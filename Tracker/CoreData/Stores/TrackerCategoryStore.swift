//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Admin on 11/12/23.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidTrackers
}

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(
        _ store: TrackerCategoryStore,
        didUpdate update: TrackerCategoryStoreUpdate
    )
}

final class TrackerCategoryStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!

    weak var delegate: TrackerCategoryStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerCategoryStoreUpdate.Move>?

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.objectID, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }

    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.category(from: $0) })
        else { return [] }
        return trackers
    }
    
    func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryCoreData.name else {
            throw TrackerCategoryStoreError.decodingErrorInvalidName
        }
        guard let trackers = try? self.trackers(from: trackerCategoryCoreData) else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        return TrackerCategory(
            name: name,
            trackers: trackers
        )
    }
    
    func trackers(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> [Tracker] {
        guard let trackers = trackerCategoryCoreData.trackers else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        return trackers.compactMap({ $0 as? Tracker })
    }
    
    func trackersForCoreCata(from category: TrackerCategory) throws -> NSSet? {
        var trackersForCoreData: [TrackerForCoreData] = []
        let trackers = category.trackers
        trackers.forEach { tracker in
            let id = tracker.id
            let name = tracker.name
            let color = UIColorValueTransformer().transformedValue(tracker.color)
            let emoji = tracker.emoji
            let schedule = DaysValueTransformer().transformedValue(tracker.schedule)
            let trackerForCoreData = TrackerForCoreData(
                id: id,
                name: name,
                color: color as? NSData ?? NSData(data: Data(count: 0)),
                emoji: emoji,
                schedule: schedule as? NSData ?? NSData(data: Data(count: 0))
                )
            trackersForCoreData.append(trackerForCoreData)
        }
        let trackersNSSet: NSSet? = NSSet(array: trackersForCoreData)
        return trackersNSSet
    }

    func addNewTracker(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        updateExistingTrackerCategory(trackerCategoryCoreData, with: trackerCategory)
        try context.save()
    }

    func updateExistingTrackerCategory(_ trackerCategoryCoreData: TrackerCategoryCoreData, with trackerCategory: TrackerCategory) {
        let category = TrackerCategory(
            name: trackerCategory.name,
            trackers: trackerCategory.trackers
        )
        trackerCategoryCoreData.name = category.name
        trackerCategoryCoreData.trackers = try? trackersForCoreCata(from: category)
    }
    
    
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerCategoryStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!,
                updatedIndexes: updatedIndexes!,
                movedIndexes: movedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
}



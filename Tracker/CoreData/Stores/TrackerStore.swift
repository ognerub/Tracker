//
//  TrackerStore.swift
//  Tracker
//
//  Created by Admin on 11/12/23.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidID
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
}

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
}

final class TrackerStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!

    weak var delegate: TrackerStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.objectID, ascending: true)
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

    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidID
        }
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        guard let color = UIColorValueTransformer().reverseTransformedValue(trackerCoreData.color)
                 else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        guard let schedule = DaysValueTransformer().reverseTransformedValue(trackerCoreData.schedule) else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        return Tracker(
            id: id,
            name: name,
            color: color as? UIColor ?? .black,
            emoji: emoji,
            schedule: schedule as? Schedule ?? Schedule(days: [WeekDay.monday]))
    }

    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        try context.save()
    }

    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = trackerCoreData.schedule
    }

    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerStoreUpdate.Move>()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
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





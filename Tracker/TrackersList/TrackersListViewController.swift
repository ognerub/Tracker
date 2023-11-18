//
//  TrakersViewController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

protocol TrackersListViewControllerDelegate: AnyObject {
    func sendCategoriesToTrackerCardViewController(_ categories: [TrackerCategory])
}

final class TrackersListViewController: UIViewController {
    
    weak var delegate: TrackersListViewControllerDelegate?
    
    //MARK: - Properties for CollectionView
    private var trackersArray: [Tracker] = []
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    
    private var selectedCategoryRow: Int?
    
    private var completedTrackers: [TrackerRecord] = []
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let cellIdentifier = "Cell"
    private let headerIdentifier = "Header"
    
    // MARK: - Properties for Empty Trackers Page
    private let emptyTrackersBackground: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(named: "YP White")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let emptyTrackersImageView: UIImageView = {
        var image = UIImage(named: "TrackersEmpty")
        var imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let emptyTrackersLabel: UILabel = {
        var label = UILabel()
        label.text = "What we will watch?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties for NavigationBar
    private let datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    private var trackersLabel: UILabel = {
        var label = UILabel()
        label.text = "Trackers"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let navBar: UINavigationBar = {
        var bar = UINavigationBar()
        bar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 182)
        return bar
    }()
    private lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    private lazy var plusButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "PlusButton") ?? UIImage(),
            target: self,
            action: #selector(didTapPlusButton)
        )
        button.tintColor = UIColor(named: "YP Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toggleAppearance(isDark: TabBarController().isDark)
        self.accessibilityLabel = "TrackersViewController"
        view.backgroundColor = .white
        addTopBar()
        collectionViewConfig()
        //reloadVisibleCategories()
        
        // MARK: - CoreData
        
        trackerStore.delegate = self
        trackersArray = trackerStore.trackers
       
        //trackerCategoryStore.delegate = self
        //visibleCategories = trackerCategoryStore.categories
    }
}

extension TrackersListViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        trackersArray = trackerStore.trackers
        collectionView.reloadData()
//        collectionView.performBatchUpdates {
//            let insertedIndexPaths = update.insertedIndexes.map { IndexPath(item: $0, section: 0) }
//            let deletedIndexPaths = update.deletedIndexes.map { IndexPath(item: $0, section: 0) }
//            let updatedIndexPaths = update.updatedIndexes.map { IndexPath(item: $0, section: 0) }
//            collectionView.insertItems(at: insertedIndexPaths)
//            collectionView.insertItems(at: deletedIndexPaths)
//            collectionView.insertItems(at: updatedIndexPaths)
//            for move in update.movedIndexes {
//                collectionView.moveItem(
//                    at: IndexPath(item: move.oldIndex, section: 0),
//                    to: IndexPath(item: move.newIndex, section: 0)
//                )
//            }
//        }
    }
}

//extension TrackersListViewController: TrackerCategoryStoreDelegate {
//
//    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
//        visibleCategories = trackerCategoryStore.categories
//        collectionView.performBatchUpdates {
//            let insertedIndexPaths = update.insertedIndexes.map { IndexPath(item: $0, section: 0) }
//            let deletedIndexPaths = update.deletedIndexes.map { IndexPath(item: $0, section: 0) }
//            let updatedIndexPaths = update.updatedIndexes.map { IndexPath(item: $0, section: 0) }
//            collectionView.insertItems(at: insertedIndexPaths)
//            collectionView.insertItems(at: deletedIndexPaths)
//            collectionView.insertItems(at: updatedIndexPaths)
//            for move in update.movedIndexes {
//                collectionView.moveItem(
//                    at: IndexPath(item: move.oldIndex, section: 0),
//                    to: IndexPath(item: move.newIndex, section: 0)
//                )
//            }
//        }
//    }
//}
    

extension TrackersListViewController {
    
    private func reloadVisibleCategories() {
        
//        let filterWeekDay = datePicker.date.dayOfWeek()
//        let filterText = (searchBar.text ?? "").lowercased()
//
//        var notEmptyCategories: [TrackerCategory] = []
//        for category in 0 ..< categories.count {
//            if categories[category].trackers.count != 0 {
//                notEmptyCategories.append(categories[category])
//            }
//        }
//
//        visibleCategories = notEmptyCategories.map { category in
//            let trackers = category.trackers.filter { tracker in
//                let textCondition = filterText.isEmpty ||
//                tracker.name.lowercased().contains(filterText)
//                let dateCondition = tracker.schedule.days.contains { WeekDay in
//                    WeekDay.rawValue == filterWeekDay
//                }
//                return textCondition && dateCondition
//            }
//            return TrackerCategory(
//                name: category.name,
//                trackers: trackers)
//        }
        collectionView.reloadData()
        showOrHideEmptyTrackersInfo()
    }
    
    private func showOrHideEmptyTrackersInfo() {
        //if visibleCategories.count == 0 {
        if trackersArray.count == 0 {
            showEmptyTrackersInfo()
        } else {
            hideEmptyTrackersInfo()
        }
    }
    
    // MARK: - Objective-C functions
    @objc
    func didTapPlusButton() {
        
        let tracker = Tracker(id: UUID(), name: "New", color: .blue
                              , emoji: "😋", schedule: Schedule(days: [WeekDay.empty,WeekDay.empty,WeekDay.empty,WeekDay.empty,WeekDay.empty,WeekDay.saturday, WeekDay.sunday]))
        try! trackerStore.addNewTracker(tracker)
        
//        let vc = TrackerTypeViewController()
//        vc.delegate = self
//        self.delegate = vc
//        self.delegate?.sendCategoriesToTrackerCardViewController(categories)
//        present(vc, animated: true)
    }
}

// MARK: - ThirdViewController Delegate
extension TrackersListViewController: TrackerCardViewControllerDelegate {
    func sendTrackerToTrackersListViewController(newTracker: Tracker, categoriesNames: [String]?, selectedCategoryRow: Int?) {
        trackersArray.append(newTracker)
        
        if let categoriesNames = categoriesNames,
           let selectedCategoryRow = selectedCategoryRow {
            /// create new array with categories for processing
            var currentCategories = self.categories
            /// current array with names
            var currentCategoriesNames: [String] = []
            /// new array with names
            var newCategoriesNames: [String] = []
            /// if current categories is not empty
            if currentCategories.count > 0 {
                /// append array with names from current categories
                for category in 0 ..< currentCategories.count {
                    currentCategoriesNames.append(currentCategories[category].name)
                }
                /// set new array equal to current array
                newCategoriesNames = currentCategoriesNames
                /// check that array contains received names
                for name in 0 ..< categoriesNames.count {
                    if !currentCategoriesNames.contains(categoriesNames[name]) {
                        /// if array not contains received names, add them to new array
                        newCategoriesNames.append(categoriesNames[name])
                    }
                }
                /// add new categories if needed
                for item in 0 ..< newCategoriesNames.count {
                    if item > (currentCategoriesNames.count-1) {
                        let category = TrackerCategory(
                            name: newCategoriesNames[item],
                            trackers: item == selectedCategoryRow ? [newTracker] : [])
                        currentCategories.append(category)
                    } else {
                        /// or append existing category with trackers
                        if item == selectedCategoryRow {
                            var trackers = currentCategories[item].trackers
                            trackers.append(newTracker)
                            let name = currentCategories[item].name
                            let category = TrackerCategory(
                                name: name,
                                trackers: trackers)
                            currentCategories.remove(at: item)
                            currentCategories.insert(category, at: item)
                        }
                    }
                }
                /// set self.categories equal to computed category
                self.categories = currentCategories
            } else {
                /// self.categories is empty, need to append with new names
                for item in 0 ..< categoriesNames.count {
                    let category = TrackerCategory(
                        name: categoriesNames[item],
                        trackers: item == selectedCategoryRow ? [newTracker] : [])
                    currentCategories.append(category)
                }
            }
            self.categories = currentCategories
        }
        
        self.selectedCategoryRow = selectedCategoryRow
        
        reloadVisibleCategories()
        dismiss(animated: true)
    }
}

extension TrackersListViewController {
    // MARK: - Date Picker
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        searchBar.text = ""
        searchBar.endEditing(true)
        reloadVisibleCategories()
    }
}

// MARK: - UISearchBarDelegate
extension TrackersListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadVisibleCategories()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideEmptyTrackersInfo()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.endEditing(true)
        reloadVisibleCategories()
    }
}

// MARK: - CollectionViewDataSource (NumberOfItemsInSection, CellForItemAt)
extension TrackersListViewController: UICollectionViewDataSource {
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return visibleCategories.count
        return 1
    }
    /// Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard visibleCategories[section].trackers.count != 0 else { return 0 }
//        return visibleCategories[section].trackers.count
        guard trackersArray.count != 0 else { return 0 }
        return trackersArray.count
    }
    
    /// Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackersListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        //let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let tracker = trackersArray[indexPath.row]
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath
        )
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDate = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDate
    }
}

extension TrackersListViewController: TrackersListCollectionViewCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        
        let isNotFutureDate: Bool = (
            Calendar.current.isDate(Date(), inSameDayAs: datePicker.date) ||
            Date().distance(to: datePicker.date) < 0
        )
        if isNotFutureDate {
            completedTrackers.append(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        } else {
            return
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - CollectionViewDelegate
extension TrackersListViewController: UICollectionViewDelegate {
    
    /// Switch between header and (footer removed)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = headerIdentifier
        default:
            id = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView else {
            return UICollectionReusableView()
        }
        guard visibleCategories.count != 0 else { return view }
        //view.titleLabel.text = "\(visibleCategories[indexPath.section].name)"
        view.titleLabel.text = "Section name"
        return view
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension TrackersListViewController: UICollectionViewDelegateFlowLayout {
    /// Set layout width and height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 5, height: 148)
    }
    /// Set layout horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    /// Set layout vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    /// Set header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: 46
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultHigh)
    }
}

// MARK: - Configure constraints
private extension TrackersListViewController {
    func collectionViewConfig() {
        /// Create collectionView with custom layout
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        /// Make VC a dataSource of collectionView, to config Cell
        collectionView.dataSource = self
        /// Register Cell
        collectionView.register(TrackersListCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        /// Make VC a delegate of collectionView, to config Header and Footer
        collectionView.delegate = self
        /// Register Header
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        /// disable multiple selection
        collectionView.allowsMultipleSelection = false
    }
    func addTopBar() {
        // NavBar
        view.addSubview(navBar)
        // DatePicker
        navBar.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: navBar.centerYAnchor, constant: -datePicker.frame.size.height/2),
            datePicker.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -16)
        ])
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        // PlusButton
        view.addSubview(plusButton)
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            plusButton.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 49),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        // TrackersLabel
        navBar.addSubview(trackersLabel)
        NSLayoutConstraint.activate([
            trackersLabel.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -53),
            trackersLabel.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16)
        ])
        // SearchBar
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        searchBar.delegate = self
    }
    func showEmptyTrackersInfo() {
        view.addSubview(emptyTrackersBackground)
        view.addSubview(emptyTrackersImageView)
        view.addSubview(emptyTrackersLabel)
        NSLayoutConstraint.activate([
            emptyTrackersBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyTrackersBackground.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            emptyTrackersBackground.widthAnchor.constraint(equalToConstant: view.frame.width),
            emptyTrackersBackground.heightAnchor.constraint(equalToConstant: view.frame.height),
            emptyTrackersImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -40),
            emptyTrackersImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
            emptyTrackersLabel.topAnchor.constraint(equalTo: emptyTrackersImageView.bottomAnchor, constant: 8),
            emptyTrackersLabel.widthAnchor.constraint(equalToConstant: 343),
            emptyTrackersLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -171.5)
        ])
    }
    func hideEmptyTrackersInfo() {
        emptyTrackersBackground.removeFromSuperview()
        emptyTrackersImageView.removeFromSuperview()
        emptyTrackersLabel.removeFromSuperview()
    }
}

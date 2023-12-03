//
//  TrakersViewController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

final class TrackersListViewController: UIViewController {
    
    // MARK: - Properties for CoreData    
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let analyticsService = AnalyticsService()
    
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
        label.text = NSLocalizedString("emptyTrackersLabel", comment: "Info text")
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
        label.text = NSLocalizedString("trackersLabel", comment: "Trackers")
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
        searchBar.placeholder = NSLocalizedString("searchBar.placeholder", comment: "SearchBar placeholder")
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
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toggleAppearance(isDark: TabBarController().isDark)
        self.accessibilityLabel = "TrackersViewController"
        view.backgroundColor = .white
        addTopBar()
        collectionViewConfig()
        
        // MARK: - CoreData
        
        trackerStore.delegate = self
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self

        reloadVisibleCategories()
        
        
    }
}

extension TrackersListViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        reloadVisibleCategories()
        // TODO: - PerformBatchUpdates
    }
}

extension TrackersListViewController: TrackerCategoryStoreDelegate {

    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        // TODO: - Categories update
    }
}

extension TrackersListViewController: TrackerRecordStoreDelegate {

    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        reloadVisibleCategories()
    }
}

extension TrackersListViewController {
    
    // MARK: - Reload
    private func reloadVisibleCategories() {
        
        completedTrackers = trackerRecordStore.completedTrackers
        
        let filterWeekDay = datePicker.date.dayOfWeek()
        let filterText = (searchBar.text ?? "").lowercased()

        
        var filteredCategories: [TrackerCategory] = []
        
        filteredCategories = trackerCategoryStore.categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.days.contains { WeekDay in
                    WeekDay.rawValue == filterWeekDay
                }
                return textCondition && dateCondition
            }
            return TrackerCategory(
                name: category.name,
                trackers: trackers)
            
        }
        
        visibleCategories = filteredCategories.filter { $0.trackers.count != 0 }
        
        collectionView.reloadData()
        showOrHideEmptyTrackersInfo()
    }
    
    private func showOrHideEmptyTrackersInfo() {
        if visibleCategories.count == 0 {
            showEmptyTrackersInfo()
        } else {
            hideEmptyTrackersInfo()
        }
    }
    
    // MARK: - Objective-C functions
    @objc
    func didTapPlusButton() {
        
//        analyticsService.report(event: "tracker_add", params: ["trackers_count" : trackerStore.trackers.count + 1])
        
        let vc = TrackerTypeViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - ThirdViewController Delegate
extension TrackersListViewController: TrackerCardViewControllerDelegate {
    func sendTrackerToTrackersListViewController(newTracker: Tracker, categoriesNames: [String]?, selectedCategoryRow: Int?) {
        try? trackerStore.addNewTracker(newTracker, selectedCategoryRow: selectedCategoryRow)
        dismiss(animated: true)
    }
}

// MARK: - TrackerEditableCardViewController Delegate
extension TrackersListViewController: TrackerEditableCardViewControllerDelegate {
    func sendEditedTrackerToTrackersListViewController(newTracker: Tracker, categoriesNames: [String]?, selectedCategoryRow: Int?) {
        try? trackerStore.deleteSelectedTracker(with: newTracker.id)
        try? trackerStore.addNewTracker(newTracker, selectedCategoryRow: selectedCategoryRow)
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
        return visibleCategories.count
        //return 1
    }
    /// Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard visibleCategories[section].trackers.count != 0 else { return 0 }
        return visibleCategories[section].trackers.count
    }
    
    /// Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackersListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
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
            try? trackerRecordStore.addNewTrackerRecord(trackerRecord)
        } else {
            print("impossible to complete for future date")
            return
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        
        completedTrackers.enumerated().forEach { (index, trackerRecord) in
            if isSameTrackerRecord(trackerRecord: trackerRecord, id: id) {
                try? trackerRecordStore.removeTrackerRecord(trackerRecord)
            }
        }
        
    }
}

// MARK: - CollectionViewDelegate
extension TrackersListViewController: UICollectionViewDelegate {

        
        /// Did selecet cell
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
    //        print("Did select cell at \(indexPath)")
    //    }
        
        /// Did deselect cell
        //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        //        //cell?.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        //        //cell?.titleLabel.backgroundColor = .blue
        //        print("Did deselect cell at \(indexPath)")
        //    }
        
        // Context menu configuration
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersListCollectionViewCell else {
            return nil
        }
        
        return UITargetedPreview(view: cell.cellBackgroundSquare)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {

        guard indexPaths.count > 0 else {
            return nil
        }
        let indexPath = indexPaths[0]
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]

        let identifier = NSString(string: "\(tracker.id)")

        let config = UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil
        ) { _ in
            
            // TODO: - Localize context menu
            
            let pin = UIAction(
                title: tracker.isPinned ? "Unpin" : "Pin",
                image: UIImage(),
                identifier: nil,
                discoverabilityTitle: nil,
                state: .off
            ) { [weak self] _ in
                
                if tracker.isPinned {
                    self?.unpinTracker(indexPath: indexPath)
                } else {
                    self?.pinTracker(indexPath: indexPath)
                }
            }

            let edit = UIAction(
                title: "Edit",
                image: UIImage(),
                identifier: nil,
                discoverabilityTitle: nil,
                state: .off
            ) { [weak self] _ in
                self?.editTracker(indexPath: indexPath)
            }
            
            let deleteAction = UIAction(title: "Delete") { [weak self] _ in
                self?.deleteTracker(indexPath: indexPath)
            }
            let attributedString = NSAttributedString(string: "Delete", attributes: [
                //NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ])
            deleteAction.setValue(attributedString, forKey: "attributedTitle")

            return UIMenu(
                title: "",
                identifier: nil,
                children: [pin, edit, deleteAction]
            )
        }
        return config
    }
    
    private func unpinTracker(indexPath: IndexPath) {
        let unpinnedFrom = visibleCategories[indexPath.section]
        let trackerToUnpin = unpinnedFrom.trackers[indexPath.row]
        let categoryName = trackerToUnpin.pinnedFrom
        let selectedCategoryRow = trackerCategoryStore.getCategoryRow(for: categoryName ?? "")
        let unpinnedTracker = Tracker(
            id: trackerToUnpin.id,
            name: trackerToUnpin.name,
            color: trackerToUnpin.color,
            emoji: trackerToUnpin.emoji,
            schedule: trackerToUnpin.schedule,
            isPinned: false,
            pinnedFrom: nil)
        try? trackerStore.deleteSelectedTracker(with: trackerToUnpin.id)
        try? trackerStore.addNewTracker(unpinnedTracker, selectedCategoryRow: selectedCategoryRow ?? 0)
    }
    
    private func pinTracker(indexPath: IndexPath) {
        
        if let pinnedCategoryRow = trackerCategoryStore.getCategoryRow(for: "Pinned") {
            savePinnedTracker(at: indexPath, pinnedCategoryRow: pinnedCategoryRow)
        } else {
            let pinnedCategory = TrackerCategory(name: "Pinned", trackers: [])
            try? trackerCategoryStore.addNewTrackerCategory(pinnedCategory)
            if let pinnedCategoryRow = trackerCategoryStore.getCategoryRow(for: "Pinned") {
                savePinnedTracker(at: indexPath, pinnedCategoryRow: pinnedCategoryRow)
            }
        }
    }
    
    private func savePinnedTracker(at indexPath: IndexPath, pinnedCategoryRow: Int) {
        let pinnedFrom = visibleCategories[indexPath.section]
        let trackerToPin = pinnedFrom.trackers[indexPath.row]
        let pinnedTracker = Tracker(
            id: trackerToPin.id,
            name: trackerToPin.name,
            color: trackerToPin.color,
            emoji: trackerToPin.emoji,
            schedule: trackerToPin.schedule,
            isPinned: true,
            pinnedFrom: pinnedFrom.name)
        try? trackerStore.deleteSelectedTracker(with: trackerToPin.id)
        try? trackerStore.addNewTracker(pinnedTracker, selectedCategoryRow: pinnedCategoryRow)
    }
    
    
    private func editTracker(indexPath: IndexPath) {
        let trackerToEdit = visibleCategories[indexPath.section].trackers[indexPath.row]
        // MARK: - uncomment if needed to return editable UI like creation
//        let isTrackerRegular: Bool = trackerToEdit.schedule.days != WeekDay.allCases.filter { $0 != WeekDay.empty } ? true : false
        let isTrackerRegular = true
        
        let selectedCategoryName = trackerStore.getSelectedTrackerCategoryName(with: trackerToEdit.id)
        let categories = trackerCategoryStore.getSortedCategories()
        let selectedCategoryRow = Int(categories.firstIndex { category in
            category.name == selectedCategoryName
        } ?? 0)
        var categoriesNames: [String] = []
        categories.forEach { category in
            categoriesNames.append(category.name)
        }
        
        let completedDays = completedTrackers.filter { $0.id == trackerToEdit.id }.count
        
        let vc = TrackerEditableCardViewController(
            regularTracker: isTrackerRegular,
            trackerID: trackerToEdit.id,
            trackerName: trackerToEdit.name,
            trackerColor: trackerToEdit.color,
            trackerEmoji: trackerToEdit.emoji,
            trackerDays: trackerToEdit.schedule.days,
            isPinned: trackerToEdit.isPinned,
            categories: categories,
            newCategoriesNames: categoriesNames,
            selectedCategoryRow: selectedCategoryRow,
            completedDays: completedDays
        )
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func deleteTracker(indexPath: IndexPath) {
        let selectedTrackerID = visibleCategories[indexPath.section].trackers[indexPath.row].id
        try? trackerStore.deleteSelectedTrackerRecords(with: selectedTrackerID)
        try? trackerStore.deleteSelectedTracker(with: selectedTrackerID)
        print("delete pressed")
    }
    
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
        view.changeTitle(title: "\(visibleCategories[indexPath.section].name)")
        return view
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension TrackersListViewController: UICollectionViewDelegateFlowLayout {
    /// Set layout width and height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2 - 5) - 16, height: 148)
    }
    /// Set layout horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    /// Set layout vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return sectionInsets
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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

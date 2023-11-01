//
//  TrakersViewController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit



final class TrackersViewController: UIViewController {
    
    /// MOCK array
    private var trackersArray: [Tracker] =
    [Tracker(id: 0, name: "Monday", color: UIColor(named: "CC Orange")!, emoji: "🍍", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["Monday", "", "", "", "", "", ""])),
     Tracker(id: 1, name: "Tuesday", color: UIColor(named: "CC Pink")!, emoji: "🥭", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "Tuesday", "", "", "", "", ""])),
     Tracker(id: 2, name: "Wednesday", color: UIColor(named: "CC Red")!, emoji: "🥑", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "", "Wednesday", "", "", "", ""])),
     Tracker(id: 3, name: "Thursday", color: UIColor(named: "CC Blue")!, emoji: "🥝", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "", "", "Thursday", "", "", ""])),
     Tracker(id: 4, name: "Friday", color: UIColor(named: "CC Green")!, emoji: "🥑", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "", "", "", "Friday", "", ""])),
     Tracker(id: 5, name: "Saturday", color: UIColor(named: "CC Red")!, emoji: "🍒", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "", "", "", "", "Saturday", ""])),
     Tracker(id: 6, name: "Sunday", color: UIColor(named: "CC Pink")!, emoji: "🥭", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "", "", "", "", "", "Sunday"])),
     Tracker(id: 7, name: "Everyday", color: UIColor(named: "CC Blue")!, emoji: "🌶️", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])),
     Tracker(id: 8, name: "Weekdays", color: UIColor(named: "CC Orange")!, emoji: "🍉", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "", ""])),
     Tracker(id: 9, name: "Weekends", color: UIColor(named: "CC Red")!, emoji: "🫐", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "", "", "", "", "Saturday", "Sunday"])),
     Tracker(id: 10, name: "Random", color: UIColor(named: "CC Purple")!, emoji: "🍏", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["Monday", "", "Wednesday", "", "Friday", "", "Sunday"])),
     Tracker(id: 11, name: "Random2", color: UIColor(named: "CC Green")!, emoji: "🧄", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "Tuesday", "", "Thursday", "", "Saturday", ""])),
     Tracker(id: 12, name: "Unregulated", color: UIColor(named: "CC Blue")!, emoji: "🍆", schedule: Schedule(date: String("2023-10-28 21:00:00 +0000").dateFromISO8601String(), days: ["", "", "", "", "", "", ""]))]
    
    //MARK: - Properties for CollectionView
    //private var trackersArray: [Tracker] = []
    private var visibleArray: [Tracker] = []
    private var firstCategory: TrackerCategory = TrackerCategory(name: "First category", trackers: [])
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
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
            with: UIImage(named: "PlusButton")!,
            target: self,
            action: #selector(didTapPlusButton)
        )
        button.tintColor = UIColor(named: "YP Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedDate: String = ""
    private var currentDate: String = ""
    
    private var collectionViewNeedsReloadData: Bool = true
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessibilityLabel = "TrackersViewController"
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMainView()
    }
    
    func setMainView() {
        addTopBar()
        collectionViewConfig()
        
        let category = TrackerCategory(
            name: "New category",
            trackers: trackersArray)
        let categories = [category]
        self.categories = categories
        
        visibleCategories = self.categories
        
        if visibleCategories[0].trackers.count > 0 {
            hideEmptyTrackersInfo()
            performCollectionViewUpdate()
        } else {
            showEmptyTrackersInfo()
        }
    }
    
    func performCollectionViewUpdate() {
        if collectionViewNeedsReloadData {
            collectionView.reloadData()
            collectionViewNeedsReloadData = false
        } else {
            let nextIndex = visibleCategories[0].trackers.count - 1
            collectionView.performBatchUpdates {
                collectionView.insertItems(at: [IndexPath(item: nextIndex, section: 0)])
            }
        }
    }
    
    // MARK: - Objective-C functions
    @objc
    func didTapPlusButton() {
        let vc = TrackerTypeViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - ThirdViewController Delegate
extension TrackersViewController: TrackerCardViewControllerDelegate {
    func didReceiveTracker(tracker: Tracker) {
        trackersArray.append(tracker)
        let category = TrackerCategory(
            name: "New category",
            trackers: trackersArray)
        let categories = [category]
        self.categories = categories
        setMainView()
        dismiss(animated: true)
    }
}

extension TrackersViewController {
    // MARK: - Date Picker
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        searchBar.text = ""
        searchBar.endEditing(true)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        selectedDate = dateFormatter.string(from: (sender.date))
        currentDate = dateFormatter.string(from: Date())
        let selectedDay: String = sender.date.dayOfWeek()
        
        hideOrShowEmptyTrackersInfoAndReload(firstIf: true, firstString: selectedDate, secondIf: true, secondString: selectedDay)
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hideOrShowEmptyTrackersInfoAndReload(firstIf: false, firstString: searchText, secondIf: false, secondString: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideEmptyTrackersInfo()
        searchBar.setShowsCancelButton(false, animated: true)
        visibleCategories = categories
        searchBar.text = ""
        searchBar.endEditing(true)
        if Calendar.current.isDate(Date(), inSameDayAs: datePicker.date) {
            collectionViewNeedsReloadData = true
            performCollectionViewUpdate()
        } else {
            let selectedDay: String = datePicker.date.dayOfWeek()
            hideOrShowEmptyTrackersInfoAndReload(firstIf: true, firstString: selectedDate, secondIf: true, secondString: selectedDay)
        }
        
    }
    
    private func hideOrShowEmptyTrackersInfoAndReload(firstIf: Bool, firstString: String, secondIf: Bool, secondString: String) {
        hideEmptyTrackersInfo()
        visibleCategories = categories
        if firstIf ? firstString == currentDate : firstString.count == 0 {
            visibleCategories = categories
        } else {
            var array: [Tracker] = []
            for item in 0..<visibleCategories[0].trackers.count {
                if secondIf ? visibleCategories[0].trackers[item].schedule.days.contains(secondString) : visibleCategories[0].trackers[item].name.contains(secondString) {
                    let tracker = categories[0].trackers[item]
                    array.append(tracker)
                }
            }
            let category = TrackerCategory(
                name: "New category", trackers: array)
            let categories = [category]
            visibleCategories = categories
        }
        collectionViewNeedsReloadData = true
        performCollectionViewUpdate()
        if visibleCategories[0].trackers.count == 0 {
            showEmptyTrackersInfo()
        }
    }
}

// MARK: - CollectionViewDataSource (NumberOfItemsInSection, CellForItemAt)
extension TrackersViewController: UICollectionViewDataSource {
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    /// Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard visibleCategories[0].trackers.count > 0 else { return 0 }
        return visibleCategories[0].trackers.count
    }
    
    /// Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.delegate = self
        
        let tracker = visibleCategories[0].trackers[indexPath.row]
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
    
    private func isTrackerCompletedToday(id: UInt) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UInt) -> Bool {
        let isSameDate = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDate
    }
}

extension TrackersViewController: CollectionViewCellDelegate {
    func completeTracker(id: UInt, at indexPath: IndexPath) {
        
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        
        let compareTwoDatesByDay = Calendar.current.compare(visibleCategories[0].trackers[indexPath.row].schedule.date, to: datePicker.date, toGranularity: .day)
        let resultOfDatesCompatison: ComparisonResult = compareTwoDatesByDay
        var isNotFutureDate: Bool = true
        switch resultOfDatesCompatison {
        case .orderedAscending:
            isNotFutureDate = false
        case .orderedSame:
            isNotFutureDate = true
        case .orderedDescending:
            isNotFutureDate = true
        default:
            isNotFutureDate = true
        }
        
        if isNotFutureDate {
            completedTrackers.append(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        } else {
            return
        }
    }
    
    func uncompleteTracker(id: UInt, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - CollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
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
    
//    /// Context menu configuration
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
//        guard indexPaths.count > 0 else {
//            return nil
//        }
//        let indexPath = indexPaths[0]
//        return UIContextMenuConfiguration(actionProvider: { actions in
//            let deleteAction = UIAction(title: "Delete") { [weak self] _ in
//                guard let newArray = self?.visibleArray else { return }
//                let newCategory = TrackerCategory(name: "New category", trackers: newArray)
//                self?.categories = [newCategory]
//                self?.deleteTracker(collectionView: collectionView, indexPath: indexPath)
//            }
//            let attributedString = NSAttributedString(string: "Delete", attributes: [
//                //NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
//                NSAttributedString.Key.foregroundColor: UIColor.red
//            ])
//            deleteAction.setValue(attributedString, forKey: "attributedTitle")
//            return UIMenu(children: [
//                UIAction(title: "Edit") { [weak self] _ in
//                    self?.editTracker(collectionView: collectionView, indexPath: indexPath)
//                },
//                deleteAction,
//            ])
//        })
//    }
//    private func deleteTracker(collectionView: UICollectionView, indexPath: IndexPath) {
//        guard visibleArray.count > 0 else { return }
//        visibleArray.remove(at: indexPath.row)
//        collectionView.performBatchUpdates {
//            collectionView.deleteItems(at: [IndexPath(item: indexPath.row, section: 0)])
//        }
//        if visibleArray.count == 0 {
//            showEmptyTrackersInfo()
//        }
//    }
//    private func editTracker(collectionView: UICollectionView, indexPath: IndexPath) {
//        // TODO: make tracker editable
//    }
    
    /// Switch between header and (footer removed)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = headerIdentifier
        default:
            id = ""
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SupplementaryView
        view.titleLabel.text = "\(categories[0].name)"
        return view
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
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
private extension TrackersViewController {
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
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
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

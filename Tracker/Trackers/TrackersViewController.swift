//
//  TrakersViewController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

protocol TrackersViewControllerDelegate: AnyObject {
    func sendTrackersArray(trackersArray: [Tracker])
}

final class TrackersViewController: UIViewController {
    
    weak var delegate: TrackersViewControllerDelegate?
    
    //MARK: - Properties for CollectionView
    private var currentDate: Date = Date()
    
    var trackersArray: [Tracker]
    
    init(trackersArray: [Tracker]) {
        self.trackersArray = trackersArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    //private let footerIdentifier = "Footer"
    
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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessibilityLabel = "TrackersViewController"
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("willAppear trackersArray is \(trackersArray)")
        addTopBar()
        collectionViewConfig()
        setStartView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("didAppear")
    }
    
    func setStartView() {
        
        if trackersArray.count > 0 {
            print("hide stub")
            hideEmptyTrackersInfo()
            addNewTrackerAndPerformBatchUpdates()
        } else {
            print("show stub")
            showEmptyTrackersInfo()
        }
    }
    
    // MARK: - Objective-C functions
    @objc
    func reloadObjC() {
        print("notice \(trackersArray)")
    }
    
    
    @objc
    func didTapPlusButton() {
        
        let vc = TrackerTypeViewController(middleArray: trackersArray)
        self.delegate = vc
        self.delegate?.sendTrackersArray(trackersArray: trackersArray)
        self.present(vc, animated: true, completion: nil)
    }
    
    func addNewTrackerAndPerformBatchUpdates() {
        if trackersArray.count >= 1 {
            print("CollectionView reloadData \(trackersArray)")
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutSubviews()
        } else {
            let nextIndex = trackersArray.count - 1
            collectionView.performBatchUpdates {
                collectionView.insertItems(at: [IndexPath(item: nextIndex, section: 0)])
        }
        }
    }
    
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let selectedDate: String = dateFormatter.string(from: (sender.date))
        print("date picker changed \(selectedDate)")
    } 
}

extension TrackersViewController: TrackerTypeViewControllerDelegate {
    func sendMiddleArray(array: [Tracker]) {
        trackersArray = array
        print("trackersArray delegate \(trackersArray)")
        
        setStartView()
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
        /// Register Footer
        //        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
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
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search bar text did change \(searchText)")
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
        guard trackersArray.count > 0 else { return 0}
        return trackersArray.count
    }
    
    /// Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        cell.cellTrackerLabel.text = trackersArray[indexPath.row].name
        cell.cellEmojiLabel.text = trackersArray[indexPath.row].emoji
        cell.cellBackgroundSquare.backgroundColor = trackersArray[indexPath.row].color
        cell.cellPlusButton.backgroundColor = trackersArray[indexPath.row].color
        return cell
    }
}

// MARK: - CollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    /// Did select cell
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
    //        //cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    //        //cell?.titleLabel.backgroundColor = .black
    //        print("Did select cell at \(indexPath)")
    //    }
    /// Did deselect cell
    //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
    //        //cell?.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    //        //cell?.titleLabel.backgroundColor = .blue
    //        print("Did deselect cell at \(indexPath)")
    //    }
    /// Context menu configuration
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        let indexPath = indexPaths[0]
        return UIContextMenuConfiguration(actionProvider: { actions in
            let deleteAction = UIAction(title: "Delete") { [weak self] _ in
                guard let newArray = self?.trackersArray else { return }
                let newCategory = TrackerCategory(name: "New category", trackers: newArray)
                self?.categories = [newCategory]
                self?.deleteTracker(collectionView: collectionView, indexPath: indexPath)
            }
            let attributedString = NSAttributedString(string: "Delete", attributes: [
                //NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ])
            deleteAction.setValue(attributedString, forKey: "attributedTitle")
            return UIMenu(children: [
                UIAction(title: "Edit") { [weak self] _ in
                    self?.editTracker(collectionView: collectionView, indexPath: indexPath)
                },
                deleteAction,
            ])
        })
    }
    private func deleteTracker(collectionView: UICollectionView, indexPath: IndexPath) {
        guard trackersArray.count > 0 else { return }
        trackersArray.remove(at: indexPath.row)
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(item: indexPath.row, section: 0)])
        }
        if trackersArray.count == 0 {
            showEmptyTrackersInfo()
        }
    }
    private func editTracker(collectionView: UICollectionView, indexPath: IndexPath) {
        // TODO: make tracker editable
    }
    /// Switch between header and footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = headerIdentifier
            //        case UICollectionView.elementKindSectionFooter:
            //            id = footerIdentifier
        default:
            id = ""
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SupplementaryView
        view.titleLabel.text = "\(firstCategory.name)"
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
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
    //    /// Set footer size
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        let indexPath = IndexPath(row: 0, section: section)
    //        let footerView = self.collectionView(
    //            collectionView,
    //            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter,
    //            at: indexPath
    //        )
    //        return footerView.systemLayoutSizeFitting(
    //            CGSize(
    //                width: collectionView.frame.width,
    //                height: UIView.layoutFittingExpandedSize.height
    //            ),
    //            withHorizontalFittingPriority: .required,
    //            verticalFittingPriority: .fittingSizeLevel)
    //    }
}

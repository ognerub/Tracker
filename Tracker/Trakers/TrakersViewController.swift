//
//  TrakersViewController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

final class TrakersViewController: UIViewController, UISearchBarDelegate {
    
    private let emptyTrakersImageView: UIImageView = {
        var image = UIImage(named: "TrakersEmpty")
        var imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyTrakersLabel: UILabel = {
       var label = UILabel()
        label.text = "What we will watch?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private var trakersLabel: UILabel = {
        var label = UILabel()
        label.text = "Trakers"
        label.font = UIFont.systemFont(ofSize: 34)
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
        let exitButton = UIButton.systemButton(
            with: UIImage(named: "PlusButton")!,
            target: self,
            action: #selector(didTapPlusButton)
        )
        exitButton.tintColor = UIColor(named: "YP Black")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessibilityLabel = "TrakersViewController"
        view.backgroundColor = .white
        addTopBar()
        //showEmptyTrakersInfo()
        collectionViewConfig()
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
        
        // SearchBar
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        searchBar.delegate = self
        
        // PlusButton
        view.addSubview(plusButton)
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            plusButton.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 49),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        // TrackersLabel
        navBar.addSubview(trakersLabel)
        NSLayoutConstraint.activate([
            trakersLabel.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -53),
            trakersLabel.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16)
            ])
    }
    
    @objc
    func didTapPlusButton() {
        print("plus button pressed")
    }
    
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate: String = dateFormatter.string(from: (sender.date))
        print("date picker changed \(selectedDate)")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search bar text did change \(searchText)")
    }
    
    func showEmptyTrakersInfo() {
        view.addSubview(emptyTrakersImageView)
        view.addSubview(emptyTrakersLabel)
        NSLayoutConstraint.activate([
            emptyTrakersImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -40),
            emptyTrakersImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
            emptyTrakersLabel.topAnchor.constraint(equalTo: emptyTrakersImageView.bottomAnchor, constant: 8),
            emptyTrakersLabel.widthAnchor.constraint(equalToConstant: 343),
            emptyTrakersLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -171.5)
        ])
    }
    
    private let letters = [
                "а", "б", "в", "г", "д", "е", "ё", "ж", "з", "и", "й", "к",
                "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц",
                "ч", "ш" , "щ", "ъ", "ы", "ь", "э", "ю", "я"
            ]
    
    private let cellIdentifier = "Cell"
    private let headerIdentifier = "Header"
    private let footerIdentifier = "Footer"
    
    func collectionViewConfig() {
        /// Create collectionView with custom layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        /// Make VC a delegate of collectionView, to config Header and Footer
        collectionView.delegate = self
        /// Register Header
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        /// Register Footer
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        /// disable multiple selection
        collectionView.allowsMultipleSelection = false
    }
}

// MARK: - CollectionViewDataSource (NumberOfItemsInSection, CellForItemAt)
extension TrakersViewController: UICollectionViewDataSource {
    /// Return number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    /// Return cell for item of collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        //cell.titleLabel.text = letters[indexPath.row]
        return cell
    }
}

// MARK: - CollectionViewDelegate
extension TrakersViewController: UICollectionViewDelegate {
    /// Did select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        //cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        //cell?.titleLabel.backgroundColor = .black
    }
    /// Did deselect cell
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        //cell?.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        //cell?.titleLabel.backgroundColor = .blue
    }
    /// Context menu configuration
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        let indexPath = indexPaths[0]
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Bold") { [weak self] _ in
                    self?.makeBold(collectionView: collectionView, indexPath: indexPath)
                },
                UIAction(title: "Italic") { [weak self] _ in
                    self?.makeItalic(collectionView: collectionView, indexPath: indexPath)
                },
            ])
        })
    }
    
    private func makeBold(collectionView: UICollectionView, indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        //cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }

    private func makeItalic(collectionView: UICollectionView, indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        //cell?.titleLabel.font = UIFont.italicSystemFont(ofSize: 17)
    }
    
    
    /// Switch between header and footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = headerIdentifier
        case UICollectionView.elementKindSectionFooter:
            id = footerIdentifier
        default:
            id = ""
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SupplementaryView
        view.titleLabel.text = "It`s \(id)"
        return view
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension TrakersViewController: UICollectionViewDelegateFlowLayout {
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
        return 10
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
    /// Set footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let footerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter,
            at: indexPath
        )
        return footerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}

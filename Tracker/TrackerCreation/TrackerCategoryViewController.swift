//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Admin on 11/6/23.
//


import UIKit

protocol TrackerCategoryViewControllerDelegate: AnyObject {
    func sendCategoriesNamesToTrackerCard(arrayWithCategoriesNames: [String], selectedCategory: Int)
}

final class TrackerCategoryViewController: UIViewController {
    
    weak var delegate: TrackerCategoryViewControllerDelegate?
    
    // MARK: - Mutable properties:
    
    private var titleBackground: UIView = {
        var background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Category"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsMultipleSelection = false
        table.isScrollEnabled = true
        table.allowsSelection = true
        
        table.separatorColor = UIColor(named: "YP LightGrey")?.withAlphaComponent(0.3)
        table.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        return table
    }()
    
    private lazy var newCategoryButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapCreateNewCategoryButton)
        )
        button.setTitle("Add new category", for: .normal)
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var cornersArray: [CACornerMask] = []
    private var alpha: [CGFloat] = []
    
    var categoriesNames: [String] {
        didSet {
            computeCornersAndAlpha()
        }
    }
    var selectedCategory: Int?
    
    var selectionArray: [CGFloat] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(array: [String], selectedCategory: Int?) {
        self.categoriesNames = array
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toggleAppearance(isDark: TabBarController().isDark)
        view.backgroundColor = UIColor(named: "YP White")
        titleConfig()
        acceptScheduleButtonConfig()
        computeCornersAndAlpha()
        tableViewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Objective-C functions
    @objc
    func didTapCreateNewCategoryButton() {
        clearTableViewSelection()
        //categoriesNames.append("New \(categoriesNames.count)")
        let vc = TrackerCategoryNameViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func computeCornersAndAlpha() {
        /// create and change selectionArray for selection of category button
        var selectionArray = self.selectionArray
        if selectionArray.count == 0 && categoriesNames.count > 0 {
            for _ in 0 ..< categoriesNames.count {
                selectionArray.append(0)
            }
        } else {
            selectionArray.append(0)
        }
        /// set selectedCategory if it is not nil
        if let selectedCategory = selectedCategory {
            selectionArray.remove(at: selectedCategory)
            selectionArray.insert(1.0, at: selectedCategory)
        }
        self.selectionArray = selectionArray
        /// switch corners of category button depending on array.count
        let allCornersArray: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let firstCellCornersArray: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let lastCellCornersArray: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        switch categoriesNames.count {
        case 0:
            alpha = [0]
            return cornersArray = []
        case 1:
            alpha = [0]
            return cornersArray = [allCornersArray]
        case 2:
            alpha = [1.0,0]
            return cornersArray = [firstCellCornersArray, lastCellCornersArray]
        default:
            var combineArray: [CACornerMask] = [firstCellCornersArray]
            var alphaArray: [CGFloat] = [1.0]
            for _ in 0 ..< (categoriesNames.count-2) {
                let emptyArray: CACornerMask = []
                combineArray.append(emptyArray)
                alphaArray.append(1.0)
            }
            combineArray.append(lastCellCornersArray)
            alphaArray.append(0)
            alpha = alphaArray
            return cornersArray = combineArray
        }
    }
    
    func clearTableViewSelection() {
        if let i = selectionArray.firstIndex(of: 1.0) {
            selectionArray[i] = 0
        }
    }
    
    func closeCategorySelection() {
        if let i = selectionArray.firstIndex(of: 1.0) {
            self.delegate?.sendCategoriesNamesToTrackerCard(arrayWithCategoriesNames: categoriesNames, selectedCategory: i)
            dismiss(animated: true, completion: { })
        }
    }
    
}

// MARK: - TrackerCategoryNameViewControllerDelegate
extension TrackerCategoryViewController: TrackerCategoryNameViewControllerDelegate {
    func sendCategoryNameToTrackerCategoryViewController(categoryName: String) {
        print("delegate sended category name: \(categoryName)")
    }
}

// MARK: - UITableViewDelegate
extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if categoriesNames.count == 0 {
            return 0
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clearTableViewSelection()
        selectionArray[indexPath.row] = 1.0
        closeCategorySelection()
    }
}

// MARK: - UITableViewDataSource
extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoriesNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCategoryTableViewCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        guard let TrackerCategoryTableViewCell = cell as? TrackerCategoryTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = TrackerCategoryTableViewCellViewModel(
            categoryView: TrackerCategoryTableViewCell.categoryView,
            categoryLabel: TrackerCategoryTableViewCell.categoryLabel,
            categoryFooterView:
                TrackerCategoryTableViewCell.categoryFooterView,
            categoryCheckMark: TrackerCategoryTableViewCell.categoryCheckMark)
        configCell(at: indexPath, cell: cellViewModel)
        return TrackerCategoryTableViewCell
    }
    func configCell(at indexPath: IndexPath, cell: TrackerCategoryTableViewCellViewModel) {
        let items = TrackerCategoryTableViewCellViewModel(
            categoryView: cell.categoryView,
            categoryLabel: cell.categoryLabel,
            categoryFooterView: cell.categoryFooterView,
            categoryCheckMark: cell.categoryCheckMark)
        items.categoryView.layer.maskedCorners = cornersArray[indexPath.row]
        items.categoryLabel.text = String(indexPath.row)
        items.categoryFooterView.alpha = alpha[indexPath.row]
        items.categoryCheckMark.alpha = selectionArray[indexPath.row]
    }
}

extension TrackerCategoryViewController {
    // MARK: - Constraints configuration
    
    func titleConfig() {
        view.addSubview(titleBackground)
        NSLayoutConstraint.activate([
            titleBackground.topAnchor.constraint(equalTo: view.topAnchor),
            titleBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackground.heightAnchor.constraint(equalToConstant: 57)
        ])
        titleBackground.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: titleBackground.bottomAnchor, constant: -14),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            titleLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/2)
        ])
    }
    
    func acceptScheduleButtonConfig() {
        view.addSubview(newCategoryButton)
        NSLayoutConstraint.activate([
            newCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            newCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func tableViewConfig() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleBackground.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: newCategoryButton.topAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerCategoryTableViewCell.self, forCellReuseIdentifier: TrackerCategoryTableViewCell.reuseIdentifier)
    }
}

//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Admin on 11/6/23.
//


import UIKit

protocol TrackerCategoryViewControllerDelegate: AnyObject {
    func sendCategories(array: [TrackerCategory])
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
            action: #selector(didTapNewCategoryButton)
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
    
    var array: [TrackerCategory] {
        didSet {
            computeCornersAndAlpha()
        }
    }
    
    var selectionArray: [CGFloat] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(array: [TrackerCategory]) {
        self.array = array
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
        tableViewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Objective-C functions
    @objc
    func didTapNewCategoryButton() {
        print("didTap NewCategory Button")
//        self.delegate?.sendCategories(array: array)
//        dismiss(animated: true, completion: { })
        array.append(TrackerCategory(name: "New one", trackers: []))
    }
    
    func computeCornersAndAlpha() {
        
        var selectionArray = self.selectionArray
        selectionArray.append(0)
        self.selectionArray = selectionArray
        
        let allCornersArray: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let firstCellCornersArray: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let lastCellCornersArray: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        switch array.count {
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
            for _ in 0 ..< (array.count-2) {
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
    
}

// MARK: - UITableViewDelegate
extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if array.count == 0 {
            return 0
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let i = selectionArray.firstIndex(of: 1.0) {
            selectionArray[i] = 0.0
        }
        selectionArray[indexPath.row] = 1.0
    }
}

// MARK: - UITableViewDataSource
extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
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
        let numbers: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        items.categoryLabel.text = String(numbers[indexPath.row])
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

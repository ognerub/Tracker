//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Admin on 11/6/23.
//


import UIKit

protocol TrackerCategoryViewControllerDelegate: AnyObject {
    func sendCategories(array: [Category])
}

final class TrackerCategoryViewController: UIViewController {
    
    weak var delegate: TrackerCategoryViewControllerDelegate?
    
    var newCategoriesArray: [Category]
    
    init(newCategoriesArray: [Category]) {
        self.newCategoriesArray = newCategoriesArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        table.isScrollEnabled = false
        table.allowsSelection = false
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
        self.delegate?.sendCategories(array: newCategoriesArray)
        dismiss(animated: true, completion: { })
    }
    
}

// MARK: - UITableViewDelegate
extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - UITableViewDataSource
extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCategoryTableViewCell.reuseIdentifier, for: indexPath)
        guard let TrackerCategoryTableViewCell = cell as? TrackerCategoryTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = TrackerCategoryTableViewCellViewModel(
            scheduleView: TrackerCategoryTableViewCell.scheduleView,
            scheduleLabel: TrackerCategoryTableViewCell.scheduleLabel,
            scheduleFooterView:
                TrackerCategoryTableViewCell.scheduleFooterView)
        configCell(at: indexPath, cell: cellViewModel)
        return TrackerCategoryTableViewCell
    }
    func configCell(at indexPath: IndexPath, cell: TrackerCategoryTableViewCellViewModel) {
        let items = TrackerCategoryTableViewCellViewModel(
            scheduleView: cell.scheduleView,
            scheduleLabel: cell.scheduleLabel,
            scheduleFooterView: cell.scheduleFooterView)
        let cornersArray: [CACornerMask] = [[.layerMinXMinYCorner, .layerMaxXMinYCorner],[],[],[],[],[],[.layerMinXMaxYCorner, .layerMaxXMaxYCorner]]
        items.scheduleView.layer.maskedCorners = cornersArray[indexPath.row]
        let daysArray: [WeekDay] = WeekDay.allCases
        items.scheduleLabel.text = daysArray[indexPath.row].rawValue
        let alpha = [1.0,1.0,1.0,1.0,1.0,1.0,0]
        items.scheduleFooterView.alpha = alpha[indexPath.row]
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

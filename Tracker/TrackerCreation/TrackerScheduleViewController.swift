//
//  TrackerScheduleViewController.swift
//  Tracker
//
//  Created by Admin on 10/19/23.
//

import UIKit

final class TrackerScheduleViewController: UIViewController{
    
    private var titleBackground: UIView = {
        var background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Schedule"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .red
        return table
    }()
    
    private lazy var acceptScheduleButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapAcceptScheduleButton)
        )
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White")
        titleConfig()
        acceptScheduleButtonConfig()
        tableViewConfig()
    }
    
    @objc
    func didTapAcceptScheduleButton() {
        print("did tap accept schedule button")
    }
    
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
        view.addSubview(acceptScheduleButton)
        NSLayoutConstraint.activate([
            acceptScheduleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            acceptScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            acceptScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            acceptScheduleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func tableViewConfig() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleBackground.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: acceptScheduleButton.topAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerScheduleTableViewCell.self, forCellReuseIdentifier: TrackerScheduleTableViewCell.reuseIdentifier)
    }
    
    @objc
    func didTapScheduleButton() {
        print("did tap schedule button")
    }
    
    @objc
    func switchChanged(sender: UISwitch!) {
        print("Switch value is \(sender.isOn)")
    }
}

extension TrackerScheduleViewController: TrackerScheduleTableViewCellDelegate {
    func TrackerScheduleTableViewCellSwitchDidChange(_ cell: TrackerScheduleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        print("Delegate did switch \(indexPath)")
    }
}

extension TrackerScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

extension TrackerScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackerScheduleTableViewCell.reuseIdentifier, for: indexPath)
        guard let TrackerScheduleTableViewCell = cell as? TrackerScheduleTableViewCell else {
            return UITableViewCell()
        }
        TrackerScheduleTableViewCell.delegate = self
        let cellViewModel = TrackerScheduleTableViewCellViewModel(
            scheduleView: TrackerScheduleTableViewCell.scheduleView,
            scheduleSwitch: TrackerScheduleTableViewCell.scheduleSwitch)
        configCell(at: indexPath, cell: cellViewModel)
        return TrackerScheduleTableViewCell
        return UITableViewCell()
    }
    
    func configCell(at: IndexPath, cell: TrackerScheduleTableViewCellViewModel) {
        
    }
    
}

protocol TrackerScheduleTableViewCellDelegate: AnyObject {
    func TrackerScheduleTableViewCellSwitchDidChange(_ cell: TrackerScheduleTableViewCell)
}

final class TrackerScheduleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TrackerScheduleTableViewCell"
    weak var delegate: TrackerScheduleTableViewCellDelegate?
    
    lazy var scheduleView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "YP Blue")?.cgColor
        return view
    }()
    
    var scheduleSwitch: UISwitch = {
        let sswitch = UISwitch()
        sswitch.setOn(false, animated: false)
        sswitch.tintColor = UIColor(named: "YP Grey")
        sswitch.onTintColor = UIColor(named: "YP Blue")
        sswitch.thumbTintColor = UIColor(named: "YP Whtite")
        sswitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControl.Event.valueChanged)
        sswitch.translatesAutoresizingMaskIntoConstraints = false
        return sswitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "YP White")
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(scheduleView)
        contentView.addSubview(scheduleSwitch)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            scheduleView.topAnchor.constraint(equalTo: topAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scheduleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scheduleView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            scheduleSwitch.topAnchor.constraint(equalTo: scheduleView.centerYAnchor, constant: -15.5),
            scheduleSwitch.trailingAnchor.constraint(equalTo: scheduleView.trailingAnchor, constant: -16),
            scheduleSwitch.heightAnchor.constraint(equalToConstant: 31),
            scheduleSwitch.widthAnchor.constraint(equalToConstant: 51)
        ])
    }
    
    @objc
    func switchChanged(sender: UISwitch!) {
        print("Switch value is \(sender.isOn)")
        delegate?.TrackerScheduleTableViewCellSwitchDidChange(self)
    }
    
}

struct TrackerScheduleTableViewCellViewModel {
    var scheduleView: UIView
    var scheduleSwitch: UISwitch
}

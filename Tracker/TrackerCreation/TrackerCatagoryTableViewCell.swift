//
//  TrackerScheduleTableViewCell.swift
//  Tracker
//
//  Created by Admin on 11/4/23.
//

import UIKit

final class TrackerCategoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TrackerCategoryTableViewCell"
    
    var scheduleView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "YP LightGrey")?.withAlphaComponent(0.3)
        return view
    }()
    
    var scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "YP Black")
        label.text = "Monday"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var scheduleFooterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "YP Grey")
        return view
    }()
    
    // MARK: - override init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "YP White")
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure constraints
    private func addSubviews() {
        addSubview(scheduleView)
        addSubview(scheduleFooterView)
        scheduleView.addSubview(scheduleLabel)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            scheduleView.topAnchor.constraint(equalTo: topAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scheduleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scheduleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 22),
            scheduleLabel.topAnchor.constraint(equalTo: scheduleView.centerYAnchor, constant: -11),
            scheduleLabel.leadingAnchor.constraint(equalTo: scheduleView.leadingAnchor, constant: 16),
            scheduleFooterView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scheduleFooterView.heightAnchor.constraint(equalToConstant: 0.5),
            scheduleFooterView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            scheduleFooterView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }
}

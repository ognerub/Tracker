//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Admin on 10/1/23.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    private let colors: [UIColor] = [
        .black, .blue, .brown,
        .cyan, .green, .orange,
        .red, .purple, .yellow
    ]
    
    let cellBackgroundSquare: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cellBackgroundRound: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellEmojiLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cellTrackerLabel: UILabel = {
       var label = UILabel()
        label.text = "Something that user printed is shown here"
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.addInterlineSpacing(spacingValue: 6)
        label.textColor = UIColor(named: "YP White")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cellPlusButton: UIButton = {
        let resizedImage = UIImage(named: "PlusButton")!.resized(to: CGSize(width: 10, height: 10))
        let button = UIButton.systemButton(
            with: resizedImage,
            target: self,
            action: #selector(didTapCellPlusButton)
        )
        button.layer.cornerRadius = 21
        button.layer.masksToBounds = true
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor(named: "YP White")?.cgColor
        button.tintColor = UIColor(named: "YP White")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    func didTapCellPlusButton() {
        print("plus cell button pressed")
    }
    
    private let cellDaysCounterLabel: UILabel = {
       var label = UILabel()
        label.text = "1 day"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "YP White")
        cellBackgroundRound.backgroundColor = UIColor(named: "YP White")
        cellBackgroundRound.alpha = 0.3
        addSubViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear style of cell after scroll!
//        if titleLabel.backgroundColor == .black {
//            titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//            titleLabel.backgroundColor = .blue
//        }
    }
    
    func addSubViews() {
        addSubview(cellBackgroundSquare)
        addSubview(cellBackgroundRound)
        addSubview(cellEmojiLabel)
        addSubview(cellTrackerLabel)
        contentView.addSubview(cellPlusButton)
        addSubview(cellDaysCounterLabel)
    }
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            cellBackgroundSquare.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            cellBackgroundSquare.heightAnchor.constraint(equalToConstant: 90),
            cellBackgroundSquare.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundSquare.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cellBackgroundRound.widthAnchor.constraint(equalToConstant: 24),
            cellBackgroundRound.heightAnchor.constraint(equalToConstant: 24),
            cellBackgroundRound.topAnchor.constraint(equalTo: cellBackgroundSquare.topAnchor, constant: 12),
            cellBackgroundRound.leadingAnchor.constraint(equalTo: cellBackgroundSquare.leadingAnchor, constant: 12),
            
            cellEmojiLabel.widthAnchor.constraint(equalToConstant: 16),
            cellEmojiLabel.leadingAnchor.constraint(equalTo: cellBackgroundRound.centerXAnchor, constant: -8),
            cellEmojiLabel.heightAnchor.constraint(equalToConstant: 22),
            cellEmojiLabel.topAnchor.constraint(equalTo: cellBackgroundRound.centerYAnchor, constant: -11),
            
            cellTrackerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cellTrackerLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - 12),
            cellTrackerLabel.topAnchor.constraint(equalTo: cellBackgroundRound.bottomAnchor, constant: 8),
            
            cellPlusButton.topAnchor.constraint(equalTo: cellBackgroundSquare.bottomAnchor, constant: 4),
            cellPlusButton.trailingAnchor.constraint(equalTo: cellBackgroundSquare.trailingAnchor, constant: -8),
            cellPlusButton.widthAnchor.constraint(equalToConstant: 42),
            cellPlusButton.heightAnchor.constraint(equalToConstant: 42),
            
            cellDaysCounterLabel.leadingAnchor.constraint(equalTo: cellBackgroundRound.leadingAnchor),
            cellDaysCounterLabel.centerYAnchor.constraint(equalTo: cellPlusButton.centerYAnchor)
        ])
    }
}

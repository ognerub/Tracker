//
//  TrackerCardCollectionViewCell.swift
//  Tracker
//
//  Created by Admin on 11/5/23.
//

import UIKit

protocol TrackerCardCollectionViewCellDelegate: AnyObject {
    func didSelectCell(at indexPath: IndexPath)
}

final class TrackerCardCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: TrackerCardCollectionViewCellDelegate?
    
    private let colors: [UIColor] = [
        .black, .blue, .brown,
        .cyan, .green, .orange,
        .red, .purple, .yellow
    ]
    
    private let cellBackgroundRound: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellEmojiLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 38)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "YP White")
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        indexPath: IndexPath,
        emojiLabel: String
    ) {
        self.cellEmojiLabel.text = emojiLabel
        self.indexPath = indexPath
        print("indexPath of cell is \(indexPath)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Configure Constraints
    func addSubviews() {
        addSubview(cellBackgroundRound)
        addSubview(cellEmojiLabel)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            cellBackgroundRound.widthAnchor.constraint(equalToConstant: 52),
            cellBackgroundRound.heightAnchor.constraint(equalToConstant: 52),
            cellBackgroundRound.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundRound.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cellEmojiLabel.widthAnchor.constraint(equalToConstant: 38),
            cellEmojiLabel.leadingAnchor.constraint(equalTo: cellBackgroundRound.centerXAnchor, constant: -19),
            cellEmojiLabel.heightAnchor.constraint(equalToConstant: 38),
            cellEmojiLabel.topAnchor.constraint(equalTo: cellBackgroundRound.centerYAnchor, constant: -19)
        ])
    }
}

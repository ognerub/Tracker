//
//  TrackerCardCollectionViewSecondCell.swift
//  Tracker
//
//  Created by Admin on 11/6/23.
//

import UIKit

final class TrackerCardCollectionViewSecondCell: UICollectionViewCell {
    
    let cellBackgroundRound: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        indexPath: IndexPath
    ) {
        self.indexPath = indexPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Configure Constraints
    func addSubviews() {
        addSubview(cellBackgroundRound)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            cellBackgroundRound.widthAnchor.constraint(equalToConstant: 52),
            cellBackgroundRound.heightAnchor.constraint(equalToConstant: 52),
            cellBackgroundRound.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundRound.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}

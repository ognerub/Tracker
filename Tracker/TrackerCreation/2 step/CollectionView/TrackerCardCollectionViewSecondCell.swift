//
//  TrackerCardCollectionViewSecondCell.swift
//  Tracker
//
//  Created by Admin on 11/6/23.
//

import UIKit

final class TrackerCardCollectionViewSecondCell: UICollectionViewCell {
    
    let cellBackgroundRectangle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellMiddleRectangle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(named: "YP White")?.cgColor
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
        indexPath: IndexPath,
        color: UIColor,
        borderWidth: CGFloat,
        alpha: CGFloat
    ) {
        self.indexPath = indexPath
        cellBackgroundRectangle.backgroundColor = color
        cellBackgroundRectangle.layer.borderColor = color.cgColor
        cellBackgroundRectangle.layer.borderWidth = borderWidth
        cellBackgroundRectangle.alpha = alpha
        cellMiddleRectangle.backgroundColor = color
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Configure Constraints
    func addSubviews() {
        addSubview(cellBackgroundRectangle)
        addSubview(cellMiddleRectangle)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            cellBackgroundRectangle.widthAnchor.constraint(equalToConstant: 52),
            cellBackgroundRectangle.heightAnchor.constraint(equalToConstant: 52),
            cellBackgroundRectangle.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundRectangle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cellMiddleRectangle.widthAnchor.constraint(equalToConstant: 46),
            cellMiddleRectangle.leadingAnchor.constraint(equalTo: cellBackgroundRectangle.centerXAnchor, constant: -23),
            cellMiddleRectangle.heightAnchor.constraint(equalToConstant: 46),
            cellMiddleRectangle.topAnchor.constraint(equalTo: cellBackgroundRectangle.centerYAnchor, constant: -23)
        ])
    }
}

//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Admin on 10/1/23.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    private var practicumLogo: UIImageView = {
        let practicumLogoImage = UIImage(named: "Logo")!
        let practicumLogoImageView = UIImageView(image: practicumLogoImage)
        practicumLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        return practicumLogoImageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP White")
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "AAA"
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        self.frame.size = CGSize(width: 100, height: 100)
        addSubViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        addSubview(practicumLogo)
        addSubview(titleLabel)
    }
    func configureConstraints() {
        NSLayoutConstraint.activate([
            practicumLogo.widthAnchor.constraint(equalToConstant: 91),
            practicumLogo.heightAnchor.constraint(equalToConstant: 94),
            practicumLogo.topAnchor.constraint(equalTo: centerYAnchor, constant: -47),
            practicumLogo.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -45.5),
            titleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

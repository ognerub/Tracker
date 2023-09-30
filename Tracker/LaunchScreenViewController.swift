//
//  LaunchScreenViewController.swift
//  Tracker
//
//  Created by Admin on 9/30/23.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    
    private var practicumLogo: UIImageView = {
        let practicumLogoImage = UIImage(named: "Logo")!
        let practicumLogoImageView = UIImageView(image: practicumLogoImage)
        practicumLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        return practicumLogoImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Blue")
        addSubViews()
        configureConstraints()
        
    }
    
    func addSubViews() {
        view.addSubview(practicumLogo)
    }
    func configureConstraints() {
        NSLayoutConstraint.activate([
            practicumLogo.widthAnchor.constraint(equalToConstant: 91),
            practicumLogo.heightAnchor.constraint(equalToConstant: 94),
            practicumLogo.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -47),
            practicumLogo.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -45.5)
        ])
        
    }
    
}

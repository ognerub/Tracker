//
//  TabBarController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let tabBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YP White")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let border: UIView = {
        let border = UIView()
        border.backgroundColor = UIColor(named: "YP Grey")
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: 0, height: 1)
        return border
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White")
//        tabBarBackgroundView.addSubview(border)
//        NSLayoutConstraint.activate([
//            border.leadingAnchor.constraint(equalTo: tabBarBackgroundView.leadingAnchor),
//            border.trailingAnchor.constraint(equalTo: tabBarBackgroundView.trailingAnchor),
//            border.heightAnchor.constraint(equalToConstant: 1),
//            border.topAnchor.constraint(equalTo: tabBarBackgroundView.topAnchor)
//        ])
//        tabBarBackgroundView.addSubview(border)
//        view.addSubview(tabBarBackgroundView)
//        NSLayoutConstraint.activate([
//            tabBarBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tabBarBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tabBarBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
//            tabBarBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
        tabBar.backgroundColor = UIColor(named: "YP White")
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1).cgColor
        tabBar.clipsToBounds = true
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let firstItem = TrakersViewController()
        let firstItemIcon = UITabBarItem(title: "Trakers", image: UIImage(named: "TabBarRecordOff"), selectedImage: UIImage(named: "TabBarRecordOn"))
        firstItem.tabBarItem = firstItemIcon
        let secondItem = StatisticsViewController()
        let secondItemIcon = UITabBarItem(title: "Statistics", image: UIImage(named: "TabBarHareOff"), selectedImage: UIImage(named: "TabBarHareOn"))
        secondItem.tabBarItem = secondItemIcon
        let controllers = [firstItem, secondItem]
        self.viewControllers = controllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "")?")
        return true
    }
    
}

//
//  TabBarController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var selectedTabBar: Int = 0
    
    var isDark = true { didSet { setNeedsStatusBarAppearanceUpdate() }}
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDark ? .darkContent : .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toggleAppearance(isDark: isDark)
        view.backgroundColor = UIColor(named: "YP White")
        tabBar.backgroundColor = UIColor(named: "YP White")
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1).cgColor
        tabBar.clipsToBounds = true
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let firstItem = TrackersListViewController()
        let firstItemIcon = UITabBarItem(title: "Trakers", image: UIImage(named: "TabBarRecordOff"), selectedImage: UIImage(named: "TabBarRecordOn"))
        firstItem.tabBarItem = firstItemIcon
        let secondItem = StatisticsViewController()
        let secondItemIcon = UITabBarItem(title: "Statistics", image: UIImage(named: "TabBarHareOff"), selectedImage: UIImage(named: "TabBarHareOn"))
        secondItem.tabBarItem = secondItemIcon
        let controllers = [firstItem, secondItem]
        viewControllers = controllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController.accessibilityLabel == "TrakersViewController" {
            selectedTabBar = 0
        } else {
            selectedTabBar = 1
        }
        
        print("Did select viewController: \(viewController.accessibilityLabel ?? "") /n selectedTabBar = \(selectedTabBar)")
    }
    
}

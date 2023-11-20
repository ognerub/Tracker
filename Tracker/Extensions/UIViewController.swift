//
//  UIViewController.swift
//  Tracker
//
//  Created by Admin on 11/6/23.
//

import UIKit

extension UIViewController {
        
    func toggleAppearance(isDark: Bool) {
        self.overrideUserInterfaceStyle = isDark ? .light : .dark
    }
}

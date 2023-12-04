//
//  UIViewController.swift
//  Tracker
//
//  Created by Admin on 12/4/23.
//

import UIKit

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }
}

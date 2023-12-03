//
//  UIColor.swift
//  Tracker
//
//  Created by Admin on 12/1/23.
//

import UIKit

extension UIColor {
    func isEqual(color: UIColor?) -> Bool {
        guard let color = color else { return false }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var targetRed: CGFloat = 0
        var targetGreen: CGFloat = 0
        var targetBlue: CGFloat = 0
        var targetAlpha: CGFloat = 0
        color.getRed(&targetRed, green: &targetGreen, blue: &targetBlue, alpha: &targetAlpha)
        
        return (
            Int((round(red*10)/10)*255.0) == Int((round(targetRed*10)/10)*255.0) &&
            Int((round(green*10)/10)*255.0) == Int((round(targetGreen*10)/10)*255.0) &&
            Int((round(blue*10)/10)*255.0) == Int((round(targetBlue*10)/10)*255.0) &&
            Int((round(alpha*10)/10)*255.0) == Int((round(targetAlpha*10)/10)*255.0)
        )
    }
}

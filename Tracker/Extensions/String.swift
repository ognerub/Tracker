//
//  String.swift
//  Tracker
//
//  Created by Admin on 10/15/23.
//

import UIKit

extension String {
    
    func attributedString(_ string: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.red
        ])
        return attributedString
    }
}


//
//  TrakersViewController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

final class TrakersViewController: UIViewController {
    
    let datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.red
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        if let navBar = navigationController?.navigationBar {
            navBar.addSubview(datePicker)
            
            NSLayoutConstraint.activate([
                datePicker.topAnchor.constraint(equalTo: navBar.topAnchor),
                datePicker.trailingAnchor.constraint(equalTo: navBar.trailingAnchor)
            ])

            let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
        }
    }
    
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate: String = dateFormatter.string(from: (sender.date))
        print("date picker changed \(selectedDate)")
    }
    
}

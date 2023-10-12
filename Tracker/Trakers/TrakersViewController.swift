//
//  TrakersViewController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

final class TrakersViewController: UIViewController, UISearchBarDelegate {
    
    private let emptyTrakersImageView: UIImageView = {
        var image = UIImage(named: "TrakersEmpty")
        var imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyTrakersLabel: UILabel = {
       var label = UILabel()
        label.text = "What we will watch?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    var trakersLabel: UILabel = {
        var label = UILabel()
        label.text = "Trakers"
        label.font = UIFont.systemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let navBar = UINavigationBar()
    
    private lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var plusButton: UIButton = {
        let exitButton = UIButton.systemButton(
            with: UIImage(named: "PlusButton")!,
            target: self,
            action: #selector(didTapPlusButton)
        )
        exitButton.tintColor = UIColor(named: "YP Black")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessibilityLabel = "TrakersViewController"
        view.backgroundColor = .white
        addTopBar()
        addSearchBar()
        showEmptyTrakersInfo()
    }
    
    func addTopBar() {
        
        // NavBar
        view.addSubview(navBar)
        navBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 182)
        
        // DatePicker
        navBar.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: navBar.centerYAnchor, constant: -datePicker.frame.size.height/2),
            datePicker.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -16)
        ])
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        // SearchBar
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        searchBar.delegate = self
        
        // PlusButton
        view.addSubview(plusButton)
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            plusButton.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 49),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        // TrackersLabel
        navBar.addSubview(trakersLabel)
        NSLayoutConstraint.activate([
            trakersLabel.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -53),
            trakersLabel.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16)
            ])
    }
    
    @objc
    func didTapPlusButton() {
        print("plus button pressed")
    }
    
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate: String = dateFormatter.string(from: (sender.date))
        print("date picker changed \(selectedDate)")
    }
    
    func addSearchBar() {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search bar text did change \(searchText)")
    }
    
    func showEmptyTrakersInfo() {
        view.addSubview(emptyTrakersImageView)
        view.addSubview(emptyTrakersLabel)
        NSLayoutConstraint.activate([
            emptyTrakersImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -40),
            emptyTrakersImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
            emptyTrakersLabel.topAnchor.constraint(equalTo: emptyTrakersImageView.bottomAnchor, constant: 8),
            emptyTrakersLabel.widthAnchor.constraint(equalToConstant: 343),
            emptyTrakersLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -171.5)
        ])
    }
    
}

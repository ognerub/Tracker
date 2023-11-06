//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Admin on 10/10/23.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let emptyStatisticsImageView: UIImageView = {
        var image = UIImage(named: "StatisticsEmpty")
        var imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStatisticsLabel: UILabel = {
       var label = UILabel()
        label.text = "Nothing to analize"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let navBar: UINavigationBar = {
        var bar = UINavigationBar()
        bar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 182)
        return bar
    }()
    
    var statisticsLabel: UILabel = {
        var label = UILabel()
        label.text = "Statistics"
        label.font = UIFont.systemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessibilityLabel = "StatisticsViewController"
        
        showEmptyStatisticsInfo()
        
        // NavBar
        view.addSubview(navBar)
        
        // StatisticsLabel
        navBar.addSubview(statisticsLabel)
        NSLayoutConstraint.activate([
            statisticsLabel.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -53),
            statisticsLabel.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16)
            ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func showEmptyStatisticsInfo() {
        view.addSubview(emptyStatisticsLabel)
        view.addSubview(emptyStatisticsImageView)
        NSLayoutConstraint.activate([
            emptyStatisticsImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -40),
            emptyStatisticsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
            emptyStatisticsLabel.topAnchor.constraint(equalTo: emptyStatisticsImageView.bottomAnchor, constant: 8),
            emptyStatisticsLabel.widthAnchor.constraint(equalToConstant: 343),
            emptyStatisticsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -171.5)
        ])
    }
    
}

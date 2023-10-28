//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Admin on 10/15/23.
//

import UIKit

protocol TrackerTypeViewControllerDelegate: AnyObject {
    func sendMiddleArray(array: [Tracker])
}

// MARK: - TrackerTypeViewController
final class TrackerTypeViewController: UIViewController {
    
    weak var delegate: TrackerTypeViewControllerDelegate?
    
    var middleArray: [Tracker]
    
    init(middleArray: [Tracker]) {
        self.middleArray = middleArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Mutable properties
    private var titleBackground: UIView = {
        var background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Creation of tracker"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var regularTrackerButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapRegularTrackerButton)
        )
        button.setTitle("Regular", for: .normal)
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var unregularTrackerButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapUnregularTrackerButton)
        )
        button.setTitle("Unregular", for: .normal)
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White")
        titleConfig()
        stackViewConfig()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissObjC), name: NSNotification.Name(rawValue: "DismissAfterPresenting"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear \(middleArray)")
        let vc = TrackersViewController(trackersArray: middleArray)
        vc.beginAppearanceTransition(true, animated: false)
    }
    
    // MARK: - Objective-C functions
    
    @objc
    func dismissObjC() {
        self.dismiss(animated: true)
    }
    
    @objc
    func didTapRegularTrackerButton() {
        let vc = TrackerCardViewController(newTrackersArray: middleArray)
        self.delegate = vc
        self.delegate?.sendMiddleArray(array: middleArray)
        vc.titleLabel.text  = "New habit"
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    func didTapUnregularTrackerButton() {
        let vc = TrackerCardViewController(newTrackersArray: middleArray)
        self.delegate = vc
        self.delegate?.sendMiddleArray(array: middleArray)
        vc.titleLabel.text  = "New unregular tracker"
        self.present(vc, animated: true, completion: nil)
    }
}

extension TrackerTypeViewController: TrackersViewControllerDelegate {
    func sendTrackersArray(trackersArray: [Tracker]) {
        middleArray = trackersArray
    }
}

extension TrackerTypeViewController: TrackerCardViewControllerDelegate {
    func sendNewTrackersArray(newTrackersArray: [Tracker]) {
        middleArray = newTrackersArray
        
        print("middlearray delegate \(middleArray)")
        
        let vc = TrackersViewController(trackersArray: middleArray)
        self.delegate = vc
        self.delegate?.sendMiddleArray(array: self.middleArray)
        
    }
}

// MARK: - Constraints configuration
extension TrackerTypeViewController {
    func titleConfig() {
        view.addSubview(titleBackground)
        NSLayoutConstraint.activate([
            titleBackground.topAnchor.constraint(equalTo: view.topAnchor),
            titleBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackground.heightAnchor.constraint(equalToConstant: 57)
        ])
        titleBackground.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: titleBackground.bottomAnchor, constant: -14),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            titleLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/2)
        ])
    }
    
    func stackViewConfig() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -68),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 136)
        ])
        stackView.addArrangedSubview(regularTrackerButton)
        stackView.addArrangedSubview(unregularTrackerButton)
    }
}





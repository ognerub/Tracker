//
//  TrackerCardViewController.swift
//  Tracker
//
//  Created by Admin on 10/15/23.
//

import UIKit

protocol TrackerCardViewControllerDelegate: AnyObject {
    func didReceiveTracker(tracker: Tracker)
}

// MARK: - TrackerCardViewController
final class TrackerCardViewController: UIViewController {
    
    weak var delegate: TrackerCardViewControllerDelegate?
    
    private let emojies = [
        "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒",
        "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️",
        "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄",
    ]
    
    private let colors: [UIColor] = [
        UIColor(named: "CC Blue")!,
        UIColor(named: "CC Green")!,
        UIColor(named: "CC Orange")!,
        UIColor(named: "CC Pink")!,
        UIColor(named: "CC Purple")!,
        UIColor(named: "CC Red")!
    ]
    
    private var newTrackerIdArray: [Int] = []
    private var newTrackerName: String = ""
    private var newTrackerColor: UIColor = .clear
    private var newTrackerEmoji: String = ""
    private var newTrackerDate: Date = Date()
    private var newTrackerDays: [String] = ["", "", "", "", "", "", ""]
    
    // MARK: - Mutable properties
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var titleBackground: UIView = {
        var background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    private var textField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "YP LightGrey")
        textField.clearButtonMode = .whileEditing
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        return textField
    }()
    
    private var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapCategoryButton)
        )
        button.setTitle("Category", for: .normal)
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.backgroundColor = UIColor(named: "YP LightGrey")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 26, left: 16, bottom: 26, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scheduleButtonTitle = "Schedule"
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapScheduleButton)
        )
        button.setTitle(scheduleButtonTitle, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitleColor(UIColor(named: "YP Grey"), for: .normal)
        button.backgroundColor = UIColor(named: "YP LightGrey")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 26, left: 16, bottom: 26, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var categoryButtonArrowImageView: UIImageView = {
        let image = UIImage(named: "ArrowRight")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var scheduleButtonArrowImageView: UIImageView = {
        let image = UIImage(named: "ArrowRight")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var buttonBottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YP Grey")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapCancelButton)
        )
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(named: "YP Red"), for: .normal)
        button.backgroundColor = UIColor(named: "YP White")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapCreateButton)
        )
        button.setTitle("Create", for: .normal)
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Grey")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White")
        titleConfig()
        textFieldConfig()
        horizontalStackViewConfig()
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if titleLabel.text != "New habit" {
            verticalStackView.removeFromSuperview()
            buttonBottomDivider.removeFromSuperview()
            categoryButtonConfig()
        } else {
            categoryButton.removeFromSuperview()
            verticalStackViewConfig()
            scheduleButtonTitleTextConfig()
        }
    }
    
    // MARK: - CreateNewTracker
    func createNewTracker() -> Tracker {
        let newTrackerId = UUID()
        newTrackerIdArray.append(0)
        newTrackerEmoji = emojies.randomElement()!
        newTrackerColor = colors.randomElement()!
        var schedule = Schedule(
            date: newTrackerDate.onlyDate ?? newTrackerDate,
            days: newTrackerDays)
        if titleLabel.text != "New habit" {
            let unregularSchedule = Schedule(
                date: schedule.date,
                days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
            schedule = unregularSchedule
        }
        let newTracker: Tracker = Tracker(
            id: newTrackerId,
            name: newTrackerName,
            color: newTrackerColor,
            emoji: newTrackerEmoji,
            schedule: schedule)
        return newTracker
    }
    
    func scheduleButtonTitleTextConfig() {
        
        var scheduleButtonTitleText: String = ""
        switch newTrackerDays {
        case ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]:
            scheduleButtonTitleText = "\(scheduleButtonTitle) \n Everyday"
        case ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "", ""]:
            scheduleButtonTitleText = "\(scheduleButtonTitle) \n Weekdays"
        case ["", "", "", "", "", "Saturday", "Sunday"]:
            scheduleButtonTitleText = "\(scheduleButtonTitle) \n Weekends"
        case ["", "", "", "", "", "", ""]:
            scheduleButtonTitleText = scheduleButtonTitle
        default:
            let filteredAndShuffledArray = newTrackerDays.filter({ $0 != "" })
            let prefixedArray = filteredAndShuffledArray.map { $0.prefix(3) }
            let joinedString = prefixedArray.joined(separator: ", ")
            scheduleButtonTitleText = "\(scheduleButtonTitle) \n \(joinedString)"
        }
        let mutableString = NSMutableAttributedString(string: scheduleButtonTitleText)
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "YP Black")!, range: NSRange(location: 0, length: scheduleButtonTitle.count))
        scheduleButton.setAttributedTitle(mutableString, for: .normal)
    }
    
    // MARK: - Objective-C functions
    
    @objc
    func didTapCategoryButton() {
        print("did tap category button")
    }
    
    @objc
    func didTapScheduleButton() {
        let vc = TrackerScheduleViewController(newNumbersArray: newTrackerDays)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    func didTapCreateButton() {
        let newTracker = createNewTracker()
        self.delegate?.didReceiveTracker(tracker: newTracker)
    }
}

// MARK: - TrackerScheduleViewControllerDelegate
extension TrackerCardViewController: TrackerScheduleViewControllerDelegate {
    func sendArray(array: [String]) {
        newTrackerDays = array
        scheduleButtonTitleTextConfig()
    }
}

// MARK: - UITextFieldDelegate
extension TrackerCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        guard let updatedString = updatedString else { return false }
        newTrackerName = updatedString
        createButtonIsActive(newTrackerName.count > 0)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        createButtonIsActive(false)
        return true
    }
    
    func createButtonIsActive(_ bool: Bool) {
        if bool {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "YP Black")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "YP Grey")
        }
    }
}

// MARK: - Constraints configuration
extension TrackerCardViewController {
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
    
    func textFieldConfig() {
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleBackground.bottomAnchor, constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func categoryButtonConfig() {
        view.addSubview(categoryButton)
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        categoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func verticalStackViewConfig() {
        view.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            verticalStackView.heightAnchor.constraint(equalToConstant: 150)
        ])
        verticalStackView.addArrangedSubview(categoryButton)
        verticalStackView.addArrangedSubview(scheduleButton)
        
        categoryButton.addSubview(categoryButtonArrowImageView)
        categoryButton.addSubview(buttonBottomDivider)
        NSLayoutConstraint.activate([
            categoryButtonArrowImageView.topAnchor.constraint(equalTo: categoryButton.centerYAnchor, constant: -12),
            categoryButtonArrowImageView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            categoryButtonArrowImageView.heightAnchor.constraint(equalToConstant: 24),
            categoryButtonArrowImageView.widthAnchor.constraint(equalToConstant: 24),
            
            buttonBottomDivider.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            buttonBottomDivider.heightAnchor.constraint(equalToConstant: 1),
            buttonBottomDivider.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            buttonBottomDivider.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16)
        ])
        categoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        scheduleButton.addSubview(scheduleButtonArrowImageView)
        NSLayoutConstraint.activate([
            scheduleButtonArrowImageView.topAnchor.constraint(equalTo: scheduleButton.centerYAnchor, constant: -12),
            scheduleButtonArrowImageView.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
            scheduleButtonArrowImageView.heightAnchor.constraint(equalToConstant: 24),
            scheduleButtonArrowImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func horizontalStackViewConfig() {
        view.addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        horizontalStackView.addArrangedSubview(cancelButton)
        horizontalStackView.addArrangedSubview(createButton)
    }
}

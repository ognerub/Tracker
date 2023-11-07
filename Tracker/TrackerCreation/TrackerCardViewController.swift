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
    
    private let scheduleButtonTitle = "Schedule"
    private let newHabit = "New habit"
    
    // MARK: - CollectionView properties
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let cellIdentifier = "Cell"
    private let secondCellIdentifier = "SecondCell"
    private let headerIdentifier = "Header"
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = contentSize
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contentSize
        return view
    }()
    
    private lazy var contentSize: CGSize = CGSize(width: view.frame.width, height: titleLabel.text == newHabit ? 781 : 706)
    
    private var activeSection: Int?
    private var previousSection: Int?
    
    private let emojies = [
        "🙂","😻","🌺","🐶","❤️","😱",
        "😇","😡","🥶","🤔","🙌","🍔",
        "🥦","🏓","🥇","🎸","🏝","😪"
    ]
    private var emojieSelectedAt: Int?
    private var previousEmojiWas: Int?
    
    private let colors: [UIColor] = [
        UIColor(named: "CC Red") ?? .red,
        UIColor(named: "CC Orange") ?? .orange,
        UIColor(named: "CC Blue") ?? .blue,
        UIColor(named: "CC Purple") ?? .purple,
        UIColor(named: "CC Green") ?? .green,
        UIColor(named: "CC Pink") ?? .systemPink,
        UIColor(named: "CC SoftPink") ?? . systemPink,
        UIColor(named: "CC LightBlue") ?? .blue,
        UIColor(named: "CC LightGreen") ?? .green,
        UIColor(named: "CC DarkBlue") ?? .blue,
        UIColor(named: "CC DarkOrange") ?? .orange,
        UIColor(named: "CC Light Pink") ?? .systemPink,
        UIColor(named: "CC LightBrown") ?? .brown,
        UIColor(named: "CC MiddleBlue") ?? .blue,
        UIColor(named: "CC MiddlePurple") ?? .purple,
        UIColor(named: "CC DarkPink") ?? .systemPink,
        UIColor(named: "CC LightPurple") ?? .purple,
        UIColor(named: "CC MiddleGreen") ?? .green
    ]
    private var colorSelectedAt: Int?
    private var previousColorWas: Int?
    
    private var newTrackerIdArray: [Int] = []
    private var newTrackerName: String = ""
    private var newTrackerColor: UIColor = .clear
    private var newTrackerEmoji: String = ""
    private var newTrackerDate: Date = Date()
    private var newTrackerDays: [WeekDay] = [.empty, .empty, .empty, .empty, .empty, .empty, .empty]
    
    // MARK: - Mutable properties
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New habit"
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
        textField.backgroundColor = UIColor(named: "YP LightGrey")?.withAlphaComponent(0.3)
        textField.clearButtonMode = .whileEditing
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.addDoneButtonOnKeyboard()
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
        button.backgroundColor = UIColor(named: "YP LightGrey")?.withAlphaComponent(0.3)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 26, left: 16, bottom: 26, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapScheduleButton)
        )
        button.setTitle(scheduleButtonTitle, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor(named: "YP Grey"), for: .normal)
        button.backgroundColor = UIColor(named: "YP LightGrey")?.withAlphaComponent(0.3)
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
    
    // MARK: - Category properties
    
    private var trackerCategories: [TrackerCategory]?
    private var selectedCategory: Int?
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toggleAppearance(isDark: TabBarController().isDark)
        view.backgroundColor = UIColor(named: "YP White")
        titleConfig()
        horizontalStackViewConfig()
        scrollViewConfig()
        textFieldConfig()
        textField.delegate = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if titleLabel.text != newHabit {
            verticalStackView.removeFromSuperview()
            buttonBottomDivider.removeFromSuperview()
            categoryButtonConfig()
            
            collectionViewConfig()
        } else {
            categoryButton.removeFromSuperview()
            verticalStackViewConfig()
            scheduleButtonTitleTextConfig()
            contentSize = CGSize(width: view.frame.width, height: 781)
            collectionViewConfig()
        }
    }
}

extension TrackerCardViewController {
    // MARK: - CreateNewTracker
    private func createNewTracker() -> Tracker {
        let newTrackerId = UUID()
        newTrackerIdArray.append(0)
        if let emojieSelectedAt = emojieSelectedAt {
            newTrackerEmoji = emojies[emojieSelectedAt]
        } else {
            newTrackerEmoji = emojies.randomElement() ?? "X"
        }
        
        if let colorSelectedAt = colorSelectedAt {
            newTrackerColor = colors[colorSelectedAt]
        } else {
            newTrackerColor = colors.randomElement() ?? .black
        }
            var schedule = Schedule(
                days: newTrackerDays)
            if titleLabel.text != newHabit {
                let unregularSchedule = Schedule(
                    days: WeekDay.allCases.filter { $0 != WeekDay.empty })
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
    
    private func scheduleButtonTitleTextConfig() {
        
        var stringArray: [String] = []
        for item in 0..<newTrackerDays.count {
            let value = newTrackerDays[item].rawValue
            stringArray.append(value)
        }
        
        let weekEnds: [WeekDay] = [.empty, .empty, .empty, .empty, .empty, .saturday,.sunday]
        let weekDays: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .empty, .empty]
        let empty: [WeekDay] = [.empty, .empty, .empty, .empty, .empty, .empty, .empty]
        
        var scheduleButtonTitleText: String = ""
        switch newTrackerDays {
        case WeekDay.allCases:
            scheduleButtonTitleText = "\(scheduleButtonTitle)\n Everyday"
        case weekDays:
            scheduleButtonTitleText = "\(scheduleButtonTitle)\n Weekdays"
        case weekEnds:
            scheduleButtonTitleText = "\(scheduleButtonTitle)\n Weekends"
        case empty:
            scheduleButtonTitleText = scheduleButtonTitle
        default:
            let filteredAndShuffledArray = stringArray.filter({ $0 != "" })
            let prefixedArray = filteredAndShuffledArray.map { $0.prefix(3) }
            let joinedString = prefixedArray.joined(separator: ", ")
            scheduleButtonTitleText = "\(scheduleButtonTitle)\n\(joinedString)"
        }
        let mutableString = NSMutableAttributedString(string: scheduleButtonTitleText)
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "YP Black") ?? .black, range: NSRange(location: 0, length: scheduleButtonTitle.count))
        scheduleButton.setAttributedTitle(mutableString, for: .normal)
    }
    
    // MARK: - Objective-C functions
    
    @objc
    func didTapCategoryButton() {
        let vc = TrackerCategoryViewController(array: trackerCategories ?? [], selectedCategory: selectedCategory ?? nil)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    func didTapScheduleButton() {
        let vc = TrackerScheduleViewController(newWeekDaysNamesArray: newTrackerDays)
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

// MARK: - TrackerSchedule Delegate
extension TrackerCardViewController: TrackerScheduleViewControllerDelegate {
    func sendArray(array: [WeekDay]) {
        newTrackerDays = array
        scheduleButtonTitleTextConfig()
        createButtonIsActive(newTrackerName.count > 0)
    }
}

// MARK: - TrackerCard Delegate
extension TrackerCardViewController: TrackerCategoryViewControllerDelegate {
    func sendCategories(array: [TrackerCategory], selectedCategory: Int) {
        self.trackerCategories = array
        self.selectedCategory = selectedCategory
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
        let empty: [WeekDay] = [.empty, .empty, .empty, .empty, .empty, .empty, .empty]
        if bool && newTrackerDays != empty || titleLabel.text != newHabit {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "YP Black")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "YP Grey")
        }
    }
}

// MARK: - CollectionViewDataSource
extension TrackerCardViewController: UICollectionViewDataSource {
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    /// Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    
    /// Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackerCardCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(
                indexPath: indexPath,
                emojiLabel: emojies[indexPath.row],
                backgroundColor: UIColor(named: "YP White") ?? .white
            )
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secondCellIdentifier, for: indexPath) as? TrackerCardCollectionViewSecondCell else {
                return UICollectionViewCell()
            }
            cell.configure(
                indexPath: indexPath,
                color: colors[indexPath.row],
                borderWidth: 0,
                alpha: 0
            )
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension TrackerCardViewController: UICollectionViewDelegate {
    
    /// Did selecet cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCardCollectionViewCell else {
                assertionFailure("No cell while didSelectItemAt")
                return
            }
            if emojieSelectedAt == nil {
                previousEmojiWas = indexPath.row
                emojieSelectedAt = indexPath.row
            } else {
                previousEmojiWas = emojieSelectedAt
                emojieSelectedAt = indexPath.row
                if previousEmojiWas != emojieSelectedAt {
                    guard let previousEmojiWas = previousEmojiWas else { return }
                    let previousIndexPath = IndexPath(row: previousEmojiWas, section: 0)
                    collectionView.reloadItems(at: [previousIndexPath])
                }
            }
            newTrackerEmoji = emojies[indexPath.row]
            cell.cellBackgroundRound.backgroundColor = UIColor(named: "YP LightGrey") ?? .gray
            
        } else {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCardCollectionViewSecondCell else {
                assertionFailure("No cell while didSelectItemAt")
                return
            }
            
            if colorSelectedAt == nil {
                previousColorWas = indexPath.row
                colorSelectedAt = indexPath.row
            } else {
                previousColorWas = colorSelectedAt
                colorSelectedAt = indexPath.row
                if previousColorWas != colorSelectedAt {
                    guard let previousColorWas = previousColorWas else { return }
                    let previousIndexPath = IndexPath(row: previousColorWas, section: 1)
                    collectionView.reloadItems(at: [previousIndexPath])
                }
            }
            newTrackerColor = colors[indexPath.row]
            cell.cellBackgroundRectangle.layer.borderWidth = 3
            cell.cellBackgroundRectangle.alpha = 0.3
        }
    }
    
    /// Switch between header and (footer removed)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = headerIdentifier
        default:
            id = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView else {
            return UICollectionReusableView()
        }
        view.titleLabel.text = indexPath.section == 0 ? "Emoji" : "Color"
        return view
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension TrackerCardViewController: UICollectionViewDelegateFlowLayout {
    /// Set layout width and height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 6 - 5, height: 52)
    }
    /// Set layout horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    /// Set layout vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    /// Set header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: 81
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .required)
    }
}

// MARK: - Constraints configuration
private extension TrackerCardViewController {
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
    
    func scrollViewConfig() {
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleBackground.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor)
        ])
        
        scrollView.addSubview(contentView)
    }
    
    func textFieldConfig() {
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32)
        ])
    }
    
    func categoryButtonConfig() {
        contentView.addSubview(categoryButton)
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            categoryButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        categoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func verticalStackViewConfig() {
        contentView.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
            buttonBottomDivider.heightAnchor.constraint(equalToConstant: 0.5),
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
    
    // MARK: - CollectionView configure
    func collectionViewConfig() {
        let bottomAnchorItem = titleLabel.text != newHabit ? categoryButton : verticalStackView
        /// Create collectionView with custom layout
        scrollView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: bottomAnchorItem.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        /// Make VC a dataSource of collectionView, to config Cell
        collectionView.dataSource = self
        /// Register Cells
        collectionView.register(TrackerCardCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TrackerCardCollectionViewSecondCell.self, forCellWithReuseIdentifier: secondCellIdentifier)
        /// Disable scroll
        collectionView.isScrollEnabled = false
        /// Make VC a delegate of collectionView, to config Header and Footer
        collectionView.delegate = self
        /// Register Header
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        /// disable multiple selection
        collectionView.allowsMultipleSelection = false
    }
}

//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Admin on 11/22/23.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private let userDefaults: UserDefaults = .standard
    
    private var firstPage: UIViewController = {
        let page = UIViewController()
        let imageView = UIImageView(image: UIImage(named: "On First"))
        page.view.addSubview(imageView)
        return page
    }()
    
    private var secondPage: UIViewController = {
        let page = UIViewController()
        let imageView = UIImageView(image: UIImage(named: "On Second"))
        page.view.addSubview(imageView)
        return page
    }()
    
    private lazy var pages: [UIViewController] = {
        return [firstPage, secondPage]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapActionButton(sender: ))
        )
        button.setTitle(NSLocalizedString("actionButton.title", comment: "Action button title"), for: .normal)
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var practicumLogo: UIImageView = {
        let image = UIImage(named: "Logo")
        let logo = UIImageView(image: image)
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isDark: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        configConstraints()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        switchMainTitleText()
        
        setColors()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setColors()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private func setColors() {
        if traitCollection.userInterfaceStyle == .light {
            actionButton.backgroundColor = UIColor(named: "YP Black")
            actionButton.setTitleColor(UIColor(named: "YP White"), for: .normal)
            mainLabel.textColor = UIColor(named: "YP White")
            pageControl.currentPageIndicatorTintColor = UIColor(named: "YP Black")
            pageControl.pageIndicatorTintColor = UIColor(named: "YP Black")?.withAlphaComponent(0.3)
        } else {
            actionButton.backgroundColor = UIColor(named: "YP White")
            actionButton.setTitleColor(UIColor(named: "YP Black"), for: .normal)
            mainLabel.textColor = UIColor(named: "YP Black")
            pageControl.currentPageIndicatorTintColor = UIColor(named: "YP White")
            pageControl.pageIndicatorTintColor = UIColor(named: "YP White")?.withAlphaComponent(0.3)
            
        }
    }
    
    private func switchMainTitleText() {
        if pageControl.currentPage == 0 {
            mainLabel.text = NSLocalizedString("mainLabel.text.first", comment: "First info text for onboarding")
        } else {
            mainLabel.text = NSLocalizedString("mainLabel.text.second", comment: "Second info text for onboarding")
        }
    }
    
    // MARK: - Objective-C functions
    @objc
    func didTapActionButton(sender: UIButton) {
        userDefaults.isNotFirstRun = true
        setTabBarControllerAsRoot()
    }
    
    private func setTabBarControllerAsRoot() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration of switchToTabBarController") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
        
        switchMainTitleText()
    }
}

// MARK: - Configure constraints
extension OnboardingViewController {
    private func configConstraints() {
        
        view.addSubview(practicumLogo)
        NSLayoutConstraint.activate([
            practicumLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            practicumLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            practicumLogo.heightAnchor.constraint(equalToConstant: 94),
            practicumLogo.widthAnchor.constraint(equalToConstant: 91)
        ])
        
        view.addSubview(mainLabel)
        view.addSubview(pageControl)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainLabel.topAnchor.constraint(equalTo: practicumLogo.bottomAnchor, constant: 25),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}


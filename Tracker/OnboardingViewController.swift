//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Admin on 11/22/23.
//

import UIKit

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var firstPage: UIViewController = {
        let page = UIViewController()
        let imageView = UIImageView(image: UIImage(named: "On First"))
        page.view.addSubview(imageView)
        page.view.contentMode = .scaleToFill
        return page
    }()
    
    private var secondPage: UIViewController = {
        let page = UIViewController()
        let imageView = UIImageView(image: UIImage(named: "On Second"))
        page.view.addSubview(imageView)
        page.view.contentMode = .scaleToFill
        return page
    }()

    private lazy var pages: [UIViewController] = {
        return [firstPage, secondPage]
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = UIColor(named: "YP Black")
        pageControl.pageIndicatorTintColor = UIColor(named: "YP Black")?.withAlphaComponent(0.3)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapActionButton)
        )
        button.setTitle("Wow, amazing technologies!", for: .normal)
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "YP Black")
        label.text = "Track only what \n you want!"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }

        view.addSubview(mainLabel)
        view.addSubview(pageControl)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func didTapActionButton() {
        print("Wow button pressed")
    }

    // MARK: - UIPageViewControllerDataSource

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

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
        
        
        if pageControl.currentPage == 0 {
            mainLabel.text = "Track only what \n you want!"
        } else {
            mainLabel.text = "Even if it`s not \n liters of water and yoga!"
        }
    }
}


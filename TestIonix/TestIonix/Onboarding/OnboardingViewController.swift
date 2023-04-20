//
//  OnboardingViewController.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import UIKit

class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private lazy var orderedViewControllers: [UIViewController] = {
        let cameraVC = CameraViewController()
        let pushNotificationVC = PushNotificationsViewController()
        let locationVC = LocationViewController()
        
        cameraVC.onCancelTapped = { [weak self] in
            self?.dismissOnboardingAndShowHome()
        }
        pushNotificationVC.onCancelTapped = { [weak self] in
            self?.dismissOnboardingAndShowHome()
        }
        locationVC.onCancelTapped = { [weak self] in
            self?.dismissOnboardingAndShowHome()
        }
        
        return [cameraVC, pushNotificationVC, locationVC]
    }()
    
    private func dismissOnboardingAndShowHome() {
        let homeViewController = HomeViewController()
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = homeViewController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    private var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        // Disable the default UIPageControl
        for view in view.subviews {
            if view is UIPageControl {
                view.isHidden = true
            }
        }
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        configurePageControl()
    }
    
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    // MARK: - UIPageViewControllerDelegate

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentViewController = pageViewController.viewControllers?.first,
           let index = orderedViewControllers.firstIndex(of: currentViewController) {
            pageControl.currentPage = index
        }
    }
    
    // MARK: - PageControl

    private func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
    }
}

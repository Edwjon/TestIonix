//
//  TestIonixTests.swift
//  TestIonixTests
//
//  Created by Edward Pizzurro on 4/22/23.
//

import XCTest
@testable import TestIonix

final class TestIonixTests: XCTestCase {
    
    var homeViewController: HomeViewController!
    var onboardingViewController: TestableOnboardingViewController!
    var cameraViewController: CameraViewController!
    var pushNotificationsViewController: PushNotificationsViewController!
    var locationViewController: LocationViewController!
    
    override func setUpWithError() throws {
        homeViewController = HomeViewController()
        onboardingViewController = TestableOnboardingViewController()
        cameraViewController = CameraViewController()
        pushNotificationsViewController = PushNotificationsViewController()
        locationViewController = LocationViewController()
    }
    
    override func tearDownWithError() throws {
        homeViewController = nil
        onboardingViewController = nil
        cameraViewController = nil
        pushNotificationsViewController = nil
        locationViewController = nil
    }
}

//MARK: - HomeViewController Tests -
extension TestIonixTests {
    
    func testFetchFilteredPosts() {
        let expectation = XCTestExpectation(description: "Fetch filtered posts")
        
        // Call the fetchFilteredPosts method on your HomeViewController instance
        homeViewController.fetchFilteredPosts()
        
        // Wait for 10 seconds for the completion handler to be called
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            XCTAssertTrue(self.homeViewController.posts.count > 0, "Filtered posts should not be empty")
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled or timeout after 15 seconds
        wait(for: [expectation], timeout: 15)
    }
    
    func testSearchPosts() {
        let expectation = XCTestExpectation(description: "Search posts")
        
        // Call the searchPosts method on your HomeViewController instance with a test query
        homeViewController.searchPosts(query: "test", completion: { result in
            switch result {
            case .success:
                XCTAssertTrue(self.homeViewController.searchResults.count > 0, "Search results should not be empty")
            case .failure(let error):
                XCTFail("Error searching posts: \(error.localizedDescription)")
            }
            expectation.fulfill()
        })
        
        // Wait for the expectation to be fulfilled or timeout after 15 seconds
        wait(for: [expectation], timeout: 15)
    }
    
    func testLoadMorePostsIfNeeded() {
        // Test case when not searching
        let initialPostCount = homeViewController.posts.count
        let indexPath = IndexPath(item: initialPostCount - 1, section: 0)
        homeViewController.loadMorePostsIfNeeded(currentIndexPath: indexPath)
        
        // Expect posts count to increase after loading more posts
        let expectation1 = XCTestExpectation(description: "Load more posts when not searching")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.homeViewController.posts.count > initialPostCount)
            expectation1.fulfill()
        }
        
        // Test case when searching
        homeViewController.isSearching = true
        homeViewController.searchPosts(query: "test") { _ in }
        let initialSearchResultsCount = homeViewController.searchResults.count
        let indexPath2 = IndexPath(item: initialSearchResultsCount - 1, section: 0)
        homeViewController.loadMorePostsIfNeeded(currentIndexPath: indexPath2)
        
        // Expect search results count to increase after loading more posts
        let expectation2 = XCTestExpectation(description: "Load more posts when searching")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.homeViewController.searchResults.count > initialSearchResultsCount)
            expectation2.fulfill()
        }
        
        wait(for: [expectation1, expectation2], timeout: 10)
    }
    
    func testNumberOfItemsInSection() {
        // Given
        homeViewController.posts = [Post.mock(), Post.mock(), Post.mock()]
        homeViewController.searchResults = [Post.mock(), Post.mock()]
        homeViewController.isSearching = false
        
        // When
        let numberOfItemsNotSearching = homeViewController.collectionView(homeViewController.collectionView, numberOfItemsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfItemsNotSearching, homeViewController.posts.count, "Number of items should be equal to the number of posts when not searching")
        
        // Given
        homeViewController.isSearching = true
        
        // When
        let numberOfItemsSearching = homeViewController.collectionView(homeViewController.collectionView, numberOfItemsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfItemsSearching, homeViewController.searchResults.count, "Number of items should be equal to the number of search results when searching")
    }
    
    func testCellForItemAt() {
        let mockPost = Post.mock()
        homeViewController.posts = [mockPost]
        homeViewController.loadViewIfNeeded()
        
        let collectionView = homeViewController.collectionView
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = homeViewController.collectionView(collectionView, cellForItemAt: indexPath) as! PostCollectionViewCell
        
        XCTAssertEqual(cell.titleLabel.text, homeViewController.posts[indexPath.item].title, "Title of the cell should match the post title")
    }
    
    func testSearchBarTextDidChange() {
        let expectation = XCTestExpectation(description: "Search bar text did change")
        
        // Given
        homeViewController.searchBar.text = "test"
        homeViewController.isSearching = true
        
        // When
        homeViewController.searchBar(homeViewController.searchBar, textDidChange: homeViewController.searchBar.text!)
        
        // Then
        XCTAssertTrue(homeViewController.isSearching, "isSearching should be true after searchBar text did change")
        XCTAssertEqual(homeViewController.searchResults.count, 0, "Search results should be empty initially")
        
        // Wait for search results to be updated
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.homeViewController.searchResults.count > 0, "Search results should not be empty after searchBar text did change")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testSearchBarCancelButtonClicked() {
        // Given
        homeViewController.searchBar.text = "test"
        homeViewController.isSearching = true
        homeViewController.searchResults = [Post.mock()]
        
        // When
        homeViewController.searchBarCancelButtonClicked(homeViewController.searchBar)
        
        // Then
        XCTAssertFalse(homeViewController.isSearching, "isSearching should be false after searchBar cancel button clicked")
        XCTAssertEqual(homeViewController.searchResults.count, 0, "Search results should be empty after searchBar cancel button clicked")
    }
}

//MARK: - OnboardingViewController Tests -
class TestableOnboardingViewController: OnboardingViewController {
    var testOrderedViewControllers: [UIViewController] {
        return orderedViewControllers
    }
}

extension TestIonixTests {
    
    func testOrderedViewControllersCount() {
        // Test that OnboardingViewController has the correct number of view controllers in orderedViewControllers
        XCTAssertEqual(onboardingViewController.testOrderedViewControllers.count, 3, "orderedViewControllers should have exactly 3 view controllers")
    }
    
    func testInitialViewControllerSetup() {
        // Test that OnboardingViewController sets up the initial view controller correctly
        onboardingViewController.viewDidLoad()
        let firstViewController = onboardingViewController.testOrderedViewControllers.first
        XCTAssertNotNil(firstViewController, "firstViewController should not be nil")
        
        let currentViewController = onboardingViewController.viewControllers?.first
        XCTAssertEqual(currentViewController, firstViewController, "Initial view controller should be the first view controller in orderedViewControllers")
    }
    
    func testNavigationBetweenViewControllers() {
        // Test case 3: Test navigation between view controllers
        onboardingViewController.viewDidLoad()
        
        // Test navigating forward
        if let currentViewController = onboardingViewController.viewControllers?.first,
           let nextViewController = onboardingViewController.pageViewController(onboardingViewController, viewControllerAfter: currentViewController) {
            XCTAssertEqual(onboardingViewController.testOrderedViewControllers[1], nextViewController, "The next view controller should be the second one in orderedViewControllers")
        } else {
            XCTFail("Failed to navigate to the next view controller")
        }
        
        // Test navigating backward
        if let currentViewController = onboardingViewController.testOrderedViewControllers[2] as? UIViewController,
           let previousViewController = onboardingViewController.pageViewController(onboardingViewController, viewControllerBefore: currentViewController) {
            XCTAssertEqual(onboardingViewController.testOrderedViewControllers[1], previousViewController, "The previous view controller should be the second one in orderedViewControllers")
        } else {
            XCTFail("Failed to navigate to the previous view controller")
        }
    }

    func testPageControlConfiguration() {
        // Test case 4: Test page control configuration
        onboardingViewController.viewDidLoad()
        
        XCTAssertEqual(onboardingViewController.pageControl.numberOfPages, onboardingViewController.testOrderedViewControllers.count, "The pageControl numberOfPages should be equal to the number of view controllers in orderedViewControllers")
        
        XCTAssertEqual(onboardingViewController.pageControl.currentPage, 0, "The pageControl currentPage should be 0 initially")
        
        XCTAssertEqual(onboardingViewController.pageControl.tintColor, UIColor.black, "The pageControl tintColor should be black")
        
        XCTAssertEqual(onboardingViewController.pageControl.pageIndicatorTintColor, UIColor.lightGray, "The pageControl pageIndicatorTintColor should be lightGray")
        
        XCTAssertEqual(onboardingViewController.pageControl.currentPageIndicatorTintColor, UIColor.black, "The pageControl currentPageIndicatorTintColor should be black")
    }

    func testPageViewControllerDataSource() {
        // Test case 5: Test UIPageViewControllerDataSource implementation
        onboardingViewController.viewDidLoad()
        
        XCTAssertEqual(onboardingViewController.presentationCount(for: onboardingViewController), onboardingViewController.testOrderedViewControllers.count, "The presentationCount should be equal to the number of view controllers in orderedViewControllers")
        
        XCTAssertEqual(onboardingViewController.presentationIndex(for: onboardingViewController), 0, "The presentationIndex should be 0 initially")
    }
}

//MARK: - CameraViewController Tests -
extension TestIonixTests {
    
    func testViewControllerLoadsProperlyCamera() {
        // Test case 1: Test if the view controller loads properly and has the expected UI elements
        cameraViewController.loadViewIfNeeded()
        
        XCTAssertNotNil(cameraViewController.imageView, "The imageView should not be nil")
        XCTAssertNotNil(cameraViewController.titleLabel, "The titleLabel should not be nil")
        XCTAssertNotNil(cameraViewController.descriptionLabel, "The descriptionLabel should not be nil")
        XCTAssertNotNil(cameraViewController.allowButton, "The allowButton should not be nil")
        XCTAssertNotNil(cameraViewController.cancelButton, "The cancelButton should not be nil")
    }

    func testHasCameraAccess() {
        // Test case 2: Test if the hasCameraAccess function returns the correct access status
        let keychain = cameraViewController.keychain
        let cameraAccessKey = "com.testIonix.cameraAccess"
        
        keychain.set(true, forKey: cameraAccessKey)
        XCTAssertTrue(cameraViewController.hasCameraAccess(), "hasCameraAccess should return true when access is granted")
        
        keychain.set(false, forKey: cameraAccessKey)
        XCTAssertFalse(cameraViewController.hasCameraAccess(), "hasCameraAccess should return false when access is denied")
        
        keychain.delete(cameraAccessKey)
        XCTAssertFalse(cameraViewController.hasCameraAccess(), "hasCameraAccess should return false when there is no stored preference")
    }
}

//MARK: - PushNotificationsViewController Tests -
extension TestIonixTests {
    func testViewControllerLoadsProperlyPushNotifications() {
        // Test case 1: Test if the view controller loads properly and has the expected UI elements
        pushNotificationsViewController.loadViewIfNeeded()
        
        XCTAssertNotNil(pushNotificationsViewController.imageView, "The imageView should not be nil")
        XCTAssertNotNil(pushNotificationsViewController.titleLabel, "The titleLabel should not be nil")
        XCTAssertNotNil(pushNotificationsViewController.descriptionLabel, "The descriptionLabel should not be nil")
        XCTAssertNotNil(pushNotificationsViewController.allowButton, "The allowButton should not be nil")
        XCTAssertNotNil(pushNotificationsViewController.cancelButton, "The cancelButton should not be nil")
    }

    func testHasPushNotificationAccess() {
        // Test case 2: Test if the hasPushNotificationAccess function returns the correct access status
        let keychain = pushNotificationsViewController.keychain
        let pushNotificationAccessKey = "com.testIonix.pushNotificationAccess"
        
        keychain.set(true, forKey: pushNotificationAccessKey)
        XCTAssertTrue(pushNotificationsViewController.hasPushNotificationAccess(), "hasPushNotificationAccess should return true when access is granted")
        
        keychain.set(false, forKey: pushNotificationAccessKey)
        XCTAssertFalse(pushNotificationsViewController.hasPushNotificationAccess(), "hasPushNotificationAccess should return false when access is denied")
        
        keychain.delete(pushNotificationAccessKey)
        XCTAssertFalse(pushNotificationsViewController.hasPushNotificationAccess(), "hasPushNotificationAccess should return false when there is no stored preference")
    }
}

//MARK: - LocationViewController Tests -
extension TestIonixTests {
    func testViewControllerLoadsProperlyLocation() {
        // Test case 1: Test if the view controller loads properly and has the expected UI elements
        locationViewController.loadViewIfNeeded()
        
        XCTAssertNotNil(locationViewController.imageView, "The imageView should not be nil")
        XCTAssertNotNil(locationViewController.titleLabel, "The titleLabel should not be nil")
        XCTAssertNotNil(locationViewController.descriptionLabel, "The descriptionLabel should not be nil")
        XCTAssertNotNil(locationViewController.allowButton, "The allowButton should not be nil")
        XCTAssertNotNil(locationViewController.cancelButton, "The cancelButton should not be nil")
    }

    func testHasLocationAccess() {
        // Test case 2: Test if the hasLocationAccess function returns the correct access status
        let keychain = locationViewController.keychain
        let locationAccessKey = "com.testIonix.locationAccess"
        
        keychain.set(true, forKey: locationAccessKey)
        XCTAssertTrue(locationViewController.hasLocationAccess(), "hasLocationAccess should return true when access is granted")
        
        keychain.set(false, forKey: locationAccessKey)
        XCTAssertFalse(locationViewController.hasLocationAccess(), "hasLocationAccess should return false when access is denied")
        
        keychain.delete(locationAccessKey)
        XCTAssertFalse(locationViewController.hasLocationAccess(), "hasLocationAccess should return false when there is no stored preference")
    }
}

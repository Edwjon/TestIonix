//
//  HomeViewController.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIScrollViewDelegate {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .clear
        return searchBar
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No results found"
        label.font = .boldSystemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()

    private let noResultsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "noResults")
        imageView.isHidden = true
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error loading data"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private var posts: [Post] = []
    private let api = Api()
    private var after: String?
    
    private var isSearching = false
    private var searchResults: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Memes"
        setupLeftBarButtonItem()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        
        view.addSubview(noResultsLabel)
        noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true

        view.addSubview(noResultsImageView)
        noResultsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultsImageView.bottomAnchor.constraint(equalTo: noResultsLabel.topAnchor, constant: -40).isActive = true
        noResultsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noResultsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        noResultsImageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //Add searchBar
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        //Add collection view
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register cell classes
        self.collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        // Load posts
        fetchFilteredPosts()
    }
    
    @objc private func handleRefreshControl() {
        if isSearching {
            if let searchText = searchBar.text, !searchText.isEmpty {
                searchPosts(query: searchText)
                activityIndicator.isHidden = true
            } else {
                isSearching = false
                collectionView.reloadData()
                refreshControl.endRefreshing()
                activityIndicator.isHidden = true
            }
        } else {
            after = nil
            posts.removeAll()
            collectionView.reloadData()
            fetchFilteredPosts()
            activityIndicator.isHidden = true
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupLeftBarButtonItem() {
        let originalImage = UIImage(named: "engine")
        let targetSize = CGSize(width: 30, height: 30)
        let resizedImage = resizeImage(image: originalImage!, targetSize: targetSize)
        
        let leftBarButtonItem = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(engineButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc private func engineButtonTapped() {
        let onboardingViewController = OnboardingViewController()
        let navigationController = UINavigationController(rootViewController: onboardingViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    
    @objc private func handleViewTap() {
        searchBar.resignFirstResponder()
        if searchBar.text == "" {
            isSearching = false
            noResultsImageView.isHidden = true
            noResultsLabel.isHidden = true
            collectionView.reloadData()
        }
        
    }
    
    private func fetchFilteredPosts() {
        activityIndicator.startAnimating()
        api.fetchPosts(limit: 100, after: after) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let fetchedPosts, let newAfter)):
                let filteredPosts = fetchedPosts.filter { post in
                    post.postHint == "image" //&& post.linkFlairText == "shiposting"
                }
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.posts.append(contentsOf: filteredPosts)
                    self.after = newAfter
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print("Error fetching posts: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Error fetching posts")
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    
    private func searchPosts(query: String, after: String? = nil) {
        activityIndicator.startAnimating()
        api.searchPosts(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let searchedPosts, _)):
                let filteredPosts = searchedPosts.filter { post in
                    post.postHint == "image" //&& post.linkFlairText == "shiposting"
                }
                DispatchQueue.main.async {
                    if let after = after {
                        self.searchResults.append(contentsOf: filteredPosts)
                    } else {
                        self.searchResults = filteredPosts
                    }
                    self.errorLabel.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print("Error searching posts: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Error searching posts")
                    self.errorLabel.isHidden = false
                }
            }
        }
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            let hasResults = searchResults.count > 0
            noResultsLabel.isHidden = hasResults
            noResultsImageView.isHidden = hasResults
            return searchResults.count
        } else {
            return posts.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCollectionViewCell
        
        let post = isSearching ? searchResults[indexPath.item] : posts[indexPath.item]
        cell.configure(with: post)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMorePostsIfNeeded(currentIndexPath: indexPath)
    }
    
    private func loadMorePostsIfNeeded(currentIndexPath indexPath: IndexPath) {
        if isSearching {
            if indexPath.item == searchResults.count - 1 {
                searchPosts(query: searchBar.text ?? "", after: after)
            }
        } else {
            if indexPath.item == posts.count - 1 {
                fetchFilteredPosts()
            }
        }
    }
    
    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults.removeAll()
            collectionView.reloadData()
        } else {
            searchPosts(query: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        searchPosts(query: searchBar.text ?? "")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

//
//  HomeViewController.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        return cv
    }()
    
    private var posts: [Post] = []
    private let api = Api()
    private var after: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        //Add collection view
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register cell classes
        self.collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // Load posts
        fetchFilteredPosts()
    }
    
    private func fetchFilteredPosts() {
        api.fetchPosts(limit: 100, after: after) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let fetchedPosts, let newAfter)):
                let filteredPosts = fetchedPosts.filter { post in
                    post.postHint == "image" //&& post.linkFlairText == "shiposting"
                }
                DispatchQueue.main.async {
                    self.posts.append(contentsOf: filteredPosts)
                    self.after = newAfter
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching posts: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCollectionViewCell
    
        let post = posts[indexPath.item]
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
        if indexPath.item == posts.count - 1 {
            fetchFilteredPosts()
        }
    }
}

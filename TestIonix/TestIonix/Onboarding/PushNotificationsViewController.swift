//
//  PushNotificationsViewController.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import Foundation
import UIKit
import UserNotifications
import KeychainSwift

class PushNotificationsViewController: UIViewController {
    
    private let keychain = KeychainSwift()
    private let pushNotificationAccessKey = "com.testIonix.pushNotificationAccess"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let allowButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    var onCancelTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

//MARK: - UI Methods -
extension PushNotificationsViewController {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        // Customize imageView
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "notifications")
        view.addSubview(imageView)
        
        // Customize titleLabel
        titleLabel.textAlignment = .center
        titleLabel.text = "Enable Push Notifications"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(titleLabel)
        
        // Customize descriptionLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Enable push notifications to let send you personal news and updates."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(descriptionLabel)
        
        // Customize allowButton
        allowButton.setTitle("Enable", for: .normal)
        allowButton.backgroundColor = .red
        allowButton.setTitleColor(.white, for: .normal)
        allowButton.layer.cornerRadius = 20
        allowButton.addTarget(self, action: #selector(allowButtonTapped), for: .touchUpInside)
        view.addSubview(allowButton)
        
        // Customize cancelButton
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.gray, for: .normal)
        cancelButton.layer.cornerRadius = 20
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        allowButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Constraints for imageView
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Constraints for titleLabel
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Constraints for descriptionLabel
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Constraints for allowButton
            allowButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 100),
            allowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            allowButton.widthAnchor.constraint(equalToConstant: 150),
            allowButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Constraints for cancelButton
            cancelButton.topAnchor.constraint(equalTo: allowButton.bottomAnchor, constant: 20),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

//MARK: - Action Methods - 
extension PushNotificationsViewController {

    @objc private func allowButtonTapped() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.keychain.set(true, forKey: self.pushNotificationAccessKey)
                    // The user has granted access to push notifications
                } else {
                    self.keychain.set(false, forKey: self.pushNotificationAccessKey)
                    // The user has denied access to push notifications
                }
            }
        }
    }

    @objc private func cancelButtonTapped() {
        onCancelTapped?()
    }
    
    //Check the user's notification access preference
    func hasPushNotificationAccess() -> Bool {
        return keychain.getBool(pushNotificationAccessKey) ?? false
    }
}

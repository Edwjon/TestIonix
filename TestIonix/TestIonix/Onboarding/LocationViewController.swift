//
//  LocationViewController.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import Foundation
import UIKit
import CoreLocation
import KeychainSwift

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    private let keychain = KeychainSwift()
    private let locationAccessKey = "com.testIonix.locationAccess"
    
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

    private func setupViews() {
        view.backgroundColor = .white

        // Customize imageView
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        view.addSubview(imageView)

        // Customize titleLabel
        titleLabel.textAlignment = .center
        titleLabel.text = "Enable location services"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(titleLabel)

        // Customize descriptionLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "We want to access your location only to provide a better experience by"
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

    @objc private func allowButtonTapped() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.keychain.set(true, forKey: self.locationAccessKey)
                // The user has granted access to the location
            case .denied, .restricted:
                self.keychain.set(false, forKey: self.locationAccessKey)
                // The user has denied access to the location
            default:
                // The location authorization status is not determined or not applicable
                break
            }
        }
    }

    @objc private func cancelButtonTapped() {
        onCancelTapped?()
    }
    
    //Check the user's location access preference
    func hasLocationAccess() -> Bool {
        return keychain.getBool(locationAccessKey) ?? false
    }
}

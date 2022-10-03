//
//  HomeController.swift
//  DSSGoogleLogin
//
//  Created by David Quispe Aruquipa on 30/09/22.
//

import UIKit
import ParseSwift

class HomeController: UIViewController {
    
    /// When set, it updates the usernameLabel's text with the user's username.
    var user: User? {
        didSet {
            usernameLabel.text = "Hello \(user?.username ?? "N/A")!"
        }
    }
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Log out", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the layout (usernameLabel and signOutButton)
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        navigationItem.title = "Back4App"
        view.addSubview(usernameLabel)
        view.addSubview(logOutButton)
        
        usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        // Adds the method that will be called when the user taps the logout button
        logOutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
    }
    
    /// Called when the user taps the logout button.
    @objc private func handleLogOut() {
        // WARNING: Use only one of the following implementations, the synchronous or asynchronous option
        
        // Logs out the user synchronously, it throws a ParseError error if something happened.
        // This should be executed in a background thread!
        do {
            try User.logout()
            
            // After the logout succeeded we pop the home screen
            navigationController?.popViewController(animated: true)
        } catch let error as ParseError {
            showMessage(title: "Error", message: "Failed to log out: \(error.message)")
        } catch {
            showMessage(title: "Error", message: "Failed to log out: \(error.localizedDescription)")
        }
        
        User.logout { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self?.showMessage(title: "Error", message: "Failed to log out: \(error.message)")
            }
        }
    }
}

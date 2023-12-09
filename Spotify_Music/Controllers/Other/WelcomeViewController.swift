//
//  WelcomeViewController.swift
//  Spotify_Music
//
//  Created by Mallikharjun kakarla on 09/12/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButtonn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Sign In With Spotify", for: .normal)
        btn.setTitleColor(.link, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButtonn)
        signInButtonn.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signInButtonn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            signInButtonn.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            signInButtonn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            signInButtonn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func signInTapped() {
        let vc = AuthViewController()
        vc.completion = { [weak self]success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success:Bool) {
        
    }
}

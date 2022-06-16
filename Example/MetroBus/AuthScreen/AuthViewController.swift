//
//  AuthViewController.swift
//  MetroBus
//
//  Created by Слава Платонов on 09.06.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var authLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Authorization here"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(authLabel)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            authLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            authLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            authLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            authLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

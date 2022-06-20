//
//  ViewController.swift
//  MetroBus
//
//  Created by Слава Платонов on 09.06.2022.
//

import Bus
import UIKit

class ViewController: UIViewController {
    
    private let showBusFlowButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Show bus flow", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showBusFlow), for: .touchUpInside)
        return button
    }()
    
    private let showHistoryFlowButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Show History", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showHistoryFlow), for: .touchUpInside)
        return button
    }()
    
    private let showOnboardingFlowButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Show Onboarding", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showOnboardingFlow), for: .touchUpInside)
        return button
    }()
    
    public var bus: Bus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    private func setup() {
        view.addSubview(showBusFlowButton)
        NSLayoutConstraint.activate([
            showBusFlowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showBusFlowButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showBusFlowButton.widthAnchor.constraint(equalToConstant: 200),
            showBusFlowButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.addSubview(showHistoryFlowButton)
        NSLayoutConstraint.activate([
            showHistoryFlowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showHistoryFlowButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75),
            showHistoryFlowButton.widthAnchor.constraint(equalToConstant: 200),
            showHistoryFlowButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.addSubview(showOnboardingFlowButton)
        NSLayoutConstraint.activate([
            showOnboardingFlowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showOnboardingFlowButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -170),
            showOnboardingFlowButton.widthAnchor.constraint(equalToConstant: 200),
            showOnboardingFlowButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    private func showBusFlow() {
        let busFlow = Bus.shared.showBusFlow()
        self.present(busFlow, animated: true)
    }
    
    @objc
    private func showHistoryFlow() {
        let busFlow = Bus.shared.showHistory()
        self.present(busFlow, animated: true)
    }
    
    @objc
    private func showOnboardingFlow() {
        let busFlow = Bus.shared.showOnboarding()
        self.present(busFlow, animated: true)
    }
}

//
//  ViewController.swift
//  MetroBus
//
//  Created by Слава Платонов on 09.06.2022.
//

import Bus
import UIKit

class ViewController: UIViewController {
    
    private let showBusFlowButton: UIButton = {
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
    }
    
    @objc private func showBusFlow() {
        let busFlow = Bus.shared.showBusFlow()
        self.present(busFlow, animated: true)
    }
}

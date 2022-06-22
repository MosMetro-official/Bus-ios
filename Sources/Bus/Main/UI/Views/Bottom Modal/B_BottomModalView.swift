//
//  B_BottomModalView.swift
//  MosmetroNew
//
//  Created by Гусейн on 29.07.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol B_BottomModalViewable {
    var image: UIImage { get set }
    var title: String { get set }
    var subtitle: String { get set }
    var onClose: () -> () { get set }
    var onAction: () -> () { get set }
    var buttonText: String { get set }
}

class B_BottomModalView : UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var actionButton: B_MKButton!
    @IBOutlet weak var contentView: UIVisualEffectView!
    
    private var onClose: (() -> ())?
    private var onAction: (() -> ())?
    
    @IBAction func handleClose(_ sender: UIButton) {
        onClose?()
    }
    
    @IBAction func handleAction(_ sender: B_MKButton) {
        onAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}

extension B_BottomModalView {
    private func setup() {
        if #available(iOS 13.0, *) {
            let effect        = UIBlurEffect(style: .systemMaterial)
            contentView.effect = effect
        }
        contentView.roundCorners(.all, radius: 33)
        actionButton.roundCorners(.all, radius: 8)
        contentView.layer.masksToBounds = true
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
    }
    
    public func configure(with data: B_BottomModalViewable) {
        imageView.image = data.image
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        onClose = data.onClose
        onAction = data.onAction
        actionButton.setTitle(data.buttonText, for: .normal)
        
    }
}

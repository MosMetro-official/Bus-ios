//
//  BlurView.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 14.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

class BlurView: UIView {

    var contentView: UIView {
        return visualEffectView.contentView
    }
    
    private var shadowView      : UIImageView!
    public var visualEffectView: UIVisualEffectView!

    init(frame: CGRect, cornerRadius: CGFloat) {
        super.init(frame: frame)
        self.selfInit(cornerRadius: cornerRadius)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selfInit()
    }

    private func selfInit(cornerRadius: CGFloat = 0, shadow: Shadow = Shadow(offset: CGSize(), blur: 10.0, color: .black.withAlphaComponent(0.5))) {
        backgroundColor = .clear
        self.shadowView = lazyShadowView(cornerRadius, shadow: shadow)
        self.visualEffectView = lazyVisualEffectView(cornerRadius)
        addSubview(shadowView)
      
        addSubview(visualEffectView)

        let blurRadius = shadow.blur
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),

            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: -blurRadius),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: blurRadius),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: blurRadius),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -blurRadius),
        ])
    }
}

//MARK: - Shadows
extension BlurView {

    fileprivate func lazyVisualEffectView(_ cornerRadius: CGFloat) -> UIVisualEffectView {
        var view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        // The "system thin" material automatically adapts to changes to the `UIUserInterfaceStyle`.
        // The only we need to do here is show/ hide the shadow.
        if #available(iOS 13.0, *) {
            view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        } else {
            // Fallback on earlier versions
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundCorners(.all, radius: cornerRadius)
//        if #available(iOS 13.0, *) {
//            view.layer.cornerCurve = .continuous
//        }
        view.layer.masksToBounds = true

        return view
    }

    fileprivate func lazyShadowView(_ cornerRadius: CGFloat, shadow: Shadow) -> UIImageView {
        
        let image = resizeableShadowImage(
            withCornerRadius: cornerRadius,
            shadow: shadow,
            shouldDrawCapInsets: false
        )

        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    fileprivate func resizeableShadowImage(withCornerRadius cornerRadius: CGFloat, shadow: Shadow, shouldDrawCapInsets: Bool) -> UIImage {

        // Trial and error: a multiple of 5 seems to create a decent shadow image for our purposes.
        // It's not a perfect fit with the visual effect view's corner. However, putting the image
        // view under the visual effect view should mask any issues.
        let sideLength: CGFloat = cornerRadius * 5
        return UIImage.resizableShadowImage(
            withSideLength: sideLength,
            cornerRadius: cornerRadius,
            shadow: shadow,
            shouldDrawCapInsets: false
        )
    }
}

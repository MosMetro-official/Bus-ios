//
//  B_AuthDelegate.swift
//  
//
//  Created by Слава Платонов on 09.06.2022.
//

import UIKit

@objc
public protocol B_AuthDelegate: AnyObject {
    
    /// Метод необходим для авторизации пользователя
    /// - Returns: ViewController авторизации
    func showAuthScreen(completion: (UIViewController) -> Void)
}

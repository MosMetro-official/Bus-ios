//
//  File 2.swift
//  
//
//  Created by Слава Платонов on 07.06.2022.
//

import Foundation

extension Notification.Name {
    static let logout = Notification.Name("account.logout")
    static let becomeActive = Notification.Name("metro.becomeActive")
    static let parkingFailure = Notification.Name("parkingFailure")
    static let parkingSuccess = Notification.Name("parkingSuccess")
    static let parkingCancelled = Notification.Name("parkingCancelled")
    static let busPaymentSuccess = Notification.Name("busPaymentSuccess")
    static let enteredBackground = Notification.Name("metro.enteredBackground")
}

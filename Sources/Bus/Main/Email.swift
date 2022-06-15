//
//  Email.swift
//  MosmetroNew
//
//  Created by Роман Мироненко on 30.07.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

//func createEmailUrl(to: String, subject: String, body: String) -> URL? {
//    let finalBody = LKPDevice().infoStringValue(body)
//
//    guard let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
//          let bodyEncoded = finalBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
//        return nil
//    }
//
//    return collectEmailUrl(to: to, subjectEncoded: subjectEncoded, bodyEncoded: bodyEncoded)
//}

fileprivate func collectEmailUrl(to: String, subjectEncoded: String, bodyEncoded: String) -> URL? {
    
     let mailList = [
         "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)",
         "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)",
         "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)",
         "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)",
         "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
     ]
     return mailList.compactMap(URL.init(string:)).first(where: UIApplication.shared.canOpenURL)
 }

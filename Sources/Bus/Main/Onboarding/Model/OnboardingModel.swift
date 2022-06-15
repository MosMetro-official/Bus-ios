//
//  OnboardingModel.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import MMCoreNetwork
import Localize_Swift

struct OnboardingModel {
    
    let lightImageURL: String?
    let darkImageURL: String?
    let title_ru: String
    let title_en: String
    let subtitle_ru: String
    let subtitle_en: String
    
    var imageURL: String? {
        return Constants.isDarkModeEnabled ? darkImageURL : lightImageURL
    }
    
    var title: String {
        return Localize.currentLanguage() == "ru" ? title_ru : title_en
    }
    
    var subtitle: String {
        return Localize.currentLanguage() == "ru" ? subtitle_ru : subtitle_en
    }
    
}

extension OnboardingModel {
    
    static func map(data: JSON) -> OnboardingModel {
        return OnboardingModel(lightImageURL: data["image"]["light"].stringValue,
                               darkImageURL: data["image"]["dark"].stringValue,
                               title_ru: data["title"]["ru"].stringValue,
                               title_en: data["title"]["en"].stringValue,
                               subtitle_ru: data["subtitle"]["ru"].stringValue,
                                subtitle_en: data["subtitle"]["en"].stringValue)
    }
//http://app-bucket.mosmetro.ru/onboarding_ios_buses/TESTONBOARDING.json
    static func loadOnboarding(name: String, callback: @escaping (Result<[OnboardingModel],FutureNetworkError>) -> Void) {
        let net = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .empty, body: nil, baseURL: "app-bucket.mosmetro.ru", lastComponent: "/\(name)/onboarding.json")
        net.request(req) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let arr = json["data"].array {
                    let boarding = arr.compactMap { OnboardingModel.map(data: $0) }
                    callback(.success(boarding))
                    return
                }
            case .failure(let err):
                callback(.failure(err))
                return
            }
        }
        
    }
    
}

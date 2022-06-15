//
//  Passenger.swift
//  MosmetroNew
//
//  Created by Гусейн on 14.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import MMCoreNetwork
import RealmSwift

struct Passenger {
    
    enum Gender {
        case male, female
    }
    
    struct Document {
        var series: String?
        var number: String?
        let name: String
        let docTypeCode: String
        let code: String
        
        static func map(data: JSON) -> Document? {
            if let code = data["code"].string, let docTypeCode = data["type"].string {
                return Document(series: nil,
                                number: nil,
                                name: data["name"].stringValue,
                                docTypeCode: docTypeCode,
                                code: code)
            }
            return nil
        }
        
    }
    var id: String?
    var name: String?
    var surname: String?
    var middleName: String?
    var gender: Gender = .male
    var document: Document
    var place: BusSeat?
    var citizenship: Country?
    var phone: String?
    var mail: String?
    var birthday: String?
    
    static func dummyPassenger(availableDocuments: [Document]) -> Passenger? {
        guard let first = availableDocuments.first else { return nil }
        
        return .init(name: nil, surname: nil, middleName: nil, gender: .male, document: first, place: nil)
    }
    
    static func fetchSaved(availableDocs: [Document], callback: @escaping (Result<[Passenger],FutureNetworkError>) -> ()) {
        guard let firstDoc = availableDocs.first else {
            callback(.failure(.jsonParsingError()))
            return
        }
        let queue = DispatchQueue(label: "ru.mosmetro.passengerFetch", qos: .userInitiated)
        queue.async {
            if let realm = try? Realm(configuration: .busConfiguration) {
                let objects = realm.objects(PassengerDTO.self)
                let passengers: [Passenger] = objects.map { passengerDTO in
                    var doc = firstDoc
                    doc.number = passengerDTO.document?.number == "" ? nil : passengerDTO.document!.number
                    doc.series = passengerDTO.document?.series == "" ? nil : passengerDTO.document!.series
                    var country: Country?
                    
                    if let countryDTO = passengerDTO.country {
                        country = Country(id: countryDTO.id, name: countryDTO.name, fullName: countryDTO.fullName, code: countryDTO.code)
                    }
                    return Passenger(id: passengerDTO.id,
                                     name: passengerDTO.name == "" ? nil : passengerDTO.name,
                                     surname: passengerDTO.lastName == "" ? nil : passengerDTO.lastName,
                                     middleName: passengerDTO.middleName == "" ? nil : passengerDTO.middleName,
                                     gender: passengerDTO.isMan ? .male : .female,
                                     document: doc,
                                     place: nil,
                                     citizenship: country,
                                     phone: passengerDTO.phone == "" ? nil : passengerDTO.phone,
                                     mail: passengerDTO.mail == "" ? nil : passengerDTO.mail,
                                     birthday: passengerDTO.birthday == "" ? nil : passengerDTO.birthday)
                    
                }
                callback(.success(passengers))
                return
            }
        }
        
    }
    
    static func save(passengers: [Passenger]) {
        let queue = DispatchQueue(label: "ru.mosmetro.passengerSave", qos: .userInitiated)
        queue.async {
            guard let realm = try? Realm(configuration: .busConfiguration) else { return }
            let passengerDTOs: [PassengerDTO] = passengers.map { passenger in
                let passengerDTO = PassengerDTO()
                if let id = passenger.id {
                    passengerDTO.id = id
                }
                passengerDTO.name = passenger.name ?? ""
                passengerDTO.lastName = passenger.surname ?? ""
                passengerDTO.middleName = passenger.middleName ?? ""
                passengerDTO.isMan = passenger.gender == .male ? true : false
                passengerDTO.phone = passenger.phone ?? ""
                passengerDTO.mail = passenger.mail ?? ""
                if let country = passenger.citizenship, let countryDTO = realm.object(ofType: CountryDTO.self, forPrimaryKey: country.id) {
                    passengerDTO.country = countryDTO
                }
                passengerDTO.birthday = passenger.birthday ?? ""
                let docDTO = DocumentDTO()
                docDTO.number = passenger.document.number ?? ""
                docDTO.series = passenger.document.series ?? ""
                passengerDTO.document = docDTO
                return passengerDTO
            }
            try! realm.write {
                realm.add(passengerDTOs, update: .all)
            }
        }
    }
    
    func save() {
        let queue = DispatchQueue(label: "ru.mosmetro.passengerSave", qos: .userInitiated)
        queue.async {
            guard let realm = try? Realm(configuration: .busConfiguration) else { return }
            let passengerDTO = PassengerDTO()
            passengerDTO.name = self.name ?? ""
            passengerDTO.lastName = self.surname ?? ""
            passengerDTO.middleName = self.middleName ?? ""
            passengerDTO.isMan = self.gender == .male ? true : false
            passengerDTO.phone = self.phone ?? ""
            passengerDTO.mail = self.mail ?? ""
            passengerDTO.birthday = self.birthday ?? ""
            if let country = self.citizenship, let countryDTO = realm.object(ofType: CountryDTO.self, forPrimaryKey: country.id) {
                passengerDTO.country = countryDTO
            }
            let docDTO = DocumentDTO()
            docDTO.number = self.document.number ?? ""
            docDTO.series = self.document.series ?? ""
            passengerDTO.document = docDTO
            try! realm.write {
                realm.add(passengerDTO)
            }
        }
    }
}

class PassengerDTO: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var middleName: String = ""
    @objc dynamic var isMan: Bool = false
    @objc dynamic var phone: String = ""
    @objc dynamic var birthday: String = ""
    @objc dynamic var document: DocumentDTO?
    @objc dynamic var mail: String = ""
    @objc dynamic var country: CountryDTO?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class DocumentDTO: Object {
    @objc dynamic var series: String = ""
    @objc dynamic var number: String = ""
}

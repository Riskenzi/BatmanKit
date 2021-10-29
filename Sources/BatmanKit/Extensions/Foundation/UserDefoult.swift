//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 02.07.2021.
//

import Foundation

public enum ObjectSavableError: String, LocalizedError {
    
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    public var errorDescription: String? {
        rawValue
    }
}

public protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    open  func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    open func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print(error)
            throw ObjectSavableError.unableToDecode
        }
    }
}
import Foundation

enum ErrorDuringSavingProccesOfObjects: String, LocalizedError {
    var errorDescription: String? {
        rawValue
    }
    case problemWithEecodingValue = "problem With Eecoding Value"
    case valueEqualNil = "value is not found by key that gave been given"
    case problemWithDecodingValue = "problem With decoding Value"
    
    
}

protocol QRCodeSavableProtocol {
    func settingUpTheQRCodeObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func gettingUpQRCodeObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: QRCodeSavableProtocol {
    func settingUpTheQRCodeObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let jsonEncoderForValue = JSONEncoder()
        do {
            let jsonDataFromValue = try jsonEncoderForValue.encode(object)
            set(jsonDataFromValue, forKey: forKey)
        } catch {
            throw ErrorDuringSavingProccesOfObjects.problemWithEecodingValue
        }
    }
    
    func gettingUpQRCodeObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let dataForGivenKeyQRObject = data(forKey: forKey) else { throw ErrorDuringSavingProccesOfObjects.valueEqualNil }
        let jsonQRCodeObjectDecoder = JSONDecoder()
        do {
            let jsonDecodedObject = try jsonQRCodeObjectDecoder.decode(type, from: dataForGivenKeyQRObject)
            return jsonDecodedObject
        } catch {
            print(error.localizedDescription)
            throw ErrorDuringSavingProccesOfObjects.problemWithDecodingValue
        }
    }
}

//
//  SessionStore.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import Foundation
import JellyKit

public class SessionStore: ObservableObject {
    @Published var items: [API.Models.Item]
    
    @Published var user: API.AuthUser?
    
    @Published private(set) public var host: String = ""
    @Published private(set) public var port: Int = 8096
    
    public var api: API
    
    var hasUser: Bool {
        return self.user != nil
    }
    
    
    
    
    public init() {
        self.user = nil
        self.api = API("", 8096)
        self.items = []
    }
    
//    public init(_ user: API.AuthUser) {
//        self.api = API(host, port, user)
//        self.user = user
//    }
    
    public func updateItems(_ items: [API.Models.Item]) {
        DispatchQueue.main.async {
            self.items.append(contentsOf: items.filter({!items.contains($0)}))
        }
    }
    public func clear() {
        KeyChain.clear(key: "credentials")
        self.user = nil
    }
    
    public func setServer(_ host: String, _ port: Int) -> API {
        DispatchQueue.main.async {
            self.host = host
            self.port = port
        }
        if hasUser {
            self.api = API(host, port, user)
        } else {
            self.api = API(host, port)
        }
        return self.api
    }
}

import Security

class KeyChain {
    class func clear(key: String) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key] as [String : Any]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }

    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
}

extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}


class UserObject: ObservableObject {
    private(set) public var userId: String
    private(set) public var serverId: String
    private(set) public var accessToken: String
    
    public init(_ userId: String, _ serverId: String, _ accessToken: String) {
        self.userId = userId
        self.serverId = serverId
        self.accessToken = accessToken
    }
}

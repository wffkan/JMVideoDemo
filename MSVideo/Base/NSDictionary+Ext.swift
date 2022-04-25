//
//  NSDictionary+Ext.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/8/2.
//

import Foundation

extension Dictionary {
    
    func bf_convertJsonString() -> String {
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        return ""
    }
    
    func bf_convertData() -> Data? {
        
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data
    }
    
    static func bf_convertFromData(data: Data) -> Dictionary? {
        
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? Dictionary
    }
}

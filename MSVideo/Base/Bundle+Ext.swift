//
//  Bundle+Ext.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

public extension Bundle {
    
    static let bf_resourceBundle: Bundle = Bundle(url: Bundle.main.url(forResource: "TUIKitResource", withExtension: "bundle")!)!
    
    static let bf_emojiBundle: Bundle = Bundle(url: Bundle.main.url(forResource: "TUIKitFace", withExtension: "bundle")!)!
    
    static var bf_languageBundle: Bundle {
        var lanuage = self.bf_localizableLanguageKey()
        lanuage = "Localizable/\(lanuage)"
        return Bundle(path: self.bf_resourceBundle.path(forResource: lanuage, ofType: "lproj")!)!
    }
    
    static func bf_localizableLanguageKey() -> String {
        var language = Locale.preferredLanguages.first
        if language?.hasPrefix("en") == true {
            language = "en"
        }else if language?.hasPrefix("zh") == true {
            if language?.contains("Hans") == true {
                language = "zh-Hans"
            }else {
                language = "zh-Hant"
            }
        }else if language?.hasPrefix("ko") == true {
            language = "ko"
        }else if language?.hasPrefix("ru") == true {
            language = "ru"
        }else if language?.hasPrefix("uk") == true {
            language = "uk"
        }else {
            language = "en"
        }
        return language!
    }
    
    static func bf_localizedString(key: String, value: String? = nil) -> String {
        
        return self.bf_languageBundle.localizedString(forKey: key, value: value, table: nil)
    }
}

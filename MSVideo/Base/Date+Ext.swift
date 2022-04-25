//
//  Date+Ext.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/8/10.
//

import Foundation

public extension Date {
    
    func ms_messageString() -> String {
        
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let nowComps = calendar.dateComponents(unitFlags, from: Date())
        let myComps = calendar.dateComponents(unitFlags, from: self)
        let dateFormat = DateFormatter()
        var isYesterday = false
        if nowComps.year != myComps.year {
            dateFormat.dateFormat = "yyyy/MM/dd HH:mm"
        }else {
            if nowComps.day == myComps.day {
                dateFormat.dateFormat = "HH:mm"
            }else if (nowComps.day! - myComps.day!) == 1 {
                isYesterday = true
                dateFormat.amSymbol = Bundle.bf_localizedString(key: "am")
                dateFormat.pmSymbol = Bundle.bf_localizedString(key: "pm")
                dateFormat.dateFormat = Bundle.bf_localizedString(key: "YesterdayDateFormat")
            }else {
                if (nowComps.day! - myComps.day!) <= 7 {
                    dateFormat.dateFormat = "EEEE HH:mm"
                }else {
                    dateFormat.dateFormat = "yyyy/MM/dd HH:mm"
                }
            }
        }
        var str = dateFormat.string(from: self)
        if isYesterday {
            str = "\(Bundle.bf_localizedString(key: "Yesterday")) \(str)"
        }
        return str
    }
}

//
//  MSVideoUtils.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation


enum MSVideoPlayMode {
    case MSVideoPlayModeOneLoop // 单个循环
    case MSVideoPlayModeListLoop // 列表循环
}

class MSVideoUtils {
    
    static func loadDefaultVideoUrls() -> [String] {
        
        let fileidArr = ["387702294394366256","387702294394228858", "387702294394228636","387702294394228527", "387702294167066523","387702294167066515","387702294168748446","387702294394227941"]
        return fileidArr
    }
    
}

//
//  MSVideoModel.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import HandyJSON


class MSVideoData: HandyJSON {
    
    var Items: [MSVideoModel] = []
    
    required init() {}
}

class MSVideoModel: HandyJSON {
    
    var identifer: String = ""
    var fsize: Int = 0
    var putTime: Int = 0
    var name: String = ""
    var url: String = ""
    var videoType: String = ""
    var coverUrl: String = ""
    var width: Int = 0
    var height: Int = 0
    var duration: Int = 0
    var hash: String = ""
    
    var viewHeight: CGFloat {
        if self.width == 0 || self.height == 0 {
            return 200.0
        }
        return 200.0 / CGFloat(self.width) * CGFloat(self.height)
    }
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
                    self.videoType <-- "mimeType"
        mapper <<<
                    self.name <-- "key"
    }
}


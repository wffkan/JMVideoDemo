//
//  MSVideoViewModel.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import HandyJSON

class MSVideoViewModel: NSObject {
    
    func refreshNewList(success: @escaping (_ list: [MSVideoModel]?) -> Void,fail:@escaping (_ error: NSError?) -> Void) {
        
        guard let path = Bundle.main.path(forResource: "video", ofType: "json"),
              let json = try? String.init(contentsOfFile: path) else {
                  fail(nil)
            return
        }
        if let models = JSONDeserializer<MSVideoModel>.deserializeModelArrayFrom(json: json, designatedPath: "Items") as? [MSVideoModel] {
            success(models)
        }else {
            fail(nil)
        }
    }

}

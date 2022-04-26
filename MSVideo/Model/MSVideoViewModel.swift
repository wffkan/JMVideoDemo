//
//  MSVideoViewModel.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation


class MSVideoViewModel: NSObject {
    
    func refreshNewList(success: @escaping (_ list: [MSVideoModel]?) -> Void,fail:@escaping (_ error: NSError?) -> Void) {
        
        let videoUrlArr = MSVideoUtils.loadDefaultVideoUrls()
        if videoUrlArr.count == 0 {
            fail(nil)
            return
        }
        var resultArr: [MSVideoModel] = []
        let workingGroup = DispatchGroup()
        
        for field in videoUrlArr {
            
            workingGroup.enter()
            NetWorkManager.netWorkRequest(.videoList(field: field)) { result in
                
                if let requestID = result?["requestId"] as? String,let media = result?["media"] as? [String: Any] {
                    let model = MSVideoModel.deserialize(from: media)
                    model?.requestId = requestID
                    let subStreams = model?.streamingInfo.plainOutput.subStreams.count ?? 0
                    model?.basicInfo.bitrateIndex = subStreams > 0 ? subStreams - 1 : 0
                    if model != nil {
                        resultArr.append(model!)
                    }
                }
                workingGroup.leave()
            } fail: { error in
                workingGroup.leave()
            }
        }
        workingGroup.notify(queue: .main) {
            success(resultArr)
        }
    }

}

//
//  MSVideoModel.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation

class MSVideoModel: BaseModel {
    
    var requestId: String = ""
    var basicInfo: VideoBasicInfo = VideoBasicInfo()
    var streamingInfo: VideoStreamingInfo = VideoStreamingInfo()
    var audioVideoType: String = ""
}

class VideoBasicInfo: BaseModel {
    
    var name: String = ""
    var size: Int = 0
    var duration: Int = 0
    var coverUrl: String = ""
    var bitrateIndex: Int = 0
}

class VideoStreamingInfo: BaseModel {
    
    var plainOutput: VideoPlainOutput = VideoPlainOutput()
    var widevineLicenseUrl: String = ""
    var fairplayLicenseUrl: String = ""
}

class VideoStream: BaseModel {
    
    var type: String = ""
    var width: Int = 0
    var height: Int = 0
    var resolutionName: String = ""
}

class VideoPlainOutput: BaseModel {
    
    var type: String = ""
    var url: String = ""
    var subStreams: [VideoStream] = []
}

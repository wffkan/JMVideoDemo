//
//  MSHelper.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import Foundation
import SVProgressHUD

class MSHelper {
    
    public class func showToast() {
        
        SVProgressHUD.show()
    }
    
    public class func showProgress(progress: Float,text: String?) {
        
        SVProgressHUD.showProgress(progress, status: text)
    }
    
    public class func showToastWithText(text: String) {
        
        SVProgressHUD.setMinimumDismissTimeInterval(3)
        SVProgressHUD.showInfo(withStatus: text)
    }
    
    public class func showToastSuccWithText(text: String) {
        
        SVProgressHUD.setMinimumDismissTimeInterval(3)
        SVProgressHUD.showSuccess(withStatus: text)
    }
    
    public class func showToastFailWithText(text: String) {
        
        SVProgressHUD.setMinimumDismissTimeInterval(3)
        SVProgressHUD.showError(withStatus: text)
    }
    
    public class func dismissToast() {
        
        SVProgressHUD.dismiss()
    }
    
    static var emotionResources = {() -> [[String: Any]] in
        
        var resource: [[String: Any]] = []
        if let bundlePath = Bundle.main.path(forResource: "TUIKitFace", ofType: "bundle"),let reourceBundle = Bundle(path: bundlePath) {
            let filePath = reourceBundle.path(forResource: "/emotion/emotion", ofType: "plist")
            resource = NSArray.init(contentsOfFile: filePath!) as! [[String: Any]]
            return resource
        }
         return []
    }
    
    /// 通过表情查找表情名称
    public class func emotionName(emotion_id: String) -> String {
        
        for item in self.emotionResources() {
            if let e_id = item["id"] as? String, e_id == emotion_id, let l_id = item["lottie"] as? String {
                return l_id
            }
        }
        return ""
    }
}

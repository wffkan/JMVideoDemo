//
//  UIDevice+Ext.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/8/2.
//

import UIKit
import AudioToolbox

extension UIDevice {
    
    class func impactFeedback() {
        
        let impactLight = UIImpactFeedbackGenerator(style: .medium)
        impactLight.impactOccurred()
    }
    
    static var _ringSystemSoundID: SystemSoundID = 0
    class func playShortSound(soundName: String, soundExtension: String) {
        
        guard let audioPath = Bundle.main.url(forResource: soundName, withExtension: soundExtension) else {return}
        
        let error = AudioServicesCreateSystemSoundID(audioPath as CFURL, &_ringSystemSoundID)
        if error != kAudioServicesNoError {
            print("Error loading sound")
            return
        }
        AudioServicesPlaySystemSoundWithCompletion(_ringSystemSoundID) {
            AudioServicesDisposeSystemSoundID(_ringSystemSoundID)
        }
    }
    
    class func stopPlaySystemSound() {
        if _ringSystemSoundID != 0 {
            AudioServicesRemoveSystemSoundCompletion(_ringSystemSoundID)
            AudioServicesDisposeSystemSoundID(_ringSystemSoundID)
            _ringSystemSoundID = 0
        }
    }
}

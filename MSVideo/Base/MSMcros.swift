//
//  MSMcros.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

public struct MSMcros {
    
    static func TUIKitFace(name: String) -> String {
        
        return Bundle.main.path(forResource: "TUIKitFace", ofType: "bundle")! + "/" + name
    }
    
    static func TUIKitResource(name: String) -> String {
        
        return Bundle.main.path(forResource: "TUIKitResource", ofType: "bundle")! + "/" + name
    }
    
    //cell
    static let TMessageCell_Head_Width: CGFloat = 45
    static let TMessageCell_Head_Height: CGFloat =  45
    static let TMessageCell_Head_Size: CGSize =  CGSize(width: 45, height: 45)
    static let TMessageCell_Padding: CGFloat =  8
    static let TMessageCell_Margin: CGFloat =  8
    static let TMessageCell_Indicator_Size: CGSize =  CGSize(width: 20, height: 20)
    
    
    //text cell
    static let TTextMessageCell_ReuseId: String = "TTextMessageCell"
    static let TTextMessageCell_Height_Min: CGFloat = TMessageCell_Head_Size.height + 2 * TMessageCell_Padding
    static let TTextMessageCell_Text_PADDING: CGFloat = 160
    static let TTextMessageCell_Text_Width_Max: CGFloat = UIScreen.width - TTextMessageCell_Text_PADDING
    static let TTextMessageCell_Margin: CGFloat = 12

    //system cell
    static let TSystemMessageCell_ReuseId: String = "TSystemMessageCell"
    static let TSystemMessageCell_Text_Width_Max: CGFloat = UIScreen.width * 0.5
    static let TSystemMessageCell_Margin: CGFloat = 5

    //image cell
    static let TImageMessageCell_ReuseId: String = "TImageMessageCell"
    static let TImageMessageCell_Image_Width_Max: CGFloat = UIScreen.width * 0.4
    static let TImageMessageCell_Image_Height_Max: CGFloat = TImageMessageCell_Image_Width_Max
    static let TImageMessageCell_Margin_2: CGFloat = 8
    static let TImageMessageCell_Margin_1: CGFloat = 16
    static let TImageMessageCell_Progress_Color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)

    //face cell
    static let TFaceMessageCell_ReuseId: String = "TFaceMessageCell"
    static let TFaceMessageCell_Image_Width_Max: CGFloat = UIScreen.width * 0.25
    static let TFaceMessageCell_Image_Height_Max: CGFloat = TFaceMessageCell_Image_Width_Max
    static let TFaceMessageCell_Margin: CGFloat = 16

    //file cell
    static let TFileMessageCell_ReuseId: String = "TFileMessageCell"
    static let TFileMessageCell_Container_Size: CGSize = CGSize(width: UIScreen.width*0.5, height: UIScreen.width*0.5)
    static let TFileMessageCell_Margin: CGFloat = 10
    static let TFileMessageCell_Progress_Color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)

    //emotion cell
    static let TEmotionMessageCell_ReuseId: String = "TEmotionMessageCell"
    static let TEmotionMessageCell_Container_Size: CGSize = CGSize(width: 120, height: 120)
    
    //video cell
    static let TVideoMessageCell_ReuseId: String = "TVideoMessageCell"
    static let TVideoMessageCell_Image_Width_Max: CGFloat = UIScreen.width * 0.4
    static let TVideoMessageCell_Image_Height_Max: CGFloat = TVideoMessageCell_Image_Width_Max
    static let TVideoMessageCell_Margin_3: CGFloat = 4
    static let TVideoMessageCell_Margin_2: CGFloat = 8
    static let TVideoMessageCell_Margin_1: CGFloat = 16
    static let TVideoMessageCell_Play_Size: CGSize = CGSize(width: 35, height: 35)
    static let TVideoMessageCell_Progress_Color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)

    // location cell
    static let TLocationMessageCell_ReuseId: String = "TLocationMessageCell"
    static let TLocationMessageCell_Width = UIScreen.width * 0.65
    static let TLocationMessageCell_Height = TLocationMessageCell_Width * 0.65
    //voice cell
    static let TVoiceMessageCell_ReuseId: String = "TVoiceMessaageCell"
    static let TVoiceMessageCell_Max_Duration: CGFloat = 60.0
    static let TVoiceMessageCell_Height: CGFloat = TMessageCell_Head_Size.height
    static let TVoiceMessageCell_Margin: CGFloat = 12
    static let TVoiceMessageCell_Back_Width_Max: CGFloat = UIScreen.width * 0.4
    static let TVoiceMessageCell_Back_Width_Min: CGFloat = 60
    static let TVoiceMessageCell_Duration_Size: CGSize = CGSize(width: 33, height: 33)

    //menu item cell
    static let TMenuCell_ReuseId: String = "TMenuCell"
    static let TMenuCell_Margin: CGFloat = 6
    static let TMenuCell_Line_ReuseId: String = "TMenuLineCell"
    static let TMenuCell_Background_Color: UIColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    static let TMenuCell_Background_Color_Dark: UIColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
    static let TMenuCell_Selected_Background_Color: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let TMenuCell_Selected_Background_Color_Dark: UIColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
    
    //group_live
    static let TGroupLiveMessageCell_ReuseId: String = "TGroupLiveMessageCell"

    static let TTextView_Height: CGFloat = 49
    static let TTextView_Button_Size: CGSize = CGSize(width: 30, height: 30)
    static let TTextView_Margin: CGFloat = 6
    static let TTextView_TextView_Height_Min: CGFloat = TTextView_Height - 2 * TTextView_Margin
    static let TTextView_TextView_Height_Max: CGFloat = 80

    static let TInput_Background_Color: UIColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    static let TInput_Background_Color_Dark: UIColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)

    static let TLine_Color: UIColor = #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.737254902, alpha: 0.6)
    static let TLine_Color_Dark: UIColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 0.6)
    static let TLine_Heigh: CGFloat = 0.5

    // page commom color
    static let TPage_Color: UIColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
    static let TPage_Color_Dark: UIColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
    static let TPage_Current_Color: UIColor = #colorLiteral(red: 0.4901960784, green: 0.4901960784, blue: 0.4901960784, alpha: 1)
    static let TPage_Current_Color_Dark: UIColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)

    // title commom color
    static let TText_Color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let TText_Color_Dark: UIColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
    static let TText_OutMessage_Color_Dark: UIColor = #colorLiteral(red: 0, green: 0.05882352941, blue: 0, alpha: 1)

    static let TController_Background_Color: UIColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    static let TController_Background_Color_Dark: UIColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)

    // bottom line
    static let TCell_separatorColor: UIColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    static let TCell_separatorColor_Dark: UIColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
    // cell commom color
    static let TCell_Nomal: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let TCell_Nomal_Dark: UIColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
    static let TCell_Touched: UIColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    static let TCell_Touched_Dark: UIColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
    static let TCell_OnTop: UIColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    static let TCell_OnTop_Dark: UIColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)

    //record
    static let Record_Background_Color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
    static let Record_Background_Size: CGSize = CGSize(width: UIScreen.width*0.4, height: UIScreen.width*0.4)
    static let Record_Title_Height: CGFloat = 30
    static let Record_Title_Background_Color: UIColor = #colorLiteral(red: 0.7294117647, green: 0.2352941176, blue: 0.2549019608, alpha: 1)
    static let Record_Margin: CGFloat = 8
    
}

//color
func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) ->UIColor {
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

let ColorWhiteAlpha10:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.1)
let ColorWhiteAlpha20:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.2)
let ColorWhiteAlpha40:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.4)
let ColorWhiteAlpha60:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.6)
let ColorWhiteAlpha80:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.8)

let ColorBlackAlpha5:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.05)
let ColorBlackAlpha10:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.1)
let ColorBlackAlpha20:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.2)
let ColorBlackAlpha40:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.4)
let ColorBlackAlpha60:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.6)
let ColorBlackAlpha80:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.8)
let ColorBlackAlpha90:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.9)

let ColorThemeGrayLight:UIColor = RGBA(r:104.0, g:106.0, b:120.0, a:1.0)
let ColorThemeGray:UIColor = RGBA(r:92.0, g:93.0, b:102.0, a:1.0)
let ColorThemeGrayDark:UIColor = RGBA(r:20.0, g:21.0, b:30.0, a:1.0)
let ColorThemeYellow:UIColor = RGBA(r:250.0, g:206.0, b:21.0, a:1.0)
let ColorThemeYellowDark:UIColor = RGBA(r:235.0, g:181.0, b:37.0, a:1.0)
let ColorThemeBackground:UIColor = RGBA(r:14.0, g:15.0, b:26.0, a:1.0)

let ColorThemeRed:UIColor = RGBA(r:241.0, g:47.0, b:84.0, a:1.0)

let ColorRoseRed:UIColor = RGBA(r:220.0, g:46.0, b:123.0, a:1.0)
let ColorClear:UIColor = UIColor.clear
let ColorBlack:UIColor = UIColor.black
let ColorWhite:UIColor = UIColor.white
let ColorGray:UIColor =  UIColor.gray
let ColorBlue:UIColor = RGBA(r:40.0, g:120.0, b:255.0, a:1.0)
let ColorGrayLight:UIColor = RGBA(r:40.0, g:40.0, b:40.0, a:1.0)
let ColorGrayDark:UIColor = RGBA(r:25.0, g:25.0, b:35.0, a:1.0)
let ColorSmoke:UIColor = RGBA(r:230.0, g:230.0, b:230.0, a:1.0)


//Font
let SuperSmallFont:UIFont = UIFont.systemFont(ofSize: 10.0)
let SuperSmallBoldFont:UIFont = UIFont.systemFont(ofSize: 10.0)

let SmallFont:UIFont = UIFont.systemFont(ofSize: 12.0)
let SmallBoldFont:UIFont = UIFont.systemFont(ofSize: 12.0)

let MediumFont:UIFont = UIFont.systemFont(ofSize: 14.0)
let MediumBoldFont:UIFont = UIFont.systemFont(ofSize: 14.0)

let BigFont:UIFont = UIFont.systemFont(ofSize: 16.0)
let BigBoldFont:UIFont = UIFont.systemFont(ofSize: 16.0)

let LargeFont:UIFont = UIFont.systemFont(ofSize: 18.0)
let LargeBoldFont:UIFont = UIFont.systemFont(ofSize: 18.0)

let SuperBigFont:UIFont = UIFont.systemFont(ofSize: 26.0)
let SuperBigBoldFont:UIFont = UIFont.systemFont(ofSize: 26.0)

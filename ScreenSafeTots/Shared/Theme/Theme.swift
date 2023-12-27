//
//  Theme.swift
//
//  Created by Md. Mehedi Hasan on 10/9/20.

import UIKit

class Theme {
    
    struct Color {
        
        //MARK:- Theme Colors
        ///this is the `base` color named as `sandyBrown`
        static var primary: UIColor { return Theme.Color.yellowOrange }
        ///this is the `light` base color named as `sandyBrownLight`
        static var primaryLight: UIColor { return Theme.Color.yellowOrangeLight }
        ///this is the `dark` base color named as `darkSkyBlue`
        static var primaryDark: UIColor { return Theme.Color.yellowOrangeDark }
        
        ///this is the `secondary` base color named as `purpleAstronaut`
        static var secondary: UIColor { return Theme.Color.purpleAstronaut }
        
        //static var intermidiate: UIColor { return Theme.Color.secondary }

        //static var base: UIColor { return Theme.Color.darkSkyBlue }
        //static var dark: UIColor { return Theme.Color.darkSkyBlue }
        //static var light: UIColor { return Theme.Color.darkSkyBlue }
        
        static var affirmation: UIColor { return Theme.Color.pastelGreen }
        static var negation: UIColor { return Theme.Color.redRibbon }
        
        static var background: UIColor { return Theme.Color.cararra }
        static var backgroundOpaque = UIColor.black.withAlphaComponent(0.6)
        static var selectedBackground: UIColor { return Theme.Color.mercury }
        static var shadow = UIColor.black.withAlphaComponent(0.56)
        
        static var header: UIColor { return Theme.Color.boulder }
        static var placeholder: UIColor { return Theme.Color.boulder }

        static var label: UIColor { return Theme.Color.codGray }
        static var labelSecondary: UIColor { return Theme.Color.shuttleGray }
        static var labelTertiary: UIColor { return Theme.Color.gray }
        static var labelWhite: UIColor { return UIColor.white }
        
        static var link: UIColor { return Theme.Color.telenorLink }
        static var separator = UIColor.lightGray
        
        //MARK:- Constant Colors
        
        static let boulder = UIColor(hex: 0x767676)
        static let codGray = UIColor(hex: 0x1A1A1A)
        static let shuttleGray = UIColor(hex: 0x636466)
        static let gray = UIColor(hex: 0x909090)
        static let manatee = UIColor(hex: 0x979B9F)

        static let redRibbon = UIColor(hex: 0xF21136)
        static let pastelGreen = UIColor(hex: 0x65D573)
        static let funGreen = UIColor(hex: 0x00A912)
        static let seaGreen = UIColor(hex: 0x329355)
        static let purpleAstronaut = UIColor(hex: 0x2D2F7B)
        static let telenorLink = UIColor(hex: 0x007AD0)
        
        //RGB: 87, 165, 217
        static let yellowOrange = UIColor(hex: 0xfdae43)
        static let yellowOrangeLight = UIColor(hex: 0xfdc272)
        static let yellowOrangeDark = UIColor(hex: 0xfc9a14)
        
        static let darkSkyBlue = UIColor(hex: 0x36A9E1)
        static let fadedBlue = UIColor(hex: 0x4B95CD)
        static let dodgerBlue = UIColor(hex: 0x09A8FA)
        static let pictonBlue = UIColor(hex: 0x2DA8E1)
        
        static let brownishGrey = UIColor(white: 112.0 / 255.0, alpha: 1.0)
        static let lightPeach = UIColor(hex: 0xE1DCDC)
    
        static let mercury = UIColor(hex: 0xE5E5E5)
        static let silver = UIColor(hex: 0xCCCCCC)
        static let cararra = UIColor(hex: 0xF5F4F2)
        static let blackHaze =  UIColor(hex: 0xF2F3F3)
    
    }
    
    struct Font {
        static var light : UIFont { return UIFont.systemFont(ofSize: 15.0, weight: .light) }
        static var normal : UIFont { return UIFont.systemFont(ofSize: 15.0, weight: .regular) }
        static var medium : UIFont { return UIFont.systemFont(ofSize: 15.0, weight: .medium) }
        static var bold : UIFont { return UIFont.systemFont(ofSize: 15.0, weight: .bold) }
    
//        title
//        heading
//        subheading
//        body
//        small
    }
    
}

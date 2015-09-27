//
//  PSColorScheme.swift
//  ephemera
//
//  Created by Pranjal Satija on 8/28/15.
//  Copyright © 2015 Pranjal Satija. All rights reserved.
//

import UIKit
import AudioToolbox

///universal constant for posting and listening for NSNotifications to trigger a color change
let colorSchemeNotificationName = "com.pranjalsatija.ColorScheme.update"

///universal constant for consistent transition durations
let colorSchemeTransitionDuration = 0.4

///private constant for determining the last used color scheme
let wasUsingAlternateSchemeKey = "com.pranjalsatija.ColorScheme.wasUsingAlternateScheme"

///universal constant for NSNotificationCenter
let notificationCenter = NSNotificationCenter.defaultCenter()

///universal constant for NSUserDefaults
let defaults = NSUserDefaults.standardUserDefaults()

/**
the available color schemes
    1. Main: default, it's what you configure and use in Interface Builder
    2. Alternate: set in Interface Builder using IBInspectable
*/
enum ColorSchemeType {
    case Main, Alternate
}

///defines a protocol for views wishing to use color schemes to conform to
protocol AlternateColorScheme {
    var originalBackgroundColor: UIColor? { get }
    var alternateBackgroundColor: UIColor? { get }
    var colorSchemeManager: ColorSchemeManager { get set }
    
    func transition()
    
    func switchToMain()
    func switchToAlternate()
}

///defines a protocol for views wishing to use color schemes to conform to, but is modified for views that display text
protocol AlternateColorSchemeWithText {
    var originalBackgroundColor: UIColor? { get }
    var alternateBackgroundColor: UIColor? { get }
    
    var originalTextColor: UIColor? { get }
    var alternateTextColor: UIColor? { get }
    
    var colorSchemeManager: ColorSchemeManager { get set }
    
    func transition()
    
    func switchToMain()
    func switchToAlternate()
}

///defines a protocol for views wishing to use color schemes to conform to, but is modified specifically for PSBorderedTextField
protocol AlternateColorSchemeForPSBorderedTextField {
    var originalBackgroundColor: UIColor? { get }
    var alternateBackgroundColor: UIColor? { get }
    
    var originalTextColor: UIColor? { get }
    var alternateTextColor: UIColor? { get }
    
    var originalPlaceholderColor: UIColor? { get }
    var alternatePlaceholderColor: UIColor? { get }
    
    var originalBorderColor: UIColor? { get }
    var alternateBorderColor: UIColor? { get }
    
    var colorSchemeManager: ColorSchemeManager { get set }
    
    func transition()
    
    func switchToMain()
    func switchToAlternate()

}

///defines a protocol for views wishing to use color schemes to conform to, but is modified specifically for UIActivityIndicatorView (it didn't make sense to call the variables alternateBackgroundColor and originalBackgroundColor, as that's inaccurate.
protocol AlternateColorSchemeForUIActivityIndicator {
    var originalColor: UIColor? { get }
    var alternateColor: UIColor? { get }
    var colorSchemeManager: ColorSchemeManager { get set }
    
    func transition()
    
    func switchToMain()
    func switchToAlternate()
}

///defines a basic class for apps to use as a color scheme manager. it tracks the current color scheme, vibrates the device when schemes are switched, and posts NSNotifications to signal scheme changes. It also handles the archival of the last used color scheme, and restores it as needed.
class ColorSchemeManager {
    static let universalManager = ColorSchemeManager()
    
    var currentColorScheme: ColorSchemeType
    
    init() {
        if defaults.boolForKey(wasUsingAlternateSchemeKey) {
            self.currentColorScheme = .Alternate
        }
            
        else {
            self.currentColorScheme = .Main
        }
    }
    
    ///switches color schemes by posting an NSNotification
    func switchColorScheme(cancelVibrate cancelVibrate: Bool = false) {
        notificationCenter.postNotificationName(colorSchemeNotificationName, object: nil, userInfo: nil)
        
        if !cancelVibrate {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        
        if self.currentColorScheme == .Main {
            self.currentColorScheme = .Alternate
        }
        
        else {
            self.currentColorScheme = .Main
        }
    }
    
    ///archives the current scheme to NSUserDefaults
    func archive() {
        if self.currentColorScheme == .Alternate {
            defaults.setBool(true, forKey: wasUsingAlternateSchemeKey)
        }
        
        else {
            defaults.setBool(false, forKey: wasUsingAlternateSchemeKey)
        }
        
        defaults.synchronize()
    }
}
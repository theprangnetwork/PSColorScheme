//
//  EActivityIndicatorView.swift
//  ephemera
//
//  Created by Pranjal Satija on 8/30/15.
//  Copyright © 2015 Pranjal Satija. All rights reserved.
//

import UIKit

class PSActivityIndicatorView: UIActivityIndicatorView, AlternateColorSchemeForUIActivityIndicator {
    var originalColor: UIColor?
    @IBInspectable var alternateColor: UIColor?
    
    var colorSchemeManager: ColorSchemeManager {
        get {
            return universalManager
        }
        
        set {
            if newValue.currentColorScheme == .Alternate {
                self.color = self.alternateColor
            }
        }
    }
    
    ///this override sets the `originalBackgroundColor` property, and adds an NSNotificationCenter observer to listen for transitions
    override func awakeFromNib() {
        setUp()
    }
    
    ///this function sets all the properties that PSColorScheme needs to operate, and must be called manually if instantiating this view programmatically.
    func setUp() {
        self.originalColor = self.color
        notificationCenter.addObserver(self, selector: "transition", name: colorSchemeNotificationName, object: nil)
    }
    
    ///this function determines which color scheme the view is in, and calls the appropriate animation method to update
    func transition() {
        if self.colorSchemeManager.currentColorScheme == .Main {
            switchToAlternate()
        }
            
        else {
            switchToMain()
        }
    }
    
    ///this function is a helper for `transition()`
    func switchToMain() {
        UIView.animateWithDuration(colorSchemeTransitionDuration) {
            self.color = self.originalColor
        }
    }
    
    ///this function is a helper for `transition()`
    func switchToAlternate() {
        UIView.animateWithDuration(colorSchemeTransitionDuration) {
            self.color = self.alternateColor
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}
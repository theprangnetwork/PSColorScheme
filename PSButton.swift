//
//  EButton.swift
//  ephemera
//
//  Created by Pranjal Satija on 8/28/15.
//  Copyright © 2015 Pranjal Satija. All rights reserved.
//

import UIKit

class PSButton: UIButton, AlternateColorSchemeWithText {
    var originalBackgroundColor: UIColor?
    @IBInspectable var alternateBackgroundColor: UIColor?
    
    var originalTextColor: UIColor?
    @IBInspectable var alternateTextColor: UIColor?
    
    var colorSchemeManager: ColorSchemeManager {
        get {
            return universalManager
        }
        
        set {
            if newValue.currentColorScheme == .Alternate {
                self.backgroundColor = self.alternateBackgroundColor
                self.setTitleColor(alternateTextColor, forState: .Normal)
            }
        }
    }
    
    var loadingIndicator: PSActivityIndicatorView?
    
    
    ///this override sets the `originalBackgroundColor` property, and adds an NSNotificationCenter observer to listen for transitions
    override func awakeFromNib() {
        setUp()
    }
    
    ///this function sets all the properties that PSColorScheme needs to operate, and must be called manually if instantiating this view programmatically.
    func setUp() {
        self.originalBackgroundColor = self.backgroundColor
        self.originalTextColor = self.titleColorForState(.Normal)
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
            self.backgroundColor = self.originalBackgroundColor
            self.setTitleColor(self.originalTextColor, forState: .Normal)
        }
    }
    
    ///this function is a helper for `transition()`
    func switchToAlternate() {
        UIView.animateWithDuration(colorSchemeTransitionDuration) {
            self.backgroundColor = self.alternateBackgroundColor
            self.setTitleColor(self.alternateTextColor, forState: .Normal)
        }
    }
    
    ///this function replaces the button with a EActivityIndicatorView, to indicate loading
    func showLoading(style: UIActivityIndicatorViewStyle = .WhiteLarge) {
        loadingIndicator = PSActivityIndicatorView(activityIndicatorStyle: style)
        loadingIndicator?.center = self.center
        loadingIndicator?.alternateColor = UIColor.blackColor()
        loadingIndicator?.setUp()
        loadingIndicator?.colorSchemeManager = universalManager
        
        loadingIndicator?.startAnimating()
        self.superview?.addSubview(loadingIndicator!)
        self.hidden = true
    }
    
    ///this function automatically updates the button's text and text color to indicate an error happened
    func showError() {
        self.setTitle("error", forState: .Normal)
        self.setTitleColor(UIColor.redColor(), forState: .Normal)
        self.hideLoading()
    }
    
    ///this function hides `loadingIndicator` if it's present
    func hideLoading() {
        loadingIndicator?.removeFromSuperview()
        self.hidden = false
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}
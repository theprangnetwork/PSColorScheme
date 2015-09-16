# PSColorScheme
A collection of protocols and common UI element subclasses that can easily be used to add an alternate color scheme to your apps. Easily extensible.


# About
PSColorScheme is pretty easy to use. It's being used in the new release of ephemera (http://ephemeraapp.xyz) which I made myself. The app, and this framework, are both still under development, so some UI elements, like UILabel and UITableViewCell, haven't been added, as I haven't gotten to those parts of the app yet. There is still a good bit of stuff available, and it's all pretty easy to use. This README will be done in 2 sections: one with Interface Builder, one without.


# Installation
To keep things simple, just drag and drop the .swift files from inside this repo into your project.


# Usage (Interface Builder)
Start by setting your view's class in the Identity Inspector:

![Identity Inspector](https://github.com/theprangnetwork/PSColorScheme/blob/master/images/identity%20inspector.png)


Then, you can use IBInspectable variables to define the alternate color, and other applicable properties (depending on your view): 

![Properties](https://github.com/theprangnetwork/PSColorScheme/blob/master/images/properties.png)


In your code, use an IBOutlet to set the `colorSchemeManager` property on each view you use that adopts AlternateColorScheme, or one of its sister protocols. You need this to keep your views in sync. Otherwise, you'll have some views using the main scheme, and some using the alternate scheme. My recommendation is to declare a global constant for your whole app, and have all your views use it as their color scheme manager:

```Swift
//universalManager declared as a global
myView.colorSchemeManager = universalManager
```

Once your color scheme managers are set, you get to the fun part: switching schemes! It's really simple. I think a great way to do it is to switch color schemes when the user shakes the device, but that's just my opinion. To switch color schemes, make a call to your color scheme manager's `switchColorScheme()` method. It'll handle posting the notifications, and all properly designed views adopting AlternateColorScheme should respond. That's all! PSColorScheme, by default, vibrates the device when schemes are switched. To cancel the vibration, add the `cancelVibrate` parameter to the `switchColorScheme()` call:

```Swift
universalManager.switchColorScheme(cancelVibrate: true);
```


# Usage (Code)
Start by creating a view that uses AlternateColorScheme:

```Swift 
let myView = PSView()
```

After that, set any applicable properties (they're pretty straightforward, you can take a look at the protocol declaration to see them in detail)

```Swift
myView.alternateBackgroundColor = .blackColor()
```


In your code, set the `colorSchemeManager` property on each view you use that adopts AlternateColorScheme, or one of its sister protocols. You need this to keep your views in sync. Otherwise, you'll have some views using the main scheme, and some using the alternate scheme. My recommendation is to declare a global constant for your whole app, and have all your views use it as their color scheme manager:

```Swift
//universalManager declared as a global
myView.colorSchemeManager = universalManager
```

Once your color scheme managers are set, you get to the fun part: switching schemes! It's really simple. I think a great way to do it is to switch color schemes when the user shakes the device, but that's just my opinion. To switch color schemes, make a call to your color scheme manager's `switchColorScheme()` method. It'll handle posting the notifications, and all properly designed views adopting AlternateColorScheme should respond. That's all! PSColorScheme, by default, vibrates the device when schemes are switched. To cancel the vibration, add the `cancelVibrate` parameter to the `switchColorScheme()` call:

```Swift
universalManager.switchColorScheme(cancelVibrate: true);
```


# Extending
It's pretty easy to extend PSColorScheme. Subclass a UI element, and make it conform to one of the protocols. Be sure to take a look at how the out-of-the-box ones work, so you can get a feel for what has to be implemented, like subscribing to / unsubscribing from NSNotifications, setting up the `transition()` function right, etc.


# Notes
Since I stress having a `universalManager` so much, PSColorScheme comes with one! Just use it in your code, no questions asked. The framework even handles state for you. Just call `universalManager.archive()` any time you want, and it'll save the current scheme to NSUserDefaults. When the app reopens, the `init()` checks and sets the colors of all views appropriately. A few other constants are included, and you can take a look at them at the top of PSColorScheme.swift.

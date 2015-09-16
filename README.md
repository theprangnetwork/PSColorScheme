# PSColorScheme
A collection of protocols and common UI element subclasses that can easily be used to add an alternate color scheme to your apps. Easily extensible.

# Usage
PSColorScheme is pretty easy to use. It's being used in the new release of ephemera (http://ephemeraapp.xyz) which I made myself. The app, and this framework, are both still under development, so some UI elements, like UILabel and UITableViewCell, haven't been added, as I haven't gotten to those parts of the app yet. There is still a good bit of stuff available, and it's all pretty similar to use. To use PSColorScheme, create a PSView. This can be done in code, or in Interface Builder, by setting the view's class in the Identity Inspector:

```Swift 
let myView = PSView(frame: CGRectMake(100, 100, 100, 100))
```

If you use Interface Builder, you can use IBInspectable variables to set the various properties that views adopting AlternateColorScheme need:


# Tweaks (modified)
Tweaks is an easy way to fine-tune an iOS app.

![Tweaks](https://github.com/facebook/Tweaks/blob/master/Images/Tweaks.gif?raw=true)

## Why
The best way to improve an app is to use it every day. Even when ideas can be tested out in advance — for example, with [Origami](http://origami.facebook.com) — it can still take some time with the app to see how it works in practice.

Occasionally, it's perfect the first try. Sometimes, the idea doesn't work at all. But often, it just needs a few minor adjustments. That last case is where Tweaks fits in. Tweaks makes those small adjustments easy: with no code changes and no computer, you can try out different options and decide which works best.

Some of the most useful parameters to adjust are animation timings, velocity thresholds, colors, and physics constants. At Facebook, we also use tweaks to temporarily disable new features during development. That way, the designers and engineers involved can enable it on just their devices, without getting in the way of others testing the app.

Tweaks was invaluable for building [Paper](http://www.facebook.com/paper). We hope it can be useful for your app too.

## Usage
Each configurable value is called a tweak. There's a few ways to set them up, found in `FBTweakInline.h`.

### Value
The simplest way to create a tweak is to replace a constant with `FBTweakValue`:

```objective-c
CGFloat animationDuration = FBTweakValue(@"Category", @"Group", @"Duration", 0.5);
```

The first three parameters are where the tweak is listed and what it's called, and the last one is the default value. You can pass in many types of constants for the default:

```objective-c
if (FBTweakValue(@"Category", @"Feature", @"Enabled", YES)) {
  label.text = FBTweakValue(@"Category", @"Group", @"Text", @"Tweaks example.");
}
```

In release builds, the `FBTweakValue` macro expands to just the default value, so there's no performance impact. In debug builds, though, it fetches the latest value of the tweak.

For numeric tweaks (`NSInteger`, `CGFloat`, and others), you can pass an extra two parameters which are used as the minimum and maximum value for the tweak:

```objective-c
self.red = FBTweakValue(@"Header", @"Colors", @"Red", 0.5, 0.0, 1.0);
```

### Object

```objective-c
UIColor *color = FBTweakObject(@"Category", @"Collection", @"Color", [UIColor colorWithRed:0.25 green:0.87 blue:1.0 alpha:1.0]);
```

### Bind
To make tweaks update live, you can use `FBTweakBindValue`:

```objective-c
FBTweakBindValue(self.carousel, decelerationRate, @"Cover flow", @"Settings", @"Deceleration rate", 0.93);
FBTweakBindValue(audioPlayer, volume, @"Player", @"Audio", @"Volume", 0.9);
FBTweakBindValue(webView.scrollView, scrollEnabled, @"Browser", @"Scrolling", @"Enabled", YES);
```

Or `FBTweakBindObject`:

```objective-c
FBTweakBindObject(self.view, backgroundColor, @"Demo", @"Background", @"Color", [UIColor colorWithWhite:0.9 alpha:1.0]);
```

As with `FBTweakValue`, in release builds `FBTweakBindValue` and `FBTweakBindObject` expands to just setting the property to the default value.

## Action
Actions let you run a (global) block when a tweak is selected. To make one, use `FBTweakAction`:

```objective-c
FBTweakAction(@"Player", @"Audio", @"Volume", ^{
  NSLog(@"Action selected.");
});
```

The first three parameters are the standard tweak listing information, and the last is a block to call. You can use `FBTweakAction` in any scope, but the block must be global: it can't depend on any local or instance variables (it wouldn't know which object to adjust).

Actions are useful for things like launching debug UIs, checking for updates, or (if you make one that intentionally crashes) testing crash reporting.

### Tweaks UI
To configure your tweaks, you need a way to show the configuration UI. There's two options for that:

 - Traditionally, tweaks is activated by shaking your phone. To use that, just replace your root `UIWindow` with a `FBTweakShakeWindow`. If you're using Storyboards, you can override `-window` on your app delegate:

```objective-c
- (UIWindow *)window
{
  if (!_window) {
    _window = [[FBTweakShakeWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  }

  return _window;
}
```

 - You can present a `FBTweakViewController` from anywhere in your app. Be sure to restrict the activation UI to debug builds!
 
#### Tweaks UI Dismiss Notification

Alternatively, when the Tweaks UI is dismissed, you can register your notification center to listen to `FBTweakShakeViewControllerDidDismissNotification`, which can be used after importing `FBTweakViewController.h` 

### Advanced
You can also access the objects that make up the macros mentioned above. That can be useful for more complex scenarios, like adjusting members of a C structure.

For example, to manually create a tweak:

```objective-c
FBIntegerTweak *tweak = [[FBTweak alloc] initWithIdentifier:@"com.tweaks.example.advanced"];
tweak.name = @"Advanced Settings";
tweak.defaultValue = 20;

FBTweakStore *store = [FBTweakStore sharedInstance];
FBTweakCategory *category = [store tweakCategoryWithName:@"Settings"];
FBTweakCollection *collection = [category tweakCollectionWithName:@"Enable"];
[collection addTweak:tweak];

[tweak addObserver:self];
```

Then, you can watch for when the tweak changes:

```objective-c
- (void)tweakDidChange:(FBTweak *)tweak
{
  self.advancedSettingsEnabled = ![tweak.currentValue boolValue];
}
```

To override when tweaks are enabled, you can define the `FB_TWEAK_ENABLED` macro. It's suggested to avoid including them when submitting to the App Store.

### How it works
In debug builds, the tweak macros use `__attribute__((section))` to statically store data about each tweak in the `__FBTweak` section of the mach-o. Tweaks loads that data at startup and loads the latest values from `NSUserDefaults`.

In release builds, the macros just expand to the default value. Nothing extra is included in the binary.

## Contributing
See the CONTRIBUTING file for how to help out.

## License
Tweaks is BSD-licensed. We also provide an additional patent grant.


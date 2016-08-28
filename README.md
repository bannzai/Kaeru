# Kaeru

**Kaeru** can switch ViewController in NavigationController like iOS task manager UI (after iOS 9).

## Movie
![](./KaeruIntroductionResource/iPhone.gif)

## Usage
You can call `self.navigationController?.presentHistory()` in UIViewController sub class. After it, appearance would change like iOS task manager UI.

```
@IBAction func showViewerButtonPressed(sender: AnyObject) {
    navigationController?.presentHistory()
}
```

And it's possible tap each ViewController snap shots.
After it, begin scale animation and called automatically  `UINavigationContoller.popToViewController`.

## Customize
When called `HistoryNavigationController.presentHistory()`,
it's possible to set a custom `backgroundView`.

```
let view = UIView(frame: UIScreen.mainScreen().bounds)
view.backgroundColor = .redColor()
navigationController?.presentHistory(view)
```

This sample code write and run, when `HistoryNavigationController` appear, background becomes red.

## TODO
- [ ] Support cocoapods.
- [ ] Support Carthage.
- [ ] Add delegate methods.


## License

**Kaeru** is available under the MIT license. See the **LICENSE** file for more info.

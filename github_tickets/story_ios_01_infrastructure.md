# Story: Setup iOS-Flutter Hybrid App Infrastructure

## Summary (TLDR)

**Set up foundational infrastructure for combining Flutter and Swift in an iOS app.**

* **Key Setup**:
    * Swift iOS project with UIKit tab bar controller
    * Flutter module properly embedded in iOS
    * FlutterEngine configuration and management
    * Method channels for basic Swift-Flutter communication
* **Goal**: Create working project structure optimized for iOS Simulator
* **Time Estimates**:
    * For developer with limited iOS/Swift experience: **15-20 hours**
    * For experienced iOS/Swift developer: **8-12 hours**

## Description

Set up the foundational infrastructure for a hybrid Swift-Flutter application with a tab bar
navigation. This includes initializing the iOS Swift project, creating a Flutter module, and
establishing basic communication between the two.

## Requirements

- Initialize iOS Swift project with UIKit
- Create Flutter module that can be embedded in iOS
- Implement basic tab bar controller with 5 tabs in UIKit
- Configure Flutter embedding in iOS using FlutterEngine
- Set up method channels for basic communication between Swift and Flutter
- Optimize for iOS Simulator testing

## Technical Tasks

- [ ] Create iOS project with appropriate architecture (MVC or MVVM)
- [ ] Set up Flutter module with proper configuration
- [ ] Configure FlutterEngine initialization in AppDelegate
- [ ] Implement UITabBarController with 5 tabs
- [ ] Create FlutterViewController wrapper for Flutter embedding
- [ ] Set up FlutterMethodChannel for communication
- [ ] Create stub implementations for all 5 tab screens
- [ ] Ensure proper tab switching with state preservation
- [ ] Configure workspace for easy Simulator testing
- [ ] Create documentation for project setup and architecture

## Implementation Details

```swift
// Example AppDelegate.swift configuration for FlutterEngine
import UIKit
import Flutter
import FlutterPluginRegistrant

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Flutter engine
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        
        return true
    }
}

// Example TabBarController implementation
class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure tab bar appearance
        tabBar.tintColor = UIColor.systemBlue
        
        // Create view controllers for tabs
        let myTab = MyTabViewController()
        let billingTab = createFlutterViewController(withInitialRoute: "/billing")
        let dashboardTab = DashboardTabViewController()
        let itemsTab = createFlutterViewController(withInitialRoute: "/items")
        let thTifTab = createFlutterViewController(withInitialRoute: "/thtif")
        
        // Set tab bar items
        myTab.tabBarItem = UITabBarItem(title: "My", image: UIImage(systemName: "person"), tag: 0)
        billingTab.tabBarItem = UITabBarItem(title: "Billing", image: UIImage(systemName: "creditcard"), tag: 1)
        dashboardTab.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "chart.bar"), tag: 2)
        itemsTab.tabBarItem = UITabBarItem(title: "Items", image: UIImage(systemName: "list.bullet"), tag: 3)
        thTifTab.tabBarItem = UITabBarItem(title: "ThTif", image: UIImage(systemName: "arrow.left.arrow.right"), tag: 4)
        
        // Set view controllers
        viewControllers = [myTab, billingTab, dashboardTab, itemsTab, thTifTab]
    }
    
    private func createFlutterViewController(withInitialRoute route: String) -> FlutterViewController {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterViewController.setInitialRoute(route)
        return flutterViewController
    }
}
```

## Acceptance Criteria

- [ ] iOS app builds and launches successfully in Simulator
- [ ] Flutter module builds and can be displayed within the iOS app
- [ ] Tab bar displays with 5 tabs (My, Billing, Dashboard, Items, ThTif)
- [ ] Basic navigation between tabs works
- [ ] Simple data can be passed between Swift and Flutter
- [ ] Project structure supports future development of complex features
- [ ] Documentation covers setup process for new team members

## Dependencies

- None (first story in the epic)

## Notes

This story focuses only on setting up the infrastructure and does not include implementation of the
specific tab functionalities or complex navigation patterns. These will be addressed in subsequent
stories. For developers with limited iOS/Swift experience, it will be important to understand the
basics of UIKit navigation and tab bar controllers before proceeding.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** High
- **LOE with Firebender using Gemini 2.5 Pro:** Medium-High

### Project Metrics for Developer with Limited iOS/Swift Experience (Scale 1-10)

- **Likelihood of Success:** 7/10
- **Likelihood of Frustration:** 7/10
- **Likelihood of Manual Steps:** 8/10

### Project Metrics for Experienced iOS/Swift Developer (Scale 1-10)

- **Likelihood of Success:** 9/10
- **Likelihood of Frustration:** 4/10
- **Likelihood of Manual Steps:** 7/10

### Time Estimates

- **For developer with limited iOS/Swift experience:** 15-20 hours
- **For experienced iOS/Swift developer:** 8-12 hours

### Notes

For a Flutter developer with limited iOS/Swift experience, the main challenges will be:

1. Understanding iOS project structure and architecture patterns
2. Configuring the FlutterEngine correctly for embedding
3. Managing view controller lifecycle with Flutter integration

Key resources to reference:

- [Flutter's official Add-to-App documentation for iOS](https://flutter.dev/docs/development/add-to-app/ios/project-setup)
- [UIKit Tab Bar Controller documentation](https://developer.apple.com/documentation/uikit/uitabbarcontroller)

Focus on getting the basic structure working in the Simulator before adding more complex features.
The iOS Simulator is particularly well-suited for rapid development cycles, as it avoids the code
signing and provisioning requirements of physical devices.
# Reddit Posts Viewer

Reddit Posts Viewer is an iOS application that allows you to view Reddit posts in a list format. As you scroll through the list, more posts are loaded. The app also includes an onboarding carousel to request permissions for camera, push notifications, and location services. Additionally, it provides a search functionality to find posts of interest.

## Requirements

Xcode 13+
iOS 16.0+
Swift 5.5+
Getting Started

To get started with the project, clone the repository and open the .xcworkspace file in Xcode.

```ogdl
git clone https://github.com/yourusername/reddit-posts-viewer.git
cd reddit-posts-viewer
open RedditPostsViewer.xcworkspace
```
## Dependencies

The project uses CocoaPods as a dependency manager. The following pods are included:

Alamofire (5.4.0+): A networking library for making HTTP requests
AlamofireImage (4.1.0+): An image component library for Alamofire
KeychainSwift (23.0.0+): A helper library for working with the iOS Keychain
Make sure you have CocoaPods installed on your machine. If not, run the following command:

```ogdl
sudo gem install cocoapods
```
Next, navigate to the project directory and run:

```ogdl
pod install
```

After installing the dependencies, open the RedditPostsViewer.xcworkspace file to work on the project.

## Architecture

The project follows the Model-View-Controller (MVC) design pattern. This pattern separates the application logic into three interconnected components:

Model: Represents the data and business logic of the application
View: Displays the data to the user and receives user interactions
Controller: Acts as an intermediary between the Model and View, updating the Model with user interactions and updating the View with new data

## Initialization Process

The application begins by displaying an onboarding carousel to request permissions for camera, push notifications, and location services. The user can grant or deny these permissions.

Once the onboarding process is complete, the main view displays a list of Reddit posts. As the user scrolls through the list, more posts are loaded. Users can also search for specific posts using the search bar.

## Unit Tests

The project includes unit tests for some key components, such as the PushNotificationsViewController and the LocationViewController. These tests ensure that the view controllers load correctly, user preferences are stored properly, and the UI elements are present.

To run the unit tests, select the test target in Xcode and click the "Run Tests" button or use the keyboard shortcut Cmd + U.

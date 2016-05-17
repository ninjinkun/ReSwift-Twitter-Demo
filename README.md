# ReSwift Twitter Demo
A [ReSwift](https://github.com/ReSwift/ReSwift) example.

<img src="https://cloud.githubusercontent.com/assets/113420/15327976/507c0348-1c8e-11e6-8214-4b5f0b3fd915.gif" width="317">

# Build

To build:

1. Rename `ReSwift-Twitter/Resources/Fabric.xcconfig.sample` to `ReSwift-Twitter/Resources/Fabric.xcconfig`.
2. Fill your Fabric API key, Twitter consumer key and secret into `app/ReSwift-Twitter/Resources/Fabric.xcconfig`.
  - If you don't have those keys, you should refer [this page](https://fabric.io/kits/ios/twitterkit/install).
3. Run following commands.

    ```
    $ pod install
    $ carthage bootstrap --no-use-binaries --platform ios
    ```

4. Open `ReSwift-Twitter.xcworkspace` in Xcode.


# Licence

[MIT Licence](https://opensource.org/licenses/mit-license).

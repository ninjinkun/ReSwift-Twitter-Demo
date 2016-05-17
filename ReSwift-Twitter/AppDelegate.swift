import UIKit
import TwitterKit
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Twitter.self])
        if let session = Twitter.sharedInstance().sessionStore.session() {
            store.dispatch(AuthSessionState.LoadAuthSessionAction(session: session))
        }
        return true
    }
}


import UIKit
import FontAwesome

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = tabBar.items {
            let icons: [FontAwesome] = [.ClockO, .HeartO]
            for (item, icon) in zip(items, icons) {
                let image = UIImage.fontAwesomeIconWithName(icon, textColor: UIColor.blackColor(), size: CGSize(width: 30, height: 30))
                item.image = image
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if store.state.session.session == nil {
            performSegueWithIdentifier("LoginViewController", sender: nil)
        }
    }
}
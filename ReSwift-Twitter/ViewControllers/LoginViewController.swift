import UIKit
import TwitterKit


class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: TWTRLogInButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.logInCompletion = { [weak self] (session, error) in
            if let session = session {
                store.dispatch(AuthSessionState.LoadAuthSessionAction(session: session))
                self?.dismissViewControllerAnimated(true, completion: nil)
            } else if let error = error {
                store.dispatch(AuthSessionState.ErrorAuthSessionAction(error: error))
            }
        }
    }
}
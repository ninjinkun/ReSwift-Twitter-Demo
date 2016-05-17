import ReSwift
import TwitterKit

extension AuthSessionState {
    struct LoadAuthSessionAction: Action {
        let session: TWTRAuthSession
    }

    struct ErrorAuthSessionAction: Action {
        let error: NSError
    }
}
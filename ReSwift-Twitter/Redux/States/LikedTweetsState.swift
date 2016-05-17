import TwitterKit

protocol TweetsState {
    var fetchStatus: FetchStatus { get set }
    var tweets: [TWTRTweet]? { get set }
    var error: NSError? { get set }
    var sinceId: String? { get set }
    var maxId: String? { get set }
}

struct LikedTweetsState: TweetsState {
    var fetchStatus: FetchStatus = .Initial
    var tweets: [TWTRTweet]?
    var error: NSError?
    var sinceId: String?
    var maxId: String?
}

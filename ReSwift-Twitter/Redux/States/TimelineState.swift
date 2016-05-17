import TwitterKit

struct TimelineState: TweetsState {
    var fetchStatus: FetchStatus = .Initial
    var tweets: [TWTRTweet]?
    var error: NSError?
    var sinceId: String?
    var maxId: String?
}
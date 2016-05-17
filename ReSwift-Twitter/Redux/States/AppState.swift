import ReSwift

struct AppState: StateType {
    var session = AuthSessionState()
    var timeline = TimelineState()
    var likedTweets = LikedTweetsState()
}

import ReSwift
import TwitterKit

extension TimelineState {
    struct Reducer: ReSwift.Reducer {
        typealias ReducerStateType = AppState
        func handleAction(action: Action, state: ReducerStateType?) -> ReducerStateType {
            let prevState = state ?? AppState()
            let prevTimeineState = prevState.timeline
            var nextState = prevState
            var nextTimelineState = nextState.timeline

            switch action {
            case is RequestGetTimelineAction:
                nextTimelineState.fetchStatus = .Fetching

            case let action as ResponseGetTimelineAction:
                nextTimelineState.fetchStatus = .Success
                nextTimelineState.tweets = prevTimeineState.fetchStatus == .Refresh ? action.tweets : TweetsReducerHelper.mergeTweets(prevTimeineState.tweets, nextTweets: action.tweets)
                nextTimelineState.sinceId = nextTimelineState.tweets?.first?.tweetID
                nextTimelineState.maxId = nextTimelineState.tweets?.last?.tweetID

            case let action as ErrorGetTimelineAction:
                nextTimelineState.fetchStatus = .Error
                nextTimelineState.error = action.error

            case let action as LikedTweetsState.ResponsePostLikeAction:
                if let tweets = nextTimelineState.tweets {
                    nextTimelineState.tweets = TweetsReducerHelper.updateLikedTweet(tweets, likedTweet: action.tweet)
                }

            case let action as LikedTweetsState.ResponseDeleteLikeAction:
                if let tweets = nextTimelineState.tweets {
                    nextTimelineState.tweets = TweetsReducerHelper.updateLikedTweet(tweets, likedTweet: action.tweet)
                }

            default:
                break
            }

            nextState.timeline = nextTimelineState
            return nextState
        }
    }
}
import ReSwift

extension LikedTweetsState {
    struct Reducer: ReSwift.Reducer {
        typealias ReducerStateType = AppState
        func handleAction(action: Action, state: ReducerStateType?) -> ReducerStateType {
            let prevState = state ?? AppState()
            let prevLikedTweetsState = prevState.likedTweets
            var nextState = prevState
            var nextLikedTweetsState = prevLikedTweetsState

            switch action {
            case is RequestGetLikeTweetsAction:
                nextLikedTweetsState.fetchStatus = .Fetching

            case let action as ResponseGetLikeTweetsAction:
                nextLikedTweetsState.fetchStatus = .Success
                nextLikedTweetsState.tweets = TweetsReducerHelper.mergeTweets(prevLikedTweetsState.tweets, nextTweets: action.tweets)
                nextLikedTweetsState.sinceId = nextLikedTweetsState.tweets?.first?.tweetID
                nextLikedTweetsState.maxId = nextLikedTweetsState.tweets?.last?.tweetID

            case let action as ErrorGetLikeTweetsAction:
                nextLikedTweetsState.fetchStatus = .Error
                nextLikedTweetsState.error = action.error

            case let action as ResponsePostLikeAction:
                if let prevTweets = prevLikedTweetsState.tweets {
                    var nextTweets = TweetsReducerHelper.updateLikedTweet(prevTweets, likedTweet: action.tweet)
                    nextTweets = TweetsReducerHelper.insertLikedTweet(nextTweets, likedTweet: action.tweet)
                    nextLikedTweetsState.tweets = nextTweets
                }

            case let action as ResponseDeleteLikeAction:
                if let prevTweets = prevLikedTweetsState.tweets {
                    nextLikedTweetsState.tweets = TweetsReducerHelper.removeLikedTweet(prevTweets, likedTweet: action.tweet)
                }

            default:
                break
            }

            nextState.likedTweets = nextLikedTweetsState

            return nextState
        }
    }
}
import TwitterKit

struct TweetsReducerHelper {
    static func mergeTweets(prevTweets: [TWTRTweet]?, nextTweets: [TWTRTweet]?) -> [TWTRTweet] {
        return ((prevTweets ?? [])  + (nextTweets ?? [])).reduce([]) { (tweets, tweet) in
            return tweets.contains(tweet) ? tweets : tweets + [tweet]
            }.sort { $0.createdAt.compare($1.createdAt) == .OrderedDescending }
    }

    static func updateLikedTweet(prevTweets: [TWTRTweet], likedTweet: TWTRTweet) -> [TWTRTweet] {
        var nextTweets = prevTweets
        if let index = prevTweets.indexOf({ $0.tweetID == likedTweet.tweetID }) {
            nextTweets[index] = likedTweet
        }
        return nextTweets
    }

    static func insertLikedTweet(prevTweets: [TWTRTweet], likedTweet: TWTRTweet) -> [TWTRTweet] {
        var nextTweets = prevTweets
        if prevTweets.indexOf({ $0.tweetID == likedTweet.tweetID }) == nil {
            nextTweets = mergeTweets(prevTweets, nextTweets: [likedTweet])
        }
        return nextTweets
    }

    static func removeLikedTweet(prevTweets: [TWTRTweet], likedTweet: TWTRTweet) -> [TWTRTweet] {
        return prevTweets.filter { $0.tweetID != likedTweet.tweetID }
    }
}
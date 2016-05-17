import ReSwift
import TwitterKit

extension LikedTweetsState {
    struct RequestGetLikeTweetsAction: Action {}
    struct ResponseGetLikeTweetsAction: Action {
        let tweets: [TWTRTweet]
    }
    struct ErrorGetLikeTweetsAction: Action {
        let error: NSError
    }

    struct RequestPostLikeAction: Action {
        let tweetId: String
    }
    struct ResponsePostLikeAction: Action {
        let tweet: TWTRTweet
    }
    struct ErrorPostLikeAction: Action {
        let error: NSError
    }

    struct RequestDeleteLikeAction: Action {
        let tweetId: String
    }
    struct ResponseDeleteLikeAction: Action {
        let tweet: TWTRTweet
    }
    struct ErrorDeleteLikeAction: Action {
        let error: NSError
    }
}

extension LikedTweetsState {
    static func fetchLikedTweets(sinceId: String?, maxId: String?) -> Store<AppState>.AsyncActionCreator  {
        return { (state, store, callback) in
            store.dispatch(RequestGetLikeTweetsAction())

            let client = TWTRAPIClient.clientWithCurrentUser()
            let statusesShowEndpoint = "https://api.twitter.com/1.1/favorites/list.json"
            var clientError : NSError?

            var params: [String: AnyObject] = [ : ]
            if let maxId = maxId {
                params["max_id"] = maxId
            }
            if let sinceId = sinceId {
                params["since_id"] = sinceId
            }

            let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)

            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if let connectionError = connectionError {
                    store.dispatch(ErrorGetLikeTweetsAction(error: connectionError))
                } else {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        if let array = json as? [[String :AnyObject]] {
                            let tweets = array.map { TWTRTweet(JSONDictionary: $0)! }
                            callback { _,_ in ResponseGetLikeTweetsAction(tweets: tweets) }
                        }
                    } catch let jsonError as NSError {
                        callback { _,_ in ErrorGetLikeTweetsAction(error: jsonError) }
                    }
                }
            }
        }
    }

    static func postLike(tweetId: String) -> Store<AppState>.AsyncActionCreator  {
        return { (state, store, callback) in
            store.dispatch(RequestPostLikeAction(tweetId: tweetId))

            let client = TWTRAPIClient.clientWithCurrentUser()
            let statusesShowEndpoint = "https://api.twitter.com/1.1/favorites/create.json"
            var clientError : NSError?

            let params: [String: AnyObject] = ["id" : tweetId ]

            let request = client.URLRequestWithMethod("POST", URL: statusesShowEndpoint, parameters: params, error: &clientError)

            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if let connectionError = connectionError {
                    store.dispatch(ErrorPostLikeAction(error: connectionError))
                } else {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        if let json = json as? [String :AnyObject], tweet = TWTRTweet(JSONDictionary: json) {
                            callback { _,_ in ResponsePostLikeAction(tweet: tweet) }
                        }
                    } catch let jsonError as NSError {
                        callback { _,_ in ErrorPostLikeAction(error: jsonError) }
                    }
                }
            }
        }
    }

    static func deleteLike(tweetId: String) -> Store<AppState>.AsyncActionCreator  {
        return { (state, store, callback) in
            store.dispatch(RequestDeleteLikeAction(tweetId: tweetId))

            let client = TWTRAPIClient.clientWithCurrentUser()
            let statusesShowEndpoint = "https://api.twitter.com/1.1/favorites/destroy.json"
            var clientError : NSError?

            let params: [String: AnyObject] = ["id" : tweetId ]

            let request = client.URLRequestWithMethod("POST", URL: statusesShowEndpoint, parameters: params, error: &clientError)

            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if let connectionError = connectionError {
                    store.dispatch(ErrorDeleteLikeAction(error: connectionError))
                } else {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        if let json = json as? [String :AnyObject], tweet = TWTRTweet(JSONDictionary: json) {
                            callback { _,_ in ResponseDeleteLikeAction(tweet: tweet) }
                        }
                    } catch let jsonError as NSError {
                        callback { _,_ in ErrorDeleteLikeAction(error: jsonError) }
                    }
                }
            }
        }
    }
}
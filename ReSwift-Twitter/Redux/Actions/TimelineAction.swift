import ReSwift
import TwitterKit

extension TimelineState {
    struct RequestGetTimelineAction: Action {}

    struct ResponseGetTimelineAction: Action {
        let tweets: [TWTRTweet]
    }

    struct ErrorGetTimelineAction: Action {
        let error: NSError
    }
}

extension TimelineState {
    static func fetchTimeline(sinceId: String?, maxId: String?) -> Store<AppState>.AsyncActionCreator  {
        return { (state, store, callback) in
            store.dispatch(RequestGetTimelineAction())
            let client = TWTRAPIClient.clientWithCurrentUser()
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
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
                    callback { _,_ in ErrorGetTimelineAction(error: connectionError)}
                } else {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        if let array = json as? [[String :AnyObject]] {
                            let tweets = array.map { TWTRTweet(JSONDictionary: $0)! }
                            callback { _,_ in ResponseGetTimelineAction(tweets: tweets) }
                        }
                    } catch let jsonError as NSError {
                        callback { _,_ in ErrorGetTimelineAction(error: jsonError)}
                    }
                }
            }
        }
    }
}

import UIKit
import TwitterKit
import ReSwift

class LikedTweetsViewController: UITableViewController {
    var tweets: [TWTRTweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self)

        if store.state.session.session != nil && store.state.likedTweets.fetchStatus == .Initial {
            fetchRecentTweets()
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    func refresh(sender: AnyObject) {
        fetchRecentTweets()
    }

    func fetchRecentTweets() {
        if store.state.likedTweets.fetchStatus != .Fetching {
            store.dispatch(LikedTweetsState.fetchLikedTweets(store.state.likedTweets.sinceId, maxId: nil))
        }
    }

    func fetchPastTweets() {
        if store.state.likedTweets.fetchStatus != .Fetching && store.state.likedTweets.maxId != nil {
            store.dispatch(LikedTweetsState.fetchLikedTweets(nil, maxId: store.state.likedTweets.maxId))
        }
    }
}

extension LikedTweetsViewController: StoreSubscriber {
    func newState(state: AppState) {
        if state.likedTweets.fetchStatus != .Fetching {
            refreshControl?.endRefreshing()
        }

        self.tweets = state.likedTweets.tweets
        // In production, you should calucurate entries' diff and udpate each cells.
        tableView.reloadData()
    }
}

// UIScrollViewDelegate
extension LikedTweetsViewController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if(tableView.contentOffset.y >= (tableView.contentSize.height - tableView.bounds.size.height)) {
            fetchPastTweets()
        }
    }
}

// UITableViewDataSource
extension LikedTweetsViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)
        guard let tweetCell = cell as? TweetCell, tweets = tweets else {
            return cell
        }

        let tweet = tweets[indexPath.row]
        tweetCell.tweet = tweet
        tweetCell.delegate = self
        return tweetCell
    }
}

extension LikedTweetsViewController: TweetCellLikeButtonDelegate {
    func likeButtonPushed(cell: TweetCell) {
        let tweet = cell.tweet
        if tweet.isLiked {
            store.dispatch(LikedTweetsState.deleteLike(tweet.tweetID))
        } else {
            store.dispatch(LikedTweetsState.postLike(tweet.tweetID))
        }
    }
}

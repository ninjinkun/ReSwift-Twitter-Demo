import UIKit
import TwitterKit
import Kingfisher

protocol TweetCellLikeButtonDelegate: class {
    func likeButtonPushed(cell: TweetCell)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var likeButton: LikeButton!
    weak var delegate: TweetCellLikeButtonDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        likeButton.addTarget(self, action: #selector(likeButtonPushed), forControlEvents: .TouchUpInside)
    }

    var tweet: TWTRTweet! {
        didSet {
            render(tweet)
        }
    }

    func render(tweet: TWTRTweet) {
        if let url = NSURL(string: tweet.author.profileImageURL) {
            userImageView.kf_setImageWithURL(url)
        }
        screenNameLabel.text = tweet.author.screenName
        messageLabel.text = tweet.text
        likeButton.setLike(tweet.isLiked, animated: false)
        setNeedsLayout()
    }

    func likeButtonPushed(sender: AnyObject) {
        delegate?.likeButtonPushed(self)
    }
}
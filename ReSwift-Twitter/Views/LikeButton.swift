import UIKit
import FontAwesome

class LikeButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setLike(false, animated: false)
    }

    func setLike(like: Bool, animated: Bool) {
        if like {
            let image = UIImage.fontAwesomeIconWithName(.Heart, textColor: UIColor(red: 0.88, green: 0.16, blue: 0.31, alpha: 1.0), size: CGSize(width: 20, height: 20))
            setImage(image, forState: .Normal)
        } else {
            let image = UIImage.fontAwesomeIconWithName(.Heart, textColor: UIColor.lightGrayColor(), size: CGSize(width: 20, height: 20))
            setImage(image, forState: .Normal)
        }
    }
}
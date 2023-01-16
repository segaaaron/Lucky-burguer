//
//  ListCell.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit

final class ListCell: UITableViewCell {

    //MARK: Cell Outlets
    
    @IBOutlet weak var brandLabel: UILabel! {
        didSet {
            brandLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
            brandLabel.textColor = UIColor.grayText
        }
    }
    @IBOutlet weak var smallImage: UIImageView! {
        didSet {
            smallImage.image = UIImage(named: "small_heart")
        }
    }
    @IBOutlet weak var favoriteCountLabel: UILabel! {
        didSet {
            favoriteCountLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
            favoriteCountLabel.textColor = UIColor.grayText
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            titleLabel.textColor = UIColor.blackText
        }
    }
    @IBOutlet weak var tagLabel: UILabel! {
        didSet {
            tagLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
            tagLabel.textColor = UIColor.grayText
        }
    }
    
    @IBOutlet weak var mainImage: UIImageView! {
        didSet {
            mainImage.image = UIImage(named: "default_image")
            mainImage.contentMode = .scaleAspectFit
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(model: Item, counterLikes: String) {
        brandLabel.text = model.brand?.uppercased()
        titleLabel.text = model.title
        tagLabel.text = model.tags
        favoriteCountLabel.text = counterLikes
        
        if let currentImage = model.imageURL {
            mainImage.asyncImage(with: currentImage, name: currentImage)
        } else {
            mainImage.image = UIImage(named: "default_image")
        }
    }
}

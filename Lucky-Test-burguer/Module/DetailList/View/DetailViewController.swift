//
//  DetailViewController.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel! {
        didSet {
            brandLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            brandLabel.textColor = UIColor.grayText
        }
    }
    @IBOutlet weak var smallImage: UIImageView! {
        didSet {
            smallImage.image = UIImage(named: "small_heart")
        }
    }
    @IBOutlet weak var favoriteCounterLabel: UILabel! {
        didSet {
            favoriteCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
            favoriteCounterLabel.textColor = UIColor.grayText
            favoriteCounterLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .light)
            titleLabel.textColor = UIColor.blackText
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            descriptionLabel.textColor = UIColor.blackText
            descriptionLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var oldPrice: UILabel! {
        didSet {
            oldPrice.font = UIFont.systemFont(ofSize: 14, weight: .light)
            oldPrice.textColor = UIColor.grayScale
            oldPrice.numberOfLines = 1
        }
    }
    @IBOutlet weak var newPrice: UILabel! {
        didSet {
            newPrice.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            newPrice.textColor = UIColor.blackText
            newPrice.numberOfLines = 1
        }
    }
    @IBOutlet weak var expirationDateLabel: UILabel! {
        didSet {
            expirationDateLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
            expirationDateLabel.textColor = UIColor.grayText
            expirationDateLabel.numberOfLines = 1
        }
    }
    @IBOutlet weak var redmentionsLabel: UILabel! {
        didSet {
            redmentionsLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            redmentionsLabel.textColor = UIColor.blackText
            redmentionsLabel.numberOfLines = 1
        }
    }
    
    private var imageHeight: NSLayoutConstraint?
    private var showImageAnimate: Bool = false {
        didSet {
            showAnimateImage(with: showImageAnimate)
        }
    }
    
    private lazy var animateImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "white_heart")
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var viewModel: DetailViewModel
    private var isLike: Bool = false
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = DetailViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButton()
        animateImageSetup()
        setupObjc()
    }
    
    private func createBarButton() {
        let likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        selectSaveCard(with: false, button: likeButton)
        likeButton.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
    }
    
    private func animateImageSetup() {
        imageContainerView.addSubview(animateImage)
        imageHeight = animateImage.heightAnchor.constraint(equalToConstant: 50)
        imageHeight?.isActive = true
        NSLayoutConstraint.activate([
            animateImage.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            animateImage.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            animateImage.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupObjc() {
        if let obj = viewModel.detailObjc.value {
            loadObject(model: obj)
        }
    }
    
    private func loadObject(model: Item) {
        let text = model.oldValue ?? ""
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        brandLabel.text = model.brand?.uppercased()
        let currentFavoriteCounter: Double = Double(model.favoriteCount ?? 0)
        favoriteCounterLabel.text = Utilities().convertLikes(num: currentFavoriteCounter)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        oldPrice.attributedText = attributeString
        newPrice.text = model.newValue
        expirationDateLabel.text = Utilities().formatDate(with: model.expDate ?? "")
        redmentionsLabel.text = "REDEMPTIONS CAP: \(model.timeRedemptions ?? 0) TIMES"
        
        if let currentImage = model.imageURL {
            foodImage.asyncImage(with: currentImage, name: currentImage)
        }
    }
    
    private func showAnimateImage(with isShow: Bool) {
        if isShow {
            let midx = self.imageContainerView.frame.height/2
            let midy = self.imageContainerView.frame.width/2
            self.animateImage.frame = CGRect(x: midx, y: midy, width: 25, height: 25)
            UIView.animate(withDuration: 2,
                           delay: 0.5,
                           options: [.curveEaseInOut],
                           animations: {
                self.animateImage.isHidden = false
                    self.animateImage.frame = CGRect(x: 0, y: midy, width: 300, height: 50)
                self.imageHeight?.constant = 80
                self.animateImage.layoutIfNeeded()
            }, completion: { _ in
                self.animateImage.isHidden = true
            })
        }
    }
    
    @objc func likeButtonAction(_ sender: UIButton) {
        isLike = !isLike
        selectSaveCard(with: isLike, button: sender)
        showImageAnimate = isLike
    }
    
    private func selectSaveCard(with isFavorite: Bool, button: UIButton) {
        let likeButtonImage = UIImage(named: isFavorite ? "fill_heart_icon" : "empty_heart_icon")
        button.setImage(likeButtonImage, for: .normal)
    }
}

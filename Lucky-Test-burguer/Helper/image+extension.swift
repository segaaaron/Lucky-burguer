//
//  image+extension.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit
import ImageIO

extension UIImage {
    func resizeImage(_ width: CGFloat, _ height:CGFloat) -> UIImage? {
        let widthRatio  = width / size.width
        let heightRatio = height / size.height
        let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeCompressImage(image:UIImage, withSize:CGSize) -> UIImage {
        var actualHeight:CGFloat = image.size.height
        var actualWidth:CGFloat = image.size.width
        let maxHeight:CGFloat = withSize.height
        let maxWidth:CGFloat = withSize.width
        var imgRatio:CGFloat = actualWidth/actualHeight
        let maxRatio:CGFloat = maxWidth/maxHeight
        let compressionQuality = 0.5
        if (actualHeight>maxHeight) || (actualWidth>maxWidth ){
            if imgRatio < maxRatio {
                imgRatio = maxHeight/actualHeight
                actualWidth = floor(imgRatio * actualWidth)
                actualHeight = maxHeight
            }else if imgRatio>maxRatio {
                imgRatio = maxWidth/actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }else{
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rec:CGRect = CGRect(x:0.0, y:0.0, width:actualWidth, height:actualHeight)
        UIGraphicsBeginImageContext(rec.size)
        image.draw(in: rec)
        if let image:UIImage = UIGraphicsGetImageFromCurrentImageContext(),
           let imageData = image.jpegData(compressionQuality: CGFloat(compressionQuality)),
           let resizedimage = UIImage(data: imageData) {
            UIGraphicsEndImageContext()
            return resizedimage
        }
        return UIImage()
    }
}

extension UIImageView {
    func asyncImage(with image: String, name: String) {
        Network.downloadImageCache(image, nameKey: name) { [weak self] img in
            DispatchQueue.main.async {
                self?.image = img
            }
        }
    }
    
    func setImageAnimated(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.9 : 0.0
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
}

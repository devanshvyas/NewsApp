//
//  UIImageView.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import Kingfisher
import UIKit

extension UIImageView {
    /// Download Image and Set into ImageView
    func setImage(imageURL: String?, placeholderImage: UIImage? =  nil, showPlaceHolder: Bool = true, indicatorStyle: UIActivityIndicatorView.Style = .medium) {
        if let imageString = imageURL, let url = URL(string: imageString) {
            image = nil
            var kingFisher = self.kf
            kingFisher.indicatorType = .activity
            let activity = kingFisher.indicator?.view as? UIActivityIndicatorView
            activity?.style = indicatorStyle
            activity?.color = .white
            kingFisher.setImage(
                with: url,
                placeholder: placeholderImage,
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage]) { result in
                        print(result)
            }
        } else {
            if showPlaceHolder {
                self.image = placeholderImage
            }
        }
    }
}

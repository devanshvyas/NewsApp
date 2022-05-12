//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    var news: News? {
        didSet {
            newsImage.setImage(imageURL: news?.urlToImage)
            if let author = news?.author, !author.isEmpty {
                var authorString = "By \(author)"
                if let pubDate = news?.publishedAt {
                    authorString += " at " + formattedDate(pubDate)
                }
                authorLabel.text = authorString
            } else {
                authorLabel.isHidden = true
            }
            titleLabel.text = news?.title
            descLabel.text = news?.articleDescription
            linkButton.setTitle(news?.url ?? "Not available", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailView.roundCorners(corners: [.topRight, .topLeft], radius: 30)
    }
    
    @IBAction func linkTapped(_ sender: UIButton) {
        guard let url = URL(string: news?.url ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    func formattedDate(_ value: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: value)!
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}

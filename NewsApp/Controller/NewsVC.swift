//
//  NewsVC.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import UIKit

class NewsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var currentIndexPath: IndexPath?
    var articles: [News] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        CoreDataManager.shared.fetchNews { newsData in
            self.articles = newsData
        }
        
    }
    
    @IBAction func upGesture(_ sender: UISwipeGestureRecognizer) {
        print("up")
        guard currentIndexPath != nil else {
            return
        }
        DispatchQueue.main.async {
            let nextIndexPath = self.currentIndexPath!.row + 1
            if nextIndexPath <= self.articles.count - 2 {
                self.currentIndexPath = IndexPath(row: nextIndexPath, section: 0)
                self.tableView.scrollToRow(at: self.currentIndexPath!, at: .none, animated: true)
            }
        }
    }
    
    @IBAction func downGesture(_ sender: UISwipeGestureRecognizer) {
        print("down")
        guard currentIndexPath != nil else {
            return
        }
        DispatchQueue.main.async {
            let nextIndexPath = self.currentIndexPath!.row - 1
            if nextIndexPath >= 0 {
                self.currentIndexPath = IndexPath(row: nextIndexPath, section: 0)
                self.tableView.scrollToRow(at: self.currentIndexPath!, at: .none, animated: true)
            }
        }
    }
    
    func getData() {
        NetworkHelper.shared.getNews { news in
            let newsObjs = news?.articles ?? []
            let mappedNewsObj = newsObjs.map({ $0.toNews() })
            
            var newNews: [News] = []
            for obj in mappedNewsObj {
                if !self.articles.contains(where: {$0.title == obj.title}) {
                    self.articles.insert(obj, at: 0)
                    newNews.append(obj)
                }
            }
            CoreDataManager.shared.updateNews(newNews)
        }
    }
}


extension NewsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell
        else { return UITableViewCell() }
        cell.news = articles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        currentIndexPath = indexPath
    }
}

extension NewsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
}

extension NewsVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

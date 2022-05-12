//
//  News.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import Foundation

// MARK: - News
class NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]

    init(status: String, totalResults: Int, articles: [Article]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

// MARK: - Article
class Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }

    init(source: Source, author: String?, title: String?, articleDescription: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    func toNews() -> News {
        let news = News(context: CoreDataManager.shared.persistentContainer.viewContext)
        news.title = title
        news.urlToImage = urlToImage
        news.articleDescription = articleDescription
        news.author = author
        news.url = url
        news.publishedAt = publishedAt
        return news
    }
}

// MARK: - Source
class Source: Codable {
    let id: String?
    let name: String?

    init(id: String?, name: String) {
        self.id = id
        self.name = name
    }
}

//
//  CoredataManager.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchNews(completion: @escaping ([News]) -> ()) {
        let context = persistentContainer.viewContext
        let req = NSFetchRequest<News>(entityName: "News")
        do {
            let news = try context.fetch(req)
            completion(news)
        } catch let err as NSError {
            print("====== error =======", err.localizedDescription)
            completion([])
        }
    }
    
    func setNews(_ data: News) {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "News", in: context) else {
            return
        }
        let news = News(entity: entity, insertInto: context)
        news.title = data.title
        news.urlToImage = data.urlToImage
        news.articleDescription = data.articleDescription
        news.author = data.author
        news.url = data.url
        news.publishedAt = news.publishedAt
//        saveContext()
    }
    
    func updateNews(_ data: [News]) {
        fetchNews { allNews in
            var shouldSave = false
            for (idx, news) in data.enumerated() {
                if !allNews.contains(where: {$0.title == news.title}) {
                    self.setNews(news)
                    shouldSave = true
                }
                if idx == data.count - 1, shouldSave {
                    self.saveContext()
                }
            }
        }
    }
}

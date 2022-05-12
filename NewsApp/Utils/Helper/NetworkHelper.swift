//
//  NetworkHelper.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import Foundation

class NetworkHelper {
    static let shared = NetworkHelper()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getNews(completion: @escaping (NewsResponse?) -> ()) {
        dataTask?.cancel()
        
        if let urlComponents = URLComponents(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=2295e9dcf4924cc2b9796ebf43272c76") {
            guard let url = urlComponents.url else {
                return
            }
            dataTask =
            defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                if error != nil {
                    completion(nil)
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    let news = try? JSONDecoder().decode(NewsResponse.self, from: data)
                    completion(news)
                }
            }
            dataTask?.resume()
        }
        
    }
}

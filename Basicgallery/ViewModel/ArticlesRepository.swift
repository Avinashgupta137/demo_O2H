//
//  ArticlesRepository.swift
//  Basicgallery
//
//  Created by Sanskar IOS Dev on 04/09/25.
//
import Foundation

protocol ArticlesRepositoryProtocol {
    func fetchArticles(completion: @escaping (Result<[Articles], Error>) -> Void)
    func loadStoredArticles() -> [Articles]?
    func saveArticles(_ articles: [Articles])
}

class ArticlesRepository: ArticlesRepositoryProtocol {
   
    func fetchArticles(completion: @escaping (Result<[Articles], Error>) -> Void) {
        let urlString = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=289a71e57ed742c3b60ea7d0d6fccabb"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                completion(.success(json.articles ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadStoredArticles() -> [Articles]? {
        UserModel.getStoreArrayFromUD()
    }
    
    func saveArticles(_ articles: [Articles]) {
        UserModel.setStoreArrayToUD(storeList: articles)
    }
}



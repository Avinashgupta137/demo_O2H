//
//  GalleryViewModel.swift
//  Basicgallery
//
//  Created by Sanskar IOS Dev on 04/09/25.
//

import Foundation

class GalleryViewModel {
    private let repository: ArticlesRepositoryProtocol
    
    var articles: [Articles] = [] {
        didSet {
            onDataChanged?(articles)
        }
    }
    
    var onDataChanged: (([Articles]) -> Void)?
    var onError: ((String) -> Void)?
    
    init(repository: ArticlesRepositoryProtocol = ArticlesRepository()) {
        self.repository = repository
    }
    
    func loadArticles() {
        if let stored = repository.loadStoredArticles() {
            self.articles = stored
        } else {
            repository.fetchArticles { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let articles):
                        self?.articles = articles
                        self?.repository.saveArticles(articles)
                    case .failure(let error):
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        }
    }
}

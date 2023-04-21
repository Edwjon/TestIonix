//
//  Api.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import Foundation
import Alamofire

class Api {
    private let baseURL = "https://www.reddit.com"

    func fetchPosts(limit: Int = 100, after: String? = nil, completion: @escaping (Result<([Post], String?), Error>) -> Void) {
        var url = "\(baseURL)/r/chile/new/.json?limit=\(limit)"
        if let after = after {
            url += "&after=\(after)"
        }

        AF.request(url).responseDecodable(of: ApiResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                let posts = apiResponse.data.children.map { $0.data }
                completion(.success((posts, apiResponse.data.after)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchPosts(query: String, limit: Int = 100, completion: @escaping (Result<([Post], String?), Error>) -> Void) {
        let baseSearchUrl = "https://www.reddit.com/r/chile/search.json"
        let url = "\(baseSearchUrl)?q=\(query)&limit=\(limit)"

        AF.request(url).responseDecodable(of: ApiResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                let posts = apiResponse.data.children.map { $0.data }
                completion(.success((posts, apiResponse.data.after)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

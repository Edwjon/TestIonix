//
//  Api.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import Foundation
import Alamofire

class API {
    private let baseURL = "https://www.reddit.com"
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let path = "/r/chile/new/.json"
        let parameters: Parameters = ["limit": 100]
        
        AF.request(baseURL + path, parameters: parameters).responseDecodable(of: ApiResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                let posts = apiResponse.data.children.map { $0.data }
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

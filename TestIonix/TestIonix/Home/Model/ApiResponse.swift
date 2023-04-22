//
//  ApiResponse.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import Foundation

struct ApiResponse: Codable {
    let kind: String
    let data: ApiResponseData

    struct ApiResponseData: Codable {
        let after: String?
        let dist: Int
        let children: [PostWrapper]

        struct PostWrapper: Codable {
            let kind: String
            let data: Post
        }
    }
}

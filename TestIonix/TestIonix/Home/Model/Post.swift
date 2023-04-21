//
//  Post.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import Foundation

struct Post: Codable {
    let linkFlairText: String?
    let postHint: String?
    let title: String
    let url: String
    let score: Int
    let numComments: Int
    let after: String?

    enum CodingKeys: String, CodingKey {
        case linkFlairText = "link_flair_text"
        case postHint = "post_hint"
        case title
        case url
        case score
        case numComments = "num_comments"
        case after
    }
}

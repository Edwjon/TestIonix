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

extension Post {
    static func mock(
        linkFlairText: String? = "Mock Flair",
        postHint: String? = "image",
        title: String = "Mock Title",
        url: String = "https://mockurl.com",
        score: Int = 0,
        numComments: Int = 0,
        after: String? = "t3_mock_after"
    ) -> Post {
        return Post(
            linkFlairText: linkFlairText,
            postHint: postHint,
            title: title,
            url: url,
            score: score,
            numComments: numComments,
            after: after
        )
    }
}

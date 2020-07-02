//
//  Movies.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 29.06.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class Movies {
    
    ///List of movies IDs which are in trend right now
    struct List: Decodable {
        let results: [Results]
        let total_pages: Int
        
        enum CodingKeys: String, CodingKey {
            case results
            case total_pages
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            results = try container.decode([Results].self, forKey: .results)
            total_pages = try container.decode(Int.self, forKey: .total_pages)
        }
    }
}

extension Movies {
    
    ///Result array for relevant list
    struct Results: Decodable {
        let id: Int
        let title: String
        let vote_average: Float
        let poster_path: String?
        let overview: String
        let adult: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case vote_average
            case poster_path
            case overview
            case adult
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            vote_average = try container.decode(Float.self, forKey: .vote_average)
            poster_path = try container.decode(String?.self, forKey: .poster_path)
            overview  = try container.decode(String.self, forKey: .overview)
            adult = try container.decode(Bool.self, forKey: .adult)
        }
    }
}

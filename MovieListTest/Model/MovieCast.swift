//
//  MovieCast.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 02.07.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class MovieCast {
    
    ///List of cast to certain moview
    struct List: Decodable {
        
        let cast: [Cast]
        let crew: [Crew]
        
        enum CodingKeys: String, CodingKey {
            case cast
            case crew
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            cast = try container.decode([Cast].self, forKey: .cast)
            crew = try container.decode([Crew].self, forKey: .crew)
        }
    }
}

extension MovieCast {
    
    ///Cast array for relevant list
    struct Cast: Decodable {
        let name: String

        enum CodingKeys: String, CodingKey {
            case name
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
        }
    }
    
    ///Crew array for relevant list
    struct Crew: Decodable {
        let name: String
        let job: String

        enum CodingKeys: String, CodingKey {
            case name
            case job
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            job = try container.decode(String.self, forKey: .job)
        }
    }
}

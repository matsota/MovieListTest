//
//  Movie.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 29.06.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class Movie {
    
    ///Result of url session for movie data
    struct Result: Decodable {
        let adult: Bool
        let budget: Int?
        let genres: [Genres]?
        let homepage: String?
        let title: String
        let overview: String
        let poster_path: String?
        let production_companies: [ProductionCompanies]?
        let production_countries: [ProductionCountries]?
        let release_date: String
        let runtime: Int?
        let tagline: String?
        let vote_average: Float
        let vote_count: Int
        
        enum CodingKeys: String, CodingKey {
            case adult
            case budget
            case genres
            case homepage
            case title
            case overview
            case poster_path
            case production_companies
            case production_countries
            case release_date
            case runtime
            case tagline
            case vote_average
            case vote_count
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            adult = try container.decode(Bool.self, forKey: .adult)
            budget = try container.decode(Int?.self, forKey: .budget)
            genres = try container.decode([Genres]?.self, forKey: .genres)
            homepage = try container.decode(String?.self, forKey: .homepage)
            title = try container.decode(String.self, forKey: .title)
            overview = try container.decode(String.self, forKey: .overview)
            poster_path = try container.decode(String?.self, forKey: .poster_path)
            production_companies = try container.decode([ProductionCompanies]?.self, forKey: .production_companies)
            production_countries = try container.decode([ProductionCountries]?.self, forKey: .production_countries)
            release_date = try container.decode(String.self, forKey: .release_date)
            runtime = try container.decode(Int?.self, forKey: .runtime)
            tagline = try container.decode(String?.self, forKey: .tagline)
            vote_average = try container.decode(Float.self, forKey: .vote_average)
            vote_count = try container.decode(Int.self, forKey: .vote_count)
        }
    }
    
}

extension Movie {
    
    ///Movie genres to relevant list
    struct Genres: Decodable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
        }
    }
    
    ///Array of production companies to relevant list
    struct ProductionCompanies: Decodable {
        let id: Int
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case logo_path
            case name
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            name = try container.decode(String?.self, forKey: .name)
        }
    }
    
    ///Array of production countries to relevant list
    struct ProductionCountries: Decodable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
        }
    }
    
}

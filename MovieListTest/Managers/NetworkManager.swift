//
//  NetworkManager.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 29.06.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    //MARK: Load trend movies by page_number&week
    private func trendAPI(_ page: Int) -> String {
        let api = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(AppDelegate.APIKey)&page=\(page)"
        return api
    }
    func loadMoviesInTrend(page: Int,
                           success: @escaping (Movies.List) -> Void,
                           failure: @escaping (Swift.Error) -> Void){
        
        guard let url = URL(string: trendAPI(page)) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                failure(error)
            }else{
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(Movies.List.self, from: data)
                        success(result)
                    }catch{
                        failure(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK: - Load movie data by ID of it
    private func movieAPI(_ id: Int) -> String {
        let api = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(AppDelegate.APIKey)"
        return api
    }
    func loadMovieData(movie id: Int,
                       success: @escaping (Movie.Result) -> Void,
                       failure: @escaping (Swift.Error) -> Void) {
        
        if let url = URL(string: movieAPI(id)) {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    failure(error)
                }else{
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(Movie.Result.self, from: data)
                            success(result)
                        }catch{
                            failure(error)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    //MARK: Load cast for movie by if of it
    private func loadMovieCast(_ id: Int) -> String {
        let api = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(AppDelegate.APIKey)"
        return api
    }
    func loadInvolvedPersons(movie id: Int,
                        success: @escaping (MovieCast.List) -> Void,
                        failure: @escaping (Swift.Error) -> Void) {
        
        if let url = URL(string: loadMovieCast(id)) {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    failure(error)
                }else{
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(MovieCast.List.self, from: data)
                            success(result)
                        }catch{
                            failure(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Load movies which is searching by name of it at the moment
    private func searchMovieAPI(key word: String) -> String {
        let api = "https://api.themoviedb.org/3/search/movie?api_key=\(AppDelegate.APIKey)&query=\(word)"
        return api
    }
    func loadByMovieTitle(word: String,
                          success: @escaping ([Movies.Results]) -> Void,
                          failure: @escaping (Swift.Error) -> Void) {
        
        guard let url = URL(string: searchMovieAPI(key: word)) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                failure(error)
            }else{
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(Movies.List.self, from: data)
                        success(result.results)
                    }catch{
                        failure(error)
                    }
                }
            }
        }
        task.resume()
    }
}

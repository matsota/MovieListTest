//
//  MovieDescriptionViewController.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 29.06.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class MovieDescriptionViewController: UIViewController {
    
    //MARK: - Implementation
    var movieID: Int?
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Check Movie id
        guard let id = movieID else {
            self.present(UIAlertController.alertAppearanceForTwoSec(title: "Attention", message: "ReEntry application. We lost id of movie"), animated: true)
            self.activityIndicator.stopAnimating()
            return
        }
        
        /// Movie description
        NetworkManager.shared.loadMovieData(movie: id, success: { (data) in
            DispatchQueue.main.async {
                ///Set title of movie
                self.titleLabel.text = data.title
                
                ///Set poster image
                self.imagePath = data.poster_path ?? ""
                
                ///Set Adult condition label
                if data.adult == true {
                    self.isAdultLabel.isHidden = false
                }else{
                    self.isAdultLabel.isHidden = true
                }
                
                ///Set rate label
                self.rateLabel.text = "\(data.vote_average)"
                self.votesLabel.text = "\(data.vote_count) votes"
                
                ///Set tagline label
                if let tagline = data.tagline {
                    self.taglineLabel.text = tagline
                }else{
                    self.taglineLabel.text = "No information"
                    self.taglineLabel.textColor = .systemGray3
                }
                
                ///Set link to homepage label
                if let homepage = data.homepage {
                    self.homepageButton.setTitle(homepage, for: .normal)
                }else{
                    self.homepageButton.setTitle("No information", for: .normal)
                    self.homepageButton.isUserInteractionEnabled = false
                }
                
                ///Set release date label
                if data.release_date != "" {
                    self.releaseDataLabel.text = data.release_date
                }else{
                    self.releaseDataLabel.text = "No information"
                    self.releaseDataLabel.textColor = .systemGray3
                }
                
                ///Set production companies label
                var companies = String()
                if let production_companies = data.production_companies {
                    for i in production_companies {
                        if let name = i.name{
                            companies += "\(name), "
                        }
                    }
                    if companies.count > 2 {
                        companies.removeLast(2)
                        self.poductionCompaniesLabel.text = companies
                    }else{
                        self.poductionCompaniesLabel.text = "No information"
                        self.poductionCompaniesLabel.textColor = .systemGray3
                    }
                }else{
                    self.poductionCompaniesLabel.text = "No information"
                    self.poductionCompaniesLabel.textColor = .systemGray3
                }
                
                ///Set production countries label
                var countries = String()
                if let production_countries = data.production_countries{
                    for i in production_countries {
                        countries += "\(i.name), "
                    }
                    if countries.count > 2 {
                        countries.removeLast(2)
                        self.productionCountriesLabel.text = countries
                    }else{
                        self.productionCountriesLabel.text = "No information"
                        self.productionCountriesLabel.textColor = .systemGray3
                    }
                }else{
                    self.productionCountriesLabel.text = "No information"
                    self.productionCountriesLabel.textColor = .systemGray3
                }
                
                ///Set budget label
                if let budget = data.budget {
                    if budget == 0 {
                        self.budgetLabel.text = "No information"
                        self.budgetLabel.textColor = .systemGray3
                    }else{
                        self.budgetLabel.text = "\(budget) dollars"
                    }
                }else{
                    self.budgetLabel.text = "No information"
                    self.budgetLabel.textColor = .systemGray3
                }
                
                ///Set runtime label
                if let runtime = data.runtime {
                    self.runtimeLabel.text = "\(runtime) minutes"
                }else{
                    self.runtimeLabel.text = "No information"
                }
                
                ///Set Genres label
                if let genres = data.genres {
                    var genre = String()
                    for i in genres {
                        genre += "\(i.name), "
                    }
                    if genre.count > 2 {
                        genre.removeLast(2)
                        self.genresLabel.text = genre
                        self.genresLabel.textColor = .label
                    }else{
                        self.genresLabel.text = "No information"
                        self.genresLabel.textColor = .systemGray3
                    }
                }
                
                ///Set overview label
                if data.overview == "" {
                    self.overviewLabel.text = "No information"
                    self.overviewLabel.textColor = .systemGray3
                }else{
                    self.overviewLabel.text = data.overview
                }
                
                ///Set link
                self.homepage = data.homepage
            }
        }) { (error) in
            print("ERROR: MovieDescriptionViewController: loadMovieData: ", error.localizedDescription)
        }
        
        ///Involved persons: Cast and Crew
        NetworkManager.shared.loadInvolvedPersons(movie: id, success: { (data) in
            DispatchQueue.main.async {
                let castArray = data.cast
                ///Set cast
                var cast = String()
                for i in castArray {
                    cast += "\(i.name), "
                }
                if cast.count > 1 {
                    cast.removeLast(2)
                    self.castLabel.text = cast
                }else{
                    self.castLabel.text = "No Information"
                    self.castLabel.textColor = .systemGray3
                }
                
                let crew = data.crew
                
                ///Set writer(s)
                var writtenBy = String()
                for i in crew {
                    if i.job == "Writer" {
                        writtenBy += "\(i.name), "
                    }
                }
                if writtenBy.count > 1 {
                    writtenBy.removeLast(2)
                    
                    self.writtenByLabel.text = writtenBy
                    
                }else{
                    self.writtenByLabel.text = "No Information"
                    self.writtenByLabel.textColor = .systemGray3
                }
                
                ///Set Deirector(s)
                var director = String()
                for i in crew {
                    if i.job == "Director" {
                        director += "\(i.name), "
                    }
                }
                if director.count > 1 {
                    director.removeLast(2)
                    self.directorLabel.text = director
                }else{
                    self.directorLabel.text = "No Information"
                    self.directorLabel.textColor = .systemGray3
                }
            }
        }) { (error) in
            print("ERROR: MovieDescriptionViewController: loadCastOfMovie: ", error.localizedDescription)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageURL = toPosterURL + imagePath
        if let url = URL(string: imageURL),
            let imageData = try? Data(contentsOf: url){
            posterImageView.image = UIImage(data: imageData)
            posterImageView.clipsToBounds = true
            posterImageView.layer.cornerRadius = posterImageView.frame.width / 20
            activityIndicator.stopAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    //MARK: - Private Methods
    @IBAction private func homepageTapped(_ sender: UIButton) {
        guard let urlString = homepage, let url = URL(string: urlString) else {
            self.present(UIAlertController.alertAppearanceForTwoSec(title: "Attention", message: "Link is broken. Unable to perform transition"), animated: true)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //MARK: - Private Implementation
    private var toPosterURL = "http://image.tmdb.org/t/p/w500",
    homepage: String?,
    imagePath = String()
    
    ///ImageView
    @IBOutlet private weak var posterImageView: UIImageView!
    
    ///Button
    @IBOutlet private weak var homepageButton: UIButton!
    
    ///Label
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var isAdultLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var votesLabel: UILabel!
    @IBOutlet private weak var taglineLabel: UILabel!
    @IBOutlet private weak var releaseDataLabel: UILabel!
    @IBOutlet private weak var poductionCompaniesLabel: UILabel!
    @IBOutlet private weak var writtenByLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var productionCountriesLabel: UILabel!
    @IBOutlet private weak var castLabel: UILabel!
    @IBOutlet private weak var budgetLabel: UILabel!
    @IBOutlet private weak var runtimeLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    ///Activity Indicator
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
}

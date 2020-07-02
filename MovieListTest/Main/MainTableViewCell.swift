//
//  MainTableViewCell.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 29.06.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    //MARK: - Implementation
    static let identifier = "MainTableViewCell"
    
    //MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        ///Set poster image
        let imageURL = toPosterURL + poster
        if imageURL != toPosterURL{
            if let url = URL(string: imageURL),
                let imageData = try? Data(contentsOf: url) {
                self.posterImageView.image = UIImage(data: imageData)
                self.activityIndicator.stopAnimating()
                
                posterImageView.clipsToBounds = true
                posterImageView.layer.cornerRadius = posterImageView.frame.width / 20
            }else{
                self.activityIndicator.stopAnimating()
            }
        }else{
            self.activityIndicator.stopAnimating()
        }
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        let image = UIImage(systemName: "clear.fill")
        self.posterImageView.image = image
    }
    
    //MARK: - Fill
    func fill(rate: Float, title: String, overview: String, poster: String, adult: Bool) {
        /// Set Rating of film
        self.rateLabel.text = "\(rate)"
        if rate > 6.49 {
            self.rateLabel.textColor = .green
        }else if rate < 6.5, rate > 4.49 {
            self.rateLabel.textColor = .orange
        }else{
            self.rateLabel.textColor = .red
        }
        
        ///Adult condition
        if adult == true {
            self.isAdultLabel.isHidden = false
        }else{
            self.isAdultLabel.isHidden = true
        }
        
        ///Set poster path
        self.poster = poster
        
        ///Set name of movie
        self.titleLabel.text = title
        
        ///Set overview label
        if overview == "" {
            self.overviewLabel.text = "No information"
            self.overviewLabel.textColor = .systemGray3
        }else{
            self.overviewLabel.text = overview
            self.overviewLabel.textColor = .label
        }
    }
    
    //MARK: - Private Implementation
    private var toPosterURL = "http://image.tmdb.org/t/p/w500"
    private var poster = String()
    
    ///Image View
    @IBOutlet private weak var posterImageView: UIImageView!
    
    ///Label
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var isAdultLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    ///Activity Indicator
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
}

//
//  UIAlertController + Custom.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 01.07.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

extension UIAlertController {

    //MARK: - Alert APPEARANCE
    static func alertAppearanceForTwoSec(title: String, message: String) -> (UIAlertController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
        return alert
    }

}

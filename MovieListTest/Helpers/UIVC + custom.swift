//
//  UIVC + custom.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 01.07.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


extension UIViewController {

    //MARK: Keyboard
    @objc func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}

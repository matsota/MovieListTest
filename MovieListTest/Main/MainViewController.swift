//
//  ViewController.swift
//  MovieListTest
//
//  Created by Andrew Matsota on 29.06.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class MainViewController: UIViewController{
    
    //MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Set title of view controller
        navigationController?.navigationBar.topItem?.title = "Trend Movies"
        
        ///Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        
        ///Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        ///Movies which are in trend
        NetworkManager.shared.loadMoviesInTrend(page: currentPage, success: { (data) in
            DispatchQueue.main.async {
                let pages = data.total_pages
                var pageQuantity = [Int]()
                for i in 1...pages {
                    pageQuantity.append(i)
                }
                self.pageQuantity = pageQuantity
                self.pageNumberTextField.text = "Page number 1 / \(pages)"
                
                self.trendMovies = data.results
                self.tableView.reloadData()
            }
        }) { (error) in
            print("ERROR: loadYoutubePlaylist", error.localizedDescription)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lookForDescription", let destination = segue.destination as? MovieDescriptionViewController, let index =  tableView.indexPathsForSelectedRows?.first?.row {
            if isSearching {
                if let movie = filteredMovies?[index] {
                    let id = movie.id
                    destination.movieID = id
                }
            }else{
                if let movie = trendMovies?[index] {
                    let id = movie.id
                    destination.movieID = id
                }
            }
        }
    }
    
    //MARK: - Private Implementation
    private var trendMovies: [Movies.Results]?,
    filteredMovies: [Movies.Results]?,
    isSearching = false
    
    private var pickerView = UIPickerView(),
    currentTextField = UITextField(),
    pageQuantity: [Int]?,
    currentPage = 1

    ///Table View
    @IBOutlet private weak var tableView: UITableView!
    
    ///SearchBar
    @IBOutlet weak var searchBar: UISearchBar!
    
    ///TextField
    @IBOutlet weak var pageNumberTextField: UITextField!
    
    ///Constraint
    @IBOutlet weak var lowestConstraint: NSLayoutConstraint!
}









//MARK: - Search Result
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.placeholder = "Start searching"
            isSearching = false
            pageNumberTextField.isHidden = false
            tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            navigationController?.navigationBar.topItem?.title = "Trend Movies"
            tableView.reloadData()
        }else{
            isSearching = true
            pageNumberTextField.isHidden = true
            navigationController?.navigationBar.topItem?.title = "Searching for '\(searchText)'"
            let text = searchText.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: ":", with: "%3A").replacingOccurrences(of: "(", with: "%28").replacingOccurrences(of: ")", with: "%29").replacingOccurrences(of: ",", with: "%2C").replacingOccurrences(of: "&", with: "%26")
            
            NetworkManager.shared.loadByMovieTitle(word: text, success: { (data) in
                DispatchQueue.main.async {
                    self.filteredMovies = data
                    self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.tableView.reloadData()
                }
            }) { (error) in
                print("ERROR: loadByMovieTitle", error.localizedDescription)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tableView.reloadData()
    }
    
}

//MARK: - Table view
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredMovies?.count ?? 0
        }else{
            return trendMovies?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        var fetch: Movies.Results?
        if isSearching {
            fetch = filteredMovies?[indexPath.row]
        }else{
            fetch = trendMovies?[indexPath.row]
        }

        guard let rate = fetch?.vote_average,
            let title = fetch?.title,
            let overview = fetch?.overview,
            let adult = fetch?.adult else {return cell}
        
        var poster = ""
        if let poster_ = fetch?.poster_path {
            poster = poster_
        }

        cell.fill(rate: rate, title: title, overview: overview, poster: poster, adult: adult)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height - searchBar.frame.height - pageNumberTextField.frame.height - 18
        return height
    }
    
}

//MARK: Text Field Delegate
extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerView.dataSource = self
        pickerView.delegate = self
        currentTextField = textField
        if currentTextField == pageNumberTextField {
            ///Add  PickerView
            currentTextField.inputView = pickerView
            
            ///Add button to PickerView
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
            toolbar.barStyle = .black
            toolbar.tintColor = .white
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(changePage))
            toolbar.setItems([doneButton], animated: false)
            currentTextField.inputAccessoryView = toolbar
            
        }
    }
    
}


//MARK: Picker View
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pages = pageQuantity else {return 1}
        return pages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pages = pageQuantity else {return "1"}
        return "\(pages[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let pages = pageQuantity else {return }
        currentPage = pages[row]
    }
    
}

//MARK: - Private methods
private extension MainViewController {
    
    ///Keyboard
    @objc func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        lowestConstraint.constant = keyboardFrameValue.cgRectValue.height - 14
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        
        lowestConstraint.constant = 14
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
    ///Done button method for picker view
    @objc func changePage() {
        hideKeyboard()
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        NetworkManager.shared.loadMoviesInTrend(page: self.currentPage, success: { (data) in
            DispatchQueue.main.async {
                self.pageNumberTextField.text = "Page number \(self.currentPage) / \(self.pageQuantity?.count ?? 0)"
                self.trendMovies = data.results
                self.tableView.reloadData()
            }
        }) { (error) in
            print("ERROR: loadYoutubePlaylist", error.localizedDescription)
        }
        
    }
    
}

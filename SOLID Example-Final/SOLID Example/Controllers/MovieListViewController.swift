//
//  MovieListViewController.swift
//  SOLID Example
//
//  Created by PT.Koanba on 22/09/22.
//

import UIKit

class MovieListViewController: UITableViewController {

    private var movies = [RemoteMovie]()
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var loader: MovieLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMovieList()
        print("Movie List View Controller loaded")
    }
    
    @IBAction func onRefresh(_ sender: UIRefreshControl) {
        getMovieList()
    }
    
    private func getMovieList() {
        hideErrorLabel()
        refreshControl?.beginRefreshing()
        loader?.get { result in
                self.refreshControl?.endRefreshing()
                switch result {
                case let .success(movies):
                        self.bindData(with: movies)
                case let .failure(error):
                    self.showErrorLabel(message: error.localizedDescription)
                }
        }
    }
    
    private func showErrorLabel(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func hideErrorLabel() {
        errorLabel.isHidden = true
    }
    
    private func bindData(with movies: [RemoteMovie]) {
        self.movies = movies
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        
        cell.labelMovieTitle.text = movie.title
        cell.labelMovieDescription.text = movie.remoteMovieDescription
        return cell
    }
}


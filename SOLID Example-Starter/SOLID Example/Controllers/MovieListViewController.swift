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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMovieList()
    }
    
    @IBAction func onRefresh(_ sender: UIRefreshControl) {
        getMovieList()
    }
    
    private func getMovieList() {
        hideErrorLabel()
        refreshControl?.beginRefreshing()
        let url = URL(string: "https://ghibliapi.herokuapp.com/films")!
     
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()

                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode([RemoteMovie].self, from: data!)
                    self.bindData(with: movies)
                    
                } catch let error {
                    self.showErrorLabel(message: error.localizedDescription)
                }
            }
        }.resume()
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


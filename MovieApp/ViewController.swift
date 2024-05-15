//
//  ViewController.swift
//  MovieApp
//
//  Created by Tekup-mac-5 on 14/5/2024.
//

import UIKit

struct MovieResponse: Codable {
    let results: [Movie]
}


class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    var Movies: [Movie] = []



    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        
        fetchData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = Movies[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "Celll", for: indexPath) as! CustomTableViewCell
        if let posterPath = movie.poster_path {
               let posterURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
               if let posterURL = URL(string: posterURLString) {
                   let task = URLSession.shared.dataTask(with: posterURL) { data, response, error in
                       guard let data = data, let image = UIImage(data: data) else {
                           return
                       }
                       DispatchQueue.main.async {
                           cell.theimage.image = image
                       }
                   }
                   task.resume()
               } else {
                   cell.theimage.image = UIImage(named: "img")
               }
           } else {
               cell.theimage.image = UIImage(named: "img")
           }
          
        cell.thetitle.text = movie.title
        cell.releaqedate.text = movie.release_date
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let destination = storyboard?.instantiateViewController(withIdentifier: "DetailsUIVViewController") as? DetailsUIVViewController {
            destination.movie = Movies[indexPath.row]
            self.navigationController?.pushViewController(destination, animated: true)
        }
        
    }


    func fetchData() {
            guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie") else {
                print("Invalid URL")
                return
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "include_video", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            
            guard let finalURL = components.url else {
                print("Invalid final URL")
                return
            }
            
            var request = URLRequest(url: finalURL)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwYjBlMDU5OTc4ODliNzdkMmE4NmVjNWRlYzY2NzViYiIsInN1YiI6IjY2NDMxYTg3MGNhYWI0ZDM0MGI4OWY0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.GTy-CRsI7azZ03fHPjumYQbFpMDdKlrUtDE5ah_ipPQ"
            ]
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
          
                    
                    let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter())
                        let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                        
            
                    self.Movies = movieResponse.results
                    DispatchQueue.main.async {
                                 self.tableview.reloadData()
                             }
                    
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
            }
            task.resume()
        }
 
    
}


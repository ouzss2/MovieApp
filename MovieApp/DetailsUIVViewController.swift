//
//  DetailsUIVViewController.swift
//  MovieApp
//
//  Created by Tekup-mac-5 on 14/5/2024.
//

import UIKit

class DetailsUIVViewController: UIViewController {

    var movie: Movie?
    
    @IBOutlet weak var thedetails: UILabel!
    @IBOutlet weak var thedate: UILabel!
    @IBOutlet weak var thetitle: UILabel!
    @IBOutlet weak var theimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(movie)
       
        if let movie = movie {
            thetitle.text = movie.title
            thedate.text = movie.release_date
            thedetails.text = movie.overview
                 
                 if let posterPath = movie.poster_path {
                     let posterURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                     if let posterURL = URL(string: posterURLString) {
                         let task = URLSession.shared.dataTask(with: posterURL) { data, response, error in
                             guard let data = data, let image = UIImage(data: data) else {
                                 return
                             }
                             DispatchQueue.main.async {
                                 self.theimage.image = image
                             }
                         }
                         task.resume()
                     }
                 }
             }
         }
     }

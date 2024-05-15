//
//  Movie.swift
//  MovieApp
//
//  Created by Tekup-mac-5 on 14/5/2024.
//

import Foundation

struct Movie: Codable {
    let title: String?
    let overview: String?
    let release_date: String?
    let poster_path: String?
    private enum CodingKeys: String, CodingKey {
           case title
           case overview
           case release_date
           case poster_path
       }


}

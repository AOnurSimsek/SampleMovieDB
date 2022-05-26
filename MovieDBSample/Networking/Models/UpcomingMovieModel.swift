//
//  UpcomingMovieModel.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 24.05.2022.
//

import Foundation

struct UpcomingMovieModel: Codable  {
    private var dates : DatesModel?
    private var page : Int?
    private var results : [MovieModel]?
    private var total_pages : Int?
    private var total_results : Int?
    
    func getResult() -> [MovieModel] {
        return results.unwrapMovieModel()
    }
    
    func getTotalPages() -> Int {
        return total_pages.unwrapInt()
    }
    
    func getPage() -> Int {
        return page.unwrapInt()
    }
    
    mutating func setPage(page: Int) {
        self.page = page
    }
    
    mutating func addNewMovies(movies: [MovieModel]){
        self.results?.append(contentsOf: movies)
    }
}

struct DatesModel: Codable {
    private var maximum : String?
    private var minimum : String?
}

struct MovieModel: Codable {
    private var adult : Bool?
    private var backdrop_path : String?
    private var genre_ids : [Int]?
    private var id : Int?
    private var original_language : String?
    private var original_title : String?
    private var overview : String?
    private var popularity : Double?
    private var poster_path : String?
    private var release_date : String?
    private var title : String?
    private var video : Bool?
    private var vote_average : Double?
    private var vote_count : Double?
    
    func getId() -> Int {
        return id.unwrapInt()
    }
    
    func getTitle() -> String {
        return title.unwrapString()
    }
    
    func getPosterPath()->URL?{
        return URL(string: "https://image.tmdb.org/t/p/w500/" + backdrop_path.unwrapString())
    }
    
    func getReleaseDate()->String{
        return release_date.unwrapString().getDate()
    }
    
    func getYear()->String{
        return release_date.unwrapString().getYearValue()
    }
    
    func getOverView()->String{
        return overview.unwrapString()
    }
}

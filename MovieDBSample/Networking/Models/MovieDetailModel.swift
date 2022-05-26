//
//  MovieDetailModel.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 24.05.2022.
//

import Foundation

class MovieDetailModel : Codable {
    private var adult : Bool?
    private var backdrop_path : String?
    private var budget : Int?
    private var genres : [GenreModel]?
    private var homepage : String?
    private var id : Int?
    private var imdb_id : String?
    private var original_language : String?
    private var original_title : String?
    private var overview : String?
    private var popularity : Double?
    private var poster_path :String?
    private var production_companies : [CompanyModel]?
    private var production_countries : [CountryModel]?
    private var release_date : String?
    private var revenue : Int?
    private var runtime : Int?
    private var spoken_languages : [LanguageModel]?
    private var status : String?
    private var tagline : String?
    private var title : String?
    private var video : Bool?
    private var vote_average : Double?
    private var vote_count : Int?
    
    func getTitle()->String{
        return title.unwrapString()
    }
    
    func getVoteAverage()->String{
        let stringValue: String = String(format: "%.1f", vote_average.unwrapDouble())
        return stringValue+"/10"
    }
    
    func getReleaseDate()->String{
        return release_date.unwrapString().getDate()
    }
    
    func getPosterPath()->URL?{
        return URL(string: "https://image.tmdb.org/t/p/w500/" + backdrop_path.unwrapString())
    }
    
    func getImdbId()->String{
        return imdb_id.unwrapString()
    }
    
    func getOverview()->String{
        return overview.unwrapString()
    }
}

//MARK: - Submodels

class GenreModel : Codable {
    private var id : Int?
    private var name : String?
}

class CompanyModel : Codable {
    private var id : Int?
    private var logo_path : String?
    private var name : String?
    private var origin_country : String?
}

class CountryModel : Codable {
    private var iso_3166_1 : String?
    private var name : String?
}

class LanguageModel : Codable {
    private var english_name : String?
    private var iso_639_1 : String?
    private var name : String?
}

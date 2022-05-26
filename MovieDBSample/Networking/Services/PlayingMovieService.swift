//
//  PlayingMovieService.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 24.05.2022.
//

import Foundation
import Alamofire

final class PlayingMovieService {
    private static let path : String = "/now_playing"
    
    private static func checkReachability() -> Bool {
        if (NetworkReachabilityManager()?.isReachable ?? false) {
            return true
        }
        else {
            return false
        }
    }
    
    static func getUpcomingMovies(page: Int,
                                  success: @escaping(UpcomingMovieModel)->(),
                                  fail: @escaping(serviceErrors)->()) {
        if !checkReachability() {
            fail(.internetError)
            return
        }
        
        guard let url = URL(string: RequestParameters.baseUrl + path
                                    + "?api_key=" + RequestParameters.apiKey
                                    + "&page=" + String(page))
        else {
            fail(.urlError)
            return
        }
        
        AF.request(url).responseDecodable(of: UpcomingMovieModel.self) { response in
            if let error = response.error {
                print("getUpcomingMovie Error " + "\(error)")
                fail(.apiError)
            } else {
                if let value = response.value {
                    success(value)
                } else {
                    fail(.valueError)
                }
            }
        }
    }
}

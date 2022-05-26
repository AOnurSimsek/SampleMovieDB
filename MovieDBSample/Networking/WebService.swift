//
//  UpcomingMoviesService.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 24.05.2022.
//

import Foundation
import Alamofire

final class WebService {
    private static let apiKey : String = "726e15f3daf1de3b57996b8991c6e42f"
    private static let baseUrl: String = "https://api.themoviedb.org/3/movie/"
     
    private func getUrl(type: paths,page: Int?, movieId: Int?)->URL? {
         switch type {
         case .getUpcomingMovies:
             return URL(string: WebService.baseUrl + "upcoming"
                        + "?api_key=" + WebService.apiKey
                        + "&page=" + String(page ?? 1))
         case .getNowplayingMovies:
             return URL(string: WebService.baseUrl + "now_playing"
                        + "?api_key=" + WebService.apiKey
                        + "&page=" + String(page ?? 0))
         case .MovieDetails:
             return URL(string: WebService.baseUrl + String(movieId ?? 0)
                                + "?api_key=" + WebService.apiKey )
         }
     }
    
    private static func checkReachability() -> Bool {
        if (NetworkReachabilityManager()?.isReachable ?? false) {
            return true
        }
        else {
            return false
        }
    }
    
    func getData<T: Codable> (pathType: paths,
                              page: Int? = nil,
                              type: T.Type,
                              movieId: Int? = nil,
                              success: @escaping(T)->(),
                              fail: @escaping(serviceErrors)->()) {
        if !WebService.checkReachability() {
            fail(.internetError)
            return
        }
        
        guard let url = getUrl(type: pathType, page: page, movieId: movieId)
        else {
            fail(.urlError)
            return
        }
        
        AF.request(url).responseDecodable(of: T.self) { response in
            if let error = response.error {
                print("Webservice Error " + "\(error)")
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

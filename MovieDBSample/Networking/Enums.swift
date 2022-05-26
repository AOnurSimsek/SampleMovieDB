//
//  RequestParameters.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 24.05.2022.
//

import Foundation

enum serviceErrors: CustomStringConvertible {
    case internetError
    case urlError
    case apiError
    case valueError
    case defaultError
    
    var description : String {
        switch self {
        case .internetError:
            return "Internet connection error. Check connection and try again"
        case .urlError:
            return "Url creation error. Contact with developer"
        case .apiError:
            return "Service error. Contact with developer"
        case .valueError:
            return "Value error. Contact with developer"
        case .defaultError:
            return "An error occured. Please try again later"
        }
    }
}

enum paths {
    case getUpcomingMovies
    case getNowplayingMovies
    case MovieDetails
}



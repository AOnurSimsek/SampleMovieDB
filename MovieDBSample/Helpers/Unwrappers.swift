//
//  Extensions.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 24.05.2022.
//

import Foundation

extension Optional where Wrapped == String {
    func unwrapString()->String{
        if let value = self {
            return value
        } else {
            return ""
        }
    }
}

extension Optional where Wrapped == Int {
    func unwrapInt()->Int {
        if let value = self {
            return value
        } else {
            return -1
        }
    }
}

extension Optional where Wrapped == [MovieModel] {
    func unwrapMovieModel()->[MovieModel] {
        if let model = self {
            return model
        } else {
            return []
        }
    }
}

extension Optional where Wrapped == Double {
    func unwrapDouble()->Double {
        if let value = self {
            return value
        } else {
            return -1
        }
    }
}

//
//  MovieDetailScreenViewModel.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 25.05.2022.
//

import Foundation

protocol MovieDetailProtocol {
    func dataReached(data: MovieDetailModel)
    func errorFound(error: serviceErrors)
}

final class MovieDetailScreenViewModel {
    private let service = WebService()
    private let delegate : MovieDetailProtocol
    private var ImdbId : String?
    
    init(delegate: MovieDetailProtocol){
        self.delegate = delegate
    }
    
    func getData(movieId: Int){
        service.getData(pathType: .MovieDetails, type: MovieDetailModel.self, movieId: movieId) { [unowned self] response in
            self.ImdbId = response.getImdbId()
            self.delegate.dataReached(data: response)
        } fail: { [unowned self] error in
            self.delegate.errorFound(error: error)
        }
    }
    
    func getImdbId()->String{
        return ImdbId.unwrapString()
    }
}

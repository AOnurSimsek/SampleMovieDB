//
//  MainScreenViewModel.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 25.05.2022.
//

import Foundation

protocol MainScreenDelegate {
    func dataReached()
    func paginationDataReached()
    func errorOccured(error: serviceErrors)
}

final class MainScreenViewModel {
    private var upcomingMovies : UpcomingMovieModel?
    private var nowPlayingMovies : UpcomingMovieModel?
    private var delegate : MainScreenDelegate?
    private let service = WebService()
    private var dispatchGroup = DispatchGroup()

    func setDelegate(delegate: MainScreenDelegate){
        self.delegate = delegate
    }
        
    func getData(){
        dispatchGroup.enter()
        dispatchGroup.enter()
        var _error : serviceErrors?
        
        service.getData(pathType: .getNowplayingMovies, page: 1, type: UpcomingMovieModel.self) { [unowned self] response in
            dispatchGroup.leave()
            nowPlayingMovies = response
        } fail: { [unowned self] error in
            dispatchGroup.leave()
            _error = error
        }

        service.getData(pathType: .getUpcomingMovies, page: 1, type: UpcomingMovieModel.self) { [unowned self] response in
            dispatchGroup.leave()
            upcomingMovies = response
        } fail: { [unowned self] error in
            dispatchGroup.leave()
            _error = error
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = _error {
                self.delegate?.errorOccured(error: error)
            } else {
                self.delegate?.dataReached()
            }
        }
    }
    
    func getNextPage(){
        if var currentPage = (upcomingMovies?.getPage()), currentPage != 0 {
            currentPage += 1
            service.getData(pathType: .getUpcomingMovies, page: currentPage, type: UpcomingMovieModel.self) { [unowned self] response in
                self.upcomingMovies?.addNewMovies(movies: response.getResult())
                self.upcomingMovies?.setPage(page: response.getPage())
                delegate?.paginationDataReached()
            } fail: { [unowned self] error in
                delegate?.errorOccured(error: error)
            }
        } else {
            delegate?.errorOccured(error: .valueError)
        }
    }
    
    func getCurrentPage()->Int{
        return upcomingMovies?.getPage() ?? 0
    }
    
    func getUpcomingMovie(indexPathRow:Int)->MovieModel?{
        if let count = upcomingMovies?.getResult().count, indexPathRow < count {
            return upcomingMovies?.getResult()[indexPathRow]
        } else {
            return nil
        }
    }
    
    func getNowPlayingMovie(indexPathRow:Int)->MovieModel?{
        if let count = nowPlayingMovies?.getResult().count, indexPathRow < count {
            return nowPlayingMovies?.getResult()[indexPathRow]
        } else {
            return nil
        }
    }
    
    func getUpcomingMoviesCount()->Int{
        if let value = upcomingMovies {
            return value.getResult().count
        } else {
            return 0
        }
    }
    
    func getNowPlayingMoviesCount()->Int{
        if let value = nowPlayingMovies {
            if value.getResult().count > 5 {
                return 5
            } else {
                return value.getResult().count
            }
        } else {
            return 0
        }
    }
}

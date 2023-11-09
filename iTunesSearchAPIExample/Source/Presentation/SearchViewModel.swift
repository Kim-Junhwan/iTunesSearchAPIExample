//
//  SearchViewModel.swift
//  iTunesSearchAPIExample
//
//  Created by JunHwan Kim on 2023/11/08.
//

import Foundation
import RxCocoa
import RxSwift

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output  
}

class SearchViewModel: BaseViewModel {
    
    private var searchResult: [AppInfo] = []
    var searchResultRelay = PublishRelay<[AppInfo]>()
    var searchError = PublishRelay<Error>()
    var disposeBag = DisposeBag()
    private let isLoading: BehaviorRelay<Bool> = .init(value: false)
    private let currentError: PublishRelay<Error> = .init()
    let searchService = SearchService()
    
    struct Input {
        let searchText: ControlProperty<String>
        let tapSearchButton: ControlEvent<Void>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let searchResult: Driver<[AppInfo]>
        let searchError: Driver<Error>
    }
    
    func transform(input: Input) -> Output {
        
        input.tapSearchButton.withLatestFrom(input.searchText) { _ , query in
            return query
        }.bind(with: self) { owner, query in
            owner.searchKeyword(keyword: query)
        }.disposed(by: disposeBag)
        
        return Output(isLoading: isLoading.asDriver(), searchResult: searchResultRelay.asDriver(onErrorJustReturn: []), searchError: searchError.asDriver(onErrorJustReturn: APIError.unknownResponse))
    }
    
    private func searchKeyword(keyword: String){
        isLoading.accept(true)
        searchService.fetchBoxOfficeData(searchKeyword: keyword).subscribe(with: self) { owner, result in
            owner.isLoading.accept(false)
            owner.searchResultRelay.accept(result)
        } onError: { owner, error in
            owner.isLoading.accept(false)
            owner.searchError.accept(error)
        }.disposed(by: disposeBag)

    }
    
}

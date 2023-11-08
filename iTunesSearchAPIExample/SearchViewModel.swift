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
    var disposeBag = DisposeBag()
    private let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let searchService = SearchService()
    
    struct Input {
        let searchText: ControlProperty<String>
        let tapSearchButton: ControlEvent<Void>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let searchResult: Observable<[AppInfo]>
    }
    
    func transform(input: Input) -> Output {
        let searchResultSubject: PublishSubject<[AppInfo]> = .init()
        input.tapSearchButton.withLatestFrom(input.searchText) { _ , query in
            return query
        }.subscribe(on: MainScheduler.instance)
            .flatMap { self.searchKeyword(keyword: $0) }
            .subscribe(with: self) { owner, result in
                owner.isLoading.accept(false)
            owner.searchResult.append(contentsOf: result)
            searchResultSubject.onNext(owner.searchResult)
        } onError: { owner, error in
            owner.isLoading.accept(false)
            searchResultSubject.onError(error)
        }.disposed(by: disposeBag)

        return Output(isLoading: isLoading.asDriver(), searchResult: searchResultSubject)
    }
    
    private func searchKeyword(keyword: String) -> Observable<[AppInfo]> {
        isLoading.accept(true)
        return searchService.fetchBoxOfficeData(searchKeyword: keyword)
    }
    
}

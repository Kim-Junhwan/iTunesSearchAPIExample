//
//  SearchService.swift
//  iTunesSearchAPIExample
//
//  Created by JunHwan Kim on 2023/11/08.
//

import RxSwift
import Foundation

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    case timeOut
    case decodeError
}

class SearchService: NSObject {
    
    func fetchBoxOfficeData(searchKeyword: String) -> Observable<[AppInfo]> {
        
        return Observable<[AppInfo]>.create { observer in
            
            guard let urlStr = "https://itunes.apple.com/search?term=\(searchKeyword)&country=KR&media=software&lang=ko_KR&limit=10".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ,let url = URL(string: urlStr) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            let request = URLRequest(url: url, timeoutInterval: .init(10.0))
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error as? NSError {
                    if error.code == NSURLErrorTimedOut {
                        observer.onError(APIError.timeOut)
                        return
                    }
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(SearchAppModel.self, from: data) {
                    observer.onNext(appData.results)
                } else {
                    observer.onError(APIError.decodeError)
                }
            }.resume()
            
            return Disposables.create()
        }.share()
    }
}

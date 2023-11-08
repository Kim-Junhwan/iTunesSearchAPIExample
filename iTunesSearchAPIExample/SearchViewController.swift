//
//  SearchViewController.swift
//  iTunesSearchAPIExample
//
//  Created by JunHwan Kim on 2023/11/08.
//

import Foundation
import UIKit
import RxCocoa

class SearchViewController: UIViewController {
    
    let searchController: UISearchController = .init()
    let viewModel: SearchViewModel = .init()
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
    private func bind() {
        let input = SearchViewModel.Input(searchText: searchController.searchBar.rx.text.orEmpty, tapSearchButton: searchController.searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.isLoading.drive(with: self) { owner, value in
            if value {
                LoadingView.show()
            } else {
                LoadingView.hide()
            }
        }.disposed(by: viewModel.disposeBag)
        output.searchResult.subscribe(with: self) { owner, result in
            print(result)
        } onError: { owner, error in
            owner.showErrorAlert(error: error)
        }.disposed(by: viewModel.disposeBag)

    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.width, height: 300)
        return layout
    }
    
    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "에러", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}

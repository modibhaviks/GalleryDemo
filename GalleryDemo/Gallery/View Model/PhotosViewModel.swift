//
//  PhotosViewModel.swift
//  GalleryDemo
//
//  Created by Bhavik Modi on 04/01/22.
//

import Foundation
import RxSwift
import RxCocoa

class PhotosViewModel {
    
    var rowItems = BehaviorRelay(value: [RowViewModel]())
    var uiActions = PublishSubject<UIActionType>()
    
    func getPhotos() {
        let photosURL = "https://jsonplaceholder.typicode.com/photos"
        
        uiActions.onNext(.showLoading)
        APIManager.request(url: photosURL) { [weak self] (result:Result<PhotosModel, Error>) in
            
            guard let strongSelf = self else { return }
            strongSelf.uiActions.onNext(.hideLoading)
            switch result {
            case .success(let photos):
                if photos.count == 0 {
                    strongSelf.uiActions.onNext(.showNoData)
                }
                else {
                    var items = [RowViewModel]()
                    for photo in photos {
                        items.append(RowViewModel(cellIdentifier: PhotoCollectionCell.cellIdentifier, data: photo))
                    }
                    strongSelf.rowItems.accept(items)
                }
            case .failure(let error):
                strongSelf.uiActions.onNext(.showError(title: "API Error", message: error.localizedDescription))
            }
        }
    }
    
    enum UIActionType {
        case
        showLoading,
        hideLoading,
        showNoData,
        showError(title: String, message: String?)
    }
}

//
//  GalleryViewController.swift
//  GalleryDemo
//
//  Created by Bhavik Modi on 18/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel = PhotosViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViewsWithRx()
        viewModel.getPhotos()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: PhotoCollectionCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PhotoCollectionCell.cellIdentifier)
    }
    
    // Setup View with Rx
    private func setupViewsWithRx() {
        /// Manage UI Actions
        viewModel.uiActions.subscribe(onNext: { [weak self] uiActions in
            guard let strongSelf = self else { return }
            
            switch uiActions {
            case .showLoading:
                strongSelf.showLoading()
                break
            case .hideLoading:
                strongSelf.hideLoading()
                break
            case .showNoData:
                strongSelf.collectionView.isHidden = true
                strongSelf.noDataView.isHidden = false
            case .showError(let title, let message):
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.rowItems.bind(to: collectionView.rx.items){ (collectionView, index, viewModel) -> UICollectionViewCell in

            guard let cellIdentifier = viewModel.cellIdentifier,cellIdentifier.count > 0 else {
                let cell = UICollectionViewCell()
                cell.backgroundColor = UIColor.clear
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: IndexPath.init(row: index, section: 0)) as! PhotoCollectionCell
            cell.setupCell(rowViewModel: viewModel)
            print(index)
            
            return cell
        }.disposed(by: disposeBag)
        
        // Item did select
//        collectionView
//            .rx
//            .modelSelected(RowViewModel.self)
//            .subscribe(onNext: { (item) in
//
//            }).disposed(by: disposeBag)
        
        Observable
            .zip(
                collectionView
                    .rx
                    .itemSelected
                ,collectionView
                    .rx
                    .modelSelected(RowViewModel.self))
            .bind{ [weak self] indexPath, model in
                guard let photo = model.data as? Photos else { return }
                self?.presentFullImage(photo: photo)
            }
            .disposed(by: disposeBag)
    }
    
    // Show Full image
    func presentFullImage(photo: Photos) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoVC = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        photoVC.model = photo
        photoVC.modalTransitionStyle = .crossDissolve
        photoVC.modalPresentationStyle = .overCurrentContext
        self.present(photoVC, animated: true, completion: nil)
    }
    
    // MARK: - Hide/Show Loading
    func showLoading() {
        loadingView.isHidden = false
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        loadingView.isHidden = true
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Collection View Delegate
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = collectionView.frame.width/3
        return CGSize(width: cellSize-6, height: cellSize)
    }
}

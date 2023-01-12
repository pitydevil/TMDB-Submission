//
//  ViewController.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

class HomeViewController: UIViewController {

    //MARK: OBJECT DECLARATION
    private let homeViewModel = HomeViewModel()
    private let topRatedMoviesList : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private let upcomingMoviesList : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private let nowPlayingMoviesList : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    
    //MARK: LAYOUT SUBVIEWS
    @IBOutlet weak var topRatedCard: CustomViewCollection!
    @IBOutlet weak var upcomingCard: CustomViewCollection!
    @IBOutlet weak var nowPlayingCard: CustomViewCollection!
    
    //MARK: VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - Bind Journal List with Table View
        /// Bind journal list with journalingTableView
        Task {
            SVProgressHUD.show(withStatus: "Fetching Movies")
            await homeViewModel.onAppear()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Register Controller
        topRatedCard.collectionViewLabel.text = "Top Rated Movies"
        upcomingCard.collectionViewLabel.text = "Upcoming Moives"
        nowPlayingCard.collectionViewLabel.text = "Now Playing Movies"
      
        //MARK: - Register Controller
      //  detailController = UIStoryboard(name: "Journal", bundle: nil).instantiateViewController(identifier: "detailViewController") as DetailJournalViewController
        
        //MARK: - Bind topRatedMoviesList with Table View
        /// Bind journal list with journalingTableView
        topRatedMoviesList.bind(to: topRatedCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
            cell.configureCell(model)
        }.disposed(by: bags)
        
        //MARK: - Bind upcomingMoviesList with Table View
        /// Bind journal list with journalingTableView
        upcomingMoviesList.bind(to: upcomingCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
            cell.configureCell(model)
        }.disposed(by: bags)
        
        //MARK: - Bind nowPlayingMoviesList with Table View
        /// Bind journal list with journalingTableView
        nowPlayingMoviesList.bind(to: nowPlayingCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
            cell.configureCell(model)
        }.disposed(by: bags)
        
        //MARK: - Observer for Pet Type Value
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        homeViewModel.nowPlayingMoviesArrayObjectObserver.subscribe(onNext: { [self] (value) in
            SVProgressHUD.dismiss()
            nowPlayingMoviesList.accept(value)
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Observer for Pet Type Value
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        homeViewModel.upcomingMoviesArrayObjectObserver.subscribe(onNext: { [self] (value) in
            SVProgressHUD.dismiss()
            upcomingMoviesList.accept(value)
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Observer for Pet Type Value
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        homeViewModel.topRatedMoviesArrayObjectObserver.subscribe(onNext: { [self] (value) in
            SVProgressHUD.dismiss()
            topRatedMoviesList.accept(value)
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Observer for Error State
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        homeViewModel.genericHandlingErrorObserver.skip(1).subscribe(onNext: { (value) in
            DispatchQueue.main.async { [self] in
                present(genericAlert(titleAlert: "Telah terjadi kesalahan pada server!", messageAlert: "Silahkan coba beberapa saat lagi.", buttonText: "OK"), animated: true)
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Response Collection View DidSelect Delegate Function
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        nowPlayingCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
            nowPlayingCard.collectionView.deselectItem(at: indexPath, animated: true)
//            detailController?.journalObject = BehaviorRelay(value: Journal())
//            navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Response Collection View DidSelect Delegate Function
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        upcomingCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
            nowPlayingCard.collectionView.deselectItem(at: indexPath, animated: true)
//            detailController?.journalObject = BehaviorRelay(value: Journal())
//            navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Response Collection View DidSelect Delegate Function
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        topRatedCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
            nowPlayingCard.collectionView.deselectItem(at: indexPath, animated: true)
//            detailController?.journalObject = BehaviorRelay(value: Journal())
//            navigationController?.pushViewController(detailController ?? DetailJournalViewController(), animated: true)
        }).disposed(by: bags)
    }
}

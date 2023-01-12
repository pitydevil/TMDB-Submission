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


public class HomeViewController: UIViewController {

    //MARK: OBJECT DECLARATION
    private let homeViewModel = HomeViewModel()
    private let topRatedMoviesList : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private let upcomingMoviesList : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private let nowPlayingMoviesList : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private var detailController     : DetailViewController?
    
    //MARK: LAYOUT SUBVIEWS
    @IBOutlet weak var topRatedCard: CustomViewCollection!
    @IBOutlet weak var upcomingCard: CustomViewCollection!
    @IBOutlet weak var nowPlayingCard: CustomViewCollection!
    
    //MARK: VIEW WILL APPEAR
    public override func viewWillAppear(_ animated: Bool) {
        //MARK: - OnAppear Function
        /// Fetch all movies type endpoint from server
        Task {
            SVProgressHUD.show(withStatus: "Fetching Movies")
            await homeViewModel.onAppear()
        }
    }
    
    //MARK: VIEW DID LOAD
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Instantiate Collection View Label
        topRatedCard.collectionViewLabel.text   = "Top Rated Movies"
        upcomingCard.collectionViewLabel.text   = "Upcoming Movies"
        nowPlayingCard.collectionViewLabel.text = "Now Playing Movies"
      
        //MARK: - Register Controller
        detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailViewController") as DetailViewController
        
        //MARK: - TableView Datasource and Delegate Functions
            //MARK: - Bind topRatedMoviesList with Table View
            /// Bind topRatedMoviesList with Table View
            topRatedMoviesList.bind(to: topRatedCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
                /// Configure Table View cell based on Top Rated Movie Object.
                cell.configureCell(model)
            }.disposed(by: bags)
            
            //MARK: - Bind upcomingMoviesList with Table View
            /// Bind upcomingMoviesList with Table View
            upcomingMoviesList.bind(to: upcomingCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
                /// Configure Table View cell based on Upcoming Movie Object.
                cell.configureCell(model)
            }.disposed(by: bags)
            
            //MARK: - Bind nowPlayingMoviesList with Table View
            /// Bind nowPlayingMoviesList with Table View
            nowPlayingMoviesList.bind(to: nowPlayingCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
                /// Configure Table View cell based on Now Palying Movie Object.
                cell.configureCell(model)
            }.disposed(by: bags)
        
            //MARK: - Now Playing Collection View DidSelect Delegate Function
            /// Response User Touch on Now Playing Collection View
            nowPlayingCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
                
                /// Send User's choosen Now Playing Movie Object to response handleMovieFunction
                responseHandleMovie(nowPlayingMoviesList.value[indexPath.row], indexPath, nowPlayingCard.collectionView)
            }).disposed(by: bags)
            
            //MARK: - Upcoming Collection View DidSelect Delegate Function
            /// Response User Touch on Upcoming Collection View
            upcomingCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
                
                /// Send User's choosen Upcoming Movie Object to response handleMovieFunction
                responseHandleMovie(upcomingMoviesList.value[indexPath.row], indexPath, upcomingCard.collectionView)
            }).disposed(by: bags)
            
            //MARK: - Top Rated Collection View DidSelect Delegate Function
            /// Response User Touch on Top Rated Collection View
            topRatedCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
                /// Send User's choosen Top Rated Movie Object to response handleMovieFunction
                responseHandleMovie(topRatedMoviesList.value[indexPath.row], indexPath,topRatedCard.collectionView)
            }).disposed(by: bags)
        
        //MARK: - Object Observer for UI Logic.
            //MARK: - Observer for Upcoming Movie List
            /// Update upcomingMovieList on value changes
            homeViewModel.upcomingMoviesArrayObjectObserver.subscribe(onNext: { [self] (value) in
                SVProgressHUD.dismiss()
                upcomingMoviesList.accept(value)
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
            
            //MARK: - Observer for Top Rated Movie List
            /// Update topRatedMovieList on value changes
            homeViewModel.topRatedMoviesArrayObjectObserver.subscribe(onNext: { [self] (value) in
                SVProgressHUD.dismiss()
                topRatedMoviesList.accept(value)
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
        
            //MARK: - Observer for Now Playing Movie List
            /// Update nowPlayingMovieList on value changes
            homeViewModel.nowPlayingMoviesArrayObjectObserver.subscribe(onNext: { [self] (value) in
                SVProgressHUD.dismiss()
                nowPlayingMoviesList.accept(value)
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
        
        //MARK: - Observer for Endpoint Error State
            //MARK: - Observer for Endpoint Error
            /// Inform user if there's any problem with their internet connection via UIAlertController
            /// from the given components.
            homeViewModel.genericHandlingErrorObserver.skip(1).subscribe(onNext: { (value) in
                DispatchQueue.main.async { [self] in
                    SVProgressHUD.dismiss()
                    popupAlert(title: "Telah Terjadi Gangguan di Server!", message: "Silahkan coba beberapa saat lagi.", actionTitles: ["OK"], actionsStyle: [UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                        dismiss(animated: true)
                    },nil])
                }
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
    }
   
    //MARK: - Component Function for Collection View DidSelect Delegate Func
    /// Segue User to detailViewController, and pass moviie id object to detailViewController
    /// - Parameters:
    ///     - movies: movie id object that's gonna be passed on to detailViewController
    ///     - indexpath: row and column that's gonna be used for deselect delegate function
    ///     - collectionView: collectionView object to determine which collectionView is triggered by the user.
    private func responseHandleMovie(_ movies: Movies,_ indexPath : IndexPath, _ collectionView: UICollectionView) {
        collectionView.deselectItem(at: indexPath, animated: true)
        detailController?.movieIdObject.accept(movies.id)
        navigationController?.pushViewController(detailController ?? DetailViewController(), animated: true)
    }
}

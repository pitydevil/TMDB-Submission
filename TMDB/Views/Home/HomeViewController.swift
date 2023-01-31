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
    private let genreCountObject : BehaviorRelay<GenreBody> = BehaviorRelay(value: GenreBody())
    private let discoverMoviesList : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private let genresList : BehaviorRelay<[Genres]> = BehaviorRelay(value: [])
    private var detailController     : DetailViewController?
    
    //MARK: LAYOUT SUBVIEWS
    @IBOutlet weak var discoverCard: CustomViewCollection!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: VIEW WILL APPEAR
    public override func viewWillAppear(_ animated: Bool) {
        //MARK: - OnAppear Function
        /// Fetch all movies type endpoint from server
        Task {
            SVProgressHUD.show(withStatus: "Fetching Movies")
            await homeViewModel.onAppear(genreCountObject.value)
        }
    }
    
    //MARK: VIEW DID LOAD
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        //MARK: - Instantiate Collection View Label
        discoverCard.collectionViewLabel.text   = "Discover Movies"
        discoverCard.collectionView.rx.setDelegate(self).disposed(by: bags)
      
        //MARK: - Register Controller
        detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailViewController") as DetailViewController
        
        //MARK: - TableView Datasource and Delegate Functions
     
            //MARK: - Bind upcomingMoviesList with Table View
            /// Bind upcomingMoviesList with Table View
            discoverMoviesList.bind(to: discoverCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
                /// Configure Table View cell based on Upcoming Movie Object.
                cell.configureCell(model)
            }.disposed(by: bags)
        
            //MARK: - Bind upcomingMoviesList with Table View
            /// Bind upcomingMoviesList with Table View
            genresList.bind(to: genresCollectionView.rx.items(cellIdentifier: GenresCollectionViewCell.cellID, cellType: GenresCollectionViewCell.self)) { row, model, cell in
                /// Configure Table View cell based on Genres
                cell.configureCell(model)
            }.disposed(by: bags)
            
            //MARK: - Upcoming Collection View DidSelect Delegate Function
            /// Response User Touch on Upcoming Collection View
            discoverCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
                /// Send User's choosen Upcoming Movie Object to response handleMovieFunction
                responseHandleMovie(discoverMoviesList.value[indexPath.row], indexPath, discoverCard.collectionView)
            }).disposed(by: bags)
        
            //MARK: - Upcoming Collection View DidSelect Delegate Function
            /// Response User Touch on Upcoming Collection View
            genresCollectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
                /// Send User's choosen Upcoming Movie Object to response handleMovieFunction
                DispatchQueue.main.async { [self] in
                    SVProgressHUD.show(withStatus: "Fetching Movies")
                    discoverCard.collectionViewLabel.text = "Discover \(genresList.value[indexPath.row].name) Movies"
                }
                Task {
                    genreCountObject.accept(GenreBody(page: 1, genresName: String(genresList.value[indexPath.row].id)))
                    homeViewModel.discoverMoviesArrayObject.accept([])
                    await homeViewModel.fetchMovies(genreCountObject.value)
                }
            }).disposed(by: bags)
        
        //MARK: - Object Observer for UI Logic.
            //MARK: - Observer for Upcoming Movie List
            /// Update upcomingMovieList on value changes
            homeViewModel.discoverMoviesArrayObjectObserver.subscribe(onNext: { [self] (value) in
                DispatchQueue.main.async { [self] in
                    SVProgressHUD.dismiss()
                    refreshControl.endRefreshing()
                }
                discoverMoviesList.accept(value)
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
        
            //MARK: - Observer for Upcoming Movie List
            /// Update upcomingMovieList on value changes
            homeViewModel.genresArrayObjectObserver.subscribe(onNext: { [self] (value) in
                DispatchQueue.main.async { [self] in
                    SVProgressHUD.dismiss()
                    refreshControl.endRefreshing()
                }
                genresList.accept(value)
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
                        navigationController!.popToRootViewController(animated: true)
                    }])
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
    
    @objc func refresh(_ sender: AnyObject) {
        Task {
            SVProgressHUD.show(withStatus: "Fetching Movies")
            await homeViewModel.fetchMovies(genreCountObject.value)
        }
    }
}

extension HomeViewController : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if homeViewModel.determineScrollViewPosition(scrollView) {
            Task {
                genreCountObject.accept(GenreBody(page: genreCountObject.value.page+1, genresName: genreCountObject.value.genresName))
                SVProgressHUD.show(withStatus: "Fetching Movies")
                await homeViewModel.fetchMovies(genreCountObject.value)
            }
        }
    }
}

extension HomeViewController : UICollectionViewDelegate {
    
}

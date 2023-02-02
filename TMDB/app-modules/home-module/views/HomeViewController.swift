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

public class HomeViewController: UIViewController, UICollectionViewDelegate {

    //MARK: OBJECT DECLARATION
    var presentor : ViewToPresenterProtocol?
    
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
            await presentor?.onAppear(genreCountObject.value)
        }
    }
    
    //MARK: VIEW DID LOAD
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Instantiate Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        //MARK: - Set Delegate for collectionView
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
                print("collectionView")
                presentor?.showDetailController(navigationController: self.navigationController! as! NavigationController, movieIdObject: discoverMoviesList.value[indexPath.row].id)
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
                    await presentor?.startFetchMovies(genreCountObject.value, true)
                }
            }).disposed(by: bags)
    }
       
    @objc func refresh(_ sender: AnyObject) {
        Task {
            SVProgressHUD.show(withStatus: "Fetching Movies")
            await presentor?.startFetchMovies(genreCountObject.value, false)
        }
    }
}

extension HomeViewController : UIScrollViewDelegate {
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == discoverCard.collectionView {
            presentor?.determineScrollViewPosition(scrollView)
        }
    }
}

extension HomeViewController : PresenterToViewProtocol {
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    /// - Parameters:
    ///     - enumState: movie type that's gonan be passed onto the fetch movie endpoint
    func showMovies(_ moviesArray: Array<Movies>) {
        DispatchQueue.main.async { [self] in
            SVProgressHUD.dismiss()
            refreshControl.endRefreshing()
        }
        discoverMoviesList.accept(moviesArray)
    }
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    /// - Parameters:
    ///     - enumState: movie type that's gonan be passed onto the fetch movie endpoint
    func showGenres(_ genre: Array<Genres>) {
        DispatchQueue.main.async { [self] in
            SVProgressHUD.dismiss()
            refreshControl.endRefreshing()
        }
        genresList.accept(genre)
    }
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    /// - Parameters:
    ///     - enumState: movie type that's gonan be passed onto the fetch movie endpoint
    func showScrollViewPosition(_ result: Bool) {
        switch result {
            case true:
                Task {
                    genreCountObject.accept(GenreBody(page: genreCountObject.value.page+1, genresName: genreCountObject.value.genresName))
                    SVProgressHUD.show(withStatus: "Fetching Movies")
                    await presentor?.startFetchMovies(genreCountObject.value, false)
                }
            default:
                print("gagal")
        }
    }
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    func showError() {
        DispatchQueue.main.async { [self] in
            popupAlert(title: "Telah Terjadi Gangguan di Server!", message: "Silahkan coba beberapa saat lagi.", actionTitles: ["OK"], actionsStyle: [UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                navigationController!.popToRootViewController(animated: true)
            }])
        }
    }
}

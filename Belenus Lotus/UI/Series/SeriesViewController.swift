//
//  SeriesViewController.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 27.05.2021.
//

import UIKit

class SeriesViewController: UIViewController, Instantiatable {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var scrollUpButton: UIButton!
    private let searchController = UISearchController(searchResultsController: nil)
    private let genrePicker = UIPickerView()
    private lazy var genreButton = GenreButton { [weak self] (button) in
        button.inputView = self?.genrePicker
    }
    
    private var mediator = SeriesMediator()
    private var viewModel = ViewModel()
    
    static func create() -> UINavigationController {
        let vc = SeriesViewController.instantiate()
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: ViewModel.title,
                                     image: UIImage(systemName: ViewModel.tabBarImageName),
                                     selectedImage: UIImage(systemName: ViewModel.tabBarSelectedImageName))
        return nc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBar()
    }
    
    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self)
        
        segmentControl.addTarget(self, action: #selector(segmentUpdated), for: .primaryActionTriggered)
        segmentControl.selectedSegmentTintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        scrollUpButton.addTarget(self, action: #selector(scrollUp), for: .touchUpInside)
        scrollUpButton.isHidden = true
        self.update()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.backButtonTitle = ""
        
        let titleLabel = UILabel()
        titleLabel.text = ViewModel.title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        genrePicker.dataSource = self
        genrePicker.delegate = self
        navigationItem.setRightBarButton(UIBarButtonItem(customView: genreButton), animated: true)
        mediator.getGenres { [weak self] (genres) in
            self?.viewModel.update(genres)
            self?.updateGenreButton()
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ViewModel.searchBarPlaceholder
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    private func update() {
        mediator.getMedia(update(withResult:))
    }
    
    private func update(withResult result: Result<[Series], Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case let .success(series):
                self?.viewModel.update(series) {
                    self?.collectionView.reloadData()
                }
            case let .failure(error):
                self?.viewModel.update([] as [Series])
                self?.presentAlert(for: error)
            }
            self?.updateGenreButton()
        }
    }
    
    private func updateGenreButton() {
        DispatchQueue.main.async { [weak self] in
            self?.genreButton.setTitle(self?.viewModel.getSelectedGenreName(), for: .normal)
        }
    }
    
    @objc private func segmentUpdated() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            mediator.setCollectionType(to: .discover(genre: viewModel.getSelectedGenreId()), completion: update(withResult:))
            genreButton.isHidden = false
        case 1:
            mediator.setCollectionType(to: .topRated, completion: update(withResult:))
            genreButton.isHidden = true
        default:
            break
        }
    }
    
    @objc private func scrollUp() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: true)
    }
    
    private func presentAlert(for error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension SeriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ImageCollectionViewCell.self, for: indexPath)
        cell.imagePath = viewModel.cellData[indexPath.row].posterPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(SeriesDetailViewController.create(withId: viewModel.cellData[indexPath.row].id), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = viewModel.getImageSize(forScreenWidth: Double(UIScreen.main.bounds.width))
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.cellData.count - 10 {
            update()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > UIScreen.main.bounds.height {
            scrollUpButton.isHidden = false
        } else {
            scrollUpButton.isHidden = true
        }
    }
}

extension SeriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let key = searchController.searchBar.text, key != "" {
            mediator.setCollectionType(to: .search(key: key), completion: update(withResult:))
        } else {
            segmentUpdated()
        }
    }
}

extension SeriesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getGenreList().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getGenreList()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setSelectedGenre(viewModel.getGenreList()[row])
        mediator.setCollectionType(to: .discover(genre: viewModel.getSelectedGenreId()), completion: update(withResult:))
    }
}

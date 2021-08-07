//
//  MediaCollectionViewController.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 26.07.2021.
//

import UIKit

class MediaCollectionViewController: UIViewController, Instantiatable {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var scrollUpButton: UIButton!
    private let searchController = UISearchController(searchResultsController: nil)
    private let genrePicker = UIPickerView()
    private lazy var genreButton = GenreButton { [weak self] (button) in
        button.inputView = self?.genrePicker
    }
    
    private var viewModel: ViewModel!
    
    static func create(for type: ViewModel.MediaType) -> UINavigationController {
        let vc = MediaCollectionViewController.instantiate()
        vc.viewModel = ViewModel(
            type,
            genreHandler: { [weak vc] in
                DispatchQueue.main.async {
                    vc?.genreButton.setTitle(vc?.viewModel.selectedGenre, for: .normal)
                    vc?.genreButton.setNeedsLayout()
                }
            }, mediaHandler: { [weak vc] in
                DispatchQueue.main.async {
                    vc?.collectionView.reloadData()
                }
            }, errorHandler: { [weak vc] (error) in
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                DispatchQueue.main.async {
                    vc?.present(alert, animated: true, completion: nil)
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        )
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: vc.viewModel.title,
                                     image: UIImage(systemName: vc.viewModel.tabBarImageName),
                                     selectedImage: UIImage(systemName: vc.viewModel.tabBarSelectedImageName))
        return nc
    }
    
    deinit {
        viewModel = nil
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
        viewModel.discover()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.backButtonTitle = ""
        
        let titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        genrePicker.dataSource = self
        genrePicker.delegate = self
        navigationItem.setRightBarButton(UIBarButtonItem(customView: genreButton), animated: true)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    @objc private func segmentUpdated() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            viewModel.discover()
            genreButton.isHidden = false
        case 1:
            viewModel.topRated()
            genreButton.isHidden = true
        default:
            break
        }
    }
    
    @objc private func scrollUp() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: true)
    }
}

extension MediaCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ImageCollectionViewCell.self, for: indexPath)
        cell.imagePath = viewModel.posters[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedMediaAt(row: indexPath.row, in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = viewModel.getImageSize(forScreenWidth: Double(UIScreen.main.bounds.width))
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.posters.count - 10 {
            viewModel.next()
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

extension MediaCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let key = searchController.searchBar.text, key != "" {
            viewModel.search(key)
        } else {
            segmentUpdated()
        }
    }
}

extension MediaCollectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.genres.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.genres[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setSelectedGenre(to: viewModel.genres[row])
    }
}

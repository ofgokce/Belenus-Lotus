//
//  MovieDetailViewController.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 1.06.2021.
//

import UIKit

class MovieDetailViewController: UIViewController, Instantiatable {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var id: Int!
    
    private var mediator = MoviesMediator()
    private var viewModel: ViewModel!
    
    static func create(withId id: Int) -> MovieDetailViewController {
        let vc = MovieDetailViewController.instantiate()
        vc.id = id
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupNavBar()
        
        mediator.getMovie(withId: id) { [unowned self] (result) in
            switch result {
            case let .success(series):
                viewModel = ViewModel(with: series)
                mediator.setCollectionType(to: .recommended(forMovieWithId: id)) { (result) in
                    switch result {
                    case let .success(series):
                        viewModel.updateRecommended(with: series)
                    default: break
                    }
                    setupDetails()
                    setupTableView()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                    alert.present(navigationController!, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
    }
    
    private func setupDetails() {
        DispatchQueue.main.async { [unowned self] in
            backdropImageView.kf.setImage(with: ImagesMediator().getBackdropUrl(for: viewModel.backdropPath))
            titleLabel.attributedText = viewModel.titleAttributed
            taglineLabel.text = viewModel.tagline
        }
    }
    
    private func setupTableView() {
        DispatchQueue.main.async { [unowned self] in
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ImageCollectionTableViewCell.self)
            tableView.reloadData()
        }
    }
    
    private func navigateToSeries(withId id: Int) {
        navigationController?.pushViewController(MovieDetailViewController.create(withId: id), animated: true)
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.tableViewData[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.tableViewData[section].data {
        case .imageBased: return 1
        case let .textBased(cells): return cells.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.tableViewData[indexPath.section].data {
        case let .imageBased(cellData):
            let cell = tableView.dequeueReusableCell(ImageCollectionTableViewCell.self, for: indexPath)
            let cellSize = viewModel.getImageSize(forScreenWidth: Double(UIScreen.main.bounds.width))
            cell.cellData = cellData
            cell.cellSize = CGSize(width: cellSize.width, height: cellSize.height)
            cell.selectionCallback = navigateToSeries(withId:)
            return cell
        case let .textBased(cells):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = cells[indexPath.row].text
            cell.detailTextLabel?.text = cells[indexPath.row].detail
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.numberOfLines = 0
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.tableViewData[indexPath.section].data {
        case .textBased:
            return UITableView.automaticDimension
        case .imageBased:
            return CGFloat(viewModel.getImageSize(forScreenWidth: Double(UIScreen.main.bounds.width)).height) + 20
        }
    }
}

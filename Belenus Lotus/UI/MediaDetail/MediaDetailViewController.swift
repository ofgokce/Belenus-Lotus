//
//  MediaDetailViewController.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 1.06.2021.
//

import UIKit

class MediaDetailViewController: UIViewController, Instantiatable {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: ViewModel!
    
    static func create(withMovieId id: Int) -> MediaDetailViewController {
        let vc = MediaDetailViewController.instantiate()
        vc.viewModel = ViewModel(
            withMovieId: id,
            dataHandler: { [weak vc] in
                vc?.setupDetails()
                vc?.setupTableView()
            }, errorHandler: { [weak vc] (error) in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                    vc?.present(alert, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            vc?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        )
        return vc
    }
    
    static func create(withSeriesId id: Int) -> MediaDetailViewController {
        let vc = MediaDetailViewController.instantiate()
        vc.viewModel = ViewModel(
            withSeriesId: id,
            dataHandler: { [weak vc] in
                vc?.setupDetails()
                vc?.setupTableView()
            }, errorHandler: { [weak vc] (error) in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                    vc?.present(alert, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            vc?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        )
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
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
            backdropImageView.load(fromUrl: ImagesMediator().getBackdropUrl(for: viewModel.backdropPath))
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
//        navigationController?.pushViewController(MediaDetailViewController.create(withId: id), animated: true)
    }
}

extension MediaDetailViewController: UITableViewDelegate, UITableViewDataSource {
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

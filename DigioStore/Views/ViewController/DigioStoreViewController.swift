//
//  DigioStoreViewController.swift
//  DigioStore
//
//  Created by Milton Leslie Sanches on 22/08/24.
//

import UIKit

class DigioStoreViewController: UIViewController {
    private let viewModel: DigioStoreViewModel

    init(viewModel: DigioStoreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        viewModel.fetchData()
    }

    private func setupViews() {

    }
}

extension DigioStoreViewController: DigioStoreViewModelDelegate {
    func didUpdateData() {
        DispatchQueue.main.async {
            
        }
    }

    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            
        }
    }
}

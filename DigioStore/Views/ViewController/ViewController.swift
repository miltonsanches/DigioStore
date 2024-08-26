//
//  ViewController.swift
//  DigioStore
//
//  Created by Milton Leslie Sanches on 22/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let spotlightScrollView = UIScrollView()
    internal let spotlightStackView = UIStackView()
    private let cashLabel = UILabel()
    private let cashStackView = UIStackView()
    private let productsLabel = UILabel()
    private let productsScrollView = UIScrollView()
    private let productsStackView = UIStackView()

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

        setupView()
        setupConstraints()
        viewModel.delegate = self
        viewModel.fetchData()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func configureSpotlight(with data: DigioStoreData) {
        spotlightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, spotlightItem) in data.spotlight.enumerated() {
            let imageView = createRoundedImageView()
            imageView.contentMode = .scaleAspectFill
            loadImage(from: URL(string: spotlightItem.bannerURL)!) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }

            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.widthAnchor.constraint(equalToConstant: 400).isActive = true
            container.addSubview(imageView)
            container.tag = index

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: container.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])

            spotlightStackView.addArrangedSubview(container)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(spotlightTapped(_:)))
            container.addGestureRecognizer(tapGesture)
        }

        let totalWidth = CGFloat(data.spotlight.count) * (350 + 10)
        spotlightScrollView.contentSize = CGSize(width: totalWidth, height: 150)
        
    }

    @objc private func spotlightTapped(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag, let data = viewModel.digioStoreData {
            let spotlightItem = data.spotlight[tag]
            let detailsVC = ViewControllerDetails(item: spotlightItem)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }

    @objc private func cashTapped(_ sender: UITapGestureRecognizer) {
        if let data = viewModel.digioStoreData {
            let cashItem = data.cash
            let detailsVC = ViewControllerDetails(item: cashItem)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    private func configureCashStackView(with cash: Cash) {
        let cashImageView = createRoundedImageView()
        if let url = URL(string: cash.bannerURL) {
            loadImage(from: url, into: cashImageView) { success in
                DispatchQueue.main.async {
                    if success {
                        cashImageView.isHidden = false
                    } else {
                        cashImageView.isHidden = true
                    }
                }
            }
        }
        cashStackView.addArrangedSubview(cashImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cashTapped(_:)))
        cashStackView.isUserInteractionEnabled = true
        cashStackView.addGestureRecognizer(tapGesture)
    }
    
    func configureProducts(with data: DigioStoreData) {
        productsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for product in data.products {
            let imageView = createRoundedImageView()

            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.widthAnchor.constraint(equalToConstant: 120).isActive = true
            container.heightAnchor.constraint(equalToConstant: 120).isActive = true
            container.backgroundColor = .white
            container.layer.cornerRadius = 20
            container.layer.shadowColor = UIColor.gray.cgColor
            container.layer.shadowOpacity = 0.5
            container.layer.shadowOffset = CGSize(width: 0, height: 2)
            container.layer.shadowRadius = 4

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = product.name
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .black
    
            container.addSubview(imageView)
            container.addSubview(label)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),
                imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 60),
                imageView.heightAnchor.constraint(equalToConstant: 60),
                label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                label.topAnchor.constraint(equalTo: container.topAnchor, constant: 50)
            ])

            productsStackView.addArrangedSubview(container)
            
            if let url = URL(string: product.imageURL) {
                loadImage(from: url, into: imageView) { success in
                    DispatchQueue.main.async {
                        if success {
                            imageView.isHidden = false
                            label.isHidden = true
                        } else {
                            imageView.isHidden = true
                            label.isHidden = false
                        }
                    }
                }
            } else {
                label.isHidden = false
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(productTapped(_:)))
            container.addGestureRecognizer(tapGesture)
            container.tag = data.products.firstIndex(of: product) ?? 0
        }

        let totalWidth = CGFloat(data.products.count) * (350 + 10)
        productsScrollView.contentSize = CGSize(width: totalWidth, height: 150)
    }

    @objc private func productTapped(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag, let data = viewModel.digioStoreData {
            let product = data.products[tag]
            let detailsVC = ViewControllerDetails(item: product)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }

    private func loadImage(from url: URL, into imageView: UIImageView, completion: @escaping (Bool) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                    completion(true)
                }
            } else {
                completion(false)
            }
        }.resume()
    }

    private func setupView() {
        view.backgroundColor = .white

        spotlightScrollView.translatesAutoresizingMaskIntoConstraints = false
        spotlightScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(spotlightScrollView)
        spotlightStackView.translatesAutoresizingMaskIntoConstraints = false
        spotlightStackView.axis = .horizontal
        spotlightStackView.spacing = 10
        spotlightStackView.alignment = .center
        spotlightScrollView.addSubview(spotlightStackView)
        
        view.addSubview(cashLabel)
        let cashText = NSMutableAttributedString(string: "digio ", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ])
        cashText.append(NSAttributedString(string: "Cash", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.gray
        ]))
        cashLabel.attributedText = cashText
        cashLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cashStackView)
        cashStackView.axis = .horizontal
        cashStackView.distribution = .fillEqually
        cashStackView.spacing = 10
        cashStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(productsLabel)
        productsLabel.text = "Produtos"
        productsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        productsLabel.textColor = .black
        productsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(productsScrollView)
        productsScrollView.translatesAutoresizingMaskIntoConstraints = false
        productsScrollView.showsHorizontalScrollIndicator = true
        productsStackView.translatesAutoresizingMaskIntoConstraints = false
        productsStackView.axis = .horizontal
        productsStackView.spacing = 20
        productsScrollView.addSubview(productsStackView)
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            spotlightScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            spotlightScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            spotlightScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            spotlightScrollView.heightAnchor.constraint(equalToConstant: 200),
            spotlightStackView.topAnchor.constraint(equalTo: spotlightScrollView.topAnchor),
            spotlightStackView.leadingAnchor.constraint(equalTo: spotlightScrollView.leadingAnchor, constant: 5),
            spotlightStackView.trailingAnchor.constraint(equalTo: spotlightScrollView.trailingAnchor, constant: -5),
            spotlightStackView.bottomAnchor.constraint(equalTo: spotlightScrollView.bottomAnchor),
            spotlightStackView.heightAnchor.constraint(equalTo: spotlightScrollView.heightAnchor),
            
            cashLabel.topAnchor.constraint(equalTo: spotlightScrollView.bottomAnchor, constant: 40),
            cashLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cashLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cashLabel.heightAnchor.constraint(equalToConstant: 24),
            cashStackView.topAnchor.constraint(equalTo: cashLabel.bottomAnchor, constant: 10),
            cashStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cashStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cashStackView.heightAnchor.constraint(equalToConstant: 100),

            productsLabel.topAnchor.constraint(equalTo: cashStackView.bottomAnchor, constant: 40),
            productsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            productsScrollView.topAnchor.constraint(equalTo: productsLabel.bottomAnchor, constant: 20),
            productsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            productsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            productsScrollView.heightAnchor.constraint(equalToConstant: 150),
            productsStackView.leadingAnchor.constraint(equalTo: productsScrollView.leadingAnchor, constant: 5),
            productsStackView.trailingAnchor.constraint(equalTo: productsScrollView.trailingAnchor, constant: -5),
            productsStackView.topAnchor.constraint(equalTo: productsScrollView.topAnchor),
            productsStackView.bottomAnchor.constraint(equalTo: productsScrollView.bottomAnchor),
            
        ])
    }

    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }


    private func createRoundedImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension ViewController: DigioStoreViewModelDelegate {
    func didUpdateData() {
        DispatchQueue.main.async {
            if let data = self.viewModel.digioStoreData {
                self.configureSpotlight(with: data)
                self.configureCashStackView(with: data.cash)
                self.configureProducts(with: data)
            }
        }
    }

    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

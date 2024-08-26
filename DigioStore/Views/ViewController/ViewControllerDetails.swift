//
//  ViewControllerDetails.swift
//  DigioStore
//
//  Created by Milton Leslie Sanches on 23/08/24.
//

import UIKit

protocol DetailItem {
    var displayName: String { get }
    var displayURL: String { get }
    var displayDescription: String { get }
}

extension Spotlight: DetailItem {
    var displayName: String { return name }
    var displayURL: String { return bannerURL }
    var displayDescription: String { return description }
}

extension Cash: DetailItem {
    var displayName: String { return title }
    var displayURL: String { return bannerURL }
    var displayDescription: String { return description }
}

extension Product: DetailItem {
    var displayName: String { return name }
    var displayURL: String { return imageURL }
    var displayDescription: String { return description }
}

class ViewControllerDetails: UIViewController {

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let item: DetailItem

    init(item: DetailItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureView()
    }

    private func setupView() {
        view.backgroundColor = .white

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        view.addSubview(imageView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureView() {
        nameLabel.text = item.displayName
        descriptionLabel.text = item.displayDescription
        loadImage(from: URL(string: item.displayURL)!) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image

                if let image = image {
                    let aspectRatio = image.size.width / image.size.height
                    let aspectRatioConstraint = NSLayoutConstraint(item: self!.imageView, attribute: .width, relatedBy: .equal, toItem: self!.imageView, attribute: .height, multiplier: aspectRatio, constant: 0)
                    aspectRatioConstraint.isActive = true
                }
            }
        }
    }

    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

//
//  SelectedMenuViewController.swift
//  FoodRecommendation
//
//  Created by 전민수 on 2023/07/19.
//

import UIKit

final class SelectedMenuViewController: UIViewController {

    // MARK: Properties

    private let menuDescriptionStackView = UIStackView()
    private let firstDescriptionLabel = UILabel()
    private let menuLabel = UILabel()
    private let secondDescriptionLabel = UILabel()
    private let homeButton = UIButton()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        addActionForButtonEvent()
    }

    // MARK: - Methods

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = UIImageView(image: UIImage(systemName: "star.fill"))

        configureUI()
    }

    private func configureUI() {
        menuDescriptionStackView.configureUI(axis: .vertical, alignment: .fill, distribution: .equalSpacing)
        firstDescriptionLabel.configureUI(text: "오늘 \(getEatingTimePhrase()) 메뉴는", textAlignment: .left)
        menuLabel.configureUI(text: "새우 초밥", textAlignment: .center, font: .preferredFont(forTextStyle: .largeTitle))
        secondDescriptionLabel.configureUI(text: "이 좋겠군...", textAlignment: .right)
        homeButton.configureUI(title: "처음으로", titleColor: .white, backgroundColor: .systemGreen, cornerRadius: 10)

        [menuDescriptionStackView, homeButton].forEach { view.addSubview($0) }

        [firstDescriptionLabel, menuLabel, secondDescriptionLabel].forEach { menuDescriptionStackView.addArrangedSubview($0) }

        setupmenuDescriptionStackViewUI()
        setupHomeButtonUI()
    }

    private func getEatingTimePhrase() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 6..<10:
            return "아침"
        case 12..<15:
            return "점심"
        case 17..<21:
            return "저녁"
        case 21..<24, 0..<3:
            return "야식"
        default:
            return "간식"
        }
    }

    private func setupmenuDescriptionStackViewUI() {
        NSLayoutConstraint.activate([
            menuDescriptionStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            menuDescriptionStackView.heightAnchor.constraint(equalToConstant: 150),
            menuDescriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            menuDescriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }

    private func setupHomeButtonUI() {
        NSLayoutConstraint.activate([
            homeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            homeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            homeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120)
        ])
    }

    private func addActionForButtonEvent() {
        addActionForHomeButton()
    }

    private func addActionForHomeButton() {
        homeButton.addAction(
            UIAction { [weak self] _ in
                self?.homeButton.backgroundColor = .green
            },
            for: .touchDown
        )
        homeButton.addAction(
            UIAction { [weak self] _ in
                self?.homeButton.backgroundColor = .systemGreen
                self?.popToFirstViewController()
            },
            for: [.touchUpOutside, .touchUpInside]
        )
    }

    private func popToFirstViewController() {
        if let firstViewController = navigationController?.viewControllers.first {
            navigationController?.popToViewController(firstViewController, animated: true)
        }
    }
}

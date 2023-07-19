//
//  MenuRecommendationViewController.swift
//  FoodRecommendation
//
//  Created by 전민수 on 2023/07/18.
//

import Koloda

final class MenuRecommendationViewController: UIViewController {

    // MARK: Properties

    private let logoImageView = UIImageView()
    private let menuRecommendationView = KolodaView()
    private let soldOutImageView = UIImageView()
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()

    // MARK: - Methods

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        // delegate 함수로 빼기 + SettingsViewController도!
        menuRecommendationView.delegate = self
        menuRecommendationView.dataSource = self
        configureUI()
    }
    private func configureUI() {
        logoImageView.configureUI(image: UIImage(systemName: "star.fill"))
        menuRecommendationView.visibleCardsDirection = .top
        menuRecommendationView.backgroundCardsTopMargin = 10
        menuRecommendationView.configureUI()
        soldOutImageView.configureUI(image: UIImage(systemName: "star.fill"), alpha: 0)
        setupLogoImageViewUI()
        setupMenuRecommendationView()
        setupSoldOutImageView()
    private func setupLogoImageViewUI() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupMenuRecommendationView() {
        NSLayoutConstraint.activate([
            menuRecommendationView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            menuRecommendationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuRecommendationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupSoldOutImageView() {
        NSLayoutConstraint.activate([
            soldOutImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            soldOutImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
            soldOutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            soldOutImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
    }
// MARK: - Extensions

extension MenuRecommendationViewController: KolodaViewDataSource {
    func koloda(_ koloda: Koloda.KolodaView, viewForCardAt index: Int) -> UIView {
        let view = MenuRecommendationContentView()
        view.backgroundColor = returnRainbowColor(index)
        view.layer.cornerRadius = 10

        if index == 0 {
            view.performAnimation(false)
        } else {
            view.performAnimation(true)
        }

        return view
    }

    func kolodaNumberOfCards(_ koloda: Koloda.KolodaView) -> Int {
        return 10
    }

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.soldOutImageView.alpha = 1.0
        }
    }
}
extension MenuRecommendationViewController: KolodaViewDelegate {
}
    }
}

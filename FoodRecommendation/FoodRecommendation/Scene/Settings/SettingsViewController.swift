//
//  SettingsViewController.swift
//  FoodRecommendation
//
//  Created by 전민수 on 2023/07/13.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: Typealias

    private typealias Category = ExceptionalFood.Category
    private typealias DataSource = UICollectionViewDiffableDataSource<ExceptionReasonSection, Category>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ExceptionReasonSection, Category>

    // MARK: - Properties

    private let characterImageView = UIImageView()
    private let logoImageView = UIImageView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
    private let veganDeclarationButton = VeganDeclarationButton()
    private let menuRecommendationButton = UIButton()
    private let copyrightLabel = UILabel()
    private var dataSource: DataSource?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
        applySnapshot()
        addActionForButtonEvent()
    }

    // MARK: - Methods

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        configureUI()
    }

    private func configureUI() {
        logoImageView.configureUI(image: UIImage(systemName: "star.fill"))
        characterImageView.configureUI(image: UIImage(named: "momoziImage")?.resize(newWidth: view.frame.width * 0.09))
        collectionView.configureUI()
        veganDeclarationButton.configureUI()
        menuRecommendationButton.configureUI(title: "추천받기", backgroundColor: .systemOrange, cornerRadius: 15)
        copyrightLabel.configureUI(
            text: "Icon made by Freepik from www.flaticon.com",
            textColor: .systemGray2,
            textAlignment: .center,
            font: UIFont.systemFont(ofSize: 10)
        )

        [characterImageView, logoImageView, collectionView, veganDeclarationButton, menuRecommendationButton, copyrightLabel].forEach { view.addSubview($0) }

        setupCharacterImageViewUI()
        setupLogoImageViewUI()
        setupCollectionViewUI()
        setupVeganDeclarationButtonUI()
        setupMenuRecommendastionButtonUI()
        setupCopyrightLabelUI()
    }

    private func setupCharacterImageViewUI() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.07),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.065)
        ])
    }
    private func setupLogoImageViewUI() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupCollectionViewUI() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65)
        ])
    }

    private func setupVeganDeclarationButtonUI() {
        NSLayoutConstraint.activate([
            veganDeclarationButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            veganDeclarationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            veganDeclarationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            veganDeclarationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupMenuRecommendastionButtonUI() {
        NSLayoutConstraint.activate([
            menuRecommendationButton.topAnchor.constraint(equalTo: veganDeclarationButton.bottomAnchor, constant: 10),
            menuRecommendationButton.heightAnchor.constraint(equalTo: veganDeclarationButton.heightAnchor, multiplier: 1),
            menuRecommendationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            menuRecommendationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }

    private func setupCopyrightLabelUI() {
        NSLayoutConstraint.activate([
            copyrightLabel.topAnchor.constraint(equalTo: menuRecommendationButton.bottomAnchor, constant: 5),
            copyrightLabel.leadingAnchor.constraint(equalTo: menuRecommendationButton.leadingAnchor),
            copyrightLabel.trailingAnchor.constraint(equalTo: menuRecommendationButton.trailingAnchor)
        ])
    }

    private func configureDataSource() {
        registerCell()
        registerHeaderView()
    }

    private func registerCell() {
        let cellRegistration = UICollectionView.CellRegistration<SettingsCell, Category> { cell, _, item in
            cell.set(title: item.title, image: item.image)
        }
        
        dataSource = UICollectionViewDiffableDataSource<ExceptionReasonSection, Category>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }

    private func registerHeaderView() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(elementKind: SectionHeaderView.elementKind) { supplementaryView, _, indexPath in
            let title = indexPath.section == 0
            ? ExceptionReasonSection.allergy.rawValue
            : ExceptionReasonSection.unpreferredFood.rawValue

            supplementaryView.set(title: title)
        }

        dataSource?.supplementaryViewProvider = { _, _, index in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }

    private func configureLayout() -> UICollectionViewCompositionalLayout {
        let item = setupItemLayout()
        let group = setupGroupLayout(using: item)
        let section = setupSectionLayout(using: group)
        setupSectionHeaderLayout(section)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func setupItemLayout() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        return item
    }

    private func setupGroupLayout(using item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.22)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 4
        )
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

        return group
    }

    private func setupSectionLayout(using group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )

        return section
    }

    private func setupSectionHeaderLayout(_ section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SectionHeaderView.elementKind,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [sectionHeader]
    }

    private func applySnapshot() {
        let allergyList = ExceptionalFood(categories: ExceptionalFood.testData1)
        let unpreferredFoodList = ExceptionalFood(categories: ExceptionalFood.testData2)
        var snapshot = Snapshot()
        snapshot.appendSections([.allergy])
        snapshot.appendItems(allergyList.categories)
        snapshot.appendSections([.unpreferredFood])
        snapshot.appendItems(unpreferredFoodList.categories)

        dataSource?.apply(snapshot)
    }

    private func addActionForButtonEvent() {
        addActionForVeganDeclaration()
        addActionForMenuRecommendation()
    }

    private func addActionForVeganDeclaration() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapVeganDeclarationButton))
        veganDeclarationButton.addGestureRecognizer(gesture)
    }

    @objc private func didTapVeganDeclarationButton(_ gesture: UITapGestureRecognizer) {
        print("touched")
        veganDeclarationButton.toggleUI()
    }

    private func addActionForMenuRecommendation() {
        menuRecommendationButton.addAction(
            UIAction { [weak self] _ in
                self?.menuRecommendationButton.backgroundColor = .orange
            },
            for: .touchDown
        )
        menuRecommendationButton.addAction(
            UIAction { [weak self] _ in
                self?.menuRecommendationButton.backgroundColor = .systemOrange
                self?.pushMenuRecommendationViewController()
            },
            for: [.touchUpOutside, .touchUpInside]
        )
    }

    private func pushMenuRecommendationViewController() {
        navigationController?.pushViewController(MenuRecommendationViewController(), animated: true)
    }
}

// MARK: - Extensions

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SettingsCell else {
            return
        }

        cell.toggleUI()
    }
}

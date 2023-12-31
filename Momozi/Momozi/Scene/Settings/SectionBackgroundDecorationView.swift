//
//  SectionBackgroundDecorationView.swift
//  FoodRecommendation
//
//  Created by 전민수 on 2023/07/26.
//

import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {

    // MARK: Properties

    static let elementKind = "SectionBackgroundDecorationView"

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureHierarchy()
    }

    // MARK: - Methods

    private func configureHierarchy() {
        configureOverallUI()
    }

    private func configureOverallUI() {
        setupBackgroundUI()
    }

    private func setupBackgroundUI() {
        backgroundColor = .white
        layer.borderColor = UIColor.Custom.mainBorderColor?.cgColor
        layer.cornerRadius = 15
        layer.borderWidth = 2
    }
}

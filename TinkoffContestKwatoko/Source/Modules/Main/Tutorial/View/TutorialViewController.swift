//
//  TutorialViewController.swift
//
//  Created by Andrey Vasilev on 22/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class TutorialViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    var presenter: ITutorialPresenter!

    init(presenter: ITutorialPresenter) {
        self.presenter = presenter
        super.init(output: presenter)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension TutorialViewController {
    
    var pageWidth: CGFloat { collectionView.bounds.width }
    
    var currentPage: Int {
        let offset = collectionView.contentOffset.x
        let page = Int(offset / pageWidth)
        return page
    }

    func configure() {
        navigationItem.largeTitleDisplayMode = .never
        pageControl.numberOfPages = presenter.pages.count
        pageControl.currentPage = 0
    }
}

extension TutorialViewController: ITutorialView {

}

extension TutorialViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialPageCell.reuseIdentifier, for: indexPath)
        let page = presenter.pages[indexPath.row]
        (cell as? TutorialPageCell)?.configure(model: page)
        return cell
    }
}

extension TutorialViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = currentPage
    }
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageWidth, height: collectionView.bounds.height)
    }
}

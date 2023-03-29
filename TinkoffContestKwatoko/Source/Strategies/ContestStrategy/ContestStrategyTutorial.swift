//
//  ContestStrategyTutorial.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import Foundation

extension ContestStrategy {
    
    static var tutorial: Tutorial {
        return [TutorialPage(text: L10n.Localization.Tutorial.page0, imageName: "ContestStrategyTutorialPage-0.jpg"),
                TutorialPage(text: L10n.Localization.Tutorial.page1, imageName: "ContestStrategyTutorialPage-1.jpg"),
                TutorialPage(text: L10n.Localization.Tutorial.page2, imageName: "ContestStrategyTutorialPage-2.jpg"),
                TutorialPage(text: L10n.Localization.Tutorial.page3, imageName: "ContestStrategyTutorialPage-3.jpg"),
                TutorialPage(text: L10n.Localization.Tutorial.page4, imageName: "ContestStrategyTutorialPage-4.jpg"),
                TutorialPage(text: L10n.Localization.Tutorial.page5, imageName: "ContestStrategyTutorialPage-5.jpg"),
                TutorialPage(text: L10n.Localization.Tutorial.page6, imageName: "ContestStrategyTutorialPage-6.jpg")]
    }
}

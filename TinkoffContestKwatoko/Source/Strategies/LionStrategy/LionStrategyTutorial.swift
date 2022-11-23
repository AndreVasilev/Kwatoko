//
//  LionStrategyTutorial.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 23.11.2022.
//

import Foundation

extension LionStrategy {

    static var tutorial: Tutorial {
        return [TutorialPage(text: "У инструмента можно вычислить среднее значение объема в заявках", imageName: "ContestStrategyTutorialPage-0.jpg"),
                TutorialPage(text: "Иногда выставляются заявки, которые на порядки превышают это значение - аномальные", imageName: "ContestStrategyTutorialPage-1.jpg"),
                TutorialPage(text: "Когда робот выдит аномальную заявку в стакане, он выкупает ее", imageName: ""),
                TutorialPage(text: "Задача робота: заработать на продолжении тренда после раскупки аномальной заявки", imageName: ""),
                TutorialPage(text: "Параметры робота", imageName: "ContestStrategyTutorialPage-6.jpg")]
    }
}

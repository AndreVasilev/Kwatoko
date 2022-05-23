//
//  ContestStrategyTutorial.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import Foundation

extension ContestStrategy {
    
    static var tutorial: Tutorial {
        return [TutorialPage(text: "У инструмента можно вычислить среднее значение объема в заявках", imageName: "ContestStrategyTutorialPage-0.jpg"),
                TutorialPage(text: "Иногда выставляются заявки, которые на порядки превышают это значение - аномальные", imageName: "ContestStrategyTutorialPage-1.jpg"),
                TutorialPage(text: "Когда заявка оказывается в центре стакана, высока вероятность, что у продавцов (или покупателей) не получится сразу реализовать эту заявку", imageName: "ContestStrategyTutorialPage-2.jpg"),
                TutorialPage(text: "Тогда происходит небольшой отскок цены", imageName: "ContestStrategyTutorialPage-3.jpg"),
                TutorialPage(text: "Когда робот выдит аномальную заявку в стакане, он выставляет свою перед ней", imageName: "ContestStrategyTutorialPage-4.jpg"),
                TutorialPage(text: "Задача робота: заработать на отскоке от аномальной заявки", imageName: "ContestStrategyTutorialPage-5.jpg"),
                TutorialPage(text: "Параметры робота", imageName: "ContestStrategyTutorialPage-6.jpg")]
    }
}

# Торговля по стакану

Алгоритм основан на гипотезе: когда в стакане появляется заявка с аномально большим объёмом, есть вероятность, что произойдет отскок цены от данной заявки. Задача робота заключается в поиске таких заявок и заработке на таком отскоке
Подробное описание с примерами:

| Описание | Пример |
| ------ | ------ |
| У инструмента можно вычислить среднее значение обьема в заявках | <img src="https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Resources/Tutorials/ContestStrategy/ContestStrategyTutorialPage-0.jpg?raw=true?raw=true" height="256"/> |
| Иногда выставляются заявки, которые на порядки превышают это значение - аномальные | <img src="https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Resources/Tutorials/ContestStrategy/ContestStrategyTutorialPage-1.jpg?raw=true" height="256"/> |
| Когда заявка оказывается в центре стакана, высока вероятность, что у продавцов (или покупателей) не получится сразу реализовать эту заявку | <img src="https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Resources/Tutorials/ContestStrategy/ContestStrategyTutorialPage-2.jpg?raw=true" height="256"/> |
| Тогда происходит небольшой отскок цены | <img src="https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Resources/Tutorials/ContestStrategy/ContestStrategyTutorialPage-3.jpg?raw=true" height="256"/> |
| Когда робот выдит аномальную заявку в стакане, он выставляет свою перед ней | <img src="https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Resources/Tutorials/ContestStrategy/ContestStrategyTutorialPage-4.jpg?raw=true" height="256"/> |
| Задача робота: заработать на отскоке от аномальной заявки | <img src="https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Resources/Tutorials/ContestStrategy/ContestStrategyTutorialPage-5.jpg?raw=true" height="256"/> |
| Параметры робота | <img src="https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Resources/Tutorials/ContestStrategy/ContestStrategyTutorialPage-6.jpg?raw=true" height="256"/> |
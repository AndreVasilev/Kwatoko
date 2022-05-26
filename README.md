<img src="https://github.com/AndreVasilev/Kwatoko/blob/main/Readme%20resources/AppIcon%20cropped.png?raw=true" height="256"/>

# kwatoko.pro

## Роботы для торговли на бирже прямо с iPhone

Доработанная версия приложения [**kwatoko**](https://github.com/AndreVasilev/Kwatoko)

<img src="https://github.com/AndreVasilev/Kwatoko/blob/main/Readme%20resources/Simulator%20Screen%20Recording.gif?raw=true" height="512"/>

# Основные возможности

## Создание и конфигурация роботов

В приложении доступно создание до 10 роботов с указанием стратегии, инструмента и всех необходимых для торговли по выбранной стратегии параметров
([описание стратегий и параметров](https://github.com/AndreVasilev/Kwatoko#%D1%82%D0%BE%D1%80%D0%B3%D0%BE%D0%B2%D1%8B%D0%B5-%D1%81%D1%82%D1%80%D0%B0%D1%82%D0%B5%D0%B3%D0%B8%D0%B8))

<img src="https://github.com/AndreVasilev/Kwatoko/blob/main/Readme%20resources/Robots.png?raw=true" height="512"/>

## Просмотр истории сделок

В разделе **История** отображаются сделки по каждому роботу, процент прибыли (убытка) на каждую сделку, а так же график сделок с линией тренда заработка данного робота

<img src="https://github.com/AndreVasilev/Kwatoko/blob/main/Readme%20resources/History.png?raw=true" height="512"/>

## Управление счетами

Для авторизации необходимо использовать два токена ([инструкция по генерации](https://tinkoff.github.io/investAPI/token)):

- токен для биржи

- токен для песочницы

***Рекомендуется использовать Readonly token, если не предполагается торговля на реальной бирже***

***ЗДРАВО ОЦЕНИВАЙТЕ РИСКИ ПРИ ЗАПУСКЕ РОБОТА ДЛЯ ТОРГОВЛИ НА РЕАЛЬНОЙ БИРЖЕ***

В разделе **Профиль** отображаются открытые счета, можно посмотреть баланс по всем валютам.
Для счетов в песочнице доступно открытие, закрытие, пополнение баланса в любой валюте, возможность переименовать счет (только в приложении)

*Из-за [особенностей](https://tinkoff.github.io/investAPI/head-sandbox/) работы песочницы, пополнение доступно только в рублях. Чтобы пополнить баланс иностранной валюты, будет совершено пополнение в рублях на сумму приблизительно эквивалентную сумме валюты с последующей покупкой указанной валюты*
*Если произойдет ошибка - попробуйте указать меньшую сумму*
*Покупка иностранной валюты может происходить с задержкой. Если обновление баланса не произойдет моментально - попробуйте вернуться на экран позже и проверить баланс снова*

Возможность пополнения баланса определяется режимом торгов биржи

<img src="https://github.com/AndreVasilev/Kwatoko/blob/main/Readme%20resources/Profile.png?raw=true" height="512"/>

## Тестирование

На данный момент в приложении реализован алгоритм торговли по стакану. Исторические данные стаканов отсутствуют (или не были найдены автором), поэтому для тестирования предлагается сгенерировать свой набор данных в формате JSON.

Пример заполнения:

```json
{
    "interval": 1.0,
    "data": [
        {
            "asks": [
                { "quantity": 44, "price": 100.31 },
                { "quantity": 40, "price": 101.24 },
                ...
            ],
            "bids": [
                { "quantity": 22, "price": 99.13 },
                { "quantity": 12, "price": 98.33 },
                ...
            ]
        },
        ...
    ]
}
```

***interval***: интервал получения роботом тестовых данных по стакану

***data***: массив стаканов

***asks***: массив заявок на продажу в стакане

***bids***: массив заявок на покупку в стакане

***quantity***: объём заявки (*Int*)

***price***: цена инструмента в заявке (*Double*)

Для запуска робота на тестовых данных необходимо
1. Заполнить тестовый файл [DemoData.json](https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Resources/DemoData.json) своим набором данных
2. Добавить робота со стратегией ***"Демо: торговля по стакану"***
3. Запустить робота

# Торговые стратегии

## Торговля по стакану

Алгоритм основан на гипотезе: когда в стакане появляется заявка с аномально большим объёмом, есть вероятность, что произойдет отскок цены от данной заявки. Задача робота заключается в поиске таких заявок и заработке на таком отскоке

[Подробное описание с примерами](https://github.com/AndreVasilev/Kwatoko/blob/main/Readme%20resources/ContestStrategyTutorialReadme.md)

## Результаты

Робот был запущен для торговли 1 лотом акций TCSG 23 мая 2022

За одну сессию робот совершил 51 сделку и заработал 48 рублей, что составляет ~ 2.25% от стоимости лота на момент закрытия торговой сессии

<img src="https://github.com/AndreVasilev/Kwatoko/blob/main/Readme%20resources/Proofs.png?raw=true" height="512"/>

# Технические особенности

**Заголовок x-app-name:** *AndreVasilev.Kwatoko*

**Используемые зависимости:**

- [TinkoffInvestSwiftSDK](https://github.com/JohnReeze/TinkoffInvestSwiftSDK.git)
- [Charts](https://github.com/danielgindi/Charts.git)
- [SwiftEntryKit](https://github.com/huri000/SwiftEntryKit)

*Все зависимости должны быть установлены перед сборкой проекта через Swift Package Manager*

**Реализация алгоритма**

Исходный код реализации алгоритма находится в файле [ContestStrategy.swift](https://github.com/AndreVasilev/Kwatoko/blob/main/TinkoffContestKwatoko/Source/Strategies/ContestStrategy/ContestStrategy.swift)

Вспомогательные файлы в папке [ContestStrategy](https://github.com/AndreVasilev/Kwatoko/tree/main/TinkoffContestKwatoko/Source/Strategies/ContestStrategy)

## Совместимость

| Платформа | Минимальная версия |
| --- | --- |
| macOS | 12.0 (Monterey) |
| iOS & iPadOS | 15.4 |

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Localizable {
    /// Plural format key: "You have %#@count@"
    internal static func totalDealsLld(_ p1: Int) -> String {
      return L10n.tr("Localizable", "total_deals_%lld", p1)
    }
    /// Plural format key: "You have %#@count@"
    internal static func totalRobotsLld(_ p1: Int) -> String {
      return L10n.tr("Localizable", "total_robots_%lld", p1)
    }
  }
  internal enum Localization {
    /// Счёт
    internal static let account = L10n.tr("Localization", "account")
    /// Добавить
    internal static let add = L10n.tr("Localization", "add")
    /// Вы уверены, что хотите закрыть счёт?
    internal static let askCloseAccount = L10n.tr("Localization", "ask_close_account")
    /// Вы уверены, что хотите удалить робота?
    internal static let askDeleteAllRobots = L10n.tr("Localization", "ask_delete_all_robots")
    /// Вы уверены что хотите выйти?
    internal static let askLogout = L10n.tr("Localization", "ask_logout")
    /// Все данные (роботы, конфигурации, история) будут безвозвратно удалены
    internal static let askLogoutMessage = L10n.tr("Localization", "ask_logout_message")
    /// Вы уверены, что хотите остановить робота?
    internal static let askStopRobot = L10n.tr("Localization", "ask_stop_robot")
    /// Внимание!
    internal static let attention = L10n.tr("Localization", "attention")
    /// Все сделки будут совершаться на реальной бирже.
    /// Будьте внимательны с работой робота
    internal static let attentionMessage = L10n.tr("Localization", "attention_message")
    /// Отмена
    internal static let cancel = L10n.tr("Localization", "cancel")
    /// График
    internal static let chart = L10n.tr("Localization", "chart")
    /// Закрыть
    internal static let close = L10n.tr("Localization", "close")
    /// Закрытие сделки
    internal static let closeDeal = L10n.tr("Localization", "close_deal")
    /// Нажимая "Войти", я подтверждаю, что осознаю все риски торговли роботом на реальной бирже и беру на себя всю ответственность за выставленные заявки
    internal static let complianceMessage = L10n.tr("Localization", "compliance_message")
    /// Конфигурация
    internal static let configuration = L10n.tr("Localization", "configuration")
    /// Валюты
    internal static let currencies = L10n.tr("Localization", "currencies")
    /// Сделка
    internal static let deal = L10n.tr("Localization", "deal")
    /// Сделки
    internal static let deals = L10n.tr("Localization", "deals")
    /// Удалить
    internal static let delete = L10n.tr("Localization", "delete")
    /// Любое
    internal static let directionAny = L10n.tr("Localization", "direction_any")
    /// Покупка
    internal static let directionBuy = L10n.tr("Localization", "direction_buy")
    /// Продажа
    internal static let directionSell = L10n.tr("Localization", "direction_sell")
    /// Ошибка
    internal static let error = L10n.tr("Localization", "error")
    /// Биржа
    internal static let exchange = L10n.tr("Localization", "exchange")
    /// Глубина стакана
    internal static let fieldDepth = L10n.tr("Localization", "field_depth")
    /// Объем аномальной заявки
    internal static let fieldEdgeQuantity = L10n.tr("Localization", "field_edge_quantity")
    /// Название робота
    internal static let fieldName = L10n.tr("Localization", "field_name")
    /// Дельта цены заявки
    internal static let fieldOrderDelta = L10n.tr("Localization", "field_order_delta")
    /// Направление торговли
    internal static let fieldOrderDirection = L10n.tr("Localization", "field_order_direction")
    /// Объем торгуемой заявки
    internal static let fieldOrderQuantity = L10n.tr("Localization", "field_order_quantity")
    /// Стоп-лосс (% от цены заявки)
    internal static let fieldStopLossPercent = L10n.tr("Localization", "field_stop_loss_percent")
    /// Тейк-профит (% от цены заявки)
    internal static let fieldTakeProfitPercent = L10n.tr("Localization", "field_take_profit_percent")
    /// Стакан
    internal static let glass = L10n.tr("Localization", "glass")
    /// История
    internal static let history = L10n.tr("Localization", "history")
    /// Как получить токены?
    internal static let howGetToken = L10n.tr("Localization", "how_get_token")
    /// ID
    internal static let id = L10n.tr("Localization", "id")
    /// Профиль
    internal static let information = L10n.tr("Localization", "information")
    /// Инструмент
    internal static let instrument = L10n.tr("Localization", "instrument")
    /// Инструменты
    internal static let instruments = L10n.tr("Localization", "instruments")
    /// Войти
    internal static let login = L10n.tr("Localization", "login")
    /// Выйти
    internal static let logout = L10n.tr("Localization", "logout")
    /// Открытие сделки
    internal static let openDeal = L10n.tr("Localization", "open_deal")
    /// Открыть новый
    internal static let openNew = L10n.tr("Localization", "open_new")
    /// Открыт
    internal static let opened = L10n.tr("Localization", "opened")
    /// заявка
    internal static let order = L10n.tr("Localization", "order")
    /// Пополнить
    internal static let payIn = L10n.tr("Localization", "pay_in")
    /// Сумма пополнения
    internal static let payInAmount = L10n.tr("Localization", "pay_in_amount")
    /// Пополнение доступно только в рублях.
    /// Чтобы пополнить другую валюту, будет совершено пополнение в рублях на сумму приблизительно эквивалентную сумме валюты с последующей покупкой указанной валюты
    /// Если произойдет ошибка - попробуйте указать меньшую сумму
    /// 
    /// Покупка иностранной валюты может происходить с задержкой из-за особенностей работы песочницы. Если обновление баланса не произойдет моментально - попробуйте вернуться позже и проверить баланс снова
    internal static let payInOther = L10n.tr("Localization", "pay_in_other")
    /// Введите сумму, на которую хотите совершить пополнение
    internal static let payInRub = L10n.tr("Localization", "pay_in_rub")
    /// Пополнение
    internal static let payingIn = L10n.tr("Localization", "paying_in")
    /// Профиль
    internal static let profile = L10n.tr("Localization", "profile")
    /// Объем
    internal static let quantity = L10n.tr("Localization", "quantity")
    /// Обновить
    internal static let reload = L10n.tr("Localization", "reload")
    /// Робот
    internal static let robot = L10n.tr("Localization", "robot")
    /// Роботы
    internal static let robots = L10n.tr("Localization", "robots")
    /// Рубль
    internal static let ruble = L10n.tr("Localization", "ruble")
    /// Запустить все
    internal static let runAll = L10n.tr("Localization", "run_all")
    /// Запущено: %@
    internal static func runned(_ p1: Any) -> String {
      return L10n.tr("Localization", "runned", String(describing: p1))
    }
    /// Песочница
    internal static let sandbox = L10n.tr("Localization", "sandbox")
    /// Сохранить
    internal static let save = L10n.tr("Localization", "save")
    /// Выберите инструмент
    internal static let selectInstrument = L10n.tr("Localization", "select_instrument")
    /// Выберите стратегию
    internal static let selectStrategy = L10n.tr("Localization", "select_strategy")
    /// Текущий
    internal static let selected = L10n.tr("Localization", "selected")
    /// Акции
    internal static let shares = L10n.tr("Localization", "shares")
    /// Остановить
    internal static let stop = L10n.tr("Localization", "stop")
    /// стоп-лосс
    internal static let stopLoss = L10n.tr("Localization", "stop_loss")
    /// Стратегии
    internal static let strategies = L10n.tr("Localization", "strategies")
    /// Стратегия
    internal static let strategy = L10n.tr("Localization", "strategy")
    /// Торговля по стакану
    internal static let strategyTitleContest = L10n.tr("Localization", "strategy_title_contest")
    /// Демо: торговля по стакану
    internal static let strategyTitleContestDemo = L10n.tr("Localization", "strategy_title_contest_demo")
    /// тейк-профит
    internal static let takeProfit = L10n.tr("Localization", "take_profit")
    /// Название
    internal static let title = L10n.tr("Localization", "title")
    /// Токен биржи
    internal static let tokenExchange = L10n.tr("Localization", "tokenExchange")
    /// Токен песочницы
    internal static let tokenSandbox = L10n.tr("Localization", "tokenSandbox")
    internal enum Error {
      /// Перейдите в "Профиль" и выберите текущий счёт
      internal static let selectAccount = L10n.tr("Localization", "error.select_account")
    }
    internal enum Tutorial {
      /// У инструмента можно вычислить среднее значение объема в заявках
      internal static let page0 = L10n.tr("Localization", "tutorial.page_0")
      /// Иногда выставляются заявки, которые на порядки превышают это значение - аномальные
      internal static let page1 = L10n.tr("Localization", "tutorial.page_1")
      /// Когда заявка оказывается в центре стакана, высока вероятность, что у продавцов (или покупателей) не получится сразу реализовать эту заявку
      internal static let page2 = L10n.tr("Localization", "tutorial.page_2")
      /// Тогда происходит небольшой отскок цены
      internal static let page3 = L10n.tr("Localization", "tutorial.page_3")
      /// Когда робот выдит аномальную заявку в стакане, он выставляет свою перед ней
      internal static let page4 = L10n.tr("Localization", "tutorial.page_4")
      /// Задача робота: заработать на отскоке от аномальной заявки
      internal static let page5 = L10n.tr("Localization", "tutorial.page_5")
      /// Параметры робота
      internal static let page6 = L10n.tr("Localization", "tutorial.page_6")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

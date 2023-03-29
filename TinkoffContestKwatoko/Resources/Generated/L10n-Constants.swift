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
    /// Check
    internal static let account = L10n.tr("Localization", "account")
    /// Add
    internal static let add = L10n.tr("Localization", "add")
    /// Are you sure you want to close the account?
    internal static let askCloseAccount = L10n.tr("Localization", "ask_close_account")
    /// Are you sure you want to delete the robot?
    internal static let askDeleteAllRobots = L10n.tr("Localization", "ask_delete_all_robots")
    /// Are you sure you want to exit?
    internal static let askLogout = L10n.tr("Localization", "ask_logout")
    /// All data (robots, configurations, history) will be permanently deleted
    internal static let askLogoutMessage = L10n.tr("Localization", "ask_logout_message")
    /// Are you sure you want to stop the robot?
    internal static let askStopRobot = L10n.tr("Localization", "ask_stop_robot")
    /// Attention!
    internal static let attention = L10n.tr("Localization", "attention")
    /// All transactions will be made on a real exchange.
    /// Be careful with robot operation
    internal static let attentionMessage = L10n.tr("Localization", "attention_message")
    /// Cancel
    internal static let cancel = L10n.tr("Localization", "cancel")
    /// Schedule
    internal static let chart = L10n.tr("Localization", "chart")
    /// close
    internal static let close = L10n.tr("Localization", "close")
    /// Closing the deal
    internal static let closeDeal = L10n.tr("Localization", "close_deal")
    /// By clicking "Login", I confirm that I am aware of all the risks of trading with a robot on a real exchange and take full responsibility for the submitted orders
    internal static let complianceMessage = L10n.tr("Localization", "compliance_message")
    /// Configuration
    internal static let configuration = L10n.tr("Localization", "configuration")
    /// Currencies
    internal static let currencies = L10n.tr("Localization", "currencies")
    /// Deal
    internal static let deal = L10n.tr("Localization", "deal")
    /// Deals
    internal static let deals = L10n.tr("Localization", "deals")
    /// Delete
    internal static let delete = L10n.tr("Localization", "delete")
    /// Any
    internal static let directionAny = L10n.tr("Localization", "direction_any")
    /// Purchase
    internal static let directionBuy = L10n.tr("Localization", "direction_buy")
    /// Sale
    internal static let directionSell = L10n.tr("Localization", "direction_sell")
    /// Error
    internal static let error = L10n.tr("Localization", "error")
    /// Exchange
    internal static let exchange = L10n.tr("Localization", "exchange")
    /// Cup depth
    internal static let fieldDepth = L10n.tr("Localization", "field_depth")
    /// Anomalous order volume
    internal static let fieldEdgeQuantity = L10n.tr("Localization", "field_edge_quantity")
    /// Robot name
    internal static let fieldName = L10n.tr("Localization", "field_name")
    /// Order price delta
    internal static let fieldOrderDelta = L10n.tr("Localization", "field_order_delta")
    /// Direction of trade
    internal static let fieldOrderDirection = L10n.tr("Localization", "field_order_direction")
    /// Volume of traded order
    internal static let fieldOrderQuantity = L10n.tr("Localization", "field_order_quantity")
    /// Stop Loss (of order price)
    internal static let fieldStopLossPercent = L10n.tr("Localization", "field_stop_loss_percent")
    /// Take profit (of order price)
    internal static let fieldTakeProfitPercent = L10n.tr("Localization", "field_take_profit_percent")
    /// Cup
    internal static let glass = L10n.tr("Localization", "glass")
    /// Story
    internal static let history = L10n.tr("Localization", "history")
    /// How to get tokens?
    internal static let howGetToken = L10n.tr("Localization", "how_get_token")
    /// ID
    internal static let id = L10n.tr("Localization", "id")
    /// Profile
    internal static let information = L10n.tr("Localization", "information")
    /// Tool
    internal static let instrument = L10n.tr("Localization", "instrument")
    /// Tools
    internal static let instruments = L10n.tr("Localization", "instruments")
    /// To come in
    internal static let login = L10n.tr("Localization", "login")
    /// Go out
    internal static let logout = L10n.tr("Localization", "logout")
    /// Opening a deal
    internal static let openDeal = L10n.tr("Localization", "open_deal")
    /// open new
    internal static let openNew = L10n.tr("Localization", "open_new")
    /// open
    internal static let opened = L10n.tr("Localization", "opened")
    /// application
    internal static let order = L10n.tr("Localization", "order")
    /// Top up
    internal static let payIn = L10n.tr("Localization", "pay_in")
    /// Top-up amount
    internal static let payInAmount = L10n.tr("Localization", "pay_in_amount")
    /// Replenishment is available only in rubles.
    /// To replenish another currency, a replenishment in rubles will be made in an amount approximately equivalent to the amount of the currency, followed by the purchase of the specified currency
    /// If an error occurs, try specifying a smaller amount
    /// 
    /// Purchase of foreign currency may be delayed due to the peculiarities of the sandbox. If the balance update does not happen immediately - try to come back later and check the balance again
    internal static let payInOther = L10n.tr("Localization", "pay_in_other")
    /// Enter the amount you want to top up
    internal static let payInRub = L10n.tr("Localization", "pay_in_rub")
    /// Replenishment
    internal static let payingIn = L10n.tr("Localization", "paying_in")
    /// Profile
    internal static let profile = L10n.tr("Localization", "profile")
    /// Volume
    internal static let quantity = L10n.tr("Localization", "quantity")
    /// Refresh
    internal static let reload = L10n.tr("Localization", "reload")
    /// Robot
    internal static let robot = L10n.tr("Localization", "robot")
    /// robots
    internal static let robots = L10n.tr("Localization", "robots")
    /// Ruble
    internal static let ruble = L10n.tr("Localization", "ruble")
    /// Run All
    internal static let runAll = L10n.tr("Localization", "run_all")
    /// Started: %@
    internal static func runned(_ p1: Any) -> String {
      return L10n.tr("Localization", "runned", String(describing: p1))
    }
    /// Sandbox
    internal static let sandbox = L10n.tr("Localization", "sandbox")
    /// Save
    internal static let save = L10n.tr("Localization", "save")
    /// Choose a tool
    internal static let selectInstrument = L10n.tr("Localization", "select_instrument")
    /// Choose a strategy
    internal static let selectStrategy = L10n.tr("Localization", "select_strategy")
    /// Current
    internal static let selected = L10n.tr("Localization", "selected")
    /// Stock
    internal static let shares = L10n.tr("Localization", "shares")
    /// Stop
    internal static let stop = L10n.tr("Localization", "stop")
    /// stop loss
    internal static let stopLoss = L10n.tr("Localization", "stop_loss")
    /// Strategies
    internal static let strategies = L10n.tr("Localization", "strategies")
    /// Strategy
    internal static let strategy = L10n.tr("Localization", "strategy")
    /// Glass trading
    internal static let strategyTitleContest = L10n.tr("Localization", "strategy_title_contest")
    /// Demo: Depth of Market
    internal static let strategyTitleContestDemo = L10n.tr("Localization", "strategy_title_contest_demo")
    /// take profit
    internal static let takeProfit = L10n.tr("Localization", "take_profit")
    /// Name
    internal static let title = L10n.tr("Localization", "title")
    /// Exchange Token
    internal static let tokenExchange = L10n.tr("Localization", "tokenExchange")
    /// Sandbox Token
    internal static let tokenSandbox = L10n.tr("Localization", "tokenSandbox")
    internal enum Error {
      /// Go to "Profile" and select the current account
      internal static let selectAccount = L10n.tr("Localization", "error.select_account")
    }
    internal enum Tutorial {
      /// For the instrument, you can calculate the average value of the volume in orders
      internal static let page0 = L10n.tr("Localization", "tutorial.page_0")
      /// Sometimes orders are placed that are orders of magnitude higher than this value - anomalous
      internal static let page1 = L10n.tr("Localization", "tutorial.page_1")
      /// When an order is in the center of the order book, there is a high probability that sellers (or buyers) will not be able to immediately fill this order
      internal static let page2 = L10n.tr("Localization", "tutorial.page_2")
      /// Then there is a small price bounce.
      internal static let page3 = L10n.tr("Localization", "tutorial.page_3")
      /// When the robot issues an anomalous order in the order book, it places its own in front of it
      internal static let page4 = L10n.tr("Localization", "tutorial.page_4")
      /// The task of the robot: to make money on a rebound from an anomalous order
      internal static let page5 = L10n.tr("Localization", "tutorial.page_5")
      /// Robot parameters
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

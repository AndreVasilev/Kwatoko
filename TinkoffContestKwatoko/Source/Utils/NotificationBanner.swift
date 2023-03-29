//
//  NotificationBanner.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 21.05.2022.
//

import UIKit
import SwiftEntryKit

struct NotificationBanner {
    
    enum Style {
        case error
        
        var backgroundColor: UIColor {
            switch self {
            case .error: return .systemRed
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .error: return .white
            }
        }
    }
    
    static func present(_ error: Error, style: Style = .error) {
        DispatchQueue.main.async {
            present(title: "\(L10n.Localization.error):", text: error.alertMessage, style: style)
        }
    }
}

private extension NotificationBanner {
    
    static func present(title: String, text: String, style: Style) {
        var attributes = EKAttributes()
        attributes.position = .top
        attributes.displayMode = .inferred
        attributes.entryBackground = .color(color: .init(style.backgroundColor))
        attributes.roundCorners = .all(radius: 12)
        attributes.displayDuration = 3
        attributes.positionConstraints.size = .init(width: .offset(value: 16), height: .intrinsic)

        let textColor = EKColor(style.textColor)
        let titleLabel = EKProperty.LabelContent(text: title, style: .init(font: .systemFont(ofSize: 11), color: textColor))
        let descriptionLabel = EKProperty.LabelContent(text: text, style: .init(font: .systemFont(ofSize: 13), color: textColor))
        let simpleMessage = EKSimpleMessage(title: titleLabel, description: descriptionLabel)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)

        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

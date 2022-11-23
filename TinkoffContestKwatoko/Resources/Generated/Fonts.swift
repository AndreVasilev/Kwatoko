// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum SFProDisplay {
    internal static let black = FontConvertible(name: "SFProDisplay-Black", family: "SF Pro Display", path: "SFProDisplay-Black.ttf")
    internal static let blackItalic = FontConvertible(name: "SFProDisplay-BlackItalic", family: "SF Pro Display", path: "SFProDisplay-BlackItalic.ttf")
    internal static let bold = FontConvertible(name: "SFProDisplay-Bold", family: "SF Pro Display", path: "SFProDisplay-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "SFProDisplay-BoldItalic", family: "SF Pro Display", path: "SFProDisplay-BoldItalic.ttf")
    internal static let heavy = FontConvertible(name: "SFProDisplay-Heavy", family: "SF Pro Display", path: "SFProDisplay-Heavy.ttf")
    internal static let heavyItalic = FontConvertible(name: "SFProDisplay-HeavyItalic", family: "SF Pro Display", path: "SFProDisplay-HeavyItalic.ttf")
    internal static let light = FontConvertible(name: "SFProDisplay-Light", family: "SF Pro Display", path: "SFProDisplay-Light.ttf")
    internal static let lightItalic = FontConvertible(name: "SFProDisplay-LightItalic", family: "SF Pro Display", path: "SFProDisplay-LightItalic.ttf")
    internal static let medium = FontConvertible(name: "SFProDisplay-Medium", family: "SF Pro Display", path: "SFProDisplay-Medium.ttf")
    internal static let mediumItalic = FontConvertible(name: "SFProDisplay-MediumItalic", family: "SF Pro Display", path: "SFProDisplay-MediumItalic.ttf")
    internal static let regular = FontConvertible(name: "SFProDisplay-Regular", family: "SF Pro Display", path: "SFProDisplay-Regular.ttf")
    internal static let italic = FontConvertible(name: "SFProDisplay-RegularItalic", family: "SF Pro Display", path: "SFProDisplay-RegularItalic.ttf")
    internal static let semibold = FontConvertible(name: "SFProDisplay-Semibold", family: "SF Pro Display", path: "SFProDisplay-SemiBold.ttf")
    internal static let semiboldItalic = FontConvertible(name: "SFProDisplay-SemiboldItalic", family: "SF Pro Display", path: "SFProDisplay-SemiboldItalic.ttf")
    internal static let thin = FontConvertible(name: "SFProDisplay-Thin", family: "SF Pro Display", path: "SFProDisplay-Thin.ttf")
    internal static let thinItalic = FontConvertible(name: "SFProDisplay-ThinItalic", family: "SF Pro Display", path: "SFProDisplay-ThinItalic.ttf")
    internal static let ultralight = FontConvertible(name: "SFProDisplay-Ultralight", family: "SF Pro Display", path: "SFProDisplay-UltraLight.ttf")
    internal static let ultralightItalic = FontConvertible(name: "SFProDisplay-UltralightItalic", family: "SF Pro Display", path: "SFProDisplay-UltralightItalic.ttf")
    internal static let all: [FontConvertible] = [black, blackItalic, bold, boldItalic, heavy, heavyItalic, light, lightItalic, medium, mediumItalic, regular, italic, semibold, semiboldItalic, thin, thinItalic, ultralight, ultralightItalic]
  }
  internal enum SFProRounded {
    internal static let black = FontConvertible(name: "SFProRounded-Black", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Black.otf")
    internal static let bold = FontConvertible(name: "SFProRounded-Bold", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Bold.otf")
    internal static let heavy = FontConvertible(name: "SFProRounded-Heavy", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Heavy.otf")
    internal static let light = FontConvertible(name: "SFProRounded-Light", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Light.otf")
    internal static let medium = FontConvertible(name: "SFProRounded-Medium", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Medium.otf")
    internal static let regular = FontConvertible(name: "SFProRounded-Regular", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Regular.otf")
    internal static let semibold = FontConvertible(name: "SFProRounded-Semibold", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Semibold.otf")
    internal static let thin = FontConvertible(name: "SFProRounded-Thin", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Thin.otf")
    internal static let ultralight = FontConvertible(name: "SFProRounded-Ultralight", family: "SF Pro Rounded", path: "SF-Pro-Rounded-Ultralight.otf")
    internal static let all: [FontConvertible] = [black, bold, heavy, light, medium, regular, semibold, thin, ultralight]
  }
  internal enum SFProText {
    internal static let bold = FontConvertible(name: "SFProText-Bold", family: "SF Pro Text", path: "SFProText-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "SFProText-BoldItalic", family: "SF Pro Text", path: "SFProText-BoldItalic.ttf")
    internal static let heavy = FontConvertible(name: "SFProText-Heavy", family: "SF Pro Text", path: "SFProText-Heavy.ttf")
    internal static let heavyItalic = FontConvertible(name: "SFProText-HeavyItalic", family: "SF Pro Text", path: "SFProText-HeavyItalic.ttf")
    internal static let light = FontConvertible(name: "SFProText-Light", family: "SF Pro Text", path: "SFProText-Light.ttf")
    internal static let lightItalic = FontConvertible(name: "SFProText-LightItalic", family: "SF Pro Text", path: "SFProText-LightItalic.ttf")
    internal static let medium = FontConvertible(name: "SFProText-Medium", family: "SF Pro Text", path: "SFProText-Medium.ttf")
    internal static let mediumItalic = FontConvertible(name: "SFProText-MediumItalic", family: "SF Pro Text", path: "SFProText-MediumItalic.ttf")
    internal static let regular = FontConvertible(name: "SFProText-Regular", family: "SF Pro Text", path: "SFProText-Regular.ttf")
    internal static let italic = FontConvertible(name: "SFProText-RegularItalic", family: "SF Pro Text", path: "SFProText-RegularItalic.ttf")
    internal static let semibold = FontConvertible(name: "SFProText-Semibold", family: "SF Pro Text", path: "SFProText-SemiBold.ttf")
    internal static let semiboldItalic = FontConvertible(name: "SFProText-SemiboldItalic", family: "SF Pro Text", path: "SFProText-SemiBoldItalic.ttf")
    internal static let all: [FontConvertible] = [bold, boldItalic, heavy, heavyItalic, light, lightItalic, medium, mediumItalic, regular, italic, semibold, semiboldItalic]
  }
  internal static let allCustomFonts: [FontConvertible] = [SFProDisplay.all, SFProRounded.all, SFProText.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
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

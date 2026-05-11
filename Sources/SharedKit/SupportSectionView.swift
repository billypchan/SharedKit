import SwiftUI

public struct SupportSectionConfig {
  public let appStoreURL: URL
  public let githubURL: URL
  public let twitterURL: URL
  public let buyMeACoffeeURL: URL?
  public let isPremium: Bool
  public let onRemoveAds: (@MainActor () -> Void)?
  public let onRateApp: @MainActor () -> Void

  public init(
    appStoreURL: URL,
    githubURL: URL,
    twitterURL: URL = URL(string: "https://x.com/billchanios")!,
    buyMeACoffeeURL: URL? = nil,
    isPremium: Bool = true,
    onRemoveAds: (@MainActor () -> Void)? = nil,
    onRateApp: @escaping @MainActor () -> Void
  ) {
    self.appStoreURL = appStoreURL
    self.githubURL = githubURL
    self.twitterURL = twitterURL
    self.buyMeACoffeeURL = buyMeACoffeeURL
    self.isPremium = isPremium
    self.onRemoveAds = onRemoveAds
    self.onRateApp = onRateApp
  }
}

#if os(iOS)
public struct SupportSectionView: View {
  let config: SupportSectionConfig

  public init(config: SupportSectionConfig) {
    self.config = config
  }

  public var body: some View {
    Section(header: Text("Support", bundle: .module)) {
      Link(destination: config.githubURL) {
        ExternalLinkRow(icon: "ladybug.fill", iconColor: .red, label: "Report an Issue")
      }
      Link(destination: config.twitterURL) {
        ExternalLinkRow(icon: "at", iconColor: .blue, label: "Follow on X")
      }
      if let coffeeURL = config.buyMeACoffeeURL {
        Link(destination: coffeeURL) {
          ExternalLinkRow(icon: "cup.and.saucer.fill", iconColor: .orange, label: "Buy Me a Coffee")
        }
      }
      ShareLink(item: config.appStoreURL) {
        HStack {
          Image(systemName: "square.and.arrow.up").foregroundStyle(.green)
          Text("Share this App", bundle: .module)
          Spacer()
        }
      }
      .foregroundStyle(.primary)
      Button {
        config.onRateApp()
      } label: {
        HStack {
          Image(systemName: "star.fill").foregroundStyle(.yellow)
          Text("Rate this App", bundle: .module)
          Spacer()
        }
      }
      .foregroundStyle(.primary)
      if !config.isPremium, let onRemoveAds = config.onRemoveAds {
        Button {
          onRemoveAds()
        } label: {
          HStack {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.red)
            Text("Remove Ads", bundle: .module)
              .foregroundStyle(.primary)
            Spacer()
            Text("One-time purchase", bundle: .module)
              .font(.caption)
              .foregroundStyle(.secondary)
            Image(systemName: "chevron.right")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
      }
    }
  }
}
#endif

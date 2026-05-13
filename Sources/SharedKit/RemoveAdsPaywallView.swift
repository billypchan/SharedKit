import SwiftUI

#if os(iOS)
@MainActor
public struct RemoveAdsPaywallView<PM: RemoveAdsPurchasing>: View {
  @EnvironmentObject private var purchaseManager: PM
  @Environment(\.dismiss) private var dismiss

  let appName: String
  let heroSystemImage: String

  public init(appName: String, heroSystemImage: String) {
    self.appName = appName
    self.heroSystemImage = heroSystemImage
  }

  public var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 32) {
          heroSection
          benefitsSection
          purchaseSection
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
      }
      .navigationTitle(Text("Remove Ads", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button { dismiss() } label: {
            Text("Close", bundle: .module)
          }
        }
      }
    }
  }

  // MARK: - Hero

  private var heroSection: some View {
    VStack(spacing: 16) {
      ZStack {
        Circle()
          .fill(Color.green.opacity(0.15))
          .frame(width: 100, height: 100)
        Image(systemName: heroSystemImage)
          .font(.system(size: 56))
          .foregroundStyle(.green)
      }
      .padding(.top, 24)

      Text(verbatim: String(
        format: NSLocalizedString("Enjoy %@\nAd-Free", bundle: .module, comment: "Paywall hero title"),
        appName
      ))
      .font(.title2.bold())
      .multilineTextAlignment(.center)

      Text("Support the developer and remove all banner ads with a single one-time purchase.", bundle: .module)
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
  }

  // MARK: - Benefits

  private var benefitsSection: some View {
    VStack(spacing: 0) {
      ForEach(benefits, id: \.title) { benefit in
        HStack(spacing: 16) {
          Image(systemName: benefit.icon)
            .font(.title3)
            .foregroundStyle(benefit.color)
            .frame(width: 32)

          VStack(alignment: .leading, spacing: 2) {
            Text(LocalizedStringKey(benefit.title), bundle: .module)
              .font(.subheadline.weight(.semibold))
            Text(LocalizedStringKey(benefit.description), bundle: .module)
              .font(.caption)
              .foregroundStyle(.secondary)
          }

          Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)

        if benefit.title != benefits.last?.title {
          Divider().padding(.leading, 64)
        }
      }
    }
    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
  }

  private let benefits: [Benefit] = [
    Benefit(icon: "xmark.circle.fill", color: .red,
            title: "No More Ads",
            description: "Removes all banner ads from the app."),
    Benefit(icon: "heart.fill", color: .pink,
            title: "Support Development",
            description: "Helps keep the app updated and free for everyone."),
    Benefit(icon: "arrow.clockwise.circle.fill", color: .blue,
            title: "Restore Any Time",
            description: "Re-install on any device — your purchase stays with your Apple ID."),
  ]

  // MARK: - Purchase

  private var purchaseSection: some View {
    VStack(spacing: 12) {
      if purchaseManager.isPremium {
        Label {
          Text("Ads Removed — Thank You!", bundle: .module)
        } icon: {
          Image(systemName: "checkmark.circle.fill")
        }
        .font(.headline)
        .foregroundStyle(.green)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
      } else {
        Button {
          Task { @MainActor in await purchaseManager.purchase() }
        } label: {
          HStack {
            if purchaseManager.isPurchasing {
              ProgressView().tint(.white)
            } else {
              Text(verbatim: purchaseButtonTitle)
                .font(.headline)
            }
          }
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.green)
          .foregroundStyle(.white)
          .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(purchaseManager.isPurchasing || purchaseManager.removeAdsProductDisplayPrice == nil)

        Button {
          Task { @MainActor in await purchaseManager.restore() }
        } label: {
          Text("Restore Purchase", bundle: .module)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .disabled(purchaseManager.isPurchasing)
      }

      if let error = purchaseManager.purchaseError {
        Text(error)
          .font(.caption)
          .foregroundStyle(.red)
          .multilineTextAlignment(.center)
      }

      Text("One-time purchase. No subscription.", bundle: .module)
        .font(.caption2)
        .foregroundStyle(.tertiary)
    }
  }

  private var purchaseButtonTitle: String {
    if let price = purchaseManager.removeAdsProductDisplayPrice {
      let fmt = NSLocalizedString("Remove Ads — %@", bundle: .module, comment: "Purchase button with price")
      return String(format: fmt, price)
    }
    return NSLocalizedString("Remove Ads", bundle: .module, comment: "Purchase button without price")
  }
}

private struct Benefit {
  let icon: String
  let color: Color
  let title: String
  let description: String
}
#endif

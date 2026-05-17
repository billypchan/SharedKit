import SwiftUI

#if os(iOS)
@MainActor
public struct TipJarView<PM: TipJarPurchasing>: View {
  @EnvironmentObject private var purchaseManager: PM
  @Environment(\.dismiss) private var dismiss

  let appName: String
  let heroSystemImage: String

  public init(appName: String, heroSystemImage: String = "heart.fill") {
    self.appName = appName
    self.heroSystemImage = heroSystemImage
  }

  public var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 28) {
          heroSection
          if purchaseManager.isSupporter {
            supporterStateCard
          }
          tiersSection
          restoreButton
          if let error = purchaseManager.purchaseError {
            Text(error)
              .font(.caption)
              .foregroundStyle(.red)
              .multilineTextAlignment(.center)
              .padding(.horizontal)
          }
          footer
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
      }
      .navigationTitle(Text("Support the Developer", bundle: .module))
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
          .fill(Color.pink.opacity(0.15))
          .frame(width: 100, height: 100)
        Image(systemName: heroSystemImage)
          .font(.system(size: 52))
          .foregroundStyle(.pink)
      }
      .padding(.top, 16)

      Text(verbatim: String(
        format: NSLocalizedString("Support %@", bundle: .module, comment: "Tip jar hero title"),
        appName
      ))
      .font(.title2.bold())
      .multilineTextAlignment(.center)

      Text("Independent, ad-free, and built with care. If the app saves you time, a small tip keeps it going.", bundle: .module)
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
  }

  private var supporterStateCard: some View {
    Label {
      Text("You're a Supporter — thank you!", bundle: .module)
    } icon: {
      Image(systemName: "heart.fill")
    }
    .font(.headline)
    .foregroundStyle(.pink)
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.pink.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
  }

  // MARK: - Tiers

  private var tiersSection: some View {
    VStack(spacing: 12) {
      tierCard(.oneTime,
               title: NSLocalizedString("One-Time Tip", bundle: .module, comment: ""),
               subtitle: NSLocalizedString("A single thank-you.", bundle: .module, comment: ""),
               icon: "cup.and.saucer.fill", color: .orange)
      tierCard(.monthly,
               title: NSLocalizedString("Monthly Support", bundle: .module, comment: ""),
               subtitle: NSLocalizedString("Renews each month. Cancel anytime.", bundle: .module, comment: ""),
               icon: "calendar", color: .blue)
      tierCard(.yearly,
               title: NSLocalizedString("Yearly Support", bundle: .module, comment: ""),
               subtitle: NSLocalizedString("Best value. Renews each year. Cancel anytime.", bundle: .module, comment: ""),
               icon: "star.fill", color: .yellow)
    }
  }

  private func tierCard(_ tier: TipJarTier, title: String, subtitle: String, icon: String, color: Color) -> some View {
    Button {
      Task { @MainActor in await purchaseManager.purchase(tier) }
    } label: {
      HStack(spacing: 14) {
        Image(systemName: icon)
          .font(.title3)
          .foregroundStyle(color)
          .frame(width: 32)
        VStack(alignment: .leading, spacing: 2) {
          Text(verbatim: title)
            .font(.subheadline.weight(.semibold))
          Text(verbatim: subtitle)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        Spacer()
        if purchaseManager.isPurchasing {
          ProgressView()
        } else if let price = purchaseManager.displayPrice(for: tier) {
          Text(verbatim: price)
            .font(.subheadline.weight(.semibold))
            .monospacedDigit()
        } else {
          Text("—")
            .font(.subheadline)
            .foregroundStyle(.tertiary)
        }
      }
      .padding(.vertical, 14)
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
    }
    .buttonStyle(.plain)
    .disabled(purchaseManager.isPurchasing || purchaseManager.displayPrice(for: tier) == nil)
  }

  private var restoreButton: some View {
    Button {
      Task { @MainActor in await purchaseManager.restore() }
    } label: {
      Text("Restore Purchases", bundle: .module)
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    .disabled(purchaseManager.isPurchasing)
  }

  private var footer: some View {
    VStack(spacing: 4) {
      Text("Subscriptions auto-renew until cancelled in App Store settings.", bundle: .module)
      Text("No content is locked behind these purchases — they're a thank you.", bundle: .module)
    }
    .font(.caption2)
    .foregroundStyle(.tertiary)
    .multilineTextAlignment(.center)
  }
}
#endif

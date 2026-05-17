import SwiftUI

public struct SupporterBadge: View {
  public init() {}

  public var body: some View {
    HStack(spacing: 4) {
      Image(systemName: "heart.fill")
        .foregroundStyle(.pink)
      Text("Supporter", bundle: .module)
        .font(.caption.weight(.semibold))
        .foregroundStyle(.pink)
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 3)
    .background(Color.pink.opacity(0.12), in: Capsule())
  }
}

import SwiftUI

public struct ExternalLinkRow: View {
  let icon: String
  let iconColor: Color
  let label: LocalizedStringKey

  public init(icon: String, iconColor: Color, label: LocalizedStringKey) {
    self.icon = icon
    self.iconColor = iconColor
    self.label = label
  }

  public var body: some View {
    HStack {
      Image(systemName: icon)
        .foregroundStyle(iconColor)
      Text(label, bundle: .module)
      Spacer()
      Image(systemName: "arrow.up.right.square")
        .foregroundStyle(.secondary)
    }
  }
}

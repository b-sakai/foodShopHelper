import SwiftUI

struct FloatingButton: View {
    var tappedHandler: (() -> Void)? = nil
    var systemImageName: String = "star"
    var body: some View {
        VStack {
            Spacer() // 下に配置
            HStack {
                Spacer() // 右に配置
                Button(action: {
                    self.tappedHandler?()
                }, label: {
                    Image(systemName: systemImageName)
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                })
                .frame(width: 60, height: 60)
                .background(Color.orange)
                .cornerRadius(30.0)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
            }
        }
    }
}

import SwiftUI

struct MemeSnapshot: Transferable {
    var image: Image
    var size = CGSize.zero
    var text: String
    var textSize: CGFloat
    var textColor: Color

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { snapshot in
            let uiImage = await MainActor.run {
                let snapshotContent = snapshot.snapshotView()
                let renderer = ImageRenderer(content: snapshotContent)
                renderer.scale = getScaleFor(size: snapshot.size)
                return renderer.uiImage
            }
            return uiImage?.pngData() ?? Data()
        }
    }
    
    private static func getScaleFor(size: CGSize) -> Double {
        let desiredSize = 3000.0
        if size.width > size.height {
            return desiredSize / max(size.width, 300)
        } else {
            return desiredSize / max(size.height, 300)
        }
    }
    
    private func snapshotView() -> some View {
        image
            .resizable()
            .scaledToFit()
            .overlay(alignment: .bottom) {
                Text(text)
                .font(.system(size: textSize, weight: .heavy))
                .shadow(radius: 10)
                .foregroundColor(textColor)
                .padding()
                .multilineTextAlignment(.center)
            }
            .frame(width: size.width, height: size.height)
    }
}


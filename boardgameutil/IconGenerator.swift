import SwiftUI

struct IconGenerator: View {
    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.4, blue: 0.8),
                                          Color(red: 0.1, green: 0.3, blue: 0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // 주사위
            Image(systemName: "die.face.6.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .offset(x: -30, y: -30)
            
            // 초시계
            Image(systemName: "timer")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .offset(x: 30, y: 30)
        }
        .frame(width: 1024, height: 1024)
    }
}

#Preview {
    IconGenerator()
}

// 아이콘 이미지 생성 함수
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// 아이콘 생성 함수
func generateIcons() {
    let iconGenerator = IconGenerator()
    
    // 필요한 크기들
    let sizes = [
        (40, "Icon-20@2x"),
        (60, "Icon-20@3x"),
        (58, "Icon-29@2x"),
        (87, "Icon-29@3x"),
        (80, "Icon-40@2x"),
        (120, "Icon-40@3x"),
        (120, "Icon-60@2x"),
        (180, "Icon-60@3x"),
        (152, "Icon-76@2x"),  // iPad 아이콘 추가
        (167, "Icon-83.5@2x"), // iPad Pro 아이콘 추가
        (1024, "iTunesArtwork-1024")
    ]
    
    // 각 크기별로 아이콘 생성
    for (size, name) in sizes {
        let scaledView = iconGenerator
            .frame(width: CGFloat(size), height: CGFloat(size))
        
        let image = scaledView.snapshot()
        
        // 이미지 저장
        if let data = image.pngData() {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent("\(name).png")
            try? data.write(to: fileURL)
            print("Generated \(name).png")
        }
    }
}

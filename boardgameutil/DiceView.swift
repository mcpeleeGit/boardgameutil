import SwiftUI

struct DiceView: View {
    @State private var diceNumber1 = 1
    @State private var diceNumber2 = 1
    @State private var isRolling = false
    @State private var numberOfDice = 1
    
    // iPad 여부 확인
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // 디바이스에 따른 크기 조정
    var titleFontSize: CGFloat { isPad ? 50 : 34 }
    var diceFontSize: CGFloat { isPad ? 150 : 80 }
    var buttonFontSize: CGFloat { isPad ? 24 : 17 }
    var buttonWidth: CGFloat { isPad ? 200 : 100 }
    var spacing: CGFloat { isPad ? 40 : 20 }
    
    var body: some View {
        VStack(spacing: spacing) {
            Text("주사위")
                .font(.system(size: titleFontSize))
                .fontWeight(.bold)
            
            Picker("주사위 개수", selection: $numberOfDice) {
                Text("1개").tag(1)
                Text("2개").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .scaleEffect(isPad ? 1.5 : 1.0)
            
            HStack(spacing: spacing) {
                Image(systemName: "die.face.\(diceNumber1).fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: diceFontSize, height: diceFontSize)
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(isRolling ? 360 : 0))
                
                if numberOfDice == 2 {
                    Image(systemName: "die.face.\(diceNumber2).fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: diceFontSize, height: diceFontSize)
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(isRolling ? 360 : 0))
                }
            }
            
            if numberOfDice == 2 {
                Text("합계: \(diceNumber1 + diceNumber2)")
                    .font(.system(size: buttonFontSize * 1.5))
                    .fontWeight(.bold)
            }
            
            Button(action: rollDice) {
                Text("주사위 굴리기")
                    .font(.system(size: buttonFontSize))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: buttonWidth)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .disabled(isRolling)
        }
        .padding(isPad ? 40 : 20)
    }
    
    private func rollDice() {
        isRolling = true
        
        // 주사위 굴리는 애니메이션을 위한 지연
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            diceNumber1 = Int.random(in: 1...6)
            if numberOfDice == 2 {
                diceNumber2 = Int.random(in: 1...6)
            }
            isRolling = false
        }
    }
}

#Preview {
    DiceView()
} 
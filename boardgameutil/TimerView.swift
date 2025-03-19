import SwiftUI
import AVFoundation

struct TimerView: View {
    @State private var timeElapsed = 0.00
    @State private var isActive = false
    @State private var timer: Timer?
    @State private var isWarning = false
    @State private var audioPlayer: AVAudioPlayer?
    
    // iPad 여부 확인
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // 디바이스에 따른 크기 조정
    var titleFontSize: CGFloat { isPad ? 50 : 34 }
    var timerFontSize: CGFloat { isPad ? 100 : 60 }
    var buttonFontSize: CGFloat { isPad ? 24 : 17 }
    var buttonWidth: CGFloat { isPad ? 200 : 100 }
    var spacing: CGFloat { isPad ? 40 : 20 }
    
    var body: some View {
        VStack(spacing: spacing) {
            Text("초시계")
                .font(.system(size: titleFontSize))
                .fontWeight(.bold)
            
            Text(timeString(from: timeElapsed))
                .font(.system(size: timerFontSize, weight: .bold, design: .monospaced))
                .foregroundColor(isWarning ? .red : .primary)
            
            HStack(spacing: spacing) {
                Button(action: {
                    if isActive {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Text(isActive ? "정지" : "시작")
                        .font(.system(size: buttonFontSize))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: buttonWidth)
                        .background(isActive ? Color.red : Color.green)
                        .cornerRadius(15)
                }
                
                Button(action: resetTimer) {
                    Text("리셋")
                        .font(.system(size: buttonFontSize))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: buttonWidth)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }
            
            HStack(spacing: spacing) {
                Button(action: { addTime(60) }) {
                    Text("+1분")
                        .font(.system(size: buttonFontSize))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: buttonWidth)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                
                Button(action: { addTime(-60) }) {
                    Text("-1분")
                        .font(.system(size: buttonFontSize))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: buttonWidth)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }
        }
        .padding(isPad ? 40 : 20)
        .onAppear {
            setupAudioPlayer()
        }
    }
    
    private func timeString(from seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        let centiseconds = Int((seconds * 100).truncatingRemainder(dividingBy: 100))
        return String(format: "%02d:%02d.%02d", minutes, remainingSeconds, centiseconds)
    }
    
    private func setupAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "beep", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading sound: \(error.localizedDescription)")
        }
    }
    
    private func startTimer() {
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            timeElapsed += 0.01
            
            // 55초부터 빨간색으로 표시
            isWarning = timeElapsed >= 55
            
            // 58초부터 경고음 재생
            if timeElapsed >= 58 && timeElapsed < 60 {
                let seconds = Int(timeElapsed)
                if seconds % 1 == 0 {
                    audioPlayer?.play()
                }
            }
        }
    }
    
    private func stopTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
        isWarning = false
    }
    
    private func resetTimer() {
        stopTimer()
        timeElapsed = 0.00
    }
    
    private func addTime(_ seconds: Double) {
        timeElapsed = max(0, timeElapsed + seconds)
    }
}

#Preview {
    TimerView()
} 

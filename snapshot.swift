import SwiftUI

struct ContentView: View {
    @State private var userCode = """
    func helloWorld() {
        print("Hello, World!")
    }
    """
    
    @State private var width: CGFloat = 400
    @State private var height: CGFloat = 300
    @State private var lineSpacing: CGFloat = 4
    @State private var textSize: CGFloat = 12
    @State private var circleYPosition: CGFloat = 20 // Initial Y position
    
    let originalWidth: CGFloat = 400
    let originalHeight: CGFloat = 300
    
    var body: some View {
        ScrollView {
            VStack {
                // Your code snippet with Mac screen outline overlay
                CodeSnapshotView(code: $userCode, width: width, height: height, lineSpacing: lineSpacing, textSize: textSize, circleYPosition: circleYPosition)
                
                // TextField to change the code
                TextField("Enter new code", text: $userCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Button to take a snapshot
                Button(action: {
                    // Take snapshot action
                    takeSnapshot()
                }) {
                    Text("Take Snapshot")
                }
                
                // Button to reset to original size
                Button(action: {
                    withAnimation {
                        width = originalWidth
                        height = originalHeight
                    }
                }) {
                    Text("Reset to Original Size")
                }
                
                // Adjust screen size sliders
                VStack(spacing: 16) {
                    VStack {
                        Text("Width:")
                        Slider(value: $width, in: 100...600, step: 1)
                        Text("\(Int(width))")
                    }
                    VStack {
                        Text("Height:")
                        Slider(value: $height, in: 100...400, step: 1)
                        Text("\(Int(height))")
                    }
                    
                    // Adjust line spacing slider
                    VStack {
                        Text("Line Spacing:")
                        Slider(value: $lineSpacing, in: 0...20, step: 1)
                        Text("\(Int(lineSpacing))")
                    }
                    
                    // Adjust text size slider
                    VStack {
                        Text("Text Size:")
                        Slider(value: $textSize, in: 8...20, step: 1)
                        Text("\(Int(textSize))")
                    }
                    
                    // Slider to adjust circle Y position
                    VStack {
                        Text("Circle Y Position:")
                        Slider(value: $circleYPosition, in: 0...height - 20, step: 1)
                        Text("\(Int(circleYPosition))")
                    }
                }
                .padding()
            }
        }
    }
    
    func takeSnapshot() {
        // Take snapshot code
        // This is just a placeholder for the actual snapshot functionality
        print("Snapshot taken!")
    }
}

struct CodeSnapshotView: View {
    @Binding var code: String
    var width: CGFloat
    var height: CGFloat
    var lineSpacing: CGFloat
    var textSize: CGFloat
    var circleYPosition: CGFloat // Add circleYPosition as a parameter
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Code screen
            ScrollView {
                VStack(alignment: .leading, spacing: lineSpacing) {
                    ForEach(1..<code.components(separatedBy: "\n").count + 1, id: \.self) { lineNumber in
                        HStack(spacing: 4) {
                            Text("\(lineNumber)")
                                .font(.system(size: textSize, weight: .regular, design: .monospaced))
                                .foregroundColor(.gray)
                                .frame(width: 20, alignment: .trailing)
                            TextField("", text: Binding(
                                get: { code.components(separatedBy: "\n")[lineNumber - 1] },
                                set: { newValue in
                                    var lines = code.components(separatedBy: "\n")
                                    lines[lineNumber - 1] = newValue
                                    code = lines.joined(separator: "\n")
                                }
                            ))
                            .font(.system(size: textSize, weight: .regular, design: .monospaced))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .padding(.vertical, 2)
                        }
                    }
                }
                .padding(.leading, 8)
                .frame(width: width, height: height)
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .cornerRadius(8)
            }
            
            // Traffic light buttons
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .offset(x: 0, y: circleYPosition) // Adjust Y position of the circle
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 8, height: 8)
                    .offset(x: 0, y: circleYPosition) // Adjust Y position of the circle
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                    .offset(x: 0, y: circleYPosition) // Adjust Y position of the circle
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
    }
}

func takeSnapshot() {
    // Take snapshot code
    // This is just a placeholder for the actual snapshot functionality
    print("Snapshot taken!")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

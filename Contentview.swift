import SwiftUI
import UIKit
import Vision

struct HistoryItem: Identifiable {
    var id = UUID()
    var date: Date
    var extractedText: String
    var editedText: String
}

struct HistoryView: View {
    @State private var selectedHistoryItem: HistoryItem?
    @State private var isShareSheetPresented = false

    let historyItems: [HistoryItem]

    var body: some View {
        NavigationView {
            List(historyItems) { item in
                Button(action: {
                    selectedHistoryItem = item
                }) {
                    VStack(alignment: .leading) {
                        Text("\(item.date, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(item.extractedText)
                            .lineLimit(1)
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("History")
            .sheet(item: $selectedHistoryItem) { historyItem in
                ShareSheetView(text: historyItem.extractedText, isPresented: $isShareSheetPresented)
            }
        }
    }
}

struct ShareSheetView: View {
    let text: String
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Share this text")
            Text(text)
            Button("Share") {
                isPresented = false
                shareText(text)
            }
        }
    }

    private func shareText(_ text: String) {
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var detectedText: String = ""
    @State private var editedText: String = ""
    @State private var isEditing = false
    @State private var isShowingImagePicker = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var isSaveButtonVisible = false
    @State private var historyItems: [HistoryItem] = []

    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        if selectedImage == nil {
                            Text("Select image to extract text")
                                .font(.title)
                                .foregroundColor(.gray)
                                .padding()
                        }

                        Button("Select Image") {
                            self.isShowingImagePicker.toggle()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)

                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)

                            Text("Detected Text:")
                                .font(.title)
                                .foregroundColor(.blue)

                            if isEditing {
                                ScrollView {
                                    TextEditor(text: $editedText)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                .frame(maxHeight: .infinity)
                            } else {
                                Text(detectedText)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    .font(.body)
                            }

                            HStack {
                                if !isEditing {
                                    Button("Edit") {
                                        editedText = detectedText
                                        isEditing.toggle()
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                } else {
                                    Spacer()

                                    Button("Save") {
                                        detectedText = editedText
                                        isEditing.toggle()
                                        withAnimation {
                                            self.isSaveButtonVisible = false
                                        }
                                        if let index = historyItems.firstIndex(where: { $0.extractedText == detectedText }) {
                                            historyItems[index].editedText = editedText
                                        }
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .offset(y: -keyboardHeight + (isSaveButtonVisible ? -40 : 0))
                                    .animation(.easeInOut)
                                }

                                Button("Copy") {
                                    UIPasteboard.general.string = detectedText
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)

                                Button("Export") {
                                    if !detectedText.isEmpty {
                                        exportTextAsFile(detectedText)
                                    }
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)

                                Button("Re-scan") {
                                    if let image = selectedImage {
                                        extractTextFromImage(image: image)
                                    }
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                            }
                            .padding(.bottom, 50)
                        }
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.1))
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: $isShowingImagePicker, onDismiss: processImage) {
                    ImagePicker(image: self.$selectedImage)
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                        self.keyboardHeight = keyboardSize.height
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        self.keyboardHeight = 0
                    }
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            HistoryView(historyItems: historyItems)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
    }

    func processImage() {
        guard let selectedImage = selectedImage else { return }
        extractTextFromImage(image: selectedImage)
    }

    func extractTextFromImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                detectedText += topCandidate.string + "\n"
            }
            DispatchQueue.main.async {
                self.detectedText = detectedText
                let historyItem = HistoryItem(date: Date(), extractedText: detectedText, editedText: detectedText)
                self.historyItems.append(historyItem)
            }
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform OCR request: \(error)")
        }
    }

    func exportTextAsFile(_ text: String) {
        let filename = "detected_text.txt"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)

        do {
            try text.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let av = UIActivityViewController(activityItems: [path!], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        } catch {
            print("Error exporting text: \(error)")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
@main
struct imagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}



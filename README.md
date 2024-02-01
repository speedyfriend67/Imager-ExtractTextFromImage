### SwiftUI Image To Text Extractor

This SwiftUI app allows users to extract text from images, edit the extracted text, save it as a file, and view the extraction history.
This was made on my iPhone, using Swifty!

#### Features

- **Text Extraction**: Extract text from images using OCR (Optical Character Recognition).
- **Editing**: Edit the extracted text directly within the app.
- **Export**: Save the extracted text as a text file and share it with others.
- **History**: View a history of past text extractions with the ability to share and delete entries.
- **Easy-to-Use Interface**: Intuitive UI design for effortless text extraction and management.

#### Screenshots

![Screenshot 1](Screenshots/screenshot1.png) ![Screenshot 2](Screenshots/screenshot2.png)

#### Usage

1. **Select Image**: Tap the "Select Image" button to choose an image from the photo library.
2. **Text Extraction**: Once an image is selected, the app will extract text from the image using OCR.
3. **Text Editing**: Edit the extracted text directly within the app if needed.
4. **Export**: Tap the "Export" button to save the extracted text as a text file and share it.
5. **History**: Switch to the "History" tab to view past text extractions, share entries, and delete them.

#### Code Overview

- `ContentView`: Main view containing the image picker, text extraction, editing, and export functionality.
- `ImagePicker`: SwiftUI representation of the UIKit `UIImagePickerController` for selecting images from the photo library.
- `HistoryView`: View for displaying a list of past text extraction history entries with share and delete functionality.
- `ShareSheetView`: View for sharing extracted text via system share sheet.
- `HistoryItem`: Model representing a single entry in the extraction history.

#### Technologies Used

- SwiftUI: Apple's declarative UI framework for building user interfaces across all Apple platforms.
- UIKit: Apple's framework for building iOS and macOS applications.
- Vision: Apple's framework for computer vision tasks, used for OCR text extraction.

#### Requirements

- iOS 14.0+ / macOS 11.0+
- Xcode 12.0+
- Swift 5.3+

#### Installation

1. Clone the repository: `git clone https://github.com/your-username/swiftui-image-text-extractor.git`
2. Open the project in Xcode. (i didn't build on Xcode , i used Swifty by sparkclechanJB but you can build your own ipa with the contentview.swift file. i wrote almost every code into it lol)
3. Run the app on a simulator or device.

#### Credits

This app is created by [Speedyfriend67].

#### License

This project is licensed under the [MIT License](LICENSE).

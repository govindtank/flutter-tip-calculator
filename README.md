# 💰 Flutter Tip Calculator

A modern, feature-rich tip calculator app for iOS, Android, and Web built with Flutter. Calculate fair tips quickly and share your results!

![Flutter](https://img.shields.io/badge/Flutter-3.16-blue)
![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20Web-lightgrey)
![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

### Core Functionality
- 🧮 **Accurate Tip Calculations** - Instant bill splitting for groups of any size
- 💵 **Multi-Currency Support** - Works with USD, EUR, GBP and all major currencies
- 📜 **Transaction History** - View, copy, export, or share past calculations
- ⚡ **Quick Actions** - Copy results to clipboard, export as JSON/CSV

### User Experience
- 🎨 **Modern UI Design** - Clean Material 3 interface with smooth animations
- ✏️ **Input Validation** - Smart validation prevents invalid entries
- 📱 **Responsive Layout** - Works seamlessly on phones and tablets
- ♿ **Accessibility Ready** - Full accessibility support for screen readers

### Advanced Features (Phase 2 & 3)
- ⏰ **Timestamp Tracking** - All calculations include precise timestamps
- 🔢 **Quick Tip Selector** - One-tap percentage chips (10%, 15%, 20%, 25%, 30%)
- 📋 **Clipboard Copy** - Instantly copy per-person amounts
- 💾 **Export Options** - Export history as JSON or CSV files
- 🗑️ **Clear History** - Easily remove old calculations
- 💬 **Helpful Hints** - On-screen guidance for new users

## 🚀 Quick Start

### Prerequisites
- [Flutter SDK](https://flutter.dev) 3.16+
- Xcode (iOS development)
- Android Studio/ADB (Android development)
- Node.js (for web builds)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/flutter-tip-calculator.git
cd flutter-tip-calculator

# Get dependencies
flutter pub get

# Run on your device
flutter run
```

### Build for Production

```bash
# iOS
flutter build ios --release

# Android  
flutter build apk --release

# Web
flutter build web --release
```

## 📸 Screenshots

<div align="center">

![Calculator Screenshot](screenshots/calculator_main.png)
*Bill input and tip calculation*

![History View](screenshots/history_view.png)
*Transaction history with timestamps*

</div>

## 🔧 How to Use

### Basic Calculation

1. **Enter Bill Amount** - Input the total bill value (supports decimals)
2. **Select Tip Percentage** - Choose from preset chips (10%, 15%, 20%, etc.) or custom value
3. **Enter Number of People** - Specify how many are splitting the bill
4. **View Results** - See per-person cost including tip in the results card

### Quick Actions

- **Copy to Clipboard** - Tap "Copy Per Person" to instantly copy the amount
- **Export History** - Share your calculations as JSON or CSV files
- **Clear History** - Remove old entries with one tap
- **Share Results** - Use platform-native sharing to send results to friends

## 📋 Features Breakdown

### Phase 1: Core MVP (Initial Release)
- ✅ Clean Material 3 design
- ✅ Bill amount input with validation
- ✅ Tip percentage selector (chips + custom input)
- ✅ People count slider (2-10 people)
- ✅ Results display with per-person breakdown
- ✅ Transaction history storage

### Phase 2: History & Persistence (Commit c775194)
- ✅ Timestamp field added to `Calculation` model
- ✅ Fixed JSON parsing with error handling
- ✅ Enhanced history UI with count header and timestamps
- ✅ Empty state for new users
- ✅ Improved ListTile design with icons

### Phase 3: Advanced Features (Commit 348c405)
- ✅ Quick tip percentage chips (10%, 15%, 20%, 25%, 30%)
- ✅ 20% pre-selected with visual highlighting
- ✅ Clipboard copy functionality for results
- ✅ Clear history button with confirmation
- ✅ Multi-format export (JSON, CSV)
- ✅ Input validation improvements
- ✅ Currency code display in results

### Phase 4: Polish & Accessibility (Commit dccfd33)
- ✅ Added helpful hint text for users
- ✅ Enhanced result container styling
- ✅ Improved focus states and accessibility
- ✅ Better visual hierarchy and spacing

## 📁 Project Structure

```
flutter-tip-calculator/
├── lib/
│   ├── main.dart              # App entry point and UI
│   └── model/
│       └── calculation.dart   # Data model
├── assets/                    # Images, fonts, icons
├── pubspec.yaml               # Dependencies and metadata
├── README.md                  # This file
└── screenshots/               # App screenshots
```

## 🗄️ Data Model

### Calculation Model

```dart
class Calculation {
  final String id;           // Unique identifier (v4 uuid)
  final double billAmount;   // Original bill amount
  final int numberOfPeople;  // Number of people splitting
  final String percentage;   // Tip percentage as string ("20")
  final DateTime timestamp;  // When calculation was made
  
  // Computed properties
  final double tipAmount;    // Bill * (percentage / 100)
  final double perPersonTotal; // Total per person with tip
}
```

## 🛠️ Tech Stack

- **UI Framework**: Flutter 3.16+
- **Material Design**: Material 3 components
- **State Management**: Built-in Flutter state management
- **UUID Generation**: `crypto` package for unique IDs
- **Storage**: Local SharedPreferences
- **Sharing**: `share_plus` package (Phase 3)

## ⚙️ Configuration

### Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  cupertino_icons: ^1.0.6
  collection: ^1.18.0       # For range iterator (people slider)
  crypto: ^3.0.3            # For UUID generation
  share_plus: ^12.0.2       # For sharing functionality
  intl: ^0.19.0             # For date formatting
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🔒 Security Considerations

- No sensitive data stored locally beyond calculation history
- All calculations performed client-side
- User inputs validated before processing
- Timestamps prevent old data confusion

## 🐛 Known Limitations

- Minimum people count is 2 (single person doesn't make sense for splitting)
- Maximum people count is 10 (prevents very large group calculations)
- Tip percentage limited to 0-50% range for practical use cases
- History only stores local calculations (no cloud sync currently)

## 🚀 Roadmap

- [ ] Cloud backup and restore
- [ ] Custom currency symbols
- [ ] Dark mode support
- [ ] Widget for embedding in other apps
- [ ] Statistics dashboard (monthly totals, favorite tip %)
- [ ] Email sharing of calculations
- [ ] Offline-first PWA version

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📧 Contact

- **Project Owner**: Govind
- **Email**: govindelect@gmail.com
- **GitHub**: [@yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- Material Design 3 guidelines for UI consistency
- Open source contributors and community

---

**Built with ❤️ using Flutter & Dart**

# Flutter Tip Calculator

## Overview
A modern, feature-rich tip calculator app built with Flutter. Calculate tips quickly and easily with history tracking and sharing capabilities.

## Features
- ⚡ Lightning-fast tip calculations
- 📜 Calculation history with persistent storage
- 💬 Share results directly to messaging apps
- 🌙 Dark/Light theme support
- 🎨 Customizable tip percentages
- 📱 Responsive design for all screen sizes
- ✏️ Manual bill amount entry

## Getting Started

### Prerequisites
- [Flutter](https://flutter.dev) SDK >= 3.0.0
- [Dart](https://dart.dev) SDK >= 3.0.0

### Installation
```bash
git clone https://github.com/govind/flutter-tip-calculator.git
cd flutter-tip-calculator
flutter pub get
flutter run
```

### Development
```bash
# Run on device or emulator
flutter run -d <device_id>

# Debug mode with DevTools
flutter run --debug

# Hot reload for fast iteration
flutter run
```

## Screenshots
![Tip Calculator](screenshots/calc_1.png)  # Add your screenshots

## Project Structure
```
flutter_tip_calculator/
├── lib/                      # Main application code
│   ├── main.dart            # App entry point
│   ├── models/              # Data models
│   │   └── calculation.dart # Calculation data model
│   ├── screens/             # UI screens
│   │   ├── calculator_screen.dart
│   │   └── history_screen.dart
│   └── services/            # Business logic
│       ├── share_service.dart
│       └── storage_service.dart
├── pubspec.yaml             # Dependencies and metadata
├── analysis_options.yaml    # Linting rules
└── README.md               # This file
```

## Key Features Deep Dive

### History Management
- Automatically saves all calculations locally
- View and delete past calculations
- Export history (future feature)

### Share Functionality
- Share tip results to any app that supports sharing
- Custom share cards with styled information

### User Experience
- Clean, intuitive interface
- Quick percentage buttons
- Manual override capability

## Configuration
Edit `pubspec.yaml` to customize:
- App icon
- Launch image
- Dependencies and plugins
- Package info

## Testing
```bash
# Run all tests
flutter test

# Test with coverage
flutter test --coverage
```

## Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## License
MIT License - See LICENSE file for details.

## Support
- [GitHub Issues](https://github.com/govind/flutter-tip-calculator/issues)
- Open an issue for bugs or feature requests

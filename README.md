# TipCalc Pro — Flutter Tip Calculator

<h3 align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Web-Deployable-blue?style=for-the-badge" alt="Web">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT">
</h3>

<p align="center">
  <strong>A beautiful, feature-rich tip calculator</strong><br>
  <a href="https://govindtank.github.io/flutter-tip-calculator/">🔗 Live Demo — https://govindtank.github.io/flutter-tip-calculator/</a>
</p>

---

## ✨ Features

### 🎯 Core Calculator
- **Bill amount input** with live formatting (commas, decimal precision)
- **Tip presets** — 10%, 15%, 18%, 20%, 22%, 25% with animated selection
- **Custom tip slider** — choose any percentage from 5% to 50%
- **Split bill** — divide between 1 to 50 people with +/- buttons (long-press for fast increment)
- **4 rounding modes** — None, Round Up, Round Down, Round to Nearest Dollar
- **Real-time results** — animated number counters, instant updates as you type

### 📊 Results Breakdown
- Large per-person total with animated counter
- Full breakdown: Subtotal, Tip Amount, Total, Per-Person
- **Copy** result to clipboard
- **Share** as formatted text
- **Quick actions** — Round to nearest $1, Double my share, Split 3 ways, Double tip

### 🕐 History
- **Persistent history** — all calculations saved locally
- **Summary stats** — total calculations, average tip %, most common split
- **Search** by amount or percentage
- **Filters** — This week, This month, All time
- **Swipe to delete** individual entries
- **Clear all** with confirmation

### 🎨 Themes & Customization
- **6 beautiful color schemes**: Violet, Ocean, Emerald, Amber, Rose, Slate
- **Dark / Light mode** toggle
- **9 currencies**: USD ($), EUR (€), GBP (£), INR (₹), JPY (¥), CAD (C$), AUD (A$), BRL (R$), MXN (N$)
- **Settings persistence** — remembers your preferences across sessions

### 🌐 Cross-Platform
- **Flutter Web** — deployed on GitHub Pages
- **Responsive layout** — mobile-first, works up to 1200px desktop width
- **Bottom navigation** — Calculator, History, Settings tabs

---

## 📁 Project Structure

```
lib/
├── main.dart                     # App entry, theme management, state
├── models/
│   ├── calculation.dart           # TipCalculation + RoundingOption enum
│   ├── currency.dart             # Currency data (9 currencies)
│   ├── app_settings.dart         # AppSettings (theme, currency, defaults)
│   └── models.dart               # Barrel export
├── themes/
│   └── app_themes.dart           # 6 color schemes × light/dark = 12 themes
├── services/
│   └── storage_service.dart      # SharedPreferences persistence
├── utils/
│   ├── formatters.dart           # Currency, %, date formatting
│   └── share_utils.dart          # Share text generation
├── widgets/
│   ├── tip_input_field.dart      # Animated bill amount input
│   ├── tip_preset_selector.dart   # Scrollable preset pills + custom slider
│   ├── split_selector.dart       # +/- people counter
│   ├── rounding_selector.dart    # 4-option rounding pill row
│   ├── results_card.dart         # Gradient results with animated counter
│   ├── quick_actions_bar.dart    # Quick action chips
│   ├── theme_selector_sheet.dart # Bottom sheet theme/dark mode picker
│   └── widgets.dart              # Barrel export
└── pages/
    ├── home_page.dart            # Main calculator view
    ├── history_page.dart         # History list + stats + search
    ├── settings_page.dart        # All preferences
    └── main_shell.dart           # Bottom nav shell
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev) ≥ 3.0.0
- [Dart](https://dart.dev) ≥ 3.0.0

### Installation

```bash
# Clone the repository
git clone https://github.com/govindtank/flutter-tip-calculator.git
cd flutter-tip-calculator

# Install dependencies
flutter pub get

# Run locally (web)
flutter run -d chrome

# Run on mobile
flutter run -d <device_id>

# Build for production web
flutter build web --release --base-href /flutter-tip-calculator/
```

### Development

```bash
# Hot reload (default)
flutter run

# Run with DevTools
flutter run --debug

# Analyze code
flutter analyze

# Run tests
flutter test

# Build for iOS simulator
flutter build ios --simulator --no-codesign

# Build for Android
flutter build apk --debug
```

---

## 🖥️ Web Deployment

The app is deployed automatically via GitHub Actions on every push to `main`.

**Live URL**: https://govindtank.github.io/flutter-tip-calculator/

### Manual Deployment

```bash
# Build with correct base href for GitHub Pages subdirectory
flutter build web --release --base-href /flutter-tip-calculator/

# The built files are in build/web/
# Deploy by pushing the build/web folder to the gh-pages branch
```

---

## 🎨 Theme Reference

| Theme   | Primary Color | Gradient              |
|---------|--------------|-----------------------|
| Violet  | `#7C3AED`    | `#7C3AED` → `#A855F7` |
| Ocean   | `#0284C7`    | `#0369A1` → `#38BDF8` |
| Emerald | `#059669`    | `#047857` → `#34D399` |
| Amber   | `#D97706`    | `#B45309` → `#FCD34D` |
| Rose    | `#E11D48`    | `#BE123C` → `#FB7185` |
| Slate   | `#475569`    | `#334155` → `#94A3B8` |

---

## 📱 Screenshots

> Add your screenshots to a `screenshots/` folder and reference them here:
> ```markdown
> ![Calculator](screenshots/calculator.png)
> ![History](screenshots/history.png)
> ![Settings](screenshots/settings.png)
> ```

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 🙏 Acknowledgements

Built with [Flutter](https://flutter.dev) — the beautiful, fast, portable UI framework.

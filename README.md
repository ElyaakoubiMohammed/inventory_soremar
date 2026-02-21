# 📦 Soremar Inventory — NFC Mobile Application

A cross-platform mobile application built with **Flutter** for **Soremar**, enabling NFC-based authentication and inventory management. The app allows staff to scan NFC tags to identify items, manage inventory records, and track presence — replacing manual processes with a fast, reliable mobile solution.

---

## ✨ Features

- 📡 **NFC Read & Write** — Scan and write NFC tags for item identification and authentication
- 🔐 **Login & Authentication** — Secure user login before accessing the system
- 🏠 **Home Dashboard** — Overview of inventory status and quick actions
- 🔍 **Scan Page** — Real-time NFC scanning interface
- 📋 **Item Details** — View detailed information on scanned items
- 📝 **Form Submission** — Submit and update inventory records
- 👤 **User Profile** — Profile management page
- 📵 **NFC Unavailable Handling** — Graceful fallback for devices without NFC support

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| Language | Dart |
| NFC | flutter_nfc_kit |
| Platform | Android, iOS |

---

## 📁 Project Structure

```
inventory_soremar/
├── lib/
│   ├── screens/
│   │   ├── home_page.dart          # Main dashboard
│   │   ├── scan_page.dart          # NFC scanning interface
│   │   ├── login_page.dart         # Authentication
│   │   ├── details.dart            # Item details
│   │   ├── Formulaire_page.dart    # Inventory form
│   │   ├── profilepage.dart        # User profile
│   │   └── NFCUnavailablepage.dart # Fallback page
│   ├── services/
│   │   └── nfc_service.dart        # NFC read/write logic
│   ├── Widgets/                    # Reusable UI components
│   ├── components/                 # Custom buttons and inputs
│   ├── global/
│   │   └── theme.dart              # App theming
│   └── main.dart                   # Entry point
├── assets/                         # Images and custom fonts
└── pubspec.yaml                    # Dependencies
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Android Studio or Xcode
- A physical device with NFC support (for full functionality)

### Installation

```bash
# Clone the repository
git clone https://github.com/ElyaakoubiMohammed/inventory_soremar.git

# Navigate into the project
cd inventory_soremar

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📌 Note

This application was developed during an internship at **Soremar** (July–September 2024) as part of a broader effort to digitize and automate inventory and attendance management processes.

---

## 👨‍💻 Author

**Mohammed Elyaakoubi**  
[GitHub](https://github.com/ElyaakoubiMohammed) · [LinkedIn](https://linkedin.com/in/Mohammed-Elyaakoubi)

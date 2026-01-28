# AI Coding Instructions for Food Gaadi

## Project Overview
**Food Gaadi** is a Flutter food delivery vendor app that enables food truck/restaurant operators to manage their menu items, orders, and account. The project is early-stage with Firebase integration (Firestore, Storage) for backend services.

## Architecture & Navigation Flow

### Entry Point: `lib/main.dart`
- **SplashScreen** (3-sec delay) → **LoginPage** → **DashboardPage**
- **DashboardPage** is the hub: uses `BottomNavigationBar` with 4 tabs (Dashboard, Menu, History, Profile)
- Navigation pattern: `Navigator.push()` and `Navigator.pushReplacement()` for direct routing

### Screen Organization (`lib/screens/`)
- **login_page.dart**: Email/mobile login with exit dialog on back button (`PopScope`)
- **dashboard_page.dart**: Tab controller managing `DashboardView`, `MenuPage`, `HistoryPage`, `ProfilePage`
- **menu_page.dart**: Menu management with "Active Items" vs "Drafts/Hidden" toggle; contains `MenuItem` model class
- **add_food_item_page.dart**: Form for adding new items (image picker via `ImagePicker` package)
- **history_page.dart, profile_page.dart**: Placeholder pages (scaffold structure only)

### Widget Pattern
- Only one shared widget: `FoodGaadiLogo` in `lib/widgets/food_gaadi_logo.dart`
- Most UI is inline in screens; consider extracting reusable components to `lib/widgets/` as app grows

## Data & State Management

### Current Approach: Stateful Widgets
- **No external state management** (Provider, Riverpod, GetX) yet
- State is local to each `State` class using `setState()`
- Example: `MenuPage` holds hardcoded `menuItems` list; `DashboardView` tracks `isOnline` toggle

### Data Model: MenuItem
Located in `menu_page.dart`:
```dart
class MenuItem {
  final String id, name, desc, category, imageUrl;
  final double price;
  bool isAvailable, isPopular;
}
```

### Firebase Integration (Configured but Not Yet Wired)
- **Dependencies**: `cloud_firestore`, `firebase_storage`, `image_picker`
- **Setup**: Android (`google-services.json`), iOS (via plugin), platform-specific configs ready
- **Current Gap**: No Firestore queries or Firebase Storage uploads in app code—UI is disconnected from backend

## Key Conventions & Patterns

### Styling
- **Primary color**: Orange (`Colors.orange`)
- **Accent colors**: Dark green (Pacifico font), beige background (`#FFF9F3`, `#D0BB95`)
- **Typography**: `google_fonts` package; custom brand font (Pacifico) for "Gaadi" text
- **App Bar**: White background with orange/black text

### Component Structure
- Each screen is a `StatefulWidget` (except `ProfilePage` which is `StatelessWidget`)
- Screens are **self-contained**; communication between tabs happens via `DashboardPage` index switching, not prop drilling
- Hero animations used for logo transition (`SplashScreen` → `LoginPage`)

### Navigation
- Simple routes: no named routes yet, all `Navigator.push(MaterialPageRoute(...))`
- Screens passed as page objects in `_pages` list for tab switching (see `DashboardPage`)

## Developer Workflows

### Build & Run
```bash
flutter pub get          # Install dependencies
flutter run             # Run on default device/emulator
```

### Code Quality
```bash
flutter analyze         # Check lints (uses flutter_lints + analysis_options.yaml)
flutter format          # Format Dart code
```

### Common Tasks
- **Add a dependency**: Update `pubspec.yaml`, run `flutter pub get`
- **Add a screen**: Create in `lib/screens/`, import in `dashboard_page.dart`, add to `_pages` list
- **Add a reusable widget**: Create in `lib/widgets/`, import where needed
- **Test locally**: Use `image_picker` (requires platform-specific emulator setup for iOS/Android)

## Integration Points & To-Do Items

### Firebase Wiring Needed
- **Firestore**: Query/store `MenuItem` data in collection `menus/{restaurantId}/items`
- **Storage**: Upload food images when `AddFoodItemPage` form is submitted
- **Auth**: Connect login to Firebase Authentication (currently hardcoded)

### Expected Patterns for Firebase
When implementing:
1. Create a `service` or `repository` layer (e.g., `lib/services/firestore_service.dart`)
2. Fetch data in `initState()` of stateful screens
3. Use `StreamBuilder` or `FutureBuilder` for async UI updates
4. Handle errors gracefully (user feedback via `SnackBar`)

## Important Files & Directories

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point, theme config, splash screen |
| `lib/screens/dashboard_page.dart` | Tab navigation hub |
| `lib/screens/menu_page.dart` | Menu list + `MenuItem` model |
| `pubspec.yaml` | Dependencies, app name, asset paths, splash/icon config |
| `analysis_options.yaml` | Linter rules (flutter_lints enabled) |
| `android/app/google-services.json` | Firebase config for Android |

## Gotchas & Context for AI Agents

1. **No backend yet**: All data is hardcoded; Firebase initialization complete but not in use
2. **Mixed widget patterns**: Some screens are `Stateful`, one is `Stateless`—normalize as needed
3. **Hero animations**: Used in login flow; be careful with navigation transitions
4. **Image assets**: Logo at `lib/images/icon.png` used for splash & launcher icon config
5. **Platform specifics**: Android & iOS have native platform channel setup; Windows/macOS/Linux platforms included but not actively developed
6. **Form validation**: `AddFoodItemPage` has `_formKey` but logic incomplete—needs Firebase integration to persist

## Next Steps for Agents

- Implement Firestore service layer for menu item CRUD
- Add Firebase Authentication to login flow
- Create reusable UI components (menu item cards, form fields) in `lib/widgets/`
- Add error handling & loading states across screens
- Migrate from `setState()` to a state management solution if complexity grows

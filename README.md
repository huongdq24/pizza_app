# 🍕 Pizza App - E-Commerce Mobile Application

A full-featured Flutter e-commerce application for ordering pizzas with an admin panel, built with Firebase backend and modern UI design.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 📱 Screenshots

### Customer Experience
| Login | Product List | Product Detail | Shopping Cart |
|-------|-------------|----------------|---------------|
| Modern authentication with gradient UI | Browse pizza catalog | View nutritional info | Manage cart items |

| Checkout | Order Success | Order History |
|----------|--------------|---------------|
| Payment & delivery details | Confirmation with tracking | View all orders |

### Admin Panel
| Admin View | Add Product | Order Management |
|-----------|-------------|------------------|
| Edit/Delete products | Complete product form | View all customer orders |

## ✨ Features

### 🛍️ Customer Features
- **Authentication**: Secure login/register with Firebase Auth
  - Email/password authentication
  - Password validation (uppercase, lowercase, number, special char, min 8 chars)
  - Beautiful gradient UI
- **Browse Products**: View pizza catalog with high-quality images
- **Product Details**: 
  - Large product images
  - Nutritional information (calories, protein, fat, carbs)
  - Price with discount display
  - Vegetarian badges
  - Spice level indicators
- **Shopping Cart**: 
  - Add/remove items
  - Adjust quantities with ➕/➖ buttons
  - Real-time total calculation
  - Item count badge on cart icon
- **Checkout System**:
  - Order summary
  - Multiple payment methods:
    - 💵 Cash on Delivery
    - 💳 Mock Card Payment (for testing)
  - Delivery address input
  - Order notes
- **Order Confirmation**:
  - Success animation
  - Order ID generation
  - Delivery time estimation (30-45 minutes)
  - Order details summary
  - Order status tracking
- **Order History**: Track all previous orders with status updates
- **Search**: Find pizzas quickly
- **Responsive UI**: Optimized for different screen sizes

### 👨‍💼 Admin Features
- **Product Management**: 
  - Add new products with image upload via Cloudinary
  - Edit existing products
  - Delete products
  - Visual edit (✏️) and delete (🗑️) buttons on each product card
- **Product Form**:
  - Image picker with multiple options
  - Name, description fields
  - Category selection (VEG/Non-VEG)
  - Spice level (Mild/Medium/Spicy)
  - Pricing with discount percentage
  - Nutritional information sliders
- **Order Management**: 
  - View all customer orders
  - Order status: "Đã xác nhận" (Confirmed)
  - Order details with timestamps
  - Item count and total amount
- **Dashboard**: Quick access to all admin features via menu
- **Secure Access**: Admin-only features protected by role-based security

### 🔒 Security
- **Firestore Security Rules**: Role-based access control
  - Users can only access their own cart and orders
  - Admin users can manage all products and view all orders
  - Public read access to product catalog
  - Protected write operations
- **User Authentication**: Firebase Authentication with validation
- **Protected Routes**: Admin-only features secured
- **Data Validation**: Client and server-side validation

## 🎨 UI/UX Highlights

- **Modern Design**: Premium orange-to-beige gradient theme
- **Clean White Cards**: Professional card-based layouts
- **Smooth Animations**: 
  - Success checkmark animation
  - Fade-in transitions
  - Micro-interactions
- **Responsive**: Optimized for different screen sizes
- **Clean Architecture**: Organized codebase with BLoC pattern
- **Intuitive Navigation**: Clear user flow from browse to checkout
- **Visual Feedback**: Real-time updates, loading states, success messages
- **Accessibility**: Icons, badges, and clear labels

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: BLoC (flutter_bloc)
- **Backend Services**:
  - **Firebase Authentication**: User login/register
  - **Cloud Firestore**: NoSQL database
  - **Firebase Storage**: (Future) File storage
- **Image Management**: Cloudinary
- **Architecture**: Clean Architecture with Repository Pattern
- **Design Pattern**: BLoC Pattern for state management

## 🚀 Getting Started

### Prerequisites

```bash
# Required
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / Xcode
- Firebase account
- Cloudinary account (for image uploads)

# Check Flutter installation
flutter doctor
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/huongdq24/pizza_app.git
cd pizza_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android/iOS apps to your Firebase project
   - Download configuration files:
     - **Android**: `google-services.json`
     - **iOS**: `GoogleService-Info.plist`
   - Place files in respective directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Configure Firebase with FlutterFire CLI**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Run configuration
flutterfire configure
```

5. **Deploy Firestore Security Rules**
   - Navigate to Firestore in Firebase Console
   - Go to Rules tab
   - Copy content from `firestore.rules` file in project root
   - Publish the rules

6. **Cloudinary Setup** (Optional - for adding new products)
   - Create account at [Cloudinary](https://cloudinary.com/)
   - Update credentials in image upload configuration

### Running the App

**Debug Mode:**
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

**Release Build:**
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📐 Project Structure

```
pizza_app/
├── lib/
│   ├── main.dart               # App entry point
│   ├── app.dart                # Main app widget
│   ├── app_view.dart          # App view with routing
│   ├── app_theme.dart         # Modern UI theme (orange gradient)
│   ├── simple_bloc_observer.dart
│   ├── blocs/                 # BLoC state management
│   │   ├── authentication_bloc/
│   │   ├── cart_bloc/
│   │   └── order_bloc/
│   ├── components/            # Reusable widgets
│   │   ├── cloudinary_images.dart
│   │   └── macro.dart
│   ├── screens/               # App screens
│   │   ├── auth/             # Login/Register screens
│   │   │   ├── sign_in_screen.dart
│   │   │   ├── sign_up_screen.dart
│   │   │   └── welcome_screen.dart
│   │   ├── home/             # Product catalog
│   │   │   ├── home_screen.dart
│   │   │   ├── details_screen.dart
│   │   │   └── add_product_screen.dart
│   │   ├── cart/             # Shopping cart
│   │   │   └── cart_screen.dart
│   │   ├── checkout/         # Checkout flow
│   │   │   ├── checkout_screen.dart
│   │   │   └── order_confirmation_screen.dart
│   │   ├── orders/           # Order history
│   │   │   └── order_history_screen.dart
│   │   └── admin/            # Admin panel
│   │       ├── admin_dashboard.dart
│   │       └── products_admin_page.dart
│   └── firebase/             # Firebase configuration
│       └── firebase_options.dart
├── packages/                  # Custom packages (Clean Architecture)
│   ├── user_repository/      # User data management
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── entities/
│   │   │   │   ├── models/
│   │   │   │   └── firebase_user_repo.dart
│   │   │   └── user_repository.dart
│   │   └── pubspec.yaml
│   ├── pizza_repository/     # Product data management
│   ├── cart_repository/      # Cart data management
│   └── order_repository/     # Order data management
├── assets/                   # Images, fonts
├── android/                  # Android configuration
├── ios/                      # iOS configuration
├── web/                      # Web configuration
├── firestore.rules          # Firestore security rules
├── pubspec.yaml             # Dependencies
└── README.md                # This file
```

## 🔐 User Roles & Test Accounts

### Admin User
**Email**: `huong@gmail.com`  
**Password**: Ask repository owner

**Admin Capabilities**:
- ✅ Add/Edit/Delete products
- ✅ View all orders from all customers
- ✅ Manage product catalog
- ✅ Access admin dashboard
- ✅ View analytics (future feature)

### Regular User
**Sign up**: Create account via app

**Customer Capabilities**:
- ✅ Browse products
- ✅ Add to cart
- ✅ Place orders
- ✅ View own order history
- ✅ Search products
- ❌ Cannot access admin features

## 🗄️ Database Schema

### Firestore Collections

**users**
```javascript
{
  userId: String,          // Document ID
  email: String,
  name: String,
  isAdmin: Boolean,        // Role flag
  createdAt: Timestamp
}
```

**pizzas**
```javascript
{
  pizzaId: String,         // Unique product ID
  name: String,
  description: String,
  picture: String,         // Cloudinary URL
  price: Number,           // In cents/smallest currency unit
  discount: Number,        // Discount amount
  isVeg: Boolean,
  spicy: Number,          // 1: Mild, 2: Medium, 3: Spicy
  macros: {
    calories: Number,
    proteins: Number,
    fat: Number,
    carbs: Number
  },
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**carts**
```javascript
{
  // Document ID = userId
  userId: String,
  items: [
    {
      pizzaId: String,
      name: String,
      picture: String,
      price: Number,
      discount: Number,
      quantity: Number
    }
  ],
  updatedAt: Timestamp
}
```

**orders**
```javascript
{
  orderId: String,         // Unique order ID
  userId: String,
  items: Array<CartItem>,
  totalAmount: Number,
  deliveryAddress: String,
  notes: String,
  paymentMethod: String,   // "cash" or "card"
  status: String,          // "confirmed", "preparing", "delivered"
  createdAt: Timestamp
}
```

## 🔧 Configuration

### Firestore Security Rules

Security rules in `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function
    function isAdmin() {
      return request.auth != null && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Pizzas (products)
    match /pizzas/{pizzaId} {
      allow read: if true;  // Public read
      allow write: if isAdmin();  // Admin only
    }
    
    // Carts
    match /carts/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Orders
    match /orders/{orderId} {
      allow read: if request.auth != null && 
                     (request.auth.uid == resource.data.userId || isAdmin());
      allow create: if request.auth != null;
      allow update, delete: if isAdmin();
    }
  }
}
```

### Theme Customization

Customize app theme in `lib/app_theme.dart`:

```dart
class AppTheme {
  // Colors
  static const primaryOrange = Color(0xFFFF6B35);
  static const secondaryBeige = Color(0xFFF7F3E9);
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [secondaryBeige, primaryOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ... more customization options
}
```

## 📚 Key Dependencies

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.4
  bloc: ^8.1.4
  
  # Firebase
  firebase_core: ^2.32.0
  firebase_auth: ^4.20.0
  cloud_firestore: ^4.17.5
  
  # Image Management
  cloudinary_public: ^0.21.0
  image_picker: ^1.0.7
  
  # UI
  font_awesome_flutter: ^10.7.0
  
  # Utilities
  uuid: ^4.4.0
  intl: ^0.19.0
```

## 🎯 Features Roadmap

### ✅ Completed (v1.0)
- [x] User authentication
- [x] Product catalog
- [x] Shopping cart
- [x] Checkout system
- [x] Order management
- [x] Admin panel
- [x] Security rules
- [x] Modern UI theme

### 🚧 In Progress
- [ ] Product categories (Pizza/Snacks/Drinks)
- [ ] Real-time order status updates
- [ ] Push notifications

### 📋 Planned Features
- [ ] Payment gateway integration (Stripe/PayPal)
- [ ] Multi-language support (English/Vietnamese)
- [ ] Dark mode
- [ ] Customer reviews and ratings
- [ ] Promotional codes/Coupons
- [ ] Order tracking map
- [ ] Web admin dashboard
- [ ] Analytics dashboard
- [ ] Email notifications
- [ ] Social media login (Google, Facebook)

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards
- Follow Flutter/Dart style guide
- Use BLoC pattern for state management
- Write meaningful commit messages
- Add comments for complex logic
- Update README for new features

## 🐛 Known Issues

- Web version requires Firebase configuration (currently optimized for mobile)
- Android emulator may require clean build after major changes

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Huong DQ**
- GitHub: [@huongdq24](https://github.com/huongdq24)
- Project: [Pizza App](https://github.com/huongdq24/pizza_app)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for robust backend services
- Cloudinary for seamless image management
- BLoC library maintainers
- All contributors and testers
- Open source community

## 📞 Support

For support:
- 📧 Email: huongdq24@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/huongdq24/pizza_app/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/huongdq24/pizza_app/discussions)

## 🌟 Show Your Support

Give a ⭐️ if this project helped you!

---

**Made with ❤️ using Flutter**

© 2024 Pizza App. All rights reserved.

# 🍕 Pizza App - E-Commerce Mobile Application

A full-featured Flutter e-commerce application for ordering pizzas with an admin panel, built with Firebase backend and modern UI design.

## ✨ Features

### 🛍️ Customer Features
- **Browse Products**: View pizza catalog with images, prices, and nutritional information
- **Shopping Cart**: Add/remove items, adjust quantities
- **Checkout**: Complete order with delivery details
- **Order History**: Track all previous orders with status updates
- **Search**: Find pizzas quickly
- **Authentication**: Secure login/register with Firebase Auth

### 👨‍💼 Admin Features
- **Product Management**: Add, edit, and delete pizzas
- **Order Management**: View and manage all customer orders
- **Image Upload**: Integrate with Cloudinary for product images
- **Dashboard**: Overview of orders and products

### 🔒 Security
- **Firestore Security Rules**: Role-based access control
- **User Authentication**: Firebase Authentication
- **Protected Routes**: Admin-only features secured
- **Data Validation**: Client and server-side validation

## 🎨 UI/UX Highlights

- **Modern Design**: Premium orange gradient theme
- **Responsive**: Optimized for different screen sizes
- **Smooth Animations**: Engaging user experience
- **Clean Architecture**: Organized codebase with BLoC pattern

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: BLoC (flutter_bloc)
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage
- **Image Management**: Cloudinary
- **Architecture**: Clean Architecture with Repository Pattern

## 📱 Screenshots

_Coming soon_

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / Xcode
- Firebase account
- Cloudinary account (for image uploads)

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
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place files in respective directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Configure Firebase**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Run configuration
flutterfire configure
```

5. **Firestore Security Rules**
   - Navigate to Firestore in Firebase Console
   - Go to Rules tab
   - Copy content from `firestore.rules` file
   - Publish the rules

6. **Environment Setup**
   - Update Cloudinary credentials in relevant files
   - Configure Firebase options in `lib/firebase/firebase_options.dart`

### Running the App

**Debug Mode:**
```bash
flutter run
```

**Release Build:**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📐 Project Structure

```
pizza_app/
├── lib/
│   ├── app.dart                 # Main app widget
│   ├── app_view.dart           # App view with routing
│   ├── app_theme.dart          # Modern UI theme
│   ├── blocs/                  # BLoC state management
│   │   ├── authentication_bloc/
│   │   ├── cart_bloc/
│   │   └── order_bloc/
│   ├── components/             # Reusable widgets
│   ├── screens/                # App screens
│   │   ├── auth/              # Login/Register
│   │   ├── home/              # Product catalog
│   │   ├── cart/              # Shopping cart
│   │   ├── checkout/          # Checkout flow
│   │   ├── orders/            # Order history
│   │   └── admin/             # Admin panel
│   └── firebase/              # Firebase configuration
├── packages/                   # Custom packages
│   ├── user_repository/       # User data management
│   ├── pizza_repository/      # Product data management
│   ├── cart_repository/       # Cart data management
│   └── order_repository/      # Order data management
├── firestore.rules            # Firestore security rules
└── pubspec.yaml               # Dependencies

```

## 🔐 User Roles

### Admin User
**Email**: `huong@gmail.com`
**Features**:
- Add/Edit/Delete products
- View all orders
- Manage product catalog
- Access admin dashboard

### Regular User
**Features**:
- Browse products
- Add to cart
- Place orders
- View own order history

## 🗄️ Database Schema

### Collections

**users**
```dart
{
  userId: String,
  email: String,
  name: String,
  isAdmin: bool,
  createdAt: Timestamp
}
```

**pizzas**
```dart
{
  pizzaId: String,
  name: String,
  description: String,
  picture: String,
  price: int,
  discount: int,
  isVeg: bool,
  spicy: int,
  macros: {
    calories: int,
    proteins: int,
    fat: int,
    carbs: int
  }
}
```

**carts**
```dart
{
  userId: String (document ID),
  items: [
    {
      pizzaId: String,
      name: String,
      picture: String,
      price: int,
      discount: int,
      quantity: int
    }
  ],
  updatedAt: Timestamp
}
```

**orders**
```dart
{
  orderId: String,
  userId: String,
  items: Array,
  totalAmount: int,
  deliveryAddress: String,
  notes: String,
  status: String,
  createdAt: Timestamp
}
```

## 🔧 Configuration

### Firebase Security Rules

Security rules are defined in `firestore.rules`. Key rules:
- Users can only access their own data
- Admin users can manage all products and orders
- Public read access to product catalog
- Protected cart and order data

### Theme Customization

Modify `lib/app_theme.dart` to customize:
- Colors
- Typography
- Shadows
- Border radius
- Button styles

## 📚 Dependencies

Key packages used:
```yaml
dependencies:
  flutter_bloc: ^8.1.4          # State management
  firebase_core: ^2.32.0         # Firebase core
  firebase_auth: ^4.20.0         # Authentication
  cloud_firestore: ^4.17.5       # Database
  cloudinary_public: ^0.21.0     # Image management
  font_awesome_flutter: ^10.7.0  # Icons
  image_picker: ^1.0.7           # Image selection
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Huong DQ**
- GitHub: [@huongdq24](https://github.com/huongdq24)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Cloudinary for image management
- All contributors and testers

## 📞 Support

For support, email huongdq24@example.com or create an issue in the repository.

## 🗺️ Roadmap

- [ ] Add product categories (Snacks, Drinks)
- [ ] Implement real-time order tracking
- [ ] Push notifications
- [ ] Payment gateway integration
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Web admin dashboard
- [ ] Customer reviews and ratings
- [ ] Promotional codes system

---

**Made with ❤️ using Flutter**

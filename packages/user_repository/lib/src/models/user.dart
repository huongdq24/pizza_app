import 'package:user_repository/src/entities/user_entity.dart';

class MyUser {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  bool isAdmin; // NEW - admin role

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    this.isAdmin = false, // Default to non-admin
  });

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    hasActiveCart: false,
    isAdmin: false,
  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      hasActiveCart: hasActiveCart,
      isAdmin: isAdmin,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      hasActiveCart: entity.hasActiveCart,
      isAdmin: entity.isAdmin,
    );
  }

  @override
  String toString() {
    return 'MyUser{userId: $userId, email: $email, name: $name, hasActiveCart: $hasActiveCart, isAdmin: $isAdmin}';
  }
}

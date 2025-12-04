class MyUserEntity {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  bool isAdmin; // NEW - admin role

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    this.isAdmin = false, // Default to non-admin
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'hasActiveCart': hasActiveCart,
      'isAdmin': isAdmin,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'],
      email: doc['email'],
      name: doc['name'],
      hasActiveCart: doc['hasActiveCart'],
      isAdmin: doc['isAdmin'] ?? false, // Default false if not exists
    );
  }
}

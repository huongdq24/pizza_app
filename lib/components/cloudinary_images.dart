/// Configuration for Cloudinary pizza images
/// Maps local asset names to their corresponding Cloudinary URLs
class CloudinaryImages {
  static const Map<String, String> pizzaImages = {
    '1.png':
        'https://res.cloudinary.com/dqhgnzmtk/image/upload/v1764620778/1_muuq00.png',
    '2.png':
        'https://res.cloudinary.com/dqhgnzmtk/image/upload/v1764620779/2_ik4iub.png',
    '3.png':
        'https://res.cloudinary.com/dqhgnzmtk/image/upload/v1764620779/3_jvgjaa.png',
    '4.png':
        'https://res.cloudinary.com/dqhgnzmtk/image/upload/v1764620779/4_zukiss.png',
    '5.png':
        'https://res.cloudinary.com/dqhgnzmtk/image/upload/v1764807821/5_mcwsi6.png',
    '6.png':
        'https://res.cloudinary.com/dqhgnzmtk/image/upload/v1764620779/6_ynj5ev.png',
    '7.png':
        'https://res.cloudinary.com/dqhgnzmtk/image/upload/v1764620779/7_jwvcm6.png',
    '8.png':
        'https://res.cloudinary.com/dqhgnzmtk/image/upload/v1764620778/8_rmxith.png',
  };

  /// Get list of all available pizza image URLs
  static List<String> get allImageUrls => pizzaImages.values.toList();

  /// Get list of all image names (keys)
  static List<String> get allImageNames => pizzaImages.keys.toList();

  /// Get URL for a specific image name
  static String? getUrlForImage(String imageName) => pizzaImages[imageName];
}

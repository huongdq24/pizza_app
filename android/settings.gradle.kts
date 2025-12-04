pluginManagement {
    // Đoạn mã này tìm đường dẫn Flutter SDK trong tệp local.properties
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    // Định nghĩa các kho lưu trữ để Gradle tìm kiếm các plugins
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// Định nghĩa các plugins có sẵn cho dự án
plugins {
    // Plugin Loader của Flutter
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"

    // Plugin Android Application: Cập nhật lên phiên bản 8.1.1 (hoặc mới hơn)
    // Phiên bản 8.1.0 (như lỗi trước đó của bạn) bị coi là lỗi thời.
    // Tôi đã nâng lên 8.2.0 để tăng tính ổn định và tương thích.
    id("com.android.application") version "8.6.0" apply false
    
    // Plugin Google Services (Firebase)
    // Phiên bản 4.4.0 là mới nhất hiện tại (tháng 11/2025)
    id("com.google.gms.google-services") version "4.4.1" apply false 
    
    // Plugin Kotlin Android
    // Phiên bản 2.1.0 mà bạn dùng rất mới, tôi sẽ giữ nguyên nếu bạn đã thiết lập nó.
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

// Bao gồm module ứng dụng chính
include(":app")
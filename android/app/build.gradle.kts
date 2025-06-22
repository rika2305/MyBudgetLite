plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin
    id("dev.flutter.flutter-gradle-plugin")
    // Google services plugin (Firebase)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.flutter_application_1" // Ganti ini dengan nama unik aplikasimu
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_application_1" // Ganti ini dengan ID unik, misalnya "com.yourname.mybudgetlite"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

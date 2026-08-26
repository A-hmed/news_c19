# Upgrade Gradle and AGP for Java 25 Compatibility

The build is failing because the Gradle version (8.3) does not support the Java version (25) used by Flutter and Android Studio. The error `Unsupported class file major version 69` indicates that a Java 25 runtime is being used.

This plan upgrades the Gradle wrapper, the Android Gradle Plugin (AGP), and the Kotlin Gradle Plugin to versions that are compatible with Java 25.

## Proposed Changes

### Build Configuration

#### [MODIFY] [gradle-wrapper.properties](file:///D:/Flutter projects/course/assignment12_news_app/android/gradle/wrapper/gradle-wrapper.properties)
Update Gradle to version 9.7.1, which supports Java 25.

#### [MODIFY] [settings.gradle](file:///D:/Flutter projects/course/assignment12_news_app/android/settings.gradle)
Update Android Gradle Plugin to 9.3.1 and Kotlin Gradle Plugin to 2.4.0 to match the new Gradle version and provide better support for modern Java versions.

#### [MODIFY] [app/build.gradle](file:///D:/Flutter projects/course/assignment12_news_app/android/app/build.gradle)
Update `sourceCompatibility`, `targetCompatibility`, and `jvmTarget` to `JavaVersion.VERSION_17` (minimum required by AGP 9.x) to ensure smooth compilation.

## Verification Plan

### Manual Verification
1. Run `flutter clean` to clear previous build artifacts.
2. Run `flutter run` or `flutter build apk` to verify the build completes successfully with the new Gradle and AGP versions.

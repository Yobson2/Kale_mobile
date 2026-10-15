# Flutter-specific ProGuard rules for release builds.
#
# Reference: https://flutter.dev/to/obfuscate

# Keep Flutter engine
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep Gson (if used for JSON serialization)
-keep class com.google.gson.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep model classes (adjust package path for your app)
-keep class com.kale.app.** { *; }

# Flutter's engine references Play Core (deferred components), which this app
# does not use or bundle; without this, R8 stops the release build on the
# missing classes.
-dontwarn com.google.android.play.core.**

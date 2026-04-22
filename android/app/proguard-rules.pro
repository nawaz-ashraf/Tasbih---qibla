# Keep Flutter entry points and plugin registrants
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.embedding.**

# Keep Google Mobile Ads SDK classes
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Keep classes used via reflection by kotlinx/Android
-keepattributes *Annotation*
-keep class kotlin.Metadata { *; }

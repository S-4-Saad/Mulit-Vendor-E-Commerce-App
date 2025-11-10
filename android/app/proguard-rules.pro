# Keep BouncyCastle classes
-keep class org.bouncycastle.** { *; }
-keep interface org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# Keep Conscrypt classes
-keep class org.conscrypt.** { *; }
-keep interface org.conscrypt.** { *; }
-dontwarn org.conscrypt.**

# Keep OpenJSSE classes
-keep class org.openjsse.** { *; }
-keep interface org.openjsse.** { *; }
-dontwarn org.openjsse.**

# Keep SLF4J classes
-keep class org.slf4j.** { *; }
-keep interface org.slf4j.** { *; }
-dontwarn org.slf4j.**

# Keep JNDI related classes
-keep class javax.naming.** { *; }
-keep interface javax.naming.** { *; }
-dontwarn javax.naming.**

# Keep Java activation framework
-keep class javax.activation.** { *; }
-keep interface javax.activation.** { *; }
-dontwarn javax.activation.**

# Keep JAXB API
-keep class javax.xml.bind.** { *; }
-keep interface javax.xml.bind.** { *; }
-dontwarn javax.xml.bind.**

# Keep specific security classes
-keep class com.android.org.conscrypt.** { *; }
-keep class org.apache.harmony.xnet.provider.jsse.** { *; }
-dontwarn com.android.org.conscrypt.**
-dontwarn org.apache.harmony.xnet.provider.jsse.**

# Keep OkHttp classes
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep any native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all classes in the application
-keep class com.speezu.app.** { *; }

# Additional rules for specific missing classes
-keep class javax.naming.Binding { *; }
-keep class javax.naming.NamingEnumeration { *; }
-keep class javax.naming.NamingException { *; }
-keep class javax.naming.directory.Attribute { *; }
-keep class javax.naming.directory.Attributes { *; }
-keep class javax.naming.directory.DirContext { *; }
-keep class javax.naming.directory.InitialDirContext { *; }
-keep class javax.naming.directory.SearchControls { *; }
-keep class javax.naming.directory.SearchResult { *; }

# Ignore warnings for missing classes
-dontwarn javax.naming.**
-dontwarn javax.naming.directory.**

# Handle duplicate classes
-dontwarn javax.activation.**
-dontwarn javax.xml.bind.**
-dontwarn javax.annotation.**

# Prefer javax.activation-api over com.sun.activation
-keep class javax.activation.** { *; }
-keep interface javax.activation.** { *; }

# Exclude com.sun.activation classes as we're using the API version
-dontwarn com.sun.activation.**

# Add configuration for duplicate handling
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# If you need specific activation framework features
-keep class javax.activation.DataHandler { *; }
-keep class javax.activation.DataSource { *; }
-keep class javax.activation.FileDataSource { *; }
-keep class javax.activation.URLDataSource { *; }

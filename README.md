flutter version 3.29.1
app verson v3.3.2
app level gradle is :

plugins {
id "com.android.application"
id "kotlin-android"
id "dev.flutter.flutter-gradle-plugin"
id "com.google.gms.google-services"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
localPropertiesFile.withReader('UTF-8') { reader ->
localProperties.load(reader)
}
}

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}


android {
namespace "com.frezka.customer"
compileSdkVersion 35
ndkVersion "27.0.12077973"

    kotlinOptions {
       // jvmTarget = '1.8'
        jvmTarget = '17'
    }

    compileOptions {
        coreLibraryDesugaringEnabled true
        sourceCompatibility JavaVersion.VERSION_17 // Must match Kotlin 2.x
        targetCompatibility JavaVersion.VERSION_17
    }
    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.frezka.customer"
        minSdkVersion 23
        targetSdkVersion 34
        versionCode 20
        versionName "3.3.1"
        multiDexEnabled true
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
            proguardFiles getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro"
            minifyEnabled false // Disable R8
            shrinkResources false
        }
    }
}

flutter {
source '../..'
}

configurations.all {
resolutionStrategy {
force 'androidx.browser:browser:1.5.0'
}
}

dependencies {

    // Kotlin
    implementation "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version"

    // Fix Metadata conflict (MUST HAVE for Kotlin 2.x)
    implementation 'org.jetbrains.kotlinx:kotlinx-metadata-jvm:0.9.0' // Supports Kotlin 2.1.x

    // Firebase
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics-ktx'

    // Other deps
    implementation 'phonepe.intentsdk.android.release:IntentSDK:2.3.0'
    implementation 'com.google.android.gms:play-services-wallet:19.3.0'

    // Desugaring (Java 17 support)
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'

}


project level gradle is 

buildscript {
ext.kotlin_version = '2.1.10' // Define Kotlin version (must match settings.gradle)
repositories {
google()
mavenCentral()
}
dependencies {
classpath 'com.android.tools.build:gradle:8.4.0'
classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
classpath 'com.google.gms:google-services:4.4.1' // Latest
}
}


allprojects {
repositories {
google()
mavenCentral()
maven {
url "https://phonepe.mycloudrepo.io/public/repositories/phonepe-intentsdk-android"
}
tasks.withType(JavaCompile) {
options.compilerArgs << '-Xlint:-options'
}
}
}

rootProject.buildDir = '../build'
subprojects {
project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
delete rootProject.buildDir
}


setting.gradle is 

pluginManagement {
def flutterSdkPath = {
def properties = new Properties()
file("local.properties").withInputStream { properties.load(it) }
def flutterSdkPath = properties.getProperty("flutter.sdk")
assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
return flutterSdkPath
}()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
id "dev.flutter.flutter-plugin-loader" version "1.0.0"
//id "com.android.application" version "8.3.0" apply false
id "org.jetbrains.kotlin.android" version "2.1.10" apply false
id "com.android.application" version "8.4.0" apply false
id "com.google.gms.google-services" version "4.3.15" apply false
}

include ":app"


gradle-wrapper.properties 

distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.6-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists



proguard-rules.pro

-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
public void onPayment*(...);
}
# Fix Kotlin Metadata issues
-keep class kotlin.Metadata { *; }
-dontwarn kotlinx.metadata.**

# Keep Flutter-related classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
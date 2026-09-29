group = "ch.sbb.appbakery.oidc"
version = "1.0-SNAPSHOT"

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://pkgs.dev.azure.com/MicrosoftDeviceSDK/DuoSDK-Public/_packaging/Duo-SDK-Feed/maven/v1")
        }
    }
}

plugins {
    id("com.android.library")
}

android {
    namespace = "ch.sbb.appbakery.oidc"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
    }
}

kotlin {
    jvmToolchain(21)
}

dependencies {
    api("com.microsoft.identity.client:msal:8.5.0")
    implementation("androidx.browser:browser:1.10.0")
}

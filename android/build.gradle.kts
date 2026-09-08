group = "ch.sbb.appbakery.oidc"
version = "1.0-SNAPSHOT"

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

dependencies {
    // MSAL Android: https://github.com/AzureAD/microsoft-authentication-library-for-android
    implementation("com.microsoft.identity.client:msal:8.4.2") {
        // Avoids requiring the Duo SDK Maven feed for the unused Surface Duo dual-screen support.
        // See:
        // - https://github.com/AzureAD/microsoft-authentication-library-for-android/issues/1027
        // - https://github.com/AzureAD/microsoft-authentication-library-common-for-android/pull/2873
        exclude(group = "com.microsoft.device.display")
    }
}

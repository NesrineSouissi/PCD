buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.3.0")  // Replace with the correct version
        classpath("com.google.dagger:hilt-android-gradle-plugin:2.38.1")  // Latest version as of now
    }
}

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dagger.hilt.android.plugin")
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
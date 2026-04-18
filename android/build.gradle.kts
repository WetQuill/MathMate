import org.gradle.api.JavaVersion
import org.gradle.api.Project
import org.gradle.api.tasks.compile.JavaCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    pluginManager.withPlugin("com.android.application") {
        extensions.configure<com.android.build.api.dsl.ApplicationExtension>("android") {
            compileSdk = 36
        }
    }

    pluginManager.withPlugin("com.android.library") {
        extensions.configure<com.android.build.api.dsl.LibraryExtension>("android") {
            compileSdk = 36
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val project = this
    val fixNamespaceAction = Action<Project> {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android")
            try {
                // 使用反射尝试获取并设置 namespace
                val getNamespace = android.javaClass.getMethod("getNamespace")
                if (getNamespace.invoke(android) == null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, project.group.toString())
                }
            } catch (e: Exception) {
                // 忽略不支持 namespace 属性的旧版或非 Android 插件
            }
        }
    }

    // 核心修复：如果项目已经执行完评估，则直接运行逻辑；否则才放入回调
    if (project.state.executed) {
        fixNamespaceAction.execute(project)
    } else {
        project.afterEvaluate(fixNamespaceAction)
    }
}

fun Project.forceJvmTo18() {
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_1_8.toString()
        targetCompatibility = JavaVersion.VERSION_1_8.toString()
    }

    tasks.withType<KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_1_8)
        }
    }

    val androidExt = extensions.findByName("android")
    if (androidExt != null) {
        try {
            val compileOptions = androidExt.javaClass
                .getMethod("getCompileOptions")
                .invoke(androidExt)

            compileOptions.javaClass
                .getMethod("setSourceCompatibility", JavaVersion::class.java)
                .invoke(compileOptions, JavaVersion.VERSION_1_8)

            compileOptions.javaClass
                .getMethod("setTargetCompatibility", JavaVersion::class.java)
                .invoke(compileOptions, JavaVersion.VERSION_1_8)
        } catch (_: Exception) {
            // Ignore non-Android projects or incompatible extension APIs.
        }
    }
}

subprojects {
    val alignJvmAction: Project.() -> Unit = { forceJvmTo18() }

    if (state.executed) {
        alignJvmAction()
    } else {
        afterEvaluate { alignJvmAction() }
    }
}

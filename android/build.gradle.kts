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
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureNamespace = {
        val androidExtension = project.extensions.findByName("android")
        if (androidExtension != null) {
            val namespaceMethod = androidExtension.javaClass.getMethod("getNamespace")
            val setNamespaceMethod = androidExtension.javaClass.getMethod("setNamespace", String::class.java)
            if (namespaceMethod.invoke(androidExtension) == null) {
                setNamespaceMethod.invoke(androidExtension, project.group.toString())
            }
        }
    }

    if (project.state.executed) {
        configureNamespace()
    } else {
        project.afterEvaluate {
            configureNamespace()
        }
    }
}
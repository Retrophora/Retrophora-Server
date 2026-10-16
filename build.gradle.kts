plugins {
    kotlin("jvm") version "2.2.21"
    application
}
repositories { mavenCentral() }
kotlin { jvmToolchain(21) }
val ktorVersion = "3.3.3"
dependencies {
    implementation("io.ktor:ktor-server-core-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-netty-jvm:$ktorVersion")
    testImplementation(kotlin("test-junit5"))
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    testImplementation("io.ktor:ktor-server-test-host-jvm:$ktorVersion")
}
application { mainClass.set("org.retrophora.server.ApplicationKt") }
tasks.test { useJUnitPlatform() }

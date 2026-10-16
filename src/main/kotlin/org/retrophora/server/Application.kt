// SPDX-License-Identifier: AGPL-3.0-only
package org.retrophora.server

import io.ktor.http.ContentType
import io.ktor.server.application.Application
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty
import io.ktor.server.response.respondText
import io.ktor.server.routing.get
import io.ktor.server.routing.routing

fun Application.module() {
    routing {
        get("/v1/health") {
            call.respondText("""{"service":"retrophora-server","status":"ok"}""", ContentType.Application.Json)
        }
    }
}

fun main() {
    embeddedServer(Netty, host = "127.0.0.1", port = 8080, module = Application::module).start(wait = true)
}

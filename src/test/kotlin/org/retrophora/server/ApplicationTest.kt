// SPDX-License-Identifier: AGPL-3.0-only
package org.retrophora.server

import io.ktor.client.request.get
import io.ktor.http.HttpStatusCode
import io.ktor.server.testing.testApplication
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class ApplicationTest {
    @Test fun health() = testApplication {
        application { module() }
        val response = client.get("/v1/health")
        assertEquals(HttpStatusCode.OK, response.status)
        assertTrue(response.headers["Content-Type"]?.startsWith("application/json") == true)
    }
}

%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from pq::internal::queue
---
"queue" describedBy [
    "isValidBinomialQueue" describedBy [
        "Empty queue should be valid" in do {
            isValidBinomialQueue([]) must equalTo(true)
        },
    ],
]

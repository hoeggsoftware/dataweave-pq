%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from dw::ext::PriorityQueue
---
"PriorityQueue" describedBy [
    "isEmptyQ" describedBy [
        "It should return true when the queue is empty" in do {
            isEmptyQ(emptyQueue) must equalTo(true)
        },
        "It should return false when the queue is not empty" in do {
            isEmptyQ(insertQ(emptyQueue, 1)) must equalTo(false)
        },
    ],
]

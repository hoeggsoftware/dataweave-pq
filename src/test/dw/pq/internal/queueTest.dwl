%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from pq::internal::queue
---
"queue" describedBy [
    do {
        var treeR0 = {
            data: "example rank 0",
            rank: 0,
            children: []
        }
        var treeR1 = {
            data: "example rank 1",
            rank: 1,
            children: [treeR0]
        }
        var treeR2 = {
            data: "example rank 2",
            rank: 2,
            children: [
                treeR1,
                {
                    data: "leaf node in treeR2",
                    rank: 0,
                    children: []
                }
            ]
        }
        ---
        "isValidBinomialQueue" describedBy [
            "Empty should be valid" in do {
                isValidBinomialQueue([]) must equalTo(true)
            },
            "Single null should be valid" in do {
                isValidBinomialQueue([null]) must equalTo(true)
            },
            "Single rank 0 tree should be valid" in do {
                isValidBinomialQueue([treeR0]) must equalTo(true)
            },
            "Rank 0 tree in position 1 should not be valid" in do {
                isValidBinomialQueue([null, treeR0]) must equalTo(false)
            },
            "Rank 1 tree in position 0 should not be valid" in do {
                isValidBinomialQueue([treeR1]) must equalTo(false)
            },
            "Rank 2 tree in position 2 should be valid" in do {
                isValidBinomialQueue([null, null, treeR2]) must equalTo(true)
            },
            "all three trees should be valid" in do {
                isValidBinomialQueue([treeR0, treeR1, treeR2]) must equalTo(true)
            },
            "all three trees out of order should not be valid" in do {
                isValidBinomialQueue([treeR0, treeR2, treeR1]) must equalTo(false)
            }
        ]
    }
]

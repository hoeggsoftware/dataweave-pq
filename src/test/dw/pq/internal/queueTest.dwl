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
            "Single rank 0 tree should be valid" in do {
                isValidBinomialQueue([treeR0]) must equalTo(true)
            },
            "Rank 0 tree in position 1 should not be valid" in do {
                isValidBinomialQueue([treeR0, treeR0]) must equalTo(false)
            },
            "Rank 1 tree in position 0 should not be valid" in do {
                isValidBinomialQueue([treeR1]) must equalTo(false)
            },
            "all three trees should be valid" in do {
                isValidBinomialQueue([treeR0, treeR1, treeR2]) must equalTo(true)
            },
            "all three trees out of order should not be valid" in do {
                isValidBinomialQueue([treeR0, treeR2, treeR1]) must equalTo(false)
            }
        ]
    },
    do {
        var t1r0 = {
            data: 1000,
            rank: 0,
            children: []
        }
        var t2r0 = {
            data: 200,
            rank: 0,
            children: []
        }
        var t1r1 = {
            data: 500,
            rank: 1,
            children: [
                {
                    data: 4000,
                    rank: 0,
                    children: []
                }
            ]
        }
        var t2r1 = {
            data: 250,
            rank: 1,
            children: [
                {
                    data: 777,
                    rank: 0,
                    children: []
                }
            ]
        }
        var t1r2 = {
            data: 1500,
            rank: 2,
            children: [
                {
                    data: 2500,
                    rank: 1,
                    children: [
                        {
                            data: 3500,
                            rank: 0,
                            children: []
                        }
                    ]
                },
                {
                    data: 3000,
                    rank: 0,
                    children: []
                }
            ]
        }
        ---
        /** ins expects the tree rank to be <= the lowest tree rank in the queue */
        "ins" describedBy [
            "It should insert a rank 0 tree into an empty queue" in do {
                ins(t1r0, []) must equalTo([t1r0])
            },
            "It should insert a rank 0 tree into a queue with one rank 1 tree" in do {
                ins(t1r0, [t1r1]) must equalTo([t1r0, t1r1])
            },
            "It should insert a rank 1 tree into a queue with one rank 1 tree" in do {
                ins(t1r1, [t2r1]) must equalTo([{
                    data: 250,
                    rank: 2,
                    children: [
                        t1r1,
                        {
                            data: 777,
                            rank: 0,
                            children: []
                        }
                    ]
                }])
            },
            "It should insert a rank 0 tree into a longer queue with a rank 0 tree" in do {
                ins(t1r0, [t2r0, t1r1]) must equalTo([{
                    data: t2r0.data,
                    rank: 2,
                    children: [
                        t1r1,
                        t1r0
                    ]
                }])
            },
            "It should insert a rank 0 tree into queue with a rank 0 and a rank 2 tree" in do {
                ins(t1r0, [t2r0, t1r2]) must equalTo([{
                    data: t2r0.data,
                    rank: 1,
                    children: [
                        {
                            data: t1r0.data,
                            rank: 0,
                            children: []
                        }
                    ]
                }, t1r2])
            }
        ]
    },
]

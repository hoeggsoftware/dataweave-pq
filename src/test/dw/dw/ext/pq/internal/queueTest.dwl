%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from dw::ext::pq::Types
import * from dw::ext::pq::internal::tree
import * from dw::ext::pq::internal::queue

fun coerceCriteria(data: Any) = data as Comparable

fun queueContents(q: BinomialQueue, prefix: Array = []): Array = do {
    var next = findMinBy(q, coerceCriteria)
    ---
    if (next == null) prefix
    else  queueContents(deleteMinBy(q, coerceCriteria), (prefix << next))
}

var t1r0 = newTree(1000)
var t2r0 = newTree(200)

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
var t3r1 = {
    data: 1,
    rank: 1,
    children: [
        {
            data: 10,
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
var t2r2 = {
    data: 808,
    rank: 2,
    children: [
        {
            data: 909,
            rank: 1,
            children: [ newTree(1010) ]
        },
        newTree(2020)
    ]
}
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
    /** ins expects the tree rank to be <= the lowest tree rank in the queue */
    "insBy" describedBy [
        "It should insert a rank 0 tree into an empty queue" in do {
            insBy(t1r0, [], coerceCriteria) must equalTo([t1r0])
        },
        "It should insert a rank 0 tree into a queue with one rank 1 tree" in do {
            insBy(t1r0, [t1r1], coerceCriteria) must equalTo([t1r0, t1r1])
        },
        "It should insert a rank 1 tree into a queue with one rank 1 tree" in do {
            insBy(t1r1, [t2r1], coerceCriteria) must equalTo([{
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
            insBy(t1r0, [t2r0, t1r1], coerceCriteria) must equalTo([{
                data: t2r0.data,
                rank: 2,
                children: [
                    t1r1,
                    t1r0
                ]
            }])
        },
        "It should insert a rank 0 tree into queue with a rank 0 and a rank 2 tree" in do {
            insBy(t1r0, [t2r0, t1r2], coerceCriteria) must equalTo([{
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
    ],
    "meldBy" describedBy [
        "It should meld two empty queues into one empty queue" in do {
            meldBy([], [], coerceCriteria) must beEmpty()
        },
        "It should meld a queue with an empty queue" in do {
            meldBy([t1r0, t1r1], [], coerceCriteria) must equalTo([t1r0, t1r1])
        },
        "It should meld an empty queue with a queue" in do {
            meldBy([], [t2r0, t1r1], coerceCriteria) must equalTo([t2r0, t1r1])
        },
        "It should prepend a single lower rank tree to a queue with only higher ranks" in do {
            meldBy([t1r0], [t1r1, t1r2], coerceCriteria) must equalTo([t1r0, t1r1, t1r2])
        },
        "It should produce a valid queue with trees sorted by ranks from each of the inputs" in do {
            meldBy([t1r0, t1r2], [t1r1], coerceCriteria) must equalTo([t1r0, t1r1, t1r2])
        },
        "It should produce a valid queue when each input has the same lowest rank" in do {
            meldBy([t1r0, t1r2], [t2r0, t1r1], coerceCriteria) must equalTo([{
                data: 200,
                rank: 3,
                children: [
                    t1r2,
                    t1r1,
                    t1r0
                ]
            }])
        },
    ],
    "skewMeldBy" describedBy [
        "It should produce a valid skew binomial queue when one has two of the same rank" in do {
            skewMeldBy([newTree(0), t1r0, t1r1], [t2r0, t2r1], coerceCriteria) must equalTo([
                t2r0,
                t2r1,
                {
                    data: 0,
                    rank: 2,
                    children: [
                        t1r1,
                        t1r0
                    ]
                }
            ])
        },
        "it should produce a valid skew binomial queue when both have two of the same rank" in do {
            skewMeldBy([newTree(0), t1r1, t1r2], [t2r1, t3r1, t2r2], coerceCriteria) must equalTo([
                newTree(0),
                t1r1,
                t1r2,
                {
                    data: 1, // t3r1
                    rank: 3,
                    children: [
                        t2r2,
                        t2r1,
                        newTree(10) // t3r1 original child
                    ]
                }
            ])
        },
    ],
    "findMinBy" describedBy [
        "It should return null for an empty queue" in do {
            findMinBy([], coerceCriteria) must beNull()
        },
        "it should return the value of the only member" in do {
            findMinBy([t1r0], coerceCriteria) must equalTo(t1r0.data)
        },
        "It should give the smallest value of a root" in do {
            findMinBy([t1r0, t1r1, t1r2], coerceCriteria) must equalTo(t1r1.data)
        },
    ],
    "deleteMinBy" describedBy [
        "It should do nothing for an empty queue" in do {
            deleteMinBy([], coerceCriteria) must beEmpty()
        },
        "It should produce empty queue for a single node" in do {
            deleteMinBy([t1r0], coerceCriteria) must beEmpty()
        },
        "It should return queue without the smallest node when it's rank 0" in do {
            deleteMinBy([t2r0, t1r1], coerceCriteria) must equalTo([t1r1])
        },
        "It should return queue without the minimum when it's not the lowest rank root" in do {
            deleteMinBy([t1r0, t1r1, t1r2], coerceCriteria) must equalTo([{
                data: t1r0.data,
                rank: 1,
                children: [
                    {
                        data: 4000,
                        rank: 0,
                        children: []
                    }
                ]
            },t1r2])
        }
    ],
    do {
    var smallSkewQ = [newTree(0), newTree(1)]
    ---
    "skewInsertBy" describedBy [
        "It should make two rank 0 trees after two skewInsertBys" in do {
            var twoInsertQ = [1, 0] reduce (n, q = []) -> skewInsertBy(n, q, coerceCriteria)
            ---
            twoInsertQ must equalTo(smallSkewQ)
        },
        "It should skew link when inserting into queue with two rank 0 trees" in do {
            skewInsertBy(2, smallSkewQ, coerceCriteria) must equalTo([
                {
                    data: 0,
                    rank: 1,
                    children: [newTree(2), newTree(1)] // this is not a valid binomial tree! but it is a skew binomial tree
                }
            ])
        },
        "It should use type B skew when inserting into queue with smallest node in higher rank tree" in do {
            var q = [t1r1, t3r1] // t3r1 data is very small data
            ---
            skewInsertBy(10000, q, coerceCriteria) must equalTo([{
                data: t3r1.data,
                rank: 2,
                children: [newTree(10000), t1r1] ++ t3r1.children
            }])
        },
        // this is such a cool consequence of the algorithm. See illustration in ExampleQueueMapping field ranks.
        "It should produce a queue with trees whose ranks make a skew binomial number" in do {
            var insertCount = randomInt(500)
            var skewQueue = (1 to insertCount) reduce (n, q: BinomialQueue = []) ->
                skewInsertBy(n, q, coerceCriteria)
            var ranks = (0 to 8) map (rank) -> sizeOf(skewQueue filter (t) -> t.rank == rank)
            var skewBinaryValue = sum(ranks map (count, index) -> do {
                var digitValue = (2 pow (index + 1)) - 1
                ---
                count * digitValue
            })
            ---
            skewBinaryValue must equalTo(insertCount)
        }
    ]},
    "skewDeleteMinBy" describedBy [
        "It should delete only item in a unit queue" in do {
            skewDeleteMinBy([newTree(4)], coerceCriteria) must equalTo([])
        },
        "It should delete smallest from a simple queue" in do {
            skewDeleteMinBy([newTree(1), newTree(0)], coerceCriteria) must equalTo([newTree(1)])
        },
        "It should delete when a high rank tree needs to be split" in do {
            var sevenQ = (1 to 7) reduce (n, q=[]) -> skewInsertBy(n, q, coerceCriteria)
            ---
            queueContents(skewDeleteMinBy(sevenQ, coerceCriteria)) must equalTo([2, 3, 4, 5, 6, 7])
        },
        "It should produce the same tree when inserting and then deleting the smallest value" in do {
            var moderatelySizedQ = (0 to 200) reduce (n, q:BinomialQueue = []) ->
                skewInsertBy(randomInt(1000), q, coerceCriteria)
            var originalContents = queueContents(moderatelySizedQ)
            var afterInsertingSmallest = skewInsertBy(-1, moderatelySizedQ, coerceCriteria)
            // this test is slower because of the conversions back to array for comparison
            ---
            queueContents(skewDeleteMinBy(afterInsertingSmallest, coerceCriteria)) must equalTo(originalContents)
        },
        "It should delete the smallest after many other inserts" in do {
            // 10 numbers >= 100
            var startQ = (1 to 10) reduce (n, q=[]) -> 
                skewInsertBy(randomInt(100) + 100, q, coerceCriteria)
            // smallest
            var newSmallestQ = skewInsertBy(-1, startQ, coerceCriteria)
            // next smallest so we can check after deleting smallest
            var withCheckValueQ = skewInsertBy(0, newSmallestQ, coerceCriteria)
            // 20 numbers >= 100
            var moreInsertsQ = (1 to 20) reduce (n, q=withCheckValueQ) ->
                skewInsertBy(randomInt(100) + 100, q, coerceCriteria)
            // after deleting smallest
            var testQ = deleteMinBy(moreInsertsQ, coerceCriteria)
            ---
            findMinBy(testQ, coerceCriteria) must equalTo(0)
        }
    ],
]

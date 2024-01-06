%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from dw::ext::pq::internal::queue

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
        }
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
]
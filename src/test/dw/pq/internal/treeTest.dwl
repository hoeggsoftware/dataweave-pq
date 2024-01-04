%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from pq::internal::tree
---
"tree" describedBy [
    "isValidBinomialTree" describedBy [
        "Single node should be valid" in do {
            isValidBinomialTree({data: 0, rank: 0, children: []}) must equalTo(true)
        },
        "Single node should be rank 0" in do {
            isValidBinomialTree({data: 1, rank: 0, children: []}, 0) must equalTo(true)
        },
        "Single node should not be rank 1" in do {
            isValidBinomialTree({data: 2, rank: 0, children: []}, 1) must equalTo(false)
        },
        "Rank 1 should be valid" in do {
            var tree = {
                data: "top",
                rank: 1,
                children: [
                    {
                        data: "bottom",
                        rank: 0,
                        children: []
                    }
                ]
            }
            ---
            isValidBinomialTree(tree) must equalTo(true)
        },
        "Rank 1 tree should be rank 1" in do {
            var tree = {
                data: "top",
                rank: 1,
                children: [
                    {
                        data: "bottom",
                        rank: 0,
                        children: []
                    }
                ]
            }
            ---
            isValidBinomialTree(tree, 1) must equalTo(true)
        },
        "Deformed rank 1 should not be valid" in do {
            var tree = {
                data: "beanstalk tip",
                rank: 1,
                children: [
                    {
                        data: "beanstalk middle",
                        rank: 0,
                        children: [
                            {
                                data: "beanstalk base",
                                rank: 0,
                                children: []
                            }
                        ]
                    }
                ]
            }
            ---
            isValidBinomialTree(tree) must equalTo(false)
        },
        "Rank 2 should be valid" in do {
            var tree = {
                data: "rank 2 tree",
                rank: 2,
                children: [
                    {
                        data: "rank 1 tree",
                        rank: 1,
                        children: [
                            {
                                data: "left hand rank 0 tree",
                                rank: 0,
                                children: []
                            }
                        ]
                    },
                    {
                        data: "right hand rank 0 tree",
                        rank: 0,
                        children: []
                    }
                ]
            }
            ---
            isValidBinomialTree(tree) must equalTo(true)
        }
    ],
]

/*
   Copyright 2024 Ryan Hoegg

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 */
 
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
    do {
        var t1R0 = newTree(1)
        var t2R0 = newTree(3)
        var t1R1 = {
            data: 0,
            rank: 1,
            children: [
                newTree(4)
            ]
        }
        var t2R1 = {
            data: 2,
            rank: 1,
            children: [
                newTree(100)
            ]
        }
        ---
        "link" describedBy [
            "It should link rank 0 trees when smaller is first" in do {
                link(t1R0, t2R0) must equalTo({
                    data: 1,
                    rank: 1,
                    children: [
                        newTree(3)
                    ]
                })
            },
            "It should link rank 0 trees when larger is first" in do {
                link(t2R0, t1R0) must equalTo({
                    data: 1,
                    rank: 1,
                    children: [
                        newTree(3)
                    ]
                })            
            },
            "It should link rank 1 trees when smaller is first" in do {
                link(t1R1, t2R1) must equalTo({
                    data: 0,
                    rank: 2,
                    children: [
                        {
                            data: 2,
                            rank: 1,
                            children: [
                                newTree(100)
                            ]
                        },
                        newTree(4)
                    ]
                })
            },
        ]
    },
    do {
        var t1R1 = {
            data: {someField: 4},
            rank: 1,
            children: [
                newTree({someField: 3})
            ]
        }
        var t2R1 = {
            data: {someField: 100},
            rank: 1,
            children: [
                newTree({someField: 5})
            ]
        }
        ---
        "linkBy" describedBy [
            "It should link trees using criteria" in do {
                linkBy(t1R1, t2R1, (value) -> (-1 * value.someField)) must equalTo({
                    data: {someField: 100},
                    rank: 2,
                    children: [
                        t1R1,
                        newTree({someField: 5})
                    ]
                })
            },
        ]
    }
]

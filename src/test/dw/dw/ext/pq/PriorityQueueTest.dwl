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

import * from dw::ext::pq::PriorityQueue
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

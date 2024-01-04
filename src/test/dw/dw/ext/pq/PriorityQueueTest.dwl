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

    "init" describedBy [
        "It should accept a criteria for ordering" in do {
          var values = ["MONDAY", "Tuesday", "wednesday", "thursday", "fRiDaY", "SATURDAY", "Sunday"]
            map (value, index) -> { name: value, inserted: index }          var pq = init((data) -> lower(data.name))
          var afterInserts = values reduce (value, pq = pq) ->
            pq insert value
          var firstItem = next(afterInserts)
          var firstDropped = deleteNext(afterInserts)
          var secondItem = next(firstDropped)
          var firstTwo = {
            first: firstItem,
            second: secondItem
          }
          ---
          firstTwo must equalTo({
            first: {
              name: "fRiDaY",
              inserted: 4
            },
            second: {
              name: "MONDAY",
              inserted: 0
            }
          })
        },
    ],
]

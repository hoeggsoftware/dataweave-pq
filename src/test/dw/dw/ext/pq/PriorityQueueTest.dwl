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

fun queueContents<T>(q: PriorityQueue<T>, prefix: Array<T> = []): Array<T> = do {
    var min = next(q)
    ---
    if (min == null) prefix
    else queueContents(deleteNext(q), (prefix << min))
}

type Node = {
  value: Number,
  otherData: Array<String>
}
var words = ["potato", "dataweave", "mule", "functional", "Mariano", "Ryan", "coffee", "tea", "Dijkstra", "github", "Oklahoma", "Argentina", "binomial", "skew"]

var nodeCriteria = (node: Node) -> node.value

fun randomNode(): Node =
  {
    value: random() * 10000,
    otherData: (3 to (randomInt(21) + 3)) map (i) -> words[randomInt(sizeOf(words))]
  }
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
    do { 
      var sizes = (1 to 200) ++ [250,400,600,1000,10000]
      var queues = sizes map (queueSize) -> do {
        var minPosition = randomInt(queueSize)
        var minNode = {
          value: -1,
          otherData: ["this", "is", "the", "minimum", "node"]
        }
        var nodes = (1 to queueSize) map (i, index) -> 
          if (index == minPosition) minNode else randomNode()
        var checkQueue = nodes reduce (node, q=init(nodeCriteria)) ->
          (q insert node)
        ---
        {
          queueSize: queueSize,
          minNode: minNode,
          remaining: nodes - minNode,
          q: checkQueue,
          qNext: next(checkQueue),
          qRemaining: queueContents(deleteNext(checkQueue))
        }
      }
      ---
      "correctness checks" describedBy [
        "It should find the minimum element for many different queue sizes" in do {
          (queues map (q) -> q.minNode) must equalTo(
            queues map (q) -> q.qNext)
        },
        "It should delete only one element for many different queue sizes" in do {
            (queues map (q) -> (sizeOf(q.remaining))) must equalTo(
              queues map (q) -> (sizeOf(q.qRemaining)))
        }
    ]
  }
]

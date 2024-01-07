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
output application/json

import * from dw::ext::pq::PriorityQueue
import * from dw::ext::pq::internal::tree
import * from dw::ext::pq::Types
import * from dw::util::Timer


fun queueContents<T>(q: PriorityQueue<T>, prefix: Array<T> = []): Array<T> = do {
    var min = next(q)
    ---
    if (min == null) prefix
    else  queueContents(deleteNext(q), (prefix << min))
}

var values = ["MONDAY", "Tuesday", "wednesday", "tHuRsDaY", "friday", "SATURDAY", "Sunday"]
  map (value, index) -> { name: value, inserted: index }
var pq = init((data) -> lower(data.name))
var afterInserts = values reduce (value, pq = pq) ->
  pq insert value

var oneMoreInsert = afterInserts insert { name: "Someday", inserted: 1000000 }



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

var queueChecks = do {
  var queues = ([1000, 8888, 33333, 75000, 200000]) map (queueSize) -> do {
    var minPosition = randomInt(queueSize)
    var minNode = {
      value: -1,
      otherData: ["this", "is", "the", "minimum", "node"]
    }
    var nodes = (1 to queueSize) map (i, index) -> 
      if (index == minPosition) minNode else randomNode()
    var insertStep = duration(() -> (nodes reduce (node, q=init(nodeCriteria)) ->
      (q insert node)))
    var checkQueue = insertStep.result
    ---
    {
      queueSize: queueSize,
      insertTime: insertStep.time,
      minNode: minNode,
      arrayDeleteExecutionTime: duration(() -> (nodes - minNode)).time,
      q: checkQueue,
      qNext: duration(() -> next(checkQueue)),
      qDeleteExecutionTime: duration(() -> deleteNext(checkQueue)).time
    }
  }
  ---
  queues map (q) -> q - "q"
}
---
{
  next: next(afterInserts),
  afterInserts: afterInserts.queue,
  nextNext: next(deleteNext(afterInserts)),
  queueChecks: queueChecks,
  plainArray: [1000, 8888, 33333, 75000, 200000] map (arraySize) -> {
    arraySize: arraySize,
    insertTime: duration(() -> (1 to arraySize) reduce (n, a=[]) -> n >> a).time
  }
}

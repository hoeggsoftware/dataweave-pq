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

import * from dw::ext::pq::Types
import * from pq::internal::queue
import * from pq::internal::tree

type PriorityQueue<T> = {
  queue: BinomialQueue,
  criteria: Criteria<T>
}

fun init<T>(criteria: Criteria<T>): PriorityQueue<T> = {
  queue: [],
  criteria: criteria
}

fun insert<T>(q: PriorityQueue, data: T): PriorityQueue<T> = {
  queue: insBy(newTree(data), q.queue, q.criteria),
  criteria: q.criteria
}

fun next<T>(q: PriorityQueue<T>): T | Null =
  q.queue findMinBy q.criteria

fun deleteNext<T>(q: PriorityQueue<T>): PriorityQueue<T> = {
  queue: deleteMinBy(q.queue, q.criteria),
  criteria: q.criteria
}
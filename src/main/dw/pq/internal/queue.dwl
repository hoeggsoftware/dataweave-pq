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

import * from dw::core::Arrays
import * from dw::ext::pq::Types
import * from pq::internal::tree

fun isValidBinomialQueueRoot(t: BinomialTree, index: Number) = isValidBinomialTree(t, index)

fun isValidBinomialQueue(q: BinomialQueue): Boolean = 
  (q map (t, index) -> isValidBinomialQueueRoot(t, index)) every $

@Internal(permits = ["pq::"])
fun ins(t: BinomialTree, q: BinomialQueue): BinomialQueue =
  if(isEmpty(q)) [t]
  else if (t.rank < q[0].rank) t >> q
  else ins(link(t, q[0]), q drop 1)

fun meld(q1: BinomialQueue, q2: BinomialQueue): BinomialQueue =
  if (isEmpty(q1)) q2
  else if (isEmpty(q2)) q1
  else if (q1[0].rank == q2[0].rank)
    ins(link(q1[0], q2[0]), meld(q1 drop 1, q2 drop 1))
  else if (q1[0].rank < q2[0].rank)
    q1[0] >> meld(q1 drop 1, q2)
  else meld(q2, q1)

fun findMin(q: BinomialQueue) =
  if (isEmpty(q)) null
  else min(q map $.data)
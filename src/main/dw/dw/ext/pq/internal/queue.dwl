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
import * from dw::ext::pq::internal::tree

@Internal(permits = ["dw::ext::pq::internal"])
fun isValidBinomialQueueRoot(t: BinomialTree, index: Number) = isValidBinomialTree(t, index)

@Internal(permits = ["dw::ext::pq::internal"])
fun isValidBinomialQueue(q: BinomialQueue): Boolean = 
  (q map (t, index) -> isValidBinomialQueueRoot(t, index)) every $

@Internal(permits = ["dw::ext::pq::internal", "dw::ext::pq"])
fun insBy(t: BinomialTree, q: BinomialQueue, criteria: Criteria): BinomialQueue =
  if(isEmpty(q)) [t]
  else if (t.rank < q[0].rank) t >> q
  else insBy(linkBy(t, q[0], criteria), q drop 1, criteria)

@Internal(permits = ["dw::ext::pq::internal", "dw::ext::pq"])
fun meldBy(q1: BinomialQueue, q2: BinomialQueue, criteria: Criteria, transform: (q: BinomialQueue) -> BinomialQueue = (q) -> q): BinomialQueue = do {
  var tq1 = transform(q1)
  var tq2 = transform(q2)
  ---
  if (isEmpty(tq1)) tq2
  else if (isEmpty(tq2)) tq1
  else if (tq1[0].rank == tq2[0].rank)
    insBy(linkBy(tq1[0], tq2[0], criteria), meldBy(tq1 drop 1, tq2 drop 1, criteria, transform), criteria)
  else if (tq1[0].rank < tq2[0].rank)
    tq1[0] >> meldBy(tq1 drop 1, tq2, criteria, transform)
  else meldBy(tq2, tq1, criteria)
}

@Internal(permits = ["dw::ext::pq::internal", "dw::ext::pq"])
fun skewMeldBy(q1: BinomialQueue, q2: BinomialQueue, criteria: Criteria): BinomialQueue = do {
  fun eliminateLeadingDuplicate(q: BinomialQueue): BinomialQueue =
    if (isEmpty(q)) q else insBy(q[0], q drop 1, criteria)
  ---
  meldBy(q1, q2, criteria, eliminateLeadingDuplicate)
}

@Internal(permits = ["dw::ext::pq::internal", "dw::ext::pq"])
fun findMinBy<T>(q: BinomialQueue, criteria: Criteria): T | Null =
  if (isEmpty(q)) null
  else(q minBy (t) -> criteria(t.data)).data as T

@Internal(permits = ["dw::ext::pq::internal", "dw::ext::pq"])
fun deleteMinBy(q: BinomialQueue, criteria: Criteria): BinomialQueue = do {
  var sorted = q orderBy (t) -> (criteria(t.data))
  var minTree = sorted[0]
  var remaining = sorted drop 1
  ---
  meldBy(minTree.children[-1 to 0] default [], remaining, criteria)
}
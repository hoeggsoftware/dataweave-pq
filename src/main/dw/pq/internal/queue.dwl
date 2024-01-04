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

type Criteria<T> = (data: T) -> Comparable

@Internal(permits = ["pq::"])
fun coerceCriteria(data: Any) = data as Comparable

@Internal(permits = ["pq::"])
fun isValidBinomialQueueRoot(t: BinomialTree, index: Number) = isValidBinomialTree(t, index)

@Internal(permits = ["pq::"])
fun isValidBinomialQueue(q: BinomialQueue): Boolean = 
  (q map (t, index) -> isValidBinomialQueueRoot(t, index)) every $

@Internal(permits = ["pq::", "dw::ext::pq"])
fun insBy(t: BinomialTree, q: BinomialQueue, criteria: Criteria): BinomialQueue =
  if(isEmpty(q)) [t]
  else if (t.rank < q[0].rank) t >> q
  else insBy(linkBy(t, q[0], criteria), q drop 1, criteria)

@Internal(permits = ["pq::", "dw::ext::pq"])
fun meldBy(q1: BinomialQueue, q2: BinomialQueue, criteria: Criteria): BinomialQueue =
  if (isEmpty(q1)) q2
  else if (isEmpty(q2)) q1
  else if (q1[0].rank == q2[0].rank)
    insBy(linkBy(q1[0], q2[0], criteria), meldBy(q1 drop 1, q2 drop 1, criteria), coerceCriteria)
  else if (q1[0].rank < q2[0].rank)
    q1[0] >> meldBy(q1 drop 1, q2, criteria)
  else meldBy(q2, q1, criteria)

@Internal(permits = ["pq::", "dw::ext::pq"])
fun findMinBy<T>(q: BinomialQueue, criteria: Criteria): T | Null =
  if (isEmpty(q)) null
  else(q minBy (t) -> criteria(t.data)).data as T

@Internal(permits = ["pq::", "dw::ext::pq"])
fun deleteMinBy(q: BinomialQueue, criteria: Criteria): BinomialQueue = do {
  var sorted = q orderBy (t) -> (criteria(t.data))
  var minTree = sorted[0]
  var remaining = sorted drop 1
  ---
  meldBy(minTree.children[-1 to 0] default [], remaining, criteria)
}
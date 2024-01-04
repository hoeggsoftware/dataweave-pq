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

fun ins(t: BinomialTree, q: BinomialQueue): BinomialQueue =
  if(isEmpty(q)) [t]
  else if (t.rank < q[0].rank) t >> q
  else ins(link(t, q[0]), q[1 to -1])
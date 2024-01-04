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

fun newTree(value): BinomialTree = {
    data: value,
    rank: 0,
    children: []
}

fun isValidBinomialTree(tree: BinomialTree, rank: Number = -1): Boolean = do {
    var rankToCheck = if (rank == -1) tree.rank else rank
    ---
    if (rankToCheck == 0) isEmpty(tree.children)
    else (rankToCheck == sizeOf(tree.children)) and (
        (tree.children[-1 to 0] map (child, index) -> isValidBinomialTree(child, index))
            every $
    )
}

fun link(t1:BinomialTree, t2: BinomialTree): BinomialTree =
    if (t1.data > t2.data) link(t2, t1)
    else {
        data: t1.data,
        rank: t1.rank + 1,
        children: t2 >> t1.children
    }
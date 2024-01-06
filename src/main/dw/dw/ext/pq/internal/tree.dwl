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

@Internal(permits = ["dw::ext::pq::internal", "dw::ext::pq"])
fun newTree<T>(value: T): BinomialTree = {
    data: value,
    rank: 0,
    children: []
}

@Internal(permits = ["dw::ext::pq::internal"])
fun isValidBinomialTree(tree: BinomialTree, rank: Number = -1): Boolean = do {
    var rankToCheck = if (rank == -1) tree.rank else rank
    ---
    if (rankToCheck == 0) isEmpty(tree.children)
    else (rankToCheck == sizeOf(tree.children)) and (
        (tree.children[-1 to 0] map (child, index) -> isValidBinomialTree(child, index))
            every $
    )
}

@Internal(permits=["dw::ext::pq::internal"])
fun linkBy<T>(t1:BinomialTree, t2: BinomialTree, criteria: Criteria): BinomialTree = do {
    if (criteria(t1.data) > criteria(t2.data)) linkBy(t2, t1, criteria)
    else {
        data: t1.data,
        rank: t1.rank + 1,
        children: t2 >> t1.children
    }
}

/*
 * Expects one of the trees to be rank 0, and the other two to have the same rank.
 * Uses a Type A link when the rank 0 tree is the minimum value, or a Type B link otherwise
 */
 @Internal(permits=["dw::ext::pq::internal"])
fun skewLinkBy<T>(t1: BinomialTree, t2: BinomialTree, t3: BinomialTree, criteria: Criteria): BinomialTree = do {
    var dataOrdered = [t1, t2, t3] orderBy (t) -> criteria(t.data)
    var root = dataOrdered[0] // if this is the 
    var children = dataOrdered drop 1 orderBy (t) -> t.rank
    var rank = (if (t1.rank > t2.rank) t1.rank else t2.rank) + 1
    // not considering t3 rank because only one rank should be 0, and the other two should match
    ---
    {
        data: root.data,
        rank: rank,
        children: children ++ root.children
    }
}

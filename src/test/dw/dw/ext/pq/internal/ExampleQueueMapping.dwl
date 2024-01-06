%dw 2.5
import * from dw::ext::pq::Types
import * from dw::ext::pq::internal::tree
import * from dw::ext::pq::internal::queue
output application/json

fun coerceCriteria(data: Any) = data as Comparable

var smallSkewQueue =  [newTree(0), newTree(1)]
var largeQueue = (1 to 500) reduce (n, q: BinomialQueue = []) ->
    skewInsertBy(randomInt(5000), q, coerceCriteria)
var sevenInserts = (1 to 7) reduce (n, q = []) -> skewInsertBy(n, q, coerceCriteria)
---
{
  delete: skewDeleteMinBy([newTree(1), newTree(0)], coerceCriteria),
  threeTree: skewLinkBy(newTree(0), newTree(1), newTree(2), coerceCriteria),
  threeQ: skewInsertBy(2, smallSkewQueue, coerceCriteria),
  oneHundredQ: (1 to 100) reduce (n, q: BinomialQueue = []) ->
    skewInsertBy(n, q, coerceCriteria), // skew binomial number of ranks = 020011 = 6 + 31 + 63 = 100
  ranks: ((0 to 9) map (rank) -> sizeOf(largeQueue filter (t) -> t.rank == rank)) map (treeCount, index) -> do {
    var digitValue = (2 pow (index + 1)) - 1
    var skewBinaryValue = treeCount * digitValue
    ---
    {
        digitPosition: index,
        treeCountByRank: treeCount,
        skewBinaryValue: skewBinaryValue
    }
  },
}

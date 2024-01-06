%dw 2.5
import * from dw::ext::pq::Types
import * from dw::ext::pq::internal::tree
import * from dw::ext::pq::internal::queue
output application/json

fun coerceCriteria(data: Any) = data as Comparable

var smallSkewQueue =  [newTree(0), newTree(1)]
var largeQueue = (1 to 500) reduce (n, q: BinomialQueue = []) ->
    skewInsertBy(randomInt(5000), q, coerceCriteria)
---
{
  threeTree: skewLinkBy(newTree(0), newTree(1), newTree(2), coerceCriteria),
  threeQ: skewInsertBy(2, smallSkewQueue, coerceCriteria),
  oneHundredQ: (1 to 100) reduce (n, q: BinomialQueue = []) ->
    skewInsertBy(n, q, coerceCriteria), // skew binomial number of ranks = 020011 = 6 + 31 + 63 = 100
  ranks: (0 to 9) map (rank) -> sizeOf(largeQueue filter (t) -> t.rank == rank)
}

%dw 2.5
import * from dw::ext::pq::internal::tree
import * from dw::ext::pq::internal::queue
output application/json

fun coerceCriteria(data: Any) = data as Comparable

var smallSkewQueue =  [newTree(0), newTree(1)]
---
{
  threeTree: skewLinkBy(newTree(0), newTree(1), newTree(2), coerceCriteria),
  threeQ: skewInsertBy(2, smallSkewQueue, coerceCriteria)
}

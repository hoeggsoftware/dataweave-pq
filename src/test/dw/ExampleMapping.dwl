%dw 2.0
output application/json

import * from dw::ext::PriorityQueue
var queue = emptyQueue
---
isEmptyQ(insertQ(emptyQueue, 1))
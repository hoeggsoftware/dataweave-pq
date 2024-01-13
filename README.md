# Priority Queue in DataWeave
[![Unit tests](https://github.com/hoeggsoftware/dw-ext-pq/actions/workflows/maven.yml/badge.svg)](https://github.com/hoeggsoftware/dw-ext-pq/actions/workflows/maven.yml)

This is an open source dataweave library to provide an efficient priority queue.

## Installation

### Maven

Add the maven dependency to your `pom.xml`:

```xml
    <dependency>
        <groupId>software.hoegg</groupId>
        <artifactId>dataweave-pq</artifactId>
        <version>0.1.0</version>
        <classifier>dw-library</classifier>
    </dependency>
```

### Private Exchange

Another way to incorporate this library in your mule application is to publish it into your organization's MuleSoft Anypoint Exchange. To do this, you should fork the github repository and modify the `pom.xml`.  An example of how to do it can be found [here](https://developer.mulesoft.com/tutorials-and-howtos/dataweave/dataweave-libraries-in-exchange-getting-started/) thanks to [Alex Martinez](https://github.com/alexandramartinez). 

## Usage

### Import dw::ext::pq

You will need the functions `init`, `insert`, `next`, and `deleteNext`, which all operate on the type `PriorityQueue<T>`.  Import them like so:

```dataweave
import * from dw::ext::pq::PriorityQueue
```

### Create your priority queue
Create your queue using the `init` function.  You will need to provide a criteria function, which will be used to determine whether one item has priority over another item. Items that are "smaller" than others have higher priority, so if you want higher values to come first, provide a criteria function that returns a negative value.  This is the same way you would do it with `orderBy`.

```dataweave
type Node = {
    name: String,
    priority: Number
}

var emptyQueue = init( (node: Node) -> node.priority )
```

### Adding things

Add elements to the priority queue using the `insert` function, which will return the new queue that includes the element.

```dataweave
var qWithOneItem = emptyQueue insert {
    name: "Visual Studio Code", 
    priority: 2 
}

var qWithTwoItems = qWithOneItem insert {
    name: "Emacs",
    priority: 3
}

var qWithThreeItems = qWithTwoItems insert {
    name: "Anypoint Studio",
    priority: 1
}
```

### Retrieving things

Since dataweave is a functional language, reading items from a priority queue is done separately from removing items. These steps are represented by the `next` and `deleteNext` functions.

The `next` function returns the item with the smallest value according to the criteria provided in the `init` function.

```dataweave
var firstByPriority = next(qWithThreeItems)
// Anypoint Studio node
```

The `deleteNext` function returns a priority queue that no longer contains the item with the smallest value, according to the criteria provided in the `init` function.

```dataweave
var afterRemovalQueue = deleteNext(qWithThreeItems)
// contains only Visual Studio Code and Emacs
```

## Inspiration
This work is based on publications by Gerth Stølting Brodal, Chris Okasaki, and David J. King.  Special thanks to [@amitdev](https://github.com/amitdev) for his [Purely Functional Priority Queues](https://amitdev.github.io/posts/2014-03-06-priority-queue/) blog as well.

* [Functional Binomial Queues](https://www.cs.cornell.edu/courses/cs312/2005fa/hw/binomial-queues.pdf)
* [Optimal Purely Functional Priority Queues](https://www.brics.dk/RS/96/37/BRICS-RS-96-37.pdf)

# Contributing

Pull requests on Github are my preferred way to receive contributions to this library

# License

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

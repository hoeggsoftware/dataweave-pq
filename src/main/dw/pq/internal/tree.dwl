import * from dw::core::Arrays
import * from dw::ext::Types

fun newRoot(value): BinomialTree = {
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
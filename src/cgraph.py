# Copyright (c) 2025, designbench contributors

import dataclasses

from dataclasses import dataclass
from enum import Enum
from typing import final, Callable, List, Self

import misc


# Node status
@final
class CNodeStatus(Enum):
    PENDING = 0 # Not yet executed
    SUCCESS = 1 # Executed successfully
    FAILURE = 2 # Execution failed
    FAILED_DEPENDENCY = 3 # Attempted to execute but a dependency failed


# Graph node
@final
@dataclass
class CNode:
    graph : 'CGraph'
    name: str
    computation: Callable[[], bool]
    status: CNodeStatus = CNodeStatus.PENDING
    oNodes: List[Self] = dataclasses.field(default_factory=list) # Nodes that depend on this node
    iNodes: List[Self] = dataclasses.field(default_factory=list) # Nodes that this node depends on


# Computation Graph - DAG
@final
class CGraph:
    nodes: List[CNode] = []

    def addNode(self, name: str, computation: Callable[[], bool]) -> CNode:
        node = CNode(graph=self, name=name, computation=computation)
        self.nodes.append(node)
        return node

    def addEdge(self, src: CNode, dst: CNode) -> None:
        assert src.graph is self, "'src' not in this graph"
        assert dst.graph is self, "'dst' not in this graph"
        assert (dst in src.oNodes) == (src in dst.iNodes), "Inconsitent endges"
        if dst not in src.oNodes:
            src.oNodes.append(dst)
            dst.iNodes.append(src)

    def _run(self, node: CNode) -> bool:
        assert node.graph is self, "'node' not in graph"

        if node.status != CNodeStatus.PENDING:
            return True if node.status == CNodeStatus.SUCCESS else False

        allDependenciesPassed = True
        for d in node.iNodes:
            if not self._run(d):
                allDependenciesPassed = False

        if not allDependenciesPassed:
            node.status = CNodeStatus.FAILED_DEPENDENCY
            return False

        misc.echo(node.name, style="bold")

        if node.computation():
            node.status = CNodeStatus.SUCCESS
            return True

        node.status = CNodeStatus.FAILURE
        return False

    # Run all nodes, return list of failed nodes
    def runAll(self) -> List[CNode]:
        # Run in depth-first order, for more immediate final results
        for node in self.nodes:
            if not node.oNodes:
                self._run(node)
        return [_ for _ in self.nodes if _.status == CNodeStatus.FAILURE]

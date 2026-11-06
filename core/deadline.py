"""Wall-clock budget for one whole lift.

A build whose dispatch the walk cannot follow sends the lifter into a single
proto that never finishes (minutes in the dataflow and in the CFG build), and
the caller then kills the process with no output at all.  The lift checks this
budget from its hot loops so it can stop and let the driver take another route.
0 = no limit (the default for the libraries, which never set it).
"""
import time

DEADLINE = [0.0, 0.0]


class LiftTimeout(Exception):
    """The whole lift passed its wall-clock budget."""


def arm(seconds):
    DEADLINE[0] = time.time() + seconds if seconds else 0.0
    DEADLINE[1] = time.time()


def disarm():
    DEADLINE[0] = 0.0


def check():
    d = DEADLINE[0]
    if d and time.time() > d:
        raise LiftTimeout("the lift passed its %ds budget" % int(d - DEADLINE[1]))

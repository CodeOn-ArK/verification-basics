# Solution 02

**Bug:** `full` asserts at `count == 7` instead of `count == 8`.

**Effect:** the FIFO reports full one slot early and refuses the 8th
write. No data is corrupted — capacity silently shrinks from 8 to 7.
Bugs that *lose* capacity or performance, without corrupting data, are
the ones most likely to reach silicon, because casual tests pass.

**Shortest failing sequence:** write 8 distinct values with no reads,
then check `count` (DUT: 7, model: 8) — or read back and find the 8th
value missing. Example 03's scoreboard catches it on the 8th write:
its model accepts the write (model count 7 < 8) while the DUT's count
stays at 7, so the every-cycle count check fires immediately.

**Lesson:** check flags and counts *every cycle*, not just data at the
end. The data-only version of this test passes 7/8 of the way and the
failure looks like a model problem instead of a one-line flag bug.

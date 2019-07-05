# about ps

## pcpu

> cpu utilization of the process in "##.#"
format.  Currently, it is the CPU time used
divided by the time the process has been
running (cputime/realtime ratio), expressed as
a percentage.  It will not add up to 100%
unless you are lucky.  (alias pcpu).

## rss, rsz, rssize

```
rss         RSS       resident set size, the non-swapped physical
                     memory that a task has used (in kilobytes).
                     (alias rssize, rsz).

rssize      RSS       see rss.  (alias rss, rsz).

rsz         RSZ       see rss.  (alias rss, rssize).
```

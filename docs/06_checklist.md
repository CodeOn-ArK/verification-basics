# 6 — Verification Plan & Sign-Off Checklist

Copy this into a project and fill it in *before* writing testbench code.

## Verification plan

- [ ] Features listed, each with an owner
- [ ] Corner cases per feature (boundaries, back-to-back, error cases,
      reset mid-operation, illegal inputs)
- [ ] For each feature: stimulus method (directed / random / formal)
- [ ] For each feature: check method (scoreboard / assertion / both)
- [ ] Functional coverage model defined — bins and crosses named
- [ ] Code coverage targets agreed (line, toggle, FSM)
- [ ] Reference model: who writes it, from which spec version
- [ ] Regression plan: seeds, frequency, pass criteria, triage owner

## During the project

- [ ] Every test self-checks and prints checks/errors counts
- [ ] Every failure is reproducible from a logged seed
- [ ] Assertions enabled in regression, not just in debug runs
- [ ] Coverage reviewed weekly — holes are classified as
      unreachable / under-stimulated / real gap
- [ ] Every DUT bug found → reduced test added to regression
- [ ] Every DUT bug found → assertion added, if one can express it

## Sign-off

- [ ] 100% of planned functional coverage hit, or every hole waived
      in writing with a reason
- [ ] Code coverage at target; exclusions reviewed, not assumed
- [ ] Zero open failures; zero unexplained waivers
- [ ] Assertions: zero failures, vacuity checked on key properties
- [ ] Formal properties (if used): proven, or bounded with the bound
      and its justification recorded
- [ ] Regression clean on the final RTL, on multiple seeds
- [ ] Known limitations documented — what was *not* verified

Signing off means: "I know what was checked, what wasn't, and I can
show both." If you can't list what wasn't verified, you're not done —
you're just out of time.

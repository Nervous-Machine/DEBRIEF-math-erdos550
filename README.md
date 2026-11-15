# DEBRIEF-math-erdos550

A DEBRIEF mission record (protocol https://github.com/Nervous-Machine/DEBRIEF) for **The claimed solution of Erdős Problem #550 (Ramsey numbers of trees versus complete multipartite graphs)**.

This claim is on the public claims board, https://math-board.nervousmachine.com, which shows its stage, who has contributed, and what it needs next.

**Standing.** Certified 0. Accepted 0. Refuted 0. Open gaps 3. This record is at tier zero: the claim and its public artifacts are pinned, the checks still owed are listed, and nothing has been run or read yet. The first contribution is open.

## The problem

Let T be a tree on n vertices with n large, and G the complete multipartite graph with class sizes m1 up to mk in increasing order. Show that the Ramsey number of T against G is at most the chromatic number of G minus one, times the Ramsey number of T against the complete bipartite graph on the two smallest classes minus one, plus m1. Chvátal's classical result gives the complete-graph case exactly.

Source: https://www.erdosproblems.com/550 (posed: Erdős, Faudree, Rousseau and Schelp (1985); problem 16 in the Ramsey section of the graphs problem collection).

A third-party formalization of the problem statement exists: `FormalConjectures/ErdosProblems/550.lean` in github.com/google-deepmind/formal-conjectures at commit `e028240a61822d970c933f4656f51da025cf200b` (blob `e8bc7c0e2f3ebf14533bec096eaf600a52cb30eb`). It is the natural reference for whether a claimant's Lean theorem states this problem.

## The claim

**Eric Li**, using GPT-5.5 Pro (as listed by the claimant), submitted 2026-07-17 at https://www.erdosproblems.com/forum/thread/550/proof-claims.

The claim is the stated bound for every sufficiently large n and every n-vertex tree, with k minus one in place of the chromatic number minus one. The proof combines an off-Turán tree-embedding theorem, obtained from Szemerédi regularity and an embedding lemma of Hladký and Piguet, with a compactness-and-rounding theorem for bounded-rank hypergraph obstructions using shadow hypergraphs.

Artifacts, pinned:

- an arXiv preprint: arXiv:2606.23659v2 "A Resolution of Erdős Problem 550 on Tree versus Complete Multipartite Ramsey Numbers" (published 2026-06-22, last revised 2026-08-02)
- a public repository: github.com/ericlisg/erdos550-lean at commit 6624ede70821f095eaee49865448af4e4f8c421c (2026-08-02); no licence file; 137 Lean files; has a lakefile

Status on the problem page as of 2026-11-14: listed as one proof claim; not marked accepted by the site.

## What is owed

Each open gap is in `ASKS.md` with what closes it and who could act. In order:

1. **The Lean development has not been built or kernel-checked by anyone outside the claimant** (EG1): A rerun of the Lean build on an independent machine, written down first.
2. **Do the formal statements say what the problem asks?** (EG2): A reading of the formal statement against the problem as posed, by someone who did not write it.
3. **No independent mathematician has reported reading the proof, and there is no referee report** (EG3): Someone in the field reads it and says, under their name, what holds and what does not.

## Contributing

- **Rerun** (if there is a Lean development): copy `prereg_rerun.yaml`, fill in your predictions, register it with `tools/prereg.py register` from the protocol repository and commit it *before* running anything. Run. Report with the **Rerun report** issue form; it becomes a `rerun` cycle under your name.
- **Read**: a trace (reading guide) does not exist yet. Writing one is itself a `trace` cycle. Once it exists, the **Semantic read** form takes signatures and refusals.
- **Anything else**: open a plain issue.

Rules and templates: https://github.com/Nervous-Machine/DEBRIEF/blob/main/CONTRIBUTING.md. Every contribution is one dated cycle under your own name and goes into `CITATION.cff` and the next release.

## Layout

```
ledger/erdos550.json   the ledger (protocol 0.1.0)
claim.yaml            the pinned claim this record was opened from
SCORECARD.md / ASKS.md  generated from the ledger
prereg_rerun.yaml     a pre-registration template for the first rerun (unregistered)
cycles/               contributed cycles, one file each
```

## Words

This record never calls the claim proved, verified or a theorem. It records what was claimed, what was checked by whom under what rule, and what is still open. Nothing here has standing until a cycle gives it one.

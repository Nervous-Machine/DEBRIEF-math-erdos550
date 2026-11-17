# Definitional trace of the formal statements of Erdős Problem #550

**For:** a mathematician willing to spend thirty to forty-five minutes, not a day, deciding whether the formal statements
of Erdős Problem #550 say what Erdős, Faudree, Rousseau and Schelp asked. That is the one question on this record that
no machine settles. Unlike some records in this register, nothing downstream of it is machine-checked here yet: nobody
outside the claimant has built the Lean development (gap EG1), so this guide is about meaning only.

**What this is.** The problem as posed, the two formal statements verbatim (the third party's in Google DeepMind's
formal-conjectures, and the claimant's own), every definition they depend on down to Mathlib and Lean core with file and
line, a plain-language rendering of each piece, the places where Lean's conventions differ from the blackboard, a short
argument that settles which reading of "sufficiently large" can be meant, and a sign-off checklist. The renderings are
the reading of the operating agent (Claude Code, for Nervous Machine) on 17 November 2026. They are an aid, not a check.

**What this is not.** Not an independent human semantic review, and it changes no standing. Gap EG2 stays open until a
person who is not an author signs the checklist at the end. It is not a build rerun: the worked examples in Part D are
written as Lean but **have not been run by Lean** (they are pending a run inside the built development). It says nothing
about the paper's argument (gap EG3).

**Sources, pinned, read over the network without building or running anything.**
Formal statement: `FormalConjectures/ErdosProblems/550.lean` in google-deepmind/formal-conjectures at commit
`e028240a61822d970c933f4656f51da025cf200b` (blob `e8bc7c0e`, file sha256 `b625e717cdc5e4a7843e5e7437efd5c520a12d93a9f3a89da65bef167e24e52a`);
its `graphRamsey` from `FormalConjecturesForMathlib/Combinatorics/SimpleGraph/Ramsey.lean` at the same commit; that
repository pins Lean `v4.33.1` and Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.
Claimant's statement and definitions: github.com/ericlisg/erdos550-lean at `6624ede70821f095eaee49865448af4e4f8c421c`
(`RequestProject/Main.lean`, `RequestProject/Basic.lean`, `RequestProject/MainProof.lean`, `Challenge.lean`); it pins
Lean `v4.28.0` and Mathlib `8f9d9cff6bd728b17a24e163c9402775d9e6a365`. Mathlib line numbers below are at `8f9d9cff`
unless marked; where the formal-conjectures revision differs, both are given. Problem page: https://www.erdosproblems.com/550
as read on 2026-11-17. Pre-registration for this trace: `prereg_trace.yaml`. Lean file of worked examples:
`cycles/trace-1/Trace.lean` (not run).

---

## 0. Conventions a reviewer has to know

| convention | where | what it means here |
|---|---|---|
| A graph is `SimpleGraph V`: a symmetric, irreflexive adjacency relation on a vertex type `V` | Mathlib `Combinatorics/SimpleGraph/Basic.lean` | no loops, no multi-edges; vertices are the elements of the type |
| `Cᶜ` is the complement | `SimpleGraph/Basic.lean` l.244–248 (`Adj v w := v ≠ w ∧ ¬G.Adj v w`) | the blue graph of a red–blue colouring whose red graph is `C` |
| `A ⊑ B` (`IsContained`) is "B contains a copy of A", **not necessarily induced** | `SimpleGraph/Copy.lean` l.85 (`Copy`: an injective homomorphism) and l.237 (`IsContained := Nonempty (Copy A B)`); l.239 at `0df444a3` | the usual meaning of "contains" for Ramsey numbers |
| `sInf` on ℕ is the least element, and `sInf ∅ = 0` | `Mathlib/Data/Nat/Lattice.lean` l.37 (`sInf_def`), l.65 (`sInf_empty`) | a Ramsey number defined by `sInf` would be 0 if no `N` worked; finite Ramsey rules that out (D4) |
| ℕ subtraction is truncated | Lean core | `0 - 1 = 0`. It never bites: `k ≥ 2`, and `R(T, K_{m1,m2}) ≥ n ≥ 1` (D5) |
| `∀ᶠ n in atTop, P n` is "for all sufficiently large n" | `Mathlib/Order/Filter/AtTopBot/Basic.lean` l.72 (`eventually_atTop : … ↔ ∃ a, ∀ b ≥ a, p b`); l.79 at `0df444a3` | the threshold is chosen **after** `k` and `m` (D1) |
| `Fin k` indexes from 0 | Lean core | the page's $m_1, m_2$ are `m ⟨0, _⟩`, `m ⟨1, _⟩` |
| `Monotone m` | `Mathlib/Order/Monotone/Defs.lean` l.62: `∀ ⦃a b⦄, a ≤ b → f a ≤ f b` | $m_1 \le m_2 \le \cdots \le m_k$ |

---

## Part A. The problem as posed

**A1. The problem page**, verbatim (erdosproblems.com/550, citing [EFRS85]):

> Let $m_1\leq\cdots\leq m_k$ and $n$ be sufficiently large. If $T$ is a tree on $n$ vertices and $G$ is the complete
> multipartite graph with vertex class sizes $m_1,\ldots,m_k$ then prove that
> $$R(T,G)\leq (\chi(G)-1)(R(T,K_{m_1,m_2})-1)+m_1.$$

The page adds: Chvátal [Ch77] proved that $R(T,K_m)=(m-1)(n-1)+1$; this is problem #16 in the Ramsey section of the
graphs problem collection.

**A2. The formal-conjectures docstring** repeats this sentence verbatim and adds a sentence attributing a solution to Li [Li26] and the note: "the
linked formal proof states the bound for trees on an arbitrary finite vertex type and with `K_{m_1,m_2}` written as a
complete multipartite graph with two parts; the statement below is the special case `V = Fin n`."

**A3. The claim as the claimant summarises it** (proof-claims thread, 2026-07-17): "for fixed $k\ge2$ and
$1\le m_1\le\cdots\le m_k$, we prove that, for every sufficiently large $n$ and every $n$-vertex tree $T$,
$R(T,K_{m_1,\ldots,m_k}) \le (k-1)(R(T,K_{m_1,m_2})-1)+m_1$."

**What the trace does not check.** Whether the page's sentence is a faithful rendering of the 1985 paper of Erdős,
Faudree, Rousseau and Schelp. The operating agent did not consult it. A reviewer with the paper can sign or refuse
checklist item A0; the rest of the checklist takes the page's sentence as the problem.

---

## Part B. The formal statements, verbatim

**B1. formal-conjectures** (`FormalConjectures/ErdosProblems/550.lean` l.51–61 at the pinned commit, inside
`namespace Erdos550` with `open Filter`; tagged `category research solved`; the proof is `sorry` there because the file
states the problem, it does not solve it):

```lean
theorem erdos_550 :
    ∀ (k : ℕ) (hk : 2 ≤ k) (m : Fin k → ℕ) (hm : Monotone m)
      (hm_pos : ∀ i, 0 < m i),
      ∀ᶠ n : ℕ in atTop,
        ∀ (T : SimpleGraph (Fin n)), T.IsTree →
          SimpleGraph.graphRamsey T
            (SimpleGraph.completeMultipartiteGraph (fun i ↦ Fin (m i))) ≤
            (k - 1) * (SimpleGraph.graphRamsey T
              (completeBipartiteGraph (Fin (m ⟨0, by omega⟩)) (Fin (m ⟨1, by omega⟩))) - 1) +
                m ⟨0, by omega⟩ := by
  sorry
```

**B2. The claimant's statement** (`RequestProject/Main.lean` l.72–78 at `6624ede7`; restated with the same text as the
trusted statement `Erdos550Comparator.erdos_550` in `Challenge.lean` l.15–24, which the claimant's README says was
checked with `leanprover/comparator`):

```lean
theorem erdos_550 (k : ℕ) (hk : 2 ≤ k) (m : Fin k → ℕ)
    (hmono : Monotone m) (hpos : 1 ≤ m ⟨0, by omega⟩) :
    ∃ n0 : ℕ, ∀ n, n0 ≤ n → ∀ {V : Type} [Fintype V] (T : SimpleGraph V),
      T.IsTree → Fintype.card V = n →
      ramsey T (Kmult k m) ≤
        (k - 1) * (ramsey T (Kmult 2 (fun j => m (Fin.castLE hk j))) - 1)
          + m ⟨0, by omega⟩
```

**B3. The bridge, written and not run.** No file at either pinned commit derives B1 from B2. The formal-conjectures
file links a different formal proof (github.com/plby/lean-proofs at `8822f7dd`, `src/latest/ErdosProblems/Erdos550/Main.lean`
l.80), whose `erdos_550` at that commit has the claimant's form B2, not B1. In the agent's reading B2 implies B1 in a
few lines: take `V = Fin n`; `ramsey` and `graphRamsey` are the same `sInf` (Part C); `Kmult k m` unfolds to
`completeMultipartiteGraph (fun i => Fin (m i))`; the claimant's lemma `ramsey_Kmult2_Kbip`
(`RequestProject/MainProof.lean` l.71) replaces the two-part `Kmult 2` by `completeBipartiteGraph`; `hm_pos` gives
`hpos`. That derivation is `fc_erdos_550_from_claimant` in `cycles/trace-1/Trace.lean` (Part D, example 12). **It has
not been run by Lean.** Until it is, the agreement of B1 and B2 is the agent's reading only (D8).

---

## Part C. Every piece, traced

| piece (B1; B2 where different) | Lean meaning, with source | agent's reading |
|---|---|---|
| `∀ (k : ℕ) (hk : 2 ≤ k) (m : Fin k → ℕ)` | `k` classes, sizes `m 0, …, m (k-1)` | "for every $k \ge 2$ and class sizes $m_1, \dots, m_k$" |
| `(hm : Monotone m)` | Mathlib `Order/Monotone/Defs.lean` l.62 | "$m_1 \le \cdots \le m_k$" |
| `(hm_pos : ∀ i, 0 < m i)`; B2: `(hpos : 1 ≤ m ⟨0, _⟩)` | with `Monotone`, the two are equivalent (example 7) | "every class is nonempty". The page does not say this; see D3. |
| `∀ᶠ n : ℕ in atTop, …`; B2: `∃ n0, ∀ n, n0 ≤ n → …` | `eventually_atTop` (§0): there is a threshold $n_0$, chosen after $k$ and $m$ | "for all $n \ge n_0(k, m_1, \dots, m_k)$". Nothing is uniform in the class sizes, and the class sizes need not be large. See D1 and Part E1. |
| `∀ (T : SimpleGraph (Fin n)), T.IsTree →`; B2: `∀ {V : Type} [Fintype V] (T : SimpleGraph V), T.IsTree → Fintype.card V = n →` | `IsTree` = connected and acyclic: `SimpleGraph/Acyclic.lean` l.58 (l.60 at `0df444a3`, where it `extends Connected`); `IsAcyclic` l.54 ("no walk from a vertex to itself is a cycle"); `Connected` (`Connectivity/Connected.lean` l.290) = preconnected and nonempty | "for every tree $T$ on $n$ vertices". B1 fixes the vertex set to $\{0, \dots, n-1\}$; B2 allows any finite set of size $n$ (D6). |
| `graphRamsey T H` (formal-conjectures `…/SimpleGraph/Ramsey.lean` l.88–90); B2: `ramsey T H` (`RequestProject/Basic.lean` l.27–28) | both: `sInf {N \| ∀ C : SimpleGraph (Fin N), T ⊑ C ∨ H ⊑ Cᶜ}` | "$R(T, H)$: the least $N$ such that every red–blue colouring of $K_N$ (red graph $C$, blue graph $C^c$) has a red copy of $T$ or a blue copy of $H$", copies not necessarily induced (D4) |
| `completeMultipartiteGraph (fun i ↦ Fin (m i))`; B2: `Kmult k m` | `Kmult` (`Basic.lean` l.37–39) is literally `completeMultipartiteGraph (fun i => Fin (m i))`; that is `SimpleGraph.comap Sigma.fst ⊤` (`SimpleGraph/Maps.lean` l.173; l.197 at `0df444a3`), with `comap` (l.108): `Adj u v := G.Adj (f u) (f v)` | vertices are pairs (class $i$, element of a set of size $m_i$); two are adjacent exactly when their classes differ. This is $G = K_{m_1, \dots, m_k}$ (example 3). |
| `(k - 1) * (…)` | ℕ multiplication; `k - 1` exact since `k ≥ 2` | "$(\chi(G) - 1) \cdot (\dots)$", using $\chi(K_{m_1,\dots,m_k}) = k$ when every class is nonempty (D2) |
| `completeBipartiteGraph (Fin (m ⟨0,_⟩)) (Fin (m ⟨1,_⟩))`; B2: `Kmult 2 (fun j => m (Fin.castLE hk j))` | `completeBipartiteGraph` (`SimpleGraph/Basic.lean` l.153; l.155 at `0df444a3`): vertices `Fin a ⊕ Fin b`, adjacent iff on opposite sides. B2 uses a two-class `Kmult` on the first two classes (`Fin.castLE`, core `Init/Data/Fin/Basic.lean` l.303) | "$K_{m_1, m_2}$, the complete bipartite graph on the two smallest classes". The two encodings are isomorphic graphs; the claimant's `Kmult2_iso_Kbip` and `ramsey_Kmult2_Kbip` (`MainProof.lean` l.48, l.71) state this (D7). |
| `… - 1) + m ⟨0, by omega⟩` | truncated subtraction, never truncating here (D5) | "$(R(T, K_{m_1,m_2}) - 1) + m_1$" |

---

## Part D. Worked examples, written and not yet run

All in `cycles/trace-1/Trace.lean`, which imports the claimant's development. **None has been run by Lean**: Nervous
Machine has not built the development (EG1 is open), and this cycle executes nothing. They are pending a run with
`lake env lean` inside the built development; until then no output is claimed for any of them, and there is no
`trace.txt`.

1. `(0 : ℕ) - 1 = 0` and `(2 : ℕ) - 1 = 1` by `decide`.
2. `sInf (∅ : Set ℕ) = 0` (`Nat.sInf_empty`).
3. In `completeMultipartiteGraph (fun _ : Fin 3 => Fin 2)`, `⟨0,0⟩` and `⟨1,0⟩` are adjacent, `⟨0,0⟩` and `⟨0,1⟩` are not.
4. In `completeBipartiteGraph (Fin 2) (Fin 3)`, `inl 0` and `inr 2` are adjacent, `inl 0` and `inl 1` are not.
5. The complement of any graph has no loops.
6. No graph on `Fin 0` is a tree.
7. `Monotone m` and `1 ≤ m 0` give `0 < m i` for every `i`.
8. `Kmult k m = completeMultipartiteGraph (fun i => Fin (m i))` and `Kbip a b = completeBipartiteGraph (Fin a) (Fin b)`, by `rfl`.
9. `Fin.castLE` sends index 1 of `Fin 2` to index 1 of `Fin 3`, by `rfl`.
10. `graphRamsey G H = Erdos550.ramsey G H` by `rfl` (with a verbatim copy of `graphRamsey`, Apache-2.0, attributed in the file).
11. `(∀ᶠ n in atTop, p n) ↔ ∃ n0, ∀ n ≥ n0, p n`.
12. The bridge B3: B1, restated with the copied `graphRamsey`, derived from the claimant's `Erdos550.erdos_550`; then `#print axioms` on it.
13. `#check`/`#print` of both statements and of `ramsey`, `Kmult`, `Kbip`, `completeMultipartiteGraph`, `completeBipartiteGraph`, `IsTree`, `IsContained`, `Copy`, `Monotone`.

---

## Part E. Discrepancies and observations

### E1. Which "sufficiently large" can be meant

The page's sentence begins "Let $m_1\leq\cdots\leq m_k$ and $n$ be sufficiently large". Read literally it could ask for
the class sizes to be large as well, or for one threshold that serves every $G$. Both formal statements say something
specific: fix $k$ and $m_1, \dots, m_k$ (any sizes at least 1), then there is $n_0$, depending on them, such that every
tree on $n \ge n_0$ vertices satisfies the bound.

The agent's argument that this is the only reading under which the inequality can hold (a reader should check it; it is
two lines). Let $T$ have $n \ge 2$ vertices and put $M = m_1 + \cdots + m_k = |V(G)|$. Colour every edge of $K_{M-1}$
blue: there is no red edge, so no red $T$, and the blue graph has $M - 1$ vertices, so no blue $G$. Hence
$R(T, G) \ge M$. The right-hand side, $(k-1)(R(T, K_{m_1,m_2}) - 1) + m_1$, does not depend on $m_3, \dots, m_k$. So for
fixed $n$, $k \ge 3$, $m_1$ and $m_2$, letting $m_k$ grow makes the left side unbounded and leaves the right side fixed:
the inequality fails. For example $k = 3$, $m = (1, 1, M')$: the right side is $2(R(T, K_2) - 1) + 1 = 2n - 1$, and the
left side is at least $M' + 2$, so the bound fails once $M' \ge 2n - 2$. Therefore $n$ must be large *relative to the
class sizes*; a threshold uniform in $G$ would make the problem false, and "the $m_i$ large as well" only narrows the
set of $G$, which the formal statements already cover. In the agent's reading the formal quantifier order is the
intended one, and the page's "$m_1 \le \cdots \le m_k$ and" is the ordering condition, not a second largeness condition.

### E2. Discrepancies

| id | observation | kind | effect, in the agent's reading |
|---|---|---|---|
| D1 | The page says "Let $m_1\leq\cdots\leq m_k$ and $n$ be sufficiently large"; both formal statements fix $k$ and $m$ first, require only $m_i \ge 1$, and take $n \ge n_0(k, m)$. | quantifier order | none: Part E1 shows a threshold uniform in the class sizes would make the inequality false, and requiring the $m_i$ to be large only weakens the problem. This is checklist item A1, the one place a reader's judgement is needed. |
| D2 | The page has $\chi(G) - 1$; both formal statements have `k - 1`. | substitution | none: with every class nonempty and $k \ge 2$, $G$ contains $K_k$ and is properly $k$-coloured by class, so $\chi(G) = k$. |
| D3 | Both formal statements assume every class is nonempty (`0 < m i`, or `1 ≤ m 0` with monotone); the page does not say so. | hypothesis | none: an empty class is not a class of a $k$-partite graph in the usual sense, and with empty classes allowed $\chi(G) < k$ and the substitution in D2 would fail; excluding them is the reading under which D2 holds. |
| D4 | $R$ is `sInf` of the set of good $N$, with red graph `C` on `Fin N`, blue graph `Cᶜ`, and non-induced copies; `sInf ∅ = 0`. | encoding | none: this is the standard two-colour Ramsey number. The set is nonempty for finite $T$ and $G$ by Ramsey's theorem, and it is upward closed (restrict a colouring of $K_{N+1}$ to $K_N$), so `sInf` is the threshold. Were it empty, the left side would be 0 and the statement trivially true; Ramsey's theorem is what rules that out. |
| D5 | `k - 1` and `R - 1` are truncated subtraction. | Lean convention | none: $k \ge 2$, and $R(T, K_{m_1,m_2}) \ge n \ge 1$ (a red $T$ needs $n$ vertices). |
| D6 | B1 quantifies over trees on `Fin n`; B2 over trees on any finite type of size $n$; neither excludes $n = 0$ explicitly. | vertex type | none: Ramsey numbers are invariant under relabelling, so B2 is the same statement in more generality; no graph on 0 vertices is a tree (example 6), and "eventually in $n$" makes small $n$ irrelevant. |
| D7 | $K_{m_1,m_2}$ is `completeBipartiteGraph (Fin m₁) (Fin m₂)` in B1 and a two-class `Kmult` in B2. | encoding | none: isomorphic graphs; the claimant states the isomorphism and the equality of Ramsey numbers (`MainProof.lean` l.48, l.71). Not run here. |
| D8 | No machine derivation of B1 from B2 exists at the pinned commits. The formal-conjectures file links a formal proof in plby/lean-proofs whose main declaration has B2's form. The two repositories pin different Lean and Mathlib versions (`v4.33.1`/`0df444a3` and `v4.28.0`/`8f9d9cff`); the definitions used here read the same in both, with `IsTree` restated as `extends Connected` in the later one. | provenance | none on meaning in the agent's reading; the bridge is written (Part D, example 12) and is pending a run. A reviewer who signs B1 relies on that bridge to carry the signature to the claimant's statement. |
| D9 | The formal-conjectures file is already tagged `research solved`, citing the claimant's paper. | label | none on standing here; the tag is a repository label, not a reading of the statement against the problem. |

No discrepancy that changes the meaning was seen by the agent. No anomaly is opened.

---

## Part F. Sign-off checklist

For a reviewer who is prepared to put their name to a reading. Each line is a yes/no. Send it with the **Semantic read**
issue form on this repository (it becomes a `read` cycle under your name), or anywhere public; the ledger records it by
date. Two independent signatures with no refusal close gap EG2; one refusal reopens it.

- [ ] A0 (optional, needs [EFRS85]): the page's sentence is the problem of Erdős, Faudree, Rousseau and Schelp.
- [ ] A1: "sufficiently large" means: fix $k$ and $m_1 \le \cdots \le m_k$ (each at least 1), then all $n \ge n_0(k, m)$; this is what `∀ᶠ n in atTop` after `∀ k m` says, and Part E1's argument that no other reading can hold is correct (D1, D3).
- [ ] A2: `graphRamsey T H` (and the claimant's `ramsey`) is the two-colour Ramsey number $R(T, H)$ (D4, D5).
- [ ] A3: `completeMultipartiteGraph (fun i ↦ Fin (m i))` is $K_{m_1,\dots,m_k}$, `k - 1` is $\chi(G) - 1$, and `completeBipartiteGraph (Fin (m 0)) (Fin (m 1))` is $K_{m_1,m_2}$ (D2, D7).
- [ ] A4: `T : SimpleGraph (Fin n)` with `T.IsTree` is "a tree on $n$ vertices" (D6).
- [ ] B (optional): the claimant's statement B2 says the same as B1 in more generality; the bridge B3 is the right derivation (it still has to be run by Lean, D8).

A reviewer who signs A1 to A4 has closed the semantic question for this problem as the page states it.

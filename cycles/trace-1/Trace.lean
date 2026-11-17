import RequestProject
/-
Worked examples for the reading guide (cycle 1, trace/DEFINITIONAL-TRACE.md, Part D).

STATUS: WRITTEN, NOT YET RUN BY LEAN. Nervous Machine has not built the claimant's development (gap EG1 is open), so
nothing below has been checked by Lean's kernel. To run it: build github.com/ericlisg/erdos550-lean at
6624ede70821f095eaee49865448af4e4f8c421c (Lean v4.28.0, Mathlib 8f9d9cff), place this file at the repository root, and
run `lake env lean Trace.lean`. The output belongs in cycles/trace-1/trace.txt, which does not exist yet.

Names from the claimant's development (Erdos550.ramsey, Erdos550.Kmult, Erdos550.Kbip, Erdos550.erdos_550,
Erdos550.ramsey_Kmult2_Kbip) are referred to, not copied. The definition `graphRamsey` below is copied verbatim from
google-deepmind/formal-conjectures (Apache License 2.0), file
FormalConjecturesForMathlib/Combinatorics/SimpleGraph/Ramsey.lean l.88-90 at commit e028240a, because that repository is
not a dependency of the claimant's development.
-/
open SimpleGraph Filter

namespace TraceErdos550

/-- Copied from formal-conjectures (Apache-2.0), `SimpleGraph.graphRamsey`, l.88-90 at e028240a. -/
noncomputable def graphRamsey {α β : Type*} [Fintype α] [Fintype β]
    (G : SimpleGraph α) (H : SimpleGraph β) : ℕ :=
  sInf { n : ℕ | ∀ (C : SimpleGraph (Fin n)), G.IsContained C ∨ H.IsContained Cᶜ }

-- 1. Lean's subtraction on ℕ is truncated: 0 - 1 = 0. In the statement, k - 1 has k ≥ 2 and R - 1 has R ≥ n ≥ 1.
example : (0 : ℕ) - 1 = 0 := by decide
example : (2 : ℕ) - 1 = 1 := by decide

-- 2. The infimum of the empty set of naturals is 0. A Ramsey number defined by sInf would be 0 if no N worked;
--    the finite Ramsey theorem rules that out for finite graphs.
example : sInf (∅ : Set ℕ) = 0 := Nat.sInf_empty

-- 3. completeMultipartiteGraph: two vertices are adjacent exactly when they are in different classes.
example : (completeMultipartiteGraph (fun _ : Fin 3 => Fin 2)).Adj ⟨0, 0⟩ ⟨1, 0⟩ := by simp
example : ¬ (completeMultipartiteGraph (fun _ : Fin 3 => Fin 2)).Adj ⟨0, 0⟩ ⟨0, 1⟩ := by simp

-- 4. completeBipartiteGraph: adjacent exactly across the two sides.
example : (completeBipartiteGraph (Fin 2) (Fin 3)).Adj (Sum.inl 0) (Sum.inr 2) := by simp
example : ¬ (completeBipartiteGraph (Fin 2) (Fin 3)).Adj (Sum.inl 0) (Sum.inl 1) := by simp

-- 5. The complement keeps vertices non-adjacent to themselves (the blue graph has no loops).
example (C : SimpleGraph (Fin 3)) (v : Fin 3) : ¬ Cᶜ.Adj v v := by simp

-- 6. A graph on the empty vertex type is not a tree (Connected requires a vertex), so n = 0 never satisfies T.IsTree.
example (T : SimpleGraph (Fin 0)) (h : T.IsTree) : False := by
  obtain ⟨x⟩ := h.isConnected.nonempty
  exact x.elim0

-- 7. Monotone m with 1 ≤ m 0 gives every class nonempty (the claimant's hypothesis gives formal-conjectures' hm_pos;
--    the converse is immediate at i = 0), so the two positivity hypotheses agree.
example (k : ℕ) (hk : 2 ≤ k) (m : Fin k → ℕ) (hm : Monotone m) (h0 : 1 ≤ m ⟨0, by omega⟩) (i : Fin k) :
    0 < m i := Nat.lt_of_lt_of_le h0 (hm (show (⟨0, by omega⟩ : Fin k) ≤ i from Nat.zero_le i.val))

-- 8. The claimant's Kmult and Kbip unfold to the Mathlib constructions the formal-conjectures statement uses.
example (k : ℕ) (m : Fin k → ℕ) : Erdos550.Kmult k m = completeMultipartiteGraph (fun i => Fin (m i)) := rfl
example (a b : ℕ) : Erdos550.Kbip a b = completeBipartiteGraph (Fin a) (Fin b) := rfl

-- 9. Fin.castLE picks the first two classes: index j of Fin 2 goes to index j of Fin k.
example (m : Fin 3 → ℕ) : (fun j : Fin 2 => m (Fin.castLE (by omega) j)) 1 = m 1 := rfl

-- 10. The claimant's ramsey and formal-conjectures' graphRamsey are the same number (same set, same sInf).
example {α β : Type} [Fintype α] [Fintype β] (G : SimpleGraph α) (H : SimpleGraph β) :
    graphRamsey G H = Erdos550.ramsey G H := rfl

-- 11. "Eventually in n" is "there is n0 with every n ≥ n0".
example (p : ℕ → Prop) : (∀ᶠ n in atTop, p n) ↔ ∃ n0, ∀ n ≥ n0, p n := eventually_atTop

-- 12. The bridge: the formal-conjectures statement erdos_550 (FormalConjectures/ErdosProblems/550.lean l.51-60 at
--     e028240a, restated here with the copied graphRamsey) follows from the claimant's Erdos550.erdos_550 and its lemma
--     Erdos550.ramsey_Kmult2_Kbip (RequestProject/MainProof.lean l.71). Written by Nervous Machine; not yet run.
theorem fc_erdos_550_from_claimant :
    ∀ (k : ℕ) (hk : 2 ≤ k) (m : Fin k → ℕ) (hm : Monotone m)
      (hm_pos : ∀ i, 0 < m i),
      ∀ᶠ n : ℕ in atTop,
        ∀ (T : SimpleGraph (Fin n)), T.IsTree →
          graphRamsey T
            (SimpleGraph.completeMultipartiteGraph (fun i ↦ Fin (m i))) ≤
            (k - 1) * (graphRamsey T
              (completeBipartiteGraph (Fin (m ⟨0, by omega⟩)) (Fin (m ⟨1, by omega⟩))) - 1) +
                m ⟨0, by omega⟩ := by
  intro k hk m hm hm_pos
  obtain ⟨n0, h⟩ := Erdos550.erdos_550 k hk m hm (hm_pos _)
  rw [eventually_atTop]
  refine ⟨n0, fun n hn T hT => ?_⟩
  have key := h n hn T hT (Fintype.card_fin n)
  rw [Erdos550.ramsey_Kmult2_Kbip] at key
  exact key

-- 13. The statements and definitions as the development prints them.
#check @Erdos550.erdos_550
#check @fc_erdos_550_from_claimant
#print axioms fc_erdos_550_from_claimant
#print Erdos550.ramsey
#print Erdos550.Kmult
#print Erdos550.Kbip
#print SimpleGraph.completeMultipartiteGraph
#print completeBipartiteGraph
#print SimpleGraph.IsTree
#print SimpleGraph.IsContained
#print SimpleGraph.Copy
#print Monotone

end TraceErdos550

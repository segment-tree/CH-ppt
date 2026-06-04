
example (h : p ∧ q) : q ∧ p ∧ q := sorry

#check (@Iff.intro)

#check @And.intro

theorem and_swap : (p ∧ q) ↔ (q ∧ p) :=
  sorry

example (h : p ∧ q) : q ∧ p := Iff.mp and_swap h

#check And.elim

theorem or_swap : p ∨ q ↔ q ∨ p :=
  Iff.intro
    (λ h : p ∨ q => Or.elim h (λ hp : p => Or.inr hp) (λ hq : q => Or.inl hq))
    sorry

-- assoc
example : (p ∧ q) ∧ r ↔ p ∧ (q ∧ r) :=
  Iff.intro
    (λ h : (p ∧ q) ∧ r => And.intro h.1.1 (And.intro h.1.2 h.2))
    sorry

example : (p ∨ q) ∨ r ↔ p ∨ (q ∨ r) :=
  sorry

--
example : p ∧ (q ∨ r) ↔ (p ∧ q) ∨ (p ∧ r) :=
  sorry

example : p ∨ (q ∧ r) ↔ (p ∨ q) ∧ (p ∨ r) :=
  sorry
-- other

example : (p → (q → r)) ↔ (p ∧ q → r) :=
  Iff.intro
    (λ f => λ h : p ∧ q => f h.1 h.2)
    (λ f => λ (hp : p) (hq : q) => f ⟨hp, hq⟩)

theorem t1 : (p ∨ q → r) ↔ (p → r) ∧ (q → r) :=
  sorry


example : ¬(p ∨ q) ↔ ¬p ∧ ¬q := t1

theorem absurd' : ¬(p ↔ ¬p) :=
  sorry

-- Chapter : quantifiers

section -- exercise 1

variable (α : Type u) (p q : α → Prop)

def t2 : (∀ x, p x ∧ q x) ↔ (∀ x, p x) ∧ (∀ x, q x) :=
  sorry

#check t2

example : (∀ x, p x → q x) → (∀ x, p x) → (∀ x, q x)
  | h , hp => (λ x : α => h x (hp x))

example : (∀ x, p x) ∨ (∀ x, q x) → ∀ x, p x ∨ q x := sorry

variable (r : Prop)

example (x : α) : ((∀ _ : α, r) ↔ r) :=
  sorry

example : (∀ x, r → p x) ↔ (r → ∀ x, p x) :=
  sorry

end -- exercise 1

section -- exercise 2

variable (men : Type) (barber : men)

variable (shaves : men → men → Prop)

example (h : ∀ x : men, shaves barber x ↔ ¬ shaves x x) : False :=
  absurd' (p := shaves barber barber) $ h barber

end

section

variable (α : Type) (r : α → α → Prop)

variable (refl_r : ∀ x, r x x)
variable (symm_r : ∀ {x y}, r x y → r y x)
variable (trans_r : ∀ {x y z}, r x y → r y z → r x z)

example (a b c d : α) (hab : r a b) (hcb : r c b) (hcd : r c d) : r a d :=
  trans_r (trans_r hab (symm_r hcb)) hcd

end

example (x y : Nat) : (x + y) * (x + y) = x * x + y * x + x * y + y * y :=
  have h1 : (x + y) * (x + y) = (x + y) * x + (x + y) * y :=
    Nat.mul_add (x+y) x y
  have h2 : (x + y) * (x + y) = x * x + y * x + (x * y + y * y) :=
    Nat.add_mul x y x ▸ Nat.add_mul x y y ▸ h1
  Nat.add_assoc (x * x + y * x) (x * y) (y * y) ▸ h2

section

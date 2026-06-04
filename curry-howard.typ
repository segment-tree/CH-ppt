#set page(width: 16cm, height: 9cm, margin: (x: 1.0cm, y: 0.72cm))
#set text(size: 13pt)
#set par(justify: false, leading: 0.63em)
#set heading(numbering: none)
#show heading: it => [
  #it
  #v(0.55em)
]

#show math.frac: it => math.display(it)




= #align(center)[#text(size: 11pt)[Logic, Programs, and] Curry-Howard Correspondence]

$text("Propositions as Types, Proofs as Programs")$

#v(4.0cm)
#align(center)[#text(size: 11pt)[#text(fill: blue)[Ruize Ma]]]

#pagebreak()

= Part I. Logic

Propositions:

$A, B, C ::= p | A -> B | A ∧ B | A ∨ B$

Sequent judgment:

$Γ ⊢ A$

`Γ` is a context of assumptions; `A` is the goal formula.

#pagebreak()

= Structural Reading of Sequents

Think of a derivation as a tree of rule applications.

If a rule has premises and a conclusion, it is written:

$frac(("premise 1" quad "premise 2"), ("conclusion"))$

We will instantiate this with implication/and/or/forall rules.

#pagebreak()

= Assumption Rules

$frac(, (Γ;A ⊢ A)) quad ("Assup")$

A trivial rule: if we assume `A`, then we can conclude `A`.

#pagebreak()

= Implication Rules

$frac((Γ; A ⊢ B), (Γ ⊢ A -> B)) quad (->I)$

$frac((Γ ⊢ A -> B quad Γ ⊢ A), (Γ ⊢ B)) quad (->E)$

//`->I` introduces implication by discharging assumption `A`.

#pagebreak()

= Conjunction Rules

$frac((Γ ⊢ A quad Γ ⊢ B), (Γ ⊢ A ∧ B)) quad (∧I)$

$frac((Γ ⊢ A ∧ B), (Γ ⊢ A)) quad (∧E_1)$

$frac((Γ ⊢ A ∧ B), (Γ ⊢ B)) quad (∧E_2)$

#pagebreak()

= Disjunction Rules

$frac((Γ ⊢ A), (Γ ⊢ A ∨ B)) quad (∨I_1)$

$frac((Γ ⊢ B), (Γ ⊢ A ∨ B)) quad (∨I_2)$

$frac((Γ ⊢ A ∨ B quad Γ; A ⊢ C quad Γ; B ⊢ C), (Γ ⊢ C)) quad (∨E)$

#pagebreak()

= Law of Excluded Middle (LEM)

$frac(, (⊢ A ∨ ¬A)) quad ("LEM")$

Note, Negation is syntactic sugar:

$¬P := P -> ⊥$

//#text(size: 10pt)[
//In intuitionistic/constructive logic, `⊢ A ∨ ¬A` is not derivable in general.
//]

#pagebreak()

= Derivation Example 1

Target formula:

$⊢ A -> (B -> A)$

Sketch:
/*
$A, B ⊢ A$

$A ⊢ B -> A$

$⊢ A -> (B -> A)$
*/

$frac(frac((A, B ⊢ A),(A ⊢ B -> A)), ⊢ A -> (B -> A))$

#pagebreak()

= Derivation Example 2

$P → Q, Q → R ⊢ P → R$

#text(size: 9pt)[
$frac(frac(frac(,(P → Q, Q → R, P ⊢ Q → R)) frac(frac(,(𝑃 → 𝑄, 𝑄 → 𝑅, 𝑃 ⊢ 𝑃 → 𝑄)) frac(,(𝑃 → 𝑄, 𝑄 → 𝑅, 𝑃 ⊢ 𝑃)),(P → Q, Q → R, P ⊢ Q)),(P → Q, Q → R, P ⊢ R)), (P → Q, Q → R ⊢ P → R))$
]
#pagebreak()

= First-Order Logic: forall

Quantified formulas:

$forall x. P(x)$

Rules:

$frac((Γ ⊢ P(x)), (Γ ⊢ forall x. P(x)))$ #text(size: 10pt)[where `x` is not free in `Γ`] $quad (forall I)$

$frac((Γ ⊢ forall x. P(x)), (Γ ⊢ P(t))) quad (forall E)$

Due to time limitations, we will not discuss existential quantifiers.

#pagebreak()

= Part II. Programs

Why use functional languages here?

- Functions are first-class, so implication-like behavior is explicit.
- Types are precise, so logical structure is visible in programs.
- Lambda calculus gives a formal core close to proof rules.

Our path in this part:

1. start with higher-order functions (build intuition);
2. move to product/sum/function types;
3. then introduce lambda calculus and STLC (formal view).

#pagebreak()

= Higher-Order Functions

```haskell
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)
```

```python
def apply_twice(f, x):
    return f(f(x))
```

```cpp
auto apply_twice = [](auto f, auto x) { return f(f(x)); };
```

Functions are inputs/outputs of other functions.

#pagebreak()

= Currying

```haskell
add :: Int -> Int -> Int
add x y = x + y
```

```python
def add(x):
    return lambda y: x + y
```

```cpp
auto add = [](int x) { return [x](int y) { return x + y; }; };
```

UnCurried: $"(Int, Int)" -> "Int"$.

Curried: $"Int" -> "Int" -> "Int"$ ($->$ is right-associative).

#pagebreak()

= Product Types

```haskell
proj1 :: (a, b) -> a
proj1 (x, _) = x
proj2 :: (a, b) -> b
proj2 (_, y) = y
```

```python
p = (42, "ok")   # tuple as product
left = p[0]
```

```cpp
std::pair<int, std::string> p{42, "ok"};
auto left = p.first;
```

Constructor stores both components simultaneously.

#pagebreak()

= Sum Types

```haskell
data Either a b = Left a | Right b
```

```cpp
std::variant<int, std::string> v = 42;
```

Interpretation: value is from the left branch or the right branch.

#pagebreak()

= Untyped Lambda Calculus

Syntax:

$t ::= x | (lambda x. t) | t t$

Alpha-renaming: bound variable names do not matter.

$lambda x. x equiv lambda y. y$

Beta-reduction: function application substitutes the argument.

$(lambda x. x) y -> y quad quad (lambda x. lambda y. x) a b -> a$

Eta-conversion: a function is determined by its behavior.

$lambda x. f(x) equiv f$

#pagebreak()

= Simply Typed Lambda Calculus (STLC)

Types:

$T ::= alpha | T -> T | T × T | T + T$

Typing judgment:

$Γ ⊢ t : T$

Now terms are constrained by types.

#pagebreak()

= STLC Typing Rules

$frac(((x : A) ∈ Γ), (Γ ⊢ x : A)) quad "(var)"$

$frac((Γ; x : A ⊢ t : B), (Γ ⊢ lambda x. t : A -> B)) quad "(abs)"$

$frac((Γ ⊢ f : A -> B quad Γ ⊢ a : A), (Γ ⊢ f(a) : B)) quad "(app)"$

#pagebreak()

= Program Derivation Example

Term:  $lambda x. lambda y. x$

Type: $A -> (B -> A)$

Derivation shape:

/*
$x:A, y:B ⊢ x:A$

$x:A ⊢ lambda y. x : B -> A$

$⊢ lambda x. lambda y. x : A -> (B -> A)$
*/

$((x:A, y:B ⊢ x:A) / (x:A ⊢ lambda y. x : B -> A)) / (⊢ lambda x. lambda y. x : A -> (B -> A))$

Have you noticed that this corresponds to some earlier formula?

#pagebreak()

= Part III. Curry-Howard Correspondence

Do you find any similarities between the logic rules and the typing rules?

#pagebreak()

= Rule Correspondence Table I (`->`, `and`)

#text(size: 10pt)[
#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  stroke: 0.4pt,
  [*Logic (sequent style)*],
  [*Lambda (sequent style)*],
  [
    #text(size: 8pt)[(Assup)]
    $frac(, (Γ,A ⊢ A))$
  ],
  [
    #text(size: 8pt)[(Assup)]
    $frac(, (Γ, x:A ⊢  x : A))$
  ],
  [
    #text(size: 8pt)[(-> Intro)]
    $frac((Γ, A ⊢ B), (Γ ⊢ A -> B))$
  ],
  [
    #text(size: 8pt)[(abs)]
    $frac((Γ, x:A ⊢ t:B), (Γ ⊢ lambda x. t : A -> B))$
  ],
  [
    #text(size: 8pt)[(-> Elim)]
    $frac((Γ ⊢ A -> B quad Γ ⊢ A), (Γ ⊢ B))$
  ],
  [
    #text(size: 8pt)[(app)]
    $frac((Γ ⊢ f : A -> B quad Γ ⊢ a : A), (Γ ⊢ f(a) : B))$
  ],
  [
    #text(size: 8pt)[(and Intro)]
    $frac((Γ ⊢ A quad Γ ⊢ B), (Γ ⊢ A ∧ B))$
  ],
  [
    #text(size: 8pt)[(pair Intro)]
    $frac((Γ ⊢ u:A quad Γ ⊢ v:B), (Γ ⊢ (u, v) : A × B))$
  ],
  [
    #text(size: 8pt)[(and Elim 1)]
    $frac((Γ ⊢ A ∧ B), (Γ ⊢ A))$
  ],
  [
    #text(size: 8pt)[(proj 1)]
    $frac((Γ ⊢ p : A × B), (Γ ⊢ "fst"(p) : A))$
  ],
)
]

#pagebreak()

= Rule Correspondence Table II (`and`, `or`)

#text(size: 10pt)[
#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  stroke: 0.4pt,
  [*Logic (sequent style)*],
  [*Lambda (sequent style)*],
  [
    #text(size: 8pt)[(and Elim 2)]
    $frac((Γ ⊢ A ∧ B), (Γ ⊢ B))$
  ],
  [
    #text(size: 8pt)[(proj 2)]
    $frac((Γ ⊢ p : A × B), (Γ ⊢ "snd"(p) : B))$
  ],
  [
    #text(size: 8pt)[(or Intro 1)]
    $frac((Γ ⊢ A), (Γ ⊢ A ∨ B))$
  ],
  [
    #text(size: 8pt)[(+ Intro 1)]
    $frac((Γ ⊢ a : A), (Γ ⊢ "left"(a) : A + B))$
  ],
  [
    #text(size: 8pt)[(or Intro 2)]
    $frac((Γ ⊢ B), (Γ ⊢ A ∨ B))$
  ],
  [
    #text(size: 8pt)[(+ Intro 2)]
    $frac((Γ ⊢ b : B), (Γ ⊢ "right"(b) : A + B))$
  ],
  [
    #text(size: 8pt)[(or Elim)]\
    $frac((Γ ⊢ A ∨ B quad Γ ⊢ A -> C quad Γ ⊢ B -> C), (Γ ⊢ C))$
  ],
  [
    #text(size: 8pt)[(+ Elim)]
    #text(size: 8.5pt)[
    $frac((Γ ⊢ e : A + B quad Γ ⊢ f : A -> C quad Γ ⊢ g : B -> C), (Γ ⊢ δ(e,f,g) : C))$
    ]
  ],
)
]
#text(size: 8pt)[Oops! Do you notice that we have missed something?]

#pagebreak()

= Curry-Howard Correspondence !

Judgment-level correspondence:

- Left (logic): $Γ ⊢ A$
- Right (typed lambda): $Γ ⊢ t : A$

Same context `Γ`, same goal formula/type `A`,
but on the right we also show the witness term `t`.  $quad$  (Type - Proposition, Term - Proof)

#text(size: 10pt)[
Here we work in the constructive setting, so LEM is not assumed as a general rule.
For any proposition `A`, LEM would require a term of type `A + (A -> ⊥)`, which is not uniformly constructible.
]


At this point, we have built a correspondence between propositional logic and STLC.

#pagebreak()

= What the Typing Rules Add

Compare the two judgments again:

- Logic: $Γ ⊢ A$
- Typing: $Γ ⊢ t : A$

Both sides contain:

- context `Γ`;
- proposition/type `A`.

The typing side also contains a term `t`.

Under Curry-Howard, this term is the proof object.

#pagebreak()

= Proof as Lambda Terms

Recall the earlier theorem:

$P -> Q, Q -> R ⊢ P -> R$

In the typed view, assumptions become variables:

$Γ = f : P -> Q, g : Q -> R$

#text(size: 11pt)[
$frac(
  frac(
    frac(, (Γ, x : P ⊢ g : Q -> R))
    frac(
      frac(, (Γ, x : P ⊢ f : P -> Q))
      frac(, (Γ, x : P ⊢ x : P)),
      (Γ, x : P ⊢ f(x) : Q)
    ),
    (Γ, x : P ⊢ g(f(x)) : R)
  ),
  (Γ ⊢ lambda x. g(f(x)) : P -> R)
)$
]

#pagebreak()

= Proof Term as Compressed Derivation

The whole derivation can be represented by its root term:

$f : P -> Q, g : Q -> R ⊢ lambda x. g(f(x)) : P -> R$

Program reading:

given `f : P -> Q` and `g : Q -> R`, build a function `P -> R`.

Logic reading:

given proofs of `P -> Q` and `Q -> R`, construct a proof of `P -> R`.

The type checker can reconstruct the proof tree from the term.

#pagebreak()


= Examples: Lean4 + Haskell Proof Terms

Now we instantiate each pair above with concrete terms:

- Haskell as typed functional witnesses.
- Lean4 as machine-checked proof terms.
- Some examples also provide C++/Python code for reference. However, note that their type systems are not strong enough, so the proofs are for reference only and have no practical significance.

#pagebreak()

= Example 1 (Assup): $A -> A$

Haskell witness:

```haskell
idP :: a -> a
idP x = x
```

Lean4 witness:

```lean
theorem ax1 : A -> A := fun a => a
```

Other:

```python
def id_p(x):
    return x
```

```cpp
auto id_p = [](auto x) { return x; };
```

#pagebreak()

= Example 2 (and Elim 1): $(A ∧ B) -> A$

Haskell:

```haskell
ax2 :: (a, b) -> a
ax2 (x, _) = x
```

Lean4:

```lean
theorem ax2 (A B : Prop) : A ∧ B -> A := fun h => h.left
```

C++ reference:

```cpp
auto ax2 = [](const auto& p) { return p.first; };
```

#pagebreak()

= Example 3 (and Elim 2): $(A ∧ B) -> B$

Haskell:

```haskell
ax3 :: (a, b) -> b
ax3 (_, y) = y
```

Lean4:

```lean
theorem ax3 (A B : Prop) : A ∧ B -> B := fun h => h.right
```

#pagebreak()

= Example 4 (or Intro 1): $A -> A ∨ B$

Haskell:

```haskell
ax4 :: a -> Either a b
ax4 x = Left x
```

Lean4:

```lean
theorem ax4 (A B : Prop) : A -> A ∨ B := fun a => Or.inl a
```

C++ reference:

```cpp
template <class A, class B> std::variant<A, B> ax4(A a) {
  return std::variant<A, B>{std::in_place_index<0>, a};
}
```

#pagebreak()

= Example 5 (or Intro 2): $B -> A ∨ B$

Haskell:

```haskell
ax5 :: b -> Either a b
ax5 y = Right y
```

Lean4:

```lean
theorem ax5 (A B : Prop) : B -> A ∨ B := fun b => Or.inr b
```

#pagebreak()

= Example 6 (or Elim)

Formula:

$(A -> C) -> (B -> C) -> (A ∨ B) -> C$

Haskell:

```haskell
ax6 :: (a -> c) -> (b -> c) -> Either a b -> c
ax6 f g e = case e of
  Left x  -> f x
  Right y -> g y
```

#pagebreak()

= Example 6 (or Elim)

Lean4:

/*
```lean
theorem ax6 (A B C : Prop) :
  (A -> C) -> (B -> C) -> (A ∨ B) -> C := by
  intro f g h
  cases h with
  | inl a => exact f a
  | inr b => exact g b
```
*/
```lean
theorem ax6 (A B C : Prop) :
  (A -> C) -> (B -> C) -> (A ∨ B) -> C := 
    (λ fl fr ab =>
      match ab with
      | .inl a => fl a
      | .inr b => fr b)
```

#pagebreak()

= Example 6 (or Elim)

C++ reference:

```cpp
template <class A, class B, class C, class FL, class FR>
C ax6(FL fl, FR fr, const std::variant<A, B>& e) {
  if (std::holds_alternative<A>(e)) return fl(std::get<A>(e));
  return fr(std::get<B>(e));
}
```

Case split in proof = pattern match in program.

#pagebreak()

= Example: Currying

`P × Q -> R` (uncurried) and `P -> Q -> R` (curried) are equivalent.

```haskell
toCurried :: ((p, q) -> r) -> p -> q -> r
toCurried h p q = h (p, q)

toUncurried :: (p -> q -> r) -> (p, q) -> r
toUncurried f (p, q) = f p q
```
/*
```cpp
auto to_curried = [](auto h) {
  return [h](auto p) { return [h, p](auto q) { return h(std::make_pair(p, q)); }; };
};
```
*/

```lean
example : (p → (q → r)) ↔ (p ∧ q → r) :=
  Iff.intro
    (λ f => λ h : p ∧ q => f h.1 h.2)
    (λ f => λ (hp : p) (hq : q) => f ⟨hp, hq⟩)
```

#pagebreak()

= forall and Pi-Type

Logic:

$forall x : A, P(x)$

Type-theoretic form:

$(x : A) -> P(x)$

When codomain depends on `x`, this is a Pi type.

#pagebreak()

= Rule Correspondence: `forall` / Pi

#text(size: 10pt)[
#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  stroke: 0.4pt,
  [*Logic (first-order)*],
  [*Dependent type theory*],
  [
    #text(size: 8pt)[(forall Intro)]
    $frac((Γ ⊢ P(x)), (Γ ⊢ forall x : A. P(x)))$
    #text(size: 5pt)[where `x` is not free in `Γ`]
  ],
  [
    #text(size: 8pt)[(Pi Intro)]
    $frac((Γ, x : A ⊢ t : P(x)), (Γ ⊢ lambda x. t : (x : A) -> P(x)))$
  ],
  [
    #text(size: 8pt)[(forall Elim)]
    $frac((Γ ⊢ forall x : A. P(x) quad Γ ⊢ a : A), (Γ ⊢ P(a)))$
  ],
  [
    #text(size: 8pt)[(Pi Elim / app)]
    $frac((Γ ⊢ f : (x : A) -> P(x) quad Γ ⊢ a : A), (Γ ⊢ f(a) : P(a)))$
  ],
)
]

`forall x : A, P(x)` corresponds to a function that returns one proof for each input `x`.

With Pi-Type (dependent arrow), $lambda_→$(STLC) natually extends to $lambda P$

#pagebreak()

= Lean4 Example of forall/Pi

eg1

```lean
theorem forall_id (P : A -> Prop) :
  (∀ x : A, P x -> P x) :=
    λ x (px : P x) => px
```

eg2

```lean
example  (α : Type u) (p q : α → Prop) :
  (∀ x, p x → q x) → (∀ x, p x) → (∀ x, q x) :=
    λ h hp => (λ x : α => h x (hp x))
```

One term works for every `x : A`.

#pagebreak()

= Lean4 Example: Dependent Predicate

Now the result proposition changes with the input `x`.

```lean
def Even (n : Nat) : Prop := ∃ k : Nat, n = k + k

theorem even_to_pair :
  ∀ x : Nat, Even x -> Even x ∧ Even (x + x) :=
    λ x hx => And.intro hx
      (Exists.intro x (Eq.refl (x + x)))
```

The proof is a dependent function:

`λ x hx => And.intro hx (Exists.intro x (Eq.refl (x + x)))`

`Exists.intro x ...` chooses `x` as the witness for `Even (x + x)`.

#pagebreak()

= Lean4 Example: Uniform Construction

Here the returned proof is built uniformly for every `x`.

```lean
theorem double_even :
  ∀ x : Nat, Even (x + x) :=
    λ x => Exists.intro x (Eq.refl (x + x))
```

`double_even 3` is a proof of `Even (3 + 3)`.

#pagebreak()

= Beyond STLC: Lambda Cube

#grid(
  columns: (1.25fr, 0.95fr),
  gutter: 0.45cm,
  [
    #text(size: 8.4pt)[
      #table(
        columns: (0.7fr, 1.5fr),
        inset: 5pt,
        stroke: 0.4pt,
        [*System*],
        [*Logic under Curry-Howard*],
        [$lambda_→$ / STLC],
        [intuitionistic propositional logic],
        [λP],
        [first-order intuitionistic predicate logic],
        [λ2 / System F],
        [second-order intuitionistic propositional logic],
        [λP2],
        [part of second-order predicate logic],
        [λC],
        [stronger higher-order dependent type theory / Calculus of Constructions],
      )
    ]
  ],
  [
    #align(center)[
      // #image("lambda-cube.svg", width: 6.3cm)
      #image("Lambda_Cube_img.svg", width: 6.0cm)
    ]
  ],
)

#text(size: 8.5pt)[
The systems in this talk live near the lower-left part: $lambda_→$ and $lambda P$.
]

#pagebreak()

#text(size: 28pt)[
  \
  \
  #align(center)[
    *Thanks for Listening !*
  ]
]

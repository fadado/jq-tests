module {
    name: "array/kleene",
    description: "Kleene closure for arrays as sets",
    namespace: "fadado.github.io",
    author: {
        name: "Joan Josep Ordinas Rosa",
        email: "jordinas@gmail.com"
    }
};

include "fadado.github.io/prelude";

########################################################################
# Types used in declarations:
#   SET: [a]
#   TUPLE: [a]

# ×, A ×, A × B, A × B × C, …
# Generates tuples
def product: #:: [SET] => +TUPLE
    def _product:
        if length == 1
        then
            .[0][] | [.]
        else
            .[0][] as $x
            | [$x] + (.[1:]|_product)
        end
    ;
    if length == 0 # empty product?
    then [] # empty tuple
    elif any(.[]; length==0) # A × ∅
    then empty               # ∅
    else _product
    end
;

# Aⁿ
# W(n,k) = kⁿ
def power($n): #:: SET|(number) => +TUPLE
# assert $n >= 0
    if $n == 0 # A⁰
    then []    # empty tuple
    elif length == 0 # A × ∅
    then empty       # ∅
    else
        . as $set
        | [range($n) | $set]
        | product
    end
;

# Generates K*: K⁰ ∪ K¹ ∪ K² ∪ K³ ∪ K⁴ ∪ K⁵ ∪ K⁶ ∪ K⁷ ∪ K⁸ ∪ K⁹…
# Specifically, words over an alphabet Σ (Σ*: Σ⁰ ∪ Σ¹ ∪ Σ²…)
def star: #:: SET => +TUPLE
    power(range(0; infinite))
#   . as $set
#   | if length == 0
#   then []
#   else []|deepen(.[length]=$set[])
#   end
;

#def star: #:: string => +string
#    def k: "", .[] + k;
#    if length == 0 then .  else (./"")|k end
#;

# Generates K⁺: K¹ ∪ K² ∪ K³ ∪ K⁴ ∪ K⁵ ∪ K⁶ ∪ K⁷ ∪ K⁸ ∪ K⁹…
# Specifically, words over an alphabet Σ without empty word (Σ⁺: Σ¹ ∪ Σ²…)
def plus: #:: SET => *TUPLE
    power(range(1; infinite))
#   . as $set
#   | if length == 0
#   then empty
#   else deepen(.[]|[.]; .[length]=$set[])
#   end
;

# vim:ai:sw=4:ts=4:et:syntax=jq

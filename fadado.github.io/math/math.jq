module {
    name: "math",
    description: "Miscelaneous mathematical functions",
    namespace: "fadado.github.io",
    author: {
        name: "Joan Josep Ordinas Rosa",
        email: "jordinas@gmail.com"
    }
};

include "fadado.github.io/prelude";
include "fadado.github.io/types";

########################################################################
# Simple utilities

def even($n): #:: (number) => boolean
    $n%2 == 0
;

def odd($n): #:: (number) => boolean
    $n%2 == 1
;

def gcd($m; $n): #:: (number;number) => number
    if $n == 0
    then $m
    else gcd($n; $m % $n)
    end
;

#def gcd($m; $n): #:: (number;number) => number
#    def step:
#        .x = .n      |
#        .n = .m % .n |
#        .m = .x
#        
#    ;
#    label $fence
#    | {$m, $n}
#    | recurse(step)
#    | select(.n == 0)
#    | .m, break $fence
#;

def mod($m; $n): #:: (number;number) => number
    ($m % $n)
    | if . < 0
      then . + $n end
;

def div($m; $n): #:: (number;number) => number
    ($m / $n) | trunc
;

def sign($n): #:: (number) => number
    $n|if isnan or (false==isnumber) then nan
    elif . > 0  then 1
    elif . == 0 then 0
                else -1
    end
;

def tobase($b): #:: number|(number) => ?string
    def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
    def div: (. / $b)|trunc;
    def mod: . % $b;
    def r: if . < $b then digit else (div|r)+(mod|digit) end;
    # do nothing if base out of range
    select(2 <= $b and $b <= 36)
    | r
;

# Inspired in https://www.rosettacode.org/wiki/URL_decoding#jq
def frombase($base): #:: string|(number) => number
    def downcase:
        if 65 <= . and . <= 90 then . + 32 end
    ;
    def toint: # "a" ~ 97 => 10 ~ 87
        if . > 96  then . - 87 else . - 48 end
    ;
    reduce (explode | reverse[] | downcase | toint) as $c
       ({power: 1, answer: 0};
        (.power * $base) as $b
        | .answer += (.power * $c)
        | .power = $b)
    | .answer
;

########################################################################
# Reductions on streams

def count(stream): #:: a|(a->*b) => number!
    reduce stream as $_
        (0; . + 1)
;

def sum(stream): #:: a|(a->*number) => number
    reduce stream as $item
        (0; . + $item)
;

def mul(stream): #:: a|(a->*number) => number
    reduce stream as $item
        (1; . * $item)
;

def max(stream): #:: a|(a->*number) => number
    reduce stream as $item
        (0-infinite; fmax($item; .))
;

def min(stream): #:: a|(a->*number) => number
    reduce stream as $item
        (infinite; fmin($item; .))
;

# vim:ai:sw=4:ts=4:et:syntax=jq

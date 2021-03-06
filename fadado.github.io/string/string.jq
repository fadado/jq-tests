module {
    name: "string",
    description: "Common string operations, some in the Icon language style",
    namespace: "fadado.github.io",
    author: {
        name: "Joan Josep Ordinas Rosa",
        email: "jordinas@gmail.com"
    }
};

include "fadado.github.io/prelude";
import "fadado.github.io/math" as math;

#
def remove($s): #:: string|(string) => string
    mapstr(reject(inside($s)))
;

########################################################################
# Fast concat and join only for string arrays

def join: #:: [string] => string
    reduce .[] as $s (""; . + $s)
;

def join($separator): #:: [string]|(string) => string
    def sep:
        if .==null
        then ""
        else .+$separator
        end
    ;
    reduce .[] as $s (null; sep + $s)
    // ""
;

########################################################################
# Conversions code <=> character

def ord($s): #:: (string) => number
    $s[0:1] | explode[0]
;

def char($n): #:: (number) => string
    [$n] | implode
;

########################################################################
# Pad strings

def left($n; $t): #:: string|(number;string) => string
    if $n > length
    then ($t*($n-length)) + . end
;
def left($n): #:: string|(number) => string
    left($n; " ")
;

def right($n; $t): #:: string|(number;string) => string
    if $n > length
    then . + ($t*($n-length)) end
;
def right($n): #:: string|(number) => string
    right($n; " ")
;

def center($n; $t): #:: string|(number;string) => string
    if $n > length then
        math::div($n-length; 2) as $i
        | ($t*$i) + . + ($t*$i)
        | if length != $n then .+$t end
    end
;
def center($n): #:: string|(number) => string
    center($n; " ")
;

########################################################################
# Classical trim and strip

def _lndx(predicate): # left index or empty if not found
    label $fence
    | range(0;length-1) as $i
    | reject(.[$i:$i+1] | predicate)
    | ($i , break $fence)
;

def _rndx(predicate): # rigth index or empty if not found
    label $fence
    | range(length-1;0;-1) as $i
    | reject(.[$i:$i+1] | predicate)
    | ($i+1 , break $fence)
;

def lstrip($s): #:: string|(string) => string
    if length != 0 and (.[0:1] | inside($s)) then
        (_lndx(inside($s)) // -1) as $i |
        if $i < 0 then "" else .[$i:] end
    end
;

def rstrip($s): #:: string|(string) => string
    if length != 0 and (.[-1:length] | inside($s)) then
        (_rndx(inside($s)) // -1) as $i |
        if $i < 0 then "" else .[0:$i] end
    end
;

def strip($s): #:: string|(string) => string
    if length != 0 and ((.[0:1] | inside($s)) or (.[-1:length] | inside($s))) then
        (_lndx(inside($s)) // -1) as $i |
        (_rndx(inside($s)) // -1) as $j |
        if $i < 0 and $j < 0 then ""
        elif $j < 0          then .[$i:]
        elif $i < 0          then .[:$j]
                             else .[$i:$j]
        end
    end
;

def trim: #:: string| => string
    strip(" \t\r\n\f")
;
def ltrim: #:: string| => string
    lstrip(" \t\r\n\f")
;
def rtrim: #:: string| => string
    rstrip(" \t\r\n\f")
;

# vim:ai:sw=4:ts=4:et:syntax=jq

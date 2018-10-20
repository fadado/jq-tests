module {
    name: "string/table",
    description: "Translation tables in the SNOBOL language style",
    namespace: "fadado.github.io",
    author: {
        name: "Joan Josep Ordinas Rosa",
        email: "jordinas@gmail.com"
    }
};

include "fadado.github.io/prelude";
import "fadado.github.io/string/ascii" as ascii;
import "fadado.github.io/object/set" as set;

########################################################################
# Translation tables

# Translate/remove tables
def new($from; $to): #:: (string;string) => {string}
   ($from/"") as $s
   | ($to/"") as $t
   | reduce range(0;$s|length) as $i
        ({}; . += {($s[$i]):($t[$i]//"")})
;

# Preserve tables
def preserve($from; $preserve): #:: (string;string) => {string}
   set::new($preserve) as $t
   | reduce (($from/"") | unique)[] as $c
        ({}; . += (if $t[$c] then null else {($c):""} end))
;

# Translate characters in input string using translation table
def translate($table): #:: string|({string}) => string
    mapstr($table[.]//.)
;

def translate($from; $to): #:: string|(string;string) => string
    translate(new($from; $to))
;

# Translation table to rotate by 13 places
def rot13: #:: {string}
    def rotate: .[13:] + .[:13];
    new(ascii::ALPHA;
        (ascii::upper|rotate) + (ascii::lower|rotate))
;

# rot13:    s|translate(rot13)
# toggle:   s|translate(new(latin1::ALPHA; latin1::alpha))
# remove:   s|translate("to delete"; "")
# preserve: s|translate(s|translate("to preserve"; "")); "")
# preserve: s|translate(preserve(s; "to preserve"))

# vim:ai:sw=4:ts=4:et:syntax=jq

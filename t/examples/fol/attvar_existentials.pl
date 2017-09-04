
% Load with  ?- consult(pack(logicmoo_base/t/examples/fol/attvar_existentials)).
%:- if(\+ current_module(baseKB)).
:- module(kbt,[]).

:- ensure_loaded(library(pfc)).
:- ensure_loaded(library(dictoo)).
:- ensure_loaded(library(logicmoo_clif)).
% :- include(test_header).

:- '$current_source_module'(M),ensure_abox(M).

:- listing(ls).

:- fav_debug.
:- '$current_source_module'(M),install_retry_undefined(M,error).


% :- process_this_script_with(compile_dynamic).

%:- endif.


% =================
% examples
% =================


tbl(1):- 
   P = (loves(joe,mary) <=> ((exists([R,X,Y,T], 
  ((subRelation(R,loves), is_a(T,time), is_a(T,context),exists_durring(X,T),exists_durring(Y,T), 
              ~different(joe,X),~different(mary,Y)) => trueIn(T,holds(R,X,Y))))))),
   must(test_boxlog(P)),
   must(assert_ex(P)).

tbl(2):- P = exists([R,X,Y,T], 
  ((subRelation(R,loves), is_a(T,time), is_a(T,context),exists_durring(X,T),exists_durring(Y,T), 
              ~different(joe,X),~different(mary,Y)) => trueIn(T,holds(R,X,Y)))),
   must(test_boxlog(P)),
   must(assert_ex(P)).


f(0):- assert_ex(loves(joe,mary)).




:- discontiguous(tstit/1).
:- discontiguous(f/1).
:- discontiguous(r/1).


f(1):- assert_ex(man("John")).

tstit(0) :- clr, f(1), 
   test_count(man(_),1).


f(1.1):- assert_ex(ex(X,(nameOf(X,"John"), man(X)))).   % same comment as as f8
f(1.2):- assert_ex(atleast(1,X,(man(X),nameOf(X,"John")))).   % constraining by identity relly meant only 1

f(2):- assert_ex(man("Joe")).   % man number 2
f(2.1):- assert_ex(ex(X,(nameOf(X,"Joe"), man(X)))).   % same comment as as f8
f(2.2):- assert_ex(atleast(1,X,(man(X),nameOf(X,"Joe")))).   % constraining by identity relly meant only 1

f(3):- assert_ex(room("ThreeThirty")).

f(4):- assert_ex(room("OneTwenty")).

f(5):- assert_ex(ex(Child,(man(Child),child(Child)))).  % Look, its a man child!
f(5.1):- assert_ex(ex(Child,child(Child))). % would this create a second child?

f(6):- assert_ex(ex(P,((man(P);female(P)),nameOf(P,"Pat")))).  % Two *different* constraint paths for a single identity
f(6.1):- assert_ex(ex(P,(man(P);female(P)))).  % Two constraint paths



tstit(1) :- tstit(0), f(2),
   test_count(man(_),1).

tstit(2) :- tstit(1), f(3),
   test_count(man(_),1).

tstit(3) :- tstit(2), f(4),
   test_count(man(_),2).

tstit(4) :- tstit(3), f(5),
   test_count(man(_),2).
                    

:- dynamic(r/1).

r(1):- (assert_ex(
  ex(Mary,
    ex(John,
   (   female(Mary),
       nameOf(Mary,"Mary"),
       man(John),
       nameOf(John,"John"),
       loves(John,Mary)))))).


r(2):- assert_ex((
 ex(God,
    ex(Mary,
   (   female(Mary),
       nameOf(Mary,"Mary"),
       god(God),
       nameOf(God,"AlFaqa"),
       loves(Mary,God)))))).

r(3):- assert_ex(
  all(Child,
    ex(Mother,
   (   child(Child),
       female(Mother),
       nameOf(Child,childOf(Mother)),       
       mother(Child,Mother))))).

r(4):- assert_ex(all(R,implies(room(R),exists(D,and(door(D),has(R,D)))))).


afr:- forall((clause(f(N),Body),integer(N)),Body), forall((clause(r(N),Body),integer(N)),Body), lr.



tstit:- forall(tstit(_),true).

:- fixup_exports.

:- set_prolog_flag(write_attributes,ignore).
:- ensure_loaded(library(attvar_reader)).
:- '$current_source_module'(M),install_retry_undefined(M,kbi_define).

:- 
 writeln("

:- afr.
:- make_type(female).
% :- make_type(god).
:- make_type(man).
:- make_identity(nameOf).  % Evil? come on, just needed something here
:- make_type(loves/2).

Examples:

?- 
   female(Whom).

?- female(Whom).

?- test_all.

assuming mltt stops short of aristotelian logic which requires intensional equivalence to prove ranking 
of subtyping (for example a married man is also a man)

:- '$current_source_module'(M),install_retry_undefined(M,kbi_define).


"
).


































































end_of_file.


kbt:  ?- man(X).
add_dom(X, [man, made_skolem(X, skIsJohnNameOf_0FnSk), nameOf(X, "John")]) ;
add_dom(X, [man, made_skolem(X, skIsJoeNameOf_0FnSk), nameOf(X, "Joe")]) ;
add_dom(X, [man, child, made_skolem(X, skIsChildIsExists_0FnSk)]) ;
false.


 female(X).
add_dom(X, [female, made_skolem(X, skIsFemaleIsExistsNameOf_0FnSk), nameOf(X, "Pat")]) ;
  add_dom(X, [female, made_skolem(X, skIsFemaleExistsNameOfLoves_0FnSk), nameOf(X, "Mary"), loves(_27578664, X)]),
add_dom(_27578664, [man, made_skolem(_27578664, skIsJohnNameOf_0FnSk), nameOf(_27578664, "John")]) ;
  add_dom(X, [female, made_skolem(X, skIsFemaleExistsNameOfLoves_0FnSk), nameOf(X, "Mary"), loves(_27581410, X)]),
add_dom(_27581410, [man, child, made_skolem(_27581410, skIsChildIsExists_0FnSk), nameOf(_27581410, "John")]) ;
  add_dom(X, [female, made_skolem(X, skIsChildofIsFemaleExistsNameOfMother_0FnSk(_27586180)), nameOf(_27586180, childOf(X)), mother(_27586180, X)]) ;
false.

kbt:  ?- room(X).
add_dom(X, [room, made_skolem(X, skIsRoomThreeThirtyNameOf_0FnSk), nameOf(X, "ThreeThirty")]) ;
add_dom(X, [room, made_skolem(X, skIsRoomOneTwentyNameOf_0FnSk), nameOf(X, "OneTwenty")]) ;
false.


kbt:  ?- door(X).
% kbi_define(kbt:door/1).
add_dom(X, [door, made_skolem(X, skIsDoorExistsHas_0FnSk(_27566860)), has(_27566860, X)]),
 add_dom(_27566860, [room, made_skolem(_27566860, skIsRoomThreeThirtyNameOf_0FnSk), nameOf(_27566860, "ThreeThirty")]) ;
add_dom(X, [door, made_skolem(X, skIsDoorExistsHas_0FnSk(_27568268)), has(_27568268, X)]),
 add_dom(_27568268, [room, made_skolem(_27568268, skIsRoomOneTwentyNameOf_0FnSk), nameOf(_27568268, "OneTwenty")]) ;
false.


kbt:  ?- lr.
:- dynamic baseKB:producing/1.
:- multifile baseKB:producing/1.
:- public baseKB:producing/1.
:- module_transparent baseKB:producing/1.


:- dynamic producing/1.
:- multifile producing/1.
:- public producing/1.
:- module_transparent producing/1.

producing(A) :-
        inherit_above(kbt, producing(A)).
producing(loves(_, _)).
producing(nameOf(_, "Joe")).
producing(nameOf(_, "Mary")).
producing(man(_)).
producing(nameOf(_, "John")).
producing(room(_)).
producing(nameOf(_, "ThreeThirty")).
producing(nameOf(_, "OneTwenty")).
producing(child(_)).
producing(female(_)).
producing(nameOf(_, "Pat")).
producing(god(_)).
producing(nameOf(_, "AlFaqa")).
producing(mother(_, _)).
producing(nameOf(_, childOf(_))).
producing(door(_)).
producing(has(_, _)).

:- dynamic baseKB:duce_tru/1.
:- multifile baseKB:duce_tru/1.
:- public baseKB:duce_tru/1.
:- module_transparent baseKB:duce_tru/1.


:- dynamic duce_tru/1.
:- multifile duce_tru/1.
:- public duce_tru/1.
:- module_transparent duce_tru/1.

duce_tru(A) :-
        inherit_above(kbt, duce_tru(A)).
duce_tru(loves(B, A)) :-
        skolem(A, skMaryNameOfLoves_1FnSk(B)),
        skolem(B, skJoeNameOfLovesExists_0FnSk).
duce_tru(nameOf(A, "Joe")) :-
        skolem(A, skJoeNameOfLovesExists_0FnSk).
duce_tru(nameOf(A, "Mary")) :-
        skolem(A, skMaryNameOfLoves_1FnSk(B)),
        skolem(B, skJoeNameOfLovesExists_0FnSk).
duce_tru(man(A)) :-
        skolem(A, skIsJohnNameOf_0FnSk).
duce_tru(nameOf(A, "John")) :-
        skolem(A, skIsJohnNameOf_0FnSk).
duce_tru(man(A)) :-
        skolem(A, skIsJoeNameOf_0FnSk).
duce_tru(nameOf(A, "Joe")) :-
        skolem(A, skIsJoeNameOf_0FnSk).
duce_tru(room(A)) :-
        skolem(A, skIsRoomThreeThirtyNameOf_0FnSk).
duce_tru(nameOf(A, "ThreeThirty")) :-
        skolem(A, skIsRoomThreeThirtyNameOf_0FnSk).
duce_tru(room(A)) :-
        skolem(A, skIsRoomOneTwentyNameOf_0FnSk).
duce_tru(nameOf(A, "OneTwenty")) :-
        skolem(A, skIsRoomOneTwentyNameOf_0FnSk).
duce_tru(child(A)) :-
        skolem(A, skIsChildIsExists_0FnSk).
duce_tru(man(A)) :-
        skolem(A, skIsChildIsExists_0FnSk).
duce_tru(female(A)) :-
        skolem(A, skIsFemaleIsExistsNameOf_0FnSk),
        proven_not_tru(man(A)).
duce_tru(man(A)) :-
        skolem(A, skIsFemaleIsExistsNameOf_0FnSk),
        proven_not_tru(female(A)).
duce_tru(nameOf(A, "Pat")) :-
        skolem(A, skIsFemaleIsExistsNameOf_0FnSk).
duce_tru(female(A)) :-
        skolem(A, skIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(man(A)) :-
        skolem(A, skIsExistsNameOfLoves_1FnSk(B)),
        skolem(B, skIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(loves(A, B)) :-
        skolem(A, skIsExistsNameOfLoves_1FnSk(B)),
        skolem(B, skIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(nameOf(A, "Mary")) :-
        skolem(A, skIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(nameOf(A, "John")) :-
        skolem(A, skIsExistsNameOfLoves_1FnSk(B)),
        skolem(B, skIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(female(A)) :-
        skolem(A, skIsGodIsFemaleExistsNameOfLoves_1FnSk(B)),
        skolem(B, skIsGodIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(god(A)) :-
        skolem(_, skIsGodIsFemaleExistsNameOfLoves_1FnSk(A)),
        skolem(A, skIsGodIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(loves(A, B)) :-
        skolem(A, skIsGodIsFemaleExistsNameOfLoves_1FnSk(B)),
        skolem(B, skIsGodIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(nameOf(A, "AlFaqa")) :-
        skolem(_, skIsGodIsFemaleExistsNameOfLoves_1FnSk(A)),
        skolem(A, skIsGodIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(nameOf(A, "Mary")) :-
        skolem(A, skIsGodIsFemaleExistsNameOfLoves_1FnSk(B)),
        skolem(B, skIsGodIsFemaleExistsNameOfLoves_0FnSk).
duce_tru(female(A)) :-
        skolem(A,
                    skIsChildofIsFemaleExistsNameOfMother_0FnSk(_)).
duce_tru(mother(B, A)) :-
        skolem(A,
                    skIsChildofIsFemaleExistsNameOfMother_0FnSk(B)).
duce_tru(nameOf(B, childOf(A))) :-
        skolem(A,
                    skIsChildofIsFemaleExistsNameOfMother_0FnSk(B)).
duce_tru(door(A)) :-
        skolem(A, skIsDoorExistsHas_0FnSk(B)),
        room(B).
duce_tru(has(B, A)) :-
        skolem(A, skIsDoorExistsHas_0FnSk(B)),
        room(B).


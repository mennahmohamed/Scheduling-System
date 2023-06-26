ta_slot_assignment([ta(N,L)|T],[ta(N,L1)|T],N):- L>0,L1 is L-1.

ta_slot_assignment([ta(N,L)|T],[ta(N,L)|T1],N1):-N1\=N, ta_slot_assignment(T,T1,N1).

slot_assignment(LabsNum,TAs,RemTAs,Assignment):-
                     helper_slot(LabsNum,TAs,TAs,[],RemTAs, Assign),
                     permutation(Assign,Assignment).

helper_slot(0,_,R1,R2,R1,R2).
helper_slot(N,[ta(Name,_)|T],Modified,Assig,R1,R2):-N>0, 
ta_slot_assignment(Modified,Res,Name), N1 is N-1, 
helper_slot(N1,T,Res,[Name|Assig],R1,R2).

helper_slot(N,[_|T],Modified,Assig,R1,R2):-N>0,helper_slot(N,T,Modified,Assig,R1,R2).

                     
max_slots_per_day(L,Max):-
           flatten(L,R),
           helper_max_slots(R,Max). 
      
helper_max_slots([],_).
helper_max_slots([H|T],Max):-
           count(H,[H|T],R,[],Modified), R=<Max,helper_max_slots(Modified,Max).

count(_,[],0,L,L).
count(H,[H|T],C,L,Modified):-count(H,T,C1,L,Modified),C is C1+1.
count(H,[X|T],C,L,Modified):-count(H,T,C,[X|L],Modified), H\=X.



day_schedule([],T,T,[]).
day_schedule([H|T],TAs,RemTAs,[H1|T1]):-
          slot_assignment(H,TAs,UpdatedRem,H1),
          day_schedule(T,UpdatedRem,RemTAs,T1).
   

week_schedule([],_,_,[]).
week_schedule([H|T],TAs,DayMax,[H1|T1]):-
          day_schedule(H,TAs,RemTAs,H1),
          max_slots_per_day(H1,DayMax),
          week_schedule(T,RemTAs,DayMax,T1).
          
     



           
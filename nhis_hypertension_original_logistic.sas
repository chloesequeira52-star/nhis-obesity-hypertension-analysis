/* STEP 1: Import ONLY first 1000 rows for faster testing */  
proc import datafile="/home/u64136090/sasuser.v94/adult24.csv"  
    out=work.proj3_raw_full  
    dbms=csv  
    replace;  
    guessingrows=1000;  
run;  
 
/* Create a smaller dataset (first 1000 rows) */  
data work.proj3_raw;  
    set work.proj3_raw_full (obs=1000);  
run; 
/* Check first 20 rows */  
proc print data=work.proj3_raw (obs=20);  
run;  
 
/* View variable names and metadata */  
proc contents data=work.proj3_raw varnum;  
run;  
 
/* Frequency tables for raw variables */ 
proc freq data=work.proj3_raw;  
    tables HYPEV_A BMICAT_A SEX_A RACEALLP_A;  
run; 
/* STEP 3: Create clean analytic dataset */  
data work.proj3_clean;  
    set work.proj3_raw;  
 
    /* Outcome: Hypertension */  
    if HYPEV_A = 1 then hypertension = 1;  

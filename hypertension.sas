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

/* View variable names */
proc contents data=work.proj3_raw varnum;
run;
proc freq data=work.proj3_raw;
    tables HYPEV_A BMICAT_A SEX_A RACEALLP_A;
run;
/* STEP 3: Create clean analytic dataset */

data work.proj3_clean;
    set work.proj3_raw;

    /* Outcome: Hypertension */
    if HYPEV_A = 1 then hypertension = 1;
    else if HYPEV_A = 2 then hypertension = 0;
    else hypertension = .;

    /* Exposure: Obesity */
    if BMICAT_A = 4 then obese = 1;
    else if BMICAT_A in (1,2,3) then obese = 0;
    else obese = .;

    /* Sex */
    if SEX_A = 1 then male = 1;
    else if SEX_A = 2 then male = 0;

    /* Race: White vs Non-White */
    if RACEALLP_A = 1 then white = 1;
    else if RACEALLP_A in (2,3,4,5,6,7,8) then white = 0;
    else white = .;

    /* Age */
    age = AGEP_A;

    /* Keep only complete cases */
    if hypertension ne . and obese ne . and male ne . and white ne . and age ne .;

run;
proc freq data=work.proj3_clean;
    tables hypertension obese male white;
run;

proc means data=work.proj3_clean;
    var age;
run;
/* STEP 4: Logistic Regression */

proc logistic data=work.proj3_clean descending;
    class male (ref='0') white (ref='1') / param=ref;

    model hypertension = obese age male white;

run;
/* STEP 5: Add interaction (obesity * sex) */

proc logistic data=work.proj3_clean descending;
    class male (ref='0') white (ref='1') / param=ref;

    model hypertension = obese age male white obese*male;

run;

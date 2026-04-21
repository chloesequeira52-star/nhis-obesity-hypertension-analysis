/* STEP 1: Import full NHIS dataset */

proc import datafile="/home/u64136090/sasuser.v94/adult24.csv"
    out=work.proj3_raw_full
    dbms=csv
    replace;
    guessingrows=max;
run;

/* OPTIONAL: smaller test dataset for quick debugging */
data work.proj3_raw_test;
    set work.proj3_raw_full (obs=1000);
run;

/* Check variable names */
proc contents data=work.proj3_raw_full varnum;
run;
/* STEP 3: Create clean analytic dataset */

data work.proj3_clean;
    set work.proj3_raw_full;

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
    else male = .;

    /* Race: White vs Non-White */
    if RACEALLP_A = 1 then white = 1;
    else if RACEALLP_A in (2,3,4,5,6,7,8) then white = 0;
    else white = .;

    /* Age */
    age = AGEP_A;

    /* Keep survey design variables */
    weight = WTFA_A;
    strata = PSTRAT;
    cluster = PPSU;

    /* Keep only complete cases */
    if hypertension ne . and obese ne . and male ne . and white ne . and age ne . 
       and weight ne . and strata ne . and cluster ne .;
run;
proc surveyfreq data=work.proj3_clean;
    strata strata;
    cluster cluster;
    weight weight;
    tables hypertension obese male white;
run;

proc surveymeans data=work.proj3_clean mean stderr;
    strata strata;
    cluster cluster;
    weight weight;
    var age;
run;
/* STEP 4: Survey-weighted logistic regression */

proc surveylogistic data=work.proj3_clean;
    strata strata;
    cluster cluster;
    weight weight;

    class obese (ref='0')
          male  (ref='0')
          white (ref='1') / param=ref;

    model hypertension(event='1') = obese age male white;
run;
/* STEP 5: Test interaction between obesity and sex */

proc surveylogistic data=work.proj3_clean;
    strata strata;
    cluster cluster;
    weight weight;

    class obese (ref='0')
          male  (ref='0')
          white (ref='1') / param=ref;

    model hypertension(event='1') = obese age male white obese*male;
run;

/* Stratified model: females only */
proc surveylogistic data=work.proj3_clean;
    where male = 0;
    strata strata;
    cluster cluster;
    weight weight;

    class obese (ref='0')
          white (ref='1') / param=ref;

    model hypertension(event='1') = obese age white;
run;

/* Stratified model: males only */
proc surveylogistic data=work.proj3_clean;
    where male = 1;
    strata strata;
    cluster cluster;
    weight weight;

    class obese (ref='0')
          white (ref='1') / param=ref;

    model hypertension(event='1') = obese age white;
run;

/* STEP 6: Sensitivity analysis using Poisson regression with robust variance */

proc genmod data=work.proj3_clean descending;

    class obese (ref='0') 
          male (ref='0') 
          white (ref='1')
          cluster;

    model hypertension = obese age male white / dist=poisson link=log;

    repeated subject=cluster / type=ind;

    weight weight;

run;

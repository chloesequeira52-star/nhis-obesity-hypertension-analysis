/* Analytic dataset built from their recode logic (nhis_hypertension_survey_analysis.sas, STEP 3).
   The external NHIS import (proc import of adult24.csv) is replaced with a small mock
   sample carrying the same NHIS variables so the recode + PROCs run standalone. */
data work.proj3_clean;
    input HYPEV_A BMICAT_A SEX_A RACEALLP_A AGEP_A WTFA_A PSTRAT PPSU;

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
    datalines;
2 3 2 1 26 1211 10 1
1 4 2 2 29 2021 11 2
1 4 1 3 51 1400 12 3
1 1 2 1 78 1215 13 4
2 4 1 1 40 1036 10 1
2 2 2 3 60 2128 11 2
2 4 2 3 40 1097 12 3
2 4 2 4 24 1110 13 4
1 4 2 4 32 769 10 1
2 1 2 1 48 1859 11 2
2 1 1 1 55 2108 12 3
2 3 2 1 55 909 13 4
2 1 1 3 63 1304 10 1
2 2 1 1 52 1903 11 2
2 1 2 1 19 2017 12 3
2 1 2 1 57 929 13 4
1 4 2 1 54 1712 10 1
1 4 1 3 66 1034 11 2
1 2 1 1 33 1916 12 3
2 1 1 4 38 1731 13 4
2 2 2 3 71 1217 10 1
1 4 2 1 24 1843 11 2
1 1 2 2 65 1269 12 3
2 3 1 1 19 1999 13 4
2 4 1 1 20 903 10 1
1 4 1 1 28 1948 11 2
2 3 2 3 51 1170 12 3
2 3 2 2 51 1523 13 4
2 2 1 2 45 1394 10 1
2 2 2 4 29 1872 11 2
2 4 1 1 59 1455 12 3
2 4 2 1 81 1262 13 4
2 2 1 4 48 1592 10 1
2 4 2 3 52 1885 11 2
1 2 2 1 61 1940 12 3
2 1 1 2 39 1791 13 4
2 3 2 4 24 2017 10 1
2 1 2 1 37 727 11 2
2 2 1 2 48 1407 12 3
2 2 2 1 25 1881 13 4
2 2 2 2 34 1845 10 1
2 2 2 1 59 1653 11 2
2 4 1 1 55 1559 12 3
1 1 2 1 23 738 13 4
1 4 1 1 73 1708 10 1
2 3 2 4 77 1577 11 2
2 4 2 1 69 1427 12 3
1 4 1 3 64 2140 13 4
2 4 2 4 19 1352 10 1
2 3 2 4 24 1632 11 2
2 2 2 3 23 2065 12 3
1 2 2 1 67 1169 13 4
1 4 2 1 30 1993 10 1
2 4 2 3 54 1404 11 2
2 2 2 1 51 1141 12 3
2 3 2 2 71 803 13 4
2 4 2 3 75 713 10 1
2 4 2 2 57 1570 11 2
2 4 1 1 84 1373 12 3
2 4 2 1 51 2115 13 4
2 4 1 3 57 1824 10 1
2 3 2 1 30 1380 11 2
2 4 2 1 30 2032 12 3
2 4 1 3 83 1235 13 4
2 4 1 3 59 2185 10 1
2 3 1 1 66 1150 11 2
2 2 2 1 69 1253 12 3
2 2 2 1 26 1808 13 4
2 3 1 1 39 1892 10 1
2 3 2 1 42 2087 11 2
2 2 1 2 28 1426 12 3
2 4 2 1 47 838 13 4
2 4 2 2 25 1332 10 1
1 2 2 3 75 840 11 2
2 3 1 1 53 2055 12 3
1 4 1 3 69 1019 13 4
2 4 1 3 51 1647 10 1
1 4 1 1 21 1454 11 2
2 1 2 1 44 1528 12 3
1 3 1 1 72 936 13 4
2 2 1 1 77 754 10 1
2 4 1 3 82 832 11 2
1 2 2 1 45 1670 12 3
2 2 1 1 34 1236 13 4
2 4 2 4 31 2028 10 1
2 1 2 1 58 1591 11 2
2 2 2 4 52 1920 12 3
2 3 2 1 32 1889 13 4
2 3 2 1 35 1753 10 1
2 4 1 1 70 1155 11 2
;
run;

/* Sensitivity analysis: Poisson regression with robust variance -> prevalence ratios (STEP 6) */
proc genmod data=work.proj3_clean descending;

    class obese (ref='0') 
          male (ref='0') 
          white (ref='1')
          cluster;

    model hypertension = obese age male white / dist=poisson link=log;

    repeated subject=cluster / type=ind;

    weight weight;

run;

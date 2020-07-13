Collapsing nested headers in proc report with output sas dataset                                                                   
                                                                                                                                   
"Here I have 2 arms, with the count of each grade and then the total.                                                              
I have also included N, which is the number of patients per arm. I would                                                           
like to use proc report with ARM as an across variable like this"                                                                  
                                                                                                                                   
The op also wants to sum the across variables so we will have just one output observation.                                         
Also wants TOTAL(N=#) for ARM1 and ARM2                                                                                            
                                                                                                                                   
       Method                                                                                                                      
          1. Uses my macro, utl_odsrpt with a title statement with column headers separed by '|'                                   
          2, Use options  "proc report data=have nowd missing noheader box formchar='|';"                                          
                           title "|ARM1_GRADE1 | ARM1_GRADE2 | ARM1_TOTAL | ARM2_GRADE1 | ARM2_GRADE2 | ARM2_TOTAL|";              
          3. Use sql to put the counts you eant into macro variables                                                               
          4. Finally run proc report changing the one column header                                                                
             define ARM1_TOTAL / display "TOTAL#(N=&ARM1_TOTAL)" width=7;                                                          
github                                                                                                                             
https://tinyurl.com/y92ez8p4                                                                                                       
https://github.com/rogerjdeangelis/utl-collapsing-nested-headers-in-proc-report-with-output-sas-dataset                            
                                                                                                                                   
                                                                                                                                   
                                                                                                                                   
StackOverflow                                                                                                                      
https://tinyurl.com/y9rfxr7r                                                                                                       
https://stackoverflow.com/questions/62868166/different-labels-for-variables-split-by-across-variable-in-proc-report                
                                                                                                                                   
macros                                                                                                                             
https://tinyurl.com/y9nfugth                                                                                                       
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                                         
                                                                                                                                   
                                                                                                                                   
related repos                                                                                                                      
https://tinyurl.com/yacj4g7c                                                                                                       
https://github.com/rogerjdeangelis?tab=repositories&q=in%3Areadme+utl_odsfrq&type=&language=                                       
                                                                                                                                   
/*                   _                                                                                                             
(_)_ __  _ __  _   _| |_                                                                                                           
| | `_ \| `_ \| | | | __|                                                                                                          
| | | | | |_) | |_| | |_                                                                                                           
|_|_| |_| .__/ \__,_|\__|                                                                                                          
        |_|                                                                                                                        
*/                                                                                                                                 
                                                                                                                                   
data have;                                                                                                                         
    input ARM GRADE1 GRADE2 TOTAL N;                                                                                               
cards4;                                                                                                                            
1 0 1 1 2                                                                                                                          
1 1 0 1 2                                                                                                                          
2 1 2 3 3                                                                                                                          
2 1 1 2 3                                                                                                                          
2 0 1 1 3                                                                                                                          
;;;;                                                                                                                               
run;quit;                                                                                                                          
                                                                                                                                   
WORK.HAVE total obs=5                                                                                                              
                                                                                                                                   
  ARM    GRADE1    GRADE2    TOTAL    N                                                                                            
                                                                                                                                   
   1        0         1        1      2                                                                                            
   1        1         0        1      2                                                                                            
   2        1         2        3      3                                                                                            
   2        1         1        2      3                                                                                            
   2        0         1        1      3                                                                                            
                                                                                                                                   
/*           _               _                                                                                                     
  ___  _   _| |_ _ __  _   _| |_                                                                                                   
 / _ \| | | | __| `_ \| | | | __|                                                                                                  
| (_) | |_| | |_| |_) | |_| | |_                                                                                                   
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                  
                |_|                                                                                                                
*/                                                                                                                                 
                                                                                                                                   
                                                                                                                                   
Since I create a output dataset from proc report, you can easily format the                                                        
output any way you want. If yoy want othe multi-level headings just                                                                
group the column variables witf nested parens.                                                                                     
                                                                                                                                   
                                                                           | RULE                                                  
                                                                           |                                                       
                             TOTAL                                   TOTAL | Create this header                                    
ARM1_GRADE1   ARM1_GRADE2    (N=2)      ARM2_GRADE1   ARM2_GRADE2    (N=3) | stacked                                               
          1             1        2                2             4        3 |                                                       
                                                                           |                                                       
                                                                                                                                   
/*                                                                                                                                 
 _ __  _ __ ___   ___ ___  ___ ___                                                                                                 
| `_ \| `__/ _ \ / __/ _ \/ __/ __|                                                                                                
| |_) | | | (_) | (_|  __/\__ \__ \                                                                                                
| .__/|_|  \___/ \___\___||___/___/                                                                                                
|_|                                                                                                                                
*/                                                                                                                                 
                                                                                                                                   
data have;                                                                                                                         
    input ARM GRADE1 GRADE2 TOTAL N;                                                                                               
cards4;                                                                                                                            
1 0 1 1 2                                                                                                                          
1 1 0 1 2                                                                                                                          
2 1 2 3 3                                                                                                                          
2 1 1 2 3                                                                                                                          
2 0 1 1 3                                                                                                                          
;;;;                                                                                                                               
run;quit;                                                                                                                          
                                                                                                                                   
options ls=255;                                                                                                                    
%utl_odsrpt(setup);                                                                                                                
proc report data=have nowd missing noheader box formchar='|';                                                                      
title "|ARM1_GRADE1 | ARM1_GRADE2 | ARM1_TOTAL | ARM2_GRADE1 | ARM2_GRADE2 | ARM2_TOTAL|";                                         
  column ARM, (GRADE1 GRADE2 TOTAL,(N));                                                                                           
  define ARM / across;                                                                                                             
run;quit;                                                                                                                          
%utl_odsrpt(outdsn=wantrpt);                                                                                                       
                                                                                                                                   
proc sql;                                                                                                                          
  select ARM1_TOTAL,  ARM2_TOTAL                                                                                                   
  into  :ARM1_TOTAL trimmed, :ARM2_TOTAL trimmed                                                                                   
  from wantrpt                                                                                                                     
;quit;                                                                                                                             
                                                                                                                                   
title;                                                                                                                             
proc report data=wantrpt nowd missing split="#";                                                                                   
define ARM1_TOTAL / display "TOTAL#(N=&ARM1_TOTAL)" width=12;                                                                      
define ARM2_TOTAL / display "TOTAL#(N=&ARM2_TOTAL)" width=12;                                                                      
run;quit;                                                                                                                          
                                                                                                                                   
                                                                                                                                   

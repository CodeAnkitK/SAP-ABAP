1.  This data type has a default length of one and a blank default value.\
A: I\
B: N\
**C: C**\
D: D

2.      The event that is processed after all data has been read but before the list is displayed is:\
**A: END-OF-PAGE.**\
B: START-OF-SELECTION.\
C: END-OF-SELECTION.\
D: AT LINE-SELECTION.

3.      The business (non-technical) definition of a table field is determined by the field’s \_\_\_\_.\
A: domain\
B: field name\
C: data type\
**D: data element**

4.      What will be output by the code below?\
*DATA: alph type I value 3.\
write: alph.\
WHILE alph > 2.\
write: alph.\
alph = alph – 1.\
ENDWHILE.*A: 3\
B: 3 2\
C: 3 3 2\
**D: 3 3**

5.      To allow the user to enter a single value on a selection screen, use the ABAP\
keyword \_\_\_\_.\
A: SELECT-OPTIONS.\
**B: PARAMETERS.**\
C: RANGES.\
D: DATA.

6.      When modifying an internal table within LOOP AT itab. \_ ENDLOOP. you must\
include an index number.\
A: True\
**B: False**

7.      If itab contains 20 rows, what will SY-TABIX equal when the program reaches the\
WRITE statement below?\
SY-TABIX = 10.\
LOOP AT itab.\
count\_field = count\_field + 1.\
ENDLOOP.\
WRITE: /1 count\_field.\
A: 0\
B: 10\
**C: 20**\
D: 30

8.      To select one record for a matching primary key, use \_\_\_\_.\
A: SELECT\
B: SELECT INTO\
**C: SELECT SINGLE**\
D: SELECT ENTRY

9.      In regard to MOVE-CORRESPONDING, which of the following is NOT a true\
statement?\
A: Moves the values of components with identical names.\
B: Fields without a match are unchanged.\
**C: Corresponds to one or more MOVE statements.**\
D: Moves the values of components according to their location.

10\. To read an exact row number of an internal table, use this parameter of the READ\
TABLE statement.\
A: INDEX\
**B: TABIX**\
C: ROW\
D: WHERE

11\. The following code indicates:\
SELECTION-SCREEN BEGIN OF BLOCK B1.\
PARAMETERS: myparam(10) type C,\
Myparam2(10) type N,\
SELECTION-SCREEN END OF BLOCK.\
**A: Draw a box around myparam and myparam2 on the selection screen**.\
B: Allow myparam and myparam2 to be ready for input during an error dialog.\
C: Do not display myparam and myparam2 on the selection screen.\
D: Display myparam and myparam2 only if both fields have default values.

12\.  If a table contains many duplicate values for a field, minimize the number of\
records returned by using this SELECT statement addition.\
A: MIN\
B: ORDER BY\
**C: DISTINCT**\
D: DELETE

13\. When writing a SELECT statement, you should place as much load as possible on\
the database server and minimize the load on the application server.\
A: True\
**B: False**

14\. PERFORM subroutine USING var.\
The var field is known as what type of parameter?\
A: Formal\
**B: Actual**\
C: Static\
D: Value

15\. The following statement will result in a syntax error.\
DATA: price(3) type p decimals 2 value ‘100.23’.\
A: True\
**B: False**

16\. This data type has a default length of one and a default value = ‘0’.\
A: P\
B: C\
**C: N**\
D: I

17\. The following code indicates:\
SELECT fld1 FROM tab1 INTO TABLE itab\
UP TO 100 ROWS\
WHERE fld7 = pfld7.\
A: Itab will contain 100 rows.\
B: Only the first 100 records of tab1 are read.\
C: If itab has less than 100 rows before the SELECT, SY-SUBRC will be set to 4.\
**D: None of the above.**

18\. Which of the following is NOT a true statement regarding a sorted internal table\
type?\
**A: May only be accessed by its key.**\
B: Its key may be UNIQUE or NON-UNIQUE.\
C: Entries are sorted according to its key when added.\
D: A binary search is used when accessing rows by its key.

19\. Function module source code may not call a subroutine.\
A: True\
**B: False**

20\.  Given:\
DO.\
Write: /1 ‘E equals MC squared.’.\
ENDDO.\
This will result in \_\_\_\_.\
A: output of ‘E equals MC squared.’ on a new line one time\
**B: an endless loop that results in an abend error**\
C: output of ‘E equals MC squared.’ on a new line many times\
D: a loop that will end when the user presses ESC

21\. The following code indicates\
write: /5 ‘I Love ABAP’.\
A: Output ‘I Lov’ on the current line\
B: Output ‘I Love ABAP’ starting at column 5 on the current line\
C: Output ‘I Lov’ on a new line\
**D: Output ‘I Love ABAP’ starting at column 5 on a new line**

22\. To both add or change lines of a database table, use \_\_\_\_.\
A: INSERT\
B: UPDATE\
C: APPEND\
**D: MODIFY**

23\. The output for the following code will be\
report zabaprg.\
DATA: my\_field type I value 99.\
my\_field = my\_field + 1.\
clear my\_field.\
WRITE: ‘The value is’, my\_field left-justified.\
A: The value is 99\
B: The value is 100\
**C: The value is 0**D: None of the above

24\. If this code results in an error, the remedy is\
SELECT \* FROM tab1 WHERE fld3 = pfld3.\
WRITE: /1 tab1-fld1, tab1-fld2.\
ENDSELECT.\
A: Add a SY-SUBRC check.\
B: Change the \* to fld1 fld2.\
**C: Add INTO (tab1-fld1, tab1-fld2).\
D: There is no error.**

25\. What is output by the following code?\
DATA: BEGIN OF itab OCCURS 0,\
letter type c,\
END OF itab.\
itab-letter = ‘A’. APPEND itab.\
itab-letter = ‘B’. APPEND itab.\
itab-letter = ‘C’. APPEND itab.\
itab-letter = ‘D’. APPEND itab.\
LOOP AT itab.\
SY-TABIX = 2.\
WRITE itab-letter.\
EXIT.\
ENDLOOP.\
**A: A**\
B: A B C D\
C: B\
D: B C D

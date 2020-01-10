/****************************************/
/* Impala SAS library를 SASHELP라고 가정 */
/****************************************/

/* CASE1 : 인메모리 테이블 삭제 후 전체 다시 적재 */

/* Set connection parameters to connect the CAS server */
options cashost = "172.27.64.248" casport = 5570 ;

/* Start a CAS session for each users defined in my .authinfo file */
cas mySession1 user = viyademo03 ;
caslib _all_ assign ;

proc delete data = public.class ;
run;

data public.class(promote=yes) ;
 set sashelp.class ;
run;

cas mySession1 terminate ;

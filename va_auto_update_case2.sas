/****************************************/
/* Impala SAS library를 SASHELP라고 가정 */
/****************************************/

/* CASE2 : 소스 테이블 전체를 인메모리 테이블에 append */
/*         (CAS에 임시 테이블 class_append로 적재 후, */
/*          CAS Table끼리 Append 해야 함             */

/* Set connection parameters to connect the CAS server */
options cashost = "172.27.64.248" casport = 5570 ;

/* Start a CAS session for each users defined in my .authinfo file */
cas mySession2 user = viyademo03 ;
caslib _all_ assign ;

/* CAS에 있는 테이블 가정 */
data public.class(promote=yes) ;
	set sashelp.class ;
run ;

/* Impala SAS Library에 업데이트된 테이블 가정 */
/* 업테이트된 테이블 먼저 임시로 CAS에 적재           */
data public.class_update(promote=yes) ;
	set sashelp.class ;
run ;

/* CAS에 있는 2개 테이블을 Append함 */
data public.class(append=yes) ;
 set public.class_update ;
run ;

/* 임시된 테이블 drop */
proc delete data = public.class_update ;
run ;

cas mySession2 terminate ;

/****************************************/
/* Impala SAS library를 SASHELP라고 가정 */
/****************************************/

/* CASE3 : 소스 테이블의 오늘 날짜만 Query하여 인메모리 테이블에 append */

/* Set connection parameters to connect the CAS server */
options cashost = "172.27.64.248" casport = 5570 ;

/* Start a CAS session for each users defined in my .authinfo file */
cas mySession3 user = viyademo03 ;
caslib _all_ assign ;

/* 초기 CAS에 있는 테이블 가정 */
data public.rent(promote=yes) ;
	set sashelp.rent ;
run ;


/* Impala SAS Library에 업데이트된 테이블 가정 */
/* 소스 데이터 work.rent에 오늘 날짜 row 추가 */
data work.rent_update ;
	set sashelp.rent ;
run ;

data work.rent_today;
 amount = 100 ;
 date = today() ;
 format date date9. ;
 output ;
run ;

proc append base=work.rent_update data=work.rent_today force ; run ;


/* 소스에서 오늘 날짜 데이터만 가져오기 */
data public.rent_update(promote=yes) ;
	set work.rent_update ;
 	where date = today();
run ;

data public.rent(append=yes) ;
	set public.rent_update ;
run ;

proc delete data = public.rent_update ;
run ;

cas mySession3 terminate ;

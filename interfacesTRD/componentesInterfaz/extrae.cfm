<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
<cfset preictsdb       = Application.dsinfo.preicts.schema>

<!--- Extracción de Swaps (Fact)
	Falta realizar la validación para mostrar los registros con error,
	ahora solamente está mostrando los registros sin error.
--->

<cffunction name="droptable">
<cfquery datasource="sifinterfaces">
#DropTableSQL('##SwapFACT_IE10')#
#DropTableSQL('##SwapFACT_ID10')#
#DropTableSQL('##Concep')#
if object_id('##OvsD_swapscompra') is not null
	drop table ##OvsD_swapscompra
if object_id('##swapsVentas') is not null
	drop table ##swapsVentas
if object_id('##swapsAlmacen') is not null
	drop table ##swapsAlmacen
if object_id('##SWAPS_IE103') is not null
	drop table ##SWAPS_IE103
</cfquery>
</cffunction>

<cfset droptable()>

<cfquery datasource="sifinterfaces">
/* ************CREA TABLAS *************** */ 
 create table ##SwapFACT_IE10(
  ID int null,
  i_folio int not null,
  i_empresa int not null,
  acct_num int null,
  c_tipo_folio char(2) not null,
  c_docto_proveedor varchar(40) null,
  c_moneda char(8) not null,
  dt_fecha_recibo datetime not null,
  dt_fecha_vencimiento datetime not null,
  voucher_num int not null,
  c_producto char(8) null,
  c_unidad char(8) null,
  voucher_tot_amt float null,
  voucher_curr_code char(8) null,
  f_precio float null,
  f_cantidad float null,
  f_iva float null,
  voucher_creation_date datetime null,
  voucher_book_comp_num int null,
  voucher_book_curr_code char(8) null,
  voucher_creator_init char(3) null,
  voucher_acct_name varchar(15) null,
  voucher_book_comp_name varchar(15) null,
  c_orden char(12) null,
  OrdenComer char(12) null,
  i_anio int null,
  SNid int not null,
  NombreBarco varchar(8) null,
  FechaHoraCarga datetime null,
  FechaHoraSalida datetime null,
  CodEmbarque char(8) null,
  FechaBOL datetime null,
  CodigoDireccionEnvio char(10) null,
  CodigoDireccionFact char(10) null,
  PrecioUnitario float null,
  CodigoUnidadMedida char(1) null,
  ImporteImpuesto float null,
  FechaTipoCambio datetime null,
  CuentaContable varchar(26) null,
  pump_on_date datetime null,
  pump_off_date datetime null
)

create clustered index ID_INDEX 
on ##SwapFACT_IE10(ID)


create table ##SwapFACT_ID10(
	ID int null,
	Consecutivo int null,
	Consecutivo2 int null,
	i_folio int not null,
	i_voucher int not null ,
	i_empresa_prop int not null,
	voucher_tot_amt float null ,
	cost_amt float null,  
	P_unitario_cost float null,
	N_productos int not null ,
	p_s_ind char(2),
	cmdty_code char(8) not null ,
	order_type_code char(12) null,                 
	acct_ref_num char(12) null,                                     
	real_port_num int not null ,
	trade_num int not null  ,
	cost_code char(12) null,
	cost_type_code char(12) null, 
	f_iva float null,
	ConceptoServicio int null
)

create clustered index ID_INDEX 
on ##SwapFACT_ID10(ID)

</cfquery>
<cfquery datasource="sifinterfaces">

/* ---------------LLENADO DE ENCABEZADO IE10- -----------------------------------*/
--select * from ##SwapFACT_IE10

insert ##SwapFACT_IE10
select distinct
 null,1 as i_folio,ab.acctNum, aa.acct_num,'RI' as c_tipo_folio, ab.invoice,ac.c_moneda,ab.invoiceDate,ab.dueDate, 
aa.voucher_num,  null, null,  aa.voucher_tot_amt, aa.voucher_curr_code, null,null,null, aa.voucher_creation_date, 
aa.voucher_book_comp_num, aa.voucher_book_curr_code,
aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,null, null, null, 
0 SNid, null,null,null,null,null, null,null,null,null,null,null,null,null,null		

from  #preictsdb#..voucher aa,
        #preictsdb#..PmiInvoice ab,
	#preictsdb#..PmiInvoiceDetail ac
where 
 	ab.paginaFact = 1
	and ab.voucherNum = ac.voucherNum
 	and ab.voucherNum = aa.voucher_num
	and (ab.invoiceType = 'f')
	and (convert(varchar(8),aa.voucher_creation_date,112) between 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaI, 'yyyymmdd' )#"> and
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#"> )
	and not exists(select 1 from InterfazBitacoraProcesos ib, IE10 ie where ab.invoice = ie.Documento
					and 'RI' = ie.CodigoTransacion and ab.acctNum = convert(int,ie.NumeroSocio) and ib.IdProceso 					
					= ie.ID and MsgError like 'OK') 
										
/*--------------- ACTUALIZAR SOCIO DE NEGOCIO -------------------------*/

update ##SwapFACT_IE10 set SNid=a.SNid from #minisifdb#..SNegocios a, ##SwapFACT_IE10  b where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
and SNcodigoext= convert(varchar,b.i_empresa)



/*  ------------------ACTUALIZA DIRECCIONES --------------------*/
UPDATE ##SwapFACT_IE10 SET CodigoDireccionEnvio = c.SNcodigoext
from ##SwapFACT_IE10 a, #minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c 
where a.i_empresa=convert(int,b.SNcodigoext) and b.SNid=c.SNid and c.SNnombre = 'COBERTURAS'

UPDATE ##SwapFACT_IE10 SET CodigoDireccionFact =c.SNcodigoext from ##SwapFACT_IE10 a, 
#minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c where a.i_empresa=convert(int,b.SNcodigoext) and b.SNid=c.SNid and c.SNnombre = 'COBERTURAS'


/*  ------------------ACTUALIZA CAMBIO DE PROPIEDAD -------------------- */

UPDATE ##SwapFACT_IE10 SET FechaTipoCambio=NULL
UPDATE ##SwapFACT_IE10 SET FechaTipoCambio=dt_fecha_recibo from ##SwapFACT_IE10  where FechaTipoCambio IS NULL




/* ********************************************************************************************* */


/* Genera el ID del Encabezado y Detalle */

declare @i int
select @i=0 /* (select Consecutivo
					from #sifinterfacesdb#..IdProceso) */

UPDATE ##SwapFACT_IE10 set ID=@i + 1,@i=@i+1 
--select * from ##SwapFACT_IE10

/* ********************************************************************************************* */

/*--------------- CREA TABLA TEMPORAL ##Paso PARA EL LLENADO DE CAMPOS DEL ENCABEZADO ---------------*/

/* ------------------ INSERTA DATOS EN LA TABLA TEMPORAL ##SwapFACT_ID10 (DETALLE)   -------------*/

INSERT INTO ##SwapFACT_ID10
SELECT  null,null,null,w.i_folio, w.i_voucher,  w.i_empresa_prop,w.voucher_tot_amt , w.venta as cost_amt,  
                                     (w.venta/w.N_productos) as P_unitario_cost, w.N_productos, w.p_s_ind , w.cmdty_code ,
                                     w.order_type_code, w.acct_ref_num, w.real_port_num, w.trade_num , w.cost_code,
                                     w.cost_type_code, w.f_iva,null
 from
(select        distinct       f.i_folio,
                                     f.i_voucher,
                                     f.i_empresa_prop,
                                     f.voucher_tot_amt ,
                                     f.venta,  
                                     (f.venta/g.N_productos) as P_unitario_cost,
                                     g.N_productos,
                                     f.p_s_ind ,
                                     f.cmdty_code ,
                                     f.order_type_code,                 
                                     f.acct_ref_num,                                     
                                     g.real_port_num,
                                     f.trade_num ,f.cost_code,
                                                          f.cost_type_code,f.f_iva                                                         
                                     
from 


( select      distinct        k.i_folio,
                                     k.i_voucher,
                                     k.i_empresa_prop,
                                     k.voucher_tot_amt ,
                                     k.f_iva,
                                     h.p_s_ind,
                                      h.cmdty_code ,
                                     h.order_type_code,                 
                                     k.port_num , 
				     k.venta/az.NVentas as venta,
				     h.acct_ref_num,
                                     h.trade_num,
                                     k.cost_code,
                                     k.cost_type_code

                   from                        (select distinct 
                                                         1 as i_folio,
                                                         a.voucherNum as i_voucher,
                                                         e.acct_num as i_empresa_prop,
                                                         b.voucher_tot_amt ,
                                                         d.port_num,
                                                         sum(d.cost_amt) as venta,
                                                          d.cost_code,
                                                          d.cost_type_code, null as f_iva
                                                from       
                                                         #preictsdb#..PmiInvoice a,
                                                         #preictsdb#..voucher b,
                                                         #preictsdb#..voucher_cost c , 
                                                         #preictsdb#..cost d,
							 #preictsdb#..account e
                                               where 
                                                         c.voucher_num=b.voucher_num
                                                 and   a.voucherNum=b.voucher_num
                                                 and   c.cost_num=d.cost_num           
                                                 and   (a.invoiceType = 'f')
                                                 and   (convert(varchar(8),b.voucher_creation_date,112) between 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaI, 'yyyymmdd' )#"> and
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#">) 
                                                 and   d.cost_type_code='SWAP'
						 and a.bookingCo = e.acct_short_name
                                                 and   e.acct_num =<cfqueryparam cfsqltype="cf_sql_integer" value="#INTICTS.CodICTS#">
                                                        group by 
                                                         a.voucherNum,
                                                         e.acct_num,
                                                         b.voucher_tot_amt ,
                                                         d.port_num,d.cost_code,
                                                          d.cost_type_code) k,

                                                         (
                                               select  distinct 
                                                          t.real_port_num,
                                                          t.p_s_ind,
                                                          t.cmdty_code,
                                                          o.order_type_code,
                                                          tr.acct_ref_num,
                                                          t.trade_num
                                               from            
                                                           #preictsdb#..trade_item t, 
                                                           #preictsdb#..trade_order o,
                                                           #preictsdb#..trade tr
							 --  	  , #preictsdb#..cost ct
                                               where          
                                                           t.trade_num=o.trade_num
                                                     and t.order_num=o.order_num
                             --                      and ct.cost_owner_key6 = t.trade_num
						     --and ct.cost_type_code = 'WPP'
						     and o.order_type_code='PHYSICAL'
                                                     and t.p_s_ind='S'
                                                     and tr.trade_num=t.trade_num ) h,

                                                         (
                                               select  distinct am.real_port_num,
							  count(distinct am.trade_num) as NVentas
                                               from            
                                                           #preictsdb#..trade_item am, 
                                                           #preictsdb#..trade_order an,
                                                           #preictsdb#..trade ao
							 -- ,  	  #preictsdb#..cost ap
                                               where          
                                                           am.trade_num=an.trade_num
                                                     and am.order_num=an.order_num
                             --                      and ap.cost_owner_key6 = am.trade_num
						     --and ap.cost_type_code = 'WPP'
						     and an.order_type_code='PHYSICAL'
                                                     and am.p_s_ind='S'
                                                     and ao.trade_num=an.trade_num 
						     group by am.real_port_num) az
							
where k.port_num=h.real_port_num and az.real_port_num = h.real_port_num) f,


                                        (select  distinct 
                                                          u.real_port_num,                                                           
                                                          sum(u.No_productos) as N_productos

                                         from  

                                                         (select  distinct 
                                                          t.real_port_num,
                                                          tr.acct_ref_num,
                                                          (count( distinct tr.acct_ref_num)) as No_productos,
                                                           t.cmdty_code
                                                          from            
                                                           #preictsdb#..trade_item t, 
                                                           #preictsdb#..trade_order o,
                                                           #preictsdb#..trade tr
							 --        , #preictsdb#..cost ct
                                                           where          
                                                           t.trade_num=o.trade_num
                                                     and t.order_num=o.order_num
                             --                        and ct.cost_owner_key6 = t.trade_num
						     --and ct.cost_type_code = 'WPP'
						     and o.order_type_code='PHYSICAL'
                                                     and t.p_s_ind='S'
                                                     and tr.trade_num=t.trade_num                                                     
                                                     group by  t.real_port_num,
                                                              tr.acct_ref_num,t.cmdty_code ) u

                                                   group by u.real_port_num ) g
where f.port_num=g.real_port_num) w

/* ----------- ID DE DETALLE SwapFACT2_ID10 ------------ */

update ##SwapFACT_ID10 
set ID = e.ID
from ##SwapFACT_ID10 d, ##SwapFACT_IE10 e
where d.i_voucher = e.voucher_num

/*--------------- ACTUALIZAR CONCEPTO SERVICIO -------------------------*/
select sb.subconcepto_id, ff.i_folio, ff.cost_code,ff.cost_type_code
	INTO tempdb..##Concep 
	FROM #tesoreriadb#..subconceptos sb, #tesoreriadb#..rel_subconceptos_detalles r, #tesoreriadb#..subconceptos_detalle s,  ##SwapFACT_ID10 ff
	WHERE s.costo_id = ff.cost_code
		  AND s.tipo_costo = ff.cost_type_code
		  AND s.payable_receivable = 'P' 
		  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
		  AND sb.subconcepto_id = r.subconcepto_id
		 --AND sb.subconcepto_id = cp.converCcodigo

UPDATE ##SwapFACT_ID10 set ConceptoServicio = b.subconcepto_id from ##SwapFACT_ID10 a,   tempdb..##Concep b WHERE a.i_folio=b.i_folio
UPDATE ##SwapFACT_ID10 set ConceptoServicio =22 from ##SwapFACT_ID10  where ConceptoServicio IS NULL

/* ------------ CONSECUTIVO ##SwapFACT_ID10 -------------*/

declare @a int
select @a=0
update ##SwapFACT_ID10 
set Consecutivo2 = @a+1,@a=@a+1
from ##SwapFACT_ID10 d, ##SwapFACT_IE10 e
where d.ID = e.ID

--declare @i int
select @a=0
UPDATE ##SwapFACT_ID10 set Consecutivo= @a+1, @a = 
case 
when exists (select 1 from ##SwapFACT_ID10 c where c.ID = d.ID and c.Consecutivo2 = d.Consecutivo2 + 1)  
then  @a+1 
else 0 
end
from ##SwapFACT_ID10 d

/* --- TERMINADO PROCESO PARA PmiInvoice COMIENZA EL PROCESO PARA PmiFolios --- */


#DropTableSQL('##Concep')#
</cfquery>

<cfquery datasource="sifinterfaces">
/* ---------------LLENADO DE ENCABEZADO IE10- -----------------------------------*/
--select * from ##SwapFACT_IE10

insert ##SwapFACT_IE10
select
 null,ab.i_folio,ab.i_empresa, aa.acct_num,ab.c_tipo_folio, ab.c_docto_proveedor,ab.c_moneda,ab.dt_fecha_recibo,ab.dt_fecha_vencimiento, 
aa.voucher_num,  null, null,  aa.voucher_tot_amt, aa.voucher_curr_code, null,null,ab.f_iva, aa.voucher_creation_date, 
aa.voucher_book_comp_num, aa.voucher_book_curr_code,
aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,ab.c_orden, null, ab.i_anio, 
0 SNid, null,null,null,null,null, null,null,null,null,null,null,null,null,null		

from  #preictsdb#..voucher aa,
        #preictsdb#..PmiFolios ab
where 
       ab.i_voucher = aa.voucher_num
       and (ab.c_tipo_folio = 'RI')
       and (convert(varchar(8),aa.voucher_creation_date,112) between 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaI, 'yyyymmdd' )#"> and
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#">)
      and not exists(select 1 from InterfazBitacoraProcesos ib, IE10 ie where ab.c_docto_proveedor = ie.Documento
					and ab.c_tipo_folio = ie.CodigoTransacion and ab.i_empresa = convert(int,ie.NumeroSocio) and 
					ib.IdProceso = ie.ID and MsgError like 'OK') 

/*--------------- ACTUALIZAR SOCIO DE NEGOCIO -------------------------*/


update ##SwapFACT_IE10 set SNid=a.SNid from #minisifdb#..SNegocios a, ##SwapFACT_IE10  b 
where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
and SNcodigoext= convert(varchar,b.i_empresa) and b.i_folio != 1


/*  ------------------ACTUALIZA DIRECCIONES --------------------*/
UPDATE ##SwapFACT_IE10 SET CodigoDireccionEnvio =c.SNcodigoext
from ##SwapFACT_IE10 a, #minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c 
where a.i_empresa=convert(int,b.SNcodigoext) and b.SNid=c.SNid 
and a.i_folio != 1 and c.SNnombre = 'COBERTURAS'

UPDATE ##SwapFACT_IE10 SET CodigoDireccionFact =c.SNcodigoext from ##SwapFACT_IE10 a, 
#minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c 
where a.i_empresa=convert(int,b.SNcodigoext) and b.SNid=c.SNid 
and a.i_folio != 1 and c.SNnombre = 'COBERTURAS'


/*  ------------------ACTUALIZA CAMBIO DE PROPIEDAD -------------------- */

UPDATE ##SwapFACT_IE10 SET FechaTipoCambio=NULL where i_folio != 1
UPDATE ##SwapFACT_IE10 SET FechaTipoCambio=dt_fecha_recibo from ##SwapFACT_IE10  where FechaTipoCambio IS NULL
and i_folio != 1


</cfquery>

<cfquery datasource="sifinterfaces">
/* Genera el ID del Encabezado y Detalle */

declare @b int
select @b= isnull(max(ID),0) from ##SwapFACT_IE10

UPDATE ##SwapFACT_IE10 set ID=@b + 1 ,@b=@b+1 where i_folio != 1
--select * from ##SwapFACT_IE10

/* Acutualiza idProceso*/
/* update #sifinterfacesdb#..IdProceso set Consecutivo = @b */

</cfquery>
<cfquery datasource="sifinterfaces">
/* ********************************************************************************************* */

/*--------------- CREA TABLA TEMPORAL ##Paso PARA EL LLENADO DE CAMPOS DEL ENCABEZADO ---------------*/

/* ------------------ INSERTA DATOS EN LA TABLA TEMPORAL ##SwapFACT_ID10 (DETALLE)   -------------*/

INSERT INTO ##SwapFACT_ID10
SELECT  null,null,null,w.i_folio, w.i_voucher,  w.i_empresa_prop,w.voucher_tot_amt , w.venta as cost_amt,  
                                     (w.venta/w.N_productos) as P_unitario_cost, w.N_productos, w.p_s_ind , w.cmdty_code ,
                                     w.order_type_code, w.acct_ref_num, w.real_port_num, w.trade_num , w.cost_code,
                                     w.cost_type_code, w.f_iva,null

 from
(select        distinct       f.i_folio,
                                     f.i_voucher,
                                     f.i_empresa_prop,
                                     f.voucher_tot_amt ,
                                     f.venta,  
                                     (f.venta/g.N_productos) as P_unitario_cost,
                                     g.N_productos,
                                     f.p_s_ind ,
                                     f.cmdty_code ,
                                     f.order_type_code,                 
                                     f.acct_ref_num,                                     
                                     g.real_port_num,
                                     f.trade_num ,f.cost_code,
                                                          f.cost_type_code,f.f_iva                                                         
                                     
from 


( select      distinct        k.i_folio,
                                     k.i_voucher,
                                     k.i_empresa_prop,
                                     k.voucher_tot_amt ,
                                     k.f_iva,
                                     h.p_s_ind,
                                      h.cmdty_code ,
                                     h.order_type_code,                 
                                     k.port_num , 
     				     k.venta/az.NVentas as venta,
				     h.acct_ref_num,
                                     h.trade_num,
                                     k.cost_code,
                                     k.cost_type_code

                   from                        (select distinct 
                                                         a.i_folio,
                                                         a.i_voucher,
                                                         a.i_empresa_prop,
                                                         b.voucher_tot_amt ,
                                                         d.port_num,
                                                         sum(d.cost_amt) as venta,
                                                          d.cost_code,
                                                          d.cost_type_code, a.f_iva
                                                from       
                                                         #preictsdb#..PmiFolios a,
                                                         #preictsdb#..voucher b,
                                                         #preictsdb#..voucher_cost c , 
                                                         #preictsdb#..cost d
                                               where 
                                                         c.voucher_num=b.voucher_num
                                                 and   a.i_voucher=b.voucher_num
                                                 and   c.cost_num=d.cost_num           
                                                 and   (a.c_tipo_folio = 'RI')
                                                 and   (convert(varchar(8),b.voucher_creation_date,112) between 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaI, 'yyyymmdd' )#"> and
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#">) 
                                                 and   a.i_empresa_prop =<cfqueryparam cfsqltype="cf_sql_integer" value="#INTICTS.CodICTS#">
                                                 and   d.cost_type_code='SWAP'
                                                        group by a.i_folio,
                                                         a.i_voucher,
                                                         a.i_empresa_prop,
                                                         b.voucher_tot_amt ,
                                                         d.port_num,d.cost_code,
                                                          d.cost_type_code,a.f_iva) k,

                                                         (
                                               select  distinct 
                                                          t.real_port_num,
                                                          t.p_s_ind,
                                                          t.cmdty_code,
                                                          o.order_type_code,
                                                          tr.acct_ref_num,
                                                          t.trade_num
                                               from            
                                                           #preictsdb#..trade_item t, 
                                                           #preictsdb#..trade_order o,
                                                           #preictsdb#..trade tr
							 --  	  , #preictsdb#..cost ct
                                               where          
                                                           t.trade_num=o.trade_num
                                                     and t.order_num=o.order_num
                             --                        and ct.cost_owner_key6 = t.trade_num
						     --and ct.cost_type_code = 'WPP'
						     and o.order_type_code='PHYSICAL'
                                                     and t.p_s_ind='P'
                                                     and tr.trade_num=t.trade_num ) h,

                                                         (
                                               select  distinct am.real_port_num,
							  count(distinct am.trade_num) as NVentas
                                               from            
                                                           #preictsdb#..trade_item am, 
                                                           #preictsdb#..trade_order an,
                                                           #preictsdb#..trade ao
							 --  	  ,#preictsdb#..cost ap
                                               where          
                                                           am.trade_num=an.trade_num
                                                     and am.order_num=an.order_num
						     --and ap.cost_owner_key6 = am.trade_num
						     --and ap.cost_type_code = 'WPP'
                                                     and an.order_type_code='PHYSICAL'
                                                     and am.p_s_ind='P'
                                                     and ao.trade_num=an.trade_num 
						     group by am.real_port_num) az
							
where k.port_num=h.real_port_num and az.real_port_num = h.real_port_num) f,


                                        (select  distinct 
                                                          u.real_port_num,                                                           
                                                          sum(u.No_productos) as N_productos

                                         from  

                                                         (select  distinct 
                                                          t.real_port_num,
                                                          tr.acct_ref_num,
                                                          (count( distinct tr.acct_ref_num)) as No_productos,
                                                           t.cmdty_code
                                                          from            
                                                           #preictsdb#..trade_item t, 
                                                           #preictsdb#..trade_order o,
                                                           #preictsdb#..trade tr
							 --  	  #preictsdb#..cost ct
                                                           where          
                                                           t.trade_num=o.trade_num
                                                     and t.order_num=o.order_num
						     --and ct.cost_owner_key6 = t.trade_num
						     --and ct.cost_type_code = 'WPP'
                                                     and o.order_type_code='PHYSICAL'
                                                     and t.p_s_ind='P'
                                                     and tr.trade_num=t.trade_num                                                     
                                                     group by  t.real_port_num,
                                                              tr.acct_ref_num,t.cmdty_code ) u

                                                   group by u.real_port_num ) g
where f.port_num=g.real_port_num) w
</cfquery>

<cfquery datasource="sifinterfaces">
/* ----------- ID DE DETALLE SwapFACT2_ID10 ------------ */

update ##SwapFACT_ID10 
set ID = e.ID
from ##SwapFACT_ID10 d, ##SwapFACT_IE10 e
where d.i_folio = e.i_folio and d.i_folio != 1

</cfquery>
<cfquery datasource="sifinterfaces">
/*--------------- ACTUALIZAR CONCEPTO SERVICIO -------------------------*/
select sb.subconcepto_id, ff.i_folio, ff.cost_code,ff.cost_type_code
	INTO tempdb..##Concep 
	FROM #tesoreriadb#..subconceptos sb, #tesoreriadb#..rel_subconceptos_detalles r, #tesoreriadb#..subconceptos_detalle s,  ##SwapFACT_ID10 ff
	WHERE s.costo_id = ff.cost_code
		  AND s.tipo_costo = ff.cost_type_code
		  AND s.payable_receivable = 'P' 
		  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
		  AND sb.subconcepto_id = r.subconcepto_id
		 --AND sb.subconcepto_id = cp.converCcodigo

UPDATE ##SwapFACT_ID10 set ConceptoServicio = b.subconcepto_id from ##SwapFACT_ID10 a,   tempdb..##Concep b WHERE a.i_folio=b.i_folio and a.i_folio != 1
UPDATE ##SwapFACT_ID10 set ConceptoServicio =22 from ##SwapFACT_ID10  where ConceptoServicio IS NULL and i_folio != 1

</cfquery>
<cfquery datasource="sifinterfaces">

/* ------------ CONSECUTIVO ##SwapFACT_ID10 -------------*/
declare @c int
select @c= max(Consecutivo2) from ##SwapFACT_ID10
update ##SwapFACT_ID10 
set Consecutivo2 = @c+1,@c=@c+1
from ##SwapFACT_ID10 d, ##SwapFACT_IE10 e
where d.ID = e.ID and d.i_folio != 1

--declare @i int
select @c=0
UPDATE ##SwapFACT_ID10 set Consecutivo= @c+1, @c = 
case 
when exists (select 1 from ##SwapFACT_ID10 c where c.ID = d.ID and c.Consecutivo2 = d.Consecutivo2 + 1)  
then  @c+1 
else 0 
end
from ##SwapFACT_ID10 d
where d.i_folio != 1
</cfquery>

<cfquery datasource="sifinterfaces">
/*Ajuste de Centavos de Diferencia */
update ##SwapFACT_ID10 set cost_amt = 
case 
when 
isnull(abs((select round(sum(cost_amt),2) from ##SwapFACT_ID10 b where b.ID = a.ID group by ID) -
(select round(voucher_tot_amt,2) from  ##SwapFACT_IE10 c where a.ID = c.ID)),0) < 1
then 
	cost_amt + round(isnull(abs((select round(sum(cost_amt),2) from ##SwapFACT_ID10 b where b.ID = a.ID group by ID) -
(select round(voucher_tot_amt,2) from  ##SwapFACT_IE10 c where a.ID = c.ID)),0),2)
else
cost_amt
end
from ##SwapFACT_ID10 a
where a.Consecutivo = (select min(d.Consecutivo) from ##SwapFACT_ID10 d where d.ID = a.ID group by ID) 
</cfquery>

<!--- La fecha Tipo Cambio es la del documento, en caso de que se desee cambiar esto aplicar este fragmento al query
isnull((select min(FTipoCambio) from ##SWAPS_IE103 b where a.ID = b.ID),FechaTipoCambio !--->
<cfquery datasource="sifinterfaces">
/* --------------------------- Inserta Datos en la tabla de encabezados IE10  --------------------------------------- */
insert #sifinterfacesdb#..PMIINT_IE10 (FechaRegistro,sessionid,
ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
FechaTipoCambio, StatusProceso)
select
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
ID,14, convert (varchar,i_empresa), case when i_folio = 1 then 'CC' else 'CP' end ,c_tipo_folio,
c_docto_proveedor, null,c_moneda, dt_fecha_recibo, dt_fecha_vencimiento,
'S', 'ICTS',convert(varchar,voucher_num),'22',null ,
null , 0 , convert(varchar,CodigoDireccionEnvio), convert(varchar,CodigoDireccionFact), 
FechaTipoCambio, 1
FROM ##SwapFACT_IE10
</cfquery>

<cfquery datasource="sifinterfaces">
/*--------INSERTA LA INFORMACION EN LA TABLA ID10-------*/
insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid,
ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
CodigoDepartamento, PrecioTotal, CentroFuncional, 
CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra, OCconceptoIngreso)

SELECT 
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
a.ID, a.Consecutivo, 'O', a.cmdty_code  , null, 
null, null,0,'',0, 
0, null, '0',b.FechaDocumento,null, 
a.acct_ref_num, null, round(a.f_iva,2),0,null,
null,round(a.cost_amt,2), null, 
null,(select min(OCTtipo) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx, #minisifdb#..OCordenComercial ax where a.acct_ref_num = ax.OCcontrato and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid),
(select min(OCTtransporte) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx, #minisifdb#..OCordenComercial ax where a.acct_ref_num = ax.OCcontrato and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid),
a.acct_ref_num,case when i_folio = 1 then null else convert(char,a.ConceptoServicio) end,
case when i_folio = 1 then convert(char,a.ConceptoServicio) else null end
FROM ##SwapFACT_ID10 a, #sifinterfacesdb#..PMIINT_IE10 b
where a.ID=b.ID
and b.sessionid = #session.monitoreo.sessionid#

/* Validacion de Errores */

/*Verifica que exista el socio de Negocios*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + 'Socio de Negocios NO existe ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where not exists (select 1 from  #minisifdb#..SNegocios b where b.SNcodigoext = a.NumeroSocio)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica la clasificacion del socio como Coberturas*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Socio de Negocios sin direccion COBERTURAS ' 
from #sifinterfacesdb#..PMIINT_IE10 a, #minisifdb#..SNegocios b
where b.SNcodigoext = a.NumeroSocio
and not exists (select 1 from #minisifdb#..SNDirecciones c where b.SNid = c.SNid and c.SNnombre like 'COBERTURAS')
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que exista Orden Comercial*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' No se encontro Orden Comercial para Documento ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where 
(
not exists (select 1 from #sifinterfacesdb#..PMIINT_ID10 b where a.ID = b.ID and a.sessionid = b.sessionid)
or
exists (select 1 from #sifinterfacesdb#..PMIINT_ID10 b where a.ID = b.ID and b.ContractNo is null and a.sessionid = b.sessionid)
)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica numero de documento correcto*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Numero de Documento Invalido ' 
where Documento is null or len(Documento) < 1
and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que tenga configurada cuenta en su direccion COBERTURAS*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Direccion COBERTURAS sin cuenta ' 
from #sifinterfacesdb#..PMIINT_IE10 a,#minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c
where b.SNcodigoext = a.NumeroSocio
and b.SNid = c.SNid 
and c.SNnombre like 'COBERTURAS'
and (
(a.Modulo like 'CP' and c.SNDCFcuentaProveedor is null)
	or
(a.Modulo like 'CC' and c.SNDCFcuentaCliente is null)
	)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que la suma de los detalles sea igual al monto encabezado*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Suma del Monto de los detalles no es igual al importe Total ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where
abs((select round(sum(cost_amt),2) from ##SwapFACT_ID10 b where b.ID = a.ID group by ID) -
(select round(voucher_tot_amt,2) from  ##SwapFACT_IE10 c where a.ID = c.ID)) > .05
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica el codigo de Moneda*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Codigo de Moneda Incorrecto ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where not exists (select 1 from  #minisifdb#..Monedas b where b.Miso4217 = a.CodigoMoneda)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que el Almacen Exista*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Almacen NO existe ' 
from #sifinterfacesdb#..PMIINT_IE10 a,#sifinterfacesdb#..PMIINT_ID10 b
where 
a.ID = b.ID
and not exists (select 1 from  #minisifdb#..Almacen c where c.Almcodigo = b.CodigoAlmacen)
and b.CodigoAlmacen is not null
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
and a.sessionid = b.sessionid


/*Verifica que el Articulo Exista*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Articulo NO existe ' 
from #sifinterfacesdb#..PMIINT_IE10 a,##SwapFACT_ID10 b
where 
a.ID = b.ID
and not exists (select 1 from  #minisifdb#..Articulos c where ltrim(rtrim(c.Acodigo)) = ltrim(rtrim(b.cmdty_code)) and c.Ecodigo = 8)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que el Documento no haya sido aplicado antes*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Documento Ya aplicado en SOIN ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where 
(
exists (select 1 from  #minisifdb#..EDocumentosCxP c, #minisifdb#..SNegocios d where ltrim(rtrim(c.EDdocumento)) like ltrim(rtrim(a.Documento)) and c.CPTcodigo like a.CodigoTransacion and d.SNcodigoext like a.NumeroSocio and c.SNcodigo = d.SNcodigo and c.Ecodigo = 8)
or
exists (select 1 from  #minisifdb#..EDocumentosCP c, #minisifdb#..SNegocios d where ltrim(rtrim(c.Ddocumento)) like ltrim(rtrim(a.Documento)) and c.CPTcodigo like a.CodigoTransacion and d.SNcodigoext like a.NumeroSocio and c.SNcodigo = d.SNcodigo and c.Ecodigo = 8)
or
exists (select 1 from  #minisifdb#..HEDocumentosCP c, #minisifdb#..SNegocios d where ltrim(rtrim(c.Ddocumento)) like ltrim(rtrim(a.Documento)) and c.CPTcodigo like a.CodigoTransacion and d.SNcodigoext like a.NumeroSocio and c.SNcodigo = d.SNcodigo and c.Ecodigo = 8)
)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que la orden comercial Exista en la estrcutura de OC*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Orden Comercial no encontrada ' 
from #sifinterfacesdb#..PMIINT_IE10 a,#sifinterfacesdb#..PMIINT_ID10 b
where 
a.ID = b.ID
and not exists (select 1 from  #minisifdb#..OCordenComercial c where ltrim(rtrim(c.OCcontrato)) = ltrim(rtrim(b.ContractNo)) and c.Ecodigo = 8)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que el documento no se encuentre en la cola de procesos*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Documento en Cola Procesos Interfaz 10 ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where 
exists(select 1 from InterfazColaProcesos ib, IE10 ie where a.Documento = ie.Documento
		and a.CodigoTransacion = ie.CodigoTransacion and a.NumeroSocio = ie.NumeroSocio and ib.IdProceso = ie.ID) 
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>

<cfset droptable()>

<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfsetting requesttimeout="3600"> 
<cfparam name="url.formato" default="HTML">
<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="Reversion.cfm">
</cfif>

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cf_navegacion name="fltPeriodo" 		navegacion="" default="-1">
<cf_navegacion name="fltMes" 			navegacion="" default="-1">
<cf_navegacion name="fltMoneda" 		navegacion="" default="-1">
<cf_navegacion name="fltUsuario" 		navegacion="" default="-1">
<cf_navegacion name="fltInterfaz" 		navegacion="" default="-1">
<cf_navegacion name="fltEstatus" 		navegacion="" default="-1">

 <cf_dbtemp name="TmpProcesosExp" returnvariable="TmpProcesosExp" datasource="sifinterfaces">
				<cf_dbtempcol name="Ecodigo" type="integer">
				<cf_dbtempcol name="Interfaz" type="varchar(70)">
				<cf_dbtempcol name="Periodo" type="integer">
				<cf_dbtempcol name="NumMes" type="integer">
				<cf_dbtempcol name="Mes" type="varchar(25)">
				<cf_dbtempcol name="Registros" type="integer">
				<cf_dbtempcol name="Importe" type="money">
                <cf_dbtempcol name="Usuario" type="varchar(25)">
				<cf_dbtempcol name="Moneda" type="varchar(25)">
                <cf_dbtempcol name="Estatus" type="varchar(25)">
 </cf_dbtemp>
 
 
<cfquery name="rsEmpresaProcesos" datasource="sifinterfaces">
    select EQUcodigoOrigen
    from SIFLD_Equivalencia
    where CATcodigo like 'CADENA'
    and EQUidSIF like convert(varchar,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>

<cfquery name="rsCifrasControl" datasource="sifinterfaces">
    insert into #TmpProcesosExp# (Ecodigo, Interfaz, Periodo, NumMes, Mes, Registros, Importe, Usuario, Estatus, Moneda)
	select Ecodigo,Interfaz = 'Compras FACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then    'Febrero' 	when 3 then 'Marzo' when 	4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when			 	12 then 'Diciembre'end as Mes,count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'PRFC' and Estatus in (1,2,3,0,6)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Compras NOFACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2    then 'Febrero' when 3    then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
 	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'PRNF' and Estatus in (1,2,3,0,6)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Ventas FACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error'	 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'PRFC' and Estatus in (1,2,3,0,6)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'Ventas NOFACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
 	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'PRNF' and Estatus in (1,2,3,0,6)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'Gastos FACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'GAFC' and Estatus in (1,2,3,6,0)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					   <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Gastos NOFACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 'Febrero' 	when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when	 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'GANF' and Estatus in (1,2,3,6,0)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Otros Ingresos Con Orden', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 	    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'OICO' and Estatus in (1,2,3,0,6)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union 
	select Ecodigo, Interfaz = 'Otros Ingresos Sin Orden', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 	    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'OISO' and Estatus in (1,2,3,0,6)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'SWAPS FACT Perdida', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 		    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when			 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'CE' and Estatus in (1,2,3,0) and Tipo_Documento != 'FU'
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					   <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'SWAPS NOFACT Perdida', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 	    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'AB' and Estatus in (1,2,3,0) and Tipo_Documento != 'FU'
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Futuros Cerrados Perdida', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 	    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when		 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error'	 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'CE' and Estatus in (1,2,3,0) and Tipo_Documento = 'FU'
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Futuros Abiertos Perdida', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 	    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'AB' and Estatus in (1,2,3,0) and Tipo_Documento = 'FU'
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'SWAPS FACT Ganancia', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then  	    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'CE' and Estatus in (1,2,3,0) and Tipo_Documento != 'FU'
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'SWAPS NOFACT Ganancia', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then  		    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'AB' and Estatus in (1,2,3,0) and Tipo_Documento != 'FU'
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'Futuros Cerrados Ganancia', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 			    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'CE' and Estatus in (1,2,3,0) and Tipo_Documento = 'FU'
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union 
	select Ecodigo, Interfaz = 'Futuros Abiertos Ganancia', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 		    then 'Febrero' when 3 then 	'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'AB' and Estatus in (1,2,3,0) and Tipo_Documento = 'FU'
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select E.Ecodigo, Interfaz = 'Inventarios', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 'Febrero' 		    when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Costo,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Movimientos_Inventario E
	inner join DSIFLD_Movimientos_Inventario D on E.ID_Movimiento = D.ID_Movimiento where Estatus in (1,2,3,0,6)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and E.Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by E.Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda
	union
	select Ecodigo, Interfaz = 'CostoVenta', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 'Febrero' 			    when 3 then 'Marzo' when 4 	then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Monto,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from SIFLD_Costo_Venta where Estatus in (1,2,3,0,6)
					  <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda
</cfquery>

<cfquery name="rsBitacora" datasource="sifinterfaces">
select Ecodigo, Interfaz, Periodo, Mes, Registros, convert(varchar,convert(money,Importe),1) as Importe, Usuario, Estatus, Moneda 
                      from #TmpProcesosExp# 
					  where 1=1
					  <cfif form.fltInterfaz neq "-1">
                          and Interfaz = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltInterfaz)#">
                      </cfif>
					  <cfif form.fltEstatus neq "-1">
                          and Estatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltEstatus)#">
                      </cfif>
					 <!--- <cfif form.fltPeriodo neq "-1">
                          and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
                      </cfif>
					  <cfif form.fltMes neq "-1">
                          and NumMes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
                      </cfif>
					   <cfif form.fltMoneda neq "-1">
                          and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
                      </cfif>
                      <cfif form.fltUsuario neq "-1">
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>                      
					  
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>--->
                      order by Interfaz, Periodo, Mes, Usuario, Moneda
				</cfquery>
				
<cfquery name="rsEmpresa" datasource="sifinterfaces">				
	select distinct(Edescripcion) as Nom_Empresa from #minisifdb#..Empresas E 
	inner join int_ICTS_SOIN I on I.Ecodigo = E.Ecodigo
	inner join #TmpProcesosExp# T on I.CodICTS = convert (varchar(10),T.Ecodigo) 				  
</cfquery>

<cfif isdefined("rsBitacora") and rsBitacora.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif rsBitacora.recordcount EQ 0>
	<cfthrow message="No existen registros que mostrar">
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Cifras de Control del Modulo de Integración" 
			filename="Cifras de Control del Modulo de Intergación.xls" 
			ira="../Consultas/consola-bitacora-procesados-form.cfm">
		<cf_templatecss>
		<cfflush interval="512">
		<cfoutput>

				<table width="130%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="12">&nbsp;</td>
						<td align="right"><strong>#DateFormat(now(),"DD/MM/YYYY")#</strong></td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>"#rsEmpresa.Nom_Empresa#"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Cifras de Control de Módulo de Integración</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
				<table width="130%">
					<tr>
						<td nowrap align="rigth"><strong>Interfaz</strong></td>
						<td nowrap align="rigth"><strong>Periodo</strong></td>
						<td nowrap align="rigth"><strong>Mes</strong></td>
						<td nowrap align="rigth"><strong>Registros</strong></td>
						<td nowrap align="rigth"><strong>Moneda</strong></td>
						<td nowrap align="rigth"><strong>Importe</strong></td>
						<td nowrap align="rigth"><strong>Usuario</strong></td>
						<td nowrap align="rigth"><strong>Estatus</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsBitacora">
						<tr>
							<td nowrap>#rsBitacora.Interfaz#</td>
							<td nowrap>#rsBitacora.Periodo#</td>
							<td nowrap>#rsBitacora.Mes#</td>
							<td nowrap>#rsBitacora.Registros#</td>
							<td nowrap>#rsBitacora.Moneda#</td>
							<td nowrap>#rsBitacora.Importe#</td>
							<td nowrap>#rsBitacora.Usuario#</td>
							<td nowrap>#rsBitacora.Estatus#</td>
						</tr>
					</cfloop>
				</table>
		</cfoutput>
</cfif>



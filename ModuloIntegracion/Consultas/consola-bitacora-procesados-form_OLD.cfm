<cf_templateheader title="Bitacora de Procesos">  
<cf_web_portlet_start titulo="Registros con Error">

<cf_navegacion name="fltPeriodo" 		navegacion="" default="-1">
<cf_navegacion name="fltMes" 			navegacion="" default="-1">
<cf_navegacion name="fltMoneda" 		navegacion="" default="-1">
<cf_navegacion name="fltUsuario" 		navegacion="" default="-1">
<cf_navegacion name="fltInterfaz" 		navegacion="" default="-1">
<cf_navegacion name="fltEstatus" 		navegacion="" default="-1">

 <cf_dbtemp name="TmpProcesos" returnvariable="TmpProcesos" datasource="sifinterfaces">
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

<cfquery name="rsCifrasControl" datasource="sifinterfaces">
    insert into #TmpProcesos# (Ecodigo, Interfaz, Periodo, NumMes, Mes, Registros, Importe, Usuario, Estatus, Moneda)
	select Ecodigo,Interfaz = 'Compras FACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then    'Febrero' 	when 3 then 'Marzo' when 	4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when			 	12 then 'Diciembre'end as Mes,count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'PRFC' and Estatus in (1,2,3,0,6)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Compras NOFACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2    then 'Febrero' when 3    then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
 	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'PRNF' and Estatus in (1,2,3,0,6)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Ventas FACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error'	 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'PRFC' and Estatus in (1,2,3,0,6)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'Ventas NOFACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
 	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'PRNF' and Estatus in (1,2,3,0,6)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'Gastos FACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'GAFC' and Estatus in (1,2,3,6,0)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Gastos NOFACT', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 'Febrero' 	when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when	 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'GANF' and Estatus in (1,2,3,6,0)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Otros Ingresos Con Orden', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 	    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'OICO' and Estatus in (1,2,3,0,6)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union 
	select Ecodigo, Interfaz = 'Otros Ingresos Sin Orden', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 	    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'OISO' and Estatus in (1,2,3,0,6)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'SWAPS FACT Perdida', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 		    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when			 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'CE' and Estatus in (1,2,3,0) and Tipo_Documento != 'FU'
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'SWAPS NOFACT Perdida', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 	    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'AB' and Estatus in (1,2,3,0) and Tipo_Documento != 'FU'
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Futuros Cerrados Perdida', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 	    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when		 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error'	 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'CE' and Estatus in (1,2,3,0) and Tipo_Documento = 'FU'
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'Futuros Abiertos Perdida', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 	    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros,
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Compra where Clas_Compra = 'AB' and Estatus in (1,2,3,0) and Tipo_Documento = 'FU'
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Compra
	union
	select Ecodigo, Interfaz = 'SWAPS FACT Ganancia', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then  	    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'CE' and Estatus in (1,2,3,0) and Tipo_Documento != 'FU'
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'SWAPS NOFACT Ganancia', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then  		    'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'AB' and Estatus in (1,2,3,0) and Tipo_Documento != 'FU'
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select Ecodigo, Interfaz = 'Futuros Cerrados Ganancia', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 			    then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'CE' and Estatus in (1,2,3,0) and Tipo_Documento = 'FU'
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union 
	select Ecodigo, Interfaz = 'Futuros Abiertos Ganancia', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 		    then 'Febrero' when 3 then 	'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Total,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Facturas_Venta where Clas_Venta = 'AB' and Estatus in (1,2,3,0) and Tipo_Documento = 'FU'
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda, Clas_Venta
	union
	select E.Ecodigo, Interfaz = 'Inventarios', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 'Febrero' 		    when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Costo,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from ESIFLD_Movimientos_Inventario E
	inner join DSIFLD_Movimientos_Inventario D on E.ID_Movimiento = D.ID_Movimiento where Estatus in (1,2,3,0,6)
	group by E.Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda
	union
	select Ecodigo, Interfaz = 'CostoVenta', Periodo, Mes as NumMes, case Mes when 1 then 'Enero' when 2 then 'Febrero' 			    when 3 then 'Marzo' when 4 	then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
	when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 	12 then 'Diciembre'end as Mes, count (1) as Registros, 
	sum(isnull(Monto,0)) as Importe, Usuario, Estatus = case Estatus  when 1 then 'Pendiente' when 2 then 'Procesado' when 3 then 'Error' when 6 then 'Error' 	when 0 then 'Eliminado' end, Moneda
	from SIFLD_Costo_Venta where Estatus in (1,2,3,0,6)
	group by Ecodigo, Periodo, Mes, Usuario, Estatus, Moneda 
</cfquery>

<cfquery name="rsEmpresaProcesos" datasource="sifinterfaces">
    select EQUcodigoOrigen
    from SIFLD_Equivalencia
    where CATcodigo like 'CADENA'
    and EQUidSIF like convert(varchar,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>

<cfquery name="rsPeriodo" datasource="sifinterfaces">
    select distinct (Periodo)
    from #TmpProcesos#
    <cfif rsEmpresaProcesos.recordcount GT 0>
		where Ecodigo in(#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
	</cfif>
	order by Periodo
</cfquery>

<cfquery name="rsMes" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfquery name="rsMoneda" datasource="sifinterfaces">
    select distinct (Moneda)
    from #TmpProcesos#
    <cfif rsEmpresaProcesos.recordcount GT 0>
		where Ecodigo in(#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
	</cfif>
	order by Moneda
</cfquery>

<cfquery name="rsProcesos" datasource="sifinterfaces">
	select distinct (Interfaz) 
	from #TmpProcesos#
	<cfif rsEmpresaProcesos.recordcount GT 0>
		where Ecodigo in(#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
	</cfif>
	order by Interfaz
</cfquery>

<cfquery name="rsUsuarios" datasource="sifinterfaces">
	select distinct (Usuario)
	from #TmpProcesos#
	where Usuario is not null
    <cfif rsEmpresaProcesos.recordcount GT 0>
		and Ecodigo in(#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
    </cfif> 
 	order by Usuario
</cfquery>

<cfquery name="rsEstatus" datasource="sifinterfaces">
	select distinct(Estatus)
	from #TmpProcesos#
	<cfif rsEmpresaProcesos.recordcount GT 0>
		where Ecodigo in(#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
    </cfif> 
    order by Estatus
</cfquery>

<cfquery name="rsAñoMes" datasource="#session.dsn#">
	select convert(integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=   "#Session.Ecodigo#"> and Pcodigo = 60)) as Mes,
	case convert (integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=     "#Session.Ecodigo#"> and Pcodigo = 60)) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then    'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when    10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as NomMes,
	(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                    					    "#Session.Ecodigo#"> and Pcodigo = 50) as Año
</cfquery>


<!---<cfif not isdefined("form.fltInterfaz") and not isdefined("url.fltInterfaz")>
	<cfset form.fltInterfaz = -1>
</cfif>
<cfif not isdefined("form.fltUsuario") and not isdefined("url.fltUsuario")>
	<cfset form.fltUsuario = -1>
</cfif>--->


<!--- ****************************************************************  --->
<cfset LvarNavegacion = ""> 

<cfif Form.fltPeriodo NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltPeriodo=#Form.fltPeriodo#">
</cfif>

<cfif Form.fltMes NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMes=#Form.fltMes#">
</cfif>

<cfif Form.fltInterfaz NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltInterfaz=#Form.fltInterfaz#">
</cfif>

<cfif Form.fltMoneda NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMoneda=#Form.fltMoneda#">
</cfif>

<cfif Form.fltUsuario NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltUsuario=#Form.fltUsuario#">
</cfif>

<cfif Form.fltEstatus NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltEstatus=#Form.fltEstatus#">
</cfif>

<cfoutput> 

<form method="post" action = "consola-bitacora-procesados-form.cfm" name="formBitacora" style="margin:0 0 0 0">
    <table class="AreaFiltro" width="100%">
        <td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <tr>
			<td></td>
            <td align="left"><strong>Interfaz: </strong></td>
            <td width="200">
                <select name="fltInterfaz"> 
                <option value="-1" selected="selected">(Todas las interfaces...)</option>
                <cfloop query="rsProcesos">
                    <option value="#rsProcesos.Interfaz#" <cfif isdefined("form.fltInterfaz") and trim(form.fltInterfaz) EQ trim(rsProcesos.Interfaz)>selected</cfif>>#rsProcesos.Interfaz#</option>
                </cfloop>
                </select>
            </td>
			<td align="left"><strong>Periodo:	</strong></td>
				 <td>
					<select name="fltPeriodo" tabindex="5">
					<option value="-1" selected="">(Todos)</option>
						<cfloop query="rsPeriodo">
                    		<option value="#rsPeriodo.Periodo#" <cfif #rsAñoMes.Año# EQ "#rsPeriodo.Periodo#">selected</cfif>>#rsPeriodo.Periodo#
							</option>
						</cfloop>
					</select>
			</td>
			<td align="left"><strong>Mes: </strong></td>
            <td>
				<select name="fltMes" tabindex="5"> 
				<option value="-1" selected="">(Todos)</option>
		        	<cfloop query="rsMes">
                		<option value="#rsMes.VSvalor#" <cfif #rsAñoMes.Mes# EQ "#rsMes.VSvalor#">selected</cfif>>#rsMes.VSdesc#</option>     
					</cfloop>
                </select>
         		</td>
				<td align="left"><strong>Moneda:	</strong></td>				
           	    <td>
					<select name="fltMoneda" tabindex="5">
					<option value="-1" selected="selected">(Todos...)</option>
						<cfloop query="rsMoneda">
                    		<option value="#rsMoneda.Moneda#" <cfif isdefined("form.fltMoneda") and trim(form.fltMoneda) EQ trim(rsMoneda.Moneda)>selected</cfif>>#rsMoneda.Moneda#</option>
               			</cfloop>
					</select>
				</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
			<td></td>
			<td align="left"><strong>Usuario:	</strong></td>
			    <td>
				<select name="fltUsuario">
	             <option value="-1" selected="selected">(Todos...)</option>
    		        <cfloop query="rsUsuarios">
                		<option value="#rsUsuarios.Usuario#" <cfif isdefined("form.fltUsuario") and trim(form.fltUsuario) EQ trim(rsUsuarios.Usuario)>selected="selected"</cfif>>#rsUsuarios.Usuario#</option>
            		</cfloop>
            	</select>
			</td>
			<td align="left"><strong>Estatus:	</strong></td>
			    <td>
				  <select name="fltEstatus">
	             <option value="-1" selected="selected">(Todos...)</option>
    		        <cfloop query="rsEstatus">
                		<option value="#rsEstatus.Estatus#" <cfif isdefined("form.fltEstatus") and trim(form.fltEstatus) EQ trim(rsEstatus.Estatus)>selected="selected"</cfif>>#rsEstatus.Estatus#</option>

            		</cfloop>
            	</select>
			</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>	
			<td><input name="submit" type="submit" id="Seleccionar" value="Seleccionar"/>
			<input name="submit" type="submit" id="Consultar" value="Consultar" onClick="javascript:Consultar();"/></td>	 
        </tr>
        <tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
         <tr>
		 	<td colspan="8">
                <cfquery name="rsLista" datasource="sifinterfaces">
                      select Ecodigo, Interfaz, Periodo, Mes, Registros, convert(varchar,convert(money,Importe),1) as Importe, Usuario, Estatus, Moneda 
                      from #TmpProcesos#
                      where 1=1
					  <cfif form.fltInterfaz neq "-1">
                          and Interfaz = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltInterfaz)#">
                      </cfif>
					  <cfif form.fltPeriodo neq "-1">
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
					  <cfif form.fltEstatus neq "-1">
                          and Estatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltEstatus)#">
                      </cfif>
                       <cfif rsEmpresaProcesos.recordcount GT 0>
                          and Ecodigo in (#ValueList(rsEmpresaProcesos.EQUcodigoOrigen)#)
                       </cfif>
                      order by Interfaz, Periodo, Mes, Usuario, Moneda
				</cfquery>
			</td>
    	</tr>
    </table>
 </form>
 
	   <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="cortes" value="Interfaz"/>
			<cfinvokeargument name="desplegar" value="Periodo, Mes, Registros, Importe, Usuario, Estatus, Moneda"/>
			<cfinvokeargument name="etiquetas" value="Periodo, Mes, Registros, Importe, Usuario, Estatus, Moneda"/>
			<!---<cfinvokeargument name="formatos" value="S,I,I,S,S,S"/>---->
			<cfinvokeargument name="formatos" value="S,S,V,S,V,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,S,N,N"/>
			<cfinvokeargument name="align" value="center,center, center, left, center,center, center"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value=""/>   
            <cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="keys" value=""/>
			<cfinvokeargument name="botones" value=""/>
            <cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
		</cfinvoke>

</cfoutput> 

<!--- <cfabort showerror="aqui"> --->

<script type="text/javascript" type="text/javascript">

function Consultar(){
		document.formBitacora.action = "consola-bitacora-procesados-export.cfm";
		}		
</script> 

<cf_web_portlet_end>
<cf_templatefooter> 
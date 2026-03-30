<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 	type="integer" 		mandatory="yes">
</cf_dbtemp>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO VENGA VACIO --->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select 1
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.recordcount EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1)
	</cfquery>
<cfelse>
	<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO TENGA REGISTROS DUPLICADOS PARA UN ARTICULO,MONEDA,PERIODO Y MES --->
	<cfquery name="rsCheck2" datasource="#session.DSN#">
		select 1 
		from #table_name# 
		group by  Fecha,Moneda
		having count(1) > 1		
	</cfquery>
	<cfif rsCheck2.RecordCount GT 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('Existe tipos de cambio duplicados para una misma fecha ',2)
		</cfquery>
	</cfif>
	<!--- VALIDA QUE EL TIPO DE CAMBIO DE COMPRA  SEA MAYOR QUE CERO --->
	<cfquery name="rsCheck3" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where TCCompra <= 0
	</cfquery>
	<cfif isdefined("rsCheck3") and  rsCheck3.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo de importaci&oacute;n tiene tipos de cambio (compra) con valor menor o igual a cero ',3)
		</cfquery>
	</cfif>	
	<!--- VALIDA QUE EL TIPO DE CAMBIO DE VENTA  SEA MAYOR QUE CERO --->
	<cfquery name="rsCheck3" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where TCVenta <= 0
	</cfquery>
	<cfif isdefined("rsCheck3") and  rsCheck3.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo de importaci&oacute;n tiene tipos de cambio (venta) con valor menor o igual a cero ',3)
		</cfquery>
	</cfif>	
	<!--- VALIDA QUE EL TIPO DE CAMBIO PROMEDIO  SEA MAYOR QUE CERO --->
	<cfquery name="rsCheck3" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where TCPromedio <= 0
	</cfquery>
	<cfif isdefined("rsCheck3") and  rsCheck3.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo de importaci&oacute;n tiene tipos de cambio (promedio) con valor menor o igual a cero ',3)
		</cfquery>
	</cfif>	
	<!--- VALIDA MONEDA --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select 'La moneda :' #_Cat# x.Moneda #_Cat# '  no existe en el cat&aacute;logo de monedas',4
		from #table_name# x
		where  ltrim(rtrim(x.Moneda)) not in (
			select ltrim(rtrim(b.Miso4217)) 
			from Monedas b
			where b.Ecodigo = #session.Ecodigo#)
	</cfquery>	
</cfif>	

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum
</cfquery>	

<cfif (err.recordcount) EQ 0>
	<!--- BUSCA EL MONEDA LOCAL - Monedas de minisif --->
	<cfquery name="rsmiso" datasource="#session.dsn#">
		 select m.Miso4217 
		 	from Empresas e
				inner join Monedas m
					on e.Mcodigo = m.Mcodigo
		where e.Ecodigo = #session.Ecodigo#
	</cfquery>
	<!---Busca el Mcodigo del Miso en las monedas de asp (vista en minisif)--->
	<cfquery name="rsMonloc" datasource="#session.dsn#">
		 select Mcodigo from Moneda where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsmiso.Miso4217#">
	</cfquery>
    <!---
	<!--- BUSCA EL MONEDA LOCAL  --->
	<cfquery name="rsMonloc" datasource="#session.dsn#">
		 select Mcodigo from Empresas where Ecodigo = #session.Ecodigo#
	</cfquery> 
	---ABG CORRECCION AL METODO DE BUSQUEDA DE LA MONEDA LOCAL--->
	<cfset Monloc =  rsMonloc.Mcodigo>
	
	<!--- BUSCA LAS EMPRESAS DE LA COORPORACION QUE TIENEN LA MISMA MONEDA LOCAL.   --->
	<cfquery name="rsEmpresa" datasource="asp">
		select Ecodigo from Empresa 
		where CEcodigo = #session.CEcodigo#
		and Mcodigo = #Monloc#
		and Ereferencia is not null
	</cfquery>
	
	<cfset empresas =''>
	<cfloop query="rsEmpresa">
		<cfset empresas= empresas & rsEmpresa.Ecodigo & ','>
	</cfloop>
	<cfset empresas = empresas & '-1'>

<!---Actuliza los tipos de cambio que ya existen segun Htipocambio_PK (Ecodigo, Mcodigo, Hfecha)--->
   <cfquery name="UPDcurrency" datasource="#session.dsn#">
   		select coalesce(x.TCCompra,0) TCcompra,
		       coalesce(x.TCVenta,0) TCventa,
			   coalesce(x.TCPromedio,0) TCpromedio, 
			   e.Ecodigo,
			   a.Mcodigo,
		       <cf_dbfunction name="date_format" args="x.Fecha,YYYYMMDD"> Hfecha
			from Htipocambio htp
		    	inner join Empresas e
		    		on htp.Ecodigo = e.Ecodigo
	      		   and e.EcodigoSDC in (#empresas#)
	            inner join Monedas a
		  	       on a.Ecodigo = e.Ecodigo
			      and a.Mcodigo = htp.Mcodigo
		       inner join #table_name# x
		           on x.Moneda = a.Miso4217
			 where <cf_dbfunction name="date_format" args="htp.Hfecha,YYYYMMDD"> = <cf_dbfunction name="date_format" args="x.Fecha,YYYYMMDD"> 
	</cfquery>
	<cfloop query="UPDcurrency">
		<cfquery datasource="#session.dsn#">
			update Htipocambio
			 set TCcompra   = #UPDcurrency.TCcompra#,
			     TCventa    = #UPDcurrency.TCventa#,
			     TCpromedio = #UPDcurrency.TCpromedio#
			where Ecodigo   = #UPDcurrency.Ecodigo#
			  and Mcodigo   = #UPDcurrency.Mcodigo#
			  and <cf_dbfunction name="date_format" args="Hfecha,YYYYMMDD">	= '#UPDcurrency.Hfecha#'
		</cfquery>
	</cfloop>
	
	<cfquery name="registrosinsertar" datasource="#session.dsn#">
		select 
			a.Ecodigo, 
			a.Mcodigo, 
			x.Fecha Hfecha, 
			x.TCCompra, 
			x.TCVenta,
			x.TCPromedio
		from #table_name# x, Empresas e, Monedas a
		where e.EcodigoSDC in (#empresas#)
		  and a.Ecodigo = e.Ecodigo
		  and a.Miso4217 = x.Moneda
		  and a.Ecodigo  = e.Ecodigo
		  and not exists (
		  		select 1
				from Htipocambio HT
				where HT.Mcodigo = a.Mcodigo
				  and HT.Ecodigo = a.Ecodigo
				  and <cf_dbfunction name="date_format" args="HT.Hfecha,YYYYMMDD"> = <cf_dbfunction name="date_format" args="x.Fecha,YYYYMMDD">
				) 
	</cfquery>

	<cfset LvarFechaFinal = createdate(6100,1,1)>
		
	<cfloop query="registrosinsertar">
		<cfquery name="rsRegistroActual" datasource="#session.dsn#">
			select Ecodigo, Mcodigo, Hfecha, Hfechah
			from Htipocambio tc
			where tc.Ecodigo = #registrosinsertar.Ecodigo#
			  and tc.Mcodigo = #registrosinsertar.Mcodigo#
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#registrosinsertar.Hfecha#"> between tc.Hfecha and tc.Hfechah
		</cfquery>
			
		<cfif rsRegistroActual.recordcount GT 0>
			<cfset LvarFecha = rsRegistroActual.Hfechah>
			<cfquery datasource="#session.dsn#">
				update Htipocambio
				set Hfechah    = <cfqueryparam cfsqltype="cf_sql_date" value="#registrosinsertar.Hfecha#">
				where Ecodigo  = #registrosinsertar.Ecodigo#
				  and Mcodigo  = #registrosinsertar.Mcodigo#
				  and Hfecha   = <cfqueryparam cfsqltype="cf_sql_date" value="#rsregistroActual.Hfecha#">
				  and Hfechah  = <cfqueryparam cfsqltype="cf_sql_date" value="#rsregistroActual.Hfechah#">
			</cfquery>
		<cfelse>
			<cfset LvarFecha = LvarFechaFinal>
		</cfif>

		<cfquery datasource="#session.dsn#">
			insert into Htipocambio ( 
				Ecodigo,
				Mcodigo,
				Hfecha,
				TCcompra,
				TCventa,
				TCpromedio,
				Husuario,
				BMUsucodigo,
				Hfechah
			)
			values(
				#registrosinsertar.Ecodigo#,
				#registrosinsertar.Mcodigo#,
				<cf_jdbcquery_param  cfsqltype="cf_sql_date" value="#registrosinsertar.Hfecha#">,
				#registrosinsertar.TCCompra#,
				#registrosinsertar.TCVenta#,
				#registrosinsertar.TCPromedio#,
				'#session.usulogin#',
				#session.Usucodigo#,
				<cf_jdbcquery_param  cfsqltype="cf_sql_date" value="#LvarFecha#">
			)
		</cfquery>
	</cfloop>
</cfif>
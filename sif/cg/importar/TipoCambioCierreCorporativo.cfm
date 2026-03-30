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
		group by  Moneda
		having count(1) > 1		
	</cfquery>
	<cfif rsCheck2.RecordCount GT 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('Existe tipos de cambio duplicados para una misma moneda ',2)
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
	<!--- BUSCA EL PERIODO  --->
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = 50
		and Mcodigo = 'GN'
	</cfquery>
	<cfset Periodo = rsPeriodo.Pvalor >
	<!--- BUSCA EL MES  --->
	<cfquery name="rsMes" datasource="#session.dsn#">
		select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = 60
		and Mcodigo = 'GN'
	</cfquery>
	<cfset Mes = rsMes.Pvalor >


	<!--- BUSCA EL MONEDA LOCAL  --->
	<cfquery name="rsMonloc" datasource="#session.dsn#">
		 select Mcodigo from Empresas where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset Monloc =  rsMonloc.Mcodigo>
	
	<!--- BUSCA LAS EMPRESAS DE LA COORPORACION QUE TIENEN LA MISMA MONEDA LOCAL.   --->
	<cfquery name="rsEmpresa" datasource="asp">
		select  Ecodigo from Empresa 
		where CEcodigo = #session.CEcodigo#
		and Mcodigo = #Monloc#
		and Ereferencia is not null
	</cfquery>
	
	<cfset empresas =''>
	<cfloop query="rsEmpresa">
		<cfset empresas= empresas & rsEmpresa.Ecodigo & ','>
	</cfloop>
	<cfset empresas = empresas & '-1'>
	<!---Actuliza los tipos de cambio que ya existen segun TipoCambioEmpresa_PK(Ecodigo, Mcodigo, Periodo, Mes)--->
	<cfquery name="UPDcurrency" datasource="#session.dsn#">
	   select e.Ecodigo,
	     	  a.Mcodigo,
			  tce.Periodo,
			  tce.Mes,
			  coalesce(x.TCCompra,0)   TCCompra,
		      coalesce(x.TCVenta,0)    TCVenta,
		      coalesce(x.TCPromedio,0) TCPromedio
	   from TipoCambioEmpresa tce
	    inner join Empresas e
			on tce.Ecodigo = e.Ecodigo
		   and e.EcodigoSDC in (#empresas#)
		inner join Monedas a
			on a.Ecodigo = e.Ecodigo
		   and a.Mcodigo = tce.Mcodigo 	
		inner join #table_name# x
		    on x.Moneda = a.Miso4217
	   where tce.Periodo = #Periodo#
	     and tce.Mes     = #Mes#
	</cfquery>
	<cfloop query="UPDcurrency">
		<cfquery datasource="#session.dsn#">
			update TipoCambioEmpresa
	          set TCEtipocambio 	 = #UPDcurrency.TCCompra#,
		          TCEtipocambioventa = #UPDcurrency.TCVenta#,
		          TCEtipocambioprom	 = #UPDcurrency.TCPromedio#
			where Ecodigo = #UPDcurrency.Ecodigo#
			  and Mcodigo = #UPDcurrency.Mcodigo#
			  and Periodo = #UPDcurrency.Periodo#
		      and Mes     = #UPDcurrency.Mes#
		</cfquery>
	</cfloop>
		
	<cfquery name="RSregistros" datasource="#session.dsn#">
		insert into TipoCambioEmpresa ( 
			Ecodigo,
			Mcodigo,
			Periodo,
			Mes,    
			TCEtipocambio,
			TCEtipocambioventa,
			TCEtipocambioprom,
			BMUsucodigo
		)
		select 
			a.Ecodigo, 
			a.Mcodigo, 
			#periodo#, 
			#mes#, 
			x.TCCompra, 
			x.TCVenta,
			x.TCPromedio,
			#session.Usucodigo#
		from #table_name# x, Empresas e, Monedas a
		where e.EcodigoSDC in (#empresas#)
		  and a.Ecodigo = e.Ecodigo
		  and a.Miso4217 = x.Moneda
		  and a.Ecodigo  = e.Ecodigo
		  and not exists (
		  		select 1
				from TipoCambioEmpresa TCE
				where TCE.Mcodigo = a.Mcodigo
				  and TCE.Ecodigo = a.Ecodigo
				  and TCE.Periodo = #Periodo#
				  and TCE.Mes     = #Mes#
				) 
	</cfquery>
</cfif>
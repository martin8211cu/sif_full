<cftransaction>
	<cf_dbtemp name="planillaBSJ" returnvariable="planillaBSJ" datasource="#session.dsn#">
		<cf_dbtempcol name="registros"  type="numeric" identity="yes">
		<cf_dbtempcol name="planilla"  	type="char(5)" mandatory="no">
		<cf_dbtempcol name="archivo"  	type="char(5)" mandatory="no">
		<cf_dbtempcol name="cedula"  	type="char(9)" mandatory="no">
		<cf_dbtempcol name="blancos"  	type="char(11)" mandatory="no">
		<cf_dbtempcol name="fechaini"   type="char(6)"  mandatory="no">
		<cf_dbtempcol name="monto"  	type="char(13)" mandatory="no">
		<cf_dbtempcol name="ceros"  	type="char(3)"  mandatory="no">
		<cf_dbtempcol name="detalle"  	type="char(14)" mandatory="no">
		<cf_dbtempcol name="blancos2" 	type="char(11)" mandatory="no">
		<cf_dbtempcol name="fechafin"   type="char(5)"  mandatory="no">
		<cf_dbtempcol name="blanco" 	type="char(1)"  mandatory="no">
		<cf_dbtempcol name="nombre" 	type="char(30)" mandatory="no">
		<cf_dbtempkey cols="registros">
	</cf_dbtemp>
	
	<!--- -- Numero de Planilla--->
	<!---if not exists(select 1 from RHParametros where Pcodigo = 200 and Ecodigo = @Ecodigo) begin
		   insert RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
		   values (@Ecodigo, 200, 'Numero de Planilla', 'B0011')
	end--->
	<cfquery name="rscheck1" datasource="#session.dsn#">
		select 1 as check1
		from RHParametros 
		where Pcodigo = 200 
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfif rscheck1.check1 LTE 0>
		<cfquery name="rsInsertA" datasource="#session.DSN#">
		   insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
		   values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 200, 'Numero de Planilla', 'B0011')
		</cfquery>
	</cfif>

	<cfquery name="rscheck2" datasource="#session.dsn#">
		select Pvalor as Planilla
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 200
	</cfquery>
	<cfset bPlanilla = rscheck2.Planilla>
	
	<!--- -- Consecutivo de Archivo--->
	<!---if not exists(select 1 from RHParametros where Pcodigo = 210 and Ecodigo = @Ecodigo) begin
		   insert RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
		   values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 210, 'Consecutivo de Archivo de Planilla', '1')
	end--->
	<cfquery name="rscheck3" datasource="#session.DSN#">
		select 1 as check3
		from RHParametros 
		where Pcodigo = 210 
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfset bcheck3 = rscheck3.check3>			
			
	<cfif bcheck3 LTE 0 >
		<cfquery name="rsInsertB" datasource="#session.DSN#">
			insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 210, 'Consecutivo de Archivo de Planilla', '1')
		</cfquery>
	</cfif>
	
	<cfquery name="rscheck4" datasource="#session.DSN#">
		select Pvalor as Archivo 
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		 and Pcodigo = 210
	</cfquery>
	<cfset bArchivo = rscheck4.Archivo>
	
	<cfquery name="rsInsert" datasource="#session.DSN#">
	
		insert into #planillaBSJ# (planilla, archivo, cedula, blancos, fechaini, monto, ceros, detalle, blancos2, fechafin, blanco, nombre)
		select 'T' || substring(<cfqueryparam cfsqltype="cf_sql_varchar" value="#bPlanilla#">, 4, 4), 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 5-len(bArchivo)) & bArchivo#">,
				left(a.DRIdentificacion, 14), <!---left(a.DEcuenta, 14),--->				 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#">,
				 <cf_dbfunction name="date_format"  args="b.ERNfinicio,YYYYMMDD">,
				 <cf_dbfunction name="to_number" args="round(a.DRNliquido* 100, 0)" returnvariable="LvarCampoI"> <!--- este no pinta en el select :-) --->
				 <cfset LvarCampoI = "#LvarCampoI#">
				 <cf_dbfunction name="to_char" args="#LvarCampoI#" returnvariable="LvarCampoI">
				 right('0000000000000' || #LvarCampoI# ,13),
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 3)#">, 
				 left(b.ERNdescripcion, 14), 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#">, 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 5)#">,
				 <!---<cf_dbfunction name="date_format"  args="b.ERNffin,DD-MM">, ---->
	             replicate(' ', 1),
				 left(a.DRNapellido1, 13) || replicate(' ', 13-{fn LENGTH(left(a.DRNapellido1, 13))}) 
				 || left(a.DRNapellido2, 13) || replicate(' ', 13-{fn LENGTH(left(a.DRNapellido2, 13))})
				 || left(a.DRNnombre, 4) as nombre
		from DRNomina a, ERNomina b
		where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
		and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
		and a.ERNid = b.ERNid
		order by 1, 3
	</cfquery>
	
	<!--- -- encabezado --->
	<cfquery name="ERR" datasource="#session.DSN#">
		select <cfqueryparam cfsqltype="cf_sql_varchar" value="#bPlanilla#"> || ' ' as planilla,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 5-len(bArchivo)) & bArchivo#"> as archivo,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 9)#" > as cedula,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#"> as blancos,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 3)#">,
				 <cf_dbfunction name="date_format"  args="b.ERNfinicio,YYYYMMDD"> as fechaini,
				 <cf_dbfunction name="to_number" args="a.monto" returnvariable="LvarCampo">
				 <cfset LvarCampo = "sum(#LvarCampo#)">
				 <cf_dbfunction name="to_char" args="#LvarCampo#" returnvariable="LvarCampo">
				 right ('0000000000000' || #LvarCampo# ,13) as monto,
				 right ('000' || <cf_dbfunction name="to_char" args="count(1)">,3) as ceros,
				 <cf_dbfunction name="to_char"  args="left(b.ERNdescripcion,14)"> || replicate(' ', 14 - {fn LENGTH(<cf_dbfunction name="to_char" args ="left(b.ERNdescripcion,14)">)}) as detalle,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#"> as blancos2,
				 <!---<cf_dbfunction name="date_format"  args="b.ERNffin,DD-MM"> as fechafin,--->
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 5)#"> as fechafin,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as blanco,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 30)#"> as nombre
		from #planillaBSJ# a, ERNomina b
		where b.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		group by b.ERNdescripcion, b.ERNfinicio
		union
		<!--- -- detalle--->
		select planilla,
				 archivo,
				 cedula,
				 blancos,
				 <cf_dbfunction name="to_char" args ="registros" returnvariable="LvarCampoM">
				 <cfset LvarCampoM = "#LvarCampoM#">
				 right('000' || #LvarCampoM#,3),
				 fechaini,
				 monto,
				 ceros,
				 detalle,
				 blancos2,
				 fechafin,
				 blanco,
				 nombre
		from #planillaBSJ#
		order by 1, 3
	</cfquery>
	
	<cfquery name="drop" datasource="#session.DSN#">
		drop table #planillaBSJ#
	</cfquery>
	
	
	<cfquery name="updateA" datasource="#Session.DSN#">
		update RHParametros
		<cf_dbfunction name="to_number" args="Pvalor" returnvariable="LvarCampoB"> <!--- este no pinta en el select :-) --->
        <cfset LvarCampoB = "#LvarCampoB# + 1">
		<cf_dbfunction name="to_char" args="#LvarCampoB#" returnvariable="LvarCampoB">
		set Pvalor = #LvarCampoB#
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 210 
	</cfquery>

</cftransaction>
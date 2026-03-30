<cftransaction>
	<cf_dbtemp name="planillaBSJ" returnvariable="planillaBSJ" datasource="#session.dsn#">
		<cf_dbtempcol name="registros"  type="numeric" identity="yes">
		<cf_dbtempcol name="planilla"  	type="char(5)" mandatory="no">
		<cf_dbtempcol name="archivo"  	type="char(5)" mandatory="no">
		<cf_dbtempcol name="cedula"  	type="char(10)" mandatory="no">
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

	<!--- Número de Plan (tipo de contrato con el BAC) --->
	<cfquery name="rscheck5" datasource="#session.dsn#">
		select CBdato1 as nPlan
		from CuentasBancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
        and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	<cfset Plan = rscheck5.nPlan>
	
	<cfquery name="rsInsert" datasource="#session.DSN#">
	
		insert into #planillaBSJ# (planilla, archivo, cedula, blancos, fechaini, monto, ceros, detalle, blancos2, fechafin, blanco, nombre)
		select 	 {fn concat('T', <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(Plan)) & Plan#"> )},
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 5-len(bArchivo)) & bArchivo#">,
				 left(a.DRIdentificacion, 10),
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#">,
				 <cf_dbfunction name="date_format"  args="b.ERNfdeposito,YYMMDD">,
				 <cf_dbfunction name="to_number" args="round(a.DRNliquido* 100, 0)" returnvariable="LvarCampoI"> <!--- este no pinta en el select :-) --->
				 <cfset LvarCampoI = "#LvarCampoI#">
				 <cf_dbfunction name="to_char" args="#LvarCampoI#" returnvariable="LvarCampoI">
				 right({fn concat('0000000000000',#LvarCampoI#)} ,13),
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 3)#">, 
				 left(b.ERNdescripcion, 14), 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#">, 
				 <cf_dbfunction name="date_format"  args="b.ERNffin,DD-MM">, 
	             replicate(' ', 1),
				 <!---{fn concat(
				 	{fn concat(
				 		{fn concat(
				 			{fn concat( left(a.DRNapellido1, 13) , replicate(' ', 13-{fn LENGTH(left(a.DRNapellido1, 13))}) )}
				 		, left(a.DRNapellido2, 13))}
				 	, replicate(' ', 13-{fn LENGTH(left(a.DRNapellido2, 13))}) )}
				 , left(a.DRNnombre, 4) )} as nombre  --->
				 convert(varchar(30), {fn concat(
					 					{fn concat(
					 						{fn concat( rtrim(a.DRNapellido1),' ')},
					 						{fn concat( rtrim(a.DRNapellido2),' ')}
					 					)}, rtrim(a.DRNnombre) )})
		from DRNomina a, ERNomina b
		where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
		and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
		and a.ERNid = b.ERNid
		order by 1, 3
	</cfquery>
	
	<!--- -- encabezado --->
	<cfquery name="ERR" datasource="#session.DSN#">
		select {fn concat('B', <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(Plan)) & Plan#"> )},
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 5-len(bArchivo)) & bArchivo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 10)#" >,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#">,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 3)#">,
				 <cf_dbfunction name="date_format"  args="b.ERNfdeposito,YYMMDD">,
				 <cf_dbfunction name="to_number" args="a.monto" returnvariable="LvarCampo">
				 <cfset LvarCampo = "sum(#LvarCampo#)">
				 <cf_dbfunction name="to_char" args="#LvarCampo#" returnvariable="LvarCampo">
				 right ({fn concat('0000000000000' , #LvarCampo#)} ,13),
				 right ({fn concat('000' , <cf_dbfunction name="to_char" args="count(1)">)},3),
				 {fn concat(<cf_dbfunction name="to_char"  args="left(b.ERNdescripcion,14)"> , replicate(' ', 14 - {fn LENGTH(<cf_dbfunction name="to_char" args ="left(b.ERNdescripcion,14)">)}))},
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#">,
				 <cf_dbfunction name="date_format"  args="b.ERNffin,DD-MM">,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#">,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 30)#">
		from #planillaBSJ# a, ERNomina b
		where b.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		group by b.ERNdescripcion, b.ERNfdeposito, b.ERNffin
		union
		<!--- -- detalle--->
		select planilla,
				 archivo,
				 cedula,
				 blancos,
				 <cf_dbfunction name="to_char" args ="registros" returnvariable="LvarCampoM">
				 <cfset LvarCampoM = "#LvarCampoM#">
				 right( '000'+ #LvarCampoM# ,3),
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
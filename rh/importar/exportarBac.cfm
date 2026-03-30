<!--- Se realizan cambios para trabajar con nóminas en proceso y en histórico y dbfunction
tamaño del string del exportado =  116
fcastro20111103
--->
<cftransaction>
	<cf_dbtemp name="planillaBSJ" returnvariable="planillaBSJ" datasource="#session.dsn#">
		<cf_dbtempcol name="registros"  type="numeric" identity="yes">
		<cf_dbtempcol name="planilla"  	type="char(5)" mandatory="yes">
		<cf_dbtempcol name="archivo"  	type="char(5)" mandatory="yes">
		<cf_dbtempcol name="cedula"  	type="char(9)" mandatory="yes">
		<cf_dbtempcol name="blancos"  	type="char(11)" mandatory="yes">
		<cf_dbtempcol name="fechaini"   type="char(6)"  mandatory="yes">
		<cf_dbtempcol name="monto"  	type="char(13)" mandatory="yes">
		<cf_dbtempcol name="ceros"  	type="char(3)"  mandatory="yes">
		<cf_dbtempcol name="detalle"  		type="varchar(14)" mandatory="yes">
		<cf_dbtempcol name="blancos2" 	type="char(11)" mandatory="yes">
		<cf_dbtempcol name="fechafin"   type="char(5)"  mandatory="yes">
		<cf_dbtempcol name="blanco" 	type="char(1)"  mandatory="yes">
		<cf_dbtempcol name="nombre" 	type="char(30)" mandatory="yes">
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

<!---	<!--- Número de Plan (tipo de contrato con el BAC) --->
	<cfquery name="rscheck5" datasource="#session.dsn#">
		select CBdato1 as nPlan
		from CuentasBancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	</cfquery>
	<cfset Plan = rscheck5.nPlan>--->
	
	
	<!--- prefijo para indicar si se trata de nominas en historico o en proceso--->
	<cfset pre="">
	<cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "h">
		<cfset pre="H">
	</cfif>
	
	<!--- Variable de contatenacion--->
	<cf_dbfunction name="OP_concat" returnvariable="concat">
	
	<!--- substring planilla--->
	<cfset LvarPlanilla=Mid(bPlanilla,2,4)>
	
	<!--- salario liquido--->
	<cf_dbfunction name="to_char_integer"	args="0"  returnvariable="cero"><!--- se convierte a cero el string para usarlo como char a duplicar--->
	 <cf_dbfunction name="to_number" args="round(a.#pre#DRNliquido* 100, 0)" 	returnvariable="LvarCampoLiq"  delimiters="|"> 
		<cf_dbfunction name="to_char" args="#LvarCampoLiq#" returnvariable="LvarCampoLiqC">
			<cf_dbfunction name="length"      args="#LvarCampoLiqC#"   returnvariable="LvarLiqL" delimiters="|" > 
				<cf_dbfunction name="sRepeat"     args="#cero#|13-coalesce(#LvarLiqL#,0)" 	returnvariable="ReplLiq" delimiters="|">

	<!----Apellido 1------------------>
		<cf_dbfunction name="length"      args="left(a.#pre#DRNapellido1,13)"  		returnvariable="LvarApe1L" delimiters="|" > <!--- Longitud Real--->
			<cf_dbfunction name="sRepeat"     args="''|13-coalesce(#LvarApe1L#,0)" 	returnvariable="ReplApe1" delimiters="|">
	<!----Apellido 2------------------>
		<cf_dbfunction name="length"      args="left(a.#pre#DRNapellido2,13)" 		returnvariable="LvarApe2L" delimiters="|" > <!--- Longitud Real--->
			<cf_dbfunction name="sRepeat"     args="''|13-coalesce(#LvarApe2L#,0)" 	returnvariable="ReplApe2" delimiters="|">
			
	<!--- Descripcion--->			
	 <cf_dbfunction name="to_char" args="left(b.#pre#ERNdescripcion,14)" 	returnvariable="LvarERNdescripcion"  delimiters="|">  
		<cf_dbfunction name="length"      args="#LvarERNdescripcion#"  		returnvariable="LvarERNdescripcionL" delimiters="|" > 
			<cf_dbfunction name="sRepeat"     args="''|14-#LvarERNdescripcionL#" 	returnvariable="ReplERNdescripcion" delimiters="|">				

	<cfquery  datasource="#session.DSN#">
		INSERT INTO #planillaBSJ# (planilla, archivo, cedula, blancos, fechaini, monto,ceros, detalle, blancos2,fechafin,blanco, nombre)
		SELECT 'T'#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#LvarPlanilla#">,<!---tam: 5--->
				  <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 5-len(bArchivo)) & bArchivo#">,<!---tam: 5--->
				  left(a.#pre#DRIdentificacion, 9),<!---tam: 9--->
				  <cf_dbfunction name="sRepeat"     args="' '|11" delimiters="|"> ,<!---tam: 11--->
				  <cf_dbfunction name="date_format"  args="b.#pre#ERNfinicio,YYMMDD">,<!---tam: 6--->
				  left(#ReplLiq##concat##LvarCampoLiqC#,13) ,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 3)#">,
				  left(#LvarERNdescripcion# #concat# #ReplERNdescripcion#,14),
				  <cf_dbfunction name="sRepeat" args="''|11" delimiters="|">,
				  <cf_dbfunction name="date_format"  args="b.#pre#ERNffin,DD-MM">, <!---tam: 5--->
	              replicate(' ',1),
				  left(a.#pre#DRNapellido1,13)#concat##ReplApe1##concat# <!---tam: 30--->
				  left(a.#pre#DRNapellido2,13)#concat##ReplApe2##concat#
				  left(a.#pre#DRNnombre, 4)
		FROM 
				 #pre#DRNomina a, #pre#ERNomina b
		WHERE a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
		and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
		and a.ERNid = b.ERNid
		order by 1, 3
	</cfquery>
	
	<cf_dbtemp name="temp2" returnvariable="temp2" datasource="#session.dsn#">
		<cf_dbtempcol name="planilla"  	type="char(5)" mandatory="yes">
		<cf_dbtempcol name="archivo"  	type="char(5)" mandatory="yes">
		<cf_dbtempcol name="cedula"  	type="char(9)" mandatory="yes">
		<cf_dbtempcol name="num"  	type="char(3)" mandatory="yes">
		<cf_dbtempcol name="blancos"  	type="char(11)" mandatory="yes">
		<cf_dbtempcol name="fechaini"   type="char(6)"  mandatory="yes">
		<cf_dbtempcol name="monto"  	type="char(13)" mandatory="yes">
		<cf_dbtempcol name="ceros"  	type="char(3)"  mandatory="yes">
		<cf_dbtempcol name="detalle"  		type="char(14)" mandatory="yes">
		<cf_dbtempcol name="blancos2" 	type="char(11)" mandatory="yes">
		<cf_dbtempcol name="fechafin"   type="char(5)"  mandatory="yes">
		<cf_dbtempcol name="blanco" 	type="char(1)"  mandatory="yes">
		<cf_dbtempcol name="nombre" 	type="char(30)" mandatory="yes">
	</cf_dbtemp>

	<!--------------------------- encabezado ------------------------------>
	
	<!--- monto--->
		 <cf_dbfunction name="to_number" args="a.monto" 	returnvariable="LvarCampo"  delimiters="|"> 
			 <cf_dbfunction name="to_char" args="sum(#LvarCampo#)" returnvariable="LvarCampo">
			 	<cf_dbfunction name="length"      args="#LvarCampo#"  		returnvariable="LvarCampoL" delimiters="|" > <!--- Longitud Real--->
					<cf_dbfunction name="sRepeat"     args="#cero#|13-coalesce(#LvarCampoL#,0)" 	returnvariable="ReplLvarCampoL" delimiters="|">

	<!--- Count--->
		 <cf_dbfunction name="to_char" args="count(1)" 	returnvariable="LvarCount"  delimiters="|"> 
		 	<cf_dbfunction name="length"      args="#LvarCount#"  		returnvariable="LvarCountL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="#cero#|3-coalesce(#LvarCountL#,0)" 	returnvariable="ReplLvarCount" delimiters="|">
		
	<!--- Descripcion--->
		<cf_dbfunction name="to_char"  args="left(b.#pre#ERNdescripcion,14)" returnvariable="LvarDescripcion">
			<cf_dbfunction name="length"      args="#LvarDescripcion#"  		returnvariable="LvarDescripcionL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|14-coalesce(#LvarDescripcionL#,0)" 	returnvariable="ReplDescrip" delimiters="|">
				
	<!--- Registros --->
		<cf_dbfunction name="to_char" args ="registros" returnvariable="LvarCampoM">
			<cf_dbfunction name="length"      args="#LvarCampoM#"  		returnvariable="LvarCampoML" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="#cero#|3-coalesce(#LvarCampoML#,0)" 	returnvariable="ReplLvarCampoM" delimiters="|">
				
			
	<cfquery datasource="#session.DSN#"><!---tam total: 116--->
		INSERT INTO #temp2# (planilla, archivo, cedula, blancos, num, fechaini, monto,ceros, detalle, blancos2,fechafin,blanco, nombre)
		SELECT 'B'#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#LvarPlanilla#">,<!---tam: 5--->
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 5-len(bArchivo)) & bArchivo#">,<!---tam: 5--->
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 9)#" >,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 3)#">,
 				 <cf_dbfunction name="date_format"  args="b.#pre#ERNfinicio,YYMMDD">,<!---tam: 6--->
				 left(#ReplLvarCampoL##concat##LvarCampo#,13),
				 left (#ReplLvarCount##concat##LvarCount#,3),
				 left(#LvarDescripcion# #concat# #ReplDescrip# ,14) as detalle,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 11)#">,
				 <cf_dbfunction name="date_format"  args="b.#pre#ERNffin,DD-MM">,<!---tam: 5--->
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#">,
 				 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 30)#">
		FROM #planillaBSJ# a, #pre#ERNomina b
		WHERE b.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		group by b.#pre#ERNdescripcion, b.#pre#ERNfdeposito, b.#pre#ERNffin
	</cfquery>

	<cfquery datasource="#session.dsn#">
		INSERT INTO #temp2# (planilla, archivo, cedula, blancos, num, fechaini, monto,ceros, detalle, blancos2,fechafin,blanco, nombre)
		SELECT planilla,
					 archivo,
					 cedula,
					 blancos,
					 left(#ReplLvarCampoM##concat##LvarCampoM#,3),
					 fechaini,
					 monto,
					 ceros,
					 detalle,
					 blancos2,
					 fechafin,
					 blanco,
					 nombre
		FROM #planillaBSJ#
		order by 1, 3
	</cfquery>
			
	<cfquery name="ERR" datasource="#session.dsn#">
		SELECT planilla,
					 archivo,
					 cedula,
					 blancos,
					 num,
					 fechaini,
					 monto,
					 ceros,
					 detalle,
					 blancos2,
					 fechafin,
					 blanco,
					 nombre
		FROM #temp2#
	</cfquery>
	
	<cfquery name="drop" datasource="#session.DSN#">
		drop table #planillaBSJ#
	</cfquery>
	
	<cfquery name="updateA" datasource="#Session.DSN#">
		UPDATE RHParametros
		<cf_dbfunction name="to_number" args="Pvalor" returnvariable="LvarCampoB"> <!--- este no pinta en el select :-) --->
        <cfset LvarCampoB = "#LvarCampoB# + 1">
		<cf_dbfunction name="to_char" args="#LvarCampoB#" returnvariable="LvarCampoB">
		SET Pvalor = #LvarCampoB#
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 210 
	</cfquery>

</cftransaction>
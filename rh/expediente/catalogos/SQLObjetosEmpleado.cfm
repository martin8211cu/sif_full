

<cfif isdefined("Form.BotonSel") and len(trim(form.BotonSel))>
</cfif>
<cfset modo="ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cftransaction>
			<cfif isdefined("Form.Alta")>
				<cfquery name="insRHArchEmp" datasource="#Session.DSN#">	
					insert into RHArchEmp 
						(DEid, Ecodigo, RHAEdescr, RHAEfecha,BMusumod, BMfechamod)
						<!--- (DEid, Ecodigo, RHAEdescr, RHAEfecha,RHAEarchivo,RHAEruta, RHAEtipo, BMusumod, BMfechamod) --->
						values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHAEdescr#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp"  value="#LSParsedateTime(form.RHAEfecha)#">,
					<!---
					'#form.DEid#_#nombreArchivo#',
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#cffile.serverDirectory#">,					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cffile.serverFileExt#">, 
					--->					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					)
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="insRHArchEmp">
				<cfset vRHAEid = insRHArchEmp.identity>
				
				<cfif isdefined("form.archivo") and len(trim(form.archivo))>
					<cftry>
						<!--- Windows acepta slash (/) y backslash(\) como separadores de directorio, 
							  unix solo permite slash(/), por eso usamos unicamente el slash(/) con la 
							  seguridad que los dos SO lo soportan --->
						<cfset error = false >
						<cfset rootdir = ExpandPath('') >
						<cfset ruta = "#rootdir#/rh/expediente/catalogos/archivos">
						<cfset ruta = replace(ruta,'\','/', 'ALL')>
						<cfset filename = replace(form.archivo, '\', '/', 'all') >
						<cfset temp_arreglo = listtoarray(filename, '/') >
						<cfset filename = trim(temp_arreglo[arraylen(temp_arreglo)]) >
						<cfset nombre_arreglo = listtoarray(filename, '.') >

						<cfif not directoryexists(ruta)>
							<cfset error = true >
						</cfif>
				
						<cfif not error >
							<cffile action="upload" destination="#ruta#" nameConflict="overwrite" fileField="form.archivo">
							
							<cfset Actual  = #cffile.serverDirectory# &'\'& #cffile.serverFile#>
							<cfset list1 = " ,á,é,í,ó,ú,Á,É,Í,Ó,Ú,Ñ,ñ">
							<cfset list2 = "_,a,e,i,o,u,a,e,i,o,u,n,n">
							<cfset nombreArchivo = ReplaceList(cffile.serverFile,list1,list2)>	
							<cfset Nuevo   = #cffile.serverDirectory# &'\'& #vRHAEid#&'_'&#nombreArchivo#>
							<cffile action = "rename" source = "#Actual#" destination = "#Nuevo#" attributes="normal"> 
							
						</cfif>
						<cfcatch type="any">
							<cfset error = true >
							<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail#">
						</cfcatch>		
					</cftry>	
				<cfelse>
					<cfthrow message="#MSG_SeleccionArchivo#">
				</cfif>
				<cfquery name="updRHArchEmp" datasource="#Session.DSN#">
					update RHArchEmp set 
						RHAEarchivo			=  '#vRHAEid#_#nombreArchivo#',
						RHAEruta 			=  <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#cffile.serverDirectory#">,
						RHAEtipo 			=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#cffile.serverFileExt#">
					where RHAEid = #vRHAEid#
				</cfquery>
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="rsdataObj" datasource="#session.DSN#">
					select ltrim(rtrim(RHAEruta)) as RHAEruta ,ltrim(rtrim(RHAEarchivo)) as RHAEarchivo
					from RHArchEmp
					where  RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAEid#">  
				</cfquery>
				<cfif rsdataObj.recordCount GT 0>
					<cfset full_path_name = #rsdataObj.RHAEruta# &'\'& #rsdataObj.RHAEarchivo#>
					<cffile action = "delete"	file = "#full_path_name#">
				</cfif>
				<cfquery name="delRHArchEmp" datasource="#Session.DSN#">
					delete from RHArchEmp 
					where RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAEid#">
				</cfquery>
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				<cfquery name="updRHArchEmp" datasource="#Session.DSN#">
					update RHArchEmp set
						RHAEdescr			=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAEdescr#">,
						RHAEfecha 			=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHAEfecha)#">,
						BMusumod 			=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						BMfechamod 			=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">							
					where RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAEid#">
				</cfquery>
				<cfset modo="ALTA">
			</cfif>
		</cftransaction>	
	</cfif>

		<cfif Session.Params.ModoDespliegue EQ 1>
		<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">
	<cfelseif Session.Params.ModoDespliegue EQ 0>
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
	</cfif>

	<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">			
		<input name="o" type="hidden" value="10">		
		<input name="sel" type="hidden" value="1">
	</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

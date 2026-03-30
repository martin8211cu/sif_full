<!--- Proceso de Inserción, Modificación y Borrado --->
<cfset params="">
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta")>
		<!--- Observaciones --->
		<cfset vObservaciones = " " & Replace(form.ACCTobservaciones,'<p>&nbsp;</p>','','all')>
		<cfset vObservaciones = " " & Replace(vObservaciones,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
		
		<!--- Documento Asociado --->
		<cfset vDocumentoAsociado = " " & Replace(form.ACCTdocumentoAsociado,'<p>&nbsp;</p>','','all')>
		<cfset vDocumentoAsociado = " " & Replace(vDocumentoAsociado,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
	
		<cftransaction>
			<cfquery name="rsInsert" datasource="#Session.DSN#">
				insert into ACCreditosTipo (
					Ecodigo, 				TDid, 					ACCTcodigo,		
					ACCTdescripcion, 		ACCTplazo, 				ACCTtasa, 	
					ACCTtasaMora, 			ACCTmodificable,		ACCTunico,
					ACCTobservaciones, 		ACCTdocumentoAsociado, 	ACCTtipo, 			 
					BMUsucodigo,			BMfecha 
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
					<cfif isdefined("Form.TDid") and len(trim(Form.TDid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#"><cfelse>null</cfif>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACCTcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACCTdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ACCTplazo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACCTtasa#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACCTtasaMora#">,
					<cfif isdefined("Form.ACCTmodificable")>1<cfelse>0</cfif>,
					<cfif isdefined("Form.ACCTtipo")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vObservaciones)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vDocumentoAsociado)#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACCTtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsert">
		</cftransaction>		
		<cfset params = params&"&ACCTid="&rsInsert.identity>
		
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsDelete" datasource="#Session.DSN#">
			delete from ACCreditosTipo
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACCTid#">
		</cfquery>		
		
	<cfelseif isdefined("Form.Cambio")>
		<!--- Observaciones --->
		<cfset vObservaciones = Replace(form.ACCTobservaciones,'<p>&nbsp;</p>','','all')>
		<cfset vObservaciones = Replace(vObservaciones,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
		
		<!--- Documento Asociado --->
		<cfset vDocumentoAsociado = Replace(form.ACCTdocumentoAsociado,'<p>&nbsp;</p>','','all')>
		<cfset vDocumentoAsociado = Replace(vDocumentoAsociado,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>

		<cfquery name="rsUpdate" datasource="#Session.DSN#">
			update ACCreditosTipo
			set ACCTdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACCTdescripcion#">,
				TDid = <cfif isdefined("Form.TDid") and len(trim(Form.TDid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#"><cfelse>null</cfif>,
			   	ACCTplazo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ACCTplazo#">,
				ACCTtasa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACCTtasa#">,
				ACCTtasaMora = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACCTtasaMora#">,
			   	ACCTmodificable = <cfif isdefined("Form.ACCTmodificable")>1<cfelse>0</cfif>,	
				ACCTunico = <cfif isdefined("Form.ACCTunico")>1<cfelse>0</cfif>,	
			   	ACCTobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vObservaciones)#">,
			   	ACCTdocumentoAsociado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vDocumentoAsociado)#">,
			   	ACCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACCTtipo#">,
			   	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
			   	BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACCTid#">
		</cfquery>
		<cfset params = params&"&ACCTid="&Form.ACCTid>
		
	</cfif>
				
</cfif>

<cflocation url="CreditosTipo.cfm?#params#">

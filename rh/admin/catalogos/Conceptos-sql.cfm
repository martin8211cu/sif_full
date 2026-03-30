<cfset modo = 'ALTA'>
<cfset dmodo = 'ALTA'>
<cfset action = 'Conceptos.cfm'>

<cftransaction>
	<cfif not isdefined("form.btnNuevoD") and not isdefined("form.btnNuevoE")>			
			<cfif isdefined("Form.btnAgregarE")>
				<cfquery name="chkExists" datasource="#Session.DSN#">
					select 1
					from EConceptosExpediente
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and ECEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ECEcodigo#">
				</cfquery>
				
				<cfif chkExists.recordCount GT 0>
					<cfset msg = "El código para este concepto ya existe">
					<cf_throw message="#msg#" errorcode="2015">
					<cfabort>
				</cfif>
				
				<cfquery name="ABC_ConceptosExp" datasource="#Session.DSN#">
					insert into EConceptosExpediente (CEcodigo, ECEcodigo, ECEdescripcion, ECEmultiple, Usucodigo, Ulocalizacion, ECEfecha)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.ECEcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECEdescripcion#">,
						<cfif isdefined('form.ECEmultiple')>
							1,
						<cfelse>
							0,					
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECEfecha)#">
					)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				
				<cf_dbidentity2 datasource="#session.DSN#" name="ABC_ConceptosExp">
				<cfset modo="CAMBIO">
	
			<cfelseif isdefined("Form.btnBorrarD") and isdefined('form.DCEid') and form.DCEid NEQ "" and isdefined('form.ECEid') and form.ECEid NEQ "">
				<cfquery name="ABC_ConceptosExp" datasource="#Session.DSN#">
					delete from DConceptosExpediente 
					where DCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCEid#">
						and ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECEid#">				
				</cfquery>
				
				<cfset modo="CAMBIO">
				<cfset dmodo="ALTA">
	
			<cfelseif isdefined("Form.btnBorrarE") and isdefined('form.ECEid') and Len(Trim(form.ECEid))>
				<cfquery name="ABC_ConceptosExp" datasource="#Session.DSN#">
					delete from DConceptosExpediente 
					where ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECEid#">
				</cfquery>
				
				<cfquery name="DeleteDetalle" datasource="#Session.DSN#">
					delete from EConceptosExpediente
					where ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECEid#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				</cfquery>
				
				<cfset modo="ALTA">
				<cfset action = 'Conceptos-lista.cfm'>				
	
			<cfelseif isdefined("Form.btnAgregarD")>
				<cfquery name="chkExists1" datasource="#Session.DSN#">
					select 1
					from EConceptosExpediente
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and ECEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ECEcodigo#">
					and ECEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECEid#">
				</cfquery>
				
				<cfif chkExists1.recordCount GT 0>
					<cfset msg = "El código para este concepto ya existe">
					<cf_throw message="#msg#" errorcode="2015">
					<cfabort>
				</cfif>

				<cfquery name="chkExists2" datasource="#Session.DSN#">
					select 1
					from DConceptosExpediente
					where ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECEid#">
					and DCEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DCEcodigo#">
				</cfquery>
				
				<cfif chkExists2.recordCount GT 0>
					<cfset msg = "El código para este detalle de concepto ya existe">
					<cf_throw message="#msg#" errorcode="2020">
					<cfabort>
				</cfif>

				<cf_dbtimestamp datasource="#session.dsn#"
			 			table="EConceptosExpediente"
			 			redirect="Conceptos-form.cfm"
			 			timestamp="#form.ts_rversion#"
						field1="ECEid" 
						type1="numeric" 
						value1="#form.ECEid#"
						field2="CEcodigo" 
						type2="numeric" 
						value2="#Session.CEcodigo#"
						>
				
				<cfquery name="ABC_ConceptosExp" datasource="#Session.DSN#">
					<!--- Cambio del encabezado --->				
					update EConceptosExpediente set 
						ECEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.ECEcodigo)#">,
						ECEdescripcion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECEdescripcion#">,
						<cfif isdefined('form.ECEmultiple')>
							ECEmultiple=1,
						<cfelse>
							ECEmultiple=0,					
						</cfif>
						Usucodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						Ulocalizacion= <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">, 					
						ECEfecha= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECEfecha)#">
					where ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECEid#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				</cfquery>
				
				<cfquery name="InsertDetalle" datasource="#Session.DSN#">
					<!--- Alta del detalle --->
					insert into DConceptosExpediente (ECEid, DCEcodigo, DCEvalor, DCEcuantifica, DCEanotacion, Usucodigo, Ulocalizacion, DCEfecha)
					values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECEid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.DCEcodigo)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DCEvalor#">,
								<cfif isdefined('form.DCEcuantifica') >1,<cfelse>0,</cfif>
								<cfif isdefined('form.DCEanotacion') >1,<cfelse>0,</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">, 					
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DCEfecha)#"> )		
					<cf_dbidentity1 datasource="#session.DSN#">		
				</cfquery>				
				<cf_dbidentity2 datasource="#session.DSN#" name="InsertDetalle">
				
				<cfset modo="CAMBIO">
				<cfset dmodo = 'ALTA'>
	
			
			<cfelseif isdefined("Form.btnCambiarD") and isdefined('form.DCEid') and form.DCEid NEQ "" and isdefined('form.ECEid') and Len(Trim(form.ECEid))>
				<cf_dbtimestamp datasource="#session.dsn#"
					table="EConceptosExpediente"
					redirect="Conceptos-form.cfm"
					timestamp="#form.ts_rversion#"
					field1="ECEid" 
					type1="numeric" 
					value1="#form.ECEid#"
					field2="CEcodigo" 
					type2="numeric" 
					value2="#Session.CEcodigo#"
				>
				<cfquery name="ABC_ConceptosExp" datasource="#Session.DSN#">
					<!--- Cambio del encabezado --->				
					update EConceptosExpediente set 
						ECEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.ECEcodigo)#">,
						ECEdescripcion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECEdescripcion#">,
						<cfif isdefined('form.ECEmultiple')>
							ECEmultiple=1,
						<cfelse>
							ECEmultiple=0,					
						</cfif>
						Usucodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						Ulocalizacion= <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">, 					
						ECEfecha= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECEfecha)#">
					where ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECEid#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				</cfquery>
				
				<cf_dbtimestamp datasource="#session.dsn#"
					table="DConceptosExpediente"
					redirect="Conceptos-form.cfm"
					timestamp="#form.timestampD#"
					field1="ECEid" 
					type1="numeric" 
					value1="#form.ECEid#"
					field2="DCEid" 
					type2="numeric" 
					value2="#form.DCEid#"
				>
				
				<cfquery name="UpdateDetalle" datasource="#Session.DSN#">
					<!--- Cambio del detalle --->
					update DConceptosExpediente set 
						DCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.DCEcodigo)#">,
						DCEvalor= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DCEvalor#">,
						<cfif isdefined('form.DCEcuantifica')  >DCEcuantifica=1,<cfelse>DCEcuantifica=0,</cfif>
						<cfif isdefined('form.DCEanotacion') >DCEanotacion=1,<cfelse>DCEanotacion=0,</cfif>
						Usucodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						Ulocalizacion= <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">, 					
						DCEfecha= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DCEfecha)#">
					where DCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCEid#">
						and ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECEid#">				
				</cfquery>
				
				<cfset modo="CAMBIO">
				<cfset dmodo = "ALTA">	
			</cfif>
	<cfelseif isdefined("form.btnNuevoD")>		
		<cfset modo="CAMBIO">
		<cfset dmodo = 'ALTA'>
	</cfif>
</cftransaction>

<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">	
	<input name="ECEid" type="hidden" value="
		<cfif isdefined("ABC_ConceptosExp") and isdefined("Form.btnAgregarE")>
			<cfoutput>#ABC_ConceptosExp.identity#</cfoutput>
		<cfelse>
			<cfoutput>#Form.ECEid#</cfoutput>
		</cfif>"
	>
	<cfif not isdefined("Form.btnCambiarD")  and isdefined("Form.DCEid") and not isdefined("Form.btnAgregarE") and not isdefined("Form.btnAgregarD") and not isdefined("form.btnNuevoD") and not isdefined("form.btnBorrarE") and not isdefined("form.btnBorrarD")>
		<input name="DCEid" type="hidden" value="
			<cfif isdefined("InsertDetalle")>
				<cfoutput>#InsertDetalle.identity#</cfoutput>
			<cfelse >
				<cfoutput>#Form.DCEid#</cfoutput>
			</cfif>"
		>
	</cfif>
	<input name="dmodo" type="hidden" value="<cfif isdefined("dmodo")><cfoutput>#dmodo#</cfoutput></cfif>">	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
 </form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		
		<!--- Arma la regla --->
		<cfset CaracterComp="_">
		<cfset AlineamientoComp="DER">					
		
		<cfoutput>
		<cfset reglafinal = Form.Cmayor>
		<cfset cniv = 0>
		<cfloop list="#form.MascaraReal#" delimiters="-" index="nivel">
			<cfset cniv = cniv+1>
			<cfif cniv gt 1>
				<cfset guion="">
				<cfif len(nivel) gt len(evaluate("PCRregla" & cniv))>
					<cfset diferencia = len(nivel) - len(evaluate("PCRregla" & cniv))>					
					<cfloop from="1" to="#diferencia#" step="1" index="indice">
						<cfif AlineamientoComp eq "DER">
							<cfset guion=guion & CaracterComp>
						<cfelse>
							<cfset guion=CaracterComp & guion>
						</cfif>
					</cfloop>
				</cfif>
				<cfset reglafinal = trim(reglafinal) & "-" & #evaluate("PCRregla" & cniv)# & guion>
			</cfif>
		</cfloop>
		</cfoutput>
		<!--- Arma la regla --->
		
		<cfquery name="ABC_ReglasXMascara" datasource="#Session.DSN#">
			insert INTO PCReglas 
			(Ecodigo, Cmayor, PCEMid, OficodigoM, PCRregla, PCRvalida, PCRdesde, PCRhasta,Usucodigo,Ulocalizacion)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">,
				<cfif isDefined("Form.OficodigoM") and Len(Trim(Form.OficodigoM)) GT 0>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OficodigoM#">,
				<cfelse>
					null,
				</cfif>
				<!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRregla#">,  --->
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#reglafinal#">,				
				<cfif isdefined('form.PCRvalida')>
					1,
				<cfelse>
					0,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRdesde)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRhasta)#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">					
			)
		</cfquery>
							
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja") and isdefined('Form.PCRid') and Form.PCRid NEQ ''>			
		<cfquery name="ABC_ReglasXMascara" datasource="#Session.DSN#">
			delete from PCReglas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
		</cfquery>
				  
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio") and isdefined('Form.PCRid') and Form.PCRid NEQ '' and isdefined('Form.ts_rversion') and Form.ts_rversion NEQ ''>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="PCReglas" 
			redirect="ReglasXMascaraCuenta.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#Session.Ecodigo#"
			field2="PCRid,numeric,#form.PCRid#">
				
		<!--- Arma la regla --->
		<cfset CaracterComp="_">
		<cfset AlineamientoComp="DER">			
		
		<cfoutput>
		<cfset reglafinal = Form.Cmayor>
		<cfset cniv = 0>
		<cfloop list="#form.MascaraReal#" delimiters="-" index="nivel">
			<cfset cniv = cniv+1>
			<cfif cniv gt 1>
				<cfset guion="">
				<cfif len(nivel) gt len(evaluate("PCRregla" & cniv))>
					<cfset diferencia = len(nivel) - len(evaluate("PCRregla" & cniv))>					
					<cfloop from="1" to="#diferencia#" step="1" index="indice">
						<cfif AlineamientoComp eq "DER">
							<cfset guion=guion & CaracterComp>
						<cfelse>
							<cfset guion=CaracterComp & guion>
						</cfif>						
					</cfloop>
				</cfif>
				<cfset reglafinal = trim(reglafinal) & "-" & #evaluate("PCRregla" & cniv)# & guion>
			</cfif>
		</cfloop>
		</cfoutput>
		<!--- Arma la regla --->				
				
		<cfquery name="ABC_ReglasXMascara" datasource="#Session.DSN#">
			update PCReglas set 
				<!--- PCRregla= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRregla#">,  --->
				PCRregla= <cfqueryparam cfsqltype="cf_sql_varchar" value="#reglafinal#">,
				<cfif isdefined('form.PCRvalida')>
					PCRvalida=1,
				<cfelse>
					PCRvalida=0,
				</cfif>
				OficodigoM = 
				<cfif isDefined("Form.OficodigoM") and Len(Trim(Form.OficodigoM)) GT 0>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OficodigoM#">,
				<cfelse>
					null,
				</cfif>					
				PCRdesde=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRdesde)#">,
				PCRhasta=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRhasta)#">,
				Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				Ulocalizacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
				PCRref = 
				<cfif isDefined("Form.PCRref") and Len(Trim(Form.PCRref)) GT 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRref#">
				<cfelse>
					null
				</cfif>					
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
		</cfquery>

		<cfset modo="CAMBIO">		  
	</cfif>
</cfif>
<form action="ReglasXMascaraCuenta.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Cmayor" type="hidden" value="<cfif isdefined("Form.Cmayor")><cfoutput>#Form.Cmayor#</cfoutput></cfif>">
	<input name="PCRid" type="hidden" value="<cfif isdefined("Form.PCRid") and modo NEQ 'ALTA'><cfoutput>#Form.PCRid#</cfoutput></cfif>">	
	<input name="PCEMid" type="hidden" value="<cfif isdefined("Form.PCEMid")><cfoutput>#Form.PCEMid#</cfoutput></cfif>">		
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
	<input name="ItemId" type="hidden" value="<cfif isdefined("Form.ItemId") and modo NEQ 'ALTA'><cfoutput>#Form.ItemId#</cfoutput></cfif>">		
	<input type="hidden" name="CPVid" value="<cfif isdefined("Form.CPVid")><cfoutput>#form.CPVid#</cfoutput></cfif>">
 </form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

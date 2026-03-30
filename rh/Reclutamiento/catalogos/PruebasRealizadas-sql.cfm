
<cfset modoPruebas = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHPruebasOferente (
			Ecodigo,
			RHPcodigopr,
			DEid, 
			RHOid,
			RHPNota,  
			RHPobservaciones,
			RHPfecha,        
			BMUsucodigo,     
			BMfechaalta
			)
			values(	
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigopr#">,
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">,
			<cfelse>
				null,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHPNota, ',','','all')#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPobservaciones#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHPfecha)#">,
 			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#"> 
			)	
		</cfquery>			
		<cfset modoPruebas="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHPruebasOferente
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigopr#">
			  	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
				</cfif>	
		</cfquery>  
		<cfset modoPruebas="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<!--- --->
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHPruebasOferente"
			 			redirect="PruebasRealizadas.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHPcodigopr" 
						type2="char" 
						value2="#form.RHPcodigopr#"
						field3="RHOid"
						type3="numeric" 
						value3="#form.RHOid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHPruebasOferente
			set 
			RHPNota 			= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHPNota, ',','','all')#">,
			RHPobservaciones 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPobservaciones#">,
			RHPfecha 			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHPfecha)#">,
			BMUsucodigo			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,     
			BMfechaalta			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#"> 
			
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
			  and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigopr#">
			  	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
				</cfif>	
		</cfquery> 
		<cfset modoPruebas="CAMBIO">
	</cfif>
</cfif>

<cfoutput>

<form action="<cfif isdefined("form.DEid") and len(trim(form.DEid))>expediente.cfm<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>../../Reclutamiento/catalogos/OferenteExterno.cfm</cfif>" method="post" name="sqlprueba">
	<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
	<input name="RHOid" type="hidden" value="<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>#form.RHOid#</cfif>">
	<input type="hidden" name="tab" value="6">
	<input name="o" type="hidden" value="6">			
	<input name="sel" type="hidden" value="1">
	<cfif modoPruebas neq 'ALTA'>
		<input name="RHPcodigopr" type="hidden" value="<cfif isdefined("form.RHPcodigopr") and len(trim(form.RHPcodigopr))>#form.RHPcodigopr#</cfif>">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
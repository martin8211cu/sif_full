<!--- <cfdump var="#form#"> --->

<!--- <cfset modo="ALTA"> --->
	<cfif not isdefined("Form.Nuevo")>
		<cftransaction>
			<cfif isdefined("Form.Alta")>
				<cfquery name="rsInsertaExperiencia" datasource="#session.DSN#">
					insert into RHExperienciaOferentes (Ecodigo, RHOid, RHEOnombre, RHEOpuesto, RHEOfingreso, 
						RHEOfsalida, RHEOjefe, RHEOrazon, RHEOtelefono, BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOpuesto#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.RHEOfingreso#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.RHEOfsalida#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOjefe#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOrazon#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOtelefono#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>			
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertaExperiencia">
				<cfset modo="CAMBIO">
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="rsDeleteExperiencia" datasource="#session.DSN#">
					delete from RHExperienciaOferentes
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHEOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEOid#">
				</cfquery>
			<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio")>
				<cfquery name="rsUpdateExperiencia" datasource="#session.DSN#">
					update RHExperienciaOferentes
					set	Ecodigo 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						RHOid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">, 
						RHEOnombre   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOnombre#">,
						RHEOpuesto   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOpuesto#">, 
						RHEOfingreso = <cfqueryparam cfsqltype="cf_sql_date" value="#form.RHEOfingreso#">, 
						RHEOfsalida  = <cfqueryparam cfsqltype="cf_sql_date" value="#form.RHEOfsalida#">,
						RHEOjefe 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOjefe#">,
						RHEOrazon  	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOrazon#">,
						RHEOtelefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEOtelefono#">,
						BMUsucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						<!--- ¿Qué pasó con el ts_rversion? --->
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHEOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEOid#">
				</cfquery>
				<cfset modo="CAMBIO">
			</cfif>
		</cftransaction>	
	</cfif>
	
<cfif isdefined("Form.Alta")>
	<cfset vNewExpe = "">
	<cfif isdefined('rsInsertaExperiencia')>
		<cfset vNewExpe = rsInsertaExperiencia.identity>
	</cfif>
</cfif>	 

	<form action="OferenteExterno.cfm" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="RHEOid" type="hidden" 
		value="<cfoutput><cfif isdefined("Form.Cambio") and isdefined("form.RHEOid")>#form.RHEOid#<cfelseif isdefined('vNewExpe')>#vNewExpe#</cfif></cfoutput>">	
		<input name="RHOid" type="hidden" value="<cfif isdefined("form.RHOid")><cfoutput>#form.RHOid#</cfoutput></cfif>">			
		<input name="o" type="hidden" value="2">			
		<input name="sel" type="hidden" value="1">
	</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

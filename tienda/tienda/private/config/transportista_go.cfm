<cfparam name="form.orden" default="999">
<cfif REFind("^[0-9]+$",form.orden) IS 0><cfset form.orden = 999></cfif>

<cfif isdefined("Form.Nuevo")>
	<cfset form.transportista = "">
<cfelse>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery datasource="#Session.DSN#">
				insert Transportista (Ecodigo, nombre_transportista, orden, tracking_url)
				values (
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim (Form.nombre_transportista)#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tracking_url#"> )
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery datasource="#Session.DSN#">
				delete from Transportista
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and transportista  = <cfqueryparam value="#Form.transportista#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery datasource="#Session.DSN#">
				update Transportista
				set nombre_transportista = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim (Form.nombre_transportista) #">,
				    orden = <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim (Form.orden) #">,
					tracking_url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tracking_url#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and transportista = <cfqueryparam value="#Form.transportista#" cfsqltype="cf_sql_numeric">
				  
				update Transportista
				set orden = orden + 1
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and orden >= <cfqueryparam value="#Trim(Form.orden)#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo="CAMBIO">
		</cfif>
		<!--- Reordenar transportistas --->
		<cftransaction>
			<cfquery datasource="#session.dsn#" name="ordenado">
				select transportista
				from Transportista
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				order by orden, upper(nombre_transportista)
			</cfquery>
			<cfloop query="ordenado">
				<cfquery datasource="#Session.DSN#">
					update Transportista
					set orden = <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim (ordenado.CurrentRow) #">
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and transportista = <cfqueryparam value="#ordenado.transportista#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfloop>
		</cftransaction>
	<cfcatch type="database">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="transportista.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="transportista" type="hidden" value="<cfif isdefined("Form.transportista")><cfoutput>#Form.transportista#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>


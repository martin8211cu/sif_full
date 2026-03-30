<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>


		<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into GEtipoGasto (Ecodigo, GETtipo, GETdescripcion,BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GETtipo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GETdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">			 
				
			)

			
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsBaja" datasource="#Session.DSN#">
			delete from GEtipoGasto
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and GETid = <cfqueryparam value="#Form.GETid#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="GEtipoGasto" 
			redirect="C_TipoGasto.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#session.Ecodigo#"			
			field2="GETid,integer,#form.GETid#">


			<cfquery name="rsCambio" datasource="#Session.DSN#">
				update GEtipoGasto set
					GETdescripcion = <cfqueryparam value="#Form.GETdescripcion#" cfsqltype="cf_sql_varchar">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and GETid = <cfqueryparam value="#Form.GETid#" cfsqltype="cf_sql_numeric">
			</cfquery>	
			
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="C_TipoGasto.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
<input name="GETid" type="hidden" value="<cfif isdefined("Form.GETid") and modo NEQ 'ALTA'>#Form.GETid#</cfif>">

</cfoutput>		
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

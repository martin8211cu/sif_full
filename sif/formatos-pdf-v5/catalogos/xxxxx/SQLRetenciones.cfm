<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="Retenciones" datasource="#Session.DSN#">
		set nocount on
			<cfif isdefined("Form.Alta")>
				if not exists (select Rcodigo from Retenciones  
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
  				  and Rcodigo = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">
				)
				insert Retenciones (Ecodigo, Rcodigo, Rdescripcion, Ccuentaretc,  Ccuentaretp, Rporcentaje)
				values
				(				
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Rcodigo#">)),
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Rdescripcion#">)),
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaretc#">, 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaretp#">,
					 <cfqueryparam cfsqltype="cf_sql_float"   value="#Form.Rporcentaje#">
				 )
				 else
				 	select 1
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from Retenciones
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Rcodigo  = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update Retenciones set 
					Rdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Rdescripcion#">)), 
					Ccuentaretc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaretc#">, 
					Ccuentaretp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaretp#">,
					Rporcentaje = <cfqueryparam cfsqltype="cf_sql_float"   value="#Form.Rporcentaje#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Rcodigo = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">
				  and timestamp = convert(varbinary,#lcase(Form.timestamp)#)				
				  <cfset modo="CAMBIO">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Retenciones.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Rcodigo" type="hidden" value="<cfif isdefined("Form.Rcodigo")><cfoutput>#Form.Rcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>



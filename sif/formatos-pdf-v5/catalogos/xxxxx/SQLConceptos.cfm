<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="Conceptos" datasource="#Session.DSN#">
		set nocount on
			<cfif isdefined("Form.Alta")>
			if not exists (select Ccodigo from Conceptos  
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
  				  and Ccodigo = <cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_char">
				)
				insert Conceptos (Ecodigo, Ccodigo, Cdescripcion, Ctipo )
        		values 
				(				
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#">)),
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">)), 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">
				 )
				else
				select 1
				 
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from Conceptos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Cid = <cfqueryparam value="#Form.Cid#" cfsqltype="cf_sql_integer">
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update Conceptos set 
					Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#">,
					Cdescripcion=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">, 
					Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Cid = <cfqueryparam value="#Form.Cid#" cfsqltype="cf_sql_integer">
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
<form action="Conceptos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Cid" type="hidden" value="<cfif isdefined("Form.Cid")><cfoutput>#Form.Cid#</cfoutput></cfif>">
	<input name="Ccodigo" type="hidden" value="<cfif isdefined("Form.Ccodigo")><cfoutput>#Form.Ccodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>



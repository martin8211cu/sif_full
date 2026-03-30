<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="SNegocios" datasource="#Session.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				insert SNContactos (Ecodigo  , SNcodigo  , SNCidentificacion  , SNCnombre , 
				SNCdireccion  , SNCtelefono , SNCfax , SNCemail , SNCfecha )
				values 
				(
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
 					 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNCidentificacion#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCnombre#">, 
 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCdireccion#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCtelefono#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCFax#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCemail#"> ,
 				    <cfqueryparam value="#LSDateFormat(Form.SNCfecha,'YYYYMMDD')#" cfsqltype="cf_sql_varchar">
				)
				 
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from SNContactos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				  and SNCcodigo = <cfqueryparam value="#Form.SNCcodigo#" cfsqltype="cf_sql_integer">
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update SNContactos  set 
					SNCidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNCidentificacion#">, 
					SNCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCnombre#">, 
					SNCdireccion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCdireccion#"> , 
					SNCtelefono =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCtelefono#"> , 
					SNCfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCfax#">, 
					SNCemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCemail#"> 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				  and SNCcodigo = <cfqueryparam value="#Form.SNCcodigo#" cfsqltype="cf_sql_integer">				  
				  and timestamp = convert(varbinary,#lcase(Form.timestamp)#)				
				  <cfset modo="CAMBIO">
			</cfif>
			set nocount on
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Contactos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="SNcodigo" type="hidden" value="<cfif isdefined("Form.SNcodigo")><cfoutput>#Form.SNcodigo#</cfoutput></cfif>">
	<input name="SNCcodigo" type="hidden" value="<cfif isdefined("Form.SNCcodigo")><cfoutput>#Form.SNCcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>



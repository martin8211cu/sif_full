<cfif not isDefined("Form.NuevoUS") >
	<!--- Agregar Usuario de Tipo de Expediente --->
	<cfif isDefined("Form.AltaUS")>
		<cfquery name="Insert" datasource="#session.DSN#">
			insert into UsuariosTipoExpediente (TEid, Usucodigo) 
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
					)
		</cfquery>							
	<!--- Borrar Usuario de Tipo de Expediente--->
	<cfelseif isDefined("Form.BajaUS")>			
		<cfquery name="Delete" datasource="#session.DSN#">
			delete from UsuariosTipoExpediente 
			where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
			  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">				  
		</cfquery>
	</cfif>			
</cfif>
<cfoutput>

<form action="UsuariosExp-lista.cfm" method="post" name="sql">
	<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid))>
		<input name="TEid" type="hidden" value="#Form.TEid#">
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")>#Form.PageNum#</cfif>">
</form>

</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
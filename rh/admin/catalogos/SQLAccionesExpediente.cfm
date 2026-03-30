<cfparam name="ac_modo" default="ALTA">

<cfif not isDefined("Form.Nuevo") >			
	<!--- Agregar Acción de Tipo de Expediente --->
	<cfif isDefined("Form.AltaAC")>
		<cfquery name="Insert" datasource="#Session.DSN#">
			insert into AccionesTipoExpediente (TEid, RHTid, EFEid, Usucodigo, Ulocalizacion) 
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					'00'
					)
		</cfquery>	
							
	<!--- Borrar Acción de Tipo de Expediente--->
	<cfelseif isDefined("Form.BajaAC")>
		<cfquery name="Delete" datasource="#Session.DSN#">
			delete from AccionesTipoExpediente 
			where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
			  and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
			  and EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFEid#">				  
		</cfquery> 
	</cfif>			

</cfif>

<cfoutput>
<form action="FormatosPrincipal.cfm" method="post" name="sql">
	<input name="ef_modo" type="hidden" value="CAMBIO">
	<input name="ac_modo" type="hidden" value="<cfif isdefined("ac_modo")>#ac_modo#</cfif>">
	<input name="TEid" type="hidden" value="#Form.TEid#">
	<input name="EFEid" type="hidden" value="#Form.EFEid#">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
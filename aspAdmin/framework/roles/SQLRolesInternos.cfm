<cfparam name="action"  default="RolesInternos.cfm">

<cftransaction>
<cftry>
	<cfif isdefined("form.pListaBtnSel") and len(trim(form.pListaBtnSel)) eq 0 >
		<cfquery name="alta_usuarioRol" datasource="sdc">
				set nocount on
				insert into UsuarioPermiso (Usucodigo, Ulocalizacion, rol, BMUsucodigo, BMUlocalizacion, BMUsulogin)
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="00">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#form.rol#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#"> )
				set nocount off
		</cfquery>
		<cfset action = "ConlisRIUsuarios.cfm" >
			
	<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
		<cfset borrar = true >

		<cfif form.rol eq 'sys.pso'>
			<cfquery name="rsPso" datasource="sdc">
				select * from UsuarioPermiso where rol = 'sys.pso'
			</cfquery>
			<cfif rsPso.RecordCount eq 1>
				<cfset borrar = false>
			</cfif>
		</cfif>
		
		<cfif borrar >
			<cfquery name="baja_usuarioRol" datasource="sdc">
				<cfloop index="dato" list="#form.chk#">
					set nocount on
						update UsuarioPermiso
						set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						  , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
						  , BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
						  , BMfechamod = getDate()
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
						  and Ulocalizacion = '00'
						  and rol = <cfqueryparam cfsqltype="cf_sql_char" value="#form.rol#">
	
						delete UsuarioPermiso
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
						  and Ulocalizacion = '00'
						  and rol = <cfqueryparam cfsqltype="cf_sql_char" value="#form.rol#">
					set nocount off
				</cfloop>
			</cfquery>
		</cfif>

	</cfif>
<cfcatch type="database">
	<cfinclude template="../error/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

</cftransaction>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="rol" type="hidden" value="<cfoutput>#form.rol#</cfoutput>">
	<input name="update" type="hidden" value="true">
	<input type="hidden" name="Pagina" value="<cfif modo neq 'ALTA' and isdefined("pagina")>#pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
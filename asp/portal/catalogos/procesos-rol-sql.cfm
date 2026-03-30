<!---<cftry>--->
	<cfif isdefined("form.Agregar")>
		<cfquery name="rs" datasource="asp">
			insert into SProcesosRol ( SScodigo, SMcodigo, SPcodigo, SRcodigo, BMUsucodigo, BMfecha )
			values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				   )
		</cfquery>
		<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
			method="actualizar">
			<cfinvokeargument name="SScodigo" value="#Form.SScodigo#">
			<cfinvokeargument name="SMcodigo" value="#Form.SMcodigo#">
			<cfinvokeargument name="SPcodigo" value="#Form.SPcodigo#">
		</cfinvoke>
	<cfelseif isdefined("form.Guardar")>
			<cfquery name="rs" datasource="asp">
				update SProcesosRol
				set SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
				SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
				where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
				  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo2#">
				  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
  				  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">
			</cfquery>
	<cfelseif isdefined("form.Eliminar")>
		<cfquery name="rs" datasource="asp">
			delete from SProcesosRol
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo2#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
			  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">
		</cfquery>
		<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
			method="actualizar">
			<cfinvokeargument name="SScodigo" value="#Form.SScodigo#">
			<cfinvokeargument name="SMcodigo" value="#Form.SMcodigo2#">
			<cfinvokeargument name="SPcodigo" value="#Form.SPcodigo2#">
		</cfinvoke>
	</cfif>
	
	<!---
	<cfcatch type="database">
		<cflocation url="procesos-rol.cfm">	
	</cfcatch>
</cftry>
--->

<cfoutput>
<form action="<cfif isdefined("form.btnRoles")>roles.cfm<cfelse>procesos-rol.cfm</cfif>" method="post" name="sql">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">

		<cfif isdefined("form.fSScodigo")>
			<input type="hidden" name="fSScodigo" value="#Form.fSScodigo#">
		</cfif>
		
		<cfif isdefined("form.fSMcodigo")>
			<input type="hidden" name="fSMcodigo" value="#form.fSMcodigo#">
		</cfif>
	
		<cfif isdefined("form.fProceso")>
			<input type="hidden" name="fProceso" value="#form.fProceso#">
		</cfif>

		<input type="hidden" name="SRcodigo" value="#form.SRcodigo#">
		<input type="hidden" name="SScodigo" value="#form.SScodigo#">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
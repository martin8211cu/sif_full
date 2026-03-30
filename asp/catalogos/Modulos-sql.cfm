<cfif isdefined("form.accion")>
	<cfif form.accion EQ 2>
		<cfset codigos = ListToArray(Form.SMcodigo, '|')>
		
		<cfquery name="rs" datasource="asp">
			insert INTO  ModulosCuentaE(CEcodigo, SScodigo, SMcodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(codigos[1])#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(codigos[2])#">
			)
		</cfquery>
		
		<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
			method="actualizar">
			<cfinvokeargument name="CEcodigo" value="#Session.Progreso.CEcodigo#">
			<cfinvokeargument name="SScodigo" value="#codigos[1]#">
		</cfinvoke>
	<cfelseif form.accion EQ 3>
		<cfquery name="rs" datasource="asp">
			delete from ModulosCuentaE
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
			and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigoDel#">
			and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigoDel#">
		</cfquery>
		<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
			method="actualizar">
			<cfinvokeargument name="CEcodigo" value="#Session.Progreso.CEcodigo#">
			<cfinvokeargument name="SScodigo" value="#Form.SScodigoDel#">
		</cfinvoke>
	</cfif>
</cfif>	

<cfif isdefined("form.accion")>
	<cfif form.accion eq 1>
		<cflocation url="/cfmx/asp/catalogos/Caches.cfm">
	<cfelseif form.accion EQ 2 or form.accion EQ 3>
		<HTML>
		<head>
		</head>
		<body>
			<form action="/cfmx/asp/catalogos/Modulos.cfm" method="post" name="sql">
				<cfif isdefined("Form.SScodigo") and Len(Trim(Form.SScodigo)) NEQ 0>
					<input type="hidden" name="SScodigo" value="<cfoutput>#Form.SScodigo#</cfoutput>">
				</cfif>
				<input type="hidden" name="dummy" value="dummy">
			</form>
			<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
		</body>
		</HTML>
	</cfif>
</cfif>

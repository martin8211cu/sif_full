<cfset roles = "edu.admin, edu.docente, edu.estudiante, edu.encargado, edu.asistente, edu.director">
<cfset rolesDesc = "Administrador del Centro de Estudios, Docente, Estudiante, Padre de Familia o Encargado, Asistente, Director">
<cfset rolCod = "4, 5, 6, 7, 11, 12">

<cfquery name="rolesUsr" datasource="#Session.DSN#">
	select distinct b.rol
	from UsuarioEmpresarial a, UsuarioEmpresa d, EmpresaID e, UsuarioPermiso b, Rol c, Empresa f, CuentaClienteEmpresarial g
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	  and e.consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and a.Usucodigo = d.Usucodigo
	  and a.Ulocalizacion = d.Ulocalizacion
	  and a.cliente_empresarial = d.cliente_empresarial
	  and a.activo = 1
	  and d.activo = 1
	  and d.Ecodigo = f.Ecodigo
	  and d.cliente_empresarial = f.cliente_empresarial
	  and f.activo = 1
	  and e.Ecodigo = f.Ecodigo
	  and e.sistema = 'edu'
	  and e.consecutivo is not null
	  and e.nombre_cache is not null
	  and e.activo = 1
	  and b.Usucodigo = d.Usucodigo
	  and b.Ulocalizacion = d.Ulocalizacion
	  and b.cliente_empresarial = d.cliente_empresarial
	  and b.Ecodigo = d.Ecodigo
	  and b.activo = 1
	  and b.rol = c.rol
	  and c.sistema = e.sistema
	  and c.activo = 1
	  and f.cliente_empresarial = g.cliente_empresarial
	  and g.activo = 1
</cfquery>

<cfinclude template="common.cfm">

<!--- Cuando es un nuevo mensaje --->
<cfif isdefined("Form.o") and Form.o EQ 2>
	<!--- Asegurarme de la validez del rol que envía --->
	<cfif isdefined("Form.senderRol") and Len(Trim(Form.senderRol)) NEQ 0
		  and ListFind(Replace(rolCod, ' ' , '', 'all'), Form.senderRol, ',') NEQ 0
	      and ListFind(Replace(ValueList(rolesUsr.rol, ','), ' ', '', 'all'), 
					   Trim(
							ListGetAt(roles, ListFind(Replace(rolCod, ' ' , '', 'all'), Form.senderRol, ','), ',')
					   ), 
					   ',') NEQ 0>
		<cfif Form.senderRol EQ 5>
			<cfinclude template="sendMessage-profesor.cfm">
		<cfelseif Form.senderRol EQ 6>
			<cfinclude template="sendMessage-estudiante.cfm">
		<cfelseif Form.senderRol EQ 7>
			<cfinclude template="sendMessage-encargado.cfm">
		<cfelseif Form.senderRol EQ 12>
			<cfinclude template="sendMessage-director.cfm">
		</cfif>
	</cfif>

<!--- Cuando se esta respondiendo un mensaje --->
<cfelseif isdefined("Form.o") and Form.o EQ 4 and isdefined("Form.Bcodigo") and Len(Trim(Form.Bcodigo)) NEQ 0>
	<cfset PrmDe = Form.txtFrom>
	<cfset PrmPara = Form.txtTo>
	<cfset PrmAsunto = Form.txtAsunto>
	<cfset PrmMsg = Form.txtMSG>
	<cfquery name="qryCorreos" datasource="#Session.DSN#">
		select convert(varchar, BUsucodigoOr) as PrmUsucodigo, 
			   BUlocalizacionOr as PrmUlocalizacion
		from Buzon
		where Bcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bcodigo#">
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	</cfquery>
	<cfif qryCorreos.recordCount GT 0>
		<cfscript>
			NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, qryCorreos.PrmUsucodigo, qryCorreos.PrmUlocalizacion);
		</cfscript>
	</cfif>
</cfif>

<HTML>
<head>
</head>
<body>
<cfoutput>
<form action="sendMessage-result.cfm" method="post" name="sql">
	<input name="NoEnviados" type="hidden" value="<cfif isdefined("NoEnviados")>#NoEnviados#</cfif>">
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

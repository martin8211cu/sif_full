<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("url.NTIcodigo") and url.NTIcodigo NEQ "-1" and isdefined("url.DEidentificacion") and Len(Trim(url.DEidentificacion)) NEQ 0 >
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, a.DEidentificacion, 
			{fn concat(		{fn concat(		
			{fn concat(		{fn concat(
				a.DEapellido1 , ' ')} , a.DEapellido2 )} ,  ', ' )} ,  a.DEnombre )} as NombreCompleto
			
			<cfif Url.valus EQ 1>
			   , b.Usucodigo
			</cfif>
		from DatosEmpleado a

		<cfif Url.valemp EQ 1>
			inner join LineaTiempo lt
				on lt.DEid = a.DEid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
		</cfif>

		<cfif Url.valasoc EQ 1>
			inner join ACAsociados asoc
				on asoc.DEid = a.DEid
                and asoc.ACAestado = 1
		</cfif>

		<cfif Url.valus EQ 1>
			inner join UsuarioReferencia b
				on <cf_dbfunction name="to_number" args="b.llave"> = a.DEid
				and b.llave = <cf_dbfunction name="to_char" args="a.DEid">
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
				and b.STabla = 'DatosEmpleado'

			inner join Usuario c
				on c.Usucodigo = b.Usucodigo
				and c.Uestado = 1 
				and c.Utemporal = 0
				
			inner join DatosPersonales d
				on d.datos_personales = c.datos_personales
				and d.Pid = a.DEidentificacion
		</cfif>
		
		<cfif isdefined("Url.CFid") and Len(Trim(Url.CFid))>
			<cfif Url.valemp NEQ 1>
				inner join LineaTiempo lt
					on lt.DEid = a.DEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
			</cfif>
			
			inner join RHPlazas p
				on p.RHPid = lt.RHPid
				and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CFid#">
		</cfif>

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.DEidentificacion)#">
		
		<cfif len(Trim(url.NTIcodigo))>
			and a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(url.NTIcodigo)#">
		</cfif>
		
		<cfif Url.valcomp EQ 1>
			and exists (
				select 1
				from RolEmpleadoSNegocios x
				where x.RESNtipoRol = 2
				and x.DEid = a.DEid
				and x.Ecodigo = a.Ecodigo
			)
		</cfif>
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		<cfoutput>
		if (parent.ctlid) parent.ctlid.value = "#rsEmpleado.DEid#";
		if (parent.ctlident) parent.ctlident.value = "#rsEmpleado.DEidentificacion#";
		if (parent.ctlemp) parent.ctlemp.value = "#rsEmpleado.NombreCompleto#";
		<cfif Url.valus EQ 1>
		parent.ctlusu.value = "#rsEmpleado.Usucodigo#";
		</cfif>
		
		if (window.parent.funcDEid){ window.parent.funcDEid(); }
		var funcName = 'window.parent.func#rsEmpleado.DEid#';
		if (eval(funcName)){ eval(funcName)(); }
		</cfoutput>
	</script>
	
<cfelseif isdefined("url.NTIcodigo") and (trim(url.NTIcodigo) EQ "-1") and isdefined("url.DEidentificacion") and (Len(Trim(url.DEidentificacion)) NEQ 0) and not isdefined("url.tarjeta")>
	<!--- Para cuando no se necesita el tipo de identificacion (NTIcodigo= "-1") --->
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, a.DEidentificacion, a.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# a.DEapellido2 #LvarCNCT# ', ' #LvarCNCT# a.DEnombre as NombreCompleto
			<cfif Url.valus EQ 1>
			   , b.Usucodigo
			</cfif>
		from DatosEmpleado a

		<cfif Url.valus EQ 1>
				inner join UsuarioReferencia b
					on <cf_dbfunction name="to_number" args="b.llave"> = a.DEid
					and b.llave = <cf_dbfunction name="to_char" args="a.DEid">
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
					and b.STabla = 'DatosEmpleado'
	
				inner join Usuario c
					on c.Usucodigo = b.Usucodigo
					and c.Uestado = 1 
					and c.Utemporal = 0
					
				inner join DatosPersonales d
					on d.datos_personales = c.datos_personales
					and d.Pid = a.DEidentificacion
		</cfif>

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.DEidentificacion)#">
		<cfif Url.valcomp EQ 1>
			and exists (
				select 1
				from RolEmpleadoSNegocios x
				where x.RESNtipoRol = 2
				and x.DEid = a.DEid
				and x.Ecodigo = a.Ecodigo
			)
		</cfif>
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		<cfoutput>
		parent.ctlid.value = "#rsEmpleado.DEid#";
		parent.ctlident.value = "#rsEmpleado.DEidentificacion#";
		parent.ctlemp.value = "#rsEmpleado.NombreCompleto#";
		<cfif Url.valus EQ 1>
		parent.ctlusu.value = "#rsEmpleado.Usucodigo#";
		</cfif>
		
		if (window.parent.funcDEid){ window.parent.funcDEid(); }
		var funcName = 'window.parent.func#rsEmpleado.DEid#';
		if (eval(funcName)){ eval(funcName)(); }
		</cfoutput>
	</script>
</cfif>
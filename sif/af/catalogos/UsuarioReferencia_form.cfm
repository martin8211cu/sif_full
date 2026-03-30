<cfif isdefined("btnAsignar")>
	<cfset fnAsignar(form.DEid, form.Usucodigo_A)>
</cfif>
<cf_navegacion name="DEid" default="">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<form name="form1" method="post" action="UsuarioReferencia.cfm">
	<strong>Identificacion de Empleado:</strong>
	<cf_dbfunction name="to_char" args="a.DEid"  returnvariable="DEidA">
	<cf_conlis
		traerInicial="#form.DEid NEQ ''#"  
		traerFiltro="DEid = #form.DEid#"  
		Campos="DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2"
		Desplegables="N,S,S,S,S"
		Modificables="N,S,N,N,N"
		Size="0,15,30,30,30"
		tabindex="5"
		readonly="#NOT (isdefined('form.btnEmpleado') OR form.DEid EQ '')#"
		Title="Lista de Empleados"
		Tabla="DatosEmpleado a "
		Columnas="DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2, (select coalesce(min(u.Usulogin),'**') from UsuarioReferencia b inner join Usuario u on u.Usucodigo = b.Usucodigo where b.Ecodigo=#session.EcodigoSDC# and b.STabla = 'DatosEmpleado' and b.llave = #DEidA#) as Usuarios"
		Filtro=" Ecodigo = #Session.Ecodigo#  "
		Desplegar="DEidentificacion, DEnombre, DEapellido1, DEapellido2, Usuarios"
		Etiquetas="Identificacion, Nombre, Apellido1, Apellido2, Login (**=Sin Usuario)"
		filtrar_por="DEidentificacion | DEnombre | DEapellido1 | DEapellido2 | (select coalesce(min(u.Usulogin),'**') from UsuarioReferencia b inner join Usuario u on u.Usucodigo = b.Usucodigo where b.Ecodigo=#session.EcodigoSDC# and b.STabla = 'DatosEmpleado' and b.llave = #DEidA#)"
		filtrar_por_delimiters="|"
		Formatos="S,S,S,S,S"
		Align="left,left,left,left,left"
		form="form1"
		Asignar="DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2"
		Asignarformatos="S,S,S,S,S"
	/>

	<cfif isdefined("form.btnEmpleado")>
		<cfset form.DEid = "">
	</cfif>
		
	<cfif form.DEid EQ "">
		<input type="submit" value="Buscar Posibles Usuarios" name="btnUsuario" onclick="return (this.form.DEid.value != '')"/>
		</form>
		<cfexit>
	</cfif>

	<cfquery name="rsUsuario" datasource="#session.DSN#" >
		select u.Usucodigo
		  from Usuario u
			inner join UsuarioReferencia b
				 on b.Ecodigo	= #session.EcodigoSDC#
				and b.STabla	= 'DatosEmpleado'
				and b.llave		= '#form.DEid#'
				and b.Usucodigo	= u.Usucodigo
			inner join DatosPersonales p
				 on p.datos_personales = u.datos_personales
		 where u.CEcodigo = #session.CEcodigo#
	</cfquery>
	
	<cfset LvarUsucodigoAsignado = -1>
	<cfif rsUsuario.recordCount GT 0>
		<cfset LvarUsucodigoAsignado = rsUsuario.Usucodigo>
	<cfelse>
		<br><strong>Empleado no tiene Usuario Asignado</strong> <br> 
		<cfset LvarUsucodigoAsignado = -1>
	</cfif>
	
	<cfquery name="rsEmpleado" datasource="#session.DSN#" >
		select DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2
		  from DatosEmpleado
		 where Ecodigo	= #session.Ecodigo#
		   and DEid		= #form.DEid#
	</cfquery>
	<cf_dbfunction name="to_char" args="d.DEid" returnvariable="DEidB">
	<cfquery name="rsUsuario" datasource="#session.DSN#" >
		select '<font color="blue">USUARIO ASIGNADO AL EMPLEADO:</font>' as A, 0 as orden, u.Usucodigo, u.Usulogin, p.Pid, p.Pnombre, p.Papellido1, p.Papellido2, Uestado
			, coalesce((
					select 'ASIGNADO A ' #_Cat#  DEidentificacion
					  from UsuarioReferencia b
						inner join DatosEmpleado d
							 on b.Ecodigo	= #session.EcodigoSDC#
							and b.STabla	= 'DatosEmpleado'
							and b.llave		= #preserveSingleQuotes(DEidB)#
					 where b.Usucodigo = u.Usucodigo
			), case when Uestado = 1 then 'ACTIVO' else 'INACTIVO' end) as Estado
		  from Usuario u
			inner join DatosPersonales p
				on p.datos_personales = u.datos_personales
		 where u.CEcodigo = #session.CEcodigo#
		   and u.Uestado = 1
	
		   and u.Usucodigo = #LvarUsucodigoAsignado#
		UNION
		select 'POSIBLES USUARIOS CON LA MISMA IDENTIFICACION DEL EMPLEADO:' as A, 1 as orden, u.Usucodigo, u.Usulogin, p.Pid, p.Pnombre, p.Papellido1, p.Papellido2, Uestado
			, coalesce((
				select 'ASIGNADO A '#_Cat# DEidentificacion
				  from UsuarioReferencia b
					inner join DatosEmpleado d
						 on b.Ecodigo	= #session.EcodigoSDC#
						and b.STabla	= 'DatosEmpleado'
						and b.llave		= #preserveSingleQuotes(DEidB)#
				 where b.Usucodigo = u.Usucodigo
			), case when Uestado = 1 then 'ACTIVO' else 'INACTIVO' end) as Estado
		  from Usuario u
			inner join DatosPersonales p
				on p.datos_personales = u.datos_personales
		 where u.CEcodigo = #session.CEcodigo#
		   and u.Uestado = 1
	
		   and u.Usucodigo	<> #LvarUsucodigoAsignado#
		   and p.Pid 		= '#trim(rsEmpleado.DEidentificacion)#'
		UNION
		select 'POSIBLES USUARIOS CON LOS MISMOS APELLIDOS Y NOMBRE DEL EMPLEADO:' as A, 2 as orden, u.Usucodigo, u.Usulogin, p.Pid, p.Pnombre, p.Papellido1, p.Papellido2, Uestado
			, coalesce((
				select 'ASIGNADO A '#_Cat# DEidentificacion
				  from UsuarioReferencia b
					inner join DatosEmpleado d
						 on b.Ecodigo	= #session.EcodigoSDC#
						and b.STabla	= 'DatosEmpleado'
						and b.llave		= #preserveSingleQuotes(DEidB)#
				 where b.Usucodigo = u.Usucodigo
			), case when Uestado = 1 then 'ACTIVO' else 'INACTIVO' end) as Estado
		  from Usuario u
			inner join DatosPersonales p
				on p.datos_personales = u.datos_personales
		 where u.CEcodigo = #session.CEcodigo#
		   and u.Uestado = 1
	
		   and u.Usucodigo	<> #LvarUsucodigoAsignado#
		   and p.Pid 		<> '#trim(rsEmpleado.DEidentificacion)#'
		   and upper(p.Papellido1)	= '#trim(ucase(rsEmpleado.DEapellido1))#'
		   and upper(p.Papellido2)	= '#trim(ucase(rsEmpleado.DEapellido2))#'
		   and upper(p.Pnombre)		= '#trim(ucase(rsEmpleado.DEnombre))#'
		UNION
		select 'POSIBLES USUARIOS CON EL MISMO PRIMER APELLIDO DEL EMPLEADO:' as A, 3 as orden, u.Usucodigo, u.Usulogin, p.Pid, p.Pnombre, p.Papellido1, p.Papellido2, Uestado
			, coalesce((
				select 'ASIGNADO A ' #_Cat# DEidentificacion
				  from UsuarioReferencia b
					inner join DatosEmpleado d
						 on b.Ecodigo	= #session.EcodigoSDC#
						and b.STabla	= 'DatosEmpleado'
						and b.llave		= #preserveSingleQuotes(DEidB)#
				 where b.Usucodigo = u.Usucodigo
			), case when Uestado = 1 then 'ACTIVO' else 'INACTIVO' end) as Estado
		  from Usuario u
			inner join DatosPersonales p
				on p.datos_personales = u.datos_personales
		 where u.CEcodigo = #session.CEcodigo#
		   and u.Uestado = 1
	
		   and u.Usucodigo	<> #LvarUsucodigoAsignado#
		   and p.Pid 		<> '#trim(rsEmpleado.DEidentificacion)#'
		   and (
				upper(p.Papellido2)	<> '#trim(ucase(rsEmpleado.DEapellido2))#'
				or 
				upper(p.Pnombre)	<> '#trim(ucase(rsEmpleado.DEnombre))#'
				)

		   and upper(p.Papellido1)	= '#trim(ucase(rsEmpleado.DEapellido1))#'
		   and (
				upper(p.Pnombre) like '%#trim(ucase(rsEmpleado.DEnombre))#%'
				OR
				<cf_dbfunction name="like"	args="'#trim(ucase(rsEmpleado.DEnombre))#','%' #_Cat# rtrim(upper(p.Pnombre)) #_Cat# '%'">
				)
		ORDER BY orden
	</cfquery>

	<br><strong>Usuarios con información relacionada al Empleado:</strong><br>
	<table cellpadding="0" cellspacing="2" border="0" style="width:100%">
		<tr>
			<td valign="top">
				<!--- Lista de Usuarios --->
				<cfset navegacionU = ''>
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pLista"
					query="#rsUsuario#"
					formname="form1"
					cortes="A"
					desplegar="Usulogin, Pid, Pnombre, Papellido1, Papellido2, Estado"
					etiquetas="Login, Identificacion, Nombre, Apellido1, Apellido2, Estado"
					formatos="S,S,S,S,S,S"
					align="left,left,left,left,left,left"
					navegacion="#navegacionU#"
					maxrows="0"
					keys="Usucodigo"
					pageindex="2"
					ira="UsuarioReferencia.cfm"
					lineaAzul = "orden EQ 0"
					lineaRoja = "Uestado EQ 0"
					incluyeForm="no"
					funcion="fnAsignar"
					fparams="Usulogin, Estado"
					/>
			</td>
		</tr>
	</table>

	<br><strong>Usuario que debe ser asignado al Empleado:</strong><br>
	<cf_dbfunction name="to_char" args="d.DEid"  returnvariable="DEidB">
	<cf_conlis
		Campos="Usucodigo_A, Usulogin_A, Pid_A, Pnombre_A, Papellido1_A, Papellido2_A, Empleado_A"
		Desplegables="N,S,S,S,S,S,N"
		Modificables="N,S,N,N,N,N,N"
		Size="0,10,15,30,30,30,0"
		tabindex="5"
		Title="Lista de Usuarios Activos"
		Tabla="Usuario u inner join DatosPersonales p on p.datos_personales = u.datos_personales "
		Columnas="Usucodigo as Usucodigo_A, Usulogin as Usulogin_A, Pid as Pid_A, Pnombre as Pnombre_A, Papellido1 as Papellido1_A, Papellido2 as Papellido2_A
			, (
				select d.DEidentificacion
				  from UsuarioReferencia b
					inner join DatosEmpleado d
						 on b.Ecodigo	= #session.EcodigoSDC#
						and b.STabla	= 'DatosEmpleado'
						and b.llave		= #preserveSingleQuotes(DEidB)#
				 where b.Usucodigo	= u.Usucodigo
			) as Empleado_A
				"
		Filtro=" u.CEcodigo = #session.CEcodigo# and u.Uestado = 1 "
		Desplegar="Usulogin_A, Pid_A, Pnombre_A, Papellido1_A, Papellido2_A,Empleado_A"
		Etiquetas="Login, Identificacion, Nombre, Apellido1, Apellido2, Empleado"
		filtrar_por="Usulogin, Pid, Pnombre, Papellido1, Papellido2, "
		Formatos="S,S,S,S,S,U"
		Align="left,left,left,left,left"
		form="form1"
		Asignar="Usucodigo_A, Usulogin_A, Pid_A, Pnombre_A, Papellido1_A, Papellido2_A, Empleado_A"
		Asignarformatos="S,S,S,S,S,S,S"
		funcion="fnVerificarAsignacion"
		fparams="Usucodigo_A"
		width="800"
	/>

	<script language="javascript">
		function fnVerificarAsignacion()
		{
			if (document.form1.Usucodigo_A.value == "")
			{
				return false;
			}
			<cfoutput>
			else if (document.form1.Usucodigo_A.value == "#LvarUsucodigoAsignado#")
			</cfoutput>
			{
				limpiaUsucodigo_A();
				alert ("El usuario ya está asignado al Empleado");
				return false;
			}
			else if (document.form1.Empleado_A.value != "")
			{
				var LvarU = document.form1.Usulogin_A.value;
				var LvarE = document.form1.Empleado_A.value;
				limpiaUsucodigo_A();
				alert ("El Usuario '" + LvarU + "' no puede ser asignado porque pertenece al Empleado Id = " + LvarE);
				return false;
			}
		}
		function fnAsignar(Usulogin, Estado)
		{
			if (Estado == "INACTIVO")
			{
				alert ("El usuario no puede ser asignado porque está inactivo");
				document.form1.nosubmit = true;
			}
			else
			{
				document.form1.Usulogin_A.value = Usulogin;
				traeUsulogin_A(document.form1.Usulogin_A.value, true);
			}
		}
	</script>
	<br>
	<cfif LvarUsucodigoAsignado NEQ "-1">
		<input type="submit" value="Reasignar a este Usuario" name="btnAsignar" onclick="if (document.form1.Usucodigo_A.value == '') return false;"/>
	<cfelse>
		<input type="submit" value="Asignar Usuario" name="btnAsignar" onclick="if (document.form1.Usucodigo_A.value == '') return false;"/>
	</cfif>
	<input type="submit" value="Cambiar Empleado" name="btnEmpleado"/>
</form>

<cffunction name="fnAsignar" access="private" output="false">
	<cfargument name="DEid"			type="numeric" required="yes">
	<cfargument name="Usucodigo"	type="numeric" required="yes">

	<cfquery name="rsEmpleado" datasource="#session.DSN#" >
		select Usucodigo
		  from UsuarioReferencia b
		 where b.Ecodigo	= #session.EcodigoSDC#
		   and b.STabla		= 'DatosEmpleado'
		   and b.llave		= '#Arguments.DEid#'
	</cfquery>
	
	<cfquery name="rsUsuario" datasource="#session.DSN#" >
		select b.Usucodigo, u.Usulogin
		  from UsuarioReferencia b
		  	inner join Usuario u 
			 on u.Usucodigo = b.Usucodigo
		 where b.Ecodigo	= #session.EcodigoSDC#
		   and b.STabla		= 'DatosEmpleado'
		   and b.Usucodigo	= #Arguments.Usucodigo#
	</cfquery>
	
	<cfif rsUsuario.recordCount GT 0>
		<cfif rsUsuario.Usucodigo eq rsEmpleado.Usucodigo>
			<cf_errorCode	code = "50047"
							msg  = "El Usuario '@errorDat_1@' ya está Asignado al Empleado"
							errorDat_1="#rsUsuario.Usulogin#"
			>
		<cfelse>
			<cf_errorCode	code = "50048"
							msg  = "El Usuario '@errorDat_1@' está Asignado a otro Empleado"
							errorDat_1="#rsUsuario.Usulogin#"
			>
		</cfif>
	</cfif>

	<cfif rsEmpleado.Usucodigo NEQ "">
		<cfquery datasource="#session.DSN#" >
			delete from UsuarioReferencia
			 where Ecodigo	= #session.EcodigoSDC#
			   and STabla	= 'DatosEmpleado'
			   and llave	= '#form.DEid#'
		</cfquery>
	</cfif>

	<cfquery datasource="#session.DSN#" >
		insert into UsuarioReferencia
			(Ecodigo, STabla, llave, Usucodigo, BMUsucodigo)
		values (#session.EcodigoSDC#, 'DatosEmpleado', '#form.DEid#', #Arguments.Usucodigo#, #session.Usucodigo#)
	</cfquery>
	<cflocation url="UsuarioReferencia.cfm?DEid=#Arguments.DEid#">
</cffunction>


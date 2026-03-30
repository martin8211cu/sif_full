<!---ELIMINADO DE EMPRESA
<cfset demo.Ecodigo = 1116>
<cfset demo.EcodigoSDC = 1135>
<cfset demo.DSN = 'minisif_base'>
<cfset demo.CEcodigo =  500000000000706>
<cfset demo.UsucodigoDemo =  15320>
---->

<!----
<cfquery name="rsEmpleados" datasource="#demo.DSN#">
	select * from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.Ecodigo#">
</cfquery>
---->

<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"><!---Activar el componente de seguridad(home\componentes\Seguridad.cfc)--->
<cftransaction>
	<!---
	<cfloop query="rsEmpleados"><!---Para c/empleado eliminar el usuario---->
		<cfset vnDEid = rsEmpleados.DEid>
		<!--- Buscar Usuario según Referencia --->
		<!---<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">--->
		<cfset datos_usuario = sec.getUsuarioByRef(vnDEid, session.ecodigosdcnuevo, 'DatosEmpleado')>		
		<cfif datos_usuario.recordCount GT 0>
			<!--- Borrar Referencia --->
			<cfset sec.delUsuarioRef(datos_usuario.Usucodigo, session.ecodigosdcnuevo, 'DatosEmpleado')>
			<cfquery name="chk_delete_Usuario" datasource="asp">
				select 1 as existe from dual
				where exists (
					select 1 from UsuarioRol
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				) or exists (
					select 1 from UsuarioProceso
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				) or exists (
					select 1 from UsuarioReferencia
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				) or exists (
					select 1 from UsuarioSustituto
					where Usucodigo1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
					or Usucodigo2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				)
			</cfquery>
			<cfif chk_delete_Usuario.recordCount EQ 0>
				<cfquery name="_datosUsuario" datasource="asp">
					select id_direccion, datos_personales
					from Usuario
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigoNuevo#">
				</cfquery>
				<cfset id_direccion = _datosUsuario.id_direccion>
				<cfset datos_personales = _datosUsuario.datos_personales>
			
				<cfquery name="_deletePasswords" datasource="asp">
					delete UsuarioPassword
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				</cfquery>
				
				<cfquery name="_deleteRol" datasource="asp">
					delete UsuarioRol 
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				</cfquery>
				
				<cfquery name="_deleteProceso" datasource="asp">
					delete UsuarioProceso 
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				</cfquery>	
						
				<cfquery name="_deletePreferencias" datasource="asp">
					delete Preferencias 
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				</cfquery>	
				
				<cfquery name="_delete_Usuario" datasource="asp">
					delete Usuario
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigoNuevo#">
				</cfquery>
				
				<cfquery name="_deleteReqInfo" datasource="asp">
					delete ReqInfo
					where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_direccion#">
				</cfquery>
						
				<cfquery name="_deleteDirecciones" datasource="asp">
					delete Direcciones
					where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_direccion#">
				</cfquery>
				
				<cfquery name="_deleteDatosPersonales" datasource="asp">
					delete DatosPersonales
					where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_personales#">
				</cfquery>								
			</cfif>	
		</cfif>	
	</cfloop>
	---->
	<!---ELIMINAR EL USUARIO KE SOLICITO LA DEMO--->
	<!--- Borrar Referencia --->
	<!---<cfset sec.delUsuarioRef(demo.UsucodigoDemo, session.ecodigosdcnuevo, 'DatosPersonales')>--->
	<cfquery name="chk_delete_Usuario" datasource="asp">
		select 1 as existe from dual
		where exists (
			select 1 from UsuarioRol
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		) or exists (
			select 1 from UsuarioProceso
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		) or exists (
			select 1 from UsuarioReferencia
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		) or exists (
			select 1 from UsuarioSustituto
			where Usucodigo1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
			or Usucodigo2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		)
	</cfquery>
	<cfif chk_delete_Usuario.recordCount NEQ 0>
		<cfquery name="_datosUsuario" datasource="asp">
			select id_direccion, datos_personales
			from Usuario
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.CEcodigo#">
				<!----<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigoNuevo#">---->
		</cfquery>
		<cfset id_direccion = _datosUsuario.id_direccion>
		<cfset datos_personales = _datosUsuario.datos_personales>
	
		<cfquery name="_deletePasswords" datasource="asp">
			delete UsuarioPassword
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		</cfquery>
		
		<cfquery name="_deleteRol" datasource="asp">
			delete UsuarioRol 
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		</cfquery>
		
		<cfquery name="_deleteProceso" datasource="asp">
			delete UsuarioProceso 
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		</cfquery>	
				
		<cfquery name="_deletePreferencias" datasource="asp">
			delete Preferencias 
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		</cfquery>	
		<!---*******--->
		<cfquery name="_deleteORGPermiso" datasource="asp">
			delete ORGPermisosAgenda 
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		</cfquery>	
		<cfquery name="_deleteSPorlet" datasource="asp">
			delete SPortletPreferencias 
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		</cfquery>	
		<cfquery name="_deleteUsuarioRef" datasource="asp">
			delete UsuarioReferencia 
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
		</cfquery>	
		<!---*******--->
		<cfquery name="_delete_Usuario" datasource="asp">
			delete Usuario
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.UsucodigoDemo#">
				<!----and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigoNuevo#">----->
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.CEcodigo#">
		</cfquery>
		
		<cfquery name="_delete_Usuario" datasource="asp">
			select * from Usuario
			where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_direccion#">
		</cfquery>		
		<cfquery name="_deleteReqInfo" datasource="asp">
			delete ReqInfo
			where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_direccion#">
		</cfquery>
		
		<cfquery name="_deleteDirecciones" datasource="asp">
			<!---delete Direcciones---->
			select * from Direcciones
			where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_direccion#">
		</cfquery>		
		<cfquery name="_deleteDatosPersonales" datasource="asp">
			delete DatosPersonales
			where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_personales#">
		</cfquery>						
	</cfif>	
</cftransaction>

<cftransaction>	
	<cfinclude template="eliminaCapacitacion.cfm">
	<cfinclude template="borraRelEvaluac.cfm">
	<cfinclude template="eliminaEmpleados.cfm">
	<cfinclude template="eliminaCFuncionalPlazas.cfm">
	<cfinclude template="eliminaPuestos.cfm">	
	<cfinclude template="eliminaHabilidades.cfm">
	<cfinclude template="eliminaConocimientos.cfm">
	<cfinclude template="borraNomina.cfm">
	<!--- Borra ALGUNOS parametros de SIF --->
	<cfinclude template="eliminaSIF.cfm">
	<cfinclude template="BorrarParametrosDemo.cfm">	
	<cfinclude template="eliminaOtros.cfm">	
</cftransaction>
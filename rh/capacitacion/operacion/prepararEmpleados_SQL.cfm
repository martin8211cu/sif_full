<cfsetting requesttimeout="#3600*24#">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Preparando Empleados ...</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
.cajasinbordeb {
	border: 0px none;
	background-color: #FFFFFF;
}
</style>
</head>

<body marginheight="0" marginwidth="0">


	<cfparam name="Form.EmpresaCuenta" type="numeric" default="#Url.EmpresaCuenta#">

	<cfif isdefined("Form.EmpresaCuenta") and Len(Trim(Form.EmpresaCuenta))>
		<cfquery name="rsEmpresaRef" datasource="asp">
			select a.CEcodigo, a.Ereferencia as Ecodigo, b.Ccache as DSN
			from Empresa a, Caches b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EmpresaCuenta#">
			and a.Cid = b.Cid
		</cfquery>
	
		<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>
			  <table width="100%" height="50%"  border="0" cellpadding="0" cellspacing="0">
				<tr>
				  <td id="td1" width="1%" height="21" bgcolor="#0099FF"></td>
				  <td id="td2" width="100%" height="21"></td>
				  <td width="1%" height="21" nowrap>&nbsp;&nbsp;<input type="text" name="txt1" id="txt1" value="1%" size="3" class="cajasinbordeb"></td>
				</tr>
			  </table>
		 	</td>
		  </tr>
		</table>
	
		<script language="javascript" type="text/javascript">
			function aumentarStatus(strValor){
				var td1 = document.getElementById("td1");
				var txt1 = document.getElementById("txt1");
				td1.width = strValor;
				txt1.value = strValor;
			}
			
			function resetStatus() {
				var td1 = document.getElementById("td1");
				var txt1 = document.getElementById("txt1");
				td1.width = '1%';
				txt1.value = '1%';
			}
		</script>
		
		<cfflush>

		<!--- Invocación del Componente de Seguridad del Framework --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset nuevosRoles = createObject("component", "asp.Componentes.Roles").getRolesNuevoUsuario()>
	
		<!--- Averiguar el Idioma y Pais de la Cuenta Empresarial --->
		<cfquery name="rsDatosCuenta" datasource="asp">
			select rtrim(a.LOCIdioma) as LOCIdioma, b.Ppais
			from CuentaEmpresarial a, Direcciones b
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresaRef.CEcodigo#">
			and a.id_direccion = b.id_direccion
		</cfquery>
		
		<!--- Averiguar los empleados que no tengan usuario y crearles un usuario --->
		<cfquery name="rsEmpleadosSinUsuario" datasource="#rsEmpresaRef.DSN#">
			select a.DEid,
				   a.DEidentificacion,
				   a.DEnombre,
				   a.DEapellido1,
				   a.DEapellido2,
				   a.DEfechanac,
				   a.DEsexo,
				   a.DEtelefono1,
				   a.DEtelefono2,
				   a.DEemail,
				   a.DEdireccion
			from DatosEmpleado a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresaRef.Ecodigo#">
            and not exists (
				select 1
				from UsuarioReferencia b
				where b.STabla = 'DatosEmpleado'
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EmpresaCuenta#">
				and a.DEid = <cf_dbfunction name="to_number" args="b.llave">
			)
			order by a.DEid
		</cfquery>
        
		<!--- Crear Usuarios --->
        <cfset err = ''> 
		<cfloop query="rsEmpleadosSinUsuario">
		    <cfset vEmail = rsEmpleadosSinUsuario.DEemail>
            <!---Si el logueo se realiza vía google y no existe un correo configurado, no se permite la generación del usuario hasta que el corrreo sea colocado en los datos del empleado--->
            <cfset doUser = true>
			<cfif listFindNoCase(Application.politicas_pglobal.auth.orden,'google',',') GT 0  and not len(trim(vEmail))>
				<cfset doUser = false>
			</cfif>
           <cfif doUser> 
           	<cftry>
                <cftransaction>
                
                
				<!--- Inserta los datos personales --->
                <cfquery datasource="asp" name="DPinserted">
                    insert into DatosPersonales (
                        Pid, Pnombre, Papellido1, Papellido2, Pnacimiento,
                        Psexo, Pcasa, Pcelular, Pemail1, 
                        BMUsucodigo, BMfechamod)
                    values (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEidentificacion#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEnombre#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEapellido1#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEapellido2#">,
                        <cfif Len(Trim(rsEmpleadosSinUsuario.DEfechanac))>
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsEmpleadosSinUsuario.DEfechanac#">,
                        <cfelse>
                            null,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEsexo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEtelefono1#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEtelefono2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEemail#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        <cf_dbfunction name="today">)
                    <cf_dbidentity1 datasource="asp">
                </cfquery>
                <cf_dbidentity2 datasource="asp" name="DPinserted">
   				 <!--- 			select @@identity as datos_personales --->
                <!--- Inserta la direccion --->
                
                <cfquery datasource="asp" name="Dinserted">
                    insert into Direcciones (
                        atencion, direccion1, Ppais,
                        BMUsucodigo, BMfechamod)
                    values (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(rsEmpleadosSinUsuario.DEnombre & ' ' & rsEmpleadosSinUsuario.DEapellido1 & ' ' & rsEmpleadosSinUsuario.DEapellido2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleadosSinUsuario.DEdireccion#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosCuenta.Ppais#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        <cf_dbfunction name="today">)
                    <cf_dbidentity1 datasource="asp">
                </cfquery>
  				 <!--- 				select @@identity as id_direccion --->
                <cf_dbidentity2 datasource="asp" name="Dinserted">
                <!---</cftransaction>--->			
        
                <!--- Inserta el usuario, le asocia la direccion y los datos personales --->
                <cfset user = "*">
                <cfif listFindNoCase(Application.politicas_pglobal.auth.orden,'google',',') GT 0 and len(trim(vEmail))>
                    <cfset user = vEmail>
                </cfif>
                
				<cfif isdefined("url.EnviarEmail")>
                    <cfset enviar_password = Len(Trim(rsEmpleadosSinUsuario.DEemail)) NEQ 0>
                </cfif>
                
                <cfset enviar_password = false>
                <!--- Crear Usuario --->
                <cfset usuario = sec.crearUsuario(rsEmpresaRef.CEcodigo, Dinserted.identity, DPinserted.identity, rsDatosCuenta.LOCIdioma, ParseDateTime('01/01/6100','dd/mm/yyyy'), user, enviar_password)>
                
				<!--- Asociar Referencia --->
                <cfset ref = sec.insUsuarioRef(usuario, Form.EmpresaCuenta, 'DatosEmpleado', rsEmpleadosSinUsuario.DEid)>
                
                <!---Cambia usuarios temporales a activos--->
                <cfif isdefined("url.activarUsuario")>
                    <cfquery datasource="asp" name="Dinserted">
                        Update Usuario
                        set Utemporal = 0
                        where Usucodigo = #usuario#
                    </cfquery>
                </cfif>
                
                <cfoutput>
                <script language="javascript" type="text/javascript">
                    aumentarStatus("#iif(Round(CurrentRow*100/RecordCount) gt 0,Round(CurrentRow*100/RecordCount),1)#%");
                </script>
                </cfoutput>
                
           		</cftransaction>
                
                <cfcatch type="any">
                	<cfset err = err & ' || ' & cfcatch.Message> 
                </cfcatch>
                </cftry>
                
            </cfif> 
             <cfset vEmail = "">
             
            <cfflush>   
		</cfloop>
		<script language="javascript" type="text/javascript">
			resetStatus();
		</script>


		<cfif len(trim(err))>
	    	NO SE GENERARON ALGUNOS USUARIOS: <BR> <cfoutput>#err#</cfoutput> <cfabort>
	    </cfif>


		<!--- Averiguar los empleados con Usuario que no tengan correspondencia en la tabla de PersonaEducativo y agregarlos --->
		<cfquery name="rsNuevosEstudiantes" datasource="#rsEmpresaRef.DSN#">
			select a.DEid,
				   a.DEidentificacion,
				   a.DEnombre,
				   a.DEapellido1,
				   a.DEapellido2,
				   a.DEfechanac,
				   a.DEsexo,
				   a.DEtelefono1,
				   a.DEtelefono2,
				   a.DEemail,
				   a.DEdireccion,
				   b.Usucodigo
			from DatosEmpleado a, UsuarioReferencia b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresaRef.Ecodigo#">
			and b.STabla = 'DatosEmpleado'
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EmpresaCuenta#">
			and a.DEid = <cf_dbfunction name="to_number" args="b.llave">
			and not exists (
				select 1
				from UsuarioReferencia c
				where c.STabla = 'PersonaEducativo'
				and c.Ecodigo = b.Ecodigo
				and c.Usucodigo = b.Usucodigo
			)
			order by a.DEid
		</cfquery>
		
		<!--- Crear Nuevos Estudiantes a partir de los Empleados --->
		<cfloop query="rsNuevosEstudiantes">
			<cftransaction>			
			<!--- Insertar en PersonaEducativo --->
			<cfquery name="NuevoEstudiante" datasource="#rsEmpresaRef.DSN#">
				insert into PersonaEducativo (Ecodigo)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresaRef.Ecodigo#">)
			<cf_dbidentity1 datasource="#rsEmpresaRef.DSN#">
			</cfquery>
<!--- 		select @@identity as Ppersona--->
			<cf_dbidentity2 datasource="#rsEmpresaRef.DSN#" name="NuevoEstudiante">				
			</cftransaction>	
	
			<!--- Asociar Referencia --->
			<cfset refIns = sec.insUsuarioRef(rsNuevosEstudiantes.Usucodigo, Form.EmpresaCuenta, 'PersonaEducativo', NuevoEstudiante.identity)>
		
			<!--- Agregar Rol de Estudiante a los empleados agregados de esta manera --->
			<cfset rolIns = sec.insUsuarioRol(rsNuevosEstudiantes.Usucodigo, Form.EmpresaCuenta, 'RH', 'ALUMNO')>
			
			<cfoutput>
			<script language="javascript" type="text/javascript">
				aumentarStatus("#iif(Round(CurrentRow*100/RecordCount) gt 0,Round(CurrentRow*100/RecordCount),1)#%");
			</script>
			</cfoutput>
			<cfflush>
		</cfloop>
	
		<script language="javascript" type="text/javascript">
			resetStatus();
		</script>
 
		<cfset nuevosRolesAUTO = createObject("component", "asp.Componentes.Roles").getRolesNuevoUsuario()>
		<cfloop array="#nuevosRoles#" index="rolNew">
			<!--- Averiguar los empleados que tengan usuario y no tengan el rol de autogestion --->
			<cfquery name="rsEmpleados" datasource="#rsEmpresaRef.DSN#">
				select a.DEid,
					   a.DEidentificacion,
					   a.DEnombre,
					   a.DEapellido1,
					   a.DEapellido2,
					   a.DEfechanac,
					   a.DEsexo,
					   a.DEtelefono1,
					   a.DEtelefono2,
					   a.DEemail,
					   a.DEdireccion,
					   b.Usucodigo
				from DatosEmpleado a
					inner join UsuarioReferencia b
						on a.DEid = <cf_dbfunction name="to_number" args="b.llave">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresaRef.Ecodigo#">
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EmpresaCuenta#">
						and b.STabla = 'DatosEmpleado'
				where  (
							select count(1)
							from UsuarioRol c
							where c.SScodigo = '#rolNew.SScodigo#'
							and c.SRcodigo = '#rolNew.SRcodigo#'
							and c.Ecodigo = b.Ecodigo
							and c.Usucodigo = b.Usucodigo
						) = 0
				order by a.DEid
			</cfquery>

			<cfloop query="rsEmpleados">
				<!--- Agregar Rol de Autogestión a los empleados que no lo tengan --->
				<cfset rolIns = sec.insUsuarioRol(rsEmpleados.Usucodigo,Form.EmpresaCuenta, rolNew.SScodigo, rolNew.SRcodigo)>
				<cfoutput>
				<script language="javascript" type="text/javascript">
					aumentarStatus("#iif(Round(CurrentRow*100/RecordCount) gt 0,Round(CurrentRow*100/RecordCount),1)#%");
				</script>
				</cfoutput>
				<cfflush>	
			</cfloop>
			
			<script language="javascript" type="text/javascript">
				resetStatus();
			</script>
			</cfoutput>
			<cfflush>
	
		</cfloop>
	
		<script language="javascript" type="text/javascript">
			window.close();
			if (window.opener.Listo) window.opener.Listo();
		</script>
	<cfelse>
		<script language="javascript" type="text/javascript">
			window.close();
		</script>
	</cfif>
</body>
</html>

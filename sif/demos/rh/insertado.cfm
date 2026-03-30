<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Insertado de datos en empresa de demostraciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body style="margin:0">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr> 
			<td>
				<table width="50%" style="border:1px solid black;" align="center"> 
					<tr><td>
						<!---Tabla de una columna que va a ir aumentando el with dinámicamente por medio de un llamado de una funcion de javascript----->
						<table width="0%" id="pct2" bgcolor="#0066CC"><tr><td>&nbsp;</td></tr></table>
					</td></tr>
				</table>
			</td>
		</tr>
	</table>		
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>
			<table width="50%" align="center"> 
				<tr><td nowrap align="center">
					<!---Etiqueta de avance del proceso--->
					<span id="paso" style=" font-size:11px">Cargando datos... </span><span id="percent">0</span>
				</td></tr>
			</table>
		</td></tr>									
	</table>
	<script language='javascript' type='text/JavaScript'>
		var total = 100;//Valor máximo al que se puede llegar		
		function funcDevuelveObjeto(elid){
			return document.all?document.all[elid]:document.getElementById(elid);//devuelve el objeto
		}
		
		function funcAvance(n) {
			var percent = 0;
			percent = Math.floor(n * 100 / total);						//Obtiene el porcentaja
			funcDevuelveObjeto('pct2').width = " " + percent + "%"; 	//Aumenta el with del td (columna) 
			funcDevuelveObjeto('percent').innerHTML = percent + " % ";	//Pinta el porcentaje de avance dinamicamente
			
			if (n == 100){ 												//Cuando se ha llegado al tope
				funcDevuelveObjeto('paso').innerHTML = 'La carga de datos ha finalizado con éxito...';	//Pinta etiqueta de finalización
				funcDevuelveObjeto('percent').innerHTML = '';												
				setTimeout("window.parent.location.href ='/cfmx/asp/catalogos/autoriza-demo.cfm'",1000);	//Envia al menú
			}
		}
	</script>
	<cfflush interval="1">
	
	<cfsetting requesttimeout="8600">

<cftry>	
	<!----
	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")><!---Inicializa el componente---->
	<cfset vn_Ecodigo =  Politicas.trae_parametro_global("demo.Ecodigo")>
	---->
	
	<cfset vn_Ecodigo = 1097>

	<cftransaction>
		<!---Para cada include (insert) en la BD's se llama la función que aumenta el with del td (columna)llamda funcAvance, con un valor representativo del avance---->
		<cfinclude template="ParametrosDemo.cfm">
		<script type="text/javascript" language="javascript1.2">
			funcAvance(5);
		</script>
	
		<cfinclude template="insertaHabilidades.cfm">
		<script type="text/javascript">
			funcAvance(10);
		</script>
		
		<cfinclude template="insertaConocimientos.cfm">
		<script type="text/javascript">
			funcAvance(20);	
		</script>
	
		<cfinclude template="insertaPuestos.cfm">
		<script type="text/javascript">
			funcAvance(30);	
		</script>
				
		<cfinclude template="insertaCFuncional.cfm">
		<script type="text/javascript">
			funcAvance(40);		
		</script>
	
		<cfinclude template="insertaplazas.cfm">
		<script type="text/javascript">
			funcAvance(50);
		</script>
		
		<cfinclude template="insertaNomina.cfm">
		<script type="text/javascript">
			funcAvance(60);
		</script>

		<cfinclude template="insertaEmpleados.cfm">
		<script type="text/javascript">
			funcAvance(70);
		</script>		
			
		<cfinclude template="insertaCapacitacion.cfm">
		<script type="text/javascript">
			funcAvance(75);
		</script>
		
		<cfinclude template="insertaReclutamiento.cfm">
		<script type="text/javascript">
			funcAvance(85);
		</script>

		<cfinclude template="insertaRelEvaluac.cfm">
		<script type="text/javascript">
			funcAvance(90);
		</script>
	</cftransaction>

	<cfcatch type="any">
		<!---
		<cfquery datasource="asp">
			update Usuario
			set Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.usuario#">,
				datos_personales= null
			where Usucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
		</cfquery>
		---->
		<!----======== Eliminar el usuario ========--->
		<cfquery name="_datosUsuario" datasource="asp">
			select id_direccion, datos_personales
			from Usuario
			where Usucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
		</cfquery>
		<cfif _datosUsuario.RecordCount NEQ 0>
			<cfset id_direccion = _datosUsuario.id_direccion>
			<cfset datos_personales = _datosUsuario.datos_personales>
					
			<cfquery name="_deletePasswords" datasource="asp">
				delete UsuarioPassword
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
			</cfquery>
			
			<cfquery name="_deleteRol" datasource="asp">
				delete UsuarioRol 
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
			</cfquery>
			
			<cfquery name="_deleteProceso" datasource="asp">
				delete UsuarioProceso 
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
			</cfquery>	
					
			<cfquery name="_deletePreferencias" datasource="asp">
				delete Preferencias 
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
			</cfquery>	
			<!---*******--->
			<cfquery name="_deleteORGPermiso" datasource="asp">
				delete ORGPermisosAgenda 
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
			</cfquery>	
			<cfquery name="_deleteSPorlet" datasource="asp">
				delete SPortletPreferencias 
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
			</cfquery>	
			<cfquery name="_deleteUsuarioRef" datasource="asp">
				delete UsuarioReferencia 
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
			</cfquery>	
			<!---*******--->
			<cfquery name="_delete_Usuario" datasource="asp">
				delete Usuario
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.usuario#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigoNuevo#">
					<!----and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#demo.CEcodigo#">----->
			</cfquery>					
			<!---
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
			---->
		</cfif>	
		<!---========= Eliminar la empresa ==========--->
		<cfquery datasource="#session.DSNnuevo#" >
			delete Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
		</cfquery>
		<cfquery datasource="#session.DSNnuevo#" >
			delete Empresa where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
		</cfquery>		
		<!---========= Mostrar error ===========--->			
		<cfdump var="#cfcatch#">
		<div align="center">
			Ha ocurrido un error en el proceso de carga de datos. Intentelo de nuevo.<br>
			<cfoutput>#cfcatch.message#</cfoutput>
			<cfoutput>#cfcatch.Detail#</cfoutput>
			<br><a target="_parent" href='/cfmx/asp/catalogos/autoriza-demo.cfm' style="color:#003399"><b>Ir a lista de Solicitudes de Demo</b></a>
		</div>
		<cfabort>	
	</cfcatch>
</cftry>


<!----
<!---/////////////////// Inserta los usuarios de los empleados(Aparte del resto de inserts por el <cftransaccion>, ya que el componente de seguridad se conecta con ASP) ///////////////////---->	
<!---Variables utilizadas ---->
<cfset enviar_password = false><!---Variable para indicarle al componente de seguridad que NO envie un correo al usuario creado---->
<cfset expira = CreateDate(6100, 01, 01)><!---Variable con la fecha de expiración del usuario, por defecto es "infinita"---->
<cfset vsLOCIdioma = 'es'><!---Variable con el idioma por defecto español--->
<!----Seleccion de los empleados ingresados en la nueva empresa---->
<cfquery name="rsEmpleados" datasource="#session.DSNnuevo#">
	select * from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"><!---Activar el componente de seguridad(home\componentes\Seguridad.cfc)--->
	
<cfloop query="rsEmpleados"><!---Para c/empleado se crea un usuario---->
	<cfset vnDEid= rsEmpleados.DEid><!---Variable con el DEid (llave) del empleado creado---->
	<cfset vnDatosUsuario = sec.getUsuarioByRef(vnDEid, session.EcodigoSDCNuevo, 'DatosPersonales')><!---Devuelve el Usucodigo--->	
	<cfif vnDatosUsuario.RecordCount EQ 0><!---Si no existe ya el usuario--->		
		<cfset user = rsEmpleados.DEnombre & session.EcodigoNuevo><!---Variable con el login del usuario, que estará compuesto por el nombre+codigo de la empresa---->			
		<cfquery name="rsUsulogin" datasource="#session.DSNnuevo#"><!---Verificar que no exista el usulogin--->
			select 1 from Usuario where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user#">
		</cfquery>
		<cfif rsUsulogin.RecordCount EQ 0>
			<cftransaction>
				<!--- Inserta los datos personales --->
				<cfquery datasource="#session.DSNnuevo#" name="DPinserted">
					insert into DatosPersonales (Pnombre, Papellido1, Papellido2, Pnacimiento, Psexo, Pcasa, Pcelular, Pemail1, BMUsucodigo, BMfechamod,Pid)
					select 	DEnombre, 
							DEapellido1, 
							DEapellido2,
							DEfechanac,
							DEsexo,
							DEtelefono1,
							DEtelefono2,
							DEemail,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							DEidentificacion
					from DatosEmpleado		
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDEid#">		
					<cf_dbidentity1 datasource="#session.DSNnuevo#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSNnuevo#" name="DPinserted">
				<cfset datos_personales = DPinserted.identity><!---Variable con el identity del insert en DatosPersonales (datos_personales)--->
				<!--- Inserta la dirección --->
				<cfquery datasource="#session.DSNnuevo#" name="Dinserted">
					insert into Direcciones (atencion, direccion1, Ppais, BMUsucodigo, BMfechamod)
					select 	DEnombre||' ' ||DEapellido1||' '||DEapellido2 as atencion,
							DEdireccion,
							Ppais,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					from DatosEmpleado		
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDEid#">		
					<cf_dbidentity1 datasource="#session.DSNnuevo#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSNnuevo#" name="Dinserted">
				
				<cfset id_direccion = Dinserted.identity><!----Variable con el identity del insert en Direcciones (id_direccion)--->
			</cftransaction>			
			<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"><!---Activar el componente de seguridad(home\componentes\Seguridad.cfc)--->
			<cfset usuario = sec.crearUsuario(session.CEcodigoNuevo, id_direccion, datos_personales, vsLOCIdioma, expira, user, enviar_password)><!---Invocación a función del componente de seguridad que crea el usuario--->	
			<cfset ref = sec.insUsuarioRef(usuario, session.EcodigoSDCNuevo, 'DatosEmpleado', vnDEid)><!----Asociar al usuario con UsuarioReferencia--->				
			<!---<cfset rolIns = sec.insUsuarioRol(usuario, Session.EcodigoSDCNuevo, 'RH', 'AUTO')><!--- Insertar Rol de Autogestión --->---->
		</cfif>
	</cfif>	
</cfloop>
---->
<!---Actualizar el estado del parametro 5 (indica si ya se ejecutó el wizard)---->			
<cfquery name="rsConfig" datasource="#session.DSNnuevo#" debug="no"><!---Verificar si ya existe en la tabla el registro--->
	select Pvalor 
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
	and Pcodigo=5
</cfquery>
<cfif isdefined("rsConfig") and rsConfig.RecordCount EQ 0><!---Si no existe el parámetro, lo inserta--->
	<cfquery datasource="#session.DSNnuevo#">
		insert into Parametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
				5,
				'Parametrizacion ya definida',
				'S'
				)
	</cfquery>
<cfelse><!----Si ya existe actualiza el campo para indicar que ya se ejecutó el wizard----->
	<cfquery datasource="#session.DSNnuevo#">
		update Parametros
		set Pvalor = 'S'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
			and Pcodigo = 5
	</cfquery>
</cfif> 
<script type="text/javascript">
	funcAvance(100);
</script>

</body>
</html>

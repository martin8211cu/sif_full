<!---Obtener el Mcodigo de la empresa--->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfloop list="#form.chk#" index="i">
	<!---Seleccion de los datos de la tabla RHAdjudicacion---->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select case  when a.DEid is not null then 'I'
				else 'E' end as tipo,
			case when a.DEid is not null then DEid
				else RHOid end as ID,
			a.RHTid,
			a.Tcodigo,
			a.RVid,
			a.RHJid,
			a.RHCconcurso,
			a.Dcodigo,
			a.Ocodigo,
			a.RHPid,
			a.DLfvigencia,
			a.DLffin,
			a.DLsalario,
			a.RHAporc,
			a.RHAporcsal,
			a.RHPcodigo,
			(
		        select c.RHCPlinea
		        from RHPuestos p
		        inner join RHMaestroPuestoP b
		            on b.RHMPPid = p.RHMPPid
		            and b.Ecodigo = p.Ecodigo
		        inner join RHCategoriasPuesto c
		           on c.RHMPPid = b.RHMPPid
		           and c.Ecodigo = b.Ecodigo
		        where p.RHPcodigo = a.RHPcodigo
		        and p.Ecodigo = a.Ecodigo
		        and c.RHCid = a.RHCid
		        and c.RHTTid = a.RHTTid
			) as RHCPlinea
		from RHAdjudicacion a
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
	</cfquery>

	<cfif len(trim(rsDatos.DLfvigencia))>

		<cfif len(trim(rsDatos.RHTid)) eq 0>
			<cf_errorCode	code="51960" msg="Se debe de indicar la información de la acción de personal">
		</cfif>

		<cfif rsDatos.tipo EQ 'E'><!---Si es un concursante externo se inserta primero en la tabla DatosEmpleado---->
			<!----Seleccion de datos del oferente----->
			<cfquery name="rsOferente" datasource="#session.DSN#">
				select NTIcodigo, RHOidentificacion, RHOnombre, RHOapellido1,RHOapellido2,RHOdireccion,RHOtelefono1,RHOtelefono2,
						RHOemail,RHOcivil,RHOfechanac,RHOsexo,RHOobs1,RHOobs2,RHOobs3,RHOdato1,RHOdato2,RHOdato3,RHOdato4,
						RHOdato5,RHOinfo1,RHOinfo2,RHOinfo3,o.Ppais,o.BMUsucodigo, DEid,d.direccion1 #LvarCNCT# d.direccion2 as direccion
				from DatosOferentes o
				left outer join Direcciones d
				on d.id_direccion=o.id_direccion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
			</cfquery>

			<cfset vNewEmpl = rsOferente.DEid>
			<cfif isdefined("rsOferente") and rsOferente.RecordCount and Len(Trim(rsOferente.DEid)) EQ 0>
				<cftransaction>
					<!--- OPARRALES 2018-11-06 Modificacion para insertar en DatosEmpleado el valor de DEidentificacion como consecutivo --->
					<cfquery name="rsTIdent" datasource="#session.dsn#">
						select
							NTIcaracteres
						from
							NTipoIdentificacion
						where
							Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(rsOferente.NTIcodigo)#">
					</cfquery>

					<cfquery name="rsDE" datasource="#session.dsn#">
						select
							max(convert(numeric,DEidentificacion)) as UltimoDE
						from
							DatosEmpleado
						where IsNumeric(DEidentificacion) = 1
					</cfquery>
					<cfset ultimoNum = rsDE.UltimoDE+1>
					<cfset varVeces = rsTIdent.NTIcaracteres-LEN("#ultimoNum#")>
					<cfset varUltimoDE = RepeatString('0',(varVeces lt 0 ? 0 : varVeces )) & (ultimoNum)>
					<!---Insertado de los datos del oferente en la tabla de DatosEmpleado---->
					<cfquery datasource="#session.DSN#" name="insertar">
						insert into DatosEmpleado(Ecodigo, Bid, NTIcodigo, Tcodigo, DEidentificacion, DEnombre, DEapellido1, DEapellido2,
									CBTcodigo, DEcuenta, CBcc, Mcodigo, DEdireccion, DEtelefono1, DEtelefono2, DEemail, DEcivil, DEfechanac,
									DEsexo, DEobs1, DEobs2, DEobs3, DEdato1, DEdato2, DEdato3, DEdato4, DEdato5, DEinfo1,
									DEinfo2, DEinfo3, Usucodigo, Ulocalizacion, DEusuarioportal, DEtarjeta, DEpassword,Ppais,BMUsucodigo,DESeguroSocial)
						values(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								null,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsOferente.NTIcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.Tcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varUltimoDE#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOnombre#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOapellido1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOapellido2#">,
								null,null,
								<cfqueryparam cfsqltype="cf_sql_char" value="0">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.direccion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOtelefono1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOtelefono2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOemail#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOferente.RHOcivil#">,
								<cfif len(trim(#rsOferente.RHOfechanac#)) gt 0>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOferente.RHOfechanac#">,
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/1900">,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsOferente.RHOsexo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOobs1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOobs2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOobs3#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOdato1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOdato2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOdato3#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOdato4#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOdato5#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOinfo1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOinfo2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOinfo3#">,
								null,null,null,null,null,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.Ppais#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOidentificacion#">)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>

					<cf_dbidentity2 datasource="#session.DSN#" name="insertar">
					<cfset vNewEmpl = insertar.identity>

					<!---- inserta la imagen del oferente a datosEmpleado---->
					<cfquery datasource="#session.dsn#">
						insert into RHImagenEmpleado (DEid,foto,BMUsucodigo)
						select #vNewEmpl#, foto, #session.Usucodigo#
						from RHImagenOferente
						where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
					</cfquery>

					<!---Actualiza el DEid generado para el oferente externo--->
					<cfquery datasource="#session.DSN#"	>
						update DatosOferentes
						set DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
						where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
					</cfquery>
					<!--- Mover los Datos del Oferente hacia el empleado --->
					<cfquery datasource="#Session.DSN#">
						update RHEducacionEmpleado set
							DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
						where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
					</cfquery>
					<cfquery datasource="#Session.DSN#">
						update RHExperienciaEmpleado set
							DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
						where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
					</cfquery>
					<cfquery datasource="#Session.DSN#">
						update RHCompetenciasEmpleado set
							DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
						where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
					</cfquery>
					<cfquery datasource="#Session.DSN#">
						update DatosOferentesArchivos set
							DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">,
							tipo = 'E', aprobado = 0
						where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
					</cfquery>
				</cftransaction>

				<!--------- CREACION DE USUARIO------------------------------------------------------>


				<!--- Insercion del Usuario en el Framework --->
				<!--- Averiguar el Idioma y Pais de la Cuenta Empresarial --->
				<cfquery name="rsDatosCuenta" datasource="asp">
					select rtrim(a.LOCIdioma) as LOCIdioma, b.Ppais
					from CuentaEmpresarial a, Direcciones b
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and a.id_direccion = b.id_direccion
				</cfquery>
				<cftransaction>
					<!--- Inserta los datos personales --->
					<cfquery datasource="asp" name="DPinserted">
						insert into DatosPersonales (Pid, Pnombre, Papellido1, Papellido2, Pnacimiento, Psexo, Pcasa, Pcelular, Pemail1, BMUsucodigo, BMfechamod)
						values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOidentificacion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOapellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOapellido2#">,
							<cfif len(trim(#rsOferente.RHOfechanac#)) gt 0>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOferente.RHOfechanac#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/1900">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOsexo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOtelefono1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOtelefono2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOemail#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
						<cf_dbidentity1 datasource="asp">
					</cfquery>
					<cf_dbidentity2 datasource="asp" name="DPinserted">
					<cfset datos_personales = DPinserted.identity>
					<!--- Inserta la direccion --->
					<cfquery datasource="asp" name="Dinserted">
						insert into Direcciones (atencion, direccion1, Ppais, BMUsucodigo, BMfechamod)
						values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(rsOferente.RHOnombre & ' ' & rsOferente.RHOapellido1 & ' ' & rsOferente.RHOapellido2)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOdireccion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosCuenta.Ppais#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
						<cf_dbidentity1 datasource="asp">
					</cfquery>
					<cf_dbidentity2 datasource="asp" name="Dinserted">
					<cfset id_direccion = Dinserted.identity>
				</cftransaction>

				<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
				<cfset user = "*">
				<cfset enviar_password = false>
				<!--- Crear Usuario --->
				<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
				<cfset usuario = sec.crearUsuario(Session.CEcodigo, id_direccion, datos_personales, rsDatosCuenta.LOCIdioma, LSParseDateTime('01/01/6100'), user, enviar_password)>
				<!--- Asociar Referencia --->
				<cfset ref = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'DatosEmpleado', vNewEmpl)>

				<!--- Insertar Roles--->
				<cfset nuevosRoles = createObject("component", "asp.Componentes.Roles").getRolesNuevoUsuario()>
				<cfloop array="#nuevosRoles#" index="rolNew">
					<cfset rolIns = sec.insUsuarioRol(usuario, Session.EcodigoSDC, rolNew.SScodigo, rolNew.SRcodigo)>
				</cfloop>

				<!--- Se actualiza los archivos que tenga relacionados el oferente con el usucodigo creado como empleado --->
				<cfquery datasource="#Session.DSN#">
					update DatosOferentesArchivos set
						UsuCreador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">
					where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
				</cfquery>

				<!--- --------------- PARA CAPACITACION Y DESARROLLO ------------------ --->
				<!--- Insertar en PersonaEducativo --->
				<cftransaction>
					<cfquery name="NuevoEstudiante" datasource="#Session.DSN#">
						insert into PersonaEducativo (Ecodigo)
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
						<cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="NuevoEstudiante">
					<cfset Ppersona = NuevoEstudiante.identity>
				</cftransaction>
				<!--- Asociar Referencia --->
				<cfset refIns = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'PersonaEducativo', Ppersona)>
				<!--- Agregar Rol de Estudiante a los empleados agregados de esta manera --->
				<cfset rolIns = sec.insUsuarioRol(usuario, Session.EcodigoSDC, 'RH', 'ALUMNO')>
				<!--- ----------------------------------------------------------------- --->

			</cfif>
			<!---Termina en caso de que el tipo sea E 'Externo'--->
		<cfelse>
			<!---- El empleado debe cambiar de empresa a la empresa en donde se está adjudicando el proceso.
				Se debe analizar posteriormente que la plaza es la encargada de determinar el Ecodigo del Empleado
			--->
				<cfset LvarUsuario=0>
 				<cfquery datasource="asp" name="rsUser">
					select Usucodigo,Ecodigo
					from UsuarioReferencia
					where rtrim(ltrim(llave)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.ID#">
					  and STabla = 'DatosEmpleado'
				</cfquery>
				<cfif len(trim(rsUser.Usucodigo))>
					<cfset LvarEmpresaOri=rsUser.Ecodigo>
					<cfset LvarUsuario=rsUser.Usucodigo>
				</cfif>

				<!--------- Se mueven los permisos de la empresa DE USUARIO------------------------------------------------------>
				<cfif LvarUsuario>
					<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

					<!--- Se borra la informacion anterior del empleado --->
					<cfset sec.delUsuarioRef(LvarUsuario, LvarEmpresaOri, 'DatosEmpleado')>
					<cfset sec.delUsuarioRef(LvarUsuario, LvarEmpresaOri, 'PersonaEducativo')>
					<cfinvoke component="asp.Componentes.Roles" method="delRolUser"
					Usucodigo="#LvarUsuario#"
					Ecodigo="-1"
					SScodigo=""
					SRcodigo=""
					>

					<!--- Asociar Referencia --->
					<cfset sec.insUsuarioRef(LvarUsuario, Session.EcodigoSDC, 'DatosEmpleado', rsDatos.ID)>
					<!--- --------------- PARA CAPACITACION Y DESARROLLO ------------------ --->
					<!--- Insertar en PersonaEducativo --->
					<cfquery name="NuevoEstudiante" datasource="#Session.DSN#">
						insert into PersonaEducativo (Ecodigo)
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
						<cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="NuevoEstudiante">
					<cfset Ppersona = NuevoEstudiante.identity>
					<cfset sec.insUsuarioRef(LvarUsuario, Session.EcodigoSDC, 'PersonaEducativo', Ppersona)>


					<!--- Insertar Roles--->
					<cfloop list="AUTO,ALUMNO" index="j">
						<cfset sec.insUsuarioRol(LvarUsuario, Session.EcodigoSDC, 'RH', j)>
					</cfloop>
				</cfif>

				<cfquery datasource="#session.DSN#">
					Update DatosEmpleado
					set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
				</cfquery>

		</cfif>

		<cftransaction>
			<!---Insertado en la tabla RHAcciones---->
			<cfquery name="rsAccionEnc" datasource="#session.DSN#">
				insert into RHAcciones(DEid, RHTid, Ecodigo, Tcodigo, RVid, RHJid, RHCconcurso, Dcodigo, Ocodigo, RHPid,
							RHPcodigo, DLfvigencia,DLffin, DLsalario, RHAporc, RHAporcsal, Usucodigo, RHCPlinea)
				values(
					<cfif rsDatos.tipo EQ 'I'>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
						</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHTid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.Tcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RVid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHCconcurso#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Dcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ocodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHPid#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.RHPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsDatos.DLfvigencia#">,
						<cfif isdefined("rsDatos.DLffin") and len(trim(rsDatos.DLffin)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsDatos.DLffin#">
						<cfelse>
							null
						</cfif>	,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DLsalario#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.RHAporc#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.RHAporcsal#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHCPlinea#" null="#!len(trim(rsDatos.RHCPlinea))#"> )
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsAccionEnc">

			<!--- Insertar el componente salarial --->
			<cfquery name="insComponente" datasource="#Session.DSN#">
				insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionEnc.identity#">,
					   CSid, 1.00,
					   <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DLsalario#">,
					   <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DLsalario#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
				from ComponentesSalariales a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.CSsalariobase=1
			</cfquery>
		</cftransaction>

		<!--- 20160609. LZ Comento Lógica la posibilidad de enviar Correos desde la Adjundicación de Concursos porque ya existe funcionalidad independiente para hacerlo
		        Inicio / Sapiens Reclutamiento /  Selección Envío de Correos a Concursantes
		--->
		<!---
		<!---Envio del correo--->
				<cfquery name="rsPlazas" datasource="#session.dsn#">
					select RHPdescripcion,RHPcodigo from RHPlazas where RHPid=#rsDatos.RHPid#
				</cfquery>

				<cfquery name="correo" datasource="#session.dsn#">
					select DEemail ,DEnombre,DEapellido1,DEapellido2,DEid from DatosEmpleado where DEid=
					<cfif rsDatos.tipo EQ 'I'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
					</cfif>
				</cfquery>

				<cfquery name="rsConc" datasource="#session.dsn#">
					select RHCconcurso,RHCcodigo,RHCdescripcion from RHConcursos where RHCconcurso=#rsDatos.RHCconcurso#
				</cfquery>

					<cfif len(trim(correo.DEemail)) gt 0>
						<cfset email_subject = "Información del Concurso:#rsConc.RHCconcurso#-#rsConc.RHCdescripcion#">
						<cfset email_from = "Administrador del Portal">
						<cfset email_to = '#correo.DEemail#'>
						<cfset email_cc = ''>

						<cfsavecontent variable="email_body">
						<html>
						<head></head>
						<body>
							<!---Cuerpo del correo--->
								<table>
									<cfoutput>
									<tr bgcolor="CCCCCC">
										<td bgcolor="CCCCCC" align="center"><strong>Informaci&oacute;n Concurso</strong></td>
									</tr>
									<tr>
										<td><strong>Estimado(a): </strong>#correo.DEnombre# #correo.DEapellido1# #correo.DEapellido2#</td></br>
									</tr>
									<tr>
										<td>
											Se le informa que usted ha sido seleccionado para la adjudicación de la plaza:<strong>#rsPlazas.RHPcodigo#-#rsPlazas.RHPdescripcion#</strong>
											en el concurso:<strong> #rsConc.RHCconcurso#-#rsConc.RHCdescripcion#.</strong></br>
											Por favor comunicarse con el encardo de Reclutamiento y Selección para la finalización del proceso.</br>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td>Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje. </br></td>
									</td>
									</cfoutput>
								</table>
							<!------>
						</body>
						</html>
						</cfsavecontent>

						<cfquery datasource="minisif">
							insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
							values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
						</cfquery>
					</cfif><!---Fin del envio de correo--->
		--->
		<cfelse>
			<!---<cfset Request.Error.Backs =1>--->
			<cf_throw message="No se han agregado concursantes para la adjudicaci&oacute;n de plazas" errorcode="3045">
		</cfif><!---Fin de len-trim de la fecha de vigencia--->

	<!----Actualizar estado dela adjudicacion---->
	<cfquery datasource="#session.DSN#"	>
		update RHAdjudicacion
		set RHAestado = 10
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
	</cfquery>
	<cfquery name="rs" datasource="#session.dsn#">
		select * from RHAdjudicacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
	</cfquery>

</cfloop>

<!--- 20160609. LZ Comento Lógica la posibilidad de enviar Correos desde la Adjundicación de Concursos porque ya existe funcionalidad independiente para hacerlo
        Inicio / Sapiens Reclutamiento /  Selección Envío de Correos a Concursantes
--->
<!---

	<!---Envio de correo a personas no adjudicadas--->
		<cfquery name="rsAdjCanc" datasource="#session.dsn#">
			select  *
				from RHConcursantes
				where Ecodigo =  #session.Ecodigo#
				 and RHCconcurso =#rsDatos.RHCconcurso#
				 and DEid not in (select DEid
									from RHAdjudicacion a
									where Ecodigo = #session.Ecodigo#
									and RHAlinea in (#form.chk#))
		</cfquery>
		<cfloop query="rsAdjCanc">
			<cfquery name="rsMail" datasource="#session.dsn#">
				select DEemail ,DEnombre,DEapellido1,DEapellido2,DEid from DatosEmpleado where DEid=#rsAdjCanc.DEid#
			</cfquery>
			<cfquery name="rsConc" datasource="#session.dsn#">
				select RHCconcurso,RHCcodigo,RHCdescripcion from RHConcursos where RHCconcurso=#rsDatos.RHCconcurso#
			</cfquery>

			<cfif len(trim(rsMail.DEemail)) gt 0>
				<cfset email_subject = "Información del Concurso:#rsConc.RHCconcurso#-#rsConc.RHCdescripcion#">
				<cfset email_from = "Administrador del Portal">
				<cfset email_to = '#rsMail.DEemail#'>
				<cfset email_cc = ''>

				<cfsavecontent variable="email_body">
				<html>
				<head></head>
				<body>
					<!---Cuerpo del correo--->
						<table>
							<cfoutput>
							<tr bgcolor="CCCCCC">
								<td bgcolor="CCCCCC" align="center"><strong>Informaci&oacute;n Concurso</strong></td>
							</tr>
							<tr>
								<td><strong>Estimado(a): </strong>#rsMail.DEnombre# #rsMail.DEapellido1# #rsMail.DEapellido2#</td></br>
							</tr>
							<tr>
								<td>
									Se le informa que usted NO ha sido seleccionado para la adjudicación del concurso:<strong> #rsConc.RHCconcurso#-#rsConc.RHCdescripcion#.</strong></br>
									Cualquier duda o consulta comunicarse con el encardo de Reclutamiento y Selección.</br>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje. </br></td>
							</td>
							</cfoutput>
						</table>
					<!------>
				</body>
				</html>
				</cfsavecontent>

				<cfquery datasource="minisif">
					insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
				</cfquery>
			</cfif>
		</cfloop>
--->

<cfoutput>
<form name="form1" method="post" action="AdjudicacionPlazas.cfm?Paso=0&RHCconcurso=#form.RHCconcurso#">
	<input name="RHCconcurso" type="hidden" value="<cfif isdefined("Form.RHCconcurso") and len(trim(form.RHCconcurso))>#Form.RHCconcurso#</cfif>">
</form>
</cfoutput>

<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

<!---Obtener el Mcodigo de la empresa--->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif isdefined("form.oferentes") and len(trim(form.oferentes))><!----Se selecciono algun candidato---->
	<cfloop list="#form.oferentes#" index="RHOid">
		<!-----================ INSERTA EL OFERENTE COMO EMPLEADO Y USUARIO DE LA APLICACION (Si no lo es)================----->
		<!----Seleccion de datos del oferente----->
		<cfquery name="rsOferente" datasource="#session.DSN#">
			select NTIcodigo, RHOidentificacion, RHOnombre, RHOapellido1,RHOapellido2,RHOdireccion,RHOtelefono1,RHOtelefono2,
					RHOemail,RHOcivil,RHOfechanac,RHOsexo,RHOobs1,RHOobs2,RHOobs3,RHOdato1,RHOdato2,RHOdato3,RHOdato4,
					RHOdato5,RHOinfo1,RHOinfo2,RHOinfo3,Ppais,BMUsucodigo, DEid
			from DatosOferentes
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">					
		</cfquery>
		<cfset vNewEmpl = rsOferente.DEid>
		<cfif isdefined("rsOferente") and rsOferente.RecordCount and Len(Trim(rsOferente.DEid)) EQ 0><!---El oferente NO es empleado---->
			<cftransaction>
				<!---Insertado de los datos del oferente en la tabla de DatosEmpleado---->
				<cfquery name="insertar" datasource="#session.DSN#" >
					insert into DatosEmpleado(Ecodigo, Bid, NTIcodigo, Tcodigo, DEidentificacion, DEnombre, DEapellido1, DEapellido2,
								CBTcodigo, DEcuenta, CBcc, Mcodigo, DEdireccion, DEtelefono1, DEtelefono2, DEemail, DEcivil, DEfechanac,
								DEsexo, DEobs1, DEobs2, DEobs3, DEdato1, DEdato2, DEdato3, DEdato4, DEdato5, DEinfo1,
								DEinfo2, DEinfo3, Usucodigo, Ulocalizacion, DEusuarioportal, DEtarjeta, DEpassword,Ppais,BMUsucodigo)
					values(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							null,
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsOferente.NTIcodigo#">,
							<cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo))>
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOidentificacion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOapellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOapellido2#">,
							null,null,
							<cfqueryparam cfsqltype="cf_sql_char" value="0">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOdireccion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOtelefono1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOtelefono2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOferente.RHOemail#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOferente.RHOcivil#">,
							<cfif len(trim(rsOferente.RHOfechanac))>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOferente.RHOfechanac#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
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
							null,null,null,null,null,null,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">							
							)
					<cf_dbidentity1 datasource="#session.DSN#">			
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertar">
				<cfset vNewEmpl = insertar.identity>
			</cftransaction>			
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
						<cfif len(trim(rsOferente.RHOfechanac))>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOferente.RHOfechanac#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
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
			<cfset nuevosRoles = createObject("component", "asp.Componentes.Roles").getRolesNuevoUsuario()>

			<cfset usuario = sec.crearUsuario(Session.CEcodigo, id_direccion, datos_personales, rsDatosCuenta.LOCIdioma, LSParseDateTime('01/01/6100'), user, enviar_password)>
			<!--- Asociar Referencia --->
			<cfset ref = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'DatosEmpleado', vNewEmpl)>

			<!--- Insertar Roles--->
			<cfset nuevosRoles = createObject("component", "asp.Componentes.Roles").getRolesNuevoUsuario()>
			<cfloop array="#nuevosRoles#" index="rolNew">
				<cfset rolIns = sec.insUsuarioRol(usuario,Session.EcodigoSDC, rolNew.SScodigo, rolNew.SRcodigo)>
			</cfloop>
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
			<cftransaction>
				<!---Actualiza el DEid generado para el oferente externo--->
				<cfquery datasource="#session.DSN#"	>
					update DatosOferentes
						set DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">	
				</cfquery>
				<!--- Mover los Datos del Oferente hacia el empleado --->
				<cfquery datasource="#Session.DSN#">
					update RHEducacionEmpleado set 
						DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">	
				</cfquery>
				<cfquery datasource="#Session.DSN#">
					update RHExperienciaEmpleado set 
						DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">	
				</cfquery>
				<cfquery datasource="#Session.DSN#">
					update RHCompetenciasEmpleado set 
						DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">	
				</cfquery>
			</cftransaction>	
		</cfif><!---Fin de si existe el oferente--->
		<!---================ CREA/INSERTA LA ACCION DE PERSONAL SIN POSTEAR ================---->
		<cftransaction>		
			<cfquery datasource="#session.dsn#" name="rsRHPcodigo">
				select RHPpuesto
				from RHPlazas
				where RHPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
			</cfquery>
			<cfif rsRHPcodigo.recordcount gt 0 and len(trim(rsRHPcodigo.RHPpuesto)) gt 0>
				<cfset form.RHPcodigo=rsRHPcodigo.RHPpuesto>
			</cfif>
			<cfquery name="rsAccionEnc" datasource="#session.DSN#">
				insert into RHAcciones(DEid, RHTid, Ecodigo, Tcodigo, RVid, RHJid, Dcodigo, Ocodigo, RHPid, 
							RHPcodigo, DLfvigencia,DLffin, DLsalario, RHAporc, RHAporcsal, Usucodigo
							<!---,RHCconcurso---->)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">,					
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">,		
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RVid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">,					
						<cfif isdefined("form.Dcodigo") and len(trim(form.Dcodigo))>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigo#">,	
						<cfelse>
							null,
						</cfif>
						<cfif isdefined("form.Dcodigo") and len(trim(form.Dcodigo))>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,	
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.DLfvigencia)#">,
						<cfif (isdefined("form.DLffin") and len(trim(form.DLffin)) GT 0) and (isdefined("form.usarFechaFin") and trim(form.usarFechaFin) EQ 1)>
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.DLffin)#">
						<cfelse>
							null	
						</cfif>,	
						<cfif isdefined("form.DLsalario") and len(trim(form.DLsalario)) GT 0>
							<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.DLsalario,',', '')#">
						<cfelse>
							0.00
						</cfif>	,
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHAporc#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHAporcsal#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						<!---,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHCconcurso#">--->)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsAccionEnc">
			<!--- Insertar el componente salarial --->
			<cfquery name="insComponente" datasource="#Session.DSN#">
				insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionEnc.identity#">, 
					   CSid, 1.00, 
					   <cfif isdefined("form.DLsalario") and len(trim(form.DLsalario)) GT 0>
							<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.DLsalario,',', '')#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.DLsalario,',', '')#">,
						<cfelse>
							0.00,
							0.00,
						</cfif>	 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
				from ComponentesSalariales a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				<!--- and a.CScodigo = (select min(CScodigo) from ComponentesSalariales b where b.Ecodigo = a.Ecodigo) --->
				and a.CSsalariobase=1 
			</cfquery>
		</cftransaction>
	</cfloop><!---Fin de ciclo sobre form.oferentes (oferentes seleccionados de la lista)----->
</cfif>	<!----Fin de selecciono algun candidato---->
<script type="text/javascript">
	window.close();
</script>
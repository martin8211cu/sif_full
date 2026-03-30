<cfsetting requesttimeout="1800">
<cfset modo="ALTA">
<!--- Carga de la imagen del empleado --->
<!--- Contenido Binario de la Imagen --->
<cfset tmp = "" >
<cfset ts = "null">

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
		ecodigo="#session.Ecodigo#" pvalor="2045" default="0" returnvariable="vUsaIDautomatico"/>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2020" default="0" returnvariable="RentaPais"/>

<!---Empleado Salvador--->
<cfset esSalvador=false>
<cfif RentaPais eq 'RH_CalculoNominaRentaSLV.cfc'>
	<cfset esSalvador=true>
</cfif>


<cfif esSalvador>
	<!---Validacion NIT--->
	<cfquery name="rsGetNIT" datasource="#session.DSN#">
		select DEidentificacion, DEnombre, DEapellido1,DEapellido2
		from  DatosEmpleado
		where Ecodigo = #session.Ecodigo#
		and upper(rtrim(ltrim(NIT))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(form.NIT))#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
	</cfquery>

	<cfif rsGetNIT.RecordCount gt 0 >
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElNITYaExiste"
			Default="El numero de tributario NIT ya esta siendo ocupado por: #rsGetNIT.DEidentificacion# - #rsGetNIT.DEnombre# #rsGetNIT.DEapellido1# #rsGetNIT.DEapellido2#."
			returnvariable="MSG_ElNITYaExiste"/>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElNITYaExiste#." addtoken="no">
		<cfabort>
	</cfif>


	<!---Validacion NUP--->
	<cfquery name="rsGetNUP" datasource="#session.DSN#">
		select DEidentificacion, DEnombre, DEapellido1,DEapellido2
		from  DatosEmpleado
		where Ecodigo = #session.Ecodigo#
		and upper(rtrim(ltrim(NUP))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(form.NUP))#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
	</cfquery>
	<cfif rsGetNUP.RecordCount gt 0 >
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElNUPYaExiste"
			Default="El identificador de penciones NUP ya esta siendo ocupado por: #rsGetNUP.DEidentificacion# - #rsGetNUP.DEnombre# #rsGetNUP.DEapellido1# #rsGetNUP.DEapellido2#."
			returnvariable="MSG_ElNUPYaExiste"/>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElNUPYaExiste#." addtoken="no">
		<cfabort>
	</cfif>

</cfif>

<!---Validacion el numero de tarjeta para que no se repita en caso de que venga definida, permite que el numero no venga del todo pero si viene no debe repetirse--->
<cfif isdefined('form.DEtarjeta') and len(trim(form.DEtarjeta))>
	<cfquery name="rsGetNoTarjeta" datasource="#session.DSN#">
		select DEidentificacion, DEnombre, DEapellido1,DEapellido2
		from  DatosEmpleado
		where Ecodigo = #session.Ecodigo#
		and upper(rtrim(ltrim(DEtarjeta))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(form.DEtarjeta))#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
	</cfquery>
	<cfif rsGetNoTarjeta.RecordCount gt 0 >
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_LatarjetaYaExiste"
			Default="El numero de tarjeta ya esta siendo ocupado por: #rsGetNoTarjeta.DEidentificacion# - #rsGetNoTarjeta.DEnombre# #rsGetNoTarjeta.DEapellido1# #rsGetNoTarjeta.DEapellido2#."
			returnvariable="MSG_LatarjetaYaExiste"/>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_LatarjetaYaExiste#." addtoken="no">
		<cfabort>
	</cfif>
</cfif>


<!---Validacion el numero de seguro social para que no se repita en caso de que venga definido, permite que el numero no venga del todo pero si viene no debe repetirse--->
<cfif isdefined('form.DESeguroSocial') and len(trim(form.DESeguroSocial))>
	<cfquery name="rsGetNoSS" datasource="#session.DSN#">
		select DEidentificacion, DEnombre, DEapellido1,DEapellido2
		from  DatosEmpleado
		where Ecodigo = #session.Ecodigo#
		and upper(rtrim(ltrim(DESeguroSocial))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(form.DESeguroSocial))#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
	</cfquery>
	<cfif rsGetNoSS.RecordCount gt 0 >
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElSSYaExiste"
			Default="El numero de seguro social ya esta siendo usado por: #rsGetNoSS.DEidentificacion# - #rsGetNoSS.DEnombre# #rsGetNoSS.DEapellido1# #rsGetNoSS.DEapellido2#."
			returnvariable="MSG_ElSSYaExiste"/>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElSSYaExiste#." addtoken="no">
		<cfabort>
	</cfif>
</cfif>




<cfif not isdefined("Form.Nuevo")>
	<!---verifica si parametros usa ID automatico para empleados--->
	<cfif isdefined("Form.Alta")>
		<cfif Session.cache_empresarial EQ 0>

			<!--- Verifica si existe el empleado en la empresa actual --->
			<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#">
				select count(1) as Existe
				from DatosEmpleado a
				where a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.NTIcodigo)#">
					and ltrim(rtrim(a.DEidentificacion)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.DEidentificacion)#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfquery>

		<cfelse>

			<!--- Verifica si existe el empleado en alguna de las empresas de la corporacion --->
			<cfquery name="rsEmpresaEmpleado" datasource="asp">
				select distinct c.Ereferencia
				from Empresa b, Empresa c
				where b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and b.CEcodigo = c.CEcodigo
			</cfquery>


			<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#">
				select 1
				from DatosEmpleado
				where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">
					and ltrim(rtrim(DEidentificacion)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.DEidentificacion)#">))
					<cfif rsEmpresaEmpleado.recordCount GT 0>
						and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" separator="," value="#ValueList(rsEmpresaEmpleado.Ereferencia, ',')#">)
					<cfelse>
						and Ecodigo = 0
					</cfif>
			</cfquery>

		</cfif>

       	<cfif isdefined('rsExisteEmpleado') and rsExisteEmpleado.Existe GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElEmpleadoYaExiste"
				Default="El Empleado ya existe verifique la identificacion"
				returnvariable="MSG_ElEmpleadoYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElEmpleadoYaExiste#." addtoken="no">
			<cfabort>
		</cfif>

	</cfif>

	<cfif isdefined("Form.Alta") or isdefined("form.Cambio")>
		<!--- ======================================================================================== --->
		<!--- 							REPLICACION DE USUARIOS INTERCOMPAÑIA 						   --->
		<!---                   ESTO SOLO APLICA SI EL PARAMETRO 580 TIENE VALOR DE 1          		   --->
		<!--- ======================================================================================== --->
		<!--- 0. Recupera el parametro 580 --->
		<cfquery name="rsP580" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 580
		</cfquery>
		<!--- ======================================================================================== --->
		<!--- ======================================================================================== --->
	</cfif>

	<!---Validacion del seguro social para mexico (el seguro social puede venir en blanco pero si no viene en
	blanco el mismo debe contener 11 caracteres, y no sedeb repetirse con ningin numero de seguro para otro empleado) CarolRS--->

	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2025" default="0" returnvariable="vEsMexico"/>

	<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
		<cfif vEsMexico EQ 1>
			<cfquery name="rsRepite" datasource="#Session.DSN#">
				select count(1)as si from DatosEmpleado
				where upper(ltrim(rtrim(DESeguroSocial))) = '#ucase(trim(form.DESeguroSocial))#'
				and Ecodigo = #session.Ecodigo#
				<cfif isdefined('Form.DEid') and len(trim(Form.DEid))>
					and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfif>
			</cfquery>

			<cfif rsRepite.si EQ 1>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_ElEmpleadoYaExiste"
					Default="El numero de seguro social ya existe, verifique."
					returnvariable="MSG_ElEmpleadoYaExiste"/>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElEmpleadoYaExiste#." addtoken="no">
				<cfabort>
			</cfif>
		</cfif>
	</cfif>

	<cfif isdefined("Form.Alta")>
		<cfif isdefined("form.DEsdi") and len(trim(form.DEsdi))>
			<cfset form.DEsdi = replace(form.DEsdi,',','','all')>
		</cfif>


		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
			ecodigo="#session.Ecodigo#" pvalor="16000003" default="N" returnvariable="consecutivoEmpleado"/>

		<cftransaction>
			<cfquery name="ABC_datosEmpl" datasource="#Session.DSN#">
				insert into DatosEmpleado (
					Ecodigo, 		NTIcodigo, 		DEidentificacion,	DEnombre,
					DEapellido1, 	DEapellido2,	Mcodigo, 			CBcc,
					DEdireccion, 	DEcodPostal, 
					DEtelefono1,	DEtelefono2,	DEemail,
					DEcivil, 		DEfechanac,		DEsexo, 			DEobs1,
					DEobs2, 		DEobs3, 		DEobs4, 			DEobs5,
					DEdato1, 		DEdato2, 		DEdato3, 			DEdato4,
					DEdato5, 		DEdato6, 		DEdato7, 			DEinfo1,
					DEinfo2, 		DEinfo3, 		DEinfo4, 			DEinfo5,
					Usucodigo,		Ulocalizacion,	Bid, 				DEtarjeta,
					<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>
						DEpassword,
					</cfif>
					Ppais,			CBTcodigo, 		DEcuenta,			DEporcAnticipo,
					DESeguroSocial, ZEid, DEsdi, RFC, CURP, NIT, NUP,DEtiposalario,DEtipocontratacion, <!---SML. Se agregaron campos a la base de datos para el tipo de salario y el tipo de contratacion--->
                    RHRegimenid,DESindicalizado,DETipoPago,DErespetaSBC
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfif #vUsaIDautomatico# EQ 0>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
						<cfif consecutivoEmpleado eq 'S'>
							(select right(concat('0000',isnull(max(Deidentificacion),0)+1),4) from DatosEmpleado  where Ecodigo=#session.ecodigo#),
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ltrim(rtrim(Replace(DEidentificacion,CHR(9),'')))#">,
						</cfif>
					<cfelse>
						'G',
						<cfif consecutivoEmpleado eq 'S'>
							(select right(concat('0000',isnull(max(Deidentificacion),0)+1),4) from DatosEmpleado  where Ecodigo=#session.ecodigo#),
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">,
						</cfif>
					</cfif>

					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido2#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CBcc#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdireccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEcodPostal#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEemail#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEcivil#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEsexo#">,
					<cfif isdefined('form.DEobs1')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs1#" null="#Len(Trim(Form.DEobs1)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs2#" null="#Len(Trim(Form.DEobs2)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs3')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs3#" null="#Len(Trim(Form.DEobs3)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs4')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs4#" null="#Len(Trim(Form.DEobs4)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs5')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs5#" null="#Len(Trim(Form.DEobs5)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEdato1')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato1#" null="#Len(Trim(Form.DEdato1)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEdato2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato2#" null="#Len(Trim(Form.DEdato2)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEdato3')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato3#" null="#Len(Trim(Form.DEdato3)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEdato4')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato4#" null="#Len(Trim(Form.DEdato4)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEdato5')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato5#" null="#Len(Trim(Form.DEdato5)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEdato6')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato6#" null="#Len(Trim(Form.DEdato6)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEdato7')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato7#" null="#Len(Trim(Form.DEdato7)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo1')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo1#" null="#Len(Trim(Form.DEinfo1)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo2#" null="#Len(Trim(Form.DEinfo2)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo3')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo3#" null="#Len(Trim(Form.DEinfo3)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo4')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo4#" null="#Len(Trim(Form.DEinfo4)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo5')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo5#" null="#Len(Trim(Form.DEinfo5)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
					<cfif isdefined('Form.Bid') and Len(Trim(Form.Bid)) NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('Form.DEtarjeta') and Len(Trim(Form.DEtarjeta))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtarjeta#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.DEpassword)#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
					<cfif isdefined("form.CBTcodigo") and len(trim(form.CBTcodigo))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTcodigo#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.DEcuenta") and len(trim(form.DEcuenta))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.DEcuenta#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEporcAnticipo#">,
					<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(form.DEidentificacion,'-','','ALL')#">,--->
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(form.DESeguroSocial,'-','','ALL')#">,
					<cfif isdefined("form.ZEid") and len(trim(form.ZEid)) and form.ZEid><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#"><cfelse>null</cfif>
					, <cfif isdefined("form.DEsdi") and len(trim(form.DEsdi))><cfqueryparam cfsqltype="cf_sql_money" value="#form.DEsdi#"><cfelse>null</cfif>
                    ,<cfif isdefined("form.RFC") and len(trim(form.RFC))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RFC#"><cfelse>null</cfif>
                    ,<cfif isdefined("form.CURP") and len(trim(form.CURP))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CURP#"><cfelse>null</cfif>
					,<cfif isdefined("form.NIT") and len(trim(form.NIT))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NIT#"><cfelse>null</cfif>
					,<cfif isdefined("form.NUP") and len(trim(form.NUP))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NUP#"><cfelse>null</cfif>
                    <!---SML. Inicio Se agregaron campos a la base de datos para el tipo de salario y el tipo de contratacion--->
                    ,<cfif isdefined("form.DEtiposalario") and len(trim(form.DEtiposalario))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEtiposalario#"><cfelse>0</cfif>
                    ,<cfif isdefined("form.DEtipocontratacion") and len(trim(form.DEtipocontratacion))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEtipocontratacion#"><cfelse>null</cfif>			                    <!---SML. Fin Se agregaron campos a la base de datos para el tipo de salario y el tipo de contratacion--->
                    ,<cfif isdefined("form.RegimenContra") and len(trim(form.RegimenContra))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RegimenContra#">
					<cfelse>
						null
					</cfif>
					,#IsDefined('form.DESindicalizado') ? 1 : 0#
					,#IsDefined('form.cmbTipoPago') ? form.cmbTipoPago : 0#
					,#IsDefined('form.DErespetaSBC') ? 1 : 0#
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_datosEmpl">
			<cfset vNewEmpl = ABC_datosEmpl.identity>

			<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid)) <!---and isdefined("Form.ETNumConces") and Len(Trim(Form.ETNumConces))--->>
				<cfquery name="ABC_empleadosTipo" datasource="#Session.DSN#">
					insert into EmpleadosTipo(DEid, TEid, ETNumConces)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
						0
					)
				</cfquery>
			</cfif>

			<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
				<cfquery name="ABC_empleadosImagen" datasource="#Session.DSN#">
					insert into RHImagenEmpleado(DEid, foto)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">,
						<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">
					)
				</cfquery>
			</cfif>

		</cftransaction>

		<cfset modo="ALTA">

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
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido2#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DEfechanac)#" null="#Len(Trim(Form.DEfechanac)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEsexo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEemail#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="DPinserted">
			<cfset datos_personales = DPinserted.identity>

			<!--- Inserta la direccion --->
			<cfquery datasource="asp" name="Dinserted">
				insert into Direcciones (atencion, direccion1,codPostal, Ppais, BMUsucodigo, BMfechamod)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.DEnombre & ' ' & Form.DEapellido1 & ' ' & Form.DEapellido2)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdireccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEcodPostal#">,
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
		<cfset enviar_password = (isdefined("Form.chkEnviarTemporal") AND Len(Trim(Form.DEemail)) NEQ 0) >
		<!--- Crear Usuario --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset usuario = sec.crearUsuario(Session.CEcodigo, id_direccion, datos_personales, rsDatosCuenta.LOCIdioma, ParseDateTime('01/01/6100','dd/mm/yyyy'), user, enviar_password)>
		<!--- Asociar Referencia --->
		<cfset ref = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'DatosEmpleado', vNewEmpl)>
		<!--- Insertar Rol de Autogestión --->
		<cfset rolIns = sec.insUsuarioRol(usuario, Session.EcodigoSDC, 'RH', 'AUTO')>
		<!--- --------------- PARA CAPACITACION Y DESARROLLO ------------------ --->
		<!--- Insertar en PersonaEducativo --->
		<cftransaction>
			<cfquery name="NuevoEstudiante" datasource="#Session.DSN#">
				insert into PersonaEducativo (Ecodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
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

		<!--- ======================================================================================== --->
		<!--- 							REPLICACION DE USUARIOS INTERCOMPAÑIA 						   --->
		<!--- ESTO SOLO APLICA SI EL PARAMETRO 580 TIENE VALOR DE 1									   --->
		<!--- ======================================================================================== --->
		<cfif rsP580.Pvalor eq 1 >
			<cfinclude template="replicacion-sql.cfm">
		</cfif>
		<!--- ======================================================================================== --->
		<!--- ======================================================================================== --->

	<cfelseif isdefined("Form.Baja")>
		<!---
		  Falta validar que el empleado no se encuentre en la linea de tiempo para evitar realizar el baja
		  La validación puede hacerse aqui o hacerse en la pantalla eliminando el botón de Eliminar en
		  caso de que no se pueda eliminar el empleado por dependencias
		  --->

		<!--- Buscar Usuario según Referencia --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset datos_usuario = sec.getUsuarioByRef(Form.DEid, Session.EcodigoSDC, 'DatosEmpleado')>

		<cfif datos_usuario.recordCount GT 0>

			<!--- Borrar Referencia --->
			<cfset sec.delUsuarioRef(datos_usuario.Usucodigo, Session.EcodigoSDC, 'DatosEmpleado')>

			<cfquery name="chk_delete_Usuario" datasource="asp">
				select 1 as existe
				from dual
				where exists (	select 1
								from UsuarioRol
								where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
							  )	or exists (	select 1
												from UsuarioProceso
												where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
							  			  	) or exists (	select 1
				   											from UsuarioReferencia
															where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
							 							) or exists (	select 1
				   														from UsuarioSustituto
																		where Usucodigo1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
																			or Usucodigo2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
						   	  										)
			</cfquery>

			<cfif chk_delete_Usuario.recordCount EQ 0>

				<cfquery name="_datosUsuario" datasource="asp">
					select id_direccion, datos_personales
					from Usuario
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
						and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				</cfquery>
				<cfset id_direccion = _datosUsuario.id_direccion>
				<cfset datos_personales = _datosUsuario.datos_personales>

				<cfquery name="_deletePasswords" datasource="asp">
					delete from UsuarioPassword
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				</cfquery>

				<cfquery name="_delete_Usuario" datasource="asp">
					delete from Usuario
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
						and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				</cfquery>

				<cfquery name="_deleteDirecciones" datasource="asp">
					delete from Direcciones
					where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_direccion#">
				</cfquery>

				<cfquery name="_deleteDatosPersonales" datasource="asp">
					delete from DatosPersonales
					where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_personales#">
				</cfquery>

			</cfif>
		</cfif>

		<cfquery name="_deleteEmpleadosTipo" datasource="#Session.DSN#">
			delete from EmpleadosTipo
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>

		<cfquery name="_deleteImagen" datasource="#Session.DSN#">
			delete from RHImagenEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="_deleteCertificacionesEmpleado" datasource="#Session.DSN#">
			delete from CertificacionesEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="_deleteRHExperienciaEmpleado" datasource="#Session.DSN#">
			delete from RHExperienciaEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="_deleteRHEducacionEmpleado" datasource="#Session.DSN#">
			delete from RHEducacionEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="_deleteFEmpleado" datasource="#Session.DSN#">
			delete from FEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="_deleteCargasEmpleado" datasource="#Session.DSN#">
			delete from CargasEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="_deleteRHHistoricoSDI" datasource="#Session.DSN#">
			delete from RHHistoricoSDI
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="_deleteEVacaciones" datasource="#Session.DSN#">
			delete from EVacacionesEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>

		<cfquery name="_deleteRHDAcciones" datasource="#Session.DSN#">
			delete from RHDAcciones
			where RHAlinea = (select RHAlinea from RHAcciones
								where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">)
		</cfquery>
		<cfquery name="_deleteRHAcciones" datasource="#Session.DSN#">
			delete from RHAcciones
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="update_DatosOferentes" datasource="#Session.DSN#">
			update DatosOferentes
				set RHAprobado = null,DEid= null
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfquery name="_deleteDatosEmpleado" datasource="#Session.DSN#">
			delete from DatosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>

		<cfif isdefined("form.DEsdi") and len(trim(form.DEsdi))>
			<cfset form.DEsdi = replace(form.DEsdi,',','','all')>
		</cfif>

		<cfquery name="rsExiste" datasource="#Session.DSN#">
			select count(DEidentificacion) as Existe
			from DatosEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and NTIcodigo =  ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.NTIcodigo)#">))
				and DEidentificacion = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.DEidentificacion)#">))
				and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>


       	<cfif isdefined('rsExiste') and rsExiste.Existe GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElEmpleadoYaExiste"
				Default="El Empleado ya existe verifique la Identificacion"
				returnvariable="MSG_ElEmpleadoYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElEmpleadoYaExiste#." addtoken="no">
			<cfabort>
		</cfif>

		<cfquery name="ABC_datosEmpl" datasource="#Session.DSN#">
			update DatosEmpleado
			set	<cfif #vUsaIDautomatico# EQ 0>
						NTIcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NTIcodigo#">,
						DEidentificacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ltrim(rtrim(Replace(DEidentificacion,CHR(9),'')))#">,
					</cfif>
				DEnombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnombre#">,
				DEapellido1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido1#">,
				DEapellido2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido2#">,
				CBcc 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBcc#">,
				Mcodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
				DEdireccion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdireccion#">,
				DEcodPostal 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEcodPostal#">,
				DEtelefono1			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono1#">,
				DEtelefono2			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono2#">,
				DEemail				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEemail#">,
				DEcivil 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEcivil#">,
				DEfechanac 			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
				DEsexo 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEsexo#">
				<cfif isdefined('Form.DEtarjeta') and Len(Trim(Form.DEtarjeta))>
					,DEtarjeta	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtarjeta#">
				<cfelse>
					,DEtarjeta	= null
				</cfif>
				<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>
					,DEpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.DEpassword)#">
				</cfif>
				<cfif isdefined('form.DEobs1')>
					,DEobs1 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs1#" null="#Len(Trim(Form.DEobs1)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEobs2')>
					,DEobs2 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs2#" null="#Len(Trim(Form.DEobs2)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEobs3')>
					,DEobs3 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs3#" null="#Len(Trim(Form.DEobs3)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEobs4')>
					,DEobs4 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs4#" null="#Len(Trim(Form.DEobs4)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEobs5')>
					,DEobs5 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs5#" null="#Len(Trim(Form.DEobs5)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato1')>
					,DEdato1 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato1#" null="#Len(Trim(Form.DEdato1)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato2')>
					,DEdato2 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato2#" null="#Len(Trim(Form.DEdato2)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato3')>
					,DEdato3 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato3#" null="#Len(Trim(Form.DEdato3)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato4')>
					,DEdato4 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato4#" null="#Len(Trim(Form.DEdato4)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato5')>
					,DEdato5 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato5#" null="#Len(Trim(Form.DEdato5)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato6')>
					,DEdato6 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato6#" null="#Len(Trim(Form.DEdato6)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato7')>
					,DEdato7 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato7#" null="#Len(Trim(Form.DEdato7)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo1')>
					,DEinfo1 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo1#" null="#Len(Trim(Form.DEinfo1)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo2')>
					,DEinfo2 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo2#" null="#Len(Trim(Form.DEinfo2)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo3')>
					,DEinfo3 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo3#" null="#Len(Trim(Form.DEinfo3)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo4')>
					,DEinfo4 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo4#" null="#Len(Trim(Form.DEinfo4)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo5')>
					,DEinfo5 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo5#" null="#Len(Trim(Form.DEinfo5)) EQ 0#">
				</cfif>
				<cfif isdefined('Form.Bid') and Len(Trim(Form.Bid)) NEQ 0>
					,Bid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
				<cfelse>
					,Bid 	= null
				</cfif>
				, Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">
				, CBTcodigo = <cfif isdefined ("form.CBTcodigo") and len(trim(form.CBTcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTcodigo#"><cfelse>null</cfif>
				, DEcuenta = <cfif isdefined("form.DEcuenta") and len(trim(form.DEcuenta))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEcuenta#"><cfelse>null</cfif>
				, DEporcAnticipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEporcAnticipo#">
				, ZEid = <cfif isdefined("form.ZEid") and len(trim(form.ZEid)) and form.ZEid><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#"><cfelse>null</cfif>
				, DEsdi = <cfif isdefined("form.DEsdi") and len(trim(form.DEsdi))><cfqueryparam cfsqltype="cf_sql_money" value="#form.DEsdi#"><cfelse>null</cfif>

                , RFC   = <cfif isdefined("form.RFC") and len(trim(form.RFC))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RFC#"><cfelse>null</cfif>
                , CURP  = <cfif isdefined("form.CURP") and len(trim(form.CURP))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CURP#"><cfelse>null</cfif>
				, NIT  = <cfif isdefined("form.NIT") and len(trim(form.NIT))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NIT#"><cfelse>null</cfif>
				, NUP  = <cfif isdefined("form.NUP") and len(trim(form.NUP))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NUP#"><cfelse>null</cfif>
                <!---SML. Inicio Se agregaron campos a la base de datos para el tipo de salario y el tipo de contratacion--->
                , DEtiposalario = <cfif isdefined("form.DEtiposalario") and len(trim(form.DEtiposalario))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEtiposalario#"><cfelse>0</cfif>
                , DEtipocontratacion = <cfif isdefined("form.DEtipocontratacion") and len(trim(form.DEtipocontratacion))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEtipocontratacion#"><cfelse>null</cfif>
				<!---SML. Fin Se agregaron campos a la base de datos para el tipo de salario y el tipo de contratacion--->
				, RHRegimenid = <cfif isdefined("form.RegimenContra") and len(trim(form.RegimenContra))> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RegimenContra#"><cfelse>null</cfif>
				, DESindicalizado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#(IsDefined('form.DESindicalizado') ? 1 : 0)#">
				, DErespetaSBC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#(IsDefined('form.DErespetaSBC') ? 1 : 0)#">
				, DETipoPago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IsDefined('form.cmbTipoPago') ? form.cmbTipoPago : 0#">
				<cfif len(Trim(Form.vigencia1)) Gt 0>
					, Vigencia1 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Form.vigencia1,'dd/mm/yyyy')#">
				<cfelse>
					,Vigencia1 = null
				</cfif>
				<cfif len(Trim(Form.vigencia2)) Gt 0>
					, Vigencia2 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Form.vigencia2,'dd/mm/yyyy')#">
				<cfelse>
					,Vigencia2 = null
				</cfif>
				<cfif len(Trim(Form.vigencia3)) Gt 0>
					, Vigencia3 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Form.vigencia3,'dd/mm/yyyy')#">
				<cfelse>
					,Vigencia3 = null
				</cfif>
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>


		<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid)) <!---and isdefined("Form.ETNumConces") and Len(Trim(Form.ETNumConces))--->>
			<cfquery name="Existe_datosEmpl" datasource="#Session.DSN#">
				select *
				from EmpleadosTipo
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>

			<cfif isdefined("Existe_datosEmpl") and Existe_datosEmpl.RecordCount NEQ 0>
				<cfquery name="ABC_UpddatosEmpl" datasource="#Session.DSN#">
					update EmpleadosTipo
					set TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
						ETNumConces = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>

			<cfelse>
				<cfquery name="ABC_UpddatosEmpl" datasource="#Session.DSN#">
					insert into EmpleadosTipo(DEid, TEid, ETNumConces)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
						0)
				</cfquery>

			</cfif>
		</cfif>

		<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
			<cfquery name="Existe_RHImagenEmpleado" datasource="#Session.DSN#">
				select *
				from RHImagenEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>

			<cfif isdefined("Existe_RHImagenEmpleado") and Existe_RHImagenEmpleado.RecordCount NEQ 0>
				<cfquery name="ABC_RHImagenEmpleado" datasource="#Session.DSN#">
					update RHImagenEmpleado
					set foto = <cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>

			<cfelse>
				<cfquery name="ABC_RHImagenEmpleado" datasource="#Session.DSN#">
					insert into RHImagenEmpleado(DEid, foto)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
						<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">)
				</cfquery>

			</cfif>
		</cfif>

		<!--- ======================================================================================== --->
		<!--- 							REPLICACION DE USUARIOS INTERCOMPAÑIA 						   --->
		<!---                   ESTO SOLO APLICA SI EL PARAMETRO 580 TIENE VALOR DE 1				   --->
		<!--- ======================================================================================== --->
		<cfif rsP580.Pvalor eq 1 >
			<cfinclude template="replicacion-sql.cfm">
		</cfif>
		<!--- ======================================================================================== --->
		<!--- ======================================================================================== --->

		<cfset modo="CAMBIO">

		<!--- Buscar Usuario según Referencia --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset datos_usuario = sec.getUsuarioByRef(Form.DEid, Session.EcodigoSDC, 'DatosEmpleado')>

		<cfif datos_usuario.recordCount GT 0>
			<!--- Modificar Datos del Usuario en el Framework --->
			<!--- Modificar los datos personales --->

			<cfquery datasource="asp" name="DPupdated">
				update DatosPersonales
				set Pid         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">,
					Pnombre     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnombre#">,
					Papellido1  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido1#">,
					Papellido2  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido2#">,
					Pnacimiento = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Form.DEfechanac,'dd/mm/yyyy')#" null="#Len(Trim(Form.DEfechanac)) EQ 0#">,
					Psexo       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEsexo#">,
					Pcasa       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono1#">,
					Pcelular    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono2#">,
					Pemail1     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEemail#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.datos_personales#">
			</cfquery>

			<!--- Modificar la direccion --->
			<cfquery datasource="asp" name="updated">
				update Direcciones
				set atencion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.DEnombre & ' ' & Form.DEapellido1 & ' ' & Form.DEapellido2)#">,
					direccion1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdireccion#">,
					codPostal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEcodPostal#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfechamod = getdate()
				where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.id_direccion#">
			</cfquery>

			<!--- Enviar Usuario Temporal --->
			<cfif isdefined("Form.chkEnviarTemporal") AND Len(Trim(Form.DEemail)) NEQ 0>
				<cfset cambioPass = sec.generarPassword(datos_usuario.Usucodigo, true)>
			</cfif>
		</cfif>

	</cfif>
	<cftransaction action="commit">

</cfif>


<cfif Session.Params.ModoDespliegue EQ 1>
	<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">
<cfelseif Session.Params.ModoDespliegue EQ 0>
	<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
</cfif>

<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.Baja")>
		<input name="sel"    type="hidden" value="0">
	<cfelse>
		<input name="sel"    type="hidden" value="1">
	</cfif>
	<cfif modo EQ 'CAMBIO'>
		<input name="DEid" type="hidden" value="<cfoutput><cfif isdefined("Form.Cambio") and isdefined("form.DEid")>#form.DEid#<cfelseif isdefined('vNewEmpl') and Len(Trim(vNewEmpl)) NEQ 0>#vNewEmpl#</cfif></cfoutput>">
	</cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

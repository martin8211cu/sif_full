<!---
	Interfaz 202
	DatosEmpleado
--->
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar de la BD de Interfaces. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz202" datasource="sifinterfaces">
		SELECT 	ID, EcodigoSDC, Imodo, IdentificacionEmpleado, TipoIdentificacion, EstadoCivil, Nombre, Apellido1, Apellido2, Sexo, 
				FechaNacimiento, CuentaBancaria, Banco, CarnetMarcas, Pais, DatoVariable1, DatoVariable2, DatoVariable3, DatoVariable4, 
				DatoVariable5, DatoVariable6, DatoVariable7, DatoInformativo1, DatoInformativo2, DatoInformativo3, DatoInformativo4, 
				DatoInformativo5, DatoObservacion1, DatoObservacion2, DatoObservacion3, DatoObservacion4, DatoObservacion5, BMUsucodigo, 
				ts_rversion, Direccion
		FROM 	IE202
		WHERE 	ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	
	<!--- Valida que vengan datos --->
	<cfif readInterfaz202.recordcount eq 0>
		<cfthrow message="Error en Interfaz 202. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Inserta los datos del empleado. --->
	
	<!--- empresa --->
	<cfquery name="query" datasource="#Session.DSN#">
		select c.Ecodigo
		from Empresas c
		where c.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz202.EcodigoSDC#"> 
	</cfquery>
	<cfif query.RecordCount EQ 0>			
		<cfthrow message="La Empresa #readInterfaz202.EcodigoSDC# no existe.">
	<cfelse>
		<cfset empresa = query.Ecodigo >
	</cfif>
	<!--- empleado --->
	<cfif readInterfaz202.Imodo eq 'A'>
		<cfquery name="rsValidaExistencia" datasource="#session.DSN#">
			select DEid
			from DatosEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
			  and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.IdentificacionEmpleado#"> 
		</cfquery>
		<cfif rsValidaExistencia.RecordCount GT 0>
			<cfthrow message="El Empleado #readInterfaz202.IdentificacionEmpleado# ya existe.">
		</cfif>
	</cfif>
	<cfif readInterfaz202.Imodo eq 'C'>
		<cfquery name="rsValidaExistencia" datasource="#session.DSN#">
			select DEid
			from DatosEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
			  and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.IdentificacionEmpleado#"> 
		</cfquery>
		<cfif rsValidaExistencia.RecordCount EQ 0>
			<cfthrow message="Se esta intentando modificar información de un empleado que no existe.El Empleado #readInterfaz202.IdentificacionEmpleado# no existe.">
		</cfif>
	</cfif>
	<!--- tipo de identificacion --->
	<cfquery name="query" datasource="#Session.DSN#">
		select NTIcodigo
		from NTipoIdentificacion
		where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz202.TipoIdentificacion#"> 
	</cfquery>
	<cfif query.RecordCount EQ 0>			
		<cfthrow message="El tipo de Identificaci&oacute;n #readInterfaz202.TipoIdentificacion# no existe.">
	<cfelse>
		<cfset tipo_id = query.NTIcodigo >	
	</cfif>

	<!--- estado civil --->	
	<cfif not listfind('0,1,2,3,4,5', readInterfaz202.EstadoCivil) >
		<cfthrow message="El estado civil #readInterfaz202.EstadoCivil# no existe.">
	<cfelse>
		<cfset estado_civil = readInterfaz202.EstadoCivil >
	</cfif>
	
	<!--- sexo --->	
	<cfif not listfind('M,F', readInterfaz202.Sexo) >
		<cfthrow message="El sexo #readInterfaz202.Sexo# no existe.">
	<cfelse>
		<cfset sexo = readInterfaz202.Sexo >
	</cfif>

	<cfif LEN(TRIM(readInterfaz202.Banco))>
		<!--- BANCO --->
		<cfquery name="query" datasource="#session.DSN#">
			select Bid
			from Bancos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
			  and Iaba = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz202.Banco#"> 
		</cfquery>
		<cfif query.RecordCount EQ 0>			
			<cfthrow message="El c&oacute;digo de banco #readInterfaz202.Banco# no existe.">
		<cfelse>
			<cfset Banco = query.Bid >	
		</cfif>	
	</cfif>
	<!--- MONEDA --->
	<cfquery name="query" datasource="#Session.DSN#">
		select Mcodigo 
		from Empresas 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
	</cfquery>

	<cfif query.recordcount eq 0 >
		<cfthrow message="No ha sido definida la moneda para la empresa. [Ecodigo: #empresa# (BD equivalente a minisif) ].">
	<cfelse>
		<cfset moneda = query.Mcodigo >
	</cfif>

	<cfif readInterfaz202.Imodo eq 'A'>
		<cfquery datasource="#session.DSN#" result="salida">
			insert into DatosEmpleado(	Ecodigo, 			<!--- * --->
										NTIcodigo, 			<!--- * --->
										DEidentificacion, 	<!--- * --->
										DEnombre, 			<!--- * --->
										DEcuenta,
										CBcc, 				<!--- * --->
										Bid,
										Mcodigo, 			<!--- * --->
										DEcivil, 			<!--- * --->
										DEfechanac, 		<!--- * --->
										DEsexo, 			<!--- * --->
										DEapellido1,
										DEapellido2,
										DEobs1,
										DEobs2,
										DEobs3,
										DEobs4,
										DEobs5,
										DEdato1,
										DEdato2,
										DEdato3,
										DEdato4,
										DEdato5,
										DEdato6,
										DEdato7,
										DEinfo1,
										DEinfo2,
										DEinfo3,
										DEinfo4,
										DEinfo5,
										Usucodigo,
										DEtarjeta,
										Ppais,
										DEdireccion,
										BMUsucodigo,
										IDInterfaz )
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.IdentificacionEmpleado#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Nombre#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.CuentaBancaria#">,
				<cfif len(trim(readInterfaz202.CuentaBancaria))><cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.CuentaBancaria#"><cfelse>'XXX'</cfif>,
				<cfif len(trim(readInterfaz202.Banco))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Banco#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#moneda#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#estado_civil#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#readInterfaz202.FechaNacimiento#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#sexo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Apellido1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Apellido2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion1#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion3#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion4#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion5#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable1#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable3#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable4#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable5#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable6#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable7#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo1#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo3#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo4#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo5#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.CarnetMarcas#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Pais#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Direccion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz202.ID#"> )
		</cfquery> 
	<cfelseif readInterfaz202.Imodo eq 'C'>
		<cfset DEid = 0 >
		<cfquery name="rs_id" datasource="#session.DSN#">
			select DEid
			from DatosEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
			and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.IdentificacionEmpleado#">
		</cfquery>
		<cfif len(trim(rs_id.DEid)) >
			<cfset DEid = rs_id.DEid >
		</cfif>

		<cfquery datasource="#session.DSN#" result="salida">
			update DatosEmpleado
			set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">,
				NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo_id#">,
				DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.IdentificacionEmpleado#">,
				DEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Nombre#">,
				DEcuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.CuentaBancaria#">,
				CBcc = <cfif len(trim(readInterfaz202.CuentaBancaria))><cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.CuentaBancaria#"><cfelse>'XXX'</cfif>,
				Bid =  <cfif len(trim(readInterfaz202.Banco))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Banco#"><cfelse>null</cfif>,
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#moneda#">,
				DEcivil = <cfqueryparam cfsqltype="cf_sql_integer" value="#estado_civil#">,
				DEfechanac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#readInterfaz202.FechaNacimiento#">, 
				DEsexo = <cfqueryparam cfsqltype="cf_sql_char" value="#sexo#">,
				DEapellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Apellido1#">,
				DEapellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Apellido2#">,
				DEobs1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion1#">, 
				DEobs2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion2#">,
				DEobs3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion3#">,
				DEobs4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion4#">,
				DEobs5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoObservacion5#">,
				DEdato1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable1#">, 
				DEdato2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable2#">,
				DEdato3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable3#">,
				DEdato4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable4#">, 
				DEdato5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable5#">,
				DEdato6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable6#">,
				DEdato7 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoVariable7#">,
				DEinfo1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo1#">, 
				DEinfo2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo2#">,
				DEinfo3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo3#">, 
				DEinfo4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo4#">, 
				DEinfo5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.DatoInformativo5#">,
				Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				DEtarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.CarnetMarcas#">,
				Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Pais#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				IDInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz202.ID#">,
				DEdireccion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.Direccion#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
		</cfquery> 
	
	<cfelseif readInterfaz202.Imodo eq 'B'>	
		<cfset puede_borrar = true >

		<cfset DEid = 0 >
		<cfquery name="rs_id" datasource="#session.DSN#">
			select DEid
			from DatosEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
			and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz202.IdentificacionEmpleado#">
		</cfquery>
		<cfif len(trim(rs_id.DEid)) >
			<cfset DEid = rs_id.DEid >
		</cfif>

		<cftransaction>
		<cftry>
			<cfquery datasource="#session.DSN#">
				delete DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			</cfquery>
		<cfcatch type="database">
			<cfset puede_borrar = false >
		</cfcatch>
		</cftry>
		</cftransaction>
	</cfif>

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
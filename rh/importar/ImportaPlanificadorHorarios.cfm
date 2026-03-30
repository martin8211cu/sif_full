<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoHayDatosQueProcesar"
	Default="No hay datos que procesar luego de Borrar las Marcas que no son de Tipo 1 y 3"
	returnvariable="MSG_NoHayDatosQueProcesar"/>

<!---======== Tabla temporal de errores  ========--->
	<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
         <cf_dbtempcol name="LError"   type="varchar(250)" mandatory="no">
    </cf_dbtemp> 

<cfquery name="rsDatos" datasource="#session.DSN#">
	select id,Indentificacion,FechaPlanificada,CodigoJornada,HoraEntrada,HoraSalida,DiaLibre
	from #table_name#
	order by Indentificacion,FechaPlanificada
</cfquery>

<cfif rsDatos.recordcount eq 0>
	<cfset fnInsertarError(MSG_NoHayDatosQueProcesar)>
</cfif>
<cftransaction>
	<cfloop query="rsDatos">
		<!--- Inicia:  Validacion de Identificación --->
		<cfquery name="rsDEid" datasource="#session.DSN#">
			select DEid from DatosEmpleado where Ecodigo = #session.Ecodigo# and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Indentificacion#">
		</cfquery>
		<cfset DEid = rsDEid.DEid>
		<cfif len(trim(rsDEid.DEid)) eq 0>
			<cfset fnInsertarError('La Identificación "#rsDatos.Indentificacion#" no existe en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
			<cfset DEid = -1>
		</cfif>
		<!--- Finaliza:  Validacion de Identificación --->
		
		<!--- Inicia:  Validacion de Fecha Planificada --->
		<cfif len(trim(rsDatos.FechaPlanificada)) neq 8>
			<cfset fnInsertarError('La Fecha Planificada "#rsDatos.FechaPlanificada#" no posee la loguitud correcta de 8 dígitos en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
		</cfif>
		<cfset vn_Anno = Mid(rsDatos.FechaPlanificada,1,4)>
		<cfset vn_Mes  = Mid(rsDatos.FechaPlanificada,5,2)>
		<cfset vn_Dia  = Mid(rsDatos.FechaPlanificada,7,2)>
		<cfset validarDepFecha  = true>
		<!-----======== Validar el mes,dia y año ========--->	
		<cfif not Isnumeric(vn_Dia)>
			<cfset fnInsertarError('La posición del dia (#vn_Dia#) en la fecha planificada (#rsDatos.FechaPlanificada#) no es numérico en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
		</cfif>
		<cfif not Isnumeric(vn_Mes)>
			<cfset fnInsertarError('La posición del mes (#vn_Mes#) en la fecha planificada (#rsDatos.FechaPlanificada#) no es numérico en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
			<cfset validarDepFecha  = false>
		</cfif>
		<cfif not Isnumeric(vn_Anno)>
			<cfset fnInsertarError('La posición del año (#vn_Anno#) en la fecha planificada (#rsDatos.FechaPlanificada#) no es numérico en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
			<cfset validarDepFecha  = false>
		</cfif>
		<cfif vn_Mes gt 12 or vn_Mes lte 0>	
			<cfset fnInsertarError('El mes (#vn_Mes#) en la fecha planificada (#rsDatos.FechaPlanificada#) no es válido en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>	
			<cfset validarDepFecha  = false>		
		</cfif> 
		<cfif vn_Dia lte 0 or vn_Dia GT DaysInMonth(CreateDate(vn_Anno, vn_Mes, 1))>>	
			<cfset fnInsertarError('El dia (#vn_Dia#) en la fecha planificada (#rsDatos.FechaPlanificada#) no es válido en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>	
			<cfset validarDepFecha  = false>		
		</cfif>
		<!--- Finaliza:  Validacion de Fecha Planificada --->
		
		<!--- Inicia:  Validacion de Activo --->
		<cfif validarDepFecha>
			<cfquery name="rsValidaActivo" datasource="#session.DSN#">
				select de.DEid 
				from DatosEmpleado de
					inner join LineaTiempo lt
						on lt.DEid = de.DEid and #CreateDate(vn_Anno, vn_Mes, vn_Dia)# between lt.LTdesde and lt.LThasta
				where de.Ecodigo = #session.Ecodigo# and de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Indentificacion#">
			</cfquery>
			<cfif len(trim(rsValidaActivo.DEid)) eq 0>
				<cfset fnInsertarError('El empleado no esta activo para la fecha indicada en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
			</cfif>
		</cfif>
		<!--- Finaliza:  Validacion de Activo --->
	
		<!--- Inicia:  Validacion de Codigo de Jornada --->
		<cfif len(trim(rsDatos.CodigoJornada)) gt 0>
			<cfquery name="rsJornada" datasource="#session.DSN#">
				select RHJid 
				from RHJornadas 
				where RHJcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CodigoJornada#">
					and Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfif len(trim(rsJornada.RHJid)) eq 0>
				<cfset fnInsertarError('El código "#rsDatos.CodigoJornada#" de la jornada no existe en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
			<cfelse>
				<cfquery name="rsJornada" datasource="#session.DSN#">
					select RHJid 
					from RHJornadas 
					where RHJcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CodigoJornada#">
						and Ecodigo = #session.Ecodigo#
						and RHJmarcar = 1
				</cfquery>
				<cfif len(trim(rsJornada.RHJid)) eq 0>
					<cfset fnInsertarError('La jornada "#rsDatos.CodigoJornada#" no es una jornada de registro de marcas en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
				</cfif>
			</cfif>
		<cfelse>
			<cfif validarDepFecha>
				<cfquery name="rsJornada" datasource="#session.DSN#">
					select RHJid 
					from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						and #CreateDate(vn_Anno, vn_Mes, vn_Dia)# between LTdesde and LThasta
				</cfquery>
				<cfif len(trim(rsJornada.RHJid)) eq 0>
					<cfset fnInsertarError('No existe una jornada definida ne la linea del tiempo para la identificación "#rsDatos.Indentificacion#" y la fecha "#rsDatos.FechaPlanificada#" en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
				<cfelse>
					<cfquery name="rsJornada" datasource="#session.DSN#">
						select RHJid,RHJcodigo ,RHJmarcar
						from RHJornadas 
						where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJid#">
					</cfquery>
					<cfif rsJornada.RHJmarcar neq '1'>
						<cfset fnInsertarError('La jornada "#rsJornada.RHJcodigo#" registrada para el empleado en la fecha indicada no es una jornada de registro de marcas en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<!--- Finaliza:  Validacion de Codigo de Jornada --->
		
		<cfif validarDepFecha>
			<!--- Inicia:  Validacion de Hora Entrada --->
			<cfset SHoraI = fnValidarHora(rsDatos.HoraEntrada)>
			<!--- Finaliza:  Validacion de Hora Entrada --->
			
			<!--- Inicia:  Validacion de Hora Salida --->
			<cfset SHoraF = fnValidarHora(rsDatos.HoraSalida)>
			<!--- Finaliza:  Validacion de Hora Salida --->
			
			<!--- Inicia: Creacion de Fechas Inicio-Fin --->
			<cfset tMinI = StructFind(SHoraI, 'hora') * 60 + StructFind(SHoraI, 'minutos')>
			<cfset tMinF = StructFind(SHoraF, 'hora') * 60 + StructFind(SHoraF, 'minutos')>
			<cfset FechaI = CreateDateTime(vn_Anno, vn_Mes, vn_Dia, StructFind(SHoraI, 'hora'), StructFind(SHoraI, 'minutos'), 0)>
			<cfif tMinI lt tMinF>
				<cfset FechaF = CreateDateTime(vn_Anno, vn_Mes, vn_Dia, StructFind(SHoraF, 'hora'), StructFind(SHoraF, 'minutos'), 0)>
			<cfelse>
				<cfset FechaTmp = DateAdd("d", 1, CreateDate(vn_Anno, vn_Mes, vn_Dia))>
				<cfset FechaF = CreateDateTime(DatePart("yyyy", FechaTmp), DatePart("m", FechaTmp), DatePart("d", FechaTmp) , StructFind(SHoraF, 'hora'), StructFind(SHoraF, 'minutos'), 0)>
			</cfif>
			<!--- Finaliza: Creacion de Fechas Inicio-Fin --->
			
			<!--- Inicia:  Validacion de Hora --->
			<cfif tMinI eq tMinF>
				<cfset fnInsertarError('La Hora de Salida (#rsDatos.HoraSalida#) y Hora de entrada (#rsDatos.HoraEntrada#) no pueden ser las mismas en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
			</cfif>
			<!--- Finaliza:  Validacion Hora --->
		</cfif>
		<!--- Inicia:  Validacion de Dia Libre --->
		<cfif not ListFind('S,N',rsDatos.DiaLibre)>
			<cfset fnInsertarError('El valor de día libre (#rsDatos.DiaLibre#) no es valido, valores permitidos, S ó N en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
		</cfif>
		<!--- Finaliza:  Validacion de Dia Libre --->
		
		
		<!--- Inicia:  Validacion de Duplicacion --->
		<cfquery name="rsDuplicacion" datasource="#session.DSN#">
			select count(1) cantidad
			from #table_name#
			where Indentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Indentificacion#">
				and FechaPlanificada = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.FechaPlanificada#">
				and id <> #rsDatos.id#
		</cfquery>
		<cfif rsDuplicacion.cantidad gt 0>
			<cfset fnInsertarError('EL horario planificado se repite en el archivo importado en el registro Identificación = "#rsDatos.Indentificacion#" y Fecha Planifica = "#rsDatos.FechaPlanificada#."')>
		</cfif>
		<!--- Finaliza:  Validacion de Duplicacion --->

		<!--- Inserta el registro--->
		<cfif DEid neq -1 and Len(Trim(rsJornada.RHJid)) gt 0 and validarDepFecha and ListFind('S,N',rsDatos.DiaLibre)><!--- Si el valor es -1 no se inserta porque no existe y daria error de integridad--->
			<cf_dbfunction name="to_sdateDMY"	args="RHPJfinicio" returnvariable="FechaHilera">
			<cfquery name="rsExiste" datasource="#session.DSN#">
				select count(1) existe 
				from RHPlanificador
				where DEid = #DEid#
					and <cf_dbfunction name="to_date" args="#preservesinglequotes(FechaHilera)#"> = <cfqueryparam cfsqltype="cf_sql_date" value="#FechaI#">
			</cfquery>
			<cfif rsExiste.existe gt 0>
				<cfset fnInsertarError('El horario Fecha Planifica = "#rsDatos.FechaPlanificada#" ya existe para la Identificación = "#rsDatos.Indentificacion#" en el registro de planificaciones.')>
			<cfelse>
				<cfquery datasource="#session.DSN#">
					insert into RHPlanificador(DEid, RHJid, RHPJfinicio, RHPJffinal, RHPJusuario, RHPJfregistro, BMUsucodigo, RHPlibre)
					values(
						#DEid#, #rsJornada.RHJid#,
						<cfif tMinI lt tMinF>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaI#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaF#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaI#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaF#">,
						</cfif>
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						#session.usucodigo#,
						<cfif rsDatos.DiaLibre eq 'S'>
							1
						<cfelse>
							0
						</cfif>
					)
				</cfquery>
			</cfif>
		</cfif>
		
	</cfloop>
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	<cfif rsErrores.cantidad gt 0>		
		<cfquery name="ERR" datasource="#session.DSN#">
			select LError as MSG
			from #errores#
		</cfquery>
		<cftransaction action="rollback">
	</cfif>
</cftransaction>

<cffunction name="fnInsertarError" access="private">
	<cfargument name="MSG" type="string" required="yes">
	
	<cfquery  datasource="#session.dsn#">
		Insert into #errores# (LError)
		values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MSG#">)
	</cfquery>
	
</cffunction>

<cffunction name="fnValidarHora" access="private" returntype="struct">
	<cfargument name="Hora" type="string" required="yes">
	
	<cfset vn_horas   = "">
	<cfset vn_minutos = "">
	<cfset vn_tminutos = 0>
	<cfset structHora = StructNew()>
	<cfif Len(Trim(Arguments.Hora)) eq 5>
		<cfset vn_horas   = Mid(Arguments.Hora,1,2)>
		<cfif not isNumeric(vn_horas)>
			<cfset vn_horas = -1>
		</cfif>
		<cfset vn_minutos = Mid(Arguments.Hora,4,2)>
		<cfif not isNumeric(vn_minutos)>
			<cfset vn_minutos = -1>
		</cfif>
		<cfset vn_tminutos = vn_horas * vn_minutos>
		<cfset StructInsert(structHora, 'hora', vn_horas)>
 		<cfset StructInsert(structHora, 'minutos', vn_minutos)>
	</cfif>

	<cfif Len(Trim(Arguments.Hora)) neq 5 or vn_horas GT 23 or vn_horas LT 0 or vn_minutos GT 59 or vn_minutos LT 0>
		<cfset fnInsertarError('La hora (#Arguments.Hora#) no es válido.')>
		<cfif StructKeyExists(structHora, "hora")>
			<cfset StructUpdate(structHora, 'hora', 0)>
		<cfelse>
			<cfset StructInsert(structHora, 'hora', 0)>
		</cfif>
		
		<cfif StructKeyExists(structHora, "minutos")>
			<cfset StructUpdate(structHora, 'minutos', 0)>
		<cfelse>
			<cfset StructInsert(structHora, 'minutos', 0)>
		</cfif>
	</cfif>
	<cfreturn structHora>
</cffunction>

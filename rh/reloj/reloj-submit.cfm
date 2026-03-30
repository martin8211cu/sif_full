<cfsetting enablecfoutputonly="yes">
<!---
Regresa variables para flash en formato para LoadVars.

	e:   0 si se acepta el registro
	     != 0 si hay error
	msg: Texto en caso de que haya error

Variables de entrada:
	url.c: Cedula del empleado (DatosEmpleado.DEidentificacion)	
	url.k: Password de tarjeta del empleado (DatosEmpleado.DEpassword)
			El campo se almacena en MD5
	url.b: Tipo de registro (RMtiporegis). Debe ser 1(Entrada) o 2(Salida)
--->
<!---============================== Función: funDatosJornada =======================================----->
<!--- Función para obtener los datos de la jornada ya sea del planificador (si para esa fecha se 	----->
<!--- planificó algo) o bien de los horarios de la jornada que se encuentra definida en la linea 	----->
<!--- del tiempo para esa fecha																		----->
<!---================================================================================================---->
<cffunction name="funDatosJornada" access="public" output="true" returntype="query">
	<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
	<cfargument name="arg_fecha" 	type="date" 	required="yes">
		<cfquery name="rsPlanificador" datasource="#session.DSN#"><!---Buscar los datos en el planificador--->
			select 	a.RHPJid as Planificador,
					a.RHJid as Jornada,
					a.RHPJfinicio as HoraInicioPlan,
					a.RHPJffinal as HoraFinPlan,
					(select RHCJperiodot
					from RHComportamientoJornada b
					where a.RHJid = b.RHJid
						and b.RHCJcomportamiento = 'H'
						and b.RHCJmomento = 'D') as DespuesSalida,
					(select RHCJperiodot
					from RHComportamientoJornada b
					where a.RHJid = b.RHJid
						and b.RHCJcomportamiento = 'R'
						and b.RHCJmomento = 'A') as AntesSalida,
					(select RHCJperiodot
					from RHComportamientoJornada b
					where a.RHJid = b.RHJid
						and b.RHCJcomportamiento = 'H'
						and b.RHCJmomento = 'A') as AntesEntrada,
					(select RHCJperiodot
					from RHComportamientoJornada b
					where a.RHJid = b.RHJid
						and b.RHCJcomportamiento = 'R'
						and b.RHCJmomento = 'D') as DespuesEntrada
			from RHPlanificador a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">				
				and <cf_dbfunction name="date_format" args="a.RHPJfinicio,yyyymmdd"> = <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(Arguments.arg_fecha),'yyyymmdd')#"> 
		</cfquery>
		<cfif rsPlanificador.RecordCount EQ 0><!----Si no tiene nada en el planificador---->
			<cfquery name="rsLineaT" datasource="#session.DSN#"><!---Busca la joranada y el horario--->
				select 	'' as Planificador,
						a.RHJid as Jornada,
						d.RHJhoraini as HoraInicioPlan,
						d.RHJhorafin as HoraFinPlan,
						(select RHCJperiodot
						from RHComportamientoJornada b
						where a.RHJid = b.RHJid
							and b.RHCJcomportamiento = 'H'
							and b.RHCJmomento = 'D') as DespuesSalida,
						(select RHCJperiodot
						from RHComportamientoJornada b
						where a.RHJid = b.RHJid
							and b.RHCJcomportamiento = 'R'
							and b.RHCJmomento = 'A') as AntesSalida,
						(select RHCJperiodot
						from RHComportamientoJornada b
						where a.RHJid = b.RHJid
							and b.RHCJcomportamiento = 'H'
							and b.RHCJmomento = 'A') as AntesEntrada,
						(select RHCJperiodot
						from RHComportamientoJornada b
						where a.RHJid = b.RHJid
							and b.RHCJcomportamiento = 'R'
							and b.RHCJmomento = 'D') as DespuesEntrada
													
				from LineaTiempo a
					inner join RHJornadas c
						on a.RHJid = c.RHJid
						
						inner join RHDJornadas d	<!---Obtener los datos del horario de la jornada ---->
							on c.RHJid = d.RHJid
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('w',Arguments.arg_fecha)#">  =  d.RHDJdia
			
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">		
					and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(Arguments.arg_fecha,'yyyymmdd')#"> 
						between <cf_dbfunction name="date_format" args="a.LTdesde,yyyymmdd"> and
							 	<cf_dbfunction name="date_format" args="a.LThasta,yyyymmdd">
			</cfquery>
			<cfif rsPlanificador.RecordCount EQ 0>
				<cfif rsLineaT.RecordCount NEQ 0>
					<!----NOTA: La fecha de la hora planificada TIENE que ser igual a la fecha de la marca, lo que interesa es la hora, esto para efectos de comparacion ---->
					<cfset rsLineaT.HoraInicioPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)), 
							DatePart("h", "#rsLineaT.HoraInicioPlan#"), DatePart("n", "#rsLineaT.HoraInicioPlan#"),DatePart("s", "#rsLineaT.HoraInicioPlan#"))>
					<cfset rsLineaT.HoraFinPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)), 
							DatePart("h", "#rsLineaT.HoraFinPlan#"), DatePart("n", "#rsLineaT.HoraFinPlan#"),DatePart("s", "#rsLineaT.HoraFinPlan#"))>											
				</cfif>
				<cfreturn rsLineaT>				
			</cfif>
		<cfelse>
			<!----NOTA: La fecha de la hora planificada TIENE que ser igual a la fecha de la marca, lo que interesa es la hora, esto para efectos de comparacion ---->
			<cfset rsPlanificador.HoraInicioPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)), 
					DatePart("h", "#rsPlanificador.HoraInicioPlan#"), DatePart("n", "#rsPlanificador.HoraInicioPlan#"),DatePart("s", "#rsPlanificador.HoraInicioPlan#"))>
			<cfset rsPlanificador.HoraFinPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)), 
					DatePart("h", "#rsPlanificador.HoraFinPlan#"), DatePart("n", "#rsPlanificador.HoraFinPlan#"),DatePart("s", "#rsPlanificador.HoraFinPlan#"))>
			<cfreturn rsPlanificador>
		</cfif>
</cffunction>

<cfif isdefined('form.Accion') and len(trim(form.Accion))>
	<cfif form.Accion EQ 'Entrada'>
		<cfset url.b = 1>
	</cfif>
	<cfif form.Accion EQ 'Salida'>
		<cfset url.b = 2>
	</cfif>
</cfif>

<cfif isdefined('form.c') and len(trim(form.c))>
	<cfset url.c = form.c>
</cfif>
<cfif isdefined('form.u') and len(trim(form.u))>
	<cfset url.u = form.u>
</cfif>

<cfif isdefined('form.k') and len(trim(form.k))>
	<cfset url.k = form.k>
</cfif>

<cfquery name="rsRelojMarcador" datasource="#session.DSN#">
	select Pvalor
	from RHParametros 
	where Pcodigo = 570 
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
</cfquery>
<cfquery name="rsReferencia" datasource="asp">
	select llave
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
</cfquery>
	
<cfif session.locReloj EQ 1 and rsRelojMarcador.Pvalor EQ 0>
	<cfif rsReferencia.recordCount gt 0> 
		<!--- usuario con empleado asociado, sin requerir clave  segun parametros RH--->
		<cfquery datasource="#session.dsn#" name="rsDatosEmp">
			select DEidentificacion, DEpassword
			from DatosEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(rsReferencia.llave)#">
		</cfquery>
		<cfset identificacion = rsDatosEmp.DEidentificacion>
		<cfset password = rsDatosEmp.DEpassword>
	<cfelse>	 
		<!--- usuario sin empleado asociado, sin requerir clave  segun parametros RH, pero por no ser empleado se exige clave--->
		<cfset identificacion = url.u>
		<cfset password = Hash(url.k)>
	</cfif>
<cfelse> 
	 <!--- usuario con empleado asociado, requiere clave segun parametros RH--->
		<cfset identificacion = url.u>
		<cfset password = Hash(url.k)> <!--- password sin encriptar, encriptarlo--->
</cfif>

<cfquery datasource="#session.dsn#" name="validar">
	select DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2
	from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(identificacion)#">
	  and DEpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#password#">
</cfquery>

<cfquery datasource="#session.dsn#" name="reloj">
	select c.Dcodigo, c.Ocodigo
	from RHRelojMarcador r join CFuncional c on c.CFid = r.CFid
	where r.RHRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHRid#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfparam name="url.b" default="0">
<cfif validar.RecordCount and ListFind('1,2', url.b)>
	<!-----======= Obtener los datos de la jornada ========------>
	<cfset rsDatos = funDatosJornada(validar.DEid,LSDateFormat(now(),'dd/mm/yyyy'))>
	<!----========= Se cambia el insert de la tabla RMarcas por la tabla RHControlMarcas =========--->
	<cfif rsDatos.RecordCount NEQ 0>
		<cfquery datasource="#session.DSN#">
			insert into RHControlMarcas(Ecodigo, DEid, RHASid, fechahorareloj, 
										tipomarca, justificacion, registroaut, fechahoraautorizado, 
										usuarioautor, fechahoramarca, regprocesado, RHJid, 
										RHPJid, RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, 
										numlote, canthoras, BMUsucodigo, BMfecha)
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#validar.DEid#">,
					null, 	<!----RHASid---->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,	<!----fechahorareloj---->	
					<cfif url.b EQ 1><!----tipomarca---->
						'E',
					<cfelse>
						'S',
					</cfif>
					null,	<!---justificacion---->
					0,		<!---registroaut---->
					null,	<!---fechahoraautorizado---->
					null,	<!---usuarioautor---->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,	<!----fechahoramarca---->
					0,		<!----regprocesado---->
					<cfif len(trim(rsDatos.Jornada))>		<!----RHJid---->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Jornada#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(rsDatos.Planificador))>	<!----RHPJid----->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Planificador#">,
					<cfelse>
						null,	
					</cfif>	
					<cfif url.b EQ 1>	<!----RHCMhoraplan----->
						<cfif len(trim(rsDatos.HoraInicioPlan))>	
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.HoraInicioPlan#">
						<cfelse>	
							null
						</cfif>,
					<cfelse>
						<cfif len(trim(rsDatos.HoraFinPlan))>	
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.HoraFinPlan#">
						<cfelse>	
							null
						</cfif>,
					</cfif>				
					<cfif url.b EQ 1>	<!----ttoleranciaantes----->
						<cfif len(trim(rsDatos.AntesEntrada))>	
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.AntesEntrada#">
						<cfelse>	
							null
						</cfif>,
					<cfelse>
						<cfif len(trim(rsDatos.AntesSalida))> 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.AntesSalida#">
						<cfelse>	
							null
						</cfif>,
					</cfif>
					<cfif url.b EQ 1>	<!----ttoleranciadesp----->
						<cfif len(trim(rsDatos.DespuesEntrada))>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DespuesEntrada#">
						<cfelse>	
							null
						</cfif>,
					<cfelse>	
						<cfif len(trim(rsDatos.DespuesSalida))>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DespuesSalida#">
						<cfelse>	
							null
						</cfif>,
					</cfif>	
					null, <!----numlote----->
					null, <!---canthoras ---->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,	<!--- BMUsucodigo ---->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">				<!----BMfecha----->
					)
		</cfquery>
	</cfif>
	
	<!---- ================= QUERY ANTERIOR (Modificado el 07/08/2006, solicitado por Carlos Chavarría) ================
	<!--- CFid no se inserta porque se genera en la generación de Lotes de Marcas --->
	<cfquery datasource="#session.dsn#">
		insert into RMarcas (
			Ecodigo, Dcodigo, Ocodigo, DEid,
			RMtiporegis, RMfecha, DEidentificacion,
			RMreloj, RMmarcaproces, BMUsucodigo, BMfecha, RHPMid)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#reloj.Dcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#reloj.Ocodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#validar.DEid#">,
			
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.b#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#validar.DEidentificacion#">,
			
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.RHRcodigo#">,
			0,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#-session.Ecodigo#">
		)

	</cfquery>
	------>

	<cfoutput>
		e=0&msg=#URLEncodedFormat(validar.DEnombre)
		#+#URLEncodedFormat(validar.DEapellido1)
		#+#URLEncodedFormat(validar.DEapellido2)#
		
		<cfif url.b EQ 1><!----tipomarca---->
			<cfset tipo = '(ENTRADA)'>
		<cfelse>
			<cfset tipo = '(SALIDA)'>,
		</cfif>
	</cfoutput>
	
	<cfif isdefined('form.Accion') and len(trim(form.Accion))>
		
		<cflocation url="autogestion.cfm?e=0&msg=#URLEncodedFormat(validar.DEnombre)
		#+#URLEncodedFormat(validar.DEapellido1)
		#+#URLEncodedFormat(validar.DEapellido2)#+#tipo#">
		
	</cfif>
	
<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DatosInvalidosIntenteDeNuevo"
		Default="Datos Invalidos. Intente de Nuevo"
		returnvariable="MSG_DatosInvalidosIntenteDeNuevo"/>	
	<cfoutput>e=1&msg=#MSG_DatosInvalidosIntenteDeNuevo#.</cfoutput>
	<cflocation url="autogestion.cfm?e=1&msg=#MSG_DatosInvalidosIntenteDeNuevo#">
</cfif>

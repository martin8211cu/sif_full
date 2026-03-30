<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoExisteNingunEmpleadoConElIDTarjeta"
	Default="No existe un empleado con el Id de la tarjeta"
	returnvariable="MSG_IDTarjeta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElTipoDeMarcaNoExiste"
	Default="El tipo de marca no existe"
	returnvariable="MSG_TipoMarca"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaFechaDeLaMarcaDebeSerDe6Digitos"
	Default="La fecha de la marca debe ser de 6 dígitos: 2 para el dia, 2 para el mes y 2 para el año"
	returnvariable="MSG_DigitosFecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElFormatoDeLaFechaHoraNoEsElRequerido"
	Default="El formato de la fecha y hora no es el requerido"
	returnvariable="MSG_FormatosFechaHora"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeEncontroUnaJornadaDefinidaParaElEmpleadoEnLaFechaDeLaMarca"
	Default="No se encontró una jornada definida para el empleado en la fecha de la marca"
	returnvariable="MSG_JornadaSinDefinir"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaHoraDeLaMarcaNoExiste"
	Default="La hora de la marca no existe"
	returnvariable="MSG_HoraMarcaNoExiste"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha"
	Default="Fecha"
	returnvariable="MSG_Fecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Hora"
	Default="Hora"
	returnvariable="MSG_Hora"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoHayDatosQueProcesar"
	Default="No hay datos que procesar luego de Borrar las Marcas que no son de Tipo 1 y 3"
	returnvariable="MSG_NoHayDatosQueProcesar"/>

<!---======== Tabla temporal de errores  ========--->
	<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
         <cf_dbtempcol name="LError"   type="varchar(250)" mandatory="no">
    </cf_dbtemp>  
	
	
<!--- 	
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	a.FechaMarca, 
			a.TipoMarca, 
			a.IDTarjeta, 
			a.HoraMarca
	from #table_name# a	
</cfquery>
<cf_dump var="#rsDatos#"> --->
	
<!---======== LZ Borra Todas las Marcas que no son de Tipo 1 y 3  ========--->
	<cfquery name="rsBorraMarcas" datasource="#session.DSN#">
		delete from #table_name#	
		where rtrim(ltrim(TipoMarca)) not in ('1','3')
	</cfquery>	


<!---======== LZ La Marca de Entrada en Baroda se registra con uno, se Modifica por 'E'  ========--->
	<cfquery name="rsEntrada" datasource="#session.DSN#">
	update #table_name#	
	set TipoMarca='E' 
	where rtrim(ltrim(TipoMarca))='1'
</cfquery>

<!---======== LZ La Marca de Salida en Baroda se registra con uno, se Modifica por 'S'  ========--->
<cfquery name="rsSalida" datasource="#session.DSN#">
	update #table_name#	
	set TipoMarca='S' 
	where rtrim(ltrim(TipoMarca))='3'
</cfquery>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	a.FechaMarca, 
			a.TipoMarca, 
			a.IDTarjeta, 
			a.HoraMarca
	from #table_name# a	
</cfquery>

<cfif rsDatos.recordcount eq 0>
	<cfquery  datasource="#session.DSN#">
		Insert into #errores# (LError)
		values 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_NoHayDatosQueProcesar#">
			)
	</cfquery>	
	
	<cfquery name="ERR" datasource="#session.DSN#">
		select LError as MSG
		from #errores# 
	</cfquery>
</cfif>
<!--- <cfdump var="#rsDatos#"> --->

<!---======== Buscar el DEid del empleado, segun el numero de tarjeta (DEtarjeta) 
--			 &  & ' ' & DEapellido1 & ' ' & DEapellido2 as Funcionario
========--->
<!--- <cfdump var="#rsDatos.recordcount#"> --->
<cftransaction>
<cfloop query="rsDatos">
	<cfif rsDatos.recordcount gt 0>
		<cfquery name="rsDEid" datasource="#session.DSN#">
			select DEid, {fn concat(DEidentificacion,{fn concat('. ',{fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(' ',DEnombre)})})})})})} as Funcionario
				from DatosEmpleado
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ltrim(rtrim(DEtarjeta)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsDatos.IDTarjeta)#">
		</cfquery>
		<!--- <cf_dump var="#rsDEid#"> --->
		
		<cfif rsDEid.RecordCount NEQ 0 and len(trim(rsDEid.DEid))>						
				<!---======== Verificar que el tipo de marca sea S,E,SB,EB ========--->
			<cfif len(trim(rsDatos.TipoMarca)) and (Ucase(rsDatos.TipoMarca) EQ 'E' or Ucase(rsDatos.TipoMarca) EQ 'S' or Ucase(rsDatos.TipoMarca) EQ 'SB' or Ucase(rsDatos.TipoMarca) EQ 'EB')>
				<cfset vb_fechavalida = true>
				<cfset vb_horavalida = true>
				<cfset vn_Dia = Mid(rsDatos.FechaMarca,1,2)>
				<cfset vn_Mes = Mid(rsDatos.FechaMarca,4,2)>
				<cfset vn_Anno = Mid(rsDatos.FechaMarca,7,4)>
				<cfset vn_horas = Mid(rsDatos.HoraMarca,1,2)>
				<cfset vn_minutos = Mid(rsDatos.HoraMarca,4,2)>

				<cfif Isnumeric(vn_Dia)	and Isnumeric(vn_Mes) and Isnumeric(vn_Anno) and Isnumeric(vn_horas) and Isnumeric(vn_minutos)><!---Verificar que las posiciones sean las correctas--->					
					<!-----======== Validar el mes,dia y año ========--->				
					<!-----======== LZ 01-12-2006 Esta Validacion solo permite evaluar datos hasta el 30 de Noviembre, se altera para considerar diciembre ========--->				
					<!----- <cfif vn_Mes LT 12>--->									
					<!-----======== LZ 01-12-2006 Esta Validacion solo permite evaluar datos hasta el 30 de Noviembre, se altera para considerar diciembre ========--->				
						<cfif vn_Mes LT 13>					
						<!---Validar el dia del mes--->
						<cfset vn_cont = DaysInMonth(CreateDate(vn_Anno, vn_Mes, 1))>
						<cfif vn_Dia GT vn_cont><!----El dia no existe para ese mes de ese año----->
							<cfset vb_fechavalida = false>
						</cfif>
					<cfelse><!----El numero de mes no existe---->					
						<cfset vb_fechavalida = false>
					</cfif>
					<!----======== Validar horas ========---->
					<cfif vn_horas GT 23 or vn_horas LT 0>
						<cfset vb_horavalida = false>
					</cfif>
					<cfif vn_minutos GT 59 or vn_minutos LT 0>
						<cfset vb_horavalida = false>
					</cfif>			
								
					<!----Si hubo error de fechas o de horas---->
					<cfif not vb_fechavalida>
						<cfquery name="ERR" datasource="#session.DSN#">
							Insert into #errores# (LError)
								select {fn concat('#MSG_FormatosFechaHora#',{fn concat(' : ',{fn concat('#rsDatos.FechaMarca#',
								{fn concat('. Funcionario ','#rsDEid.Funcionario#')})})})}
						</cfquery>
						
						
					<cfelse>				
						<cfif not vb_horavalida>	
							<cfquery name="ERR" datasource="#session.DSN#">
								Insert into #errores# (LError)
								select {fn concat('#MSG_HoraMarcaNoExiste#',{fn concat(' : ',{fn concat('#rsDatos.FechaMarca#',
								{fn concat('. Funcionario ','#rsDEid.Funcionario#')})})})}
							</cfquery>		
						<cfelse>				
							<cfset vd_fechahoramarca = CreateDateTime(vn_Anno, vn_Mes, vn_Dia, vn_horas, vn_minutos, 00)><!---Fecha de la marca con hora--->
							<cfset vd_fechamarca = CreateDateTime(vn_Anno, vn_Mes, vn_Dia, 00, 00, 00)><!---Fecha de la marca sin hora--->
							<!-----======== Obtener los datos de la jornada ========----->
							<cfset rsJornada = funDatosJornada(rsDEid.DEid,LSDateFormat(vd_fechamarca,'dd/mm/yyyy'))>
							<cfif rsJornada.RecordCount NEQ 0>
								<!-----======== LZ Valida que el Registro que se va a Escribir no este Duplicado ========----->								
								<cfquery name="rsValidaReg" datasource="#session.DSN#">
										select 	count(1) as Cantidad
										From RHControlMarcas			
										where	
											Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
											and DEid=    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#"> 
											and fechahorareloj = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechahoramarca#">
											and tipomarca= <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(rsDatos.TipoMarca)#">
								</cfquery>

								<cfif rsValidaReg.Cantidad EQ 0>																																									
								<!-----======== LZ No Existe el Registro en  RHControlMarcas ========----->								
								<!-----======== Insertar la marca ========----->
									<cfquery datasource="#session.DSN#">
										insert into RHControlMarcas(Ecodigo, 
																DEid, 
																RHASid, 
																fechahorareloj, 
																tipomarca, 
																justificacion, 
																registroaut, 
																fechahoraautorizado, 
																usuarioautor, 
																fechahoramarca, 
																regprocesado, 
																RHJid, 
																RHPJid, 
																RHCMhoraplan, 
																ttoleranciaantes, 
																ttoleranciadesp, 
																numlote, 
																canthoras, 
																BMUsucodigo, 
																BMfecha)
											values(	<!----- ===== Ecodigo ===== ------>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
											<!----- ===== DEid ===== ------>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">,
											<!---- ===== RHASid ===== ---->
											null,
											<!----- ===== fechahorareloj =====----->
											<!-----======== LZ No se guardaba la Fecha Real del Reloj, solo la modificada, se agrega el valor ========----->																				
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechahoramarca#">,
											<!-----===== tipomarca =====--->
											<cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(rsDatos.TipoMarca)#">,
											<!----====== justificacion ======----->
											null,
											<!--- ====== registroaut ======--->
											1,
											<!----==== fechahoraautorizado =====--->
											null,
											<!---- ====== usuarioautor ======---->
											null,
											<!---====== fechahoramarca ======--->
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechahoramarca#">,
											<!-----===== regprocesado ======----->
											0,
											<!---===== RHJid =====--->
											<cfif len(trim(rsJornada.Jornada))>
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.Jornada#">,
											<cfelse>
												null,
											</cfif> 
											<!-----===== RHPJid =====----->
											<cfif len(trim(rsJornada.Planificador))>
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.Planificador#">,
											<cfelse>
												null,	
											</cfif>				
											<!------==== RHCMhoraplan =====--->
											<cfif rsDatos.TipoMarca EQ 'E'><!---Si la marca es de entrada--->
												<cfif len(trim(rsJornada.HoraInicioPlan))>
													<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsJornada.HoraInicioPlan#">
												<cfelse>	
													null
												</cfif>,
											<cfelseif rsDatos.TipoMarca EQ 'S'><!---Si la marca es de salida--->
												<cfif len(trim(rsJornada.HoraFinPlan))>
													<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsJornada.HoraFinPlan#">
												<cfelse>	
													null
												</cfif>,
											<cfelse>
												null,
											</cfif>				
											<!-----===== ttoleranciaantes =====----->
											<cfif rsDatos.TipoMarca EQ 'E' ><!-----Si la marca es de entrada----->
												<cfif len(trim(rsJornada.AntesEntrada))>
													<cfqueryparam cfsqltype="cf_sql_integer" value="#rsJornada.AntesEntrada#">
												<cfelse>	
													null
												</cfif>,
											<cfelseif rsDatos.TipoMarca EQ 'S' ><!-----Si la marca es de salida----->
												<cfif len(trim(rsJornada.AntesSalida))>
													<cfqueryparam cfsqltype="cf_sql_integer" value="#rsJornada.AntesSalida#">
												<cfelse>	
													null
												</cfif>,
											<cfelse>
												null,
											</cfif>				
											<!-----===== ttoleranciadesp =====----->
											<cfif rsDatos.TipoMarca EQ 'E'><!-----Si la marca es de entrada----->
												<cfif len(trim(rsJornada.DespuesEntrada))>
													<cfqueryparam cfsqltype="cf_sql_integer" value="#rsJornada.DespuesEntrada#">
												<cfelse>	
													null
												</cfif>,
											<cfelseif rsDatos.TipoMarca EQ 'S'><!-----Si la marca es de salida----->
												<cfif len(trim(rsJornada.DespuesSalida))>
													<cfqueryparam cfsqltype="cf_sql_integer" value="#rsJornada.DespuesSalida#">
												<cfelse>	
													null
												</cfif>,
											<cfelse>
												null,
											</cfif>								
											<!---- ===== numlote ===== ----->
											null,
											<!---- ===== canthoras ===== ----->
											null,
											<!---- ===== BMUsucodigo ===== ---->
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
											<!---- ===== BMfecha ===== ---->
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
								</cfquery>
								<!-----======== LZ Fin de la Condicion Existe el Registro en  RHControlMarcas ========----->																	
							</cfif>												
										
							<cfelse><!---No encontro jornada--->					
								<cfquery datasource="#session.DSN#">
										Insert into #errores# (LError)
										select {fn concat('#MSG_JornadaSinDefinir#',{fn concat(' : ',{fn concat('#rsDatos.FechaMarca#',
										{fn concat('. Funcionario ','#rsDEid.Funcionario#')})})})}
								</cfquery>
							</cfif>
							
						</cfif>
					</cfif>
				<cfelse><!---Los valores de fecha y hora no tienen el formato requerido--->
					<cfquery datasource="#session.DSN#">
						Insert into #errores# (LError)
						select {fn concat('#MSG_FormatosFechaHora#',{fn concat(' : ',{fn concat('#rsDatos.FechaMarca#',
						{fn concat('. Funcionario ','#rsDEid.Funcionario#')})})})}
					</cfquery>
				</cfif>
			<cfelse><!---El tipo de marca no esta definido--->
				<cfquery  datasource="#session.DSN#">
					Insert into #errores# (LError)
						select {fn concat('#MSG_TipoMarca#',{fn concat(' : ',{fn concat('#rsDatos.FechaMarca#',
						{fn concat('. Funcionario ','#rsDEid.Funcionario#')})})})}
				</cfquery>	
			</cfif>
		<cfelse><!---No existe el ID del empleado--->
			<cfquery  datasource="#session.DSN#">
				Insert into #errores# (LError)
				select {fn concat('#MSG_IDTarjeta#', {fn concat(' : ','#rsDatos.IDTarjeta#')})}
			</cfquery>	
		</cfif>
	<cfelse><!---No existe el IDtarjeta --->
		<cfquery  datasource="#session.DSN#">
			Insert into #errores# (LError)
			select {fn concat('#MSG_IDTarjeta#', {fn concat(' : ','#rsDatos.IDTarjeta#')})}
		</cfquery>	
	</cfif>	
</cfloop>
<cfquery name="DebugA" datasource="#session.DSN#">
	select * from #errores# 
</cfquery>
<!--- <cf_dump var="#DebugA#">  --->

	<!--- <cfquery name="RsErrores" datasource="#session.DSN#">
    	Select LError from #errores#
	</cfquery> --->
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	 <!--- <cf_dump var="#rsErrores#"> ---> 
	<cfif rsErrores.cantidad gt 0>		
		<cfquery name="ERR" datasource="#session.DSN#">
			select LError as MSG
			from #errores#
		</cfquery>	
		<!--- <cf_dump var="#ERR#"> --->
		<cftransaction action="rollback">
	</cfif>
	
	<!--- <cfset vs_xx = ''>
	<cfloop query="RsErrores">
	    	<cfset vs_xx = vs_xx & ' ' & RsErrores.LError & '<BR>'>
	</cfloop>
	<cfif len(trim(vs_xx))>   
    	 <cfthrow message="Proceso Cancelado, Se presentaron los siguientes errores: <BR>" detail= "<cfoutput>#vs_xx#</cfoutput>">
     	 <cfabort>
	 </cfif> --->
</cftransaction>


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



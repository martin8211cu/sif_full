<script>

	alert('ahahah')

</script>
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Lectura de la Tabla de Interfaz --->
<cftransaction isolation="read_uncommitted">
	<cfquery name="rsDatos" datasource="sifinterfaces">
		Select
		ID
		, DEid as IDTarjeta
		, FechaMarca
		, HoraMarca
		, TipoMarca
		from IE717
		where Ecodigo = #session.Ecodigo# and
              ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<cfif rsDatos.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada en la Interfaz 717 Ecodigo = #session.Ecodigo#" >
	</cfif>
</cftransaction>

<!--- Escritura en las Tablas de Minisif --->
<cftransaction>
	<cfoutput query="rsDatos" group="ID">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

		<!---======== Verificar que la fecha venga en el formato 20101231 (yyyyMMdd) ========--->
		<cfif len(trim(rsDatos.FechaMarca)) EQ 8>
			<!---======== Buscar el DEid del empleado, segun el numero de tarjeta (DEtarjeta) ========--->
			<cfif len(trim(rsDatos.IDTarjeta))>
				<cfquery name="rsDEid" datasource="#session.DSN#">
					select DEid from DatosEmpleado
					where DEtarjeta = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.IDTarjeta#">
<!---                       "#NumberFormat(rsDatos.IDTarjeta,'00000')#"--->
				</cfquery>
				<cfif (rsDEid.RecordCount EQ 0) or (len(trim(rsDEid.DEid)) EQ 0)>
            		<cfthrow message="No existe el Id de tarjeta #rsDatos.IDTarjeta#">
                <cfelse>
                	<cfif rsDEid.RecordCount GT 1>
						<cfthrow message="No existe mas de un empleado con el Id de tarjeta #rsDatos.IDTarjeta#">
					<cfelse>
						<!-----======== Verificar que el tipo de marca sea S,E,SB,EB ========----->
						<cfif len(trim(rsDatos.TipoMarca)) and (Ucase(rsDatos.TipoMarca) EQ 'IN' or Ucase(rsDatos.TipoMarca) EQ 'OT')>
							<cfset vb_fechavalida = true>
							<cfset vb_horavalida = true>

<!---							<cfset vn_Anno = Mid(rsDatos.FechaMarca,1,4)>
							<cfset vn_Mes = Mid(rsDatos.FechaMarca,5,2)>
							<cfset vn_Dia = Mid(rsDatos.FechaMarca,7,2)>
--->
							<cfset vn_Dia = Mid(rsDatos.FechaMarca,1,2)>
							<cfset vn_Mes = Mid(rsDatos.FechaMarca,4,2)>
							<cfset vn_Anno = Mid(rsDatos.FechaMarca,7,2)>

							<cfset vn_horas = Mid(rsDatos.HoraMarca,1,2)>
							<cfset vn_minutos = Mid(rsDatos.HoraMarca,4,2)>
							<!---======== Validar fecha ===========----->
							<cfif Isnumeric(vn_Dia)	and Isnumeric(vn_Mes) and Isnumeric(vn_Anno) and Isnumeric(vn_horas) and Isnumeric(vn_minutos)><!---Verificar que las posiciones sean las correctas--->
								<!-----======== Validar el mes,dia y año ========--->
								<cfif vn_Mes LE 12>
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
                                	<cfthrow message="#rsDatos.FechaMarca# Fecha Inválida">
								<cfelse>
									<cfif not vb_horavalida>
                                        <cfthrow message="#rsDatos.HoraMarca# Hora Inválida">
									<cfelse>
										<cfset vd_fechamarca = CreateDateTime(vn_Anno, vn_Mes, vn_Dia, 00, 00, 00)>
										<!---Fecha de la marca sin hora--->
										<cfset vd_fechahoramarca = CreateDateTime(vn_Anno, vn_Mes, vn_Dia, vn_horas, vn_minutos, 00)>							                                        <!---Fecha de la marca con hora--->
										<!---======== Buscar la empresa del empleado en la linea del tiempo ==========---->

										<cfset vn_Ecodigo = funEmpresaEmpleado(rsDEid.DEid,vd_fechamarca)>
										<cfif len(trim(vn_Ecodigo)) EQ 0>
										<!----Si encontro la empresa del empleado en la linea del tiempo---->
                                        	<cfthrow message="No encontró la empresa para el empleado Id #rsDEid.DEid# para la fecha #vd_fechamarca#">
										<cfelse><!----Si se encontro el Ecodigo en la linea del tiempo---->
										<!-----======== Obtener los datos de la jornada ========----->

											<cfset rsJornada = funDatosJornada(rsDEid.DEid,LSDateFormat(vd_fechamarca,'dd/mm/yyyy'),vn_Ecodigo)>
											<cfif rsJornada.RecordCount NEQ 0>
                                            	<cfquery name="rsBuscaMarca" datasource="#session.DSN#">
                                                  select DEid from RHControlMarcas
                                                  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vn_Ecodigo#"> and
                                                  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#"> and
                                                  fechahoramarca = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechahoramarca#">
                                                </cfquery>
                                                <!-----======== La marca ya está Capturada ========----->
												<cfif rsBuscaMarca.RecordCount EQ 0>
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
                                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#vn_Ecodigo#">,
                                                                <!----- ===== DEid ===== ------>
                                                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">,
                                                                <!---- ===== RHASid ===== ---->
                                                                null,
                                                                <!----- ===== fechahorareloj =====----->
                                                                null,
                                                                <!-----===== tipomarca =====--->
                                                                <cfif rsdatos.tipomarca eq 'OT'>'S'<cfelse>'E'</cfif>,
                                                                <!----====== justificacion ======----->
                                                                null,
                                                                <!--- ====== registroaut ======--->
                                                                <!--- 1,****Se cambio el valor por que con 1 automaticamente
																lo marca como checado con 0 hace m�s validaciones --->
																0,
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
                                                                <cfif rsDatos.TipoMarca EQ 'IN'><!---Si la marca es de entrada--->
                                                                    <cfif len(trim(rsJornada.HoraInicioPlan))>
                                                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsJornada.HoraInicioPlan#">
                                                                    <cfelse>
                                                                        null
                                                                    </cfif>,
                                                                <cfelseif rsDatos.TipoMarca EQ 'OT'><!---Si la marca es de salida--->
                                                                    <cfif len(trim(rsJornada.HoraFinPlan))>
                                                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsJornada.HoraFinPlan#">
                                                                    <cfelse>
                                                                        null
                                                                    </cfif>,
                                                                <cfelse>
                                                                    null,
                                                                </cfif>
                                                                <!-----===== ttoleranciaantes =====----->
                                                                <cfif rsDatos.TipoMarca EQ 'IN' ><!-----Si la marca es de entrada----->
                                                                    <cfif len(trim(rsJornada.AntesEntrada))>
                                                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsJornada.AntesEntrada#">
                                                                    <cfelse>
                                                                        null
                                                                    </cfif>,
                                                                <cfelseif rsDatos.TipoMarca EQ 'OT' ><!-----Si la marca es de salida----->
                                                                    <cfif len(trim(rsJornada.AntesSalida))>
                                                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsJornada.AntesSalida#">
                                                                    <cfelse>
                                                                        null
                                                                    </cfif>,
                                                                <cfelse>
                                                                    null,
                                                                </cfif>
                                                                <!-----===== ttoleranciadesp =====----->
                                                                <cfif rsDatos.TipoMarca EQ 'IN'><!-----Si la marca es de entrada----->
                                                                    <cfif len(trim(rsJornada.DespuesEntrada))>
                                                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsJornada.DespuesEntrada#">
                                                                    <cfelse>
                                                                        null
                                                                    </cfif>,
                                                                <cfelseif rsDatos.TipoMarca EQ 'OT'><!-----Si la marca es de salida----->
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
                                                    <cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
                                               	</cfif>

											<cfelse><!---No encontro jornada--->
                                            	<cfthrow message="No encontró la jornada">
											</cfif><!---Fin de si se encontro la jornada---->
										</cfif><!---Fin de si se encontro el Ecodigo----->
									</cfif><!---Fin de si la hora es valida---->
								</cfif><!---Fin de si  la fecha es valida----->
							<cfelse><!---Los valores de fecha y hora no tienen el formato requerido--->
                            	<cfthrow message="Formato de fecha/hora erroneo">
							</cfif>
						<cfelse><!---El tipo de marca no esta definido----->
                        	<cfthrow message="Tipo de marca no definido">
						</cfif>
					</cfif><!---Fin de si el empleado esta en mas de una empresa----->
				</cfif><!---Fin de si el IDtarjeta esta en mas de un empleado---->
			</cfif>
		<cfelse><!---La fecha no es de 6 digitos--->
        	<cfthrow message="La fecha no es de 6 dígitos">
		</cfif>
	</cfoutput>
</cftransaction>

<!---============================== Función: funEmpresaEmpleado ======================================----->
<!--- Función para obtener la empresa del empleado en la fecha de la marca 							  ----->
<!---=================================================================================================---->
<cffunction name="funEmpresaEmpleado" access="public" output="true" returntype="string">
	<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
	<cfargument name="arg_fecha" 	type="date" 	required="yes">
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Ecodigo
		from LineaTiempo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.arg_fecha#"> between LTdesde and LThasta
	</cfquery>
	<cfreturn rsEmpresa.Ecodigo>
</cffunction>
<!---============================== Función: funDatosJornada =======================================----->
<!--- Función para obtener los datos de la jornada ya sea del planificador (si para esa fecha se 	----->
<!--- planificó algo) o bien de los horarios de la jornada que se encuentra definida en la linea 	----->
<!--- del tiempo para esa fecha																		----->
<!---================================================================================================---->
<cffunction name="funDatosJornada" access="public" output="true" returntype="query">
	<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
	<cfargument name="arg_fecha" 	type="date" 	required="yes">
	<cfargument name="arg_ecodigo" 	type="string" 	required="yes">
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

						<!----inner join RHDJornadas d----><!---Obtener los datos del horario de la jornada ---->
						left outer join RHDJornadas d
							on c.RHJid = d.RHJid
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('w',LSParseDateTime(Arguments.arg_fecha))#">  =  d.RHDJdia

				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.arg_ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
					and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(Arguments.arg_fecha),'yyyymmdd')#">
						between <cf_dbfunction name="date_format" args="a.LTdesde,yyyymmdd"> and
							 	<cf_dbfunction name="date_format" args="a.LThasta,yyyymmdd">
			</cfquery>
			<cfif rsPlanificador.RecordCount EQ 0>
				<cfif rsLineaT.RecordCount NEQ 0>
					<!----NOTA: La fecha de la hora planificada TIENE que ser igual a la fecha de la marca, lo que interesa es la hora, esto para efectos de comparacion ---->
					<cfif len(trim(rsLineaT.HoraInicioPlan)) and len(trim(rsLineaT.HoraFinPlan))>
						<cfset rsLineaT.HoraInicioPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)),
								DatePart("h", "#rsLineaT.HoraInicioPlan#"), DatePart("n", "#rsLineaT.HoraInicioPlan#"),DatePart("s", "#rsLineaT.HoraInicioPlan#"))>
						<cfset rsLineaT.HoraFinPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)),
								DatePart("h", "#rsLineaT.HoraFinPlan#"), DatePart("n", "#rsLineaT.HoraFinPlan#"),DatePart("s", "#rsLineaT.HoraFinPlan#"))>
					</cfif>
				</cfif>
				<cfreturn rsLineaT>
			</cfif>
		<cfelse>
			<!----NOTA: La fecha de la hora planificada TIENE que ser igual a la fecha de la marca, lo que interesa es la hora, esto para efectos de comparacion ---->
			<cfif len(trim(rsPlanificador.HoraInicioPlan)) and len(trim(rsPlanificador.HoraFinPlan))>
				<cfset rsPlanificador.HoraInicioPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)),
						DatePart("h", "#rsPlanificador.HoraInicioPlan#"), DatePart("n", "#rsPlanificador.HoraInicioPlan#"),DatePart("s", "#rsPlanificador.HoraInicioPlan#"))>
				<cfset rsPlanificador.HoraFinPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)),
						DatePart("h", "#rsPlanificador.HoraFinPlan#"), DatePart("n", "#rsPlanificador.HoraFinPlan#"),DatePart("s", "#rsPlanificador.HoraFinPlan#"))>
			</cfif>
			<cfreturn rsPlanificador>
		</cfif>
</cffunction>


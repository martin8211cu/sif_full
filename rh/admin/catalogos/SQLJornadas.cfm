<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Error_Las_Horas_Extra_A_no_pueden_ser_menores_que_las_horas_de_la_jornada_Proceso_Cancelado"
	Default="Error: Las Horas Extra A no pueden ser menores que las horas de la jornada. Proceso Cancelado!"
	returnvariable="MG_HorasExtraA"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Error_Las_Horas_Extra_B_no_pueden_ser_menores_que_las_horas_de_la_jornada_Proceso_Cancelado"
	Default="Error: Las Horas Extra B no pueden ser menores que las horas de la jornada. Proceso Cancelado!"
	returnvariable="MG_HorasExtraB"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Error_Las_Horas_Extra_B_no_pueden_ser_menores_que_las_horas_Extra_A_Proceso_Cancelado"
	Default="Error: Las Horas Extra B no pueden ser menores que las horas Extra A. Proceso Cancelado!"
	returnvariable="MG_HorasExtraBExtrasA"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Error_Todas_las_Incidencias_Deben_ser_distintas_Proceso_Cancelado"
	Default="Error: Todas las Incidencias Deben ser distintas. Proceso Cancelado!"
	returnvariable="MG_Incidencias"/>

<cfparam name="action" default="Jornadas-tabs.cfm?tab=1">
<cfparam name="modo" default="ALTA">

<cffunction name="crearFecha" returntype="date" output="true">
	<cfargument name="hora" type="string" required="yes">
	<cfargument name="minutos" type="string" required="yes">
	<cfargument name="tipo" type="string" required="yes">

	<cfset anno = DatePart('yyyy', Now())>
	<cfset mes = DatePart('m', Now())>
	<cfset dia = DatePart('d', Now())>

	<cfset vhora = arguments.hora >
	<cfif trim(tipo) eq 'PM' and compare(vhora,'12') neq 0>
		<cfset vhora = vhora + 12 >
	<cfelseif trim(tipo) eq 'AM' and compare(vhora,'12') eq 0 >
		<cfset vhora = 0 >
	</cfif>

	<cfset fecha = CreateDateTime(anno, mes, dia, vhora, arguments.minutos, 0) >
	<cfreturn fecha >
</cffunction>

<cfset s1 = crearFecha(Mid(Form.horaini,1,2), Mid(Form.minutoini,1,2), Mid(Form.horaini,3,3)) >
<cfset s2 = crearFecha(Mid(Form.horafin,1,2), Mid(Form.minutofin,1,2), Mid(Form.horafin,3,3)) >

<cfif isDefined("form.horainicom") and Len(Trim(form.horainicom)) GT 0 >
	<cfset s3 = crearFecha(Mid(Form.horainicom,1,2), Mid(Form.minutoinicom,1,2), Mid(Form.horainicom,3,3)) >
</cfif>

<cfif isDefined("form.horafincom") and Len(Trim(form.horafincom)) GT 0 >
	<cfset s4 = crearFecha(Mid(Form.horafincom,1,2), Mid(Form.minutofincom,1,2), Mid(Form.horafincom,3,3)) >
</cfif>

<!---==========================================================================================--->
<!--- Funcion que inserta, modifica o elimina el detalle según el parámetro Modo recibido--->
<!---==========================================================================================--->
<cffunction name="ABCDetalle" output="true">
	<cfargument name="RHJid" 	type="numeric" required="yes">	<!---Identity de la jornada insertada--->
	<cfargument name="RHDJdia" 	type="numeric" required="yes">	<!--- Dia de la semana a insertar---->
	<cfargument name="Modo" 	type="string"  required="yes">	<!--- Indica el modo: A(Alta-->Inserta), B (Baja-->Elimina) y C(Cambio-->Update)---->

	<cfif Arguments.Modo EQ 'A'><!---Alta del registro--->
		<cfquery name="rsInsertaDetalle" datasource="#session.DSN#">
			insert into RHDJornadas (RHJid,
									RHDJdia,
									Ecodigo,
									RHJhoraini,
									RHJhorafin,
									RHJhorainicom,
									RHJhorafincom,
									RHJhoradiaria,
									RHJornadahora,
									RHJtipo,
									BMfecha,
									BMUsucodigo,
									RHJhorasNormales,
									RHJhorasExtraA,
									RHJhorasExtraB
						
									)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHDJdia#">,
					Ecodigo,
					RHJhoraini,
					RHJhorafin,
					RHJhorainicom,
					RHJhorafincom,
					RHJhoradiaria,
					RHJornadahora,
					RHJtipo,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfif isdefined("form.RHJhoradiaria") and len(trim(form.RHJhoradiaria))>
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHJhoradiaria#">
					<cfelse>
						null
					</cfif>
					,
					<cfif isdefined("form.RHJhorasExtraA") and len(trim(form.RHJhorasExtraA))>
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHJhorasExtraA#">
					<cfelse>
						null
					</cfif>
					,
					<cfif isdefined("form.RHJhorasExtraB") and len(trim(form.RHJhorasExtraB))>
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHJhorasExtraB#">
					<cfelse>
						null
					</cfif>
					
			from RHJornadas
			where Ecodigo  =<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">
		</cfquery>
	<cfelseif Arguments.Modo EQ 'C'><!---Cambio de registro--->
		<cfquery name="updateDetalle" datasource="#session.DSN#">
			update RHDJornadas
			set RHJhoraini = <cfqueryparam value="#s1#"  cfsqltype="cf_sql_timestamp">,
				RHJhorafin = <cfqueryparam value="#s2#"  cfsqltype="cf_sql_timestamp">,
				RHJhorainicom = <cfif isDefined("form.horainicom") and Len(Trim(form.horainicom)) GT 0 ><cfqueryparam value="#s3#"  cfsqltype="cf_sql_timestamp"><cfelse>null</cfif>,
				RHJhorafincom = <cfif isDefined("form.horafincom") and Len(Trim(form.horafincom)) GT 0 ><cfqueryparam value="#s4#"  cfsqltype="cf_sql_timestamp"><cfelse>null</cfif>,
				RHJhoradiaria = <cfqueryparam value="#form.RHJhoradiaria#" cfsqltype="cf_sql_float">,
				RHJornadahora = <cfif isDefined("form.RHJornadahora")>1<cfelse>0</cfif>,
				RHJtipo       = <cfqueryparam value="#form.RHJtipo#" cfsqltype="cf_sql_integer">
				<!---,RHJhorasNormales = <cfif isdefined("form.RHJhoradiaria") and len(trim(form.RHJhoradiaria))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHJhoradiaria#"><cfelse>null</cfif>--->
			where Ecodigo  =<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">
				and RHDJdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHDJdia#">
		</cfquery>
	<cfelseif Arguments.Modo EQ 'B'><!---Baja de registro--->
		<cfquery name="deleteDetalle" datasource="#session.DSN#">
			delete from RHDJornadas
			where Ecodigo  =<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">
				and RHDJdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHDJdia#">
		</cfquery>
	</cfif>
</cffunction>
<!---======================================================================================
 	 Funcion que: 	Verifica si ya existe el dia para esa jornada
	 				Devuelve FALSE --> Si no existe,  TRUE  --> Si existe
	 ======================================================================================---->
<cffunction name="VerificaDetalle" returntype="boolean" output="true">
	<cfargument name="RHJid" type="string" required="yes">		<!---Identity de la jornada a verificar--->
	<cfargument name="RHDJdia" type="string" required="yes">	<!---Dia de la semana a insertar---->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select 1 from RHDJornadas
		where Ecodigo  =<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">
			and RHDJdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHDJdia#">
	</cfquery>
	<cfif rsVerifica.RecordCount EQ 0><!---Si no existe el dia--->
		<cfset vb_devuelta = false>
	<cfelse>
		<cfset vb_devuelta = true>
	</cfif>
	<cfreturn vb_devuelta>
</cffunction>

<!---===============================================================================================================
	Función inserta/actualiza/elimina el comportamiento de la jornada (RHComportamientoJornada), se tienen
	4 registros para cada jornada :
		1) HA --> Antes de entrada, donde H se guarda en el campo RHCJcomportamiento y A en RHCJmomento
		2) RD --> Despues de entrada, donde R se guarda en el campo RHCJcomportamiento y D en RHCJmomento
		3) RA --> Antes de salida, donde R se guarda en el campo RHCJcomportamiento y A en RHCJmomento
		4) HD --> Despues de salida, donde H se guarda en el campo RHCJcomportamiento y D en RHCJmomento
===================================================================================================================---->
<cffunction name="ABCComportamiento" output="true">
	<cfargument name="RHJid" type="string" required="yes">		<!---Identity de la jornada--->

	<cfif isdefined("form.HA") and len(trim(form.HA)) and (not isdefined("form.RHCJid_HA") or len(trim(form.RHCJid_HA)) EQ 0)><!---No existe el comportamiento---->
		<cfquery datasource="#session.DSN#">
			insert into RHComportamientoJornada (RHJid, RHCJcomportamiento, RHCJmomento, RHCJperiodot, RHCJfrige, RHCJfhasta)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="H">,
					<cfqueryparam cfsqltype="cf_sql_char" value="A">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.HA#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(1900,01,01)#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(6100,01,01)#">)
		</cfquery>
	<cfelseif isdefined("form.HA") and len(trim(form.HA)) and isdefined("form.RHCJid_HA") and len(trim(form.RHCJid_HA))><!---Ya existe el componente--->
		<cfquery datasource="#session.DSN#">
			update RHComportamientoJornada
				set RHCJperiodot = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HA#">
			where RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid_HA#">
		</cfquery>
	<cfelseif isdefined("form.RHCJid_HA") and len(trim(form.RHCJid_HA)) and (not isdefined("form.HA") or len(trim(form.HA)) EQ 0)><!----Se quiere quitar---->
		<cfquery datasource="#session.DSN#">
			delete from RHComportamientoJornada
			where RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid_HA#">
		</cfquery>
	</cfif>

	<cfif isdefined("form.RD") and len(trim(form.RD)) and (not isdefined("form.RHCJid_RD") or len(trim(form.RHCJid_RD)) EQ 0)>
		<cfquery datasource="#session.DSN#">
			insert into RHComportamientoJornada (RHJid, RHCJcomportamiento, RHCJmomento, RHCJperiodot, RHCJfrige, RHCJfhasta)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="R">,
					<cfqueryparam cfsqltype="cf_sql_char" value="D">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RD#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(1900,01,01)#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(6100,01,01)#">)
		</cfquery>
	<cfelseif isdefined("form.RD") and len(trim(form.RD)) and isdefined("form.RHCJid_RD") and len(trim(form.RHCJid_RD))><!---Ya existe el componente--->
		<cfquery datasource="#session.DSN#">
			update RHComportamientoJornada
				set RHCJperiodot = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RD#">
			where RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid_RD#">
		</cfquery>
	<cfelseif isdefined("form.RHCJid_RD") and len(trim(form.RHCJid_RD)) and (not isdefined("form.RD") or len(trim(form.RD)) EQ 0)><!----Se quiere quitar---->
		<cfquery datasource="#session.DSN#">
			delete from RHComportamientoJornada
			where RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid_RD#">
		</cfquery>
	</cfif>

	<cfif isdefined("form.RA") and len(trim(form.RA)) and (not isdefined("form.RHCJid_RA") or len(trim(form.RHCJid_RA)) EQ 0)>
		<cfquery datasource="#session.DSN#">
			insert into RHComportamientoJornada (RHJid, RHCJcomportamiento, RHCJmomento, RHCJperiodot, RHCJfrige, RHCJfhasta)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="R">,
					<cfqueryparam cfsqltype="cf_sql_char" value="A">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RA#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(1900,01,01)#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(6100,01,01)#">)
		</cfquery>
	<cfelseif isdefined("form.RA") and len(trim(form.RA)) and isdefined("form.RHCJid_RA") and len(trim(form.RHCJid_RA))><!---Ya existe el componente--->
		<cfquery datasource="#session.DSN#">
			update RHComportamientoJornada
				set RHCJperiodot = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RA#">
			where RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid_RA#">
		</cfquery>
	<cfelseif isdefined("form.RHCJid_RA") and len(trim(form.RHCJid_RA)) and (not isdefined("form.RA") or len(trim(form.RA)) EQ 0)><!----Se quiere quitar---->
		<cfquery datasource="#session.DSN#">
			delete from RHComportamientoJornada
			where RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid_RA#">
		</cfquery>
	</cfif>

	<cfif isdefined("form.HD") and len(trim(form.HD)) and (not isdefined("form.RHCJid_HD") or len(trim(form.RHCJid_HD)) EQ 0)>
		<cfquery datasource="#session.DSN#">
			insert into RHComportamientoJornada (RHJid, RHCJcomportamiento, RHCJmomento, RHCJperiodot, RHCJfrige, RHCJfhasta)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="H">,
					<cfqueryparam cfsqltype="cf_sql_char" value="D">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.HD#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(1900,01,01)#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(6100,01,01)#">)
		</cfquery>
	<cfelseif isdefined("form.HD") and len(trim(form.HD)) and isdefined("form.RHCJid_HD") and len(trim(form.RHCJid_HD))><!---Ya existe el componente--->
		<cfquery datasource="#session.DSN#">
			update RHComportamientoJornada
				set RHCJperiodot = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HD#">
			where RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid_HD#">
		</cfquery>
	<cfelseif isdefined("form.RHCJid_HD") and len(trim(form.RHCJid_HD)) and (not isdefined("form.HD") or len(trim(form.HD)) EQ 0)><!----Se quiere quitar---->
		<cfquery datasource="#session.DSN#">
			delete from RHComportamientoJornada
			where RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid_HD#">
		</cfquery>
	</cfif>
</cffunction>

<cfif not isdefined("form.Nuevo")>
	<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo"
			returnvariable="Lvar_PagaSeptimo">
	<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250"
			returnvariable="Lvar_PagaQ250">
	<!--- Agregar Jornada --->
	<cfif isdefined("form.Alta")>
		<cfif (isdefined("Form.RHJhorasExtraA") and len(trim(Form.RHJhorasExtraA))) and (Form.RHJhorasExtraA LT Form.RHJhoradiaria)>
			<cf_throw message="#MG_HorasExtraA#" errorcode="2090">
		</cfif>
		<cfif (isdefined("Form.RHJhorasExtraB") and len(trim(Form.RHJhorasExtraB))) and (Form.RHJhorasExtraB LT Form.RHJhoradiaria)>
			<cf_throw message="#MG_HorasExtraB#" errorcode="2095">
		</cfif>
		<cfif (isdefined("Form.RHJhorasExtraB") and len(trim(Form.RHJhorasExtraB)))
				and (isdefined("Form.RHJhorasExtraA") and len(trim(Form.RHJhorasExtraA)))
				and (Form.RHJhorasExtraB LT Form.RHJhorasExtraA)>
			<cf_throw message="#MG_HorasExtraBExtrasA#" errorcode="2100">
		</cfif>
		<cfif isdefined("form.RHJincAusencia") and isdefined("form.RHJincHJornada")
			and isdefined("form.RHJincExtraA") and isdefined("form.RHJincExtraB")
			and isdefined("form.RHJincFeriados") and isdefined("form.RHJincHJornada")>
			<cfif not ( form.RHJincAusencia neq form.RHJincHJornada
						and form.RHJincAusencia neq form.RHJincExtraA
						and form.RHJincAusencia neq form.RHJincExtraB
						and form.RHJincAusencia neq form.RHJincFeriados
						and form.RHJincHJornada neq form.RHJincExtraA
						and form.RHJincHJornada neq form.RHJincExtraB
						and form.RHJincHJornada neq form.RHJincFeriados
						and form.RHJincExtraA neq form.RHJincExtraB
						and form.RHJincExtraA neq form.RHJincFeriados
						and form.RHJincExtraB neq form.RHJincFeriados
						)>
				<cf_throw message="#MG_Incidencias#" errorcode="2105">


			</cfif>
		</cfif>
		<cftransaction>
			<cfquery name="insertaEncabezado" datasource="#session.DSN#">
				insert into RHJornadas ( RHJcodigo,
										 Ecodigo,
										 RHJdescripcion,
										 RHJsun,
										 RHJmon,
										 RHJtue,
										 RHJwed,
										 RHJthu,
										 RHJfri,
										 RHJsat,
										 RHJmarcar,
										 RHJhoraini,
										 RHJhorafin,
										 RHJhoradiaria,
										 RHJhorainicom,
										 RHJhorafincom,
										 RHJhorasemanal,
										 RHJdiassemanal,
										 RHJornadahora,
										 RHJtipo,
										 RHJjsemanal,
										 RHJdiaini,
										 RHJfraccionesExtras,
										 RHJminutosExtras,
										 RHJincAusencia,
										 RHJhorasJornada,
										 RHJincExtraA,
										 RHJhorasExtraA,
										 RHJincExtraB,
										 RHJhorasExtraB,
										 RHJincFeriados,
										 RHJrebajaocio,
										 RHJincHJornada
										<cfif Lvar_PagaSeptimo>
											,RHJpagaseptimo
											<!--- ,CIid --->
										</cfif>
										<cfif Lvar_PagaQ250>
											,RHJpagaq250
											<!--- ,CSid --->
										</cfif>
										,RHJtipoPago
										,RHJJornadaIMSS
										,ClaveSAT
										 )
					values ( 	<cfqueryparam value="#form.RHJcodigo#" cfsqltype="cf_sql_char">,
								<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#form.RHJdescripcion#" cfsqltype="cf_sql_varchar">,
								<cfif isDefined("form.RHJsun")>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJmon")>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJtue")>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJwed")>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJthu")>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJfri")>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJsat")>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJmarcar")>1<cfelse>0</cfif>,
								<cfqueryparam value="#s1#"  cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#s2#"  cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#form.RHJhoradiaria#" cfsqltype="cf_sql_float">,
								<cfif isDefined("form.horainicom") and Len(Trim(form.horainicom)) GT 0 ><cfqueryparam value="#s3#"  cfsqltype="cf_sql_timestamp"><cfelse>null</cfif>,
								<cfif isDefined("form.horafincom") and Len(Trim(form.horafincom)) GT 0 ><cfqueryparam value="#s4#"  cfsqltype="cf_sql_timestamp"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJhorasemanal") and Len(Trim(form.RHJhorasemanal)) GT 0 ><cfqueryparam value="#form.RHJhorasemanal#"  cfsqltype="cf_sql_money"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJdiassemanal") and Len(Trim(form.RHJdiassemanal)) GT 0 ><cfqueryparam value="#form.RHJdiassemanal#"  cfsqltype="cf_sql_money"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJornadahora")>1<cfelse>0</cfif>,
								<cfqueryparam value="#LSParseNumber(form.RHJtipo)#" cfsqltype="cf_sql_integer">,
								<cfif isDefined("form.RHJjsemanal") and form.RHJjsemanal EQ 1>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJjsemanal") and len(trim(form.RHJjsemanal))><cfqueryparam value="#form.RHJdiaini#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJfraccionesExtras") and len(trim(form.RHJfraccionesExtras))><cfqueryparam value="#form.RHJfraccionesExtras#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJminutosExtras") and len(trim(form.RHJminutosExtras))><cfqueryparam value="#form.RHJminutosExtras#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJincAusencia") and len(trim(form.RHJincAusencia))><cfqueryparam value="#form.RHJincAusencia#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJhorasJornada") and len(trim(form.RHJhorasJornada))><cfqueryparam value="#form.RHJhorasJornada#" cfsqltype="cf_sql_float"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJincExtraA") and len(trim(form.RHJincExtraA))><cfqueryparam value="#form.RHJincExtraA#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJhorasExtraA") and len(trim(form.RHJhorasExtraA))><cfqueryparam value="#form.RHJhorasExtraA#" cfsqltype="cf_sql_float"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJincExtraB") and len(trim(form.RHJincExtraB))><cfqueryparam value="#form.RHJincExtraB#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJhorasExtraB") and len(trim(form.RHJhorasExtraB))><cfqueryparam value="#form.RHJhorasExtraB#" cfsqltype="cf_sql_float"><cfelse>null</cfif>,
								<cfif isDefined("form.RHJincFeriados") and len(trim(form.RHJincFeriados))><cfqueryparam value="#form.RHJincFeriados#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
								<cfif isdefined("form.RHJrebajaocio")>1<cfelse>0</cfif>,
								<cfif isDefined("form.RHJincHJornada") and len(trim(form.RHJincHJornada))><cfqueryparam value="#form.RHJincHJornada#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
								<cfif Lvar_PagaSeptimo>
									,<cfif isdefined("form.RHJpagaseptimo")>1<cfelse>0</cfif>
									<!--- ,<cfif isdefined("form.CIid") and len(trim(form.CIid)) GT 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#"><cfelse>null</cfif> --->
								</cfif>
								<cfif Lvar_PagaQ250>
									,<cfif isdefined("form.RHJpagaq250")>1<cfelse>0</cfif>
									<!--- ,<cfif isdefined("form.CSid") and len(trim(form.CSid)) GT 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#"><cfelse>null</cfif> --->
								</cfif>
								<cfif isdefined("form.RHJtipoPago") and len(trim(form.RHJtipoPago))>
									,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHJtipoPago#">
								<cfelse>
									,null
								</cfif>
								,<cfqueryparam cfsqltype="cf_sql_integer" value="#(IsDefined('form.RHJJornadaIMSS') ? form.RHJJornadaIMSS : 0)#">
								,<cfqueryparam value="#form.RHJtipo#" cfsqltype="cf_sql_varchar">
								)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertaEncabezado">
			<!---Insertar dias en el detalle de la jornada (RHDJornadas)---->
			<cfif isDefined("form.RHJsun")><!---Domingo--->
				<cfset  ABCDetalle(insertaEncabezado.identity,1,'A')>
			</cfif>
			<cfif isDefined("form.RHJmon")><!---Lunes---->
				<cfset ABCDetalle(insertaEncabezado.identity,2,'A')>
			</cfif>
			<cfif isDefined("form.RHJtue")><!---Martes--->
				<cfset ABCDetalle(insertaEncabezado.identity,3,'A')>
			</cfif>
			<cfif isDefined("form.RHJwed")><!---Miercoles--->
				<cfset ABCDetalle(insertaEncabezado.identity,4,'A')>
			</cfif>
			<cfif isDefined("form.RHJthu")><!---Jueves--->
				<cfset  ABCDetalle(insertaEncabezado.identity,5,'A')>
			</cfif>
			<cfif isDefined("form.RHJfri")><!---Viernes--->
				<cfset ABCDetalle(insertaEncabezado.identity,6,'A')>
			</cfif>
			<cfif isDefined("form.RHJsat")><!---Sabado--->
				<cfset ABCDetalle(insertaEncabezado.identity,7,'A')>
			</cfif>

			<cfset vnComportamiento = ABCComportamiento(insertaEncabezado.identity)>
			 <cfset modo = 'CAMBIO'>

		</cftransaction>

	<!--- Actualizar una Jornada --->
	<cfelseif isdefined("form.Cambio")>

		<cfif (isdefined("Form.RHJhorasExtraA") and len(trim(Form.RHJhorasExtraA))) and (Form.RHJhorasExtraA LT Form.RHJhoradiaria)>
			<cf_throw message="#MG_HorasExtraA#" errorcode="2090">
		</cfif>
		<cfif (isdefined("Form.RHJhorasExtraB") and len(trim(Form.RHJhorasExtraB))) and (Form.RHJhorasExtraB LT Form.RHJhoradiaria)>
			<cf_throw message="#MG_HorasExtraB#" errorcode="2095">
		</cfif>
		<cfif (isdefined("Form.RHJhorasExtraB") and len(trim(Form.RHJhorasExtraB)))
				and (isdefined("Form.RHJhorasExtraA") and len(trim(Form.RHJhorasExtraA)))
				and (Form.RHJhorasExtraB LT Form.RHJhorasExtraA)>
			<cf_throw message="#MG_HorasExtraB#" errorcode="2100">
		</cfif>

		<cfif not ( form.RHJincAusencia neq form.RHJincHJornada
			and form.RHJincAusencia neq form.RHJincExtraA
			and form.RHJincAusencia neq form.RHJincExtraB
			and form.RHJincAusencia neq form.RHJincFeriados
			and form.RHJincHJornada neq form.RHJincExtraA
			and form.RHJincHJornada neq form.RHJincExtraB
			and form.RHJincHJornada neq form.RHJincFeriados
			and form.RHJincExtraA neq form.RHJincExtraB
			and form.RHJincExtraA neq form.RHJincFeriados
			and form.RHJincExtraB neq form.RHJincFeriados
		)>
			<cf_throw message="#MG_Incidencias#" errorcode="2105">

		</cfif>

		<cf_dbtimestamp datasource="#session.dsn#"
						table="RHJornadas"
						redirect="Jornadas.cfm"
						timestamp="#form.ts_rversion#"
						field1="RHJid"
						type1="numeric"
						value1="#form.RHJid#"
						field2="Ecodigo"
						type2="integer"
						value2="#session.Ecodigo#" >

		<cfquery datasource="#session.DSN#">
			update RHJornadas
			set	RHJcodigo = <cfqueryparam value="#form.RHJcodigo#" cfsqltype="cf_sql_char">,
				RHJdescripcion = <cfqueryparam value="#form.RHJdescripcion#"  cfsqltype="cf_sql_varchar">,
				RHJsun = <cfif isDefined("form.RHJsun")>1<cfelse>0</cfif>,
				RHJmon = <cfif isDefined("form.RHJmon")>1<cfelse>0</cfif>,
				RHJtue = <cfif isDefined("form.RHJtue")>1<cfelse>0</cfif>,
				RHJwed = <cfif isDefined("form.RHJwed")>1<cfelse>0</cfif>,
				RHJthu = <cfif isDefined("form.RHJthu")>1<cfelse>0</cfif>,
				RHJfri = <cfif isDefined("form.RHJfri")>1<cfelse>0</cfif>,
				RHJsat = <cfif isDefined("form.RHJsat")>1<cfelse>0</cfif>,
				RHJmarcar = <cfif isDefined("form.RHJmarcar")>1<cfelse>0</cfif>,
				RHJhoraini = <cfqueryparam value="#s1#"  cfsqltype="cf_sql_timestamp">,
				RHJhorafin = <cfqueryparam value="#s2#"  cfsqltype="cf_sql_timestamp">,
				RHJhoradiaria = <cfqueryparam value="#form.RHJhoradiaria#" cfsqltype="cf_sql_float">,
				RHJhorainicom = <cfif isDefined("form.horainicom") and Len(Trim(form.horainicom)) GT 0 ><cfqueryparam value="#s3#"  cfsqltype="cf_sql_timestamp"><cfelse>null</cfif>,
				RHJhorafincom = <cfif isDefined("form.horafincom") and Len(Trim(form.horafincom)) GT 0 ><cfqueryparam value="#s4#"  cfsqltype="cf_sql_timestamp"><cfelse>null</cfif>,
				RHJhorasemanal = <cfif isDefined("form.RHJhorasemanal") and Len(Trim(form.RHJhorasemanal)) GT 0 ><cfqueryparam value="#form.RHJhorasemanal#"  cfsqltype="cf_sql_money"><cfelse>null</cfif>,
				RHJdiassemanal = <cfif isDefined("form.RHJdiassemanal") and Len(Trim(form.RHJdiassemanal)) GT 0 ><cfqueryparam value="#form.RHJdiassemanal#"  cfsqltype="cf_sql_money"><cfelse>null</cfif>,
				RHJornadahora = <cfif isDefined("form.RHJornadahora")>1<cfelse>0</cfif>,
				RHJtipo = <cfqueryparam value="#LSParseNumber(form.RHJtipo)#" cfsqltype="cf_sql_integer">,
				RHJjsemanal=<cfif isDefined("form.RHJjsemanal") and form.RHJjsemanal EQ 1>1<cfelse>0</cfif>,
				RHJdiaini = <cfif isDefined("form.RHJjsemanal") and form.RHJjsemanal EQ 1><cfqueryparam value="#form.RHJdiaini#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
				RHJfraccionesExtras = <cfif isDefined("form.RHJfraccionesExtras") and len(trim(form.RHJfraccionesExtras))><cfqueryparam value="#form.RHJfraccionesExtras#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
				RHJminutosExtras = <cfif isDefined("form.RHJminutosExtras") and len(trim(form.RHJminutosExtras))><cfqueryparam value="#form.RHJminutosExtras#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
				RHJincAusencia = <cfif isDefined("form.RHJincAusencia") and len(trim(form.RHJincAusencia))><cfqueryparam value="#form.RHJincAusencia#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				RHJhorasJornada = <cfif isDefined("form.RHJhorasJornada") and len(trim(form.RHJhorasJornada))><cfqueryparam value="#form.RHJhorasJornada#" cfsqltype="cf_sql_float"><cfelse>null</cfif>,
				RHJincExtraA = <cfif isDefined("form.RHJincExtraA") and len(trim(form.RHJincExtraA))><cfqueryparam value="#form.RHJincExtraA#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				RHJhorasExtraA = <cfif isDefined("form.RHJhorasExtraA") and len(trim(form.RHJhorasExtraA))><cfqueryparam value="#form.RHJhorasExtraA#" cfsqltype="cf_sql_float"><cfelse>null</cfif>,
				RHJincExtraB = <cfif isDefined("form.RHJincExtraB") and len(trim(form.RHJincExtraB))><cfqueryparam value="#form.RHJincExtraB#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				RHJhorasExtraB = <cfif isDefined("form.RHJhorasExtraB") and len(trim(form.RHJhorasExtraB))><cfqueryparam value="#form.RHJhorasExtraB#" cfsqltype="cf_sql_float"><cfelse>null</cfif>,
				RHJincFeriados = <cfif isDefined("form.RHJincFeriados") and len(trim(form.RHJincFeriados))><cfqueryparam value="#form.RHJincFeriados#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				RHJrebajaocio = <cfif isdefined("form.RHJrebajaocio")>1<cfelse>0</cfif>,
				RHJincHJornada = <cfif isDefined("form.RHJincHJornada") and len(trim(form.RHJincHJornada))><cfqueryparam value="#form.RHJincHJornada#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
				<cfif Lvar_PagaSeptimo and isdefined("form.RHJpagaseptimo")><!---  and isdefined("form.CIid") and len(trim(form.CIid)) GT 0 --->
					,RHJpagaseptimo=1
					<!--- ,CIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#"> --->
				<cfelse>
					,RHJpagaseptimo=0
					<!--- ,CIid=null --->
				</cfif>
				<cfif Lvar_PagaQ250 and isdefined("form.RHJpagaq250")><!---  and isdefined("form.CSid") and len(trim(form.CSid)) GT 0 --->
					,RHJpagaq250=1
					<!--- ,CSid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#"> --->
				<cfelse>
					,RHJpagaq250=0
					<!--- ,CSid=null --->
				</cfif>
				,RHJtipoPago = 	<cfif isdefined("form.RHJtipoPago") and len(trim(form.RHJtipoPago))>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHJtipoPago#">
								<cfelse>
									null
								</cfif>
				,RHJJornadaIMSS = <cfqueryparam cfsqltype="cf_sql_bit" value="#(IsDefined('form.RHJJornadaIMSS') ? form.RHJJornadaIMSS : 0)#">
				,ClaveSAT = <cfqueryparam value="#form.RHJtipo#" cfsqltype="cf_sql_varchar">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHJid =  <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<!---Actualiza/Elimina/Inserta el detalle--->
		<!---DOMINGO--->
		<cfif isdefined("form.RHJsun") and VerificaDetalle(form.RHJid,1)>
			<cfset ABCDetalle(form.RHJid,1,'C')>
		<cfelseif isdefined("form.RHJsun") and not VerificaDetalle(form.RHJid,1)>
			<cfset ABCDetalle(form.RHJid,1,'A')>
		<cfelseif not isdefined("form.RHJsun") and  VerificaDetalle(form.RHJid,1)>
			<cfset ABCDetalle(form.RHJid,1,'B')>
		</cfif>
		<!----LUNES---->
		<cfif isdefined("form.RHJmon") and VerificaDetalle(form.RHJid,2)>			<!---Si se marco y  ya existia en el detalle, se modifica--->
			<cfset ABCDetalle(form.RHJid,2,'C')>
		<cfelseif isdefined("form.RHJmon") and not VerificaDetalle(form.RHJid,2)>	<!--Si se marco pero no existe en el detalle, se inserta--->
			<cfset ABCDetalle(form.RHJid,2,'A')>
		<cfelseif not isdefined("form.RHJmon") and  VerificaDetalle(form.RHJid,2)>	<!--Si se desmarco y existe en el detalle, se elimina el registro--->
			<cfset ABCDetalle(form.RHJid,2,'B')>
		</cfif>
		<!----MARTES---->
		<cfif isdefined("form.RHJtue") and VerificaDetalle(form.RHJid,3)>
			<cfset ABCDetalle(form.RHJid,3,'C')>
		<cfelseif isdefined("form.RHJtue") and not VerificaDetalle(form.RHJid,3)>
			<cfset ABCDetalle(form.RHJid,3,'A')>
		<cfelseif not isdefined("form.RHJtue") and  VerificaDetalle(form.RHJid,3)>
			<cfset ABCDetalle(form.RHJid,3,'B')>
		</cfif>
		<!----MIERCOLES---->
		<cfif isdefined("form.RHJwed") and VerificaDetalle(form.RHJid,4)>
			<cfset ABCDetalle(form.RHJid,4,'C')>
		<cfelseif isdefined("form.RHJwed") and not VerificaDetalle(form.RHJid,4)>
			<cfset ABCDetalle(form.RHJid,4,'A')>
		<cfelseif not isdefined("form.RHJwed") and  VerificaDetalle(form.RHJid,4)>
			<cfset ABCDetalle(form.RHJid,4,'B')>
		</cfif>
		<!---JUEVES--->
		<cfif isdefined("form.RHJthu") and VerificaDetalle(form.RHJid,5)>
			<cfset ABCDetalle(form.RHJid,5,'C')>
		<cfelseif isdefined("form.RHJthu") and not VerificaDetalle(form.RHJid,5)>
			<cfset ABCDetalle(form.RHJid,5,'A')>
		<cfelseif not isdefined("form.RHJthu") and  VerificaDetalle(form.RHJid,5)>
			<cfset ABCDetalle(form.RHJid,5,'B')>
		</cfif>
		<!---VIERNES--->
		<cfif isdefined("form.RHJfri") and VerificaDetalle(form.RHJid,6)>
			<cfset ABCDetalle(form.RHJid,6,'C')>
		<cfelseif isdefined("form.RHJfri") and not VerificaDetalle(form.RHJid,6)>
			<cfset ABCDetalle(form.RHJid,6,'A')>
		<cfelseif not isdefined("form.RHJfri") and  VerificaDetalle(form.RHJid,6)>
			<cfset ABCDetalle(form.RHJid,6,'B')>
		</cfif>
		<!---SABADO--->
		<cfif isdefined("form.RHJsat") and VerificaDetalle(form.RHJid,7)>
			<cfset ABCDetalle(form.RHJid,7,'C')>
		<cfelseif isdefined("form.RHJsat") and not VerificaDetalle(form.RHJid,7)>
			<cfset ABCDetalle(form.RHJid,7,'A')>
		<cfelseif not isdefined("form.RHJsat") and  VerificaDetalle(form.RHJid,7)>
			<cfset ABCDetalle(form.RHJid,7,'B')>
		</cfif>

		<!---Si ya existe la jornada pero sin comportamiento definido,  insertar los registros del comportamiento ---->
		<cfset vnComportamiento = ABCComportamiento(form.RHJid)>
	  	<cfset modo = 'CAMBIO'>

	<!--- Borrar una Jornada --->
	<cfelseif isdefined("form.Baja")>
		<!---Elimina el detalle--->
		<cfquery datasource="#session.DSN#">
			delete from RHDJornadas
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHJid =  <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<!---Eliminar el comportamiento --->
		<cfquery datasource="#session.DSN#">
			delete from RHComportamientoJornada
			where RHJid = <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery datasource="#session.DSN#">
			delete from RHJornadas
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHJid =  <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfset action = "Jornadas.cfm">

	<cfelseif isdefined("form.btnRegenerar")>
		<!---Eliminar los detalles si existen --->
		<cfquery datasource="#session.DSN#">
			delete from RHDJornadas
			where RHJid = <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<!---Insertar dias en el detalle de la jornada (RHDJornadas)---->
		<cfif isDefined("form.RHJsun")><!---Domingo--->
			<cfset  ABCDetalle(form.RHJid,1,'A')>
		</cfif>
		<cfif isDefined("form.RHJmon")><!--Lunes---->
			<cfset ABCDetalle(form.RHJid,2,'A')>
		</cfif>
		<cfif isDefined("form.RHJtue")><!--Martes--->
			<cfset ABCDetalle(form.RHJid,3,'A')>
		</cfif>
		<cfif isDefined("form.RHJwed")><!---Miercoles--->
			<cfset ABCDetalle(form.RHJid,4,'A')>
		</cfif>
		<cfif isDefined("form.RHJthu")><!---Jueves--->
			<cfset  ABCDetalle(form.RHJid,5,'A')>
		</cfif>
		<cfif isDefined("form.RHJfri")><!---Viernes--->
			<cfset ABCDetalle(form.RHJid,6,'A')>
		</cfif>
		<cfif isDefined("form.RHJsat")><!---Sabado--->
			<cfset ABCDetalle(form.RHJid,7,'A')>
		</cfif>
		<!---Actualizar RHJhorasNormales de RHDJornadas (Detalle/Horarios de las jornadas)----->
		<cfquery datasource="#session.DSN#">
			update RHDJornadas
				set RHJhorasNormales = <cfqueryparam cfsqltype="cf_sql_float" value="#RHJhoradiaria#">
			where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif not isdefined("form.Nuevo")>
	<input name="RHJid" type="hidden" value="<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>#form.RHJid#<cfelseif isdefined("insertaEncabezado.identity") and len(trim(insertaEncabezado.identity))>#insertaEncabezado.identity#</cfif>">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
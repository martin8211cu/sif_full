<cfparam name="Request.Debug" default="false">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElFormatoDeLasHorasEsDe4Digitos"
	Default="El formato de las horas es incorrecto."
	returnvariable="MSG_FormatoHoras"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElFormatoDeLasHorasEsMilitar"
	Default="El formato de las horas es militar"
	returnvariable="MSG_FormatoHorasMilitar"/>
<!----=============== ELIMINAR JORNADA ===============---->
<cfif isdefined("form.RHPJid_eliminar") and len(trim(form.RHPJid_eliminar))>
	<cfquery datasource="#session.DSN#">
		delete from RHPlanificador
		where RHPJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPJid_eliminar#">
	</cfquery>
<!----=============== AGREGAR/MODIFICAR JORNADAS ===============---->
<cfelseif isdefined("form.btnActualizar") or isdefined("form.btnActualizarSiguiente")>	
	<!----Si existen fechas ya grabadas en el planificador las elimina--->
	<cfif request.debug>
		<cf_dump var="#form#">
	</cfif>
	<cfif isdefined("form.RHPJid") and len(trim(form.RHPJid))>
		<cfquery datasource="#session.DSN#">
			delete from RHPlanificador
			where RHPJid in (#form.RHPJid#)
		</cfquery>
	</cfif>
	<!---Insertar todas las fechas del rango seleccionado--->
	<cfloop list="#form.IDfechas#" index="i">
		<cfif request.debug>
		Fecha:<cfdump var="#i#"><br>
		</cfif>
		<cfif isdefined("form.RHJid_#i#") and len(trim(form['RHJid_#i#']))
			and isdefined("form.RHPJfinicioH_#i#") and len(trim(form['RHPJfinicioH_#i#']))
			and isdefined("form.RHPJffinalH_#i#") and len(trim(form['RHPJffinalH_#i#']))>
			<!---Hora de inicio---->
			<cfif Isnumeric(mid(form['RHPJfinicioH_#i#'],1,2)) and Isnumeric(mid(form['RHPJfinicioH_#i#'],4,2))>
				<cfif mid(form['RHPJfinicioH_#i#'],1,2) LTE 23 and mid(form['RHPJfinicioH_#i#'],4,2) LTE 59>
					<cfset vd_fechainicio = CreateDateTime(mid(i,1,4), mid(i,5,2), mid(i,7,2), mid(form['RHPJfinicioH_#i#'],1,2), mid(form['RHPJfinicioH_#i#'],4,2),0)><!---Fecha de Inicio de la planificacion de la jornada--->
					<cfif request.debug>
						Inicio:<cfdump var="#vd_fechainicio#"><br>			
					</cfif>
				<cfelse>
					<cf_throw message="#MSG_FormatoHorasMilitar#" errorcode="5065">
				</cfif>				
			</cfif>
			<!----Hora final ---->
			<cfif Isnumeric(mid(form['RHPJffinalH_#i#'],1,2)) and Isnumeric(mid(form['RHPJffinalH_#i#'],4,2))>
				<cfif mid(form['RHPJffinalH_#i#'],1,2) LTE 23 and mid(form['RHPJffinalH_#i#'],4,2) LTE 59>
					<cfset vd_fechafin = CreateDateTime(mid(i,1,4), mid(i,5,2), mid(i,7,2), mid(form['RHPJffinalH_#i#'],1,2), mid(form['RHPJffinalH_#i#'],4,2),0)><!---Fecha de Inicio de la planificacion de la jornada--->			
					<cfif request.debug>
						Fin:<cfdump var="#vd_fechafin#"><br>			
					</cfif>
				<cfelse>
					<cf_throw message="#MSG_FormatoHorasMilitar#" errorcode="5065">
				</cfif>	
			</cfif>
			<cfif isdefined("vd_fechainicio") and len(trim(vd_fechainicio)) and isdefined("vd_fechafin") and len(trim(vd_fechafin))>
				<cfif datecompare(vd_fechainicio, vd_fechafin) eq 1><!----Si la jornada incluye 2 dias se inserta en la fecha de finalizacion el dia procesando mas 1 dia---->
					<cfset vd_fechafin = dateadd('d', 1, vd_fechafin)>
				</cfif>
				<!----Si existen fechas ya grabadas en el planificador las elimina--->
				<cfquery name="rsEliminaJornadas" datasource="#session.DSN#">
					delete from RHPlanificador
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and <cf_dbfunction name="date_format" args="RHPJfinicio,yyyymmdd"> = <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(vd_fechainicio,'yyyymmdd')#"> 
				</cfquery>
				<cfif request.debug>
					<cfabort>
				</cfif>
				<cfquery datasource="#session.DSN#">
					insert into RHPlanificador (DEid, RHJid, RHPJfinicio, RHPJffinal, RHPJusuario, RHPJfregistro, BMUsucodigo, RHPlibre)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHJid_#i#']#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechainicio#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechafin#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfif isdefined("form.RHPlibre_#i#")>
								1
							<cfelse>
								0	
							</cfif>
							)
				</cfquery>
			<cfelse>
				<cf_throw message="#MSG_FormatoHoras#" errorcode="5070">
			</cfif> <!---Fin de si los valores digitados para la hora son de 4 digitos---->
		</cfif>			
	</cfloop>
	<cfif isdefined("form.btnActualizarSiguiente") and isdefined("form.DEidSiguiente") and len(trim(form.DEidSiguiente))>
		<cfset form.DEid = form.DEidSiguiente><!----Actualiza el DEid por el siguiente en la lista---->
	</cfif>
</cfif>

<cfset params = ''>
<cfif isdefined("form.DEid") and len(trim(form.DEid))>
	<cfset params = '?DEid='&form.DEid>
</cfif>
<cfif isdefined("form.fechaInicial") and len(trim(form.fechaInicial))>
	<cfset params = params&'&fechaInicial='&form.fechaInicial>
</cfif>
<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
	<cfset params = params&'&fechaFinal='&form.fechaFinal>
</cfif>
<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>
	<cfset params = params&'&Identificacion='&form.Identificacion>
</cfif>
<cfif isdefined("form.Nombre") and len(trim(form.Nombre))>
	<cfset params = params&'&Nombre='&form.Nombre>
</cfif>
<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
	<cfset params = params&'&Grupo='&form.Grupo>
</cfif>

<cflocation url="PlanificaJornadas-Empleado.cfm#params#">
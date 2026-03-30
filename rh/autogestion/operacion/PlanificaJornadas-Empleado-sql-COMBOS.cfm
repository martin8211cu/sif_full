<!----=============== ELIMINAR JORNADA ===============---->
<cfif isdefined("form.RHPJid_eliminar") and len(trim(form.RHPJid_eliminar))>
	<cfquery datasource="#session.DSN#">
		delete from RHPlanificador
		where RHPJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPJid_eliminar#">
	</cfquery>
<!----=============== AGREGAR/MODIFICAR JORNADAS ===============---->
<cfelseif isdefined("form.btnActualizar")>	
	<!----Si existen fechas ya grabadas en el planificador las elimina--->
	<cfif isdefined("form.RHPJid") and len(trim(form.RHPJid))>
		<cfquery datasource="#session.DSN#">
			delete from RHPlanificador
			where RHPJid in (#form.RHPJid#)
		</cfquery>
	</cfif>
	<!---Insertar todas las fechas del rango seleccionado--->
	<cfloop list="#form.IDfechas#" index="i">
		<cfif isdefined("form.RHJid_#i#") and len(trim(form['RHJid_#i#']))
			and isdefined("form.RHPJfinicioH_#i#") and len(trim(form['RHPJfinicioH_#i#']))
			and isdefined("form.RHPJfinicioM_#i#") and len(trim(form['RHPJfinicioM_#i#']))
			and isdefined("form.RHPJfinicioS_#i#") and len(trim(form['RHPJfinicioS_#i#']))
			and isdefined("form.RHPJffinalH_#i#") and len(trim(form['RHPJffinalH_#i#']))
			and isdefined("form.RHPJffinalM_#i#") and len(trim(form['RHPJffinalM_#i#']))
			and isdefined("form.RHPJffinalS_#i#") and len(trim(form['RHPJffinalS_#i#']))>
			<!----Hora de entrada--->
			<cfif isdefined("form.RHPJfinicioS_#i#") and len(trim(form['RHPJfinicioS_#i#']))><!---Si es pasado meridiano y no son las 12 medianoche---->
				<cfset vn_horainicio = form['RHPJfinicioH_#i#']>
				<cfif form['RHPJfinicioS_#i#'] eq 'PM' and compare(vn_horainicio,'12') neq 0>
					<cfset vn_horainicio = vn_horainicio + 12 >
				<cfelseif form['RHPJfinicioS_#i#'] eq 'AM' and compare(vn_horainicio,'12') eq 0 >
					<cfset vn_horainicio = 0 >
				</cfif>			
			</cfif>
			<cfset vd_fechainicio = CreateDateTime(mid(i,1,4), mid(i,5,2), mid(i,7,2), vn_horainicio, form['RHPJfinicioM_#i#'],0)><!---Fecha de Inicio de la planificacion de la jornada--->
			<!----Hora de salida---->
			<cfif isdefined("form.RHPJffinalS_#i#") and len(trim(form['RHPJffinalS_#i#']))><!---Si es pasado meridiano y no son las 12 medianoche---->
				<cfset vn_horavence = form['RHPJffinalH_#i#']>
				<cfif form['RHPJffinalS_#i#'] eq 'PM' and compare(vn_horavence,'12') neq 0>
					<cfset vn_horavence = vn_horavence + 12 >
				<cfelseif form['RHPJffinalS_#i#'] eq 'AM' and compare(vn_horavence,'12') eq 0 >
					<cfset vn_horavence = 0 >
				</cfif>
			</cfif>
			<cfset vd_fechafin = CreateDateTime(mid(i,1,4), mid(i,5,2), mid(i,7,2), vn_horavence, form['RHPJffinalM_#i#'],0)><!---Fecha fin de la planificacion de la jornada--->
			<cfif datecompare(vd_fechainicio, vd_fechafin) eq 1><!----Si la jornada incluye 2 dias se inserta en la fecha de finalizacion el dia procesando mas 1 dia---->
				<cfset vd_fechafin = dateadd('d', 1, vd_fechafin)>
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
		</cfif>			
	</cfloop>
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
<cflocation url="PlanificaJornadas-Empleado.cfm#params#">
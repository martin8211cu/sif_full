<!-----=================================== GENERAR MASIVO ===================================
A) Inserta en la tabla RHPlanificador. Si x ej. se define un rango de fechas de 10/01/2006 
	al 14/01/2006 se insertara un registro por cada día del rango, es decir: 
			1--> 10/01/2006		3--> 12/01/2006		5--> 14/01/2006
			2--> 11/01/2006		4--> 13/01/2006
	Se insertan esos 5 registros para cada empleado chequeado	
B) En el campo RHPJffinal se inserta la misma fecha de inicio (anteriores) pero con la hora
	de salida, excepto que cuando la jornada comprende mas de 1 dia, por ejemplo entrada 
	lunes a las 10:00 p.m y salida martes a las 6:00 a.m, entonces se guarda la fecha
	de inicio mas  un dia
=============================================================================================----->


<cf_dbtemp name="TmpEmpleados" returnvariable="TmpEmpleados" datasource="#session.DSN#">
	<cf_dbtempcol name="Empleado" 	type="varchar(255)"	mandatory="yes">
</cf_dbtemp>

<cfif isdefined("form.btnGenerarMasivo") or isdefined("form.btnContinuar")>
	<!----Eliminar los registro que existan para esos empleados en el rango de fechas seleccionado---->
	<cfquery name="vr" datasource="#session.DSN#">
		select 1 from RHControlMarcas a, RHPlanificador b
		where b.DEid in (#form.chk#)
			and <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd"> between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.RHPJfinicio),'yyyymmdd')#"> 
				and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.RHPJffinal),'yyyymmdd')#"> 
			and a.RHPJid = b.RHPJid
	</cfquery>
	<cfif vr.recordcount GT 0>
		<cf_throw message="Error en Planificador, Ya existen marcas para las fechas que desea Planificar, no puede generar una planificación para estas fechas, Proceso Cancelado!" errorcode="5075">
	</cfif>	

	<cfquery  name="RS_Jornada"datasource="#session.DSN#">
		select RHJornadahora from  RHJornadas 
		where RHJid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">
	</cfquery>	
	
	<!----Hora de entrada--->
	<cfif isdefined("form.RHPJfinicio_s") and len(trim(form.RHPJfinicio_s))><!---Si es pasado meridiano y no son las 12 medianoche---->
		<!----Hora de entrada--->
		<cfset vn_horainicio = form.RHPJfinicio_h>
		<cfif form.RHPJfinicio_s eq 'PM' and compare(vn_horainicio,'12') neq 0>
			<cfset vn_horainicio = vn_horainicio + 12 >
		<cfelseif form.RHPJfinicio_s eq 'AM' and compare(vn_horainicio,'12') eq 0 >
			<cfset vn_horainicio = 0 >
		</cfif>
	</cfif>
	<!----Hora de salida---->
	<cfif isdefined("form.RHPJffinal_s") and len(trim(form.RHPJffinal_s))><!---Si es pasado meridiano y no son las 12 medianoche---->
		<cfset vn_horavence = form.RHPJffinal_h>
		<cfif form.RHPJffinal_s eq 'PM' and compare(vn_horavence,'12') neq 0>
			<cfset vn_horavence = vn_horavence + 12 >
		<cfelseif form.RHPJffinal_s eq 'AM' and compare(vn_horavence,'12') eq 0 >
			<cfset vn_horavence = 0 >
		</cfif>
	</cfif>
	<cfif isdefined("form.btnGenerarMasivo")>
		<!----Antes de realizar la generación se valida si hay empleados con planificacion parcial ---->
		<cfset parcial = false>
		<cfloop list="#form.chk#" index="i"><!----Para cada empleado seleccinado----->
			<cfset parcial = false>
			<cfset vd_fecha = LSParseDateTime(form.RHPJfinicio)><!---Variable fecha para realizar el ciclo--->
			<cfloop condition = "#vd_fecha# LTE #LSParseDateTime(form.RHPJffinal)#"><!----Para cada dia del rango---->
				<cfset vd_fechainicio = CreateDateTime(year(vd_fecha), month(vd_fecha), day(vd_fecha), vn_horainicio, form.RHPJfinicio_m,0)><!----Fecha procesando, con la hora de entrada--->
				<cfset vd_fechafin = CreateDateTime(year(vd_fecha), month(vd_fecha), day(vd_fecha), vn_horavence, form.RHPJffinal_m,0)><!---Fecha procesando, con la hora de salida---->
				<cfif datecompare(vd_fechainicio, vd_fechafin) eq 1><!----Si la jornada incluye 2 dias se inserta en la fecha de finalizacion el dia procesando mas 1 dia---->
					<cfset vd_fechafin = dateadd('d', 1, vd_fechafin)>
				</cfif>		
				<cfquery  name="RS_LT" datasource="#session.DSN#">
					select b.RHJornadahora from LineaTiempo a
					inner join RHJornadas b
						on a.RHJid = b.RHJid
					where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechainicio#"> between LTdesde and  LThasta 
				</cfquery>
				<cfif  isdefined("RS_Jornada") and isdefined("RS_LT") and RS_LT.RHJornadahora eq RS_Jornada.RHJornadahora>
					<cfset parcial = true>
				</cfif>
				<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
			</cfloop>
			<cfif parcial >
				<cfquery  name="RS_insert" datasource="#session.DSN#">
					insert into #TmpEmpleados# (Empleado)
					select 
						{fn concat({fn concat({fn concat({fn concat({fn concat({fn concat(de.DEidentificacion ,' ' )} ,de.DEnombre )},' ')},de.DEapellido1 )}, ' ' )},de.DEapellido2 )}
					 from DatosEmpleado  de
					where de.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
			</cfif>
		</cfloop>	
		<cfquery  name="RS_empleados" datasource="#session.DSN#">
			select * from #TmpEmpleados#
		</cfquery>
	</cfif>	
	
	<cfif isdefined("RS_empleados") and RS_empleados.recordCount GT 0>
		<cfinclude template="Lista-prev.cfm">
		<cfabort>
	<cfelse>
		<cfquery name="r" datasource="#session.DSN#">
			delete from RHPlanificador		
			where RHPlanificador.DEid in (#form.chk#)
			and <cf_dbfunction name="date_format" args="RHPlanificador.RHPJfinicio,yyyymmdd"> between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.RHPJfinicio),'yyyymmdd')#"> 
			and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.RHPJffinal),'yyyymmdd')#"> 
		</cfquery>
		<cfloop list="#form.chk#" index="i"><!----Para cada empleado seleccinado----->
			<cfset vd_fecha = LSParseDateTime(form.RHPJfinicio)><!---Variable fecha para realizar el ciclo--->
			<cfloop condition = "#vd_fecha# LTE #LSParseDateTime(form.RHPJffinal)#"><!----Para cada dia del rango---->
				<cfset vd_fechainicio = CreateDateTime(year(vd_fecha), month(vd_fecha), day(vd_fecha), vn_horainicio, form.RHPJfinicio_m,0)><!----Fecha procesando, con la hora de entrada--->
				<cfset vd_fechafin = CreateDateTime(year(vd_fecha), month(vd_fecha), day(vd_fecha), vn_horavence, form.RHPJffinal_m,0)><!---Fecha procesando, con la hora de salida---->
				<cfif datecompare(vd_fechainicio, vd_fechafin) eq 1><!----Si la jornada incluye 2 dias se inserta en la fecha de finalizacion el dia procesando mas 1 dia---->
					<cfset vd_fechafin = dateadd('d', 1, vd_fechafin)>
				</cfif>		
				
				<cfquery  name="RS_LT" datasource="#session.DSN#">
					select b.RHJornadahora from LineaTiempo a
					inner join RHJornadas b
						on a.RHJid = b.RHJid
					where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechainicio#"> between LTdesde and  LThasta 
				</cfquery>
				<cfif  isdefined("RS_Jornada") and isdefined("RS_LT") and RS_LT.RHJornadahora eq RS_Jornada.RHJornadahora>
					<cfquery datasource="#session.DSN#">
						insert into RHPlanificador (DEid, RHJid, RHPJfinicio, RHPJffinal, RHPJusuario, RHPJfregistro, BMUsucodigo, RHPlibre)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechainicio#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechafin#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfif isdefined("form.optLibre") and form.optLibre EQ 1>
									1
								<cfelse>
									0	
								</cfif>
								)
					</cfquery>
				</cfif>
				<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
			</cfloop>
		</cfloop>	
	</cfif>
<!----===================== BORRADO MASIVO ===================== ---->
<cfelseif isdefined("form.btnBorrarMasivo")>
	<cfquery name="rsVerificaFechas" datasource="#session.DSN#">
		delete from RHPlanificador		
		where RHPlanificador.DEid in (#form.chk#)
			and <cf_dbfunction name="date_format" args="RHPlanificador.RHPJfinicio,yyyymmdd"> between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.RHPJfinicio),'yyyymmdd')#"> 
				and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.RHPJffinal),'yyyymmdd')#"> 
	</cfquery>
</cfif>
<cfoutput>
	<form name="form1" action="PlanificaJornadas.cfm" method="post">		
		<cfif isdefined("form.chkTodos")>
			<input type="hidden" name="Todos" value="1">
		</cfif>
		<input type="hidden" name="chk" value="#form.chk#">	
		<input type="hidden" name="RHJid" value="#form.RHJid#">		
		<input type="hidden" name="RHPJfinicio_h" value="#form.RHPJfinicio_h#">
		<input type="hidden" name="RHPJfinicio_m" value="#form.RHPJfinicio_m#">
		<input type="hidden" name="RHPJfinicio_s" value="#form.RHPJfinicio_s#">
		<input type="hidden" name="RHPJffinal_h" value="#form.RHPJffinal_h#">
		<input type="hidden" name="RHPJffinal_m" value="#form.RHPJffinal_m#">
		<input type="hidden" name="RHPJffinal_s" value="#form.RHPJffinal_s#">	
		<input type="hidden" name="optLibre" value="0">	
	</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

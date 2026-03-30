<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" default="Planificación de Jornadas" vsgrupo="103" returnvariable="nombre_proceso"/>
<cfinvoke key="LB_FechaInicio" default="Fecha Inicio"	 returnvariable="LB_FechaInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaFinal" default="Fecha Final"	 returnvariable="LB_FechaFinal" component="sif.Componentes.Translate" method="Translate"/>					
<cfinvoke key="BTN_Mostrar" default="Mostrar"	 returnvariable="BTN_Mostrar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Actualizar" default="Actualizar"	 returnvariable="BTN_Actualizar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Actualizar_Siguiente" default="Actualizar, Siguiente"	 returnvariable="BTN_Actualizar_Siguiente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Regresar" default="Regresar"	 returnvariable="BTN_Regresar"component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_FechaInicioMayorFechaVence" default="La fecha de inicio no puede ser mayor a la fecha final"	 returnvariable="MSG_FechaDesdeMayorFechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarLaFechaIncialLaFechaFinal" default="Debe seleccionar la fecha incial y la fecha final"	returnvariable="MSG_SeleccionarFechas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ConfirmaActualiza" default="Esta seguro que desea actualizar la planificación del empleado?"	 returnvariable="MSG_ConfirmaActualiza" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="MSG_FechaInicialMenorAHoy" default="La fecha inicial no puede ser menor al día de hoy"	 returnvariable="MSG_FechaInicialMenorAHoy" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Lunes" default="Lunes" returnvariable="LB_Lunes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Martes" default="Martes"returnvariable="LB_Martes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Miercoles" default="Miércoles" returnvariable="LB_Miercoles" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jueves" default="Jueves" returnvariable="LB_Jueves" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Viernes" default="Viernes" returnvariable="LB_Viernes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Sabado" default="Sábado" returnvariable="LB_Sabado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Domingo" default="Domingo" returnvariable="LB_Domingo" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>	  

		<!--- Máscara para la la hora --->
		<script src="/cfmx/rh/js/MaskApi/masks.js"></script>

	  	<!----============== TRADUCCION =================---->
		
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")>
			<cfset form.DEid = url.DEid>
		</cfif>
		<cfif isdefined("url.fechaInicial") and len(trim(url.fechaInicial)) and not isdefined("form.fechaInicial")>
			<cfset form.fechaInicial = url.fechaInicial>
		</cfif>
		<cfif isdefined("url.fechaFinal") and len(trim(url.fechaFinal)) and not isdefined("form.fechaFinal")>
			<cfset form.fechaFinal = url.fechaFinal>
		</cfif>
		<cfif isdefined("url.Identificacion") and len(trim(url.Identificacion)) and not isdefined("form.Identificacion")>
			<cfset form.Identificacion = url.Identificacion>
		</cfif>
		<cfif isdefined("url.Nombre") and len(trim(url.Nombre)) and not isdefined("form.Nombre")>
			<cfset form.Nombre = url.Nombre>
		</cfif>
		<cfif isdefined("url.Grupo") and len(trim(url.Grupo)) and not isdefined("form.Grupo")>
			<cfset form.Grupo = url.Grupo>
		</cfif>

		<cfset vs_fechaActual = LSDateFormat(now(),'dd/mm/yyyy')>

	<!--- LZ 2006-11-08 Parti la Consulta en 2 Partes --->
	<!--- LZ Primera Parte Busca La Maxima linea del Tiempo del funcionario --->
		<cfquery name="rsMaxLTEmpleado" datasource="#Session.DSN#">
		<!----Busca la ULTIMA jornada definida en la linea del tiempo (para los empleados que no estan activos actualmente)---->
			select 	max(lt.LTdesde) as MaxLTdesde
			From LineaTiempo lt
			Where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>
	
	<!--- LZ Segunda Parte Usa el Dato de la Primera Parte y trae la informacion que Pintara en Pantalla en el Encabezado --->		
		<cf_dbfunction name="date_part"   args="hh, l.RHJhoraini" returnvariable="Lvar_date_part_hh_RHJhoraini">
		<cf_dbfunction name="to_char"   args="#Lvar_date_part_hh_RHJhoraini#" returnvariable="Lvar_to_char_date_part_hh_RHJhoraini">
		<cf_dbfunction name="date_part"   args="mi, l.RHJhoraini" returnvariable="Lvar_date_part_mi_RHJhoraini">
		<cf_dbfunction name="to_char"   args="#Lvar_date_part_mi_RHJhoraini#" returnvariable="Lvar_to_char_date_part_mi_RHJhoraini">
		<cf_dbfunction name="date_part"   args="hh, l.RHJhorafin" returnvariable="Lvar_date_part_hh_RHJhorafin">
		<cf_dbfunction name="to_char"   args="#Lvar_date_part_hh_RHJhorafin#" returnvariable="Lvar_to_char_date_part_hh_RHJhorafin">
		<cf_dbfunction name="date_part"   args="mi, l.RHJhorafin" returnvariable="Lvar_date_part_mi_RHJhorafin">
		<cf_dbfunction name="to_char"   args="#Lvar_date_part_mi_RHJhorafin#" returnvariable="Lvar_to_char_date_part_mi_RHJhorafin">
		<cfquery name="rsEmpleado" datasource="#Session.DSN#"><!----Busca la ULTIMA jornada definida en la linea del tiempo (para los empleados que no estan activos actualmente)---->
			select 	lt.LTdesde,	
					a.DEid, 
					a.NTIcodigo, 
					a.DEidentificacion, 
					a.DEnombre, 
					a.DEapellido1, 
					a.DEapellido2, 
					n.NTIdescripcion,
					lt.RHJid,
					coalesce(j.RHJornadahora,0) as RHJornadahora,
					j.RHJdescripcion as Jornada,					
					{fn concat(case len(#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhoraini)#) when 1 then
										{fn concat('0',#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhoraini)#)}
									else										
										#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhoraini)#
									end,
								{fn concat(':',
									case len(#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhoraini)#) when 1 then
										{fn concat('0',#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhoraini)#)}
									else
										#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhoraini)#
									end
								)}
					)} as HoraInicio,
					
					{fn concat(case len(#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhorafin)#) when 1 then
										{fn concat('0',#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhorafin)#)}
									else										
										#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhorafin)#
									end,
								{fn concat(':',
									case len(#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhorafin)#) when 1 then
										{fn concat('0',#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhorafin)#)}
									else
										#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhorafin)#
									end
								)}
					)} as HoraFinal
					
			from DatosEmpleado a
				inner join NTipoIdentificacion n
					on a.NTIcodigo = n.NTIcodigo
				inner join LineaTiempo lt
					on a.DEid = lt.DEid
					and a.Ecodigo = lt.Ecodigo
				inner join RHJornadas j
					on lt.RHJid = j.RHJid
					and a.Ecodigo = j.Ecodigo
					
					inner join RHDJornadas l
						on j.RHJid = l.RHJid
						<!--- and <cf_dbfunction name="date_part" args="dw,lt.LTdesde"> = l.RHDJdia --->
							
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and lt.LTdesde =<cfqueryparam cfsqltype="cf_sql_date" value="#rsMaxLTEmpleado.MaxLTdesde#">
		</cfquery>
		
		<!--- LZ FIN 2006-11-08 Parti la Consulta en 2 Partes --->
		<cfquery name="rsJornadas0" datasource="#Session.DSN#">
			select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion,RHJornadahora
			from RHJornadas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and coalesce(RHJornadahora,0) = 0
			and coalesce(RHJmarcar,0)=1
		</cfquery>
		
		<cfquery name="rsJornadas1" datasource="#Session.DSN#">
			select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion,RHJornadahora
			from RHJornadas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and coalesce(RHJornadahora,0) = 1
			and coalesce(RHJmarcar,0)=1
		</cfquery>
		
		<!--- <cfdump var="#rsJornadas0#">
		<cfdump var="#rsJornadas1#"> --->
		
		<cfif isdefined("form.fechaInicial") and len(trim(form.fechaInicial))>
			<cfset vd_fechaInicial = LSParseDateTime(form.fechaInicial)>
		<cfelse>
			<cfset vd_fecha = CreateDateTime(year(now()), month(now()), day(now()), 00, 00,0)><!---Variable con la fecha---->
			<cfloop condition = "#DayOfWeek(vd_fecha)# NEQ 2">				
				<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
			</cfloop>
			<cfset vd_fechaInicial = vd_fecha >
		</cfif>
		
		<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
			<cfset vd_fechaFinal = LSParseDateTime(form.fechaFinal)>
		<cfelse>
			<cfset vd_fechaFinal = DateAdd("d", 6, "#vd_fechaInicial#")><!---Fecha del dia + 6 dias para presentar 7 días de la semana apartir de hoy---->
		</cfif>
	
		<!---Tabla temporal para almacenar todas las fechas del rango seleccionado---->
		<cf_dbtemp name="TmpRangoFec" returnvariable="TmpRangoFec" datasource="#session.DSN#">
			<cf_dbtempcol name="tmpfecha" 	    type="datetime"		mandatory="yes">
			<cf_dbtempcol name="RHJid" 	        type="numeric"		mandatory="no">
			<cf_dbtempcol name="RHJornadahora" 	type="int"	     	mandatory="no">
			<cf_dbtempcol name="HoraInicio" 	type="varchar(255)"	   	mandatory="no">
			<cf_dbtempcol name="HoraFinal" 	    type="varchar(255)"	   	mandatory="no">
		</cf_dbtemp>
		
		<cfset vd_fecha = CreateDateTime(year(vd_fechaInicial), month(vd_fechaInicial), day(vd_fechaInicial), 00, 00,0)><!---Variable con la fecha---->
		<cfloop condition = "#vd_fecha# LTE #vd_fechaFinal#">
			<cfquery datasource="#session.DSN#">
				insert into #TmpRangoFec# (tmpfecha)
				values(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">)
			</cfquery>			
			<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
		</cfloop>

		<cfquery datasource="#session.DSN#">
			update #TmpRangoFec#
			set  RHJid = (
				select a.RHJid from LineaTiempo a
				inner join RHJornadas b
					on a.RHJid = b.RHJid
				where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and #TmpRangoFec#.tmpfecha between LTdesde and  LThasta ),
			RHJornadahora = (
				select b.RHJornadahora from LineaTiempo a
				inner join RHJornadas b
					on a.RHJid = b.RHJid
				where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and #TmpRangoFec#.tmpfecha between LTdesde and  LThasta ),
			 HoraInicio = (
				select distinct l.RHJhoraini
				from LineaTiempo a
				inner join RHJornadas b
					on a.RHJid = b.RHJid
				inner join RHDJornadas l
						on b.RHJid = l.RHJid	
				where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and #TmpRangoFec#.tmpfecha between LTdesde and  LThasta ),
			
			 HoraFinal = (
				select distinct l.RHJhorafin
				from LineaTiempo a
				inner join RHJornadas b
					on a.RHJid = b.RHJid
				inner join RHDJornadas l
						on b.RHJid = l.RHJid	
				where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and #TmpRangoFec#.tmpfecha between LTdesde and  LThasta )
				

										
			where exists(
				select 1 from LineaTiempo a
				inner join RHJornadas b
					on a.RHJid = b.RHJid
				where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and #TmpRangoFec#.tmpfecha between LTdesde and  LThasta )
		</cfquery> 
		
		<cfif rsEmpleado.RecordCount NEQ 0>
			<!----Jornadas definidas en el planificador para el empleado en el rango del dia actual + 6 dias mas ------>
			<cf_dbfunction name="date_part"   args="hh, a.RHPJfinicio" returnvariable="Lvar_date_part_hh_RHPJfinicio">
			<cf_dbfunction name="to_char"   args="#Lvar_date_part_hh_RHPJfinicio#" returnvariable="Lvar_to_char_date_part_hh_RHPJfinicio">
			<cf_dbfunction name="date_part"   args="mi, a.RHPJfinicio" returnvariable="Lvar_date_part_mi_RHPJfinicio">
			<cf_dbfunction name="to_char"   args="#Lvar_date_part_mi_RHPJfinicio#" returnvariable="Lvar_to_char_date_part_mi_RHPJfinicio">
			<cf_dbfunction name="date_part"   args="hh, a.RHPJffinal" returnvariable="Lvar_date_part_hh_RHPJffinal">
			<cf_dbfunction name="to_char"   args="#Lvar_date_part_hh_RHPJffinal#" returnvariable="Lvar_to_char_date_part_hh_RHPJffinal">
			<cf_dbfunction name="date_part"   args="mi, a.RHPJffinal" returnvariable="Lvar_date_part_mi_RHPJffinal">
			<cf_dbfunction name="to_char"   args="#Lvar_date_part_mi_RHPJffinal#" returnvariable="Lvar_to_char_date_part_mi_RHPJffinal">
			<cf_dbfunction name="date_format" args="c.tmpfecha,yyyymmdd" returnvariable="Lvar_param1">
			<cf_dbfunction name="date_format" args="a.RHPJfinicio,yyyymmdd" returnvariable="Lvar_param2">
			<cf_dbfunction name="date_part" args="dw,c.tmpfecha" returnvariable="Lvar_param3">
			<cfquery name="rsDatos" datasource="#session.DSN#">
			 	select 	a.RHPJid,
						c.tmpfecha,
						case #preservesinglequotes(Lvar_param3)#
							when 2 then
								'#LB_Lunes#'
							when 3 then
								'#LB_Martes#'
							when 4 then 
								'#LB_Miercoles#'
							when 5 then 
								'#LB_Jueves#'
							when 6 then
								'#LB_Viernes#'
							when 7 then
								'#LB_Sabado#'
							when 1 then
								'#LB_Domingo#'	
						end as Dia,					
						case when a.RHPJid is null then 
							c.HoraInicio
						else
							<cf_dbfunction name="to_char" args="a.RHPJfinicio">
						end as HoraInicio,
						
						case when a.RHPJid is null then 
							c.HoraFinal
						else
							<cf_dbfunction name="to_char" args="a.RHPJffinal">
						end as HoraFinal,
						case when a.RHPJid is null then 
							c.RHJid
						else
							a.RHJid
						end  as Jornada,
						c.RHJornadahora,					
						a.RHPlibre
				from #TmpRangoFec# c
					left outer join RHPlanificador a
						on #preservesinglequotes(Lvar_param1)# = #preservesinglequotes(Lvar_param2)#
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				order by c.tmpfecha
			</cfquery>
			<!---Empleado que sigue al click en Actualizar, Siguiente---->
			<cfquery name="rsLista" datasource="#session.DSN#" maxrows="1">
				select b.DEid																		
				from RHCMAutorizadoresGrupo a
				inner join RHCMEmpleadosGrupo b
					on a.Gid = b.Gid
					and a.Ecodigo = b.Ecodigo
				
					inner join DatosEmpleado c
						on b.DEid = c.DEid
						and b.Ecodigo = c.Ecodigo		
						<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>
							and upper(c.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Identificacion)#%">
						</cfif>
						<cfif isdefined("form.Nombre") and len(trim(form.Nombre))>
							and upper({fn concat(c.DEapellido1,{fn concat(' ',{fn concat(c.DEapellido2,{fn concat(' ',c.DEnombre)})})})}) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Nombre)#%">
						</cfif>
				where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and b.DEid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and {fn concat(c.DEapellido1,{fn concat(' ',{fn concat(c.DEapellido2,{fn concat(' ',c.DEnombre)})})})} > <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleado.DEapellido1#&' '&#rsEmpleado.DEapellido2#&' '&#rsEmpleado.DEnombre#">
					<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
						and a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">
					</cfif>
					
				order by {fn concat(c.DEapellido1,{fn concat(' ',{fn concat(c.DEapellido2,{fn concat(' ',c.DEnombre)})})})}
			</cfquery>
		</cfif>	
		<table width="100%" cellpadding="2" cellspacing="0">
			<cfif rsEmpleado.RecordCount EQ 0>
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><strong>------<cf_translate key="LB_ElEmpleadoNoSeEncuentraActivoEnLaEmpresa">El empleado no se encuentra activo en la empresa</cf_translate> ------</strong></td></tr>
				<tr><td>&nbsp;</td></tr>
			<cfelse>			
				<tr>
					<td valign="top">						
						<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<cfoutput>
							<table width="100%" cellpadding="0" cellspacing="0">
								<form name="form1" action="PlanificaJornadas-Empleado-sql.cfm" method="post" onsubmit="javascript: funcValidaFechas();">
									<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
									<input type="hidden" name="RHPJid_eliminar" value=""><!---Campo para guardar el RHPJid de la jornada a eliminar--->
									<!---============= Campos ocultos de la pantalla anterior ===============---->
									<input type="hidden" name="Identificacion" value="<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>#form.Identificacion#</cfif>">
									<input type="hidden" name="Nombre" value="<cfif isdefined("form.Nombre") and len(trim(form.Nombre))>#form.Nombre#</cfif>">
									<input type="hidden" name="Grupo" value="<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>#form.Grupo#</cfif>">
									<input type="hidden" name="DEidSiguiente" value=""><!---Guarda el DEid del siguiente empleado en la lista---->
									<tr>
										<td><cfinclude template="PlanificaJornadas-empheader.cfm"></td>
									</tr>
									<tr>
										<td>
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td width="13%" align="right"><strong>#LB_FechaInicio#:&nbsp;</strong></td>
													<td width="1%">
														<cf_sifcalendario  tabindex="1" form="form1" name="fechaInicial" value="#LSDateFormat(vd_fechaInicial,'dd/mm/yyyy')#" onBlur="funcValidaFechas()">													</td>
													<td width="13%" align="right"><strong>#LB_FechaFinal#:&nbsp;</strong></td>
													<td width="14%">
														<cf_sifcalendario  tabindex="1" form="form1" name="fechaFinal" value="#LSDateFormat(vd_fechaFinal,'dd/mm/yyyy')#" onBlur="funcValidaFechas()">													</td>
													<td width="12%"><input tabindex="1" type="button" name="btnGenerar" value="#BTN_Mostrar#" onclick="javascript: return funGenerar();" /></td>
													<td width="23%">
														<input tabindex="1" type="submit" name="btnActualizarSiguiente" value="#BTN_Actualizar_Siguiente#" onclick="javascript: if ( confirm('#MSG_ConfirmaActualiza#') ){ funcCargaEmpleado();return true;} return false;">													</td>
													<td width="13%">
														<input tabindex="1" type="submit" name="btnActualizar" value="#BTN_Actualizar#" onclick="javascript: if ( confirm('#MSG_ConfirmaActualiza#') ){return true;} return false;">													</td>
													<td width="11%"><input tabindex="1" type="button" name="btnRegresar" value="#BTN_Regresar#" onclick="javascript: location.href = 'PlanificaJornadas.cfm';"></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td>
											<table width="100%" cellpadding="2" cellspacing="0">
												<tr class="tituloListas">
													<td width="1%">&nbsp;</td>
													<td width="25%"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate></strong></td>
													<td width="38%"><strong><cf_translate key="LB_Jornada">Jornada</cf_translate></strong></td>
													<td width="13%"><strong><cf_translate key="LB_HoraEntrada">Hora Entrada</cf_translate></strong></td>
													<td width="13%"><strong><cf_translate key="LB_HoraSalida">Hora Salida</cf_translate></strong></td>
													<td width="5%" align="center"><strong><cf_translate key="LB_Libre">Libre</cf_translate></strong></td>
													<td width="5%">&nbsp;</td>
												</tr>
												<cfset condicion = -1>

												<cfloop query="rsDatos">
													<cfset condicion = rsDatos.RHJornadahora>
													<cfset vs_id = LSDateFormat(rsDatos.tmpfecha,'yyyymmdd')>		<!---Variable con un identificador para cada fecha--->
													<input type="hidden" name="RHPJid" value="#rsDatos.RHPJid#">	<!---Id's de los días que si estan en planificador (Eliminar/Crear)--->
													<input type="hidden" name="IDfechas" value="#vs_id#">			<!---Variable con los identificadores de cada fecha creados (Crear)--->												
													<cfset vs_jornada = rsDatos.Jornada>							<!---Variable con la jornada (Se utiliza asi porque siempre usaba el mismo valor)---->
													
													
													<tr>
														<td>&nbsp;</td>
														<td nowrap>#LSDateFormat(rsDatos.tmpfecha,'dd/mm/yyyy')# , #rsDatos.Dia#</td>
														<td>														
															<cfset lvar_RHJid = "">
															<cfif condicion eq 1>
															    
																<select tabindex="1"  name="RHJid_#vs_id#" onchange="javascript: funcTraeHorario(this.value,'#vs_id#');">
																	<cfloop query="rsJornadas1">																
																		<cfset lvar_RHJid = rsJornadas1.RHJid>	
																		<option value="#lvar_RHJid#" <cfif vs_jornada EQ lvar_RHJid> selected</cfif>>#rsJornadas1.Descripcion#</option>
																	</cfloop>
																</select>
															<cfelse>
																<select tabindex="1"  name="RHJid_#vs_id#" onchange="javascript: funcTraeHorario(this.value,'#vs_id#');">
																	<cfloop query="rsJornadas0">																
																		<cfset lvar_RHJid = rsJornadas0.RHJid>
																		<option value="#lvar_RHJid#" <cfif vs_jornada EQ lvar_RHJid> selected</cfif>>#rsJornadas0.Descripcion#</option>
																	</cfloop>
																</select>
															</cfif>
															
															
														</td>
														<td>
															<cf_inputTime tabindex="1"  name="RHPJfinicioH_#vs_id#" value="#TimeFormat(rsDatos.HoraInicio, 'HH:mm')#">
														</td>
														<td>
															<cf_inputTime tabindex="1"  name="RHPJffinalH_#vs_id#" value="#TimeFormat(rsDatos.HoraFinal, 'HH:mm')#">
														</td>
														<td align="center">
															<input tabindex="1"  type="checkbox" name="RHPlibre_#vs_id#" <cfif rsDatos.RHPlibre EQ 1>checked</cfif>>
														</td>
														<td>
															<cfif len(trim(rsDatos.RHPJid))>
																<img tabindex="-1" border="0" style="cursor:pointer;" src="/cfmx/rh/imagenes/Borrar01_S.gif" onclick="javascript: funcEliminar('#rsDatos.RHPJid#')">
															<cfelse>
																&nbsp;
															</cfif>
														</td>
													</tr>
												</cfloop>
											</table>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
								</form>
							</table>
						</cfoutput>						
						<cf_web_portlet_end>
					</td>	
				</tr>
			</cfif> 
		</table>
		<iframe name="ifr_horario" id="ifr_horario" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" ></iframe>
		<script type="text/javascript" language="javascript1.2">									
			function funcCargaEmpleado(){
				<cfif isdefined("rsLista") and rsLista.RecordCount NEQ 0>
					document.form1.DEidSiguiente.value = <cfoutput>'#rsLista.DEid#'</cfoutput>;
				</cfif>
			}
			function funGenerar(){
				if (document.form1.fechaInicial.value != '' && document.form1.fechaFinal.value != ''){
					/*if (funFechaInicial()){*/
						var inicio = document.form1.fechaInicial.value.split('/');
						var fechainicio = inicio[2] + inicio[1] + inicio[0]
						var hasta = document.form1.fechaFinal.value.split('/');
						var fechafinal = hasta[2] + hasta[1] + hasta[0]
						if (fechainicio > fechafinal){
							<cfoutput>alert("#MSG_FechaDesdeMayorFechaHasta#")</cfoutput>;
							return false;
						}							
					/*}*/
					document.form1.action = '';
					document.form1.submit();
					return true;
				}	
				else{
					<cfoutput>alert("#MSG_SeleccionarFechas#")</cfoutput>;
					return false;
				}						
			}
			
			function funcTraeHorario(pn_RHJid,prn_idObjeto){
				var params = '';
				params = '&form=form1&idObjeto='+prn_idObjeto;
				document.getElementById("ifr_horario").src = "PlanificaJornadas-TraerHorario.cfm?RHJid="+pn_RHJid+"&psOrigen=M"+params;
			}
			
			function funcEliminar(prn_RHPJid){
				document.form1.RHPJid_eliminar.value = prn_RHPJid;
				document.form1.submit();
			}
			
			function funcValidaFechas(){
				var inicio = document.form1.fechaInicial.value.split('/');
				var fechainicio = inicio[2] + inicio[1] + inicio[0]
				var hasta = document.form1.fechaFinal.value.split('/');
				var fechafinal = hasta[2] + hasta[1] + hasta[0]
				if (fechainicio > fechafinal){
					<cfoutput>alert("#MSG_FechaDesdeMayorFechaHasta#")</cfoutput>;
					document.form1.fechaInicial.value = '';
					document.form1.fechaFinal.value = '';
					return false;
				}
				return true;
			}
			
			function funFechaInicial(){
				var inicio = document.form1.fechaInicial.value.split('/');
				var fechainicio = inicio[2] + inicio[1] + inicio[0];
				var fechaactual = <cfoutput>'#vs_fechaActual#'</cfoutput>;
				var fechaactual = fechaactual.split('/');
				var fechaactual = fechaactual[2]+fechaactual[1]+fechaactual[0]
				if (fechainicio < fechaactual){
					<cfoutput>alert("#MSG_FechaInicialMenorAHoy#")</cfoutput>;
					document.form1.fechaInicial.value = <cfoutput>'#vs_fechaActual#'</cfoutput>;
				}			
				funcValidaFechas();
			}			
		</script>
<cf_templatefooter>



<cfsilent>
	<cfsetting requesttimeout="3600">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cfinvoke component="sif.Componentes.TranslateDB"
		method="Translate"
		VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
		Default="Revisi&oacute;n de Marcas de Reloj"
		VSgrupo="103"
		returnvariable="nombre_proceso"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Empleado"
		Default="Empleado"
		returnvariable="LB_Empleado"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ListaDeEmpleados"
		Default="Lista de Empleados"
		returnvariable="LB_ListaDeEmpleados"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_NoSeEncontraronRegistros"
		Default="No se encontraron registros"
		returnvariable="LB_NoSeEncontraronRegistros"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Identificacion"
		Default="IdentificaciÃ³n"
		returnvariable="LB_Identificacion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Todos"
		Default="Todos"
		returnvariable="LB_Todos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_LaCantidadRegistrosVisualizarNoMayorA50"
		Default="La cantidad de registros a visualizar no puede ser mayor a 50	"
		returnvariable="MSG_CantidadMayor"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		returnvariable="BTN_Filtrar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Marca"
		Default="Marca"
		returnvariable="LB_Marca"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha"
		Default="Fecha"
		returnvariable="LB_Fecha"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Entrada"
		Default="Entrada"
		returnvariable="LB_Entrada"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salida"
		Default="Salida"
		returnvariable="LB_Salida"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Planificado"
		Default="Planificado"
		returnvariable="LB_Planificado"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ToleranciaAntes"
		Default="T/A(min)"
		returnvariable="LB_ToleranciaAntes"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ToleranciaDespues"
		Default="T/D(min)"
		returnvariable="LB_ToleranciaDespues"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Status"
		Default="Status"
		returnvariable="LB_Status"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Autorizar"
		Default="Autorizar"
		returnvariable="BTN_Autorizar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Ajustar"
		Default="Ajustar"
		returnvariable="BTN_Ajustar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Agregar"
		Default="Agregar"
		returnvariable="BTN_Agregar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_EstaSeguroQueDeseaAutorizarLasMarcas"
		Default="Esta seguro que desea autorizar las marcas"
		returnvariable="MSG_ConfirmaAutorizar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DebeMarcarUnoOMasRegistros"
		Default="Debe marcar uno o mÃ¡s registros"
		returnvariable="MSG_DebeMarcarUnoOMasRegistros"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_EstaSeguroQueDeseaAjustarLasHorasDeMarcaSegunLaPlanificada"
		Default="Esta seguro que desea ajustar las horas de marca segÃºn la hora planificada"
		returnvariable="MSG_ConfirmaAjustar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"
		Default="Usted no tiene grupos asociados. No puede acceder este proceso."
		returnvariable="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"/>

	<cfquery name="rsGrupos" datasource="#session.DSN#">
		select  b.Gid, b.Gdescripcion
		from RHCMAutorizadoresGrupo a
			inner join RHCMGrupos b
				on a.Gid = b.Gid
				and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	<cfif rsGrupos.recordcount eq 0>
		<cf_throw message="#MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso#" errorcode="5110">
	<cfelseif rsGrupos.recordcount eq 1>
		<cfparam name="Form.Grupo" default="#rsGrupos.Gid#">
	</cfif>

	<cfset navegacion = ''>
	<cfset arrayEmpleado = ArrayNew(1)>
	<cfset fechaFinal = LSDateFormat(now(),'dd/mm/yyyy')>
	<cfset fechaInicio = ''>
	<cfset vnMaxrows = 50>
	<cfset vnMaxrowsQuery = 1000>

	<cfif isdefined("url.btnFiltrar")>
		<cfset form.btnFiltrar = url.btnFiltrar>
	</cfif>
	<cfif isdefined("form.btnFiltrar")>
		<cfset navegacion = navegacion & '&btnFiltrar'>
	</cfif>
	<cfif isdefined("url.FDEid") and len(trim(url.FDEid)) and not isdefined("form.FDEid")>
		<cfset form.FDEid = url.FDEid>
	</cfif>
	<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "FDEid=" & Form.FDEid>
		<cfset ArrayAppend(arrayEmpleado, form.FDEid)>
	</cfif>
	<cfif isdefined("url.FDEIdentificacion") and len(trim(url.FDEIdentificacion)) and not isdefined("form.FDEIdentificacion")>
		<cfset form.FDEIdentificacion = url.FDEIdentificacion>
	</cfif>
	<cfif isdefined("form.FDEIdentificacion") and len(trim(form.FDEIdentificacion))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "FDEIdentificacion=" & Form.FDEIdentificacion>
		<cfset ArrayAppend(arrayEmpleado, form.FDEIdentificacion)>
	</cfif>
	<cfif isdefined("url.FNombre") and len(trim(url.FNombre)) and not isdefined("form.FNombre")>
		<cfset form.FNombre = url.FNombre>
	</cfif>
	<cfif isdefined("form.FNombre") and len(trim(form.FNombre))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "FNombre=" & Form.FNombre>
		<cfset ArrayAppend(arrayEmpleado, form.FNombre)>
	</cfif>
	<cfif isdefined("url.Grupo") and len(trim(url.Grupo)) and not isdefined("form.Grupo")>
		<cfset form.Grupo = url.Grupo>
	</cfif>
	<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Grupo=" & Form.Grupo>
	</cfif>
	<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
		<cfset form.ver = url.ver>
	</cfif>
	<cfif isdefined("form.ver") and len(trim(form.ver))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "ver=" & Form.ver>
		<cfset vnMaxrows = form.ver>
	</cfif>
	<cfif isdefined("url.Inicio_h") and len(trim(url.Inicio_h)) and not isdefined("form.Inicio_h")>
		<cfset form.Inicio_h = url.Inicio_h>
	</cfif>
	<cfif isdefined("form.Inicio_h") and len(trim(form.Inicio_h))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Inicio_h=" & Form.Inicio_h>
	<cfelse>
		<cfset form.Inicio_h = 12>
	</cfif>
	<cfif isdefined("url.Inicio_m") and len(trim(url.Inicio_m)) and not isdefined("form.Inicio_m")>
		<cfset form.Inicio_m = url.Inicio_m>
	</cfif>
	<cfif isdefined("form.Inicio_m") and len(trim(form.Inicio_m))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Inicio_m=" & Form.Inicio_m>
	</cfif>
	<cfif isdefined("url.Inicio_s") and len(trim(url.Inicio_s)) and not isdefined("form.Inicio_s")>
		<cfset form.Inicio_s = url.Inicio_s>
	</cfif>
	<cfif isdefined("form.Inicio_s") and len(trim(form.Inicio_s))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Inicio_s=" & Form.Inicio_s>
	</cfif>
	<cfif isdefined("url.Fin_h") and len(trim(url.Fin_h)) and not isdefined("form.Fin_h")>
		<cfset form.Fin_h = url.Fin_h>
	</cfif>
	<cfif isdefined("form.Fin_h") and len(trim(form.Fin_h))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Fin_h=" & Form.Fin_h>
	<cfelse>
		<cfset form.Fin_h = 11>
	</cfif>
	<cfif isdefined("url.Fin_m") and len(trim(url.Fin_m)) and not isdefined("form.Fin_h")>
		<cfset form.Fin_m = url.Fin_h>
	</cfif>
	<cfif isdefined("form.Fin_m") and len(trim(form.Fin_m))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Fin_m=" & Form.Fin_m>
	<cfelse>
		<cfset form.Fin_m = 59>
	</cfif>
	<cfif isdefined("url.Fin_s") and len(trim(url.Fin_s)) and not isdefined("form.Fin_s")>
		<cfset form.Fin_s = url.Fin_s>
	</cfif>
	<cfif isdefined("form.Fin_s") and len(trim(form.Fin_s))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Fin_s=" & Form.Fin_s>
	<cfelse>
		<cfset form.Fin_s = 'PM'>
	</cfif>
	<cfif isdefined("url.FTipoMarca") and len(trim(url.FTipoMarca)) and not isdefined("form.FTipoMarca")>
		<cfset form.FTipoMarca = url.FTipoMarca>
	</cfif>
	<cfif isdefined("form.FTipoMarca") and len(trim(form.FTipoMarca))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "FTipoMarca=" & Form.FTipoMarca>
	</cfif>
	<cfif isdefined("url.fechaInicio") and len(trim(url.fechaInicio)) and not isdefined("form.fechaInicio")>
		<cfset form.fechaInicio = url.fechaInicio>
	</cfif>
	<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fechaInicio=" & Form.fechaInicio>
		<cfset fechaInicio = form.fechaInicio>
	</cfif>
	<cfif isdefined("url.fechaFinal") and len(trim(url.fechaFinal)) and not isdefined("form.fechaFinal")>
		<cfset form.fechaFinal = url.fechaFinal>
	</cfif>
	<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fechaFinal=" & Form.fechaFinal>
		<cfset fechaFinal = form.fechaFinal>
	</cfif>
	<cfif isdefined("url.ordenarpor") and len(trim(url.ordenarpor)) and not isdefined("form.ordenarpor")>
		<cfset form.ordenarpor = url.ordenarpor>
	</cfif>
	<cfif isdefined("form.ordenarpor") and len(trim(form.ordenarpor))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "ordenarpor=" & Form.ordenarpor>
	</cfif>
	<cfif isdefined("url.Estado") and len(trim(url.Estado)) and not isdefined("form.Estado")>
		<cfset form.Estado = url.Estado>
	</cfif>
	<cfif isdefined("form.Estado") and len(trim(form.Estado))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Estado=" & Form.Estado>
	</cfif>
	<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
		<cfset form.pagina = url.PageNum_Lista>
	</cfif>
	<cfif isdefined("url.PageNum") and len(trim(url.PageNum))>
		<cfset form.pagina = url.PageNum>
	</cfif>
	<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
		<cfset form.pagina = url.Pagina>
	</cfif>
	<cfparam name="form.pagina" default="1">
	<!---Crear la fecha y hora del filtro---->
	<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
		<!----Hora de entrada--->
		<cfset vn_horainicio = form.Inicio_h>
		<cfif form.Inicio_s eq 'PM' and compare(vn_horainicio,'12') neq 0>
			<cfset vn_horainicio = vn_horainicio + 12 >
		<cfelseif form.Inicio_s eq 'AM' and compare(vn_horainicio,'12') eq 0 >
			<cfset vn_horainicio = 0 >
		</cfif>
		<cfset vd_fechainicio = CreateDateTime(year(LSParseDateTime(form.fechaInicio)), month(LSParseDateTime(form.fechaInicio)), day(LSParseDateTime(form.fechaInicio)), vn_horainicio, form.Inicio_m,00)>
		<cfset fechaInicio = LSDateFormat(vd_fechainicio,'dd/mm/yyyy')>
	</cfif>
	<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
		<cfset vn_horavence = form.Fin_h>
		<cfif form.Fin_s eq 'PM' and compare(vn_horavence,'12') neq 0>
			<cfset vn_horavence = vn_horavence + 12 >
		<cfelseif form.Fin_s eq 'AM' and compare(vn_horavence,'12') eq 0 >
			<cfset vn_horavence = 0 >
		</cfif>
		<cfset vd_fechafin = CreateDateTime(year(LSParseDateTime(form.fechaFinal)), month(LSParseDateTime(form.fechaFinal)), day(LSParseDateTime(form.fechaFinal)), vn_horavence, form.Fin_m,59)>
		<cfset fechaFinal = LSDateFormat(vd_fechafin,'dd/mm/yyyy')>
	</cfif>
	<!--- DAG 11/05/2007: SE ESTANDARIZA PARA DBMSS: ORACLE, MSSQLSERVER, SYBASE --->
	<!--- Date Part de fecha hora marca --->
	<cf_dbfunction name="date_part" args="hh, d.fechahoramarca" returnvariable="Lvar_fechahoramarca_hh">
	<cf_dbfunction name="date_part" args="mi, d.fechahoramarca" returnvariable="Lvar_fechahoramarca_mi">
	<!--- To char del Date Part de fecha hora marca --->
	<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#" returnvariable="Lvar_to_char_fechahoramarca_hh">
	<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#-12" returnvariable="Lvar_to_char_fechahoramarca_hh_m12">
	<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_mi#" returnvariable="Lvar_to_char_fechahoramarca_mi">
	<!--- Date Part de fecha hora plan --->
	<cf_dbfunction name="date_part" args="hh, d.RHCMhoraplan" returnvariable="Lvar_RHCMhoraplan_hh">
	<cf_dbfunction name="date_part" args="mi, d.RHCMhoraplan" returnvariable="Lvar_RHCMhoraplan_mi">
	<!--- To char del Date Part de fecha hora plan --->
	<cf_dbfunction name="to_char" args="#Lvar_RHCMhoraplan_hh#" returnvariable="Lvar_to_char_RHCMhoraplan_hh">
	<cf_dbfunction name="to_char" args="#Lvar_RHCMhoraplan_hh#-12" returnvariable="Lvar_to_char_RHCMhoraplan_hh_m12">
	<cf_dbfunction name="to_char" args="#Lvar_RHCMhoraplan_mi#" returnvariable="Lvar_to_char_RHCMhoraplan_mi">
	<!--- dateaddx abc se usa al final de la consulta --->
	<cf_dbfunction name="dateaddx" args="mi|-(coalesce(d.ttoleranciaantes,0))| d.RHCMhoraplan" returnvariable="Lvar_dataadd_RHCMhoraplan_a" delimiters="|">
	<cf_dbfunction name="dateaddx" args="mi|coalesce(d.ttoleranciadesp,0)| d.RHCMhoraplan" returnvariable="Lvar_dataadd_RHCMhoraplan_b" delimiters="|">
	<cf_dbfunction name="dateaddx" args="ss|59| #Lvar_dataadd_RHCMhoraplan_b#" returnvariable="Lvar_dataadd_RHCMhoraplan_bc" delimiters="|">
	<!--- Consulta estandarizada --->
	<cfquery name="rsLista" datasource="#session.DSN#">
		<cf_dbrowcount1 rows="#vnMaxrowsQuery#">
		select	d.fechahoramarca,
				d.RHCMid,
				d.tipomarca,
				case when d.tipomarca = 'S' or d.tipomarca = 'E' then
					<cf_dbfunction name="to_char" args="d.ttoleranciaantes">
				else
					'&nbsp;'
				end as ttoleranciaantes,
				case when d.tipomarca = 'S' or d.tipomarca = 'E' then
					<cf_dbfunction name="to_char" args="d.ttoleranciadesp">
				else
					'&nbsp;'
				end as ttoleranciadesp,
				case when d.registroaut = 1 then
					d.RHCMid
				else
					0
				end as inactivo,
				{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as Empleado,
				case when d.tipomarca = 'E' or d.tipomarca = 'EB' then
					d.fechahoramarca
				else
					null
				end as Entrada,
				case when d.tipomarca = 'S' or d.tipomarca = 'SB' then
                	d.fechahoramarca
				else
					null
				end as Salida,
				case when d.tipomarca = 'S' or d.tipomarca = 'E' then
                	d.RHCMhoraplan
				else
					null
				end as Planificado,
				case when d.registroaut = 1 then
					'<img src=/cfmx/rh/imagenes/checked.gif>'
				when d.tipomarca = 'EB' or d.tipomarca = 'SB' then
					'<img src=/cfmx/rh/imagenes/TBP_0098.JPG>'
				when d.registroaut = 0 and d.tipomarca = 'E'
					and
					<!--- El query regresa un valor entero si es que existe una salida en el mismo día que entro el
					trabajador --->
					(select COUNT(*) as numRegistros from minisif_adp..RHControlMarcas cm
					where cm.DEid = d.Deid and cm.tipomarca = 'S'
					and (cm.fechahoramarca >= (
						<!--- Retorna la fecha y hora en la que entro el empleado --->
						select rhcm.fechahoramarca from minisif_adp..RHControlMarcas rhcm
						where rhcm.RHCMid = d.RHCMid and rhcm.DEid = d.Deid and rhcm.tipomarca = 'E'
						)
						<!--- Al estar en DateTime para hacer una comparación entre fechas las
						horas, minutos y milisegundos tambien cuentan, por lo tanto dejo esos valores en 0
						y le aumento un día para que quede justo cuando empieza ese día --->
						and cm.fechahoramarca <
						CAST(DATEADD(day, 1,cast((select rhcm.fechahoramarca from minisif_adp..RHControlMarcas rhcm
						where rhcm.RHCMid = d.RHCMid and rhcm.DEid = d.Deid and rhcm.tipomarca = 'E') AS DATE)) AS DATETIME))
						) > 0
					then
					'<img src=/cfmx/rh/imagenes/TBP_0116.JPG>'
				<!--- ***********************esto es el código original**************************************** --->
				<!--- when d.registroaut = 0 and (d.tipomarca = 'E' or d.tipomarca = 'S') --->
				<!--- 	and d.fechahoramarca between (#PreserveSingleQuotes(Lvar_dataadd_RHCMhoraplan_a)#)
											 and (#PreserveSingleQuotes(Lvar_dataadd_RHCMhoraplan_bc)#) then --->
				<!--- else --->
				<!--- ************************Termina el segmento de código original*************************** --->
				when d.registroaut = 0 and d.tipomarca = 'S'
				and
				<!--- Es la misma funcionalidad de compración de fechas, las cuales validan que el usuario entre y salga el mismo
				día --->
					(select COUNT(*) from minisif_adp..RHControlMarcas cm
					where cm.DEid = d.Deid and cm.tipomarca = 'E'
					and (cm.fechahoramarca < CAST(DATEADD(day, 1, cast((select rhcm.fechahoramarca from minisif_adp..RHControlMarcas rhcm
						where rhcm.RHCMid = d.RHCMid and rhcm.DEid = d.Deid and rhcm.tipomarca = 'S') AS DATE)) AS DATETIME)
					and cm.fechahoramarca > CAST(cast((select rhcm.fechahoramarca from minisif_adp..RHControlMarcas rhcm
						where rhcm.RHCMid = d.RHCMid and rhcm.DEid = d.Deid and rhcm.tipomarca = 'S') AS DATE)AS DATETIME))) > 0
				then
				'<img src=/cfmx/rh/imagenes/TBP_0116.JPG>'
				else
				'<img src=/cfmx/rh/imagenes/TBP_0107.JPG>'
				end as status

		from RHCMAutorizadoresGrupo a
			inner join RHCMEmpleadosGrupo b
				inner join DatosEmpleado c

					inner join RHControlMarcas d
						on d.DEid = c.DEid
						and d.numlote is null		<!--- numero de lote --->
						<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>
							and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FDEid#">
						</cfif>
						<cfif isdefined("vd_fechaInicio") and len(trim(vd_fechaInicio)) and isdefined("vd_fechafin") and len(trim(vd_fechafin))>
							<cfif vd_fechaInicio GT vd_fechafin>
								and d.fechahoramarca between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechafin#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechaInicio#">
							<cfelseif vd_fechafin GT vd_fechaInicio>
								and d.fechahoramarca between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechaInicio#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechafin#">
							<cfelse>
								and d.fechahoramarca = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechaInicio#">
							</cfif>
						<cfelseif isdefined("vd_fechaInicio") and len(trim(vd_fechaInicio)) and (not isdefined("vd_fechafin") or  len(trim(vd_fechafin)) EQ 0)>
							and d.fechahoramarca >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechaInicio#">
						<cfelseif isdefined("vd_fechafin") and len(trim(vd_fechafin)) and (not isdefined("vd_fechaInicio") or  len(trim(vd_fechaInicio)) EQ 0)>
							and d.fechahoramarca <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fechafin#">
						</cfif>
						<cfif isdefined("form.Estado") and len(trim(form.Estado)) and form.Estado EQ 1>
							and d.registroaut = 1
						<cfelseif isdefined("form.Estado") and len(trim(form.Estado)) and form.Estado EQ 0>
							and d.registroaut = 0
						</cfif>
						<cfif isdefined("form.FTipoMarca") and len(trim(form.FTipoMarca))>
							and d.tipomarca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FTipoMarca#">
						</cfif>

				on c.DEid = b.DEid
			on a.Gid = b.Gid

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
				and a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">
			<cfelse>
				and a.Gid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsGrupos.Gid)#" list="true">)
			</cfif>
		<cf_dbrowcount2_a rows="#vnMaxrowsQuery#">
		<cfif isdefined("form.ordenarpor") and form.ordenarpor EQ 2>
			order by d.fechahoramarca
		<cfelse>
			order by c.DEapellido1, c.DEapellido2, c.DEnombre, d.fechahoramarca
		</cfif>
		<cf_dbrowcount2_b>
	</cfquery>
</cfsilent>
<!--- <cf_dump var=#rsLista#> --->
<cfoutput>
	<form name="form1" action="RevMarcas-sql.cfm" method="post">
		<input type="hidden" name="tab" value="1">
		<input type="hidden" name="pagina" value="#form.pagina#">
		<table width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<fieldset style="text-indent:inherit">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="12%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:&nbsp;</strong></td>
							<td width="17%">
								<cfif rsGrupos.RecordCount LTE 1>
									<input type="hidden" name="Grupo" value="#rsGrupos.Gid#">
									#rsGrupos.Gdescripcion#
								<cfelse>
									<select name="Grupo" tabindex="1">
										<option value="">--- #LB_Todos# ---</option>
										<cfloop query="rsGrupos">
											<option value="#rsGrupos.Gid#" <cfif isdefined("form.Grupo") and len(trim(form.Grupo)) and form.Grupo EQ rsGrupos.Gid>selected</cfif>>#rsGrupos.Gdescripcion#</option>
										</cfloop>
									</select>
								</cfif>
							</td>
							<td width="15%" align="right" nowrap><strong><cf_translate key="LB_FechaYHoraInicial">Fecha y hora inicial</cf_translate>:&nbsp;</strong></td>
							<td width="15%" nowrap>
								<cf_sifcalendario  tabindex="2" form="form1" name="fechaInicio" value="#fechaInicio#">
							</td>
							<td width="23%">
								<select id="Inicio_h" name="Inicio_h" tabindex="3">
								  <cfloop index="i" from="1" to="12">
									<option value="<cfoutput>#i#</cfoutput>"  <cfif isdefined("form.Inicio_h") and form.Inicio_h EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
								  </cfloop>
								</select> :
								<select id="Inicio_m" name="Inicio_m" tabindex="4">
								  <cfloop index="i" from="0" to="59">
									<option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("form.Inicio_m") and form.Inicio_m EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
								  </cfloop>
								</select>
								<select id="Inicio_s"  name="Inicio_s" tabindex="5">
								  <option value="AM" <cfif isdefined("form.Inicio_s") and form.Inicio_s EQ 'AM'> selected</cfif>>AM</option>
								  <option value="PM" <cfif isdefined("form.Inicio_s") and form.Inicio_s EQ 'PM'> selected</cfif>>PM</option>
								</select>
							</td>
							<td width="18%" valign="top">
								<strong><cf_translate key="LB_SimbologÃ­a">Simbolog&iacute;a</cf_translate></strong>
							</td>
						</tr>
						<tr>
							<td width="12%" align="right" nowrap><strong><cf_translate key="LB_TipoMarca">Tipo marca</cf_translate>:&nbsp;</strong></td>
							<td>
								<select name="FTipoMarca" tabindex="6">
									<option value="">--- #LB_Todos# ---</option>
									<option value="E" <cfif isdefined("form.FTipoMarca") and len(trim(form.FTipoMarca)) and form.FTipoMarca EQ 'E'>selected</cfif>><cf_translate key="LB_Entrada">Entrada</cf_translate></option>
									<option value="S" <cfif isdefined("form.FTipoMarca") and len(trim(form.FTipoMarca)) and form.FTipoMarca EQ 'S'>selected</cfif>><cf_translate key="LB_Salida">Salida</cf_translate></option>
									<option value="SB" <cfif isdefined("form.FTipoMarca") and len(trim(form.FTipoMarca)) and form.FTipoMarca EQ 'SB'>selected</cfif>><cf_translate key="LB_SalidaBreak">Salida Break</cf_translate></option>
									<option value="EB" <cfif isdefined("form.FTipoMarca") and len(trim(form.FTipoMarca)) and form.FTipoMarca EQ 'EB'>selected</cfif>><cf_translate key="LB_EntradaBreak">Entrada Break</cf_translate></option>
								</select>
							</td>
							<td width="15%" align="right" nowrap><strong><cf_translate key="LB_FechaYHoraFinal">Fecha y hora final</cf_translate>:&nbsp;</strong></td>
							<td nowrap>
								<cf_sifcalendario  tabindex="7" form="form1" name="fechaFinal" value="#fechaFinal#">
							</td>
							<td>
								<select id="Fin_h" name="Fin_h" tabindex="8">
								  <cfloop index="i" from="1" to="12">
									<option value="<cfoutput>#i#</cfoutput>"  <cfif isdefined("form.Fin_h") and form.Fin_h EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
								  </cfloop>
								</select> :
								<select id="Fin_m" name="Fin_m" tabindex="9">
								  <cfloop index="i" from="0" to="59">
									<option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("form.Fin_m") and form.Fin_m EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
								  </cfloop>
								</select>
								<select id="Fin_s"  name="Fin_s" tabindex="10">
									<option value="AM" <cfif isdefined("form.Fin_s") and form.Fin_s EQ 'AM'> selected</cfif>>AM</option>
									<option value="PM" <cfif isdefined("form.Fin_s") and form.Fin_s EQ 'PM'> selected</cfif>>PM</option>
								</select>
							</td>
							<td rowspan="2" valign="top">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td><img src="/cfmx/rh/imagenes/TBP_0116.JPG"></td>
										<td><cf_translate key="LB_Consistentes">Consistentes</cf_translate></td>
									</tr>
									<tr>
										<td><img src="/cfmx/rh/imagenes/TBP_0107.JPG"></td>
										<td><cf_translate key="LB_Inconsistentes">Inconsistentes</cf_translate></td>
									</tr>
									<tr>
										<td><img src="/cfmx/rh/imagenes/TBP_0098.JPG"></td>
										<td><cf_translate key="LB_MarcasPorOcio">Marcas por ocio</cf_translate></td>
									</tr>
									<tr>
										<td><img src="/cfmx/rh/imagenes/checked.gif"></td>
										<td><cf_translate key="LB_Autorizadas">Autorizadas</cf_translate></td>
									</tr>
								</table>

							</td>
						</tr>
						<tr>
							<td width="12%" align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
							<td colspan="2">
								<cf_conlis
								   campos="FDEid,FDEidentificacion,FNombre"
								   desplegables="N,S,S"
								   modificables="N,S,N"
								   size="0,20,40"
								   title="#LB_ListaDeEmpleados#"
								   tabla=" RHCMAutorizadoresGrupo a
											inner join RHCMEmpleadosGrupo b
												on a.Gid = b.Gid
												and a.Ecodigo = b.Ecodigo

												inner join DatosEmpleado c
													on b.DEid = c.DEid
													and b.Ecodigo = c.Ecodigo"
								   columnas="b.DEid as FDEid, c.DEidentificacion as FDEidentificacion, {fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as FNombre"
								   filtro="a.Ecodigo = #session.Ecodigo#
											and a.Usucodigo = #session.Usucodigo#"
								   desplegar="FDEidentificacion,FNombre"
								   filtrar_por="c.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)}"
								   filtrar_por_delimiters="|"
								   etiquetas="#LB_Identificacion#,#LB_Empleado#"
								   valuesArray="#arrayEmpleado#"
								   formatos="S,S"
								   align="left,left"
								   asignar="FDEid,FDEidentificacion,FNombre"
								   asignarformatos="S,S,S"
								   showEmptyListMsg="true"
								   EmptyListMsg="-- #LB_NoSeEncontraronRegistros# --"
								   tabindex="11">
							</td>
							<td align="right"><strong><cf_translate key="LB_Estado">Estado</cf_translate>:&nbsp;</strong></td>
							<td>
								<select name="Estado" tabindex="12">
									<option value="">--- #LB_Todos# ---</option>
									<option value="1" <cfif isdefined("form.Estado") and form.Estado EQ 1>selected</cfif>><cf_translate key="LB_Autorizado">Autorizado</cf_translate></option>
									<option value="0" <cfif isdefined("form.Estado") and form.Estado EQ 0>selected</cfif>><cf_translate key="LB_NoAutorizado">No Autorizado</cf_translate></option>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong><cf_translate key="LB_OrdenarPor">Ordenar por</cf_translate>:&nbsp;</strong></td>
							<td colspan="2">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td>
											<input type="radio" name="ordenarpor" value="1" <cfif isdefined("form.ordenarpor") and form.ordenarpor EQ 1>checked<cfelseif not isdefined("form.btnFiltrar")>checked</cfif> tabindex="13"><cf_translate key="LB_EmpleadoFechaHora">Empleado/Fecha/Hora</cf_translate>
											<input type="radio" name="ordenarpor" value="2" <cfif isdefined("form.ordenarpor") and form.ordenarpor EQ 2>checked</cfif> tabindex="14"><cf_translate key="LB_FechaHora">Fecha/Hora</cf_translate>
										</td>
									</tr>
								</table>
							</td>
							<td width="15%" align="right"><strong><cf_translate key="LB_Ver">Ver</cf_translate>:&nbsp;</strong></td>
							<td>
								<input type="text" name="ver" value="<cfif isdefined("form.ver") and len(trim(form.ver))>#form.ver#<cfelse>50</cfif>" size="7">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="6" align="center">
								<input type="submit" name="btnFiltrar" value="#BTN_Filtrar#" onClick="javascript: document.form1.action = ''; ">
								<input type="submit" name="btnAgregar" value="#BTN_Agregar#" onClick="javascript: document.form1.action='RevMarcas-tabs.cfm'; document.form1.submit();">
							</td>
						</tr>
					</table>
					</fieldset>
				</td>
			</tr>
				<tr>
					<td>
						<input type="checkbox" name="chkTodos" value="" onClick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
						<label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
					</td>
				</tr>
				<tr>
					<td align="center">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr><td>
								<cfinvoke
									 component="rh.Componentes.pListas"
									 method="pListaQuery"
									  returnvariable="pListaEmpl">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="Empleado,tipomarca,fechahoramarca,Entrada,Salida,Planificado,ttoleranciaantes,ttoleranciadesp,status"/>
										<cfinvokeargument name="etiquetas" value="#LB_Empleado#,#LB_Marca#,#LB_Fecha#,#LB_Entrada#,#LB_Salida#,#LB_Planificado#,#LB_ToleranciaAntes#,#LB_ToleranciaDespues#,#LB_Status#"/>
										<cfinvokeargument name="formatos" value="V,V,D,H,H,H,V,V,IMG"/>
										<cfinvokeargument name="align" value="left,center,left,left,left,left,left,left,left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="S"/>
										<cfinvokeargument name="irA" value="RevMarcas-tabs.cfm"/>
										<cfinvokeargument name="keys" value="RHCMid"/>
										<cfinvokeargument name="inactivecol" value="inactivo"/>
										<cfinvokeargument name="checkbox_function" value="funcChequea()"/>
										<cfinvokeargument name="maxRows" value="#vnMaxrows#"/>
										<cfinvokeargument name="maxRowsQuery" value="#vnMaxrowsQuery#"/>
										<cfinvokeargument name="incluyeForm" value="false"/>
										<cfinvokeargument name="formName" value="form1"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="showEmptyListMsg" value="yes"/>
								</cfinvoke>
							</td></tr>
						</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<cfif isdefined("rsLista") and rsLista.RecordCount NEQ 0>
					<tr>
						<td align="center">
							<table width="34%" cellpadding="0" cellspacing="0" align="center">
								<tr>
									<td>
										<input type="submit" name="btnAutorizar" value="#BTN_Autorizar#" onClick="javascript: if ( confirm('#MSG_ConfirmaAutorizar#?') ){return funcValidar();}else{return false;}">
										<input type="submit" name="btnAjustar" value="#BTN_Ajustar#" onClick="javascript: if ( confirm('#MSG_ConfirmaAjustar#?') ){return funcValidar();}else{return false;}">
										<input type="submit" name="btnAgregar" value="#BTN_Agregar#" onClick="javascript: document.form1.action='RevMarcas-tabs.cfm';">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</cfif>
		</table>
	</form>
	<script type="text/javascript" language="JavaScript">
		<!--//
			function funcValidar(){
				var result = false;
				if (fnAlgunoMarcadoform1()){
					result = true;
				}else{
					alert("#MSG_DebeMarcarUnoOMasRegistros#!")
				}
				return result;
			}
			function funcChequeaTodos(){
				var c = document.form1.chkTodos;
				if (document.form1.chk) {
					if (document.form1.chk.value) {
						if (!document.form1.chk.disabled) {
							document.form1.chk.checked = c.checked;
						}
					} else {
						for (var counter = 0; counter < document.form1.chk.length; counter++) {
							if (!document.form1.chk[counter].disabled) {
								document.form1.chk[counter].checked = c.checked;
							}
						}
					}
				}
			}
			function funcChequea(){
				var c = document.form1.chkTodos;
				var checked = true;
				if (document.form1.chk) {
					if (document.form1.chk.value) {
						if (!document.form1.chk.disabled) {
							if (!document.form1.chk.checked) {
								checked = false;
							}
						}
					} else {
						for (var counter = 0; counter < document.form1.chk.length; counter++) {
							if (!document.form1.chk[counter].disabled) {
								if (!document.form1.chk[counter].checked) {
									checked = false;
								}
							}
						}
					}
				}
				document.form1.chkTodos.checked = checked;
			}
		//-->
	</script>
</cfoutput>
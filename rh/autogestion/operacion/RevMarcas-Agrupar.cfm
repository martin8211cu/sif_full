<script type="text/javascript" src="/cfmx/rh/js/sinbotones.js"></script>
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Empleado" default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>						
<cfinvoke key="LB_ListaDeEmpleados" default="Lista de Empleados"	 returnvariable="LB_ListaDeEmpleados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoSeEncontraronRegistros" default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificación"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_Todos" default="Todos"	returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_LaCantidadRegistrosVisualizarNoMayorA500" default="La cantidad de registros a visualizar no puede ser mayor a 500"	 returnvariable="MSG_CantidadMayor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar"	 returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Marca" default="Marca"	 returnvariable="LB_Marca" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_Fecha" default="Fecha"	 returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Entrada" default="Entrada"	 returnvariable="LB_Entrada" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Salida" default="Salida"	 returnvariable="LB_Salida" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Planificado" default="Planificado"	 returnvariable="LB_Planificado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Agrupar" default="Agrupar" returnvariable="BTN_Agrupar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Desagrupar" default="Desagrupar"	 returnvariable="BTN_Desagrupar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_EstaSeguroQueDeseaAgruparLasMarcasSeleccionadas" default="Esta seguro que desea agrupar las marcas seleccionadas?"	 returnvariable="MSG_ConfirmaAgrupar" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="MSG_EstaSeguroQueDeseaDesagruparLasMarcasSeleccionadas" default="Esta seguro que desea desagrupar las marcas seleccionadas?"	 returnvariable="MSG_ConfirmaDesagrupar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_EstaSeguroQueDeseaCorrerElProcesoDeAgrupamiento" default="Está Seguro Que Desea Correr El Proceso De Agrupamiento?"	 returnvariable="MSG_EstaSeguroQueDeseaCorrerElProcesoDeAgrupamiento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarLasMarcasDeInicioYFinDelAgrupamiento" default="Debe seleccionar las marcas de inicio y fin del agrupamiento"	 returnvariable="MSG_DebeSeleccionarLasMarcasDeInicioYFinDelAgrupamiento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Proceso_de_Agrupamiento" default="Proceso de Agrupamiento"	 returnvariable="BTN_AgruparAutNew" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso" default="Usted no tiene grupos asociados. No puede acceder este proceso." returnvariable="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->

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
		<cfparam name="Form.FAGrupo" default="#rsGrupos.Gid#">
	</cfif>
	<cfset navegacion = ''>
	<cfset QueryString_lista = ''>
	<cfset FAarrayEmpleado = ArrayNew(1)>
	<cfset fechaFinal = LSDateFormat(now(),'dd/mm/yyyy')>
	<cfset fechaInicio = ''>
	<cfset vnMaxrows = 50>
	<cfset QueryString_lista = QueryString_lista & '&tab=2'>
	<cfif isdefined("url.btnFAFiltrar")>
		<cfset form.btnFAFiltrar = url.btnFAFiltrar>
	</cfif>
	<cfif isdefined("form.btnFAFiltrar")>
		<cfset QueryString_lista = QueryString_lista & '&btnFAFiltrar'>
	</cfif>
	<cfif isdefined("url.FADEid") and len(trim(url.FADEid)) and not isdefined("form.FADEid")>
		<cfset form.FADEid = url.FADEid>	
	</cfif>
	<cfif isdefined("form.FADEid") and len(trim(form.FADEid))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FADEid=" & Form.FADEid>
		<cfset ArrayAppend(FAarrayEmpleado, form.FADEid)>
	</cfif>
	<cfif isdefined("url.FADEIdentificacion") and len(trim(url.FADEIdentificacion)) and not isdefined("form.FADEIdentificacion")>
		<cfset form.FADEIdentificacion = url.FADEIdentificacion>	
	</cfif>
	<cfif isdefined("form.FADEIdentificacion") and len(trim(form.FADEIdentificacion))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FADEIdentificacion=" & Form.FADEIdentificacion>
		<cfset ArrayAppend(FAarrayEmpleado, form.FADEIdentificacion)>
	</cfif>
	<cfif isdefined("url.FANombre") and len(trim(url.FANombre)) and not isdefined("form.FANombre")>
		<cfset form.FANombre = url.FANombre>	
	</cfif>
	<cfif isdefined("form.FANombre") and len(trim(form.FANombre))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FANombre=" & Form.FANombre>
		<cfset ArrayAppend(FAarrayEmpleado, form.FANombre)>
	</cfif>
	<cfif isdefined("url.FAGrupo") and len(trim(url.FAGrupo)) and not isdefined("form.FAGrupo")>
		<cfset form.FAGrupo = url.FAGrupo>	
	</cfif>
	<cfif isdefined("form.FAGrupo") and len(trim(form.FAGrupo))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAGrupo=" & Form.FAGrupo>
	</cfif>
	<cfif isdefined("url.FAver") and len(trim(url.FAver)) and not isdefined("form.FAver")>
		<cfset form.FAver = url.FAver>	
	</cfif>
	<cfif isdefined("form.FAver") and len(trim(form.FAver))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAver=" & Form.FAver>
		<cfset vnMaxrows = form.FAver>
	</cfif>				
	<cfif isdefined("url.Inicio_h") and len(trim(url.Inicio_h)) and not isdefined("form.Inicio_h")>
		<cfset form.Inicio_h = url.Inicio_h>	
	</cfif>
	<cfif isdefined("form.FAInicio_h") and len(trim(form.FAInicio_h))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAInicio_h=" & Form.FAInicio_h>			
	<cfelse>
		<cfset form.FAInicio_h = 12>			
	</cfif>	
	<cfif isdefined("url.FAInicio_m") and len(trim(url.FAInicio_m)) and not isdefined("form.FAInicio_m")>
		<cfset form.FAInicio_m = url.FAInicio_m>	
	</cfif>
	<cfif isdefined("form.FAInicio_m") and len(trim(form.FAInicio_m))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAInicio_m=" & Form.FAInicio_m>
	</cfif>		
	<cfif isdefined("url.FAInicio_s") and len(trim(url.FAInicio_s)) and not isdefined("form.FAInicio_s")>
		<cfset form.FAInicio_s = url.FAInicio_s>	
	</cfif>
	<cfif isdefined("form.FAInicio_s") and len(trim(form.FAInicio_s))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAInicio_s=" & Form.FAInicio_s>
	</cfif>	
	<cfif isdefined("url.FAFin_h") and len(trim(url.FAFin_h)) and not isdefined("form.FAFin_h")>
		<cfset form.FAFin_h = url.FAFin_h>	
	</cfif>
	<cfif isdefined("form.FAFin_h") and len(trim(form.FAFin_h))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAFin_h=" & Form.FAFin_h>
	<cfelse>
		<cfset form.FAFin_h = 11>
	</cfif>
	<cfif isdefined("url.FAFin_m") and len(trim(url.FAFin_m)) and not isdefined("form.FAFin_h")>
		<cfset form.FAFin_m = url.FAFin_h>	
	</cfif>
	<cfif isdefined("form.FAFin_m") and len(trim(form.FAFin_m))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAFin_m=" & Form.FAFin_m>
	<cfelse>
		<cfset form.FAFin_m = 59>
	</cfif>	
	<cfif isdefined("url.FAFin_s") and len(trim(url.FAFin_s)) and not isdefined("form.FAFin_s")>
		<cfset form.FAFin_s = url.FAFin_s>			
	</cfif>
	<cfif isdefined("form.FAFin_s") and len(trim(form.FAFin_s))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAFin_s=" & Form.FAFin_s>
	<cfelse>
		<cfset form.FAFin_s = 'PM'>
	</cfif>
	<cfif isdefined("url.FAfechaInicio") and len(trim(url.FAfechaInicio)) and not isdefined("form.FAfechaInicio")>
		<cfset form.FAfechaInicio = url.FAfechaInicio>	
	</cfif>
	<cfif isdefined("form.FAfechaInicio") and len(trim(form.FAfechaInicio))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAfechaInicio=" & Form.FAfechaInicio>
		<cfset fechaInicio = form.FAfechaInicio>
	</cfif>			
	<cfif isdefined("url.FAfechaFinal") and len(trim(url.FAfechaFinal)) and not isdefined("form.FAfechaFinal")>
		<cfset form.FAfechaFinal = url.FAfechaFinal>	
	</cfif>
	<cfif isdefined("form.FAfechaFinal") and len(trim(form.FAfechaFinal))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAfechaFinal=" & Form.FAfechaFinal>
		<cfset fechaFinal = form.FAfechaFinal>
	</cfif>		
	<cfif isdefined("url.FAEstado") and len(trim(url.FAEstado)) and not isdefined("form.FAEstado")>
		<cfset form.FAEstado = url.FAEstado>	
	</cfif>
	<cfif isdefined("form.FAEstado") and len(trim(form.FAEstado))>
		<cfset QueryString_lista = QueryString_lista & Iif(Len(Trim(QueryString_lista)), DE("&"), DE("")) & "FAEstado=" & Form.FAEstado>
	</cfif>
	<!---Crear la fecha y hora del filtro---->
	<cfif isdefined("form.FAfechaInicio") and len(trim(form.FAfechaInicio))>
		<!----Hora de entrada--->
		<cfset vn_horainicio = form.FAInicio_h>
		<cfif form.FAInicio_s eq 'PM' and compare(vn_horainicio,'12') neq 0>
			<cfset vn_horainicio = vn_horainicio + 12 >
		<cfelseif form.FAInicio_s eq 'AM' and compare(vn_horainicio,'12') eq 0 >
			<cfset vn_horainicio = 0 >
		</cfif>
		<cfset vd_fechainicio = CreateDateTime(year(LSParseDateTime(form.FAfechaInicio)), month(LSParseDateTime(form.FAfechaInicio)), day(LSParseDateTime(form.FAfechaInicio)), vn_horainicio, form.FAInicio_m,00)>
		<cfset fechaInicio = LSDateFormat(vd_fechainicio,'dd/mm/yyyy')>
	</cfif>
	<cfif isdefined("form.FAfechaFinal") and len(trim(form.FAfechaFinal))>
		<cfset vn_horavence = form.FAFin_h>
		<cfif form.FAFin_s eq 'PM' and compare(vn_horavence,'12') neq 0>
			<cfset vn_horavence = vn_horavence + 12 >
		<cfelseif form.FAFin_s eq 'AM' and compare(vn_horavence,'12') eq 0 >
			<cfset vn_horavence = 0 >
		</cfif>
		<cfset vd_fechafin = CreateDateTime(year(LSParseDateTime(form.FAfechaFinal)), month(LSParseDateTime(form.FAfechaFinal)), day(LSParseDateTime(form.FAfechaFinal)), vn_horavence, form.FAFin_m,59)>
		<cfset fechaFinal = LSDateFormat(vd_fechafin,'dd/mm/yyyy')>
	</cfif>
	<cfquery name="rsListaCount" datasource="#session.DSN#">
		select coalesce(count(1),0) as rCount 
			from RHCMAutorizadoresGrupo a
			inner join RHCMEmpleadosGrupo b
				on a.Gid = b.Gid
				and a.Ecodigo = b.Ecodigo
			inner join RHControlMarcas d
				on b.DEid = d.DEid
				and b.Ecodigo = d.Ecodigo
				and d.registroaut = 1															
				and d.numlote is null
			inner join DatosEmpleado c
				on b.DEid = c.DEid
				and b.Ecodigo = c.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and a.Gid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsGrupos.Gid)#" list="true">)
	</cfquery>
	<cfquery name="rsListaPendientesCount" datasource="#session.DSN#">
		select coalesce(count(1),0) as rCount 
			from RHCMAutorizadoresGrupo a
			inner join RHCMEmpleadosGrupo b
				on a.Gid = b.Gid
				and a.Ecodigo = b.Ecodigo
			inner join RHControlMarcas d
				on b.DEid = d.DEid
				and b.Ecodigo = d.Ecodigo
				and d.registroaut = 1															
				and d.grupomarcas is null
				and d.numlote is null
			inner join DatosEmpleado c
				on b.DEid = c.DEid
				and b.Ecodigo = c.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and a.Gid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsGrupos.Gid)#" list="true">)
	</cfquery>
	<!--- DAG 11/05/2007: SE ESTANDARIZA PARA DBMSS: ORACLE, MSSQLSERVER, SYBASE --->
	<!--- Date Part de fecha hora marca --->
	<cf_dbfunction name="date_part" args="hh, d.fechahoramarca" returnvariable="Lvar_fechahoramarca_hh">
	<cf_dbfunction name="date_part" args="mi, d.fechahoramarca" returnvariable="Lvar_fechahoramarca_mi">
	<cf_dbfunction name="date_part" args="ss, d.fechahoramarca" returnvariable="Lvar_fechahoramarca_ss">
	<!--- To char del Date Part de fecha hora marca --->
	<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#" returnvariable="Lvar_to_char_fechahoramarca_hh">
	<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#-12" returnvariable="Lvar_to_char_fechahoramarca_hh_m12">
	<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_mi#" returnvariable="Lvar_to_char_fechahoramarca_mi">
	<!--- Consulta estandarizada --->
	<cfquery name="rsLista" datasource="#session.DSN#">
		select	d.fechahoramarca,
				d.RHCMid,
				d.DEid,
				d.grupomarcas,
				d.tipomarca,
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
				end as Salida
		from RHCMAutorizadoresGrupo a
			inner join RHCMEmpleadosGrupo b
				on a.Gid = b.Gid
				and a.Ecodigo = b.Ecodigo
				
				inner join RHControlMarcas d
					on b.DEid = d.DEid
					and b.Ecodigo = d.Ecodigo
					and d.registroaut = 1															
					and d.numlote is null
					<cfif isdefined("form.FADEid") and len(trim(form.FADEid))>
						and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FADEid#">
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
					<cfif isdefined("form.FAEstado") and len(trim(form.FAEstado)) and form.FAEstado EQ 1>
						and d.grupomarcas is not null
					<cfelseif isdefined("form.FAEstado") and len(trim(form.FAEstado)) and form.FAEstado EQ 0>
						and d.grupomarcas is null
					</cfif>
					
				inner join DatosEmpleado c
					on b.DEid = c.DEid
					and b.Ecodigo = c.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			<cfif isdefined("form.FAGrupo") and len(trim(form.FAGrupo))>
				and a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAGrupo#">
			<cfelse>
				and a.Gid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsGrupos.Gid)#" list="true">)
			</cfif>	
		order by {fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)}, d.fechahoramarca asc , (#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#),(#PreserveSingleQuotes(Lvar_fechahoramarca_mi)#),(#PreserveSingleQuotes(Lvar_fechahoramarca_ss)#)
	</cfquery>
	<form name="form2" action="RevMarcas-Agrupar-sql.cfm" method="post" onsubmit="return sinbotones()">
		<input  type="hidden" name="tab" value="1">
		<input  type="hidden" name="btnAgruparAutNew1" value="0">
		<cfoutput>
		<table width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<fieldset style="text-indent:inherit">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="12%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:&nbsp;</strong></td>
							<td width="20%">
								<cfif rsGrupos.RecordCount LTE 1>
									<input type="hidden" name="FAGrupo" value="#rsGrupos.Gid#">
									#rsGrupos.Gdescripcion#
								<cfelse>
									<select name="FAGrupo" tabindex="1">
										<option value="">--- #LB_Todos# ---</option>
										<cfloop query="rsGrupos">
											<option value="#rsGrupos.Gid#" <cfif isdefined("form.FAGrupo") and len(trim(form.FAGrupo)) and form.FAGrupo EQ rsGrupos.Gid>selected</cfif>>#rsGrupos.Gdescripcion#</option>
										</cfloop>
									</select>
								</cfif>
							</td>
							<td width="14%" align="right" nowrap><strong><cf_translate key="LB_FechaYHoraInicial">Fecha y hora inicial</cf_translate>:&nbsp;</strong></td>
							<td width="15%" nowrap>
								<cf_sifcalendario  tabindex="2" form="form2" name="FAfechaInicio" value="#fechaInicio#">
							</td>
							<td width="23%">
								<select id="FAInicio_h" name="FAInicio_h" tabindex="3">
								  <cfloop index="i" from="1" to="12">
									<option value="<cfoutput>#i#</cfoutput>"  <cfif isdefined("form.FAInicio_h") and form.FAInicio_h EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
								  </cfloop>
								</select> :
								<select id="FAInicio_m" name="FAInicio_m" tabindex="4">
								  <cfloop index="i" from="0" to="59">
									<option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("form.FAInicio_m") and form.FAInicio_m EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
								  </cfloop>
								</select>
								<select id="FAInicio_s"  name="FAInicio_s" tabindex="5">
								  <option value="AM" <cfif isdefined("form.FAInicio_s") and form.FAInicio_s EQ 'AM'> selected</cfif>>AM</option>
								  <option value="PM" <cfif isdefined("form.FAInicio_s") and form.FAInicio_s EQ 'PM'> selected</cfif>>PM</option>
								</select> 
							</td>		
							<td width="16%">
								<cf_botones values="Filtrar">
							</td>								
						</tr>
						<tr>									
							<td align="right"><strong><cf_translate key="LB_Estado">Estado</cf_translate>:&nbsp;</strong></td>
							<td>
								<select name="FAEstado" tabindex="6">
									<option value="">--- #LB_Todos# ---</option>
									<option value="1" <cfif isdefined("form.FAEstado") and form.FAEstado EQ 1>selected</cfif>><cf_translate key="LB_Agrupadas">Agrupadas</cf_translate></option>
									<option value="0" <cfif isdefined("form.FAEstado") and form.FAEstado EQ 0>selected</cfif>><cf_translate key="LB_NoAgrupadas">No Agrupadas</cf_translate></option>
								</select>
							</td>
							<td width="14%" align="right" nowrap><strong><cf_translate key="LB_FechaYHoraFinal">Fecha y hora final</cf_translate>:&nbsp;</strong></td>										
							<td nowrap>
								<cf_sifcalendario  tabindex="7" form="form2" name="FAfechaFinal" value="#fechaFinal#">
							</td>	
							<td>
								<select id="FAFin_h" name="FAFin_h" tabindex="8">
								  <cfloop index="i" from="1" to="12">
									<option value="<cfoutput>#i#</cfoutput>"  <cfif isdefined("form.FAFin_h") and form.FAFin_h EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
								  </cfloop>
								</select> :
								<select id="FAFin_m" name="FAFin_m" tabindex="9">
								  <cfloop index="i" from="0" to="59">
									<option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("form.FAFin_m") and form.FAFin_m EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
								  </cfloop>
								</select>
								<select id="FAFin_s"  name="FAFin_s" tabindex="10">
									<option value="AM" <cfif isdefined("form.FAFin_s") and form.FAFin_s EQ 'AM'> selected</cfif>>AM</option>
									<option value="PM" <cfif isdefined("form.FAFin_s") and form.FAFin_s EQ 'PM'> selected</cfif>>PM</option>
								</select>
							</td>
						</tr>
						<tr>
							<td width="12%" align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
							<td colspan="2">
								<cf_conlis
								   campos="FADEid,FADEidentificacion,FANombre"
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
								   columnas="b.DEid as FADEid, c.DEidentificacion as FADEidentificacion, {fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as FANombre"
								   filtro="a.Ecodigo = #session.Ecodigo#
											and a.Usucodigo = #session.Usucodigo#"
								   desplegar="FADEidentificacion,FANombre"
								   filtrar_por="c.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)}"
								   filtrar_por_delimiters="|"
								   etiquetas="#LB_Identificacion#,#LB_Empleado#"
								   valuesArray="#FAarrayEmpleado#"
								   formatos="S,S"
								   align="left,left"
								   form="form2"
								   asignar="FADEid,FADEidentificacion,FANombre"
								   asignarformatos="S,S,S"
								   showEmptyListMsg="true"
								   EmptyListMsg="-- #LB_NoSeEncontraronRegistros# --"
								   tabindex="11">
							</td>
							<td width="15%" align="right"><strong><cf_translate key="LB_Ver">Ver</cf_translate>:&nbsp;</strong></td>
							<td>
								<input type="text" name="FAver" 
									value="<cfif isdefined("form.FAver") and len(trim(form.FAver))>#form.FAver#<cfelse>50</cfif>" 
									size="7" tabindex="12">
							</td>
						</tr>
					</table>
					</fieldset>
				</td>
			</tr>
		</table>
		</cfoutput>
		<cfif rsListaCount.rcount gt 0>
			<table width="1" align="center">
				<tr>
					<td style="color:#FF0000; font-size:14px; padding-right: 3px; cursor: pointer;"
						nowrap onclick="javascript:funcMarcasSinAgruparRpt();">
						<cfif rsListaPendientesCount.rcount gt 0>
							<strong><cf_translate key="LB_Tiene_Marcas_Pendientes_de_Agrupar">
								Tiene Marcas Pendientes de Agrupar.
							</cf_translate></strong>
						</cfif>
					</td>
				</tr>
			</table>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<input type="checkbox" name="chkAllItems" onclick="javascript: funcFiltroChkAll(this);" 
							<cfif isdefined("form.FATodos") and form.FATodos EQ 1>checked</cfif>>
						<label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
					</td>
				</tr>
			</table>
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<!--- =============================================================================== --->
				<!--- NAVEGACION --->
				<!--- =============================================================================== --->
				<!--- Variables para controlar la cantidad de items a desplegar --->
				<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
				<cfif isdefined("Form.Pagina") and Len(Trim(Form["Pagina"]))>
					<cfset PageNum_lista = Form['Pagina']>
				<cfelseif isdefined("Url.Pagina") and Len(Trim(Url["Pagina"]))>
					<cfset PageNum_lista = Url['Pagina']>
				<cfelseif isdefined("Form.PageNum_lista") and Len(Trim(Form["PageNum_lista"]))>
					<cfset PageNum_lista = Form['PageNum_lista']>
				<cfelseif isdefined("Url.PageNum_lista") and Len(Trim(Url["PageNum_lista"]))>
					<cfset PageNum_lista = Url['PageNum_lista']>
				<cfelseif isdefined("Form.PageNum") and Len(Trim(Form["PageNum"]))>
					<cfset PageNum_lista = Form['PageNum']>
				<cfelseif isdefined("Url.PageNum") and Len(Trim(Url["PageNum"]))>
					<cfset PageNum_lista = Url['PageNum']>
				<cfelse>
					<cfset PageNum_lista = 1>
				</cfif>	
				<!--- si esta navegando y le da filtrar, hace q' empiece en la primera pagina  --->
				<cfset MaxRows_lista = vnMaxrows>
				<cfset StartRow_lista = Min((PageNum_lista-1)*MaxRows_lista+1, Max(rsLista.RecordCount,1)) >
				<cfset EndRow_lista = Min(StartRow_lista+MaxRows_lista-1, rsLista.RecordCount)>
				<cfset TotalPages_lista = Ceiling(rsLista.RecordCount/MaxRows_lista)>											
				<!--- =============================================================================== --->
				<!--- =============================================================================== --->										
				<table width="98%" cellpadding="0" cellspacing="0" align="center">
					<cfoutput>
					<tr>
						<td width="3%">&nbsp;</td>
						<td width="46%"><strong>#LB_Empleado#</strong></td>
						<td width="13%" align="center"><strong>#LB_Marca#</strong></td>
						<td width="16%" align="center"><strong>#LB_Fecha#</strong></td>
						<td width="11%"><strong>#LB_Entrada#</strong></td>
						<td width="11%"><strong>#LB_Salida#</strong></td>
					</tr>
					</cfoutput>
					<cfset cortegrupo = ''>	<!---Cambio de grupo---->																		
					<cfoutput query="rsLista" startrow="#StartRow_lista#" maxrows="#MaxRows_lista#">														
						<cfif len(trim(rsLista.grupomarcas)) and rsLista.grupomarcas NEQ cortegrupo>
							<tr><td colspan="6"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate></strong></td></tr>
						<cfelseif len(trim(rsLista.grupomarcas)) EQ 0>
							<tr><td colspan="6"><strong><cf_translate key="LB_SinAgrupar">Sin agrupar</cf_translate></strong></td></tr>
						</cfif>																																						
						<tr class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td width="3%">
								<input type="checkbox" name="chk" value="#rsLista.DEid#|#rsLista.fechahoramarca#"  
									style="cursor:pointer;" onclick="javascript: funcFiltroChkThis(this);">
							</td>
							<td width="46%">#rsLista.Empleado#</td>
							<td width="13%" align="center">#rsLista.tipomarca#</td>
							<td width="16%" align="center">#LSDateFormat(rsLista.fechahoramarca,'dd/mm/yyyy')#</td>
							<td width="11%"><cfif len(trim(rsLista.Entrada))>#lstimeformat(rsLista.Entrada,'hh:mm tt')#</cfif></td>
							<td width="11%"><cfif len(trim(rsLista.Salida))>#lstimeformat(rsLista.Salida,'hh:mm tt')#</cfif></td>
						</tr>	
						<cfset cortegrupo = rsLista.grupomarcas>												
					</cfoutput>
					<cfoutput>
					<tr> 
						<td colspan="7" align="center" >
							<cfif PageNum_lista GT 1>
							  <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> 
							</cfif>
							<cfif PageNum_lista GT 1>
							  <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> 
							</cfif>
							<cfif PageNum_lista LT TotalPages_lista>
							  <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> 
							</cfif>
							<cfif PageNum_lista LT TotalPages_lista>
							  <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> 
							</cfif> 
						</td>
					</tr>
					</cfoutput>
				</table>																		
			</td></tr>										
			</table>
			<cf_botones values="#BTN_Agrupar#,#BTN_Desagrupar#,#BTN_AgruparAutNew#" names="btnAgrupar,btnDesagrupar,btnAgruparAutNew">
		</cfif>
	</form>
	<cfoutput>
		<script language="javascript" type="text/javascript">
			/*instancia de las pantallas emergentes de generar y modificar 
			se maneja solo una porque no tiene sentido estar modificando un 
			registro y genearando al mismo tiempo.
			*/
			var popUpWindowMSAgrupar=0;
			/*levanta una pantalla emergente con las dimenciones dadas*/
			function funcPopUpWindowMSAgrupar(URLStr, left, top, width, height){
				if(popUpWindowMSAgrupar){
					if(!popUpWindowMSAgrupar.closed) 
						popUpWindowMSAgrupar.close();
				}
				popUpWindowMSAgrupar = open(URLStr, 'popUpWindowMSAgrupar', 'toolbars=no, location=no, directories=no, status=no, menubars=no, scrollbars=yes, resizable=yes, copyhistory=yes, width='+width+', height='+height+', left='+left+', top='+top+', screenX='+left+', screenY='+top);
			}
			/*lavanta una ventana emergente con una pantalla para capturar los parámetros de generacioon*/
			function funcMarcasSinAgruparRpt() {
				funcPopUpWindowMSAgrupar("RevMarcas-AgruparReporte-PopUp.cfm",50,50,800,600);
				return false;
			}
			/*chequea / deschequea todos los check boxes*/
			function funcFiltroChkAll(c){
				if (document.form2.chk) {
					if (document.form2.chk.value) {
						if (!document.form2.chk.disabled) { 
							document.form2.chk.checked = c.checked;
						}
					} else {
						for (var counter = 0; counter < document.form2.chk.length; counter++) {
							if (!document.form2.chk[counter].disabled) {
								document.form2.chk[counter].checked = c.checked;
							}
						}
					}
				}
			}
			/*chequea / deschequea uno de los check boxes*/
			function funcFiltroChkThis(c){
				checked = true;
				if (document.form2.chk) {
					if (document.form2.chk.value) {
						if (!document.form2.chk.disabled) { 
							if (!document.form2.chk.checked) {
								checked = false;
							}									
						}
					} else {
						for (var counter = 0; counter < document.form2.chk.length; counter++) {
							if (!document.form2.chk[counter].disabled) {
								if (!document.form2.chk[counter].checked) {
									checked = false;
								}	
							}
						}
					}
				}
				document.form2.chkAllItems.checked = checked;
			}
			/*verifica si hay algun item marcado*/
			function fnAlgunoMarcado(){
				if (document.form2.chk) {
					if (document.form2.chk.value) {
						return document.form2.chk.checked;
					} else {
						for (var i=0; i<document.form2.chk.length; i++) {
							if (document.form2.chk[i].checked) { 
								return true;
							}
						}
					}
				}
				return false;
			}
			/*funciones de los botones*/
			function funcbtnAgrupar(){
				document.form2.btnAgruparAutNew1.value = 0;
				if (fnAlgunoMarcado()){
					return (confirm('#MSG_ConfirmaAgrupar#'));
				} else {
					alert("#MSG_DebeSeleccionarLasMarcasDeInicioYFinDelAgrupamiento#");
					return false;
				}
			}
			function funcbtnDesagrupar(){
				document.form2.btnAgruparAutNew1.value = 0;
				if (fnAlgunoMarcado()){
					return (confirm('#MSG_ConfirmaDesAgrupar#'));
				} else {
					alert("#MSG_DebeSeleccionarLasMarcasDeInicioYFinDelAgrupamiento#");
					return false;
				}
			}
			function funcbtnAgruparAutNew(){
				document.form2.btnAgruparAutNew1.value = 1;
				return (confirm('#MSG_EstaSeguroQueDeseaCorrerElProcesoDeAgrupamiento#'));
			}
		</script>
	</cfoutput>	
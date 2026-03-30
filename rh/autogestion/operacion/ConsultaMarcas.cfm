<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
	</cf_templatearea>
<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
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
			Key="BTN_Filtrar"
			Default="Filtrar"	
			returnvariable="BTN_Filtrar"/>	
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
			Key="LB_SalidaBreak"
			Default="Salida Break"	
			returnvariable="LB_SalidaBreak"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_EntradaBreak"
			Default="Entrada Break"	
			returnvariable="LB_EntradaBreak"/>	

		<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">			
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<!---Averiguar el DEid del usuario logueado---->
			<cfquery name="rsDEid" datasource="#session.DSN#">
				select llave as DEid
				from UsuarioReferencia
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					and STabla = 'DatosEmpleado'
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">	
			</cfquery>		
			<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
			<cfif rsDEid.RecordCount NEQ 0>
				<!---Datos de empleado---->
				<cfquery name="rsEmpleado" datasource="#Session.DSN#">
					select 	a.DEid, 
							a.DEidentificacion, 
							a.DEnombre, 
							a.DEapellido1, 
							a.DEapellido2,
							n.NTIdescripcion									
					from DatosEmpleado a, NTipoIdentificacion n
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">
						and a.NTIcodigo = n.NTIcodigo									
				</cfquery>
				<cfif isdefined("form.fechahasta") and len(trim(form.fechahasta))>
					<cfset vd_fecha = CreateDateTime(year(LSParseDateTime(form.fechahasta)), month(LSParseDateTime(form.fechahasta)), day(LSParseDateTime(form.fechahasta)), 23, 59,59)>
				</cfif>
				<cfquery name="rsMarcas" datasource="#session.DSN#">
					select case  <cf_dbfunction name="date_part" args="dw,a.fechahoramarca"> 
								when 2 then
									'Lunes'
								when 3 then
									'Martes'
								when 4 then 
									'Miércoles'
								when 5 then 
									'Jueves'
								when 6 then
									'Viernes'
								when 7 then
									'Sábado'
								when 1 then
									'Domingo'	
							end	as Dia,							
							a.fechahoramarca,
							case a.tipomarca 	when 'E' then '#LB_Entrada#'
												when 'S' then '#LB_Salida#'
												when 'EB' then '#LB_EntradaBreak#'
												when 'SB' then '#LB_SalidaBreak#'
							end as tipomarca,
							case a.registroaut 	when 1 then  '<img src=/cfmx/rh/imagenes/checked.gif>'
												else '<img src=/cfmx/rh/imagenes/unchecked.gif>'
							end as autorizado
							
					from RHControlMarcas a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
						and a.numlote is null 
						<cfif isdefined("form.fechahasta") and len(trim(form.fechahasta))>
							and a.fechahoramarca <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">
						</cfif>
					order by a.fechahoramarca asc 
				</cfquery>
			</cfif>
			<cfoutput>
				<table width="100%" cellpadding="0" cellspacing="0">
					<cfif isdefined("rsEmpleado") and rsEmpleado.RecordCount NEQ 0>
						<tr>
							<td><cfinclude template="../../expediente/consultas/frame-infoEmpleado.cfm"></td>
						</tr>
						<tr>
							<td>								
								<form name="form1" action="" method="post">
									<table width="100%" cellpadding="0" cellspacing="0">										
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td width="15%" align="right"><strong><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:&nbsp;</strong></td>
											<td width="15%">
												<cfif isdefined("form.fechahasta") and len(trim(form.fechahasta))>
													<cf_sifcalendario  tabindex="1" form="form1" name="fechahasta" value="#form.fechahasta#">
												<cfelse>
													<cf_sifcalendario  tabindex="1" form="form1" name="fechahasta">
												</cfif>
											</td>
											<td width="70%"><input type="submit" name="btnFiltrar" value="#BTN_Filtrar#"></td>
										</tr>
									</table>
								</form>
							</td>
						</tr>
						<!---Lista ---->						
						<tr>
							<td align="center">
								<table width="91%" cellpadding="4" cellspacing="0" align="center">
									<tr class="tituloListas">
										<td><strong><cf_translate key="LB_Fecha">Fecha</cf_translate></strong></td>
										<td align="center"><strong><cf_translate key="LB_HoraDeLaMarca">Hora de la marca</cf_translate></strong></td>
										<td align="center"><strong><cf_translate key="LB_TipoDeMarca">Tipo de marca</cf_translate></strong></td>
										<td align="center"><strong><cf_translate key="LB_Autorizada">Autorizada</cf_translate></strong></td>
									</tr>
									<cfif rsMarcas.RecordCount NEQ 0>
										<cfloop query="rsMarcas">
											<tr class="<cfif rsMarcas.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
												<td width="34%">
													<cfset vn_mes = Month(rsMarcas.fechahoramarca)>
													<cfset vs_mes = listgetat(meses, vn_mes)>
													<cf_translate key="LB_#rsMarcas.Dia#">#rsMarcas.Dia#</cf_translate>
													#LSDateFormat(rsMarcas.fechahoramarca,'dd')#														
													<cf_translate key="LB_#vs_mes#">#vs_mes#</cf_translate>,
													#LSDateFormat(rsMarcas.fechahoramarca,'yyyy')#
												</td>
												<td width="29%" align="center">
													#LSTimeFormat(rsMarcas.fechahoramarca,'hh:mm tt')#
												</td>
												<td width="37%" align="center">
													#rsMarcas.tipomarca#
												</td>
												<td align="center">
													#rsMarcas.autorizado#
												</td>
											</tr>
										</cfloop>
									<cfelse>
										<tr><td align="center" colspan="4"><strong>----- <cf_translate key="MSG_NoHayMarcasRegistradasSinProcesar">No hay marcas registradas sin procesar</cf_translate>-----</strong></td></tr>
									</cfif>
								</table>
							</td>
						</tr>
					<cfelse>
						<tr>
							<td><strong><cf_translate key="LB_ElUsuarioNoEstaAsignadoComoEmpleadoDeLaEmpresa">El usuario no esta asignado como empleado de la empresa</cf_translate></strong></td>
						</tr>
					</cfif>
					<tr><td>&nbsp;</td></tr>
				</table>
			</cfoutput>
	</cf_templatearea>
</cf_template>

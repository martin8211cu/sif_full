<cfparam name="url.fecha" default="#DateFormat(Now(), 'DD/MM/YYYY')#">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', url.fecha) is 0>
	<cfset fecha = Now()>
<cfelse>
	<cfset fecha = LSParseDateTime(url.fecha)>
</cfif>
<cfparam name="url.filtro_cedula" default="">
<cfparam name="url.filtro_nombre" default="">
<cfparam name="url.filtro_ecodigo" default="#session.Ecodigo#">

<cfset navegacion = '' >
<cfset navegacion = navegacion & '&filtro_cedula=#url.filtro_cedula#' >
<cfset navegacion = navegacion & '&filtro_nombre=#url.filtro_nombre#' >
<cfset navegacion = navegacion & '&filtro_ecodigo=#url.filtro_ecodigo#' >

<cfquery datasource="#session.dsn#" name="empleados">
	select 	de.Ecodigo as empresa,
			e.Edescripcion, 
			de.DEid, 
			de.DEidentificacion as cedula,  
			{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre

	from DatosEmpleado de 
	
	inner join Empresas e 
		on de.Ecodigo = e.Ecodigo
	inner join LineaTiempo lt
		on lt.DEid = de.DEid
		and #fecha#	 between LTdesde and LThasta

	where e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">

	<cfif isdefined("url.filtro_ecodigo") and len(trim(url.filtro_ecodigo))>
		and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_ecodigo#">
	</cfif>

	<cfif Len(Trim(url.filtro_cedula))>
		and upper(de.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_cedula))#%">
	</cfif>	
	<cfif Len(Trim(url.filtro_nombre))>
	  	and upper( {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_nombre))#%">
	</cfif>	

	order by e.Edescripcion, de.DEidentificacion, nombre

</cfquery>

<cfquery name="rs_empresa" datasource="#session.DSN#">
	select Ecodigo, Edescripcion
	from Empresas
	where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by Edescripcion
</cfquery>

<cf_template>
<cf_templatearea name="body">

<cf_web_portlet_start titulo="Mi agenda">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<div class="tituloListas">Programar nueva cita m&eacute;dica</div>
	<br>	
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="2">
				<table width="100%" border="0" cellpadding="1">
					<tr>
						<td ><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Fecha">Fecha</cf_translate>:</strong> <strong><cfoutput>#LSDateFormat(fecha,'DD/MM/YYYY')#</cfoutput></strong></td>
					</tr>
					<tr>
						<td>
							<form name="filtro" id="filtro" action="ProgramarCitaEmp.cfm" method="get">

							<cfoutput>
								<input type="hidden" name="agenda" value="#url.agenda#" />
							<table width="100%" border="0" cellpadding="1" cellspacing="0" class="tituloListas">
								<tr>
									<td><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Empresa">Empresa</cf_translate></strong></td>
									<td><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
									<td><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Nombre">Nombre</cf_translate></strong></td>
									<td rowspan="2" valign="middle" align="center"><input type="submit" name="btnFiltrar" value="Filtrar" class="btnFiltrar" /> </td>
								</tr>
								<tr>
									<td>
										<select name="filtro_ecodigo" id="filtro_ecodigo">
											<option value="0">-Todos-</option>
											<cfloop query="rs_empresa">
												<option value="#rs_empresa.Ecodigo#" <cfif isdefined("url.filtro_ecodigo") and url.filtro_ecodigo eq rs_empresa.Ecodigo>selected</cfif> >#rs_empresa.Edescripcion#</option>
											</cfloop>
										</select>
									</td>
									<td>
										<input type="text" name="filtro_cedula" id="filtro_cedula" size="25" maxlength="60" value="#url.filtro_cedula#" />
									</td>
									<td>
										<input type="text" name="filtro_nombre" id="filtro_nombre" size="50" maxlength="255" value="#url.filtro_nombre#" />
									</td>
								</tr>
							</table>
							</cfoutput>
							</form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<form style="margin:0" action="ProgramarCita.cfm" method="get" name="form1" id="form1" >
					<cfoutput>
					<input type="hidden" name="fecha" value="#LSDateFormat(fecha,'DD/MM/YYYY')#">
					<input type="hidden" name="filtro_cedula" id="filtro_cedula" value="#url.filtro_cedula#" />
					<input type="hidden" name="filtro_nombre" id="filtro_nombre" value="#url.filtro_nombre#" />
					<input type="hidden" name="agenda" id="agenda" value="#url.agenda#" />
					</cfoutput>
	
					<cfinvoke component="rh.Componentes.pListas"
						method="pListaQuery"
						query="#empleados#"
						columnas="cedula,nombre"
						desplegar="cedula,nombre"
						etiquetas="C&eacute;dula,Nombre"
						ajustar="S,S"
						formatos="S,S"
						incluyeForm="false"
						formName="form1"
						align="left,left"
						form_method="get"
						irA="ProgramarCita.cfm"
						mostrar_filtro="no"
						cortes='Edescripcion'
						navegacion="#navegacion#" >
				</form>
			</td>
			<td valign="top" align="center"><cf_calendario value="#fecha#" onChange="location.href='?filtro_cedula=#URLEncodedFormat(url.filtro_cedula)#&filtro_nombre=#URLEncodedFormat(url.filtro_nombre)#&fecha='+escape(dmy)" ></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>
<cf_web_portlet_end>

</cf_templatearea>
</cf_template>
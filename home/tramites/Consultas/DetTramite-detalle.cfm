<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Activos Fijos
	</cf_templatearea>
	<cf_templatearea name="body">

<cf_templatecss>

</head>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de detalle de un Tr&aacute;mite'>

<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	select id_inst, nombre_inst, codigo_inst
	from TPInstitucion
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
</cfquery>

<cfquery name="rsSuc" datasource="#session.tramites.dsn#">
	select nombre_sucursal, codigo_sucursal
	from TPSucursal
	where id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_sucursal#">
</cfquery>

<cfquery name="rsVen" datasource="#session.tramites.dsn#">
	select nombre_ventanilla, codigo_ventanilla
	from TPVentanilla
	where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_ventanilla#">
</cfquery>


<cfinclude template="../../menu/pNavegacion.cfm">

<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<tr style="background-color:#ededed">
		<td colspan="4" style="border-bottom:1px solid black">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr style="background-color:#ededed">
					<td rowspan="2"><cfoutput><img src="/cfmx/home/tramites/public/logo_inst.cfm?id_inst=#rsInstitucion.id_inst#" width="146" height="59"></cfoutput></td>
				  	<td style="font-size:16px">&nbsp;</td>
				  	<td colspan="3" style="font-size:16px"><strong><cfoutput>#rsInstitucion.nombre_inst#</cfoutput></strong></td>
					<cfoutput><td align="right"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='/cfmx/home/tramites/Consultas/detalle_tramite.cfm?id_tramite=#url.id_tramite#&listado=#url.listado#&fechai=#url.fecha_inicio#&fechaf=#url.fecha_fin#'"></td></cfoutput>
				</tr>
				
				<tr style="background-color:#ededed">
					<td style="font-size:14px">&nbsp;</td>
				  	
					<cfif isdefined("url.id_tramite") and url.id_tramite eq 0>
						<td colspan="4" ><strong><font size="3">Consulta de un Tr&aacute;mite&nbsp;</font></strong></td>
					<cfelse>
						<cfquery name="tramite" datasource="#session.tramites.dsn#">
							select codigo_tramite, nombre_tramite
							from TPTramite
							where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
						</cfquery>
						<cfoutput>
							<td colspan="4" align="left" ><font size="3"><strong>Tr&aacute;mite: #tramite.codigo_tramite# - #tramite.nombre_tramite#</strong></font></td>
						</cfoutput>
					</cfif>
				</tr>
			</table>
		</td>
	</tr>

		<cfset f1 = LSParsedateTime(url.fecha_inicio)>
		<cfset f2 = LSParsedateTime(url.fecha_fin)>

		<cfquery name="lista" datasource="#session.tramites.dsn#">
			select p.identificacion_persona, p.nombre, p.apellido1, p.apellido2, it.fecha_inicio	
			
			from TPInstanciaTramite it
			
			inner join TPVentanilla v
			on v.id_ventanilla=it.id_ventanilla
			and v.id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_ventanilla#">
			
			inner join TPSucursal s
			on s.id_sucursal=v.id_sucursal
			 and s.id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_sucursal#">
			
			inner join TPInstitucion i
			on i.id_inst = s.id_inst

			inner join TPPersona p
			on p.id_persona = it.id_persona
			
			where it.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
			  and it.fecha_inicio between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f2#">
			  and it.completo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.listado#">
			
			order by  p.identificacion_persona, p.nombre, p.apellido1, p.apellido2 

		</cfquery>
	
		<cfif lista.recordcount gt 0>
		<cfoutput>
		<tr><td colspan="2"><strong><font size="2">Sucursal: #trim(rsSuc.codigo_sucursal)# - #rsSuc.nombre_sucursal#</font></strong></td></tr>
		<tr><td colspan="2"><strong><font size="2">Ventanilla: #trim(rsVen.codigo_ventanilla)# - #rsVen.nombre_ventanilla#</font></strong></td></tr>
		</cfoutput>
		<tr>
			<td colspan="2">
				<table width="100%" cellpadding="3" cellspacing="0">
					<tr class="tituloListas">
						<td><strong>Identificaci&oacute;n</strong></td>
						<td><strong>Nombre</strong></td>
						<td align="center"><strong>Fecha de Inicio</strong></td>
					</tr>
					<cfoutput query="lista">
						<tr  class="<cfif lista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td >#lista.identificacion_persona#</td>
							<td style="padding-left:15px;">#lista.nombre# #lista.apellido1# #lista.apellido2#</td>
							<td align="center">#LSDateFormat(lista.fecha_inicio,'dd/mm/yyyy')#</td>
						</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="center">--- Fin del Reporte ---</td>
		</tr>

		<cfelse>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr><td colspan="2" align="center"><strong>-- No se encontraron registros --</strong></td></tr>	
		</cfif>

</table>

<script type="text/javascript">
<!--
	function funcCerrar(){
		//alert('En Construcción');
		document.form1.submit();
	}

	function limpiar(){
		document.filtro.Listado.value = '';
		document.filtro.fechai.value = '';
		document.filtro.fechaf.value = '';
		document.filtro.id_tramite.value = '';
	}

	function imprimir() {
		window.print()	
	}	
	
	function validar(f){
		if (f.id_tramite.value == ''){
			alert('Debe seleccionar un trámite')
			return false
		}
		return true;
	}
	
//-->
</script>
<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>




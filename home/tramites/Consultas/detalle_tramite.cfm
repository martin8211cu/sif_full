<cfif isdefined("url.fechai") and not isdefined("form.fechai")>
	<cfset form.fechai = url.fechai >
</cfif>
<cfif isdefined("url.fechaf") and not isdefined("form.fechaf")>
	<cfset form.fechaf = url.fechaf >
</cfif>
<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
	<cfset form.id_tramite = url.id_tramite >
	<cfset form.filtrar = '' >
</cfif>
<cfif isdefined("url.listado") and not isdefined("form.listado")>
	<cfset form.listado = url.listado >
</cfif>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Activos Fijos
	</cf_templatearea>
	<cf_templatearea name="body">

<cf_templatecss>

</head>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de un Tr&aacute;mite'>
<cfinclude template="../../menu/pNavegacion.cfm">
<!--- fechas --->
<cfset fecha_inicio = createdate(1900,01,01)>
<cfset fecha_fin = createdate(6100,01,01)>
<cfif isdefined("form.fechai") and len(trim(form.fechai))>
	<cfset fecha_inicio = LSParsedateTime(form.fechai) >
</cfif>
<cfif isdefined("form.fechaf") and len(trim(form.fechaf))>
	<cfset fecha_fin = LSParsedateTime(form.fechaf) >
</cfif>
<cfif DateCompare(fecha_inicio, fecha_fin) eq 1>
	<cfset tmp = fecha_inicio >
	<cfset fecha_inicio = fecha_fin>
	<cfset fecha_fin = tmp>
</cfif>

<cfparam name="form.id_tramite" default="0">
<cfparam name="form.Listado" default="0">
<cfparam name="session.tramites.id_inst" default="0">

<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	select id_inst, nombre_inst, codigo_inst
	from TPInstitucion
	<cfif Len(session.tramites.id_inst)>
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
	</cfif>
</cfquery>

<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<tr style="background-color:#ededed">
		<td colspan="4" style="border-bottom:1px solid black">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr style="background-color:#ededed">
					<td rowspan="2"><cfoutput><img src="/cfmx/home/tramites/public/logo_inst.cfm?id_inst=#rsInstitucion.id_inst#" width="146" height="59"></cfoutput></td>
				  	<td style="font-size:16px">&nbsp;</td>
				  	<td colspan="4" style="font-size:16px"><strong><cfoutput>#rsInstitucion.nombre_inst#</cfoutput></strong></td>
				</tr>
				
				<tr style="background-color:#ededed">
					<td style="font-size:14px">&nbsp;</td>
				  	
					<cfif isdefined("form.id_tramite") and form.id_tramite eq 0>
						<td colspan="4" ><strong><font size="3">Consulta de un Tr&aacute;mite&nbsp;</font></strong></td>
					<cfelse>
						<cfquery name="tramite" datasource="#session.tramites.dsn#">
							select codigo_tramite, nombre_tramite
							from TPTramite
							where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
						</cfquery>
						<cfoutput>
							<td colspan="4" align="left" ><font size="3"><strong>Tr&aacute;mite: #tramite.codigo_tramite# - #tramite.nombre_tramite#</strong></font></td>
						</cfoutput>
					</cfif>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td colspan="4">
			<form name="filtro" method="post" style="margin:0; " onSubmit="return validar(this);">
			<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td ><strong>Tr&aacute;mite&nbsp;</strong></td>
					<td ><strong>Estado&nbsp;</strong></td>
					<td  nowrap><strong>Fecha Inicial&nbsp;</strong></td>
					<td nowrap><strong>Fecha Final&nbsp;</strong></td>
				</tr>

				<tr>
					<td >
						<cfoutput>
							<cfquery name="combotramite" datasource="#session.tramites.dsn#">
								select t.id_tramite, t.codigo_tramite, t.nombre_tramite,
									i.id_inst, i.nombre_inst
								from TPTramite t
									join TPInstitucion i
										on t.id_inst = i.id_inst
								order by i.nombre_inst, i.id_inst, t.codigo_tramite, t.id_tipotramite
							</cfquery>

							<select name="id_tramite" >
								<option value="" >- seleccionar -</option>
								<cfset c_inst="">
								<cfloop query="combotramite">
									<cfif (c_inst neq id_inst) or CurrentRow EQ 1>
										<cfif CurrentRow NEQ 1>
											</optgroup>
										</cfif>
										<cfset c_inst = id_inst>
										<optgroup label="#HTMLEditFormat(nombre_inst)#">
									</cfif>
									<option value="#id_tramite#" <cfif isdefined("form.id_tramite") and form.id_tramite eq combotramite.id_tramite>selected</cfif> > #trim(HTMLEditFormat(codigo_tramite))# - #HTMLEditFormat(nombre_tramite)# </option>
								</cfloop>
							</select>
				 		</td>

					<td>
						<select name="Listado" >
							<option value="0" <cfif isdefined("form.Listado") and len(trim(form.Listado)) and form.Listado EQ 0>selected</cfif>>Pendientes</option>
							<option value="1" <cfif isdefined("form.Listado") and len(trim(form.Listado)) and form.Listado EQ 1>selected</cfif>>Cerrados</option>
						</select>
					</td>
					
					<cfparam name="form.fechai" default="#LSDateFormat(dateadd('d',-7,now()),'dd/mm/yyyy')#" >
					<td><cf_sifcalendario name="fechai" value="#form.fechai#" form="filtro"></td>

					<cfparam name="form.fechaf" default="#LSDateFormat(now(),'dd/mm/yyyy')#">
					<td><cf_sifcalendario name="fechaf" value="#form.fechaf#" form="filtro"></td>

						<td align="right"><input type="submit" name="Filtrar" value="Filtrar"></td>
						<td align="left"><input type="button" name="Limpiar" value="Limpiar" onClick="javascript:limpiar();"></td>
						<td style="width:10% " align="center">
							<a href="javascript:imprimir();" id="imp"><img src="/cfmx/home/tramites/images/impresora.gif" border="0" alt="Imprimir"></a>
						</td>
					</cfoutput>
				</tr>
			</table>

			</form>
		</td>
	</tr>

	<cfif isdefined("form.Filtrar")>
		<cfquery name="lista" datasource="#session.tramites.dsn#">
			select 	it.id_tramite,
					v.id_ventanilla, 
					v.codigo_ventanilla, 
					v.nombre_ventanilla, 
					s.codigo_sucursal, 
					s.id_sucursal, 
					s.nombre_sucursal, 
					s.id_inst, 
					i.nombre_inst,
					count(1) as total
			
			from TPInstanciaTramite it
			
			inner join TPVentanilla v
			on v.id_ventanilla=it.id_ventanilla
			
			inner join TPSucursal s
			on s.id_sucursal=v.id_sucursal
			
			inner join TPInstitucion i
			on i.id_inst = s.id_inst
			
			where it.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
			  and it.fecha_inicio between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_inicio#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_fin#">
			  and it.completo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.listado#">
			
			group by it.id_tramite, v.id_ventanilla, v.codigo_ventanilla, v.nombre_ventanilla, s.codigo_sucursal, s.id_sucursal, s.nombre_sucursal, s.id_inst, i.nombre_inst
			
			order by i.nombre_inst, s.nombre_sucursal, v.nombre_ventanilla

		</cfquery>
	
		<cfif lista.recordcount gt 0>
		<tr>
			<td colspan="2">
				<table width="100%" cellpadding="3" cellspacing="0">
					<tr class="tituloListas">
						<td><strong>Sucursal</strong></td>
						<td><strong>Ventanilla</strong></td>
						<td align="center"><strong>Cantidad de Tr&aacute;mites</strong></td>
					</tr>
					<cfset vtotal = 0 >
					<cfoutput query="lista" group="nombre_inst">
						<cfset i = 0 >
						<tr><td class="tituloCorte" colspan="6">#lista.nombre_inst#</td></tr>
						
						<cfoutput>
							<tr style="cursor:pointer;" onClick="javascript:location.href='/cfmx/home/tramites/Consultas/DetTramite-detalle.cfm?id_tramite=#lista.id_tramite#&listado=#form.listado#&id_sucursal=#lista.id_sucursal#&id_ventanilla=#lista.id_ventanilla#&fecha_inicio=#LSDateFormat(fecha_inicio,'dd/mm/yyyy')#&fecha_fin=#LSDateFormat(fecha_fin,'dd/mm/yyyy')#'" class="<cfif i mod 2>listaPar<cfelse>listaNon</cfif>">
								<td style="padding-left:15px;">#trim(lista.codigo_sucursal)# - #lista.nombre_sucursal#</td>
								<td style="padding-left:15px;">#trim(lista.codigo_ventanilla)# - #lista.nombre_ventanilla#</td>
								<td align="center">#lista.total#</td>
							</tr>
							<cfset i = i+1 >
							<cfset vtotal = vtotal + lista.total >
						</cfoutput>
					</cfoutput>
					<cfoutput>
					<tr style="border-top:1px solid gray ">
						<td style="border-top:1px solid gray "><strong><font size="2">Total</font></strong></td>
						<td style="border-top:1px solid gray ">&nbsp;</td>
						<td align="center" style="border-top:1px solid gray "><strong><font size="2">#vtotal#</font></strong></td>
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




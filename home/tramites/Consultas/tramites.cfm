<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Lista de Tr&aacute;mites por Cerrar</title>
<cf_templatecss>
</head>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<body style="margin:0">

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

<cfparam name="form.Listado" default="0">
<cfparam name="session.tramites.id_inst" default="0">

<cfquery name="lista" datasource="#session.tramites.dsn#">
	select 	a.id_tramite,
			a.id_instancia,
			p.id_persona,
			p.identificacion_persona as cedula,
			substring((rtrim(p.nombre) || ' ' || rtrim(p.apellido1) || ' '  || rtrim(p.apellido2)),1,35) as nombre,
			rtrim(t.nombre_tramite) as tramite,
			a.fecha_inicio as fecha,
			a.id_instancia,
			p2.nombre || ' ' || p2.apellido1 || ' '  || p2.apellido2 as funcionario,
			v.id_sucursal,
			s.nombre_sucursal,
			v.nombre_ventanilla,
			a.id_instancia
		
	from TPInstanciaTramite a
	
	inner join TPPersona p
	  on a.id_persona = p.id_persona
		<cfif isdefined("form.id_persona") and len(trim(form.id_persona))>
			and a.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
		</cfif>
	
	inner join TPTramite t
	  on a.id_tramite = t.id_tramite
	  and t.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
		<cfif isdefined("form.id_tipotramite") and len(trim(form.id_tipotramite))>
		    and t.id_tipotramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipotramite#">	
		</cfif>
	
	inner join TPInstitucion i
	on i.id_inst=t.id_inst
	
	inner join TPFuncionario f
	on f.id_funcionario = a.id_funcionario
	
	inner join TPPersona p2
	on p2.id_persona=f.id_persona
	
	inner join TPRFuncionarioVentanilla fv
	on fv.id_ventanilla=a.id_ventanilla
	and fv.id_funcionario=a.id_funcionario
	
	inner join TPVentanilla v
	on v.id_ventanilla=fv.id_ventanilla
	<cfif isdefined("form.id_sucursal") and len(trim(form.id_sucursal))>
		and v.id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">	
	</cfif>
	
	inner join TPSucursal s
	on s.id_sucursal=v.id_sucursal
	
	where a.completo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.listado#">
	  and a.fecha_inicio between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_inicio#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_fin#">

	order by tramite, fecha desc, nombre
</cfquery>

<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	select id_inst, nombre_inst, codigo_inst
	from TPInstitucion
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
</cfquery>

<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<tr style="background-color:#ededed">
		<td colspan="4" style="border-bottom:1px solid black">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr style="background-color:#ededed">
					<td rowspan="2"><cfoutput><img src="/cfmx/home/tramites/public/logo_inst.cfm?id_inst=#rsInstitucion.id_inst#" width="146" height="59"></cfoutput></td>
				  	<td style="font-size:16px">&nbsp;</td>
				  	<td colspan="4" style="font-size:16px"><cfoutput>#rsInstitucion.nombre_inst#</cfoutput></td>
				</tr>
				
				<tr style="background-color:#ededed">
					<td style="font-size:14px">&nbsp;</td>
				  	<td colspan="4" style="font-size:14px"><strong>Consulta de Tr&aacute;mites&nbsp;</strong></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td colspan="4">
			<form name="filtro" method="post" style="margin:0; ">
			<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td align="right"><strong>Estado:&nbsp;</strong></td>
					<td>
						<select name="Listado" >
							<option value="0" <cfif isdefined("form.Listado") and len(trim(form.Listado)) and form.Listado EQ 0>selected</cfif>>Pendientes</option>
							<option value="1" <cfif isdefined("form.Listado") and len(trim(form.Listado)) and form.Listado EQ 1>selected</cfif>>Cerrados</option>
						</select>
					</td>
					
					<cfquery name="tipo" datasource="#session.tramites.dsn#">
						select id_tipotramite, nombre_tipotramite  
						from TPTipoTramite
						order by 2
					</cfquery>					
					<td align="right" nowrap><strong>Tipo de Tr&aacute;mite:&nbsp;</strong></td>
					<td> 
						<select name="id_tipotramite" >
							<option value="">-todos-</option>
							<cfoutput query="tipo">
								<option value="#id_tipotramite#" <cfif isdefined("form.id_tipotramite") and form.id_tipotramite EQ tipo.id_tipotramite>selected</cfif>>#tipo.nombre_tipotramite#</option>
							</cfoutput>
						</select>
					</td>
					
					<cfquery name="sucursal" datasource="#session.tramites.dsn#">
						select id_sucursal, nombre_sucursal 
						from TPSucursal s
						where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
						order by 2
					</cfquery>					
					<td align="right" nowrap><strong>Sucursal:&nbsp;</strong></td>
					<td>
						<select name="id_sucursal" >
							<option value="">-todos-</option>
							<cfoutput query="sucursal">
								<option value="#sucursal.id_sucursal#" <cfif isdefined("form.id_sucursal") and form.id_sucursal EQ sucursal.id_sucursal>selected</cfif>>#sucursal.nombre_sucursal#</option>
							</cfoutput>
						</select>
					</td>
					
					<cfparam name="form.fechai" default="#LSDateFormat(dateadd('d',-7,now()),'dd/mm/yyyy')#" >
					<td align="right" nowrap><strong>Fecha Inicial:&nbsp;</strong></td>
					<td><cf_sifcalendario name="fechai" value="#form.fechai#" form="filtro"></td>
					<cfparam name="form.fechaf" default="#LSDateFormat(now(),'dd/mm/yyyy')#">
					<td align="right" nowrap><strong>Fecha Final:&nbsp;</strong></td>
					<td><cf_sifcalendario name="fechaf" value="#form.fechaf#" form="filtro"></td>

					<td style="width:10% " align="center">
						<a href="javascript:imprimir();" id="imp">
							<img src="/cfmx/home/tramites/images/impresora.gif" border="0" alt="Imprimir">
						</a>
					</td>
				</tr>

				<cfset formulario = 'filtro' >
				<cfparam name="form.id_persona" default="0">
				<cfif isdefined("form.id_persona") and len(trim(form.id_persona)) eq 0>
					<cfset form.id_persona = 0 >
				</cfif>
<!---<cfset inicio = now() >--->
				<cfquery name="persona" datasource="#session.tramites.dsn#">
					select id_persona, identificacion_persona, nombre || ' ' || apellido1 || ' ' || apellido2 as nombre_persona
					from TPPersona
					where id_persona=#0+form.id_persona#
					
				</cfquery>
<!---
<cfset fin = now() >
<cfoutput>#inicio#</cfoutput><br>
<cfoutput>#fin#</cfoutput><br>
<cfoutput>#datediff('s',inicio, fin)# segundos</cfoutput>
--->

				<tr>
					<td><strong>Persona:&nbsp;</strong></td>
					<td colspan="5" ><cfinclude template="../vistas/filtro_persona.cfm"></td>
					<td align="right"><input type="submit" name="Filtrar" value="Filtrar"></td>
					<td align="left"><input type="button" name="Limpiar" value="Limpiar" onClick="javascript:limpiar();"></td>
				</tr>

			</table>

			</form>
		</td>
	</tr>


	<tr>
		<td colspan="2">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr class="tituloListas">
					<td><strong>No. Tr&aacute;mite</strong></td>
					<td><strong>Persona</strong></td>
					<td nowrap><strong>Fecha de Inicio</strong></td>
					<td><strong>Funcionario</strong></td>
					<td><strong>Sucursal</strong></td>
					<td><strong>Ventanilla</strong></td>
				</tr>
				<cfoutput query="lista" group="tramite">
					<cfset i = 0 >
					<tr><td class="tituloCorte" colspan="6">#lista.tramite#</td></tr>
					
					<cfoutput>
						<tr style="cursor:pointer;" onClick="javascript:location.href='/cfmx/home/tramites/Consultas/tramite-detalle.cfm?id_tramite=#lista.id_tramite#&id_persona=#lista.id_persona#&id_instancia=#lista.id_instancia#'" class="<cfif i mod 2>listaPar<cfelse>listaNon</cfif>">
							<td>#lista.id_instancia#</td>
							<td>#lista.nombre#</td>
							<td>#LSDateFormat(lista.fecha,'dd/mm/yyyy')#</td>
							<td>#lista.Funcionario#</td>
							<td>#lista.nombre_sucursal#</td>
							<td>#lista.nombre_ventanilla#</td>
						</tr>
						<cfset i = i+1 >
					</cfoutput>
				</cfoutput>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" align="center">--- Fin del Reporte ---</td>
	</tr>
</table>

<script type="text/javascript">
<!--
	function funcCerrar(){
		//alert('En Construcción');
		document.form1.submit();
	}

	function limpiar(){
		document.filtro.Listado.value = '';
		document.filtro.id_tipotramite.value = '';
		document.filtro.id_sucursal.value = '';
		document.filtro.fechai.value = '';
		document.filtro.fechaf.value = '';
		document.filtro.id_persona.value = '';
		document.filtro.identificacion_persona.value = '';
		document.filtro.nombre_persona.value = '';
	}

	function imprimir() {
		window.print()	
	}	
	
//-->
</script>

</body>
</html>




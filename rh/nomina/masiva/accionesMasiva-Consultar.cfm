<!--- Variables por URL --->
<cfif isdefined("url.RHEAMid") and len(trim(url.RHEAMid))><cfset form.RHEAMid = url.RHEAMid></cfif>
<cfif isdefined("url.RHAid") and len(trim(url.RHAid))><cfset form.RHAid = url.RHAid></cfif>

<!--- Consulta de la Empleados de Acción Masiva --->
<cfquery name="rsEmpleadosAccionMasiva" datasource="#Session.DSN#">
	select 	a.RHEAMid,
			a.DEid, 
			b.DEidentificacion,
			{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) } as DEnombre,
			a.RHAid, 
			c.RHAdescripcion, 
			a.RHCPlinea,
			l.RHMPPdescripcion, 
			a.Ecodigo, 
			d.Edescripcion,
			a.RHAfhasta, 
			a.RHAfdesde,
			a.RHAporcsal, 
			a.Dcodigo, 
			rtrim(e.Deptocodigo) as Deptocodigo,
			rtrim(e.Ddescripcion) as Ddescripcion, 
			ltrim(rtrim(f.RHPcodigo)) as RHPcodigo,
			coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))) as RHPcodigoext, 
			rtrim(f.RHPdescpuesto) as RHPdescpuesto, 
			a.RHAporc, 
			a.Ocodigo, 
			rtrim(g.Oficodigo) as Oficodigo,
			rtrim(g.Odescripcion) as Odescripcion,
			a.RVid, 
			h.Descripcion,
			a.Tcodigo, 
			rtrim(i.Tdescripcion) as Tdescripcion, 
			a.RHEAMreconocido, 
			a.RHEAMjustificacion, 
			a.RHEAMusuarior,
			{fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})} as Usuario,
			a.RHEAMfecha, 
			a.RHEAMrevaluado, 
			a.RHEAMevaluacion, 
			a.RHEAMfuevaluacion, 
			a.BMUsucodigo
	from RHEmpleadosAccionMasiva a
		inner join DatosEmpleado b
			on a.DEid = b.DEid
		inner join RHAccionesMasiva c
			on a.RHAid = c.RHAid
		inner join Empresas d
			on d.Ecodigo = a.Ecodigo
		left outer join Departamentos e
			on a.Dcodigo = e.Dcodigo
			and a.Ecodigo = e.Ecodigo
		left outer join RHPuestos f
			on a.RHPcodigo = f.RHPcodigo
			and a.Ecodigo = f.Ecodigo
		left outer join Oficinas g
			on a.Ocodigo = g.Ocodigo
			and a.Ecodigo = g.Ecodigo
		left outer join RegimenVacaciones h
			on a.RVid = h.RVid
			and a.Ecodigo = h.Ecodigo
		left outer join TiposNomina i
			on a.Tcodigo = i.Tcodigo
			and a.Ecodigo = i.Ecodigo
		left outer join RHCategoriasPuesto j
			on a.RHCPlinea = j.RHCPlinea
			and a.Ecodigo = j.Ecodigo
		left outer join RHCategoria k
			on k.RHCid = j.RHCid
			and k.Ecodigo = j.Ecodigo
		left outer join RHMaestroPuestoP l
			on l.RHMPPid = j.RHMPPid
			and l.Ecodigo = j.Ecodigo
		inner join Usuario u
			on a.RHEAMusuarior = u.Usucodigo
		inner join DatosPersonales dp
			on u.datos_personales = dp.datos_personales
	where a.RHEAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEAMid#">
		and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
	
<!----================= TRADUCCION =====================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Cerrar"
	Default="Cerrar"
	returnvariable="BTN_Cerrar"/>

<cfoutput>
<form name="form1" style="margin: 0;" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid gray;">
			  <tr>
				<td class="#Session.Preferences.Skin#_thcenter" align="center">
					<cf_translate key="LB_Situacion_Propuesta">Situaci&oacute;n Propuesta</cf_translate>
				</td>
			  </tr>
			  <tr>
				<td>
					<cf_rhaccionesmasivas query="#rsEmpleadosAccionMasiva#">
				</td>
			  </tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center"><input type="button" name="Cerrar" value="#BTN_Cerrar#" onClick="javascrip: return cerrar()"></td>
	</tr>
</table>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function cerrar() {
		window.close();
	}
</script>

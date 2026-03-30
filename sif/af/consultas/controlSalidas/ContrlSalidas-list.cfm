<!--- <cf_dump var="#form#"> --->
<cf_dbfunction name="OP_concat" returnvariable="_Cat" maxrows="3001">
<cfset params="?tab=1">
<cfif isdefined("url.AFMid") and Len(Trim(url.AFMid))>
	<cfset params= params & "&AFMid=#url.AFMid#">
</cfif>
<cfif isdefined("url.AFMMid") and Len(Trim(url.AFMMid))>
	<cfset params= params & "&AFMMid=#url.AFMMid#">
</cfif>
<cfif isdefined("url.Aplaca") and Len(Trim(url.Aplaca))>
	<cfset params= params & "&Aplaca=#url.Aplaca#">
</cfif>
<cfif isdefined("url.Aserie") and Len(Trim(url.Aserie))>
	<cfset params= params & "&Aserie=#url.Aserie#">
</cfif>

<cf_templateheader title="Control de Salidas y Entradas por Placas">
	<cf_web_portlet_start titulo="Control de Salidas y Entradas por Placas">

<cfquery name="rsActivos" datasource="#Session.DSN#">
	select a.Aid,a.Aplaca, a.Adescripcion, a.Aserie, uMov.Fecha,
		m.AFMdescripcion,mm.AFMMdescripcion,
		case uMov.TipoMovimiento
				when 4 then 'Comodato Devuelto'
				when 3 then 'Fuera por Comodato'
				when 2 then 'Fuera'
				when 1 then 'Devuelto'
				else 'Sin salidas'
		end Status
	from Activos a
	left join AFMarcas m
		on m.AFMid = a.AFMid
	left join AFMModelos mm
		on mm.AFMMid = a.AFMMid
	left join (
		select b.Aid, e.TipoMovimiento, e.Fecha
		from AFEntradaSalidaE e
		inner join (select Aid, max(AFESid) AFESid
					from AFBitacoraES
					group by Aid) b
			on e.AFESid = b.AFESid
	) uMov
		on uMov.Aid = a.Aid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("url.Aid") and Len(Trim(url.Aid))>
	and a.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Aid#">
	<cfelse>
	<cfif isdefined("url.AFMid") and Len(Trim(url.AFMid))>
		and a.AFMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#AFMid#">
	</cfif>
	<cfif isdefined("url.AFMMid") and Len(Trim(url.AFMMid))>
		and a.AFMMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#AFMMid#">
	</cfif>
	<cfif isdefined("url.Aplaca") and Len(Trim(url.Aplaca))>
		and upper(a.Aplaca) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Trim(url.Aplaca))#%">
	</cfif>
	<cfif isdefined("url.Aserie") and Len(Trim(url.Aserie))>
		and upper(a.Aserie) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.Aserie))#%">
	</cfif>
	order by a.Aplaca
</cfif>
</cfquery>

<cfoutput>

<cfif isdefined("url.Aid") and Len(Trim(url.Aid))>

	<cfquery name="rsActivo" datasource="#Session.DSN#">
		select distinct e.AFESid,e.TipoMovimiento, e.Fecha, e.FechaRegreso, e.Autoriza,
			ds.AFDdescripcion, ms.AFMSdescripcion,
			case e.TipoMovimiento
					when 4 then 'Comodato Devuelto'
					when 3 then 'Fuera por Comodato'
					when 2 then 'Salida'
					when 1 then 'Entrada'
					else 'Sin salidas'
			end Status
		from AFEntradaSalidaE e
		inner join AFBitacoraES b
			on e.AFESid = b.AFESid
		inner join Activos a
			on a.Aid = b.Aid
		left join AFMotivosSalida ms
			on e.AFMSid = ms.AFMSid
		left join AFDestinosSalida ds
			on e.AFDSid = ds.AFDSid
		where a.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Aid#">
		order by Fecha
	</cfquery>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="right"><strong>Placa:&nbsp;</strong></td>
			<td align="left">#rsActivos.Aplaca#</td>
		</tr>
		<tr>
			<td align="right"><strong>Estatus:&nbsp;</strong></td>
			<td align="left">#rsActivos.Status#</td>
		</tr>
		<tr>
			<td align="right"><strong>Descripción:&nbsp;</strong></td>
			<td align="left">#rsActivos.Adescripcion#</td>
		</tr>
		<tr>
			<td align="right"><strong>Marca:&nbsp;</strong></td>
			<td align="left">#rsActivos.AFMdescripcion#</td>
		</tr>
		<tr>
			<td align="right"><strong>Modelo:&nbsp;</strong></td>
			<td align="left">#rsActivos.AFMMdescripcion#</td>
		</tr>
		<tr>
			<td align="right"><strong>Serie:&nbsp;</strong></td>
			<td align="left">#rsActivos.Aserie#</td>
		</tr>
		<tr>
			<td colspan="2">
				<form name="filtro2" action="ContrlSalidas-list.cfm#params#" method="post">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr class="tituloListas"><td colspan="4">&nbsp;</td></tr>

						<tr>
							<td valign="top" colspan="3">
								<cfinvoke
											component="sif.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaQuery"
											query="#rsActivo#"
											columnas="AFESid,Fecha,FechaRegreso,AFDdescripcion,Autoriza,AFMSdescripcion,Status"
											desplegar="Fecha,FechaRegreso,AFDdescripcion,Autoriza,AFMSdescripcion,Status"
											etiquetas="Feha,FechaRegreso,Destino,Autoriza,Descripción,Movimiento"
											formatos="D,D,S,S,S,S"
											align="left,left,left,left,left,center"
											checkboxes= "N"
											ira="ContrlSalidas-list.cfm#params#"
											nuevo="ContrlSalidas-list.cfm"
											incluyeform="false"
											formname="filtro21"
											keys="AFESid"
											mostrar_filtro="false"
											botones="Regresar"
											maxrows="15"
											navegacion="ContrlSalidas-list.cfm"
									/>

							</td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
	</table>
<cfelse>

<form name="filtro2" action="ContrlSalidas.cfm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr class="tituloListas"><td colspan="4">&nbsp;</td></tr>

	<tr>
		<td valign="top" colspan="3">
			<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaQuery"
						query="#rsActivos#"
						columnas="Aid,Aplaca,Adescripcion,Aserie,Fecha,Status"
						desplegar="Aplaca,Adescripcion,Aserie,Fecha,Status"
						etiquetas="Placa,Descripción,Numero Serie,Fecha,Estatus"
						formatos="S,S,S,D,S"
						align="left,left,left,left,center"
						checkboxes= "N"
						ira="ContrlSalidas-list.cfm#params#"
						nuevo="ContrlSalidas-list.cfm"
						incluyeform="false"
						formname="filtro2"
						keys="Aid"
						mostrar_filtro="false"
						botones="Regresar"
						maxrows="15"
						navegacion="ContrlSalidas-list.cfm"
				/>

		</td>
	</tr>
</table>
</form>
</cfif>

<cfoutput>
	<script language="javascript" type="text/javascript">
		function funcRegresar(){
			<!--- <cfif isdefined("form.Aid")>
				document.filtro2.action="ContrlSalidas-list.cfm";
			<cfelse>
				document.filtro2.action="ContrlSalidas-list.cfm";
			</cfif>
			document.filtro2.submit(); --->
		}
	</script>
</cfoutput>

</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>



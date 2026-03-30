<cf_templatecss>

<cf_rhimprime datos="/sif/iv/operacion/inventarioFisico-reportefs.cfm" paramsuri="&EFid=#url.EFid#&Aid=#url.Aid#" >

<cfquery name="rsIF" datasource="#session.DSN#">
	select EFdescripcion, EFfecha
	from EFisico
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  and EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EFid#">
</cfquery>

<cfquery name="rsAlmacen" datasource="#session.DSN#">
	select Almcodigo, Bdescripcion
	from Almacen
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#">
</cfquery>

<cfsavecontent variable="myQuery">
	<cfoutput>
	select d.Ccodigoclas,
		d.Cdescripcion,	
		  c.Eestante,
		  c.Ecasilla,	
		b.Acodigo, 
		b.Adescripcion,
		a.DFactual, 
		a.DFcantidad, 
		a.DFdiferencia, 
		a.DFcostoactual, 
		a.DFtotal
	
	from DFisico a
	
	inner join Articulos b
	on b.Aid=a.Aid
	
	inner join Existencias c
	on c.Aid=a.Aid
	and c.Alm_Aid = #url.Aid#
	
	inner join Clasificaciones d
	on d.Ecodigo=b.Ecodigo
	and d.Ccodigo=b.Ccodigo
	
	where a.EFid = #url.EFid#
	and a.Ecodigo = #session.Ecodigo#
	and a.DFdiferencia <> 0 
	
	order by d.Ccodigoclas, d.Cdescripcion
	</cfoutput>
</cfsavecontent>

<cf_sifHTML2Word>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<cfoutput>
	<tr >
		<td align="center" ><strong><font size="4">#session.Enombre#</font></strong></td>
	</tr>
	<tr >
		<td align="center" ><strong><font size="3">Consulta de Faltantes y Sobrantes</font></strong></td>
	</tr>
	<tr >
		<td align="center" ><strong><font size="3">Inventario F&iacute;sico:</strong> #trim(rsIF.EFdescripcion)#</td>
	</tr>
	<tr >
		<td align="center" ><strong>Almac&aacute;n:</strong> #trim(rsAlmacen.Almcodigo)# - #trim(rsAlmacen.Bdescripcion)#</td>
	</tr>
	<tr >
		<td align="center" ><strong>Fecha:</strong> #LSDateFormat(rsIF.EFfecha, 'dd/mm/yyyy')#</td>
	</tr>
</table>	
	</cfoutput>
<cfset registros = 0 >

<table width="98%" align="center" border="0" cellpadding="0" cellspacing="0">
<cftry>
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
	
		<cfoutput query="data" group="Ccodigoclas">
			<cfset registros = registros + 1 >
			
			<cfif registros gt 1 >
			<tr><td>&nbsp;</td></tr>
			</cfif>

			<tr bgcolor="##c0c0c0">
				<td ><strong>Clasificaci&oacute;n</strong></td>
				<td colspan="8" style="padding:4px;" ><strong>#Ccodigoclas# - #Cdescripcion#</strong></td>
			</tr>
			
			<tr >
				<td class="tituloListas" ><strong>Estante</strong></td>
				<td class="tituloListas" ><strong>Casilla</strong></td>
				<td class="tituloListas"><strong>C&oacute;digo</strong></td>
				<td class="tituloListas"><strong>Descripci&oacute;n</strong></td>
				<td class="tituloListas" align="right"><strong>Sistema</strong></td>
				<td class="tituloListas" align="right"><strong>Conteo</strong></td>
				<td class="tituloListas" align="right"><strong>Diferencia</strong></td>
				<td class="tituloListas" align="right"><strong>Costo</strong></td>
				<td class="tituloListas" align="right"><strong>Costo Total</strong></td>
			</tr>
			
			<cfoutput>
			<tr>
				<td nowrap="nowrap"><cfif len(trim(Eestante))>#Eestante#&nbsp;<cfelse>&nbsp;</cfif></td>
				<td ><cfif len(trim(Ecasilla))>#Ecasilla#&nbsp;<cfelse>&nbsp;</cfif></td>
				<td nowrap="nowrap">#Acodigo#&nbsp;</td>
				<td nowrap="nowrap">#Adescripcion#</td>
				<td nowrap="nowrap" align="right">#LSNumberFormat(DFactual, ',9.00')#</td>
				<td nowrap="nowrap" align="right">#LSNumberFormat(DFcantidad, ',9.00')#</td>
				<td nowrap="nowrap" align="right">#LSNumberFormat(DFdiferencia, ',9.00')#</td>
				<td nowrap="nowrap" align="right">#LSNumberFormat(DFcostoactual, ',9.00')#</td>
				<td nowrap="nowrap" align="right">#LSNumberFormat(DFtotal, ',9.00')#</td>
			</tr>
			</cfoutput>
		</cfoutput>
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>


<tr><td colspan="9" align="center">--- Fin del Reporte---</td></tr>

</table>
</cf_sifHTML2Word>


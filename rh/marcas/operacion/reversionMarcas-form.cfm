<!---
	Procesamiento del Filtro
 --->
<cfif isdefined("url.FDEid") and len(trim(url.FDEid))>
	<cfset form.FDEid = url.FDEid>
</cfif>
<cfif isdefined("url.FDesde") and len(trim(url.FDesde))>
	<cfset form.FDesde = url.FDesde>
</cfif>
<cfif isdefined("url.FHasta") and len(trim(url.FHasta))>
	<cfset form.FHasta = url.FHasta>
</cfif>
<cfoutput><table align="center" width="98%" cellpadding="0" cellspacing="0" border="0" id="tblFiltro" class="AreaFiltro">
	<tr>
		<td>
			<strong>#LB_Empleado#</strong>
		</td>
		<td>
			<strong>#LB_Fecha_Desde#</strong>
		</td>
		<td>
			<strong>#LB_Fecha_Hasta#</strong>
		</td>
		<!--- <td>&nbsp;</td> --->
	</tr>
	<tr>
		<td>
			<cfif isdefined("Form.FDEid")>
				<cf_rhempleado DEid="FDEid" idempleado="#Form.FDEid#">
			<cfelse>
				<cf_rhempleado DEid="FDEid" >
			</cfif>
		</td>
		<td>
			<cfif isdefined("Form.FDesde")>
				<cf_sifcalendario name="FDesde" value="#Form.FDesde#">
			<cfelse>
				<cf_sifcalendario name="FDesde">
			</cfif>
		</td>
		<td>
			<cfif isdefined("Form.FHasta")>
				<cf_sifcalendario name="FHasta" value="#Form.FHasta#">
			<cfelse>
				<cf_sifcalendario name="FHasta">
			</cfif>
		</td>
		<!--- <td>
			<cf_botones values="Filtrar">
		</td> --->
	</tr>
</table></cfoutput>

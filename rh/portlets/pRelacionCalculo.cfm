<cfset Lvar_Regresar = "">
<cfif isdefined("request.regresar")>
	<cfset Lvar_Regresar = request.regresar>
</cfif>

<cfif isDefined("Url.RCNid") and not isDefined("Form.RCNid")>
	<cfset Form.RCNid = Url.RCNid>
</cfif>

<!--- Consulta Relación de Cálculo --->
<cfquery name="rsRelacionCalculo" datasource="#Session.DSN#">
	select 	a.RCNid, 
		   	rtrim(a.Tcodigo) as Tcodigo, 
		   	a.RCDescripcion, 
		   	a.RCdesde, 
		  	a.RChasta,
		   (case a.RCestado 
				when 0 then 'Proceso'
				when 1 then 'Cálculo'
				when 2 then 'Terminado'
				when 3 then 'Pagado'
				else ''
		   end) as RCestado,
		   a.Usucodigo, 
		   a.Ulocalizacion, 
		   a.ts_rversion,
		   b.Tdescripcion,
		   b.Mcodigo,
		   c.CPcodigo,
			case when c.CPtipo = 0 then 'Normal'
			when c.CPtipo = 2 then 'Anticipo'
			when c.CPtipo = 3 then 'Retroactivo' end as TipoCalendario,
			c.CPnodeducciones
	from RCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.Ecodigo = b.Ecodigo
	and a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
</cfquery>
<!--- Pasa algunos valores de la consulta al Form para poder utilizarlos posteriormente --->
<cfif rsRelacionCalculo.RecordCount gt 0>
	<cfset Form.RCTcodigo = rsRelacionCalculo.Tcodigo>
	<cfset Form.RCdesde = LSDateFormat(rsRelacionCalculo.RCdesde,'dd/mm/yyyy')>
	<cfset Form.RChasta = LSDateFormat(rsRelacionCalculo.RChasta,'dd/mm/yyyy')>
	<cfset Form.RCestado = rsRelacionCalculo.RCestado>
	<cfset Form.RCMcodigo = rsRelacionCalculo.Mcodigo>
</cfif>

<!--- Pinta Info de Relación de Cálculo --->
<cfoutput>
	
  <table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
   	  <!--- <cfset location2 = "/cfmx/rh/nomina/consultas/PConsultaRCalculo.cfm?Tcodigo=#Form.RCTcodigo#&fecha=#Form.RCdesde#&RCNid=#Form.RCNid#"> --->
      <tr valign="bottom">
        <td align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n:</cf_translate></strong>&nbsp;</td>
        <td colspan ="3" nowrap>#rsRelacionCalculo.RCDescripcion#</td> 
        <td width="14%" align="right" nowrap class="fileLabel">&nbsp;</td>
	    <td width="14%" align="right" valign="middle" nowrap >	
		    <cfif isDefined("request.regresar") and len(trim(request.regresar)) GT 0>
				<cfset locationR = "/cfmx/rh/nomina/operacion/#request.regresar#?RCNid=#Form.RCNid#">
				<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
				<cfif Not Find(CurrentPage,locationR)>
				<a href="##" onClick="javascript:document.location='#locationR#';"><img class="noprint" src="/cfmx/rh/imagenes/back.png" border="0" style="cursor:pointer" class="noprint" title="Regresar"></a><a href="##" onClick="javascript:document.location='#locationR#';"><cf_translate key="LB_Regresar">Regresar</cf_translate></a>
				</cfif>
			</cfif>
			<cfif isDefined("pintarReporte") and pintarReporte eq true>
				<cfset location1 = "/cfmx/rh/indexReportes.cfm?Tcodigo=#Form.RCTcodigo#&fecha=#Form.RCdesde#&RCNid=#Form.RCNid#">
				<cfif isdefined("Lvar_Regresar") and len(trim(Lvar_Regresar)) GT 0>
					<cfset location1 = location1 & "&Regresar=" & Lvar_Regresar>
				</cfif>
				<a href="##" onClick="javascript:document.location='#location1#';"><img src="/cfmx/rh/imagenes/printer3.gif" border="" align="middle"></a><a href="##" onClick="javascript:document.location='#location1#';"><cf_translate key="LB_Reportes">Reportes</cf_translate></a>
			</cfif>
		</td>
      </tr>
    <tr> 
      <td width="21%" align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_Tipo_de_Nomina">Tipo de N&oacute;mina:</strong></cf_translate>&nbsp;
      </td>
      <td width="22%" nowrap> #rsRelacionCalculo.Tdescripcion# </td>
      <td width="9%" align="right" nowrap class="fileLabel">&nbsp;</td>
      <td width="9%" nowrap>&nbsp;</td>
      <td align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_Fecha_desde">Fecha Desde:</cf_translate></strong>&nbsp;</td>
      <td nowrap> #LSDateFormat(rsRelacionCalculo.RCdesde,'dd/mm/yyyy')# </td>
    </tr>
    <tr> 
      <td align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_Codigo_del_Calendario_de_Pago">C&oacute;digo del Calendario de Pago:</cf_translate></strong>&nbsp;</td>
	  <cfset pagina = GetFileFromPath(GetTemplatePath()) >
      <td nowrap><cfif trim(pagina) eq 'ResultadoCalculo-lista.cfm' ><table><tr><td><a href="javascript:funcDeducciones();">#rsRelacionCalculo.CPcodigo#</a></td><td><a href="javascript:funcDeducciones();"><img border="0" src="/cfmx/rh/imagenes/Documentos2.gif"></a></td></tr></table><cfelse>#rsRelacionCalculo.CPcodigo#</cfif></td>
      <td align="right" nowrap class="fileLabel">&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_Fecha_Hasta">Fecha Hasta:</cf_translate></strong>&nbsp;</td>
      <td nowrap> #LSDateFormat(rsRelacionCalculo.RChasta,'dd/mm/yyyy')# </td>
    </tr>
	<tr> 
		<td align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_TipodeCalendarioDePago">Tipo de Calendario de Pago:</cf_translate></strong>&nbsp;</td>
		<td nowrap colspan="3">#rsRelacionCalculo.TipoCalendario#</td>
		<td align="right" nowrap class="fileLabel">&nbsp;</td>
		<td nowrap>&nbsp;</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
  </table>
</cfoutput>
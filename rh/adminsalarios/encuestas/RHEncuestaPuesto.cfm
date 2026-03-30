<!---
<cfparam name="EEid">

<cfdump var="#url#">

<cfif isdefined("form.EEid") and len(trim(form.EEid))>
	<cfset EEid = form.EEid>
</cfif>
----->
<cfif isdefined("url.EEid") and len(trim(url.EEid))>
	<cfset form.EEid = url.EEid>
</cfif>

<cfquery datasource="sifpublica" name="hdr">
	select EEid,EEnombre,Ppais
	from EncuestaEmpresa
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" >
</cfquery>
<cf_template>
<cf_templatearea name="title">
	Asignación de códigos de puesto
</cf_templatearea>
<cf_templatearea name="body">

<cf_web_portlet_start titulo="Configurar Encuestadora">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfset filtro = "">
<cfif isdefined("form.EPcodigo") and len(trim(form.EPcodigo))>
	<cfset filtro = filtro & " and upper(ep.EPcodigo) like '%" & UCase(Form.EPcodigo) & "%'">
</cfif>
<cfif isdefined("form.EPdescripcion") and len(trim(form.EPdescripcion))>
	<cfset filtro = filtro & " and upper(ep.EPdescripcion) like '%" & Ucase(form.EPdescripcion) & "%'">
</cfif>
<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
	<cfset filtro = filtro & " and upper(rep.RHPcodigo) like '%" & UCase(Form.RHPcodigo) & "%'">
</cfif>
<cfif isdefined("form.RHPdescripcion") and len(trim(form.RHPdescripcion))>
	<cfset filtro = filtro & " and upper(p.RHPdescpuesto) like '%" & Ucase(form.RHPdescripcion) & "%'">
</cfif>

<table width="100%" border="0" cellspacing="0">  
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td colspan="2" style=" font-size:13px" align="center"><cfoutput><strong>Configurando puestos para <a href="RHEncuestadoraEdit.cfm?EEid=#HTMLEditFormat(EEid)#">#hdr.EEnombre#</a></strong> </cfoutput></td>
  </tr>
  <!---<tr><td>&nbsp;</td></tr>--->
  <tr>
    <td valign="top" width="50%">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top" width="50%">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>									
							<form name="formFiltro" method="post" action="RHEncuestaPuesto.cfm">										
								<cfoutput>					
									<input type="hidden" name="EEid" value="<cfif isdefined("form.EEid") and len(trim(form.EEid))>#form.EEid#</cfif>">
									<tr class="areaFiltro">
										<td align="right" nowrap><strong>C&oacute;d. Puesto:</strong></td>
										<td>
											<input type="text" name="RHPcodigo" size="6" maxlength="10" value="<cfif isdefined('form.RHPcodigo') and Len(trim(form.RHPcodigo))>#trim(form.RHPcodigo)#</cfif>" onfocus="this.select();" >
										</td>
										<td align="right"><strong>Descripci&oacute;n:</strong></td>
										<td>
											<input type="text" name="RHPdescripcion" size="40" maxlength="80" value="<cfif isdefined('form.RHPdescripcion') and Len(trim(form.RHPdescripcion))>#trim(form.RHPdescripcion)#</cfif>" onfocus="this.select();">
										</td>
										<td rowspan="2" valign="middle" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
									</tr>											
									<tr class="areaFiltro">
										<td align="right" nowrap><strong>C&oacute;d. Externo:</strong></td>
										<td>
											<input type="text" name="EPcodigo" size="6" maxlength="10" value="<cfif isdefined('form.EPcodigo') and Len(trim(form.EPcodigo))>#trim(form.EPcodigo)#</cfif>" onfocus="this.select();" >
										</td>
										<td align="right"><strong>Descripci&oacute;n:</strong></td>
										<td>
											<input type="text" name="EPdescripcion" size="40" maxlength="80" value="<cfif isdefined('form.EPdescripcion') and Len(trim(form.EPdescripcion))>#trim(form.EPdescripcion)#</cfif>" onfocus="this.select();">
										</td>
									</tr>																			
								</cfoutput>
							</form>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top" width="50%">
					<cfquery datasource="#session.dsn#" name="lista">
						select rep.RHPcodigo, p.RHPdescpuesto, ep.EPcodigo, ep.EPdescripcion, #EEid# as EEid
						from RHEncuestaPuesto rep
							join RHPuestos p
								on  p.Ecodigo = rep.Ecodigo
								and p.RHPcodigo = rep.RHPcodigo
							join EncuestaPuesto ep
								on  rep.EEid = ep.EEid
								and rep.EPid = ep.EPid
						where rep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and rep.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#">
						  #preservesinglequotes(filtro)#
					</cfquery>
			
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="RHPcodigo,RHPdescpuesto,EPcodigo,EPdescripcion"
						etiquetas=" ,Puesto, ,Puesto externo"
						formatos="S,S,S,S"
						align="left,left,left,left"
						ira="RHEncuestaPuesto.cfm"
						form_method="get"
						showEmptyListMsg="true"
						keys="RHPcodigo,EEid"
					/>		
				</td>
			</tr>
		</table>
	</td>
    <td valign="top">
		<cfinclude template="RHEncuestaPuesto-form.cfm">
	</td>
  </tr>
</table>

<cf_web_portlet_end>

</cf_templatearea>
</cf_template>



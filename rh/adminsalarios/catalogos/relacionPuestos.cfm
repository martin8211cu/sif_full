<cfset navegacionRelPuestos = "tab=5&EEid=#form.EEid#">
<cfoutput>
	<cfif isdefined("url.RHPcodigo_F") and not isdefined('form.RHPcodigo_F')>
		<cfparam name="form.RHPcodigo_F" default="#url.RHPcodigo_F#">
	</cfif>
	<cfif isdefined("url.EPcodigo_F") and not isdefined('form.EPcodigo_F')>
		<cfparam name="form.EPcodigo_F" default="#url.EPcodigo_F#">
	</cfif>	
	<cfif isdefined("url.RHPdescripcion_F") and not isdefined('form.RHPdescripcion_F')>
		<cfparam name="form.RHPdescripcion_F" default="#url.RHPdescripcion_F#">
	</cfif>	
	<cfif isdefined("url.EPdescripcion_F") and not isdefined('form.EPdescripcion_F')>
		<cfparam name="form.EPdescripcion_F" default="#url.EPdescripcion_F#">
	</cfif>	
</cfoutput>

<cfif isdefined("form.RHPcodigo_F") and len(trim(form.RHPcodigo_F))>
	<cfset navegacionRelPuestos = navegacionRelPuestos & Iif(Len(Trim(navegacionRelPuestos)) NEQ 0, DE("&"), DE("")) & "RHPcodigo_F=" & Form.RHPcodigo_F>
</cfif>
<cfif isdefined("form.EPcodigo_F") and len(trim(form.EPcodigo_F))>
	<cfset navegacionRelPuestos = navegacionRelPuestos & Iif(Len(Trim(navegacionRelPuestos)) NEQ 0, DE("&"), DE("")) & "EPcodigo_F=" & Form.EPcodigo_F>
</cfif>
<cfif isdefined("form.RHPdescripcion_F") and len(trim(form.RHPdescripcion_F))>
	<cfset navegacionRelPuestos = navegacionRelPuestos & Iif(Len(Trim(navegacionRelPuestos)) NEQ 0, DE("&"), DE("")) & "RHPdescripcion_F=" & Form.RHPdescripcion_F>
</cfif>
<cfif isdefined("form.EPdescripcion_F") and len(trim(form.EPdescripcion_F))>
	<cfset navegacionRelPuestos = navegacionRelPuestos & Iif(Len(Trim(navegacionRelPuestos)) NEQ 0, DE("&"), DE("")) & "EPdescripcion_F=" & Form.EPdescripcion_F>
</cfif>

<table width="100%" border="0" cellspacing="0">  
  <tr>
    <td valign="top" width="50%">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top" width="50%">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>									
							<form name="formFiltro" method="post" action="TEncuestadoras.cfm">
								<cfoutput>					
									<input type="hidden" name="EEid" value="<cfif isdefined("form.EEid") and len(trim(form.EEid))>#form.EEid#</cfif>">
									<input type="hidden" name="tab" value="5">
									
									<tr class="areaFiltro">
										<td align="right" nowrap><strong>C&oacute;d. Puesto:</strong></td>
										<td>
											<input type="text" name="RHPcodigo_F" size="6" maxlength="10" value="<cfif isdefined('form.RHPcodigo_F') and Len(trim(form.RHPcodigo_F))>#trim(form.RHPcodigo_F)#</cfif>" onfocus="this.select();" >
										</td>
										<td align="right"><strong>Descripci&oacute;n:</strong></td>
										<td>
											<input type="text" name="RHPdescripcion_F" size="40" maxlength="80" value="<cfif isdefined('form.RHPdescripcion_F') and Len(trim(form.RHPdescripcion_F))>#trim(form.RHPdescripcion_F)#</cfif>" onfocus="this.select();">
										</td>
										<td rowspan="2" valign="middle" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
									</tr>											
									<tr class="areaFiltro">
										<td align="right" nowrap><strong>C&oacute;d. Externo:</strong></td>
										<td>
											<input type="text" name="EPcodigo_F" size="6" maxlength="10" value="<cfif isdefined('form.EPcodigo_F') and Len(trim(form.EPcodigo_F))>#trim(form.EPcodigo_F)#</cfif>" onfocus="this.select();" >
										</td>
										<td align="right"><strong>Descripci&oacute;n:</strong></td>
										<td>
											<input type="text" name="EPdescripcion_F" size="40" maxlength="80" value="<cfif isdefined('form.EPdescripcion_F') and Len(trim(form.EPdescripcion_F))>#trim(form.EPdescripcion_F)#</cfif>" onfocus="this.select();">
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
						select rep.RHPcodigo, p.RHPdescpuesto, ep.EPcodigo, ep.EPdescripcion, #form.EEid# as EEid, 5 as tab
						from RHEncuestaPuesto rep
							join RHPuestos p
								on  p.Ecodigo = rep.Ecodigo
								and p.RHPcodigo = rep.RHPcodigo
						  	<cfif isdefined("form.RHPdescripcion_F") and len(trim(form.RHPdescripcion_F))>
								and upper(p.RHPdescpuesto) like '%#UCase(Form.RHPdescripcion_F)#%'
						  	</cfif>						
							join EncuestaPuesto ep
								on  rep.EEid = ep.EEid
								and rep.EPid = ep.EPid
						  	<cfif isdefined('form.EPcodigo_F')>
							  	and upper(ep.EPcodigo) like '%#UCase(Form.EPcodigo_F)#%'
						  	</cfif>
						  	<cfif isdefined("form.EPdescripcion_F") and len(trim(form.EPdescripcion_F))>
								and upper(ep.EPdescripcion) like '%#UCase(Form.EPdescripcion_F)#%'
						  	</cfif>			
						where rep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and rep.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
						  <cfif isdefined('form.RHPcodigo_F')>
								and upper(rep.RHPcodigo) like '%#UCase(Form.RHPcodigo_F)#%'
						  </cfif>
						  order by EPdescripcion			
					</cfquery>
			
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="RHPcodigo,RHPdescpuesto"
						etiquetas=" ,Puesto"
						formatos="S,S"
						align="left,left"
						ira="TEncuestadoras.cfm"
						showEmptyListMsg="true"
						cortes="EPdescripcion"
						keys="RHPcodigo,EEid"
						navegacion="#navegacionRelPuestos#"
					/>		
				</td>
			</tr>
		</table>
	</td>
    <td valign="top">
		<!--- Consulta de Empresa Encuestadora --->
		<cfquery name="rsEncuestadora" datasource="#Session.DSN#">
			select 1
			from RHEncuestadora
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
		</cfquery>
		<cfif rsEncuestadora.recordCount>
			<cfinclude template="relacionPuestos-form.cfm">
		<cfelse>
			<p align="justify" style="margin-left: 10px; margin-right: 10px; margin-top: 10px; ">
			<strong>Para registrar una relaci&oacute;n de puestos debe configurar la empresa encuestadora antes de continuar.
			Entre a la opci&oacute;n de Configuración de Empresa Encuestadora en Administraci&oacute;n de Salarios.</strong>
			</p>
		</cfif>
	</td>
  </tr>
</table>
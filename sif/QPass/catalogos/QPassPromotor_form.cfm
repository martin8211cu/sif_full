	<cfquery name="rsOficinas" datasource="#Session.DSN#" >
		select 
			Ocodigo,
			Oficodigo,
			Odescripcion 
				from Oficinas 
			where Ecodigo = #session.Ecodigo#
			order by Oficodigo
	</cfquery>

<cfif isdefined("form.QPPid") and len(trim(form.QPPid))>
    <cfquery name="rsAsignaTags" datasource="#session.dsn#">
		 select a.QPPestado from QPPromotor a
			inner join QPassTag b
				on a.QPPid = b.QPPid
			inner join QPEAsignaPromotor c
				on a.QPPid = c.QPPid
				and a.Ecodigo = c.Ecodigo
      		  where a.Ecodigo = #session.Ecodigo#
			  and b.QPTEstadoActivacion  not in (3,4)
			  and a.QPPestado = '1'
             and a.QPPid = #form.QPPid#
    </cfquery>
	
	<cfquery name="rsDato" datasource="#session.dsn#">
		select 
			  a.QPPid,
			  a.QPPnombre,
			  a.QPPcodigo,
			  a.Ocodigo,
			  oo.Odescripcion as Oficina,
			  a.QPPtelefono,
			  a.QPPestado,
			  a.Ecodigo,
			  a.QPPdirreccion,
			  a.BMFecha,
			  a.QPPPuntoSeguro,
			  a.BMUsucodigo
			from QPPromotor a
				inner join Oficinas oo
				on oo.Ecodigo = a.Ecodigo
				and oo.Ocodigo = a.Ocodigo
			where a.Ecodigo = #session.Ecodigo# 
			and  a.QPPid=#form.QPPid#
		order by a.QPPnombre
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
		<form action="QPassPromotor_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); "> 
			<table width="80%" align="center" border="0" >
				<tr>
					<td valign="top" nowrap><strong>Código:</strong>&nbsp;</td>
			      	<td valign="top">
						<input type="text" name="QPPcodigo" maxlength="101" size="20" id="QPPcodigo" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPPcodigo)#</cfif>"/>					</td>
				</tr>
				<tr>
					<td align="right"><strong>Promotor:</strong></td>
					<td colspan="2">
				<input type="text" name="QPPnombre" maxlength="101" size="40" id="QPPnombre" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPPnombre)#</cfif>"/>				</tr>	
				<tr>
					<td align="right"><strong>Direcci&oacute;n:</strong></td>
					<td colspan="2">
                        <textarea  
                            cols="45" 
                            rows="3" 
                            name="QPPdirreccion" 
                            maxlength="255" 
                            tabindex="1"><cfif modo NEQ 'ALTA'>#trim(rsDato.QPPdirreccion)#</cfif></textarea>                	</td>
				</tr>	
				<tr>
					<td align="right"><strong>Tel&eacute;fono:</strong></td>
					<td colspan="2">
						<input type="text" name="QPPtelefono" maxlength="21" size="20" id="QPPtelefono" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPPtelefono)#</cfif>" />                	</td>
				</tr>	
				<tr>
					<td align="right"><strong>Sucursal:</strong></td>
					<td>
					<cfif modo NEQ "ALTA"> 
						<cfif rsAsignaTags.recordcount lte 0>
							<select  tabindex="1" name="Oficina">
								<cfloop query="rsOficinas">
									<option value="#rsOficinas.Ocodigo#" <cfif modo NEQ 'Alta' and rsOficinas.Ocodigo eq rsDato.Ocodigo>selected="selected"</cfif>>#rsOficinas.Oficodigo#-#rsOficinas.Odescripcion#</option>
								</cfloop>
							</select>	
						<cfelse>
						<input type="hidden" name="Oficina" value="#rsDato.Ocodigo#" >
						#rsDato.Oficina#
						</cfif>
					<cfelse>
						<select  tabindex="1" name="Oficina">
							<cfloop query="rsOficinas">
								<option value="#rsOficinas.Ocodigo#" <cfif modo NEQ 'Alta' and rsOficinas.Ocodigo eq rsDato.Ocodigo>selected="selected"</cfif>>#rsOficinas.Oficodigo#-#rsOficinas.Odescripcion#</option>
							</cfloop>
						</select>						
					</cfif>	</td> 
				</tr>					
				<tr>
					<td align="right"><strong>Vigente:</strong></td>
				    <td colspan="2">
					<input 	type="checkbox" name="QPPestado" tabindex="1" 
					<cfif modo NEQ "ALTA" and #rsDato.QPPestado# EQ 1> checked <cfif rsAsignaTags.recordcount gt 0>  disabled="disabled"</cfif></cfif>><cfif modo NEQ "ALTA" and rsDato.QPPestado EQ 1 and rsAsignaTags.recordcount gt 0>**Tiene Tags Asociados**</cfif>
               	    <strong>Seguro</strong>
				<input 	type="checkbox" name="QPPPuntoSeguro" tabindex="1" 
					<cfif modo NEQ "ALTA" and #rsDato.QPPPuntoSeguro# EQ 1> checked </cfif>></td>
				</tr>	
				
				<tr><td colspan="3"></td></tr>
			
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.QPPid") and isdefined("form.QPPcodigo")> 
							<cf_botones modo="#modo#" tabindex="1">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="1">
						</cfif>					</td>
				</tr>
				<tr>
					<td colspan="3">
						<cfset ts = "">
						<cfif modo NEQ "ALTA">
							<input type="hidden" name="QPPid" value="#rsDato.QPPid#" >
							<input type="hidden" name="QPPestado" value="#rsAsignaTags.QPPestado#">
						</cfif>
							<input type="hidden" name="Pagina3" 
							value="
						<cfif isdefined("form.pagenum3") and form.pagenum3 NEQ "">
							#form.pagenum3#
						<cfelseif isdefined("url.PageNum_lista3") and url.PageNum_lista3 NEQ "">
							#url.PageNum_lista3#
						</cfif>">					</td>
				</tr>
			</table>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.QPPnombre.description = "Promotor";
		objForm.QPPcodigo.description = "Código del Promotor";
	function habilitarValidacion() 
	{
		objForm.QPPnombre.required = true;
		objForm.QPPcodigo.required = true;
	}
	function trim(dato) {
		return dato.replace(/^\s*|\s*$/g,"");
	}
</script>
</cfoutput>

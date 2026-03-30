<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfif isdefined("url.fEOnumero") and len(url.fEOnumero) and not isdefined("form.fEOnumero")><cfset form.fEOnumero = url.fEOnumero></cfif>
<cfif isdefined("url.fEOnumero2") and len(url.fEOnumero2) and not isdefined("form.fEOnumero2")><cfset form.fEOnumero2 = url.fEOnumero2></cfif>
<cfif isdefined("url.fObservaciones") and len(url.fObservaciones) and not isdefined("form.fObservaciones")><cfset form.fObservaciones = url.fObservaciones></cfif>
<cfif isdefined("url.fEOfecha") and len(url.fEOfecha) and not isdefined("form.fEOfecha")><cfset form.fEOfecha = url.fEOfecha></cfif>
<cfif isdefined("url.SNcodigoF") and len(url.SNcodigoF) and not isdefined("form.SNcodigoF")><cfset form.SNcodigoF = url.SNcodigoF></cfif>
<cfoutput>
	<form style="margin: 0" action="#GetFileFromPath(GetTemplatePath())#" name="fsolicitud" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	  <tr> 
		<td class="fileLabel" nowrap width="8%" align="right"><label for="fEOnumero">N&uacute;mero:</label></td>
		<td nowrap width="31%">
			desde <input type="text" name="fEOnumero" size="10" maxlength="20" value="<cfif isdefined('form.fEOnumero')>#form.fEOnumero#</cfif>" style="text-transform: uppercase; text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			hasta <input type="text" name="fEOnumero2" size="10" maxlength="20" value="<cfif isdefined('form.fEOnumero2')>#form.fEOnumero2#</cfif>" style="text-transform: uppercase; text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">		</td>
		<td class="fileLabel" nowrap width="9%" align="right">Descripci&oacute;n:</td>
		<td nowrap width="25%"><input type="text" name="fObservaciones" size="40" maxlength="100" value="<cfif isdefined('form.fObservaciones')>#form.fObservaciones#</cfif>" style="text-transform: uppercase;" >		</td>
		<td width="27%" rowspan="2" align="center" valign="middle"><input type="submit" class="btnFiltrar" name="btnFiltro" value="Filtrar" /></td>
	  </tr>
	  <tr>
		<td class="fileLabel" align="right" nowrap>Proveedor:</td>
		<td nowrap>
			<cfset valSNcodF = ''>
			<cfif isdefined('form.SNcodigoF') and Len(Trim(form.SNcodigoF))>
			  <cfset valSNcodF = form.SNcodigoF>
			</cfif>
			<cf_sifsociosnegocios2 form="fsolicitud" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1">		</td>
		<td class="fileLabel" align="right" nowrap>Fecha:</td>
		<td nowrap>
			<cfif isdefined('form.fEOfecha') and Len(Trim(form.fEOfecha))>
				<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fEOfecha" value="#form.fEOfecha#">
			<cfelse>
				<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fEOfecha" value="">
			</cfif>		</td>
	  </tr>
	</table>
	</form>
</cfoutput>

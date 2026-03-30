<cfif isdefined("form.cvtid") and len(form.cvtid)>
	<cfset escenario = getCVTCEscenario(form.cvtid)>
</cfif>
<cfoutput>
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="2">
<form name="form1" method="post" action="#GCurrentPage#">
    <tr>
        <td colspan="2" class="AreaFiltro" height="25" valign="middle" align="center"><strong><cfif isdefined("escenario.cvtid")>Modificaci&oacute;n de Escenario<cfelse>Nuevo Escenario</cfif></strong></td>
		</tr>
    <tr></tr>
        <td width="1%" nowrap><div align="right"><strong>Descrpci&oacute;n&nbsp;:&nbsp;</strong></div></td>
        <td><input name="CVTdescripcion" type="text" accesskey="1" tabindex="1" value="<cfif isDefined("escenario.CVTdescripcion")>#escenario.CVTdescripcion#</cfif>"></td>
    </tr>
    <tr>
        <td width="1%" nowrap><div align="right"><strong>Tipo&nbsp;:&nbsp;</strong></div></td>
        <td><select name="CVTtipo" accesskey="2" tabindex="2">
            <option value="N" <cfif (isDefined("escenario.CVTtipo") AND "N" EQ escenario.CVTtipo)>selected</cfif>>Normal</option>
            <option value="O" <cfif (isDefined("escenario.CVTtipo") AND "O" EQ escenario.CVTtipo)>selected</cfif>>Optimista</option>
            <option value="P" <cfif (isDefined("escenario.CVTtipo") AND "P" EQ escenario.CVTtipo)>selected</cfif>>Pesimista</option>
						</select>
				</td>
    </tr>
    <tr>
        <td width="1%" nowrap>&nbsp;</td>
        <td><input type="checkbox" name="chk"
						<cfif isDefined("escenario.CVTaplicado") and escenario.CVTaplicado> 
            	checked
		        </cfif> disabled><strong>Aplicado</strong>
				</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">
			<input type="hidden" name="fMcodigo" value="-1">
			<input name="CVTid" type="hidden" value="<cfif isDefined("escenario.CVTid")>#escenario.CVTid#</cfif>">
						<input name="CVTaplicado" type="hidden" value="<cfif isDefined("escenario.CVTaplicado")>#escenario.CVTaplicado#</cfif>">
						<input name="ts" type="hidden" value="<cfif isDefined("escenario.ts")>#escenario.ts#</cfif>">
						<input name="PAGENUM" type="hidden" value="<cfif isDefined("form.PAGENUM")>#form.PAGENUM#</cfif>">
						<cfif NOT isdefined("escenario.cvtid")>
						<cf_botones modocambio = "#isdefined("escenario.cvtid")#" tabindex="3">
						<cfelse>
						<cf_botones modocambio = "#isdefined("escenario.cvtid")#" tabindex="3"  include="btnMeses" includeValues="Tipos Cambios">
						</cfif>
				</td>
    </tr>
</form>
</table>
<script language='JavaScript' type='text/JavaScript' src='/cfmx/sif/js/qForms/qforms.js'></script>
<script language='javascript' type='text/JavaScript' >
<!--//
	qFormAPI.setLibraryPath('/cfmx/sif/js/qForms/');
	qFormAPI.include('*');
	qFormAPI.errorColor = '##FFFFCC';
	objForm = new qForm('form1');
	objForm.CVTdescripcion.description = "#JSStringFormat('Descripción')#";
	objForm.CVTtipo.description = "#JSStringFormat('Tipo')#";
	objForm.CVTdescripcion.required=true;
	objForm.CVTtipo.required=true;
	objForm.CVTdescripcion.obj.focus();

	function deshabilitarValidacion()
	{
		objForm.optional('CVTdescripcion,CVTtipo');
	}
//-->
</script>
</cfoutput>
<table border="0" cellspacing="1" cellpadding="0">
<cfoutput>
	<tr> 
		<td width="10%" align="right" nowrap><strong><cf_translate key="LB_CentroFuncionalAct" XmlFile="/rh/generales.xml">Centro Funcional Actual</cf_translate>:&nbsp;</strong></td>
		<td  valign="middle" nowrap>
		<input name="CFcodigo1" type="text" id="CFcodigo1" size ="10" readonly="true"
			value="<cfif isdefined("form.CFcod")><cfoutput>#trim(form.CFcod)#</cfoutput></cfif>">
		<input name="CFdescripcion1" type="text" id="CFdescripcion1"  size="39"readonly="true"
			value="<cfif isdefined("form.CFdescrip")><cfoutput>#trim(form.CFdescrip)#</cfoutput></cfif>">
		</td>
	</tr>
	<tr>
		<td width="10%" align="right" nowrap><strong><cf_translate key="LB_CentroFuncionalProp" XmlFile="/rh/generales.xml">Centro Funcional Propuesto</cf_translate>:&nbsp;</strong></td>
		<td ><cf_rhcfuncional form="frmTab1" tabindex="1"></td>
	</tr>
	<tr>
		<td align="center" colspan="3">
			<input type="button" name="Modificar" value="#BTN_Modifica#" tabindex="1">
		</td>
	</tr>
</cfoutput>
</table>

<cfif dmodo neq 'ALTA'>
	<cfquery name="rsDForm" datasource="asp">
		select Ctipo, Cbalancen, Cformato, Cdescripcion, CdescripcionF 
		from WEContable
		where WECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WECid#">
	</cfquery>
</cfif>

<cfoutput>
<script  language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><div align="right">Formato:&nbsp;</div></td>
		<td><input name="Cformato" type="text" id="Cformato" value="<cfif dmodo neq 'ALTA'>#rsDForm.Cformato#</cfif>" size="55" maxlength="100" onfocus="this.select();"></td>
		<td nowrap><div align="right">Balance Normal:&nbsp;</div></td>
		<td width="30%"><select name="CBalancen" id="CBalancen">
			<option value="D" <cfif dmodo neq 'ALTA' and rsDform.CBalancen eq 'D'>selected</cfif>>D&eacute;bito</option>
			<option value="C" <cfif dmodo neq 'ALTA' and rsDform.CBalancen eq 'C'>selected</cfif> >Cr&eacute;dito</option>
		</select></td>
		<td ><div align="right">Tipo: </div></td>
		<td align="left"><select name="Ctipo" id="Ctipo">
			<option value="A" <cfif dmodo neq 'ALTA' and rsDform.Ctipo eq 'A'>selected</cfif> >A</option>
			<option value="P" <cfif dmodo neq 'ALTA' and rsDform.Ctipo eq 'P'>selected</cfif> >P</option>
			<option value="C" <cfif dmodo neq 'ALTA' and rsDform.Ctipo eq 'C'>selected</cfif> >C</option>
			<option value="I" <cfif dmodo neq 'ALTA' and rsDform.Ctipo eq 'I'>selected</cfif> >I</option>
			<option value="G" <cfif dmodo neq 'ALTA' and rsDform.Ctipo eq 'G'>selected</cfif> >G</option>
			<option value="O" <cfif dmodo neq 'ALTA' and rsDform.Ctipo eq 'O'>selected</cfif> >O</option>
        	                </select></td>


	</tr>
	<tr>
		<td nowrap><div align="right">Descripci&oacute;n:&nbsp;</div></td>
		<td><input  name="Cdescripcion" type="text" value="<cfif dmodo neq 'ALTA'>#rsDForm.Cdescripcion#</cfif>" size="55" maxlength="80" onblur="javascript:descripcion();" onfocus="this.select();" ></td>
		<td><div align="right">Desc. Adicional:&nbsp;</div></td>
		<td colspan="3"><input name="CdescripcionF" type="text" id="CdescripcionF" value="<cfif dmodo neq 'ALTA'>#rsDForm.CdescripcionF#</cfif>" size="55" maxlength="80" onfocus="this.select();" ></td>

	</tr>
</table>

<!--- hiddens --->
<cfif dmodo neq 'ALTA'>
	<input type="hidden" name="WECid" value="#form.WECid#">
</cfif>

<script type="text/javascript" language="javascript1.2">
	function descripcion(){
		if ( trim(document.form1.Cdescripcion.value) != ''  && trim(document.form1.CdescripcionF.value) == '' ){
			document.form1.CdescripcionF.value = document.form1.Cdescripcion.value
		}
	}
</script>

</cfoutput>
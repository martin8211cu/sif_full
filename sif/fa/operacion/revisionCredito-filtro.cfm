<cfif isdefined("url.fCliente") and len(url.fCliente) and not isdefined("form.fCliente")>
	<cfset form.fCliente= url.fCliente>
</cfif>
<cfif isdefined("url.fCedula") and len(url.fCedula) and not isdefined("form.fCedula")>
	<cfset form.fCedula = url.fCedula>
</cfif>

<cfoutput>
<form style="margin: 0" action="revisionCredito-lista.cfm" name="frevisionCredito" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  		<tr> 
			<td width="5%">&nbsp;</td>
    		<td class="fileLabel" nowrap width="40%">
				<label for="fCliente"><strong>Cliente:&nbsp;</strong></label>
    		  	<input type="text" name="fCliente" size="40" maxlength="100" value="<cfif isdefined('form.fCliente')>#form.fCliente#</cfif>">
			</td>
		  	<td class="fileLabel" nowrap width="20%">
				<label for="fCedula"><strong>C&eacute;dula:&nbsp;</strong></label>
		    	<input type="text" name="fCedula" size="10" maxlength="20" value="<cfif isdefined('form.fCedula')>#form.fCedula#</cfif>">
			</td>
			<td width="35%" align="right">
				<input type="submit" name="btnFiltro"  value="Filtrar">&nbsp;&nbsp;
				<input type="button" name="btnLimpiar"  value="Limpiar" onClick="javascript: limpiar();">&nbsp;&nbsp;
			</td>
		</tr>
	</table>
</form>
</cfoutput>


<script language="javascript1.2" type="text/javascript">
	function limpiar(){
		document.frevisionCredito.fCliente.value = "";
		document.frevisionCredito.fCedula.value = "";
		document.frevisionCredito.fCliente.focus();
	}
</script>
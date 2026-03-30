<!--- CAMPOS POR EL(OS) CUAL(ES) SE REALIZARÁ EL FILTRO--->
<cfif isdefined("url.BNCodigo") and not isdefined("form.BNCodigo") >
	<cfset form.BNCodigo = url.BNCodigo >
</cfif>
<cfif isdefined("url.BNDescripcion") and not isdefined("form.BNDescripcion") >
	<cfset form.BNDescripcion = url.BNDescripcion >
</cfif>
<cfif isdefined("url.BNFecha") and not isdefined("form.BNFecha") >
	<cfset form.BNFecha = url.BNFecha >
</cfif>



<cfoutput>
<form style="margin: 0" action="tiposBonos.cfm" name="tiposBonos" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	<tr>
		<td width="88"align="right"><strong>C&oacute;digo:</strong></td>		
		<td width="83" align="left"><input type="text" name="Codigo_F" size="10" maxlength="10" value="<cfif isdefined('form.Codigo_F')>#form.Codigo_F#</cfif>"></td>
		<td width="104" align="right"><strong>Vencimiento:</strong></td>
		<td width="482" align="left">
			<cfif isdefined('form.Fecha_F')>
				<cf_sifcalendario tabindex="5" form="tiposBonos" value="#LSDateFormat(form.Fecha_F,'dd/mm/yyyy')#" name="Fecha_F">
			<cfelse>
				<cf_sifcalendario tabindex="5" form="tiposBonos" value="" name="Fecha_F">
		</cfif>		</td>	
	  </tr>
	<tr>
	  <td align="right"><strong>Descripci&oacute;n:</strong></td>
	  <td colspan="2" align="left"><input type="text" name="Descripcion_F" size="30" maxlength="80" value="<cfif isdefined('form.Descripcion_F')>#form.Descripcion_F#</cfif>"></td>
	  <td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	  </tr>
 </table>
</form>

<script language="javascript" type="text/javascript">
	var f = document.tiposBonos;
	f.Codigo_F.focus();
</script>
</cfoutput>
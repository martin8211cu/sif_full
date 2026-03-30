<script language="javascript" type="text/javascript">
	function generarReporte(formato,rep) {
		var width = 650;
		var height = 450;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		if (rep == 0){
		<cfoutput>
		var params = '?RHASid=#Form.RHASid#&Formato='+formato;
		</cfoutput>
		var nuevo = window.open('analisis-salarial-repgenerado.cfm'+params,'conlisASalarial','resizable=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();}
		else{alert('No hay Puestos asignados. No se puede generar el reporte.');
			return false;
		}
	}
</script>
<cfquery name="rsPuestos" datasource="#session.DSN#">
	select *
	from RHASalarialPuestos
	where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
</cfquery>

<cfset Reporte = 0>
<cfif rsPuestos.RecordCount EQ 0><cfset Reporte = 1></cfif>
<form name="form1" method="get" style="margin: 0; ">
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
	    <td align="center" style="font-size:12px; font-variant:small-caps; font-weight:bold;">Seleccione el formato con el cual desea generar el reporte</td>
		<td class="fileLabel" align="right">Formato:</td>
		<td>
			<select name="formato">
				<option value="HTML">HTML</option>
				<option value="flashpaper">FlashPaper</option>
				<option value="pdf">Pdf</option>
				<option value="excel">Excel</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td colspan="3" align="center">
			<input name="btnGenerar" type="button" id="btnGenerar" value="Generar" onClick="javascript: generarReporte(this.form.formato.value,'<cfoutput>#Reporte#</cfoutput>');">
		</td>
	  </tr>
	  <tr>
		<td colspan="3">&nbsp;</td>
	  </tr>
	</table>
</form>
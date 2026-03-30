
<cfparam name="url.FMT00COD" type="numeric" >
<cfparam name="url.FMT02SQL" default="">


<cfquery datasource="sifcontrol" name="data">
	select FMT00COD,FMT02SQL,FMT11NOM,FMT11DES,FMT10TIP, FMT11CNT
	from FMT011
	where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#">
	  and FMT02SQL = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT02SQL#" null="#Len(url.FMT02SQL) is 0#">
</cfquery>
<cfquery datasource="sifcontrol" name="nextval">
	select coalesce(max(FMT02SQL),0)+1 as nextval
	from FMT011
	where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#">
</cfquery>
<cfquery datasource="asp" name="caches">
	select Ccache
	from Caches
	order by Ccache
</cfquery>



<cfoutput>

<script type="text/javascript">
<!--
function LeerCampos(f) {
	if (f.probar_ds.selectedIndex == 0)
		return;
	if (confirm('Desea utilizar el datasource ' + f.probar_ds.value + ' para ejecutar el query y obtener la lista de campos?  Los campos actuales, si los hay, los va a perder. ')) {
		f.submit();
	} else {
		f.probar_ds.selectedIndex = 0;
	}
}
-->
</script>

<form action="FMT011-sql.cfm" method="post" name="form1">
<input type="hidden" name="FMT00COD" value="#HTMLEditFormat(url.FMT00COD)#">
  <table  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td class="subTitulo">Campos de resultado </td>
      </tr>
    <tr>
      <td><strong>N&uacute;mero</strong></td>
      </tr>
    <tr>
      <td><input type="text" value="<cfif Len(data.FMT02SQL)>#HTMLEditFormat(data.FMT02SQL)#<cfelse>#nextval.nextval#</cfif>" name="FMT02SQL" onFocus="this.select()"></td>
      </tr>
    <tr>
      <td><strong>Tipo</strong></td>
      </tr>
    <tr>
      <td><select name="FMT10TIP">
        <option value="0" <cfif data.FMT10TIP is 0>selected</cfif>>texto</option>
        <option value="1" <cfif data.FMT10TIP is 1>selected</cfif>>n&uacute;mero</option>
        <option value="2" <cfif data.FMT10TIP is 2>selected</cfif>>fecha</option>
      </select></td>
      </tr>
    <tr>
      <td><strong>Nombre</strong></td>
      </tr>
	<tr>
		<td><input type="text" value="#HTMLEditFormat(data.FMT11NOM)#" name="FMT11NOM" onFocus="this.select()"></td>
	</tr>

	<tr><td></td></tr>

	<tr><td><strong>Descripci&oacute;n</strong></td></tr>
	<tr>
		<td>
			<input type="text" value="#HTMLEditFormat(data.FMT11DES)#" name="FMT11DES" onFocus="this.select()">
		</td>
	</tr>

	<tr><td><strong>Controla Cambio de Documento<BR>(sólo para soinPrintDocs.OCX)</strong></td></tr>
	<tr>
		<td>
			<input type="checkbox" value="1" name="FMT11CNT" <cfif data.FMT11CNT EQ "1">checked</cfif>>
			(primer campo del order by)
		</td>
	</tr>

	<cfif Len(data.FMT02SQL) EQ 0>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr>
		  <td><strong>Obtener campos</strong></td>
		</tr>
		<tr>
		  <td><select name="probar_ds" onChange="LeerCampos(this.form)">
		  <option value="">-Clic para consultar-</option>
		  <cfloop query="caches">
			  <cfif StructKeyExists(Application.dsinfo, caches.Ccache)>
				<option value="#HTMLEditFormat(caches.Ccache)#">#HTMLEditFormat(caches.Ccache)#</option>
			  </cfif>
		  </cfloop>
			</select></td>
		</tr>
	</cfif>


    <tr>
      <td>&nbsp;</td>
      </tr>
    <tr>
      <td>
	  <cfif Len(data.FMT02SQL)>
	  <input type="submit" name="btnGuardar" value="Guardar">
	  <input type="submit" name="btnEliminar" value="Eliminar">
	  <input type="button" name="btnNuevo" value="Nuevo" onClick="location.href='FMT000.cfm?FMT00COD=#URLEncodedFormat(url.FMT00COD)#'">
	  <cfelse>
	  <input type="submit" name="btnGuardar" value="Agregar">
	  </cfif></td>
      </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>

</cfoutput>

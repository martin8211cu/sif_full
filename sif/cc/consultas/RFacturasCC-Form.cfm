<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_CLIENTE = t.Translate('LB_CLIENTE','Cliente','/sif/generales.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todos','Todas','/sif/generales.xml')> 
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_EnLinea = t.Translate('LB_EnLinea','En l&iacute;nea (HTML)')> 

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select a.CCTcodigo, a.CCTdescripcion from CCTransacciones a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.CCTpago = 0
	order by CCTcodigo
</cfquery>
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<form name="form1" method="post" action="RFacturasCC-SQL.cfm" 
	onSubmit="javascript:
		var f = document.form1; 
		f.SNnombre.disabled = false;
		f.CCTdescripcion.value = f.CCTcodigo.options[f.CCTcodigo.selectedIndex].text;
		">
				
  <table width="80%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr> 
	  <td colspan="6" nowrap>
	  </td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td> 
	  <td nowrap align="right"><strong><cfoutput>#LB_Fecha_Desde#:</cfoutput></strong>&nbsp;</td>
	  <td nowrap><cf_sifcalendario name="fechaIni" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1"></td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td> 
	  <td nowrap align="right"><strong><cfoutput>#LB_Fecha_Hasta#:</cfoutput></strong>&nbsp;</td>
	  <td nowrap><cf_sifcalendario name="fechaFin" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1"></td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td> 
	  <td nowrap align="right"><strong><cfoutput>#LB_CLIENTE#:</cfoutput></strong>&nbsp;</td>
	  <td nowrap><cf_sifsociosnegocios2 tabindex="1"></td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td>
	  <td align="right" nowrap><strong><cfoutput>#LB_Transaccion#:</cfoutput></strong>&nbsp;</td>
	  <td nowrap>          
	  	<select name="CCTcodigo" tabindex="1">
			<option value=""><cfoutput>#LB_Todas#</cfoutput></option>
            <cfoutput query="rsTransacciones"> 
              <option value="#rsTransacciones.CCTcodigo#" >#rsTransacciones.CCTdescripcion#</option>
            </cfoutput> 
          </select>
		  <input type="hidden" name="CCTdescripcion" value="">
		</td>
	</tr>
	<tr>
    <cfoutput>
		<td>&nbsp;</td>
	  	<td nowrap align="right"><strong>#LB_Formato#</strong>&nbsp;</td>
	  	<td nowrap>
			<select name="formato" tabindex="1">
				<option value="html">#LB_EnLinea#</option>
				<option value="pdf">Adobe PDF</option>
				<option value="xls">Microsoft Excel</option>
			</select>
		</td>
    </cfoutput>
	</tr>
  <tr>
    <td colspan="4">&nbsp;</td>
	</tr>
  <tr>
	<td colspan="6">
		<cf_botones values="Consultar,Limpiar" tabindex="1">
		<!--- <div align="center"> 
			<input type="submit" name="Submit" value="Consultar">&nbsp;
			<input type="reset" name="Limpiar" value="Limpiar" >
		</div> --->
	</td>
   
  </tr>
  </table>
</form>

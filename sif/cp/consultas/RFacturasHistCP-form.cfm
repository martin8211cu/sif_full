<cfset MSG_SelSocNeg 	= t.Translate('MSG_SelSocNeg','Debe seleccionar un Socio de Negocios')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Todos 		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_SocioNegocio 	= t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Documento 	= t.Translate('LB_Documento','Documento')>
<cfset LB_ListaDoc 		= t.Translate('LB_ListaDoc','Lista de Documentos')>
<cfset LB_Formato 		= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset BTN_Consultar 	= t.Translate('BTN_Consultar','Consultar','/sif/generales.xml')>
<cfset BTN_Limpiar 	= t.Translate('BTN_Limpiar','Limpiar','/sif/generales.xml')>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<!---Consultas para pintar el formulario--->
<!---Categorias--->
<cfquery name="rsCPTransacciones" datasource="#Session.DSN#">
	 select CPTcodigo, CPTdescripcion
	 from CPTransacciones
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfoutput>
<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	  window.onfocus=closePopUp;
	}
	function closePopUp() {
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin = 0;
	  }
	}

	function doConlisTran() {
	  if (document.form1.SNcodigo.value != "" ) {
		//Se envía el codigo del Socio como parámetro para que filtre el donlis
		popUpWindow("ConlisHistDocsCP.cfm?form=form1&id=CPTcodigo&desc=Documento&nombre=Mnombre&tipocambio=EFtipocambio&saldo=SaldoEncabezado&Moneda=McodigoE&Ccuenta=CcuentaE&Socio=" + document.form1.SNcodigo.value+'&CPTtipo=C&codigo=' + document.form1.CPTcodigo.value ,200,200,700,400);
	  } else {
		alert("#MSG_SelSocNeg#");
	  }
	}
</script>
</cfoutput>


<form name="form1" method="get" action="RFacturasHistCP-SQL.cfm"
	onSubmit="javascript:
		var f = document.form1;
		f.SNnombre.disabled = false;">

  <table width="80%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr><td nowrap></td></tr>

	<tr>
	  <td width="20%" align="right" nowrap><strong><cfoutput>#LB_Transaccion#:</cfoutput></strong></td>
	  <td width="25%" nowrap>
	  	<cfoutput>
	  		<select name="CPTcodigo" tabindex="1">
				<option value="">#LB_Todos#</option>
				<cfloop query="rsCPTransacciones">
					<option value="#Trim(CPTcodigo)#">#CPTdescripcion#</option>
				</cfloop>
			</select>
		</cfoutput>
	  </td>
    </tr>

	<tr>
      <td nowrap align="right" ><strong><cfoutput>#LB_SocioNegocio#:</cfoutput></strong></td>
      <td nowrap><cf_sifsociosnegocios2 Proveedores="SI" tabindex="1"></td>
    </tr>

	<tr>
	  <td nowrap align="right" ><strong><cfoutput>#LB_Documento#:</cfoutput></strong></td>
	  <td nowrap>
        <input name="Documento" id="Documento" type="text" size="40" tabindex="-1" style="text-align: left" value=""  >
         <a href="javascript:doConlisTran();" tabindex="-1"><img src="../../imagenes/Description.gif"  title="#LB_ListaDoc#" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>

      </td>
	</tr>
	<cfoutput>
    <tr>
	  <td nowrap align="right" ><strong>#LB_Formato#</strong></td>
	  <td nowrap><select name="formato" tabindex="1">
		<option value="1">Flashpaper</option>
		<option value="2">Adobe PDF</option>
	  </select></td>
	</tr>

    <tr>
      <td nowrap align="right" ><strong>#LB_Fecha_Desde#:</strong></td>
      <td nowrap><cf_sifcalendario name="fechaIni" value="#LSDateFormat(dateAdd('m', -1 ,Now()),'DD/MM/YYYY')#" tabindex="1"></td>
    </tr>
	<tr>
      <td nowrap align="right" ><strong>#LB_Fecha_Hasta#:</strong></td>
      <td nowrap><cf_sifcalendario name="fechaFin" value="#LSDateFormat(dateAdd('m', -1 ,Now()),'DD/MM/YYYY')#" tabindex="1"></td>
    </tr>
  	<tr>
	<td colspan="2" align="center">
		<input type="submit" name="Submit" value="#BTN_Consultar#" tabindex="1">&nbsp;
		<input type="reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="1">
		<input type="hidden" name="Mnombre" value="" id="Mnombre" tabindex="-1">
		<input type="hidden" name="EFtipocambio" value="" id="EFtipocambio" tabindex="-1">
		<input type="hidden" name="SaldoEncabezado" value="" id="SaldoEncabezado" tabindex="-1">
		<input type="hidden" name="disponible" value="" id="disponible" tabindex="-1">
		<input type="hidden" name="McodigoE" value="" id="McodigoE" tabindex="-1">
		<input type="hidden" name="CcuentaE" value="" id="CcuentaE" tabindex="-1">
	</td>
	</cfoutput>
  </tr>
  </table>
</form>

<script language="javascript" type="text/javascript">
	document.form1.CPTcodigo.focus();
</script>
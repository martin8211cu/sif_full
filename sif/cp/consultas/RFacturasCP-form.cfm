<cfset MSG_SelSocNeg 	= t.Translate('MSG_SelSocNeg','Debe seleccionar un Socio de Negocios')>
<cfset MSG_SelDocto 	= t.Translate('MSG_SelDocto','Por favor seleccione el No. de Documento')>
<cfset MSG_SelDigSoc 	= t.Translate('MSG_SelDigSoc','Por seleccione digite el Socio')>


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

<form name="form1" method="get" action="RFacturasCP-SQL.cfm"
	onSubmit=<cfoutput>"javascript:
		var f = document.form1;
		if(f.SNnombre.value ==''){
			f.SNcodigo.value = '';
			//f.SNidentificacion.value = '';
		}

		if(f.Documento.value ==''){
			alert('#MSG_SelDocto#');
			return false;
		}
		if(f.SNcodigo.value ==''){
			alert('#MSG_SelDigSoc#');
			return false;
		}
		f.SNnombre.disabled = false;
		"</cfoutput>>

  <table width="80%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr><td></td></tr>

	<tr>
	  <td width="45%" align="right" nowrap><strong>Transacci&oacute;n:</strong></td>
	  <td  nowrap>
	  	<cfoutput>
	  		<select name="CPTcodigo" tabindex="1">
				<option value="">Todos</option>
				<cfloop query="rsCPTransacciones">
					<option value="#Trim(CPTcodigo)#">#CPTdescripcion#</option>
				</cfloop>
			</select>
		</cfoutput>
	  </td>
    </tr>

	<tr>
      <td nowrap align="right" ><strong>Socio:</strong></td>
      <td nowrap><cf_sifsociosnegocios2 Proveedores="SI" tabindex="1"></td>
    </tr>

	<tr>
	  <td nowrap align="right" ><strong>Documento:</strong></td>
	  <td nowrap>
        <input name="Documento" id="Documento" type="text" size="40" tabindex="-1" style="text-align: right" value="" class="cajasinborde" tabindex="1">
         <a href="javascript:doConlisTran();" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Documentos" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>

      </td>
	</tr>

	<tr>
	  <td nowrap align="right" ><strong>Formato:</strong></td>
	  <td nowrap>
	  	  <select name="formato" tabindex="1">
			<option value="1">Flashpaper</option>
			<option value="2">Adobe PDF</option>
		  </select>
	  </td>
	</tr>


    <tr>
      <td nowrap align="right" ><strong>Fecha Desde:</strong></td>
      <td nowrap><cf_sifcalendario name="fechaIni" value="#LSDateFormat(dateadd('m',-1,Now()),'DD/MM/YYYY')#" tabindex="1"></td>
    </tr>

  <tr>
	<td colspan="2" align="center">
			<input type="submit" name="Submit" value="Consultar" tabindex="1">&nbsp;
			<input type="reset" name="Limpiar" value="Limpiar" tabindex="1">
			<input type="hidden" name="Mnombre" value="" id="Mnombre" tabindex="-1">
			<input type="hidden" name="EFtipocambio" value="" id="EFtipocambio" tabindex="-1">
			<input type="hidden" name="SaldoEncabezado" value="" id="SaldoEncabezado" tabindex="-1">
			<input type="hidden" name="disponible" value="" id="disponible" tabindex="-1">
			<input type="hidden" name="McodigoE" value="" id="McodigoE" tabindex="-1">
			<input type="hidden" name="CcuentaE" value="" id="CcuentaE" tabindex="-1">
	</td>

  </tr>
  </table>
</form>

<script language="javascript" type="text/javascript">
	document.form1.CPTcodigo.focus();
</script>
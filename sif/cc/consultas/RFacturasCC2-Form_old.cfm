<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<!---Consultas para pintar el formulario--->
<!---Categorias--->
<cfquery name="rsCCTransacciones" datasource="#Session.DSN#">
	 select CCTcodigo, CCTdescripcion 
	 from CCTransacciones 
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
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
		popUpWindow("../consultas/ConlisDocsCC.cfm?form=form1&id=CCTcodigo&desc=Documento&nombre=Mnombre&tipocambio=EFtipocambio&saldo=SaldoEncabezado&Moneda=McodigoE&Ccuenta=CcuentaE&Socio=" + document.form1.SNcodigo.value+"&CCTcodigo="+document.form1.CCTcodigo.value,200,200,700,400);
	  } else {
		alert("Por favor debe seleccionar un cliente");
	  }	
	}
</script>
 
<form name="form1" method="post" action="RFacturasCC2-SQL.cfm" 
	onSubmit="javascript:
		var f = document.form1; 
		
		if(f.SNnombre.value ==''){
			f.SNcodigo.value = '';
			//f.SNidentificacion.value = '';
		}

		if(f.Documento.value ==''){
			alert('Por favor seleccione el No. de Documento');
			return false;
		}
		if(f.SNcodigo.value ==''){
			alert('Por seleccione digite el Socio');
			return false;
		}
		f.SNnombre.disabled = false;		
		">
				
  <table width="80%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr><td></td></tr>

	<tr>
	  <td width="45%" align="right" nowrap><strong>Transacci&oacute;n:</strong></td>
	  <td  nowrap>
	  	<cfoutput>
	  		<select name="CCTcodigo" >
				<option value="">Todos</option>
				<cfloop query="rsCCTransacciones">
					<option value="#Trim(CCTcodigo)#">#CCTdescripcion#</option>
				</cfloop>
			</select>
		</cfoutput>
	  </td>
    </tr>

	<tr>
      <td nowrap align="right" ><strong>Socio:</strong></td>
      <td nowrap><cf_sifsociosnegocios2></td>
    </tr>

	<tr>
	  <td nowrap align="right" ><strong>Documento:</strong></td>
	  <td nowrap>
        <input name="Documento" id="Documento" type="text" size="40" tabindex="-1" style="text-align: right" value="" class="cajasinborde" >
         <a href="javascript:doConlisTran();" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Documentos" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
       
      </td>
	</tr>

	<tr>
	  <td nowrap align="right" ><strong>Formato:</strong></td>
	  <td nowrap><select name="formato">
		<option value="html">En l&iacute;nea (HTML)</option>
		<option value="pdf">Adobe PDF</option>
		<option value="xls">Microsoft Excel</option>
	  </select></td>
	</tr>


    <tr>
      <td nowrap align="right" ><strong>Fecha Desde:</strong></td>
      <td nowrap><cf_sifcalendario name="fechaIni" value="#LSDateFormat(dateadd('m',-1,Now()),'DD/MM/YYYY')#"></td>
    </tr>

  <tr>
	<td colspan="2" align="center">
			<input type="submit" name="Submit" value="Consultar">&nbsp;
			<input type="reset" name="Limpiar" value="Limpiar" >
			<input type="hidden" name="Mnombre" value="" id="Mnombre">
			<input type="hidden" name="EFtipocambio" value="" id="EFtipocambio">
			<input type="hidden" name="SaldoEncabezado" value="" id="SaldoEncabezado">
			<input type="hidden" name="disponible" value="" id="disponible">
			<input type="hidden" name="McodigoE" value="" id="McodigoE">
			<input type="hidden" name="CcuentaE" value="" id="CcuentaE">
	</td>
   
  </tr>
  </table>
</form>

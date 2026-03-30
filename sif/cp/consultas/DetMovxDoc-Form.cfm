<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<!---Consultas para pintar el formulario--->
<!---Categorias--->
<cfquery name="rsCPTransacciones" datasource="#Session.DSN#">
	 select CPTcodigo, CPTdescripcion
	 from CPTransacciones
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset MSG_SelCliente 	= t.Translate('MSG_SelCliente','Por favor debe seleccionar un cliente')>
<cfset MSG_SelNoDoc 	= t.Translate('MSG_SelNoDoc','Por favor seleccione el No. de Documento')>
<cfset MSG_DigSoc 		= t.Translate('MSG_DigSoc','Por favor digite el Socio')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Todos 		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_PROVEEDOR		= t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
<cfset LB_Documento 	= t.Translate('LB_Documento','Documento')>
<cfset LB_EXExcel 		= t.Translate('LB_DocumeLB_EXExcelnto','Exportar a Excel.')>
<cfset LB_ListaDoc 		= t.Translate('LB_ListaDoc','Lista de Documentos')>
<cfset BTN_Consultar 	= t.Translate('BTN_Consultar','Consultar','/sif/generales.xml')>
<cfset BTN_Limpiar 	= t.Translate('BTN_Limpiar','Limpiar','/sif/generales.xml')>

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
		popUpWindow("ConlisHistDocsCP.cfm?form=form1&id=CPTcodigo&desc=Documento&nombre=Mnombre&tipocambio=EFtipocambio&saldo=SaldoEncabezado&Moneda=McodigoE&Ccuenta=CcuentaE&Socio=" + document.form1.SNcodigo.value+"&CPTtipo=C&Codigo=" + document.form1.CPTcodigo.value,200,200,800,500);
	  } else {
		alert("#MSG_SelCliente#");
	  }
	}
</script>
</cfoutput>

<form name="form1" method="post" action="DetMovxDoc-rep.cfm"
	onSubmit="<cfoutput>javascript:
		var f = document.form1;


		if(f.Documento.value ==''){
			alert('#MSG_SelNoDoc#');
			return false;
		}
		if(f.SNcodigo.value ==''){
			alert('#MSG_DigSoc#');
			return false;
		}

		f.SNnombre.disabled = false;
		"</cfoutput>>

  <table width="80%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr>
	  <td colspan="6" nowrap>
	  </td>
	</tr>
	<tr>
	  <td width="20%" nowrap align="right"><strong><cfoutput>#LB_Transaccion#:</cfoutput></strong></td>
	  <td width="25%" nowrap>
	  	<cfoutput>
	  		<select name="CPTcodigo" tabindex="1">
				<option value="">#LB_Todos#</option>
				<cfloop query="rsCPTransacciones">
					<option value="#Trim(CPTcodigo)#">#Trim(CPTcodigo)# - #CPTdescripcion#</option>
				</cfloop>
			</select>
		</cfoutput>
	  </td>
    </tr>
	<cfoutput>
	<tr>
      <td nowrap align="right"><strong>#LB_PROVEEDOR#:</strong></td>
      <td nowrap><cf_sifsociosnegocios2 Proveedores="SI" tabindex="1"></td>
    </tr>
	<tr>
	  <td nowrap align="right"><strong>#LB_Documento#:</strong></td>
	  <td nowrap>
        <input name="Documento" id="Documento" type="text" size="43" tabindex="-1" value="" readonly="readonly" >
         <a href="javascript:doConlisTran();" tabindex="-1"><img src="../../imagenes/Description.gif" alt="#LB_ListaDoc#" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>

    </td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<input type="checkbox" value="true" name="toexcel" tabindex="1"><cfoutput> <strong>#LB_EXExcel#</strong></cfoutput>
		</td>
	</tr>

  	<tr>
		<td colspan="6">
			<div align="center">
				<input type="submit" name="Submit" value="#BTN_Consultar#" tabindex="1">&nbsp;
				<input type="reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="1">

				<input type="hidden" name="Mnombre" value="" id="Mnombre" tabindex="-1">
				<input type="hidden" name="EFtipocambio" value="" id="EFtipocambio" tabindex="-1">
				<input type="hidden" name="SaldoEncabezado" value="" id="SaldoEncabezado" tabindex="-1">
				<input type="hidden" name="disponible" value="" id="disponible" tabindex="-1">
				<input type="hidden" name="McodigoE" value="" id="McodigoE" tabindex="-1">
				<input type="hidden" name="CcuentaE" value="" id="CcuentaE" tabindex="-1">


			</div>
		</td>
	</cfoutput>
  	</tr>
</table>
</form>

<script language="javascript1.2" type="text/javascript">
	function funcSNnumero(){
		document.form1.Documento.value = '';
	}
	document.form1.CPTcodigo.focus();
</script>
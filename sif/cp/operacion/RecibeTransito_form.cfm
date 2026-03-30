<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
		
	function doConlisRecibeTransito() {
		//alert(Hcodigo);
		popUpWindow("ConlisRecibeTransito.cfm",250,100,650,500);
	}
	
	function irALista() {
		location.href = "listaHorarioTipo.cfm";
	}
</script>

<form name="" onSubmit="" action="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="36%">&nbsp;</td>
    <td width="24%">&nbsp;</td>
    <td width="14%">&nbsp;</td>
    <td width="26%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><input name="btnHorarioAplica" type="button" value="Recibir" onClick="javascript:doConlisRecibeTransito();"></td>
  </tr>
  <tr>
    <td colspan="4">
					<cfset navegacion = "">
					<cfset filtro = "">
					<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
                    	<cfset Pagenum_lista = Form.Pagina>
                  	</cfif> 
					 <cf_dbfunction name="to_char"     args="a.ERTid"    returnvariable="ERTid">
					<cf_dbfunction name="to_sdateDMY" args="ERTfecha"   returnvariable="ERTfecha">
					<cfinvoke 
						 component="edu.Componentes.pListas"
						 method="pListaEdu"
						 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="ERecibeTransito a, DRecibeTransito b, Transito c"/>
						<cfinvokeargument name="columnas" value="#PreserveSingleQuotes(ERTid)# as ERTid, #PreserveSingleQuotes(ERTfecha)# as fecha, #PreserveSingleQuotes(ERTid)# as checked"/>
						<cfinvokeargument name="desplegar" value="fecha"/>
						<cfinvokeargument name="etiquetas" value="Descripción"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value=" b.TRid  = c.TRid
																and c.TRcantidad = b.DRTcantidad
																order by TRFecha "/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="RecibeTransito.cfm"/>
						<cfinvokeargument name="cortes" value=""/>
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="maxrows" value="10"/>
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="formName" value="lista"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
					</cfinvoke>
	</td>
    </tr>
</table>
</form>
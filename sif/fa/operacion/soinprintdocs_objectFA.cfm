<cfparam name="Attributes.FMT01COD"    default="FACREDITO">
<cfparam name="Attributes.FCid"        default="0">
<cfparam name="Attributes.ETnumero"    default="0">
<cfparam name="Attributes.tipo"        default="R">
<cfparam name="Attributes.Transaccion" default="FCre">

<cfset LvarOCX			= StructNew()>
<cfset LvarOCX.clsid	= "0FC59281-AD36-4FA6-A1AE-525E7D740FCC">
<cfset LvarOCX.version	= "1.0.98">

<cfset caller.LvarOCX = LvarOCX >

<script language="javascript">
	function sbDownload(pObjeto)
	{
		var LvarOCXversion	= "";
		var LvarDebug		= "";
		if (document.getElementById(pObjeto))
		{
			if (document.getElementById(pObjeto).version)
			LvarOCXversion = document.getElementById(pObjeto).version;
			else
			LvarOCXversion = "0";
		}
		if (document.getElementById("ErrorActiveX"))
		{
			if (window.Event)
			LvarDebug = "Error ActiveX: El ActiveX 'soinPrintDocs.ocx' sólo puede ejecutarse en Microsoft Internet Explorer.";
			else
			LvarDebug = "Error ActiveX: Instale primero el 'soinPrintDocs.ocx'";
		}
		else if (LvarOCXversion != "<cfoutput>#LvarOCX.version#</cfoutput>")
			LvarDebug = "Error ActiveX: Se requiere reinstalar la versión '<cfoutput>#LvarOCX.version#</cfoutput>' del 'soinPrintDocs.ocx' (version instalada: '" + LvarOCXversion + "')";
		else
		{
			LvarDebug = "Error ActiveX: No hubo error";
		return;
		}

		LvarDebug += "\n";

		if (document.getElementById(pObjeto))
		{
			LvarDebug += document.getElementById(pObjeto).id + "\n";
			if (document.getElementById(pObjeto).version)
			LvarDebug += "Version=" + LvarOCXversion + "\n";
		}
		if (document.getElementById("ErrorActiveX"))
			LvarDebug += document.getElementById("ErrorActiveX").id + "\n";
			LvarDebug += "finDebug";
			alert(LvarDebug);	
		
		alert("Instalación:\n1) Baje y abra el soinPrintDocs.zip\n2) Cierre TODAS las instancias de Internet Explorer\n3) Ejecute setup.exe\n4) Si no se pudo instalar ejecute la instalación manual");
		location.href = "soinprintdocs_dataFA.cfm?modo=DATA&Download=1&tipo=#Attributes.tipo#";
	}
</script>
<iframe width="00" height="00" id="ifrDownload" src=""  frameborder="0" style="display:none;">
</iframe>

<form name="form1" method="post">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
        	<td align="center"><strong>Imprimiendo la Factura de Cr&eacute;dito No. <cfoutput>#Attributes.Transaccion#</cfoutput>...</strong></td>
        </tr>
        <tr>
            <td align="center">
				<cfoutput>
                	<OBJECT ID="ImprimeX" width="0" height="0"	CLASSID="CLSID:#LvarOCX.clsid#">
						<span id="ErrorActiveX"></span>
					</OBJECT>

					<script language="javascript">
						sbDownload("ImprimeX");
					</script>
                
                    <OBJECT ID="Imprime1" CLASSID="CLSID:#LvarOCX.clsid#">
                    	<span id="ErrorActiveX"></span>
                    </OBJECT>
                
                    <input type="hidden" name="btnImprimir" value="" tabindex="-1">
                    <input type="hidden" name="UltimoDoc" value="0" tabindex="-1">
                    <input type="hidden" name="TotalPags" value="0" tabindex="-1">
                    <script language="javascript" FOR="Imprime1"  EVENT="Inicio">
						document.form1.btnImprimir.value = "";
						document.form1.btnCambiarBloque.style.display 	= "none";
						document.form1.btnTerminarImpresion.style.display = "none";
						document.form1.btnIrLista.style.display 			= "none";
                    </script>
    
                    <script language="javascript" FOR="Imprime1"  EVENT="NoInicio">
						document.form1.btnImprimir.value = "NOINICIO";
						alert('Impresión de documento Cancelada por usuario');
						document.form1.submit();
                    </script>
    
                    <script language="javascript" FOR="Imprime1"  EVENT="TerminoConError(LvarUltimoDoc,LvarTotPaginas)">
						document.form1.btnImprimir.value = "ERROR";
						document.form1.UltimoDoc.value = LvarUltimoDoc;
						document.form1.TotalPags.value = LvarTotPaginas;
						alert('Error al enviar Documento a Impresión');
						document.form1.submit();
                    </script>
    
                    <script language="javascript" FOR="Imprime1"  EVENT="TerminoConExito(LvarUltimoDoc,LvarTotPaginas)">
						document.form1.btnImprimir.value = "OK";
						document.form1.UltimoDoc.value = LvarUltimoDoc;
						document.form1.TotalPags.value = LvarTotPaginas;
						alert('Envio de Impresión finalizo de forma correcta');
						document.form1.submit();
                    </script>
    
                    <script language="javascript">
	                    sbDownload("Imprime1");
                    </script>
                    
                    <iframe width="00" height="00" id="ifrDatos" src="soinprintdocs_dataFA.cfm?modo=DATA&amp;FMT01COD=#Attributes.FMT01COD#&amp;FCid=#Attributes.FCid#&amp;ETnumero=#Attributes.ETnumero#&amp;tipo=#Attributes.tipo#" 
                    	    style="display:none">
                    </iframe>
                </cfoutput>
            </td>
        </tr>
    </table>     
</form>                        

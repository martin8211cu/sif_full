<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>


<cfif isdefined("url.EOidorden1") and len(url.EOidorden1) and not isdefined("form.EOidorden1")><cfset form.EOidorden1 = url.EOidorden1></cfif>

<cfif isdefined("url.fObservaciones") and len(url.fObservaciones) and not isdefined("form.fObservaciones")><cfset form.fObservaciones = url.fObservaciones></cfif>

<cfif isdefined("url.fEOfecha") and len(url.fEOfecha) and not isdefined("form.fEOfecha")><cfset form.fEOfecha = url.fEOfecha></cfif>
<cfif isdefined("url.SNcodigoF") and len(url.SNcodigoF) and not isdefined("form.SNcodigoF")><cfset form.SNcodigoF = url.SNcodigoF></cfif>

<cfparam name="lvarProvCorp" default="false">
<cfparam name="form.Ecodigo_f" default="#session.ecodigo#">
<cfoutput>
	<form style="margin: 0" action="#GetFileFromPath(GetTemplatePath())#" name="form1" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	 <cfif lvarProvCorp>
      	<tr>
            <td align="right" nowrap><strong>Empresa: </strong></td>
            <td >
                <select name="Ecodigo_f" onchange="javascript: cargarEcodigoF();">
                    <cfloop query="rsDProvCorp">
                        <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ Session.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                    </cfloop>	
                </select>
            </td>
        </tr>
      </cfif>
      <tr align="left">
          <td width="9%" nowrap align="right"><strong>Orden</strong></td>
          <td width="82%" nowrap>
                <input type="hidden" name="EOidorden1" value="">
                <input type="text" size="10" name="EOnumero1" value="" onblur="javascript:traerOrdenHasta(this.value,1);">
                <input type="text" size="40" readonly name="Observaciones1" value="" >									
                <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(1);'></a>																		
            &nbsp;
          </td>
      <tr>
        	<td colspan="2" align="center"><input type="submit" class="btnNormal" name="btnFiltro" value="Filtrar" /></td>
       	</tr>
	</table>
    <input type="hidden" name="Cancelar" value="2" />
	</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	//Funcion para hacer submit y resetar los valores de los select y conlis de proveedores y ordenes de Compra
	function cargarEcodigoF(){
		document.form1.action = 'ordenCompraACancelar.cfm';
		document.form1.submit();
		}

	var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			
			function doConlisOrdenesHasta(valor) {
				popUpWindow("/cfmx/sif/cm/consultas/ConlisOrdenCompraHasta.cfm?idx="+valor+'&Ecodigo='+<cfoutput>#form.Ecodigo_f#</cfoutput>+'&CMCid='+<cfoutput>#session.compras.comprador#</cfoutput>,30,100,900,500);	
			}
			
		function traerOrdenHasta(value, index){
		if (value!=''){	   
				document.getElementById("fr").src = '/cfmx/sif/cm/consultas/traerOrdenHasta.cfm?EOnumero='+value+'&index='+index+'&Ecodigo='+<cfoutput>#form.Ecodigo_f#</cfoutput>+'&CMCid='+<cfoutput>#session.compras.comprador#</cfoutput>;	
			} 
		else{
			document.form1.EOidorden1.value = '';
			document.form1.EOnumero1.value = '';
			document.form1.Observaciones1.value = '';
			}
		}
</script>
    <iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
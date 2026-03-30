<cfparam name="url.tipo" default="">
 <cfset titulo=" General">						 
 <cfif url.tipo EQ "CO">
	<cfset titulo=" de Contado">
 <cfelseif url.tipo EQ "CR">
	<cfset titulo=" de Cr&eacute;dito">
 <cfelseif url.tipo EQ "NC">
	<cfset titulo=" de Notas de Cr&eacute;dito">	
 <cfelseif url.tipo EQ "AN">
	<cfset titulo=" Anuladas">	
 </cfif>
<!--- Cajas --->
<cfquery name="rsCajas" datasource="#Session.DSN#">
	select convert(varchar,FCid) as FCid, FCcodigo 
	from FCajas 
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cf_templateheader title="Reporte de Transacciones">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Reporte de Transacciones #titulo#">
			<script language="JavaScript1.2" type="text/javascript">

				var popUpWin=0;
				
				function popUpWindow(URLStr, left, top, width, height){
				  if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
			
				function doConlis( id, desc, conlis, ancho, alto) {
					/**
					 * RESULTADO
					 * Pinta la ventana de conlis
					 * REQUIERE
					 * id: campo donde poner el codigo del registro
					 * desc: descripcion que ser amostrada
					 */
					popUpWindow( conlis + "?form=form1&id=" + id + "&desc=" + desc , 180, 200, ancho, alto );
				}

		  	</script>
			
			<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
              <form name="form1" action="SQLrepTransacciones.cfm" method="post" >
                <tr> 
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="10%"><div align="right">Caja:</div></td>
                  <td width="16%"><select name="FCajas">
                      <option value="">Todas</option>
                      <cfoutput query="rsCajas"> 
                        <option value="#FCid#">#FCcodigo#</option>
                      </cfoutput> </select></td>
                  <td width="20%" nowrap><div align="right">Fecha Inicial:</div></td>
                  <td width="17%"><cf_sifcalendario name="ETfechai"></td>
                  <td width="20%" nowrap><div align="right">Fecha Final:</div></td>
                  <td width="17%"><cf_sifcalendario name="ETfechaf"></td>
                </tr>
                <tr> 
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="6"><div align="center"> 
                      <input name="Consultar" type="submit" value="Consultar">
                      <input name="btnLimpiar" type="reset" value="Limpiar">
                    </div></td>
                </tr>
                <tr> 
                  <td colspan="6">&nbsp;</td>
                </tr>
			  <input name="tipo" type="hidden" value="<cfoutput>#url.tipo#</cfoutput>">
			  <input name="titulo" type="hidden" value="<cfoutput>#titulo#</cfoutput>">
              </form>
            </table>
		<cf_web_portlet_end>
<cf_templatefooter> 
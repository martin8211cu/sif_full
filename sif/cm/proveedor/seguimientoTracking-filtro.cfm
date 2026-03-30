<cf_templateheader title="Seguimiento de Embarque">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Seguimiento de Tracking de Embarque'>
		<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}

			function doConlisTrackings(valor) {
				popUpWindow("/cfmx/sif/cm/proveedor/ConlisTrackings.cfm?idx="+valor+"&validaEstado=0",30,100,950,500);
			}

			function limpiar() {
			}
		</script>
		
		<cfoutput>

		<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
		<form method="post" name="form1" action="seguimientoTracking.cfm" onSubmit="return Valida()"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				
				<tr>
					<td width="40%" valign="top">
						<table width="100%">
							<tr valign="top">
								<td valign="top">	
									<cf_web_portlet_start border="true" titulo="Consulta de Seguimiento de Tracking" skin="info1">
										<div align="justify">
										  <p>Esta consulta muestra la informaci&oacute;n relacionada al seguimiento de un tracking de embarque.</p>
								    </div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>  
					</td>
					<td width="60%" valign="top">
						<table width="100%" cellpadding="0" cellspacing="0" align="center">
							<tr>
								<td align="center" nowrap><div align="right"><strong>Tracking de Embarque:</strong>&nbsp; </div></td>
								<td colspan="3">
									<table width="100%" cellpadding="0" cellspacing="0">
										<td width="1%" nowrap>
											<input type="hidden" name="ETidtracking_move1" value="">
											<input type="text" size="10" name="ETconsecutivo_move1" value="" onblur="javascript:traeTracking(this.value,1); fm(this,-1)">
											<input type="text" size="40" readonly name="ETnumtracking_move1" value="" >
										</td>
										<td width="1%">&nbsp;<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisTrackings(1);'></a></td>
									</table>
								</td>
							</tr>
							<tr>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
							</tr>
							<tr>
							  <td colspan="4" align="center"><input type="submit" value="Consultar" name="Consultar" id="Consultar">
							    <input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
								</tr>
						</table>
					</td>
				</tr>
			</table>
		 </form>
		 </cfoutput>
<!------->
<script language="JavaScript" type="text/javascript">		 
	function Valida(){		
		if(document.form1.ETconsecutivo_move1.value == ''){
			alert("El campo Tracking de Embarque es requerido");
			return false;
		}	
	}
	function traeTracking(value, index){
	  if (value!=''){	   
	   document.getElementById("fr").src = 'traerTracking.cfm?todoEstado=1&ETconsecutivo='+value+'&index='+index;
	  }
	  else{
	   document.form1.ETidtracking_move1.value = '';
	   document.form1.ETconsecutivo_move1.value = '';
	   document.form1.ETnumtracking_move1.value = '';
	  }
	 }	 
</script>	
	

<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="10" width="10" scrolling="auto" src="" ></iframe>
 	
		<cf_web_portlet_end>
	<cf_templatefooter>


<!---*********************************
	Módulo    : Control de Reponsables
	Nombre   : Documento de Responsabilidad Vigente
	***********************************
	Hecho por: NA
	Creado    : NA
	***********************************
	Modificado por: Dorian Abarca Gómez
	Modificado: 18 Julio 2006
	Moficaciones:
	1. Se modifica para que se imprima y baje a excel con el cf_htmlreportsheaders.
	2. Se modifica para que se pinte con el jdbcquery.
	3. Se verifica uso de cf_templateheader y cf_templatefooter.
	4. Se verifica uso de cf_web_portlet_start y cf_web_portlet_end.
	5. Se agrega cfsetting y cfflush.
	6. Se envían estilos al head por medio del cfhtmlhead.
	7. Se mantienen filtros de la consulta.
	8. Se mofica conlis de placa por tag de sif_activo.
	***************************** --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Detalle de Placa">
  <cf_web_portlet_start titulo="Detalle de Placa">
    <cfflush interval="32">
	   <cfinclude template="/sif/portlets/pNavegacion.cfm">
	   <cfif not isdefined("form.btnConsultar")>
		   <iframe id="frameAplaca" name="frameAplaca" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="no"></iframe>
			<form action="InformacionPlacaRep.cfm" method="post" name="form1" >
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<td  valign="top"width="20%"> 
					  <cf_web_portlet_start border="true" titulo="Descripci&oacute;n" skin="info1">
					    <div align="center">
							<p align="justify">En este reporte se muestra información detallada de una placa  </p>
						 </div>
					   <cf_web_portlet_end> 
					 </td>
					 <td width="5%">&nbsp;</td>
					 <td width="75%">
					   <fieldset><legend>Filtros del Reporte</legend>
						<table width="100%" border="0">
						  <tr>
							<td>Placa :</td>
							<td>
								<input type="text" name="AplacaINI"value="" size="20" tabindex="3" onblur="javascript:traeAplacaINI(this.value);" />
								<input type="text" name="AdescripcionINI" value="" size="40" tabindex="-1" readonly />
								<a href="javascript:doConlisAplacaINI();" tabindex="-1"> 
									<img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Placas" name="imagenAplaca" width="18"height="14" border="0" align="absmiddle" /> 
								 </a>
							</td>
						</tr>
						<tr>
							<td colspan="4" align="center">
								<cf_botones values="Consultar,Limpiar" tabindex="1">
						</td>
					</tr>
			       </table>
				</td>
				</tr>
			</table> 
		</form> 
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms>
	<cf_qformsrequiredfield args="AplacaINI,Placa">
</cf_qforms>
<script language="javascript1.2" type="text/javascript">
	var popUpWinAplaca = null;
	document.form1.AplacaINI.focus();
	
	function popUpWindowAplaca(URLStr, left, top, width, height) {
		if(popUpWinAplaca) {
			if(!popUpWinAplaca.closed) popUpWinAplaca.close();
	  	}
	  	popUpWinAplaca = open(URLStr, 'popUpWinAplaca', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisAplacaINI(){
		var conlisArgs = 'form=form1&desc=AdescripcionINI&name=AplacaINI';
		popUpWindowAplaca('/cfmx/sif/Utiles/ConlisPlacaTodas.cfm?'+conlisArgs,250,200,650,550);
	}
	
	function traeAplacaINI(value){
		if (value!='')	{
			var conlisArgs = 'form=form1&desc=AdescripcionINI&name=AplacaINI&filtro_Aplaca=' + escape(value);
			document.getElementById('frameAplaca').src = '/cfmx/sif/Utiles/traePlacaTodas.cfm?'+conlisArgs;
		} else {
			document.form1.AplacaINI.value = '';
			document.form1.AdescripcionINI.value = '';
		}
	}	
</script>
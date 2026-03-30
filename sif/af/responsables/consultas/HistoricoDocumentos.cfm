<!---
Módulo      : Activos Fijos / Control de Responsables
Nombre      : Consulta Documentos por Placa.
Descripción : Muestra un reporte del histórico de documentos por estado y placa.
Hecho por   : Steve Vado Rodríguez
Creado      : 11/11/2005
Modificado  : 27/02/2006 Se dejará que busca sólo por placa y no por rango de placas, debido a problemas en el ICE.
Modificado  : 29/08/2006 por Randall Colomer en el ICE. Se modificó para que pueda mostrar todos los activos.	
 --->

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Documentos por Placa">
		<cfinclude template="../../../portlets/pNavegacion.cfm">				
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Documentos por Placa">
			<cfif not isdefined("form.btnConsultar")>
				<iframe id="frameAplaca" name="frameAplaca" 
					marginheight="0" 
					marginwidth="0" 
					frameborder="0" 
					height="0" 
					width="0" scrolling="no"></iframe>
				<form action="HistoricoDocumentosRep.cfm" method="post" name="form1" >
					<cfoutput>				  
					<table width="100%" border="0">
						<tr>
							<td  valign="top"width="34%"> <cf_web_portlet_start border="true" titulo="Documentos por Placa" skin="info1">
								<div align="center">
									<p align="justify">En este reporte se muestra una lista de documentos filtrada por la placa y estado. </p>
								</div>
								<cf_web_portlet_end> 
							</td>
							<td width="1%">&nbsp;</td>
							<td width="70%">
								<table width="100%" border="0">
									<tr>
										<td width="11%">Placa:</td>
										<td width="58%" nowrap>
											<input type="text" name="AplacaINI"
												value="" size="20" 
												tabindex="3"
												onblur="javascript:traeAplacaINI(this.value);" />
											<input type="text" name="AdescripcionINI"
												value="" size="40" 
												tabindex="-1"
												readonly />
											<a href="javascript:doConlisAplacaINI();" tabindex="-1"> 
												<img src="/cfmx/sif/imagenes/Description.gif"
													alt="Lista de Placas"
													name="imagenAplaca"
													width="18" 
													height="14"
													border="0" 
													align="absmiddle" /> 
											</a>		
											<!--- 
											<cf_sifactivo permitir_retirados="true" craf="true" crafpermiteinactivos="true" tabindex="1" name="AidINI" placa="AplacaINI" desc="AdescripcionINI"> 
											--->
										</td>
									</tr>
									<tr>
										<td>Estado:</td>
										<td colspan="2" nowrap>
										  <select name="estado" tabindex="1">
											<option value="">Todos</option>
											<option value="A">Activos</option>
											<option value="I">Inactivos</option>
											<option value="T">En Tr&aacute;nsito</option>
										  </select>										
										</td>
									</tr>
									<tr>
										<td colspan="4" align="center">
											<cf_botones values="Consultar,Limpiar" tabindex="1">
											<input type="hidden" value="0" name="errorFlag" id="errorFlag"/> 
										</td>
									</tr>
								</table>
							</td> 
						</tr>
					</table> 
					</cfoutput>
				</form> 
			</cfif>
			<cf_qforms>
				<cf_qformsrequiredfield args="AplacaINI,Placa">
			</cf_qforms>
		<cf_web_portlet_end>
	<cf_templatefooter> 

<script language="javascript1.2" type="text/javascript" >
	var popUpWinAplaca=null;
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
<!---
******************************************
Módulo    : Control de Reponsables
Nombre   : Reporte de Activos en Tránsito
******************************************
Hecho por: NA
Creado    : NA
******************************************
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
******************************************
Modificado por: Randall Colomer en el ICE
Modificado: 29 Agosto 2006
Modificaciones:
1. Se cambio el conlis de placas para que pueda mostrar todas las placas.
******************************************
--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		
		<cfif not isdefined("form.btnConsultar")>
			<iframe id="frameAplaca" name="frameAplaca" 
				marginheight="0" 
				marginwidth="0" 
				frameborder="0" 
				height="0" 
				width="0" scrolling="no"></iframe>
			<form action="HistoricoTransacRep.cfm" method="post" name="form1">
				<cfoutput>
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td  valign="top"width="20%"> 
							<cf_web_portlet_start border="true" titulo="Descripci&oacute;n" skin="info1">
								<div align="center">
									<p align="left">En este reporte se muestra el histórico de las transacciones realizadas para una placa en especial </p>
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
											<cfif isdefined("form.Aid") and len(trim(form.Aid)) gt 0>
												<cfquery name="rs" datasource="#session.dsn#">
													select Aid, Aplaca, Adescripcion 
													from Activos 
													where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
												</cfquery>
											</cfif>
											<cfif isdefined("rs") and rs.recordcount and len(trim(rs.Aid)) gt 0>
												<cf_sifactivo permitir_retirados="true" craf="true" crafpermiteinactivos="true" query="#rs#" >
											<cfelse>
												<cf_sifactivo permitir_retirados="true" craf="true" crafpermiteinactivos="true">
											</cfif>
											--->
										</td>
									</tr>
								</table>
								<cf_botones values="Consultar,Limpiar" >
							</fieldset>
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

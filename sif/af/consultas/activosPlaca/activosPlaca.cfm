<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<br />
			<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top">
					<table width="90%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="300">
								<cf_web_portlet_start border="true" titulo="Consulta de Activos por Placa" skin="info1">
									<p align="justify"> Esta consulta muestra la informaci&oacute;n completa de un 
																Activo Fijo, su historia y su estado actual. Muestra 
																adem&aacute;s de la informaci&oacute;n del Activo, 
																la histora de las depreciaciones, revaluaciones, mejoras y 
																retiros que ha recibido el Activo Fijo. 
									</p>
								<cf_web_portlet_end>
						  </td>
						</tr>
				  </table>
				</td>
				<td valign="top">
					<form name="form1" method="post" action="activosPlaca_sql.cfm">
						<table width="100%" border="0" cellspacing="2" cellpadding="2">
							<tr>
								<td class="fileLabel"><strong>Placa:</strong></td>
								<td colspan="3"><cf_sifactivo tabindex="1" permitir_retirados="true"></td>
							</tr>
						</table>
						<br />
						<fieldset><legend>Desde</legend>
							<table width="100%" border="0" cellspacing="2" cellpadding="2">
								<tr>
									<td class="fileLabel"><strong>Periodo:</strong></td>
									<td><cf_monto name="Periodoini" decimales="0" size="4" tabindex="1"></td>
									<td class="fileLabel"><strong>Mes:</strong></td>
									<td><cf_meses name="Mesini" todos="--Todos--" tabindex="1"></td>
								</tr>
							</table>
						</fieldset>
						<br />
						<fieldset><legend>Hasta</legend>
							<table width="100%" border="0" cellspacing="2" cellpadding="2"> 
								<tr>
									<td class="fileLabel"><strong>Periodo:</strong></td>
									<td><cf_monto name="Periodofin" decimales="0" size="4" tabindex="1"></td>
									<td class="fileLabel"><strong>Mes:</strong></td>
									<td><cf_meses name="Mesfin" todos="--Todos--" tabindex="1"></td>
								</tr>
							</table>
						</fieldset>
						<br />
						<cf_botones values="Consultar" tabindex="1">
					</form>
				</td>
			  </tr>
		  </table>
		  <cf_qforms>
		  <script language="javascript">
			<!--
				//validaciones con qforms
				//requiere el Aid
				objForm.Aid.description="Placa";
				objForm.Periodoini.description="Periodo Inicial";
				objForm.Periodofin.description="Periodo Final";
				objForm.Aid.required=true;
				function _validatePeriodos(){
					var vp1 = objForm.Periodoini.getValue();
					var vp2 = objForm.Periodofin.getValue();
					if (vp1>0&&(vp1<1900||vp1>2100)) objForm.Periodoini.throwError("El valor el Periodo Inicial debe ser mayor que 1900 y menor que 2100, o lo puede dejar en 0 inidicando que desea todos.");
					if (vp2>0&&(vp2<1900||vp2>2100)) objForm.Periodofin.throwError("El valor el Periodo Final debe ser mayor que 1900 y menor que 2100, o lo puede dejar en 0 inidicando que desea todos.");
				}
				objForm.onValidate=_validatePeriodos;
			-->
		  </script>
		  <br />
		<cf_web_portlet_end>
	<cf_templatefooter>

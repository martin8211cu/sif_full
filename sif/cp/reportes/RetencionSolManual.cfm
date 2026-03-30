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
					<form name="form1" method="post" action="RetencionSolManual_sql.cfm">
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
				objForm.Periodoini.description="Periodo Inicial";
				objForm.Periodofin.description="Periodo Final";
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

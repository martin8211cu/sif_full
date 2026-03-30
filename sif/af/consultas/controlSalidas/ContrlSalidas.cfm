<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<br />
			<cfoutput>
			<form name="form1" method="get" action="ContrlSalidas-list.cfm">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td nowrap colspan="2">&nbsp;</td></tr>
					<tr>
						<td valign="top" width="40%" align="center">
							<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
									<td>
										<cf_web_portlet_start border="true" titulo="Control de Salida y Entradas por Placa" skin="info1">
											<p align="justify">
											La Consulta de Control de Salidas le permite mostrar el histórico de las transacciones de salidas y entradas de los
											Activos Fijos. Se mostrará el detalle de la Salidas y Entrada de la placa seleccionada.
											</p>
										<cf_web_portlet_end>
									</td>
								</tr>
							</table>
						</td>

						<td valign="top" width="60%" align="center">
							<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
								<tr>
									<td class="fileLabel" align="right">Marca:</td>
									<td rowspan="2">
										<cf_sifmarcamod
											tabindexMar="1" tabindexMod="1"
											nameMar = AFMcodigo
						                    nameMod= AFMMcodigo
						                    keyMar = AFMid
						                    keyMod = AFMMid
						                    descMar = AFMdescripcion
						                    descMod = AFMMdescripcion
						                    altMar = Marca
						                    altMod = Modelo
						                    funcionMar = "funcModificarM"
						                    funcionMod = "funcModificarMod"
						                    Modificable = "true"
						                    orientacion = "V"
						               >
									</td>
								</tr>
								<tr>
								  <td class="fileLabel" align="right">Modelo:</td>
							  	</tr>
								<tr>
									<td class="fileLabel"align="right">Placa:</td>
									<td colspan="2"><cf_sifactivo tabindex="1" permitir_retirados="true"></td>
								</tr>
								<tr>
									<td class="fileLabel" align="right">Serie:</td>
								    <td colspan="2">
										<input type="text" name="Aserie" size="30" maxlength="50" tabindex="1">
									</td>
								</tr>
								<tr><td colspan="4">&nbsp;</td></tr>
								<tr>
									<td colspan="4" align="center">
										<cf_botones values="Consultar,Limpiar" tabindex="1">
									</td>
								</tr>
								<tr><td colspan="4">&nbsp;</td></tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="2" align="center" valign="top">&nbsp;</td></tr>
				</table>
			</form>
			</cfoutput>
	<script language="javascript1.2" type="text/javascript">

	</script>
		<cf_web_portlet_end>
	<cf_templatefooter>
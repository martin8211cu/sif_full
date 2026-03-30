<cfset headerBorderColor = "black">
<cfset headerBGColor = "##CCCCCC">

<script language="javascript" type="text/javascript">
	function generarReporte(puntos) {
		var width = 950;
		var height = 625;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		var params = '?RHASid=#rsDatosASalarial.RHASid#&puntos='+puntos+'&porcentaje=#rsDatosASalarial.RHASporcentaje#';
		</cfoutput>
		var nuevo = window.open('analisis-salarial2-rep.cfm'+params,'conlisASalarial','scrollbars=no,resizable=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
</script>

<cfset obj = CreateObject("component", "rh.Componentes.RH_AnalisisSalarial")>
<cftransaction>
	<cfset obj.GenerarTablasDispersion()>
	<cfset obj.GenerarDispersionSalarial(Form.RHASid, false)>
	<cfset query = obj.obtenerDatosNiveles(1)>
	<cfset query2 = obj.obtenerDatosNiveles(2)>
	<cfset query3 = obj.obtenerDatosEmpresa(1)><!--- TRAE LOS DATOS DE SALARIOS DE LA EMPRESA --->
	<cfset query4 = obj.obtenerDatosEncuesta(1)><!--- TRAE LOS DATOS DE LA ENCUESTA --->
</cftransaction>

<cfoutput>
	<form name="form1" method="post" style="margin: 0; ">
		<cfinclude template="analisis-salarial2-hiddens.cfm">
		<cfif query.recordCount>
			<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  	<tr>
					<td valign="top" align="center">
						<cfchart format = "flash" chartWidth = "500" chartheight = "300" showYGridlines = "yes" font = "Arial"
							fontSize = "10" fontBold = "no" fontItalic = "no" labelFormat = "number" xAxisTitle = "PUNTOS HAY"
							yAxisTitle = "SALARIO" showLegend = "yes" xaxistype="scale" yaxistype="scale"
							url = "javascript: generarReporte('$ITEMLABEL$');" sortxaxis="yes" markersize="4">
							<cfchartseries type="line" query="query" valuecolumn="MedioMenosPorcen" itemcolumn="PunMedios" serieslabel="Mínimo HAY" markerstyle="mcross">
							<cfchartseries type="line" query="query3" valuecolumn="LTsalario" itemcolumn="PunMedios" serieslabel="Empresa"  markerstyle="mcross">
							<cfchartseries type="line" query="query" valuecolumn="Medio" itemcolumn="PunMedios" serieslabel="Medio HAY" markerstyle="mcross">
							<cfchartseries type="line" query="query4" valuecolumn="SalReferencia" itemcolumn="PunMedios" serieslabel="Mercado" markerstyle="mcross">
							<cfchartseries type="line" query="query" valuecolumn="MedioMasPorcen" itemcolumn="PunMedios" serieslabel="Máximo HAY" markerstyle="mcross">
						</cfchart>
					</td>
					<td valign="top">
						<a onClick="javascript: generarReporte(1);" style="cursor:hand;">Ver Reporte</a>
					</td>
				</tr>
			  <!--- <cfif query2.recordCount>
			  <tr>
				<td colspan="2">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td rowspan="2" align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">Nivel</td>
						<td colspan="3" align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#;">Puntos</td>
						<td colspan="3" align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#;">Salario</td>
						<td rowspan="2" align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">Traslape</td>
						<td rowspan="2" align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">Amplitud</td>
						<td colspan="2" align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-right: 1px solid #headerBorderColor#;">y = mx + b </td>
					  </tr>
					  <tr>
						<td align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">min</td>
						<td align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">medio = x </td>
						<td align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">max</td>
						<td align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">medio - 25% </td>
						<td align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">medio = y </td>
						<td align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">medio + 25 % </td>
						<td align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">m</td>
						<td align="center" style="background-color: #headerBGColor#; font-weight: bold; border-top: 1px solid #headerBorderColor#; border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#; border-right: 1px solid #headerBorderColor#;">b</td>
					  </tr>
					  <cfloop query="query2">
					  <tr onClick="javascript: generarReporte('#query2.PunMedios#');" onMouseOver="javascript: this.style.cursor = 'pointer';">
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.Nivel))>#query2.Nivel#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.minimo))>#query2.minimo#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.PunMedios))>#query2.PunMedios#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.maximo))>#query2.maximo#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.MedioMenosPorcen))>#LSNumberFormat(query2.MedioMenosPorcen, ',9.000')#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.Medio))>#LSNumberFormat(query2.Medio, ',9.000')#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.MedioMasPorcen))>#LSNumberFormat(query2.MedioMasPorcen, ',9.000')#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.Traslape))>#LSNumberFormat(query2.Traslape, ',9.000')#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.Amplitud))>#LSNumberFormat(query2.Amplitud, ',9.000')#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.m))>#LSNumberFormat(query2.m, ',9.0000')#<cfelse>&nbsp;</cfif>
						</td>
						<td align="center" style="border-left: 1px solid #headerBorderColor#; border-bottom: 1px solid #headerBorderColor#; border-right: 1px solid #headerBorderColor#;">
							<cfif Len(Trim(query2.b))>#LSNumberFormat(query2.b, ',9.0000')#<cfelse>&nbsp;</cfif>
						</td>
					  </tr>
					  </cfloop>
					</table>
				</td>
			  </tr>
			  </cfif> --->
			  <tr><td colspan="2">&nbsp;</td></tr>
			</table>
		<cfelse>
			<p align="center" style="font-variant:small-caps">
				<strong>el reporte no devolvi&oacute; ning&uacute;n resultado</strong>
			</p>
		</cfif>
	</form>
</cfoutput>


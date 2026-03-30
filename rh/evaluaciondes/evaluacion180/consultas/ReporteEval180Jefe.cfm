<cfdocument format="#url.formato#" 
			marginleft="2" 
			marginright="2" 
			marginbottom="2"
			margintop="1" 
			unit="cm" 
			pagetype="letter">
	<cfdocumentitem type="footer">
		<table border="0" align="center" cellpadding="0" cellspacing="0" width="100%">
		 <tr>
			<td align="right" valing="top"  style="font-size:12px; font-family: Times New Roman; font-weight: normal;">
				<cfoutput><cf_translate key="LB_Pagina">P&aacute;gina</cf_translate>#cfdocument.currentpagenumber# <cf_translate key="LB_De">de</cf_translate>#cfdocument.totalpagecount#</cfoutput>
			</td>
		  </tr>
	  </table>
	</cfdocumentitem>		
	
	<cfoutput query="rsREporte" group="Empleado">
		<table width="100%" cellpadding="3" cellspacing="0" border="0" bgcolor="E3EDEF">
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center" style="font-size:14px; font-family: Times New Roman; font-weight: normal;">#session.Enombre#</td></tr>
			<tr><td align="center" style="font-size:14px; font-family: Times New Roman; font-weight: normal;">Hoja de Retroalimentaci&oacute;n</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		<table width="100%" cellpadding="3" cellspacing="0" border="0">
			<tr><td colspan="4" >&nbsp;</td></tr>
			<tr>
				<td width="25%" align="right" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;"><strong>Nombre de la Persona:</strong>&nbsp;&nbsp;&nbsp;</td>
				<td width="25%" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;">#Empleado#</td>
				<td width="25%" align="right" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;"><strong>Departamento:</strong>&nbsp;&nbsp;&nbsp;</td>
				<td width="25%" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;">#Departamento#</td>
			</tr>
			<tr>
				<td width="25%" align="right" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;"><strong>Unidad de Negocio/Apoyo:</strong>&nbsp;&nbsp;&nbsp;</td>
				<td width="25%" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;">#CentroFuncional#</td>
				<td width="25%" align="right" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;"><strong>Puesto:</strong>&nbsp;&nbsp;&nbsp;</td>
				<td width="25%" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;">#Puesto#</td>
			</tr>
			<tr>
				<td width="25%" align="right" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;"><strong>Fecha de Evaluaci&oacute;n:</strong>&nbsp;&nbsp;&nbsp;</td>
				<td width="25%" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;">Del #LSDateFormat(REdesde,'dd/mm/yyyy')# Al #LSDateFormat(REhasta,'dd/mm/yyyy')#</td>
				<td width="25%" align="right" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;"><strong>Fecha:</strong>&nbsp;&nbsp;&nbsp;</td>
				<td width="25%" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;">#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
			</tr>
			<tr>
				<td width="25%" align="right" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;"><strong>Nombre de la Evaluaci&oacute;n:</strong>&nbsp;&nbsp;&nbsp;</td>
				<td width="25%" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;">#REdescripcion#</td>
				<td width="25%" align="right" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;"><strong>Jefe:</strong>&nbsp;&nbsp;&nbsp;</td>
				<td width="25%" valign="top" style="font-size:10px; font-family: Times New Roman; font-weight: normal;">#Evaluador#</td>
			</tr>
			<tr><td colspan="4" >&nbsp;</td></tr>
		</table>
		
 		<cfoutput group="Tipo">
			<table width="100%" cellpadding="3" cellspacing="0" border="0">
				<tr bgcolor="CCCCCC"><td colspan="3" style="font-size:12px; font-family: Times New Roman; font-weight: normal;"><strong>#Tipo#</strong></td></tr>
				<tr>
					<td width="33%" style="font-size:12px; font-family: Times New Roman; font-weight: normal;"><strong>Concepto Evaluado</strong></td>
					<td width="33%" style="font-size:12px; font-family: Times New Roman; font-weight: normal;"><strong>Autoevaluaci&oacute;n</strong></td>
					<td width="33%" style="font-size:12px; font-family: Times New Roman; font-weight: normal;"><strong>Evaluaci&oacute;n</strong></td>
				</tr>
				<cfoutput>
				<tr>
					<td width="33%" valign="top" style="font-size:12px; font-family: Times New Roman; font-weight: normal;">#IAEpregunta#</td>
					<td width="33%" valign="top" style="font-size:12px; font-family: Times New Roman; font-weight: normal;">#respuestaE#</td>
					<td width="33%" valign="top" style="font-size:12px; font-family: Times New Roman; font-weight: normal;">#respuestaJ#</td>
				</tr> 
				</cfoutput>
				<tr><td colspan="3">&nbsp;</td></tr>
			</table>
		</cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr><td>&nbsp;</td></tr>
			<tr bgcolor="CCCCCC"><td style="font-size:12px; font-family: Times New Roman; font-weight: normal;"><strong>Logros Obtenidos</strong></td></tr>
		</table>
		<cfdocumentitem type="pagebreak"/>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr bgcolor="CCCCCC"><td colspan="3" style="font-size:12px; font-family: Times New Roman; font-weight: normal;"><strong>Retos y Planes de Acci&oacute;n</strong></td></tr>
		</table>
		<cfdocumentitem type="pagebreak"/>
		<table width="100%" cellpadding="0" cellspacing="3" border="0">
			<tr bgcolor="CCCCCC">
				<td width="50%" style="font-size:12px; font-family: Times New Roman; font-weight: normal;"><strong>Inter&eacute;s Profesional</strong></td>
				<td width="50%" style="font-size:12px; font-family: Times New Roman; font-weight: normal;"><strong>Referencias Laborales</strong></td>
			</tr>
			<tr>
				<td style="font-size:12px; font-family: Times New Roman; font-weight: normal; border-style:solid; border-width:0.001cm;">
					Estar&iacute;a dispuesto en seguir ascendiendo dentro de la organizaci&oacute;n?<br>Si______  No______
					<br><br><br><br>
					En cual &aacute;rea o departamento se ve a futuro ?
					<br><br><br><br>
					Por qu&eacute; esa &aacute;rea o deptartamento ?
					<br><br><br><br>
					En que puesto especificamente? <br>
					&nbsp;<br>
					&nbsp;<br>
					&nbsp;<br>
					&nbsp;<br>
				</td>
				<td valign="top" style="font-size:12px; font-family: Times New Roman; font-weight: normal; border-style:solid; border-width:0.001cm;">Indique en que &aacute;rea / puesto ve usted a esta persona evaluada y por qu&eacute; lo recomienda ?</td>
			</tr>
		</table>
		<cfdocumentitem type="pagebreak"/>
	</cfoutput>
	

</cfdocument>
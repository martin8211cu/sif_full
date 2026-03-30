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
								<cf_web_portlet_start border="true" titulo="Consulta de Movimientos de TAGs" skin="info1">
									<p align="justify"> Esta consulta muestra los movimientos realizados por un dispositivo (TAG) en un rango de fechas determinado.
									</p>
								<cf_web_portlet_end>
						  </td>
						</tr>
				  </table>
				</td>
				<td valign="top">
					<form name="form1" method="post" action="QPConsultaMov_SQL.cfm" onsubmit="return validar(this);">
						<table width="100%" border="0" cellspacing="2" cellpadding="2">
							<tr>
								<td align="right"><strong>TAG:</strong></td>
	                        <cfset valuesArray = ArrayNew(1)>
								<td colspan="3"><cfinclude template="QPconlisTag.cfm"></td>
							</tr>
							<tr>
								<td align="right"><strong>Fecha Desde:</strong></td>
								<td>
									<cfset QPLfechaD = DateFormat(Now(),'dd/mm/yyyy')>
									<cf_sifcalendario form="form1" value="#QPLfechaD#" name="QPLfechaD" tabindex="1">
								</td>
							</tr>
							<tr>
								<td align="right"><strong>Fecha Hasta:</strong></td>
								<td>
									<cfset QPLfechaH = DateFormat(Now(),'dd/mm/yyyy')>
									<cf_sifcalendario form="form1" value="#QPLfechaH#" name="QPLfechaH" tabindex="1">
								</td>
							</tr>							
						</table>
						
						<cf_botones values="Consultar" tabindex="1">
					</form>
				</td>
			  </tr>
		  </table>
				<cf_qforms form="form1">
					<cf_qformsrequiredfield args="QPTidTag,Tag">
				</cf_qforms>	
					
			<cfoutput>
			<script language="javascript1" type="text/javascript">
				function fnFechaYYYYMMDD (LvarFecha)
					{
						return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
					}
				
				function validar(formulario)
				{
						var error_input;
						var error_msg = '';
				
					if (fnFechaYYYYMMDD(document.form1.QPLfechaD.value) > fnFechaYYYYMMDD(document.form1.QPLfechaH.value)
					& fnFechaYYYYMMDD(document.form1.QPLfechaH.value) != '')
					{
						alert ("La Fecha Hasta no puede ser menor a la Fecha Desde");
						return false;
					}
					else
					{ return true;
					}
				}    
			</script>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>
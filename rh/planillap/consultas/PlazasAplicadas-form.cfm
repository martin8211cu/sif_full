<SCRIPT SRC="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<cfoutput>
	<form method="post" name="form1" action="PlazasAplicadas-SQL.cfm">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			<td width="50%">
				<table width="100%">
					<tr>
						<td height="173" valign="top">	
							<cf_web_portlet_start border="true" titulo="Plazas Solicitadas" skin="info1">
							<div align="justify">
								<p>En &eacute;ste reporte 
								muestra las solicitudes de las plazas solicitadas a partir de una fecha, ordenada por: Centro Funcional, Usuario, Puesto Presupuestario.</p>
							</div>
							<cf_web_portlet_end>
						</td>
					</tr>
				</table>  
			</td>
			<td width="50%" valign="top">
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td width="61%"><strong>Centro Funcional:</strong></td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td align="left" nowrap colspan="2"><cf_rhcfuncional tabindex="1"></td>
					<td width="2%" colspan="3" align="center">&nbsp;</td>
				</tr>
				<tr>
					<td><strong>Puesto Presupuestario:</strong></td>
					<td colspan="2">&nbsp;</td>
				</tr>		
				<tr>
					<td align="left">
						<cf_conlis 
						campos="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
						desplegables="N,S,S"
						size="0,10,60"
						modificables="N,S,N"
						title="Lista de Puestos"
						tabla="RHMaestroPuestoP"
						columnas="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
						filtro=" Ecodigo = #session.Ecodigo# order by RHMPPcodigo,RHMPPdescripcion"
						filtrar_por="RHMPPcodigo,RHMPPdescripcion"
						desplegar="RHMPPcodigo,RHMPPdescripcion"
						etiquetas="C&oacute;digo,Descripci&oacute;n"
						formatos="S,S"
						align="left,left"
						asignar="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
						asignarFormatos="S,S,S"
						form="form1"
						showEmptyListMsg="true"
						EmptyListMsg=" --- No se encontraron Puestos --- "/> 
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>	
				<tr>
					<td><strong>Solicitante:</strong></td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td align="left">
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
						<cfset filtroRH = " and mp.RHMPPid = #form.RHMPPid#">
						<cfelse>
						<cfset filtroRH = " ">
						</cfif>
						<cf_sifusuario form="form1">
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>			
				<tr>
					<td colspan="3"><table width="100%"><tr>
					<td width="43%"><strong>Fecha desde:</strong></td>
					<td width="57%"><strong>Fecha hasta:</strong></td>
					</tr></table></td>
				</tr>	
				<tr>
					<td colspan="3"><table width="100%"><tr>
					  <td width="43%"><cf_sifcalendario tabindex="4" name="fdesde" value=""></td>
					  <td width="57%"><cf_sifcalendario tabindex="5" name="fhasta" value=""></td>
					</tr></table></td>
				</tr>
				<tr>
					<td colspan="3"><table width="100%"><tr>
					<td width="43%"><strong>No.Solicitud desde:</strong></td>
					<td width="57%"><strong>No.Solicitud hasta:</strong></td>
					</tr></table></td>
				</tr>
				<tr>
					<td colspan="3"><table width="100%"><tr>
					<td width="43%"><input type="text" name="RHSPconsecutivo_desde" value="" size="10"/></td>
					<td width="57%"><input type="text" name="RHSPconsecutivo_hasta" value="" size="10"/></td>
					</tr></table></td>
				</tr>
				<tr>
					<td><strong>Formato:</strong></td>
					<td colspan="2">&nbsp;</td>
				</tr>	
				<tr>
					<td>
						<select name="formato">
							<option value="FlashPaper">FlashPaper</option>
							<option value="pdf">Adobe PDF</option>
							<option value="Excel">Microsoft Excel</option>
						</select>
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td align="center" colspan="3">
						<input type="submit" value="Generar" name="Reporte">&nbsp;
						<input type="reset" name="Limpiar" value="Limpiar">
					</td>
				</tr>
			</table>
			</td>
		</tr>
		</table>
	</form>
	</cfoutput>

<!---*******************************************
*******Sistema Financiero Integral**************
*******Gestión de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<cfoutput>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">		
  <tr>
	<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
	<td class="tituloListas">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloListas" align="left" valign="bottom"><strong>Periodo:</strong>&nbsp;</td>
			<td class="tituloListas" align="left" valign="bottom">
				<strong>#form.GATPeriodo#</strong>
			</td>
		  </tr>
		</table>
	</td>
	<td class="tituloListas">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloListas" align="left" valign="bottom"><strong>Mes:</strong>&nbsp;</td>
			<td class="tituloListas">
				<cfloop query="rsMeses">
					<cfif value eq Form.GATMes><strong>#description#</strong></cfif>
				</cfloop>
			</td>
		  </tr>
		</table>
	</td>
	<td class="tituloListas">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloListas" align="left" valign="bottom"><strong>Concepto:</strong>&nbsp;</td>
			<td class="tituloListas">
				<cfloop query="rsConceptos">
					<cfif value eq Form.Cconcepto><strong>#description#</strong></cfif>
				</cfloop>
			</td>
		  </tr>
		</table>
	</td>
	<td class="tituloListas">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloListas" align="left" valign="bottom"><strong>Documento:</strong>&nbsp;</td>
			<td class="tituloListas">
				<strong>#form.Edocumento#</strong>
			</td>
		  </tr>
		</table>
	</td>
</tr>
</table>
</cfoutput>
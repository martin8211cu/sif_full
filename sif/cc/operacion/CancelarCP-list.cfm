<!---
	Autor: Eduardo Gonzalez Sarabia
	Fecha: 11/10/2018
	Proceso: Lista de complementos de pago generados,
	         Se muestran unicamente los que se registraron en las tablas HEFavor y HDFavor

 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','Cancelaci&oacute;n de Complementos de Pago')>
<cfset LB_Complemento = t.Translate('LB_Complemento','Complemento')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Total = t.Translate('LB_Total','Total')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha')>
<cfset LB_Regenerado = t.Translate('LB_Regenerado','Regenerado')>

<!--- QUERYS --->
<cfquery name="getInfoHEFavor" datasource="#session.dsn#">
	SELECT he.idHEfavor,
	       he.CCTcodigo,
	       he.NombreComplemento,
	       sn.SNnombre,
	       he.CCTcodigo,
	       RTRIM(LTRIM(he.Ddocumento)) AS Ddocumento,
	       m.Mnombre,
	       he.EFtotal,
	       he.EFfecha,
	       CASE
	          WHEN Regenerado = 1 THEN 'Si'
	          ELSE 'No'
	       END AS Regenerado
	FROM HEFavor he
	INNER JOIN SNegocios sn ON sn.Ecodigo = he.Ecodigo AND sn.SNcodigo = he.SNcodigo
	INNER JOIN FA_CFDI_Emitido em ON em.Ecodigo = he.Ecodigo
	AND RTRIM(LTRIM(em.DocPago)) = RTRIM(LTRIM(he.Ddocumento))
	AND RTRIM(LTRIM(CONCAT(Serie,Folio,'_',DocPago))) = RTRIM(LTRIM(he.NombreComplemento))
	AND RTRIM(LTRIM(em.NombreDoctoGenerado)) = RTRIM(LTRIM(he.NombreComplemento))
	INNER JOIN Monedas m ON m.Mcodigo = he.Mcodigo AND m.Ecodigo = he.Ecodigo
	WHERE he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  AND he.Cancelado = 0
	<cfif isDefined("form.txtFilComplemento") AND #LEN(form.txtFilComplemento)#>
		AND UPPER(he.NombreComplemento) LIKE '%#UCASE(form.txtFilComplemento)#%'
	</cfif>
	<cfif isDefined("form.txtFilDocumento") AND #LEN(form.txtFilDocumento)#>
		AND UPPER(he.Ddocumento) LIKE '%#UCASE(form.txtFilDocumento)#%'
	</cfif>
	<cfif isDefined("form.SNcodigo") AND #LEN(form.SNcodigo)#>
		AND sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfif>
	ORDER BY he.EFfecha DESC
</cfquery>

<cf_templateheader title="#LB_Titulo#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<form style="margin:0" action="CancelarCP-list.cfm" method="post" name="form1">
			<!--- HIDDEN --->
			<input name="datos" type="hidden" value="">
			<!--- Tabla Complementos Emitidos --->
			<cfoutput>
				<br>
				<!--- TABLA FILTROS --->
				<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td><strong>Complemento:&nbsp;</strong></td>
						<td><input type="text" name="txtFilComplemento"></td>
						<td><strong>Documento:&nbsp;</strong></td>
						<td><input type="text" name="txtFilDocumento"></td>
						<td><strong>Socio:&nbsp;</strong></td>
						<td><cf_sifsociosnegocios2 form="form1" SNcodigo="SNcodigo" tabindex="1" SNumero="SNumero" SNdescripcion="SNdescripcion"></td>
						<td><input type="submit" class="btnFiltrar" name="filtrar" value="Filtrar"></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
				<!--- TABLA ENCABEZADOS --->
				<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr class="tituloListas">
	                  <td width="2%">&nbsp;</td>
	                  <td nowrap><strong>#LB_Complemento#</strong></td>
	                  <td nowrap><strong>#LB_Documento#</strong></td>
	                  <td nowrap align="center"><strong>#LB_Transaccion#</strong></td>
	                  <td nowrap><strong>#LB_Socio#</strong></td>
	                  <td nowrap align="center"><strong>#LB_Moneda#</strong></td>
	                  <td nowrap align="center"><strong>#LB_Total#</strong></td>
	                  <td nowrap align="center"><strong>#LB_Fecha#</strong></td>
	                  <!--- <td nowrap align="center"><strong>#LB_Regenerado#</strong></td> --->
	                </tr>
	                <cfloop query="getInfoHEFavor">
						<tr <cfif getInfoHEFavor.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>
						  	onMouseOver="javascript: style.color = 'red'"
							onMouseOut="javascript: style.color = 'black'"
							 style="cursor: pointer;">
							<td width="5%">&nbsp;</td>
							<td nowrap="nowrap" onClick="javascript:Editar('#getInfoHEFavor.idHEfavor#|#getInfoHEFavor.Mnombre#');">
								#getInfoHEFavor.NombreComplemento#
							</td>
							<td nowrap="nowrap" onClick="javascript:Editar('#getInfoHEFavor.idHEfavor#|#getInfoHEFavor.Mnombre#');">
								#getInfoHEFavor.Ddocumento#
							</td>
							<td nowrap="nowrap" onClick="javascript:Editar('#getInfoHEFavor.idHEfavor#|#getInfoHEFavor.Mnombre#');" align="center">
								#getInfoHEFavor.CCTcodigo#
							</td>
							<td nowrap="nowrap" onClick="javascript:Editar('#getInfoHEFavor.idHEfavor#|#getInfoHEFavor.Mnombre#');">
								#getInfoHEFavor.SNnombre#
							</td>
							<td nowrap="nowrap" onClick="javascript:Editar('#getInfoHEFavor.idHEfavor#|#getInfoHEFavor.Mnombre#');" align="center">
								#getInfoHEFavor.Mnombre#
							</td>
							<td nowrap="nowrap" align="right" onClick="javascript:Editar('#getInfoHEFavor.idHEfavor#|#getInfoHEFavor.Mnombre#');">
								#LSNumberFormat(getInfoHEFavor.EFtotal,',9.00')#
							</td>
							<td nowrap="nowrap" align="center" onClick="javascript:Editar('#getInfoHEFavor.idHEfavor#|#getInfoHEFavor.Mnombre#');">
								#dateformat(getInfoHEFavor.EFfecha, "dd/mm/yyyy")#
							</td>
							<!--- <td nowrap="nowrap" onClick="javascript:Editar('#getInfoHEFavor.idHEfavor#|#getInfoHEFavor.Mnombre#');" align="center">
								#getInfoHEFavor.Regenerado#
							</td> --->
						</tr>
					</cfloop>
				</table>
				<br><br><br>
			</cfoutput>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>



<cfoutput>
<script language="JavaScript1.2">
	function Editar(data) {
		if (data!="") {
			document.form1.action='CancelarCP-form.cfm';
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}
</script>
</cfoutput>
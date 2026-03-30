<cfquery name="rsSQL" datasource="#Session.DSN#">
	select OCCid, OCCcodigo, OCCdescripcion
	  from OCconceptoCompra
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and OCCcodigo = '00'
</cfquery>
<cfif rsSQL.OCCid EQ "">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		insert into OCconceptoCompra
			(Ecodigo,OCCcodigo, OCCdescripcion)
		values(#session.Ecodigo#,'00','PRODUCTO EN TRANSITO')
	</cfquery>
<cfelseif rsSQL.OCCdescripcion NEQ "PRODUCTO EN TRANSITO">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		update OCconceptoCompra
		   set OCCdescripcion = 'PRODUCTO EN TRANSITO'
		 where OCCid = #rsSQL.OCCid#
	</cfquery>
</cfif>
<cf_templateheader title="Conceptos de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conceptos de Compra'>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr> 
					<td width="40%" valign="top" nowrap>
						<fieldset>
						<legend>Lista de Conceptos de Compra&nbsp;</legend>
							<table width="90%"  border="0" cellspacing="2" cellpadding="0">
								<tr> 
									<td valign="top" nowrap>
										<cfinvoke 
											component="sif.Componentes.pListas"
											method="pListaRH"
											returnvariable="pListaRet"
												tabla="OCconceptoCompra"
												columnas="OCCid,OCCcodigo,OCCdescripcion"
												desplegar="OCCcodigo,OCCdescripcion"
												etiquetas="Código,Descripci&oacute;n"
												formatos="S,S"
												filtro="Ecodigo = #Session.Ecodigo# order by OCCcodigo"
												align="left, left"
												ajustar="N,N"
												checkboxes="N"
												MaxRows="15"
												filtrar_automatico="true"
												mostrar_filtro="true"												
												keys="OCCid"
												irA="OCconceptosCompra.cfm"
												showEmptyListMsg="true">
										</cfinvoke>
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
					<td width="5%" valign="top" nowrap>&nbsp;</td>
					<td width="55%" valign="top" nowrap>
						<fieldset>
						<legend>Mantenimiento de Conceptos de Compra&nbsp;</legend>
							<table width="90%"  border="0" cellspacing="2" cellpadding="0">
								<tr> 
									<td valign="top" nowrap>
										<cf_navegacion name="OCCid" default="" navegacion="">
										<cfinclude template="formOCconceptosCompra.cfm">
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr><td colspan="3">&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>


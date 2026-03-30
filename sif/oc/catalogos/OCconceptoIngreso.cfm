<cfquery name="rsSQL" datasource="#Session.DSN#">
	select OCIid, OCIcodigo, OCIdescripcion
	  from OCconceptoIngreso
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and OCIcodigo = '00'
</cfquery>
<cfif rsSQL.OCIid EQ "">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		insert into OCconceptoIngreso
			(Ecodigo,OCIcodigo, OCIdescripcion, CFcomplementoIngreso)
		values(#session.Ecodigo#,'00','PRODUCTO EN TRANSITO', '001')
	</cfquery>
<cfelseif rsSQL.OCIdescripcion NEQ "PRODUCTO EN TRANSITO">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		update OCconceptoIngreso
		   set OCIdescripcion = 'PRODUCTO EN TRANSITO'
		 where OCIid = #rsSQL.OCIid#
	</cfquery>
</cfif>
<cf_templateheader title="Conceptos de Ingreso">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conceptos de Ingreso'>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr> 
					<td width="40%" valign="top" nowrap>
						<fieldset>
						<legend>Lista de Conceptos de Ingreso&nbsp;</legend>
							<table width="90%"  border="0" cellspacing="2" cellpadding="0">
								<tr> 
									<td valign="top" nowrap>
										<cfinvoke 
											component="sif.Componentes.pListas"
											method="pListaRH"
											returnvariable="pListaRet"
												tabla="OCconceptoIngreso"
												columnas="OCIid,OCIcodigo,OCIdescripcion"
												desplegar="OCIcodigo,OCIdescripcion"
												etiquetas="Código,Descripci&oacute;n"
												formatos="S,S"
												filtro="Ecodigo = #Session.Ecodigo# order by OCIcodigo"
												align="left, left"
												ajustar="N,N"
												checkboxes="N"
												MaxRows="15"
												filtrar_automatico="true"
												mostrar_filtro="true"												
												keys="OCIid"
												irA="OCconceptoIngreso.cfm"
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
						<legend>Mantenimiento de Conceptos de Ingreso&nbsp;</legend>
							<table width="90%"  border="0" cellspacing="2" cellpadding="0">
								<tr> 
									<td valign="top" nowrap>
										<cf_navegacion name="OCIid" default="" navegacion="">
										<cfinclude template="OCconceptoIngreso_form.cfm">
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


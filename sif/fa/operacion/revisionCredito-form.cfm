<cfquery name="rsCliente" datasource="#session.DSN#">
	select 	a.CDid 
	from VentaE a
		inner join ClienteDetallista b
			on a.CDid = b.CDid
	where a.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
</cfquery>
<cfset form.CDid = rsCliente.CDid>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form name="form1" method="post" action="revisionCredito-sql.cfm" autocomplete="off">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
		</tr>
		
		<tr>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<!--- Datos Personales del Cliente --->
					<tr>
						<td class="subTitulo" align="center">
							<strong><font size="2">Datos Personales del Cliente</font></strong>
						</td>
					</tr>
					<tr>
						<td><cfinclude template="revisionCredito-personal.cfm"></td>
					</tr>
					<!--- Datos de la Factura Presente del Cliente --->
					<tr>
						<td class="subTitulo" align="center">
							<strong><font size="2">Datos de la Factura Presente</font></strong>
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td><cfinclude template="revisionCredito-factPrese.cfm"></td>
								</tr>
							</table>
						</td>
					</tr>
					<!--- Aprobacion o Rechazo del Crédito del Cliente --->
					<tr>
						<td class="subTitulo" align="center">
							<strong><font size="2">Aprobaci&oacute;n o Rechazo de Cr&eacute;dito</font></strong>
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td><cfinclude template="revisionCredito-aprobar.cfm"></td>
								</tr>
							</table>
						</td>
					</tr>
					<!--- Datos de Facturas Canceladas y Pendientes del Cliente --->
					<tr>
						<td class="subTitulo" align="center">
							<strong><font size="2">Datos de las Facturas Canceladas y Pendientes</font></strong>
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td width="50%"><cfinclude template="revisionCredito-cancelada.cfm"></td>
									<td width="50%"><cfinclude template="revisionCredito-pendiente.cfm"></td>
								</tr>
							</table>
						</td>
					</tr>
					<!--- Datos del Estudio de Crédito del Cliente --->
					<tr>
						<td class="subTitulo" align="center">
							<strong><font size="2">Datos del Estudio Cr&eacute;dito del Cliente</font></strong>
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td><cfinclude template="revisionCredito-estudio.cfm"></td>
									<td>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
					<!--- Fin de todos los include --->
				</table>
			</td>
		</tr>
		
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		
	</table>
</form>
</cfoutput>

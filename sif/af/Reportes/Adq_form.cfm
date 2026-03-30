<!--- 
	Creado por Gustavo Fonseca H.
		Motivo: Nueva consulta para exportación a Excel del módulo de Activos Fijos.
		Fecha:16-5-2006.
 --->

<cfif not isdefined("url.imprimir") >
	<cf_templateheader template="#session.sitio.template#">
</cfif>

<!--- Encabezado del reporte --->
<style type="text/css">
	.titulox {
		padding: 2px; 
		font-size:12px;
	}
</style> 
<cfheader name="Content-Disposition" value="inline; filename=Adquisiciones.xls">
<cfcontent type="application/vnd.msexcel">
<cfoutput>
	<cfset mes = 'Enero,Febrero,marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align="center" colspan="2"><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
		</tr>
		<tr>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align="center" colspan="2"><strong>Reporte de Adquisiciones</strong></td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>		
		</tr>
		<tr>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align="center" colspan="2"><strong>Per&iacute;odo:&nbsp;</strong>#url.periodoInicial#</td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
		</tr>	
		<tr>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align="right"><strong>Mes Inicial:&nbsp;</strong>#listGetAt(mes,url.mesInicial)#</td>
			<td align="left"><strong>Mes Final:&nbsp;</strong>#listGetAt(mes,url.mesFinal)#</td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
		</tr>	
	</table>
</cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<!--- Adquisicion --->
			<cfinclude template="Adq_sql.cfm">
		</td>
	</tr>
</table>
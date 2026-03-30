<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsAFTFHojaConteo" datasource="#session.dsn#">
	select AFTFdescripcion_hoja, AFTFfecha_hoja, AFTFestatus_hoja
	from AFTFHojaConteo
	where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AFTFid_hoja#">
</cfquery>

<cfsavecontent variable="qryLista">
	<cfoutput>
		Select Aplaca, Aserie, Adescripcion,
			b.CFcodigo #_Cat# ' - ' #_Cat# b.CFdescripcion as CentroFuncional, 
			c.DEidentificacion #_Cat#' - ' #_Cat# c.DEapellido1 #_Cat# ' ' #_Cat# c.DEapellido2 #_Cat# ' '#_Cat# c.DEnombre as EmpleadoResponsable,
			<cfif (rsAFTFHojaConteo.AFTFestatus_hoja lt 2)>
				'_____' as Estado,
				'_______________________' as Observacion
			<cfelse>
				case AFTFbanderaproceso
					when 0 then 'Sin Definir'
					when 1 then 'Normal'
					when 2 then 'No Contado'
					when 3 then 'Contado + de 1'
					when 4 then 'Agregado a la hoja'
				end as Estado,
				d.CFcodigo #_Cat# ' - ' #_Cat# d.CFdescripcion as NuevoCentroFuncional, 
				e.DEidentificacion #_Cat# ' - ' #_Cat# e.DEapellido1 #_Cat# ' ' #_Cat# e.DEapellido2 #_Cat# ' ' #_Cat# e.DEnombre as NuevoEmpleadoResponsable
			</cfif>
		from AFTFDHojaConteo a
			left outer join CFuncional b
			on b.CFid = a.CFid
			left outer join DatosEmpleado c
			on c.DEid = a.DEid
			<cfif not (rsAFTFHojaConteo.AFTFestatus_hoja lt 2)>
			left outer join CFuncional d
			on d.CFid = a.CFid_lectura
			left outer join DatosEmpleado e
			on e.DEid = a.DEid_lectura
			</cfif>
		where AFTFid_hoja = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFTFid_hoja#">
		order by EmpleadoResponsable,Aplaca
	</cfoutput>
</cfsavecontent>

<cfhtmlhead text="
<style type='text/css'>
td {  font-size: xx-small; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
a {
	text-decoration: none;
	color: ##000000;
}
.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}	.tituloSub {  font-weight: bolder; text-align: center; vertical-align: middle; font-size: small; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.tituloListas {

	font-weight: bolder;
	vertical-align: middle;
	padding: 2px;
	background-color: ##F5F5F5;
}
</style>">

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr><td width="10%" nowrap><cfif (rsAFTFHojaConteo.AFTFestatus_hoja lt 2)>Estados Posibles:</cfif>&nbsp;</td><td width="80%" nowrap class="tituloSub" align="center">Lista de Dispositivos M&oacute;viles</td><td width="10%" align="right" nowrap>Fecha emisi&oacute;n: #LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;</td></tr>
	  <tr><td width="10%" nowrap><cfif (rsAFTFHojaConteo.AFTFestatus_hoja lt 2)>1 = Normal</cfif>&nbsp;</td><td width="80%" nowrap class="tituloSub" align="center">#Session.Enombre#</td><td width="10%" align="right" nowrap>&nbsp;</td></tr>
	  <tr><td width="10%" nowrap><cfif (rsAFTFHojaConteo.AFTFestatus_hoja lt 2)>2 = No Contado</cfif>&nbsp;</td><td width="80%" nowrap class="tituloSub" align="center">Descripción: #rsAFTFHojaConteo.AFTFdescripcion_hoja#</td><td width="10%" align="right" nowrap>&nbsp;</td></tr>
	  <tr><td width="10%" nowrap><cfif (rsAFTFHojaConteo.AFTFestatus_hoja lt 2)>3 = Contado + 1</cfif>&nbsp;</td><td width="80%" nowrap class="tituloSub" align="center">Fecha: #LSDateFormat(rsAFTFHojaConteo.AFTFfecha_hoja,'dd/mm/yyyy')#</td><td width="10%" align="right" nowrap>&nbsp;</td></tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="tituloListas">
			<td nowrap>Placa&nbsp;</td>
			<td nowrap>Descripci&oacute;n&nbsp;</td>
			<td nowrap>Serie&nbsp;</td>
			<td nowrap>Centro Funcional&nbsp;</td>
			<td nowrap>Empleado Responsable&nbsp;</td>
			<td nowrap>Estado&nbsp;</td>
			<cfif (rsAFTFHojaConteo.AFTFestatus_hoja lt 2)>
			<td nowrap>Observaci&oacute;n&nbsp;</td>
			<cfelse>
			<td nowrap>Nuevo C. Funcional&nbsp;</td>
			<td nowrap>Nuevo Empleado&nbsp;</td>
			</cfif>
		</tr>
</cfoutput>

<cftry>
	<!--- Empieza a pintar el reporte en el usuario cada 512 bytes los bytes que toma en cuenta son de aquí en adelante omitiendo lo que hay antes, y la informació de los headers de la cantidad de bytes --->
	<cfflush interval="512">
	<cf_jdbcquery_open name="rsLista" datasource="#session.DSN#">
		<cfoutput>#qryLista#</cfoutput>
	</cf_jdbcquery_open>
	<cfset class  = "">
	<cfoutput query="rsLista">
		<cfif class neq "listaNon">
			<cfset class = "listaNon">
		<cfelse>
			<cfset class = "listaPar">
		</cfif>
		<tr class="#class#">
			<td nowrap>&nbsp;#Aplaca#</td>
			<td nowrap>&nbsp;#Adescripcion#</td>
			<td nowrap>&nbsp;#Aserie#</td>
			<td nowrap>&nbsp;#CentroFuncional#</td>
			<td nowrap>&nbsp;#EmpleadoResponsable#</td>
			<td nowrap>&nbsp;#Estado#</td>
			<cfif (rsAFTFHojaConteo.AFTFestatus_hoja lt 2)>
			<td nowrap>&nbsp;#Observacion#</td>
			<cfelse>
			<td nowrap>&nbsp;#NuevoCentroFuncional#</td>
			<td nowrap>&nbsp;#NuevoEmpleadoResponsable#</td>
			</cfif>
		</tr>
	</cfoutput>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfrethrow>
	</cfcatch>
</cftry>
<cf_jdbcquery_close>

<cfoutput>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr><td>&nbsp;</td><td nowrap align="center"><strong>--Fin del Reporte--</strong></td><td>&nbsp;</td></tr>
	</table>
</cfoutput>


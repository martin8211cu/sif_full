<cfoutput>
<cfset Titulo = "Boleta de Pago: " & RCalculoNomina.RCDescripcion><!--- Para que le quite el Nombre del Empleado --->
<html>
<head>
<title>#Titulo#</title>
</head>
<body>
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left: 5px; padding-right: 5px;">
	<tr style="padding: 3px;">
		<td nowrap align="center"><font size="4"><b>#rsEmpresa.Edescripcion#</b></font>
		</td>
	</tr>
</table>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left: 5px; padding-right: 5px;">
	<tr bgcolor="##EEEEEE" style="padding: 3px;">
		<td nowrap align="center"><font size="3"><b>#Titulo#</b></font>
		</td>
	</tr>
</table>

<cfif isdefined('Arguments.DEid')>
	<cfquery name="rsEncabEmpleado" datasource="#session.dsn#">
		select (DEapellido1 + ' ' + DEapellido2 + ', ' + DEnombre) as nombreEmpl, DEidentificacion, NTIdescripcion
		from DatosEmpleado de, NTipoIdentificacion ti
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and de.NTIcodigo=ti.NTIcodigo
	</cfquery>
</cfif>

<cfset Titulo = Titulo & ": " & rsEncabEmpleado.nombreEmpl & ".">

<!--- Encabezado con los datos del empleado --->
<cfif isdefined('rsEncabEmpleado')>
  <cfoutput> 
	<table width="100%" border="0" cellspacing="6" cellpadding="6">
	  <tr>
		<td nowrap valign="top">
			<table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0" style = "font-family: Verdana, Arial, Helvetica, sans-serif;	border: 1px solid ##000000;">
			  <tr> 
				<td nowrap colspan="2" align="center" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-weight: bold;background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;">Informaci&oacute;n del Empleado</td>
			  </tr>
			  <tr> 
				<td nowrap width="33%" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Nombre completo</td>
				<td nowrap width="67%">#rsEncabEmpleado.nombreEmpl#</td>
			  </tr>
			  <tr> 
				<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">#rsEncabEmpleado.NTIdescripcion#</td>
				<td>#rsEncabEmpleado.DEidentificacion#</td>
			  </tr>
		  </table>		
		</td>
	  </tr>
	</table>
  </cfoutput> 
</cfif>


<br>
<!--- ========================= Informacion de la Nómina ========================= ---> 
<table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
	<tr>
		<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" align="right">
			Tipo de Nómina :&nbsp;
		</td>
		<td nowrap  align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">
			#RCalculoNomina.Tdescripcion#
		</td>
		<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" align="right">
			Pago :&nbsp;
		</td>
		<td nowrap  align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">
			#LSDateFormat(RCalculoNomina.CPfpago,'dd/mm/yyyy')#
		</td>
		<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" align="right">
			Desde :&nbsp;
		</td>
		<td nowrap  align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">
			#LSDateFormat(RCalculoNomina.RCdesde,'dd/mm/yyyy')#
		</td>
		<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" align="right">
			Hasta :&nbsp;
		</td>
		<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">
			#LSDateFormat(RCalculoNomina.RChasta,'dd/mm/yyyy')#
		</td>
	</tr>
</table>
<br>


<!--- ========================= Informacion Resumida ========================= ---> 
<table width="97%" border="0" cellspacing="0" cellpadding="0" style = "font-family: Verdana, Arial, Helvetica, sans-serif;	border: 1px solid ##000000; padding-left: 5px; padding-right: 5px;" align="center">
	<tr><td nowrap colspan="8" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-weight: bold;background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;"><div align="center"><font size="2">Informaci&oacute;n
			Resumida</font></div></td></tr>
	<tr>
		<td nowrap colspan="8">

			<cfquery name="rsSalarioEmpleado" datasource="#session.dsn#">
				select 	SEsalariobruto, SEincidencias, SErenta, SEcargasempleado, 
				SEcargaspatrono,  SEdeducciones, SEliquido
				from SalarioEmpleado 
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			</cfquery>

				<cfif rsSalarioEmpleado.RecordCount gt 0 >
					<tr>
						<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Salario Bruto:&nbsp;</div></td>
						<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Incidencias:&nbsp;</div></td>
						<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Renta:&nbsp;</div></td>
						<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Cargas Empleado:&nbsp;</div></td>
						<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Deducciones:&nbsp;</div></td>
						<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Salario Líquido:&nbsp;</div></td>
					</tr>
	
					<tr>
						<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto,'none')#</td>
						<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEincidencias,'none')#</td>
						<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')#</td>
						<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')#</td>
						<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')#</td>
						<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEliquido,'none')#</td>
					</tr>
					<cfelse>
					<tr><td nowrap colspan="6" align="center">No hay Pagos asociados al empleado</td></tr>
				</cfif>	
		</td>
	</tr>
</table>
<!--- ========================= Informacion Resumida - FIN ========================= ---> 
<br>
  <table width="97%" border="0" cellspacing="0" cellpadding="0" style = "font-family: Verdana, Arial, Helvetica, sans-serif;	border: 1px solid ##000000; padding-left: 5px; padding-right: 5px;" align="center">
	<tr><td nowrap colspan="8" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-weight: bold;background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;"><div align="center"><font size="2">Informaci&oacute;n
			Detallada</font></div></td></tr>

	<!--- ======================= Salarios ======================== --->
	<cfquery name="rsPagosEmpleado" datasource="#session.dsn#">
		set nocount on
		declare @dias float
		
		select @dias = <cf_dbfunction name="to_float" args="FactorDiasSalario">
		from TiposNomina t, RCalculoNomina r
		where t.Ecodigo = r.Ecodigo
		  and t.Tcodigo = r.Tcodigo
		  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  
		select @dias = coalesce(@dias, <cf_dbfunction name="to_float" args="Pvalor">)
		from RHParametros 
		where Pcodigo = 80 --Numero de días para el Calculo de la Nomina Mensual
	
		select 	a.PEdesde, a.PEhasta, a.PEsalario, 
				PEdiario = round((a.PEsalario/@dias),2),
				a.PEcantdias, a.PEmontores, a.PEtiporeg, b.RHTcodigo
		from PagosEmpleado a, RHTipoAccion b 
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RHTid=b.RHTid
		order by a.PEdesde, a.PEhasta
		set nocount off
	</cfquery>

	<cfquery name="rsPagosEmpleado_0" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 0
	</cfquery>
	<cfquery name="rsPagosEmpleado_1" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 1
	</cfquery>
	<cfquery name="rsPagosEmpleado_2" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 2
	</cfquery>

	<tr><td nowrap colspan="8" style="font-weight: bolder;text-align: center;vertical-align: middle;padding: 2px;	background-color: ##DFDFDF;">Salarios</td></tr>

	<cfif rsPagosEmpleado_0.RecordCount gt 0>
		<tr>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Fecha Desde</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Fecha Hasta</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">C&oacute;digo Acci&oacute;n</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Salario</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Salario Diario</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">D&iacute;as</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
		</tr>
	
		<cfloop query="rsPagosEmpleado_0">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#RHTcodigo#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#PEcantdias#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
			</tr>
		</cfloop>
	<cfelse>		
		<tr><td nowrap colspan="8" align="center"><b>No hay Pagos asociados al empleado</b></td></tr>
	</cfif>
	<!--- ======================= Salarios - FIN ======================== --->
	
	 <!--- ======================= Retroactivos - INI ======================== --->
	<cfif rsPagosEmpleado_1.RecordCount GT 0>
		<tr>
			<td nowrap colspan="8" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-style: normal;font-weight: bold;background-image: url(/cfmx/rh/imagenes/p_ocean.gif);background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;color: ##FFFFFF;"><div align="center"><strong>Retroactivos Recalculados</strong></div></td>
		</tr>
		<cfloop query="rsPagosEmpleado_1">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#RHTcodigo#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" >#PEcantdias#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" >&nbsp;</td>
			</tr>
		</cfloop>
	</cfif>
	<cfif rsPagosEmpleado_2.RecordCount gt 0>
		<tr>
			<td nowrap colspan="8" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-style: normal;font-weight: bold;background-image: url(/cfmx/rh/imagenes/p_ocean.gif);background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;color: ##FFFFFF;"><div align="center"><strong>Retroactivos ya Pagados</strong></div></td>
		</tr>
		<cfloop query="rsPagosEmpleado_2">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">b#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">v#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">c#RHTcodigo#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">b#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">b#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">f#PEcantdias#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">y#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
			</tr>
		</cfloop>
	</cfif>
	 <!--- ======================= Retroactivos - FIN ======================== --->

	<!--- ======================= Incidencias ======================== --->
	<tr valign="top"> 
	  <td nowrap colspan="8">&nbsp;</td>
	</tr>
	<cfquery name="rsIncidenciasCalculo" datasource="#session.dsn#">
		select ICid, b.CIdescripcion, a.ICfecha, a.ICvalor, a.ICmontores, a.ICcalculo
		from IncidenciasCalculo a, CIncidentes b
		where a.CIid = b.CIid
		and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		order by b.CIcodigo
	</cfquery>

	<tr><td nowrap colspan="8" style="font-weight: bolder;text-align: center;vertical-align: middle;padding: 2px;	background-color: ##DFDFDF;">Incidencias</td></tr>
	
	<cfif rsIncidenciasCalculo.RecordCount gt 0>
		<tr> 
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Fecha</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" colspan="3">Concepto</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" >&nbsp;</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Valor</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
		</tr>
		<cfloop query="rsIncidenciasCalculo">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif> > 
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
				<td nowrap align="left" colspan="3" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#CIdescripcion#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#ICvalor#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(ICmontores,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;"><cfif ICcalculo eq 1><img border="0" src="http://websdc/cfmx/rh/imagenes/Cferror.gif"></cfif></td>
			</tr>
		</cfloop>
	<cfelse>		
		<tr><td nowrap colspan="8" align="center"><b>No hay Incidencias asociadas al Empleado</b></td></tr>
	</cfif>
	<!--- ======================= Incidencias - FIN ======================== --->

	<!--- ======================= Cargas ======================== --->

	<tr valign="top"> 
	  <td nowrap colspan="8">&nbsp;</td>
	</tr>

	<cfquery name="rsCargasCalculo" datasource="#session.dsn#">
		select a.DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto
		from CargasCalculo a, DCargas b, ECargas c
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and a.DClinea = b.DClinea
		  and b.ECid = c.ECid
	</cfquery>

	<tr><td nowrap colspan="8" style="font-weight: bolder;text-align: center;vertical-align: middle;padding: 2px;	background-color: ##DFDFDF;">Cargas</td></tr>

	<cfif rsCargasCalculo.RecordCount gt 0>
		<tr>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" colspan="4">Descripci&oacute;n</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto Patrono</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto Empleado</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
		</tr>
		<cfloop query="rsCargasCalculo">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" colspan="4" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#DCdescripcion#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvalorpat,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvaloremp,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
			</tr>
		</cfloop>
	<cfelse>		
		<tr><td nowrap colspan="8" align="center"><b>No hay Cargas asociadas al Empleado</b></td></tr>
	</cfif>
	<!--- ======================= Cargas - FIN ======================== --->

	<!--- ======================= Deducciones ======================== --->
	<tr valign="top"> 
	  <td nowrap colspan="8">&nbsp;</td>
	</tr>

	<cfquery name="rsDeduccionesCalculo" datasource="#session.dsn#">
		select  a.Did, a.DCvalor, a.DCinteres, a.DCcalculo, b.Ddescripcion, b.Dvalor, b.Dmetodo, b.Dreferencia
		from DeduccionesCalculo a, DeduccionesEmpleado b
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.Did = b.Did
	</cfquery>

	<tr><td nowrap colspan="8" style="font-weight: bolder;text-align: center;vertical-align: middle;padding: 2px;	background-color: ##DFDFDF;">Deducciones</td></tr>

	<cfif rsDeduccionesCalculo.RecordCount gt 0 >
		<tr>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" colspan="4">Descripci&oacute;n</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Referencia</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Valor</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto Resultante</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
		</tr>
	
		<cfloop query="rsDeduccionesCalculo">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" colspan="4" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#Ddescripcion#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#Dreferencia#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;"><cfif Dmetodo neq 0>#rsMoneda.Msimbolo# #LSCurrencyFormat(Dvalor,'none')#<cfelse>#LSCurrencyFormat(Dvalor,'none')# %</cfif></td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(DCvalor,'none')#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;"><cfif DCcalculo eq 1><img border="0" src="http://websdc/cfmx/rh/imagenes/Cferror.gif"></cfif> </td>
			</tr>
		</cfloop>
	<cfelse>		
		<tr><td nowrap colspan="8" align="center"><b>No hay Deducciones asociadas al Empleado</b></td></tr>
	</cfif>
	<!--- ======================= Deducciones - FIN ======================== --->	
	
	<tr valign="top"><td nowrap colspan="8">&nbsp;</td></tr>
  </table>
  <br>
  <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left: 5px; padding-right: 5px;">
	<tr bgcolor="##EEEEEE" style="padding: 3px;">
		<td nowrap align="center"><font size="3"><b>----- Fin de #Titulo# -----</b></font>
		</td>
	</tr>
  </table>
  <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left: 5px; padding-right: 5px;">
	<tr style="padding: 3px;">
		<td nowrap align="center"><font size="1">
			Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda este mensaje.
		</font>
		</td>
	</tr>
  </table>
  </body>
</html>
</cfoutput>	

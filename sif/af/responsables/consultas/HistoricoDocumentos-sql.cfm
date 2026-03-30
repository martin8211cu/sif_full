<!------------------------------------------------------ 
	Consultas
------------------------------------------------------>
<cf_dbfunction name="now" returnvariable="hoy">
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select
		C.Aplaca as placa,
		C.Adescripcion as descPlaca,
		D.DEidentificacion as cedula,
		<cf_dbfunction name="concat" args="D.DEnombre ,' ' ,D.DEapellido1,' ',D.DEapellido2"> as nombre,
		E.CRCCdescripcion as CC,
		F.ACdescripcion AS Categoria,
		G.ACdescripcion as Clase,
		C.Afechainidep as FI

	from AFTResponsables A
		inner join AFResponsables B on 
			A.AFRid = B.AFRid
		inner join Activos C on 
			B.Aid = C.Aid and
			B.Ecodigo = C.Ecodigo
		inner join DatosEmpleado D on 
			B.DEid 	= D.DEid and 
			B.Ecodigo = D.Ecodigo
		left outer join CRCentroCustodia E on
			B.Ecodigo = E.Ecodigo and 
			B.CRCCid  = E.CRCCid
		left outer join ACategoria F on
			C.Ecodigo = F.Ecodigo and
			C.ACcodigo = F.ACcodigo
		left outer join AClasificacion G on
			C.Ecodigo = G.Ecodigo and
			C.ACcodigo = G.ACcodigo and
			C.ACid = G.ACid
		left outer join CRDocumentoResponsabilidad H on
			B.AFRid = H.AFRid and
			B.B.Ecodigo = H.Ecodigo
			

	where B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

	<!--- Rango de Placas ---> 
	<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
		and C.Aplaca >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.APlacaIni#">
	</cfif>
	<cfif isdefined("form.APlacaFin") and len(trim(form.APlacaFin))>
		and C.Aplaca <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.APlacaFin#">
	</cfif>
	
	<!--- Estado --->
	<cfif isdefined("form.estado") and len(trim(form.estado))>
		<cfif form.estado eq 2>
			and C.Afechainidep <= #hoy#
		<cfelseif form.estado eq 3>
			and C.Afechainidep >= #hoy#
		<cfelseif form.estado eq 4>
			and not H.AFRid is null
		</cfif>
	</cfif>	
	
	Order By C.Aplaca
</cfquery>

<!------------------------------------------------------ 
	Configuración de Parámetros
------------------------------------------------------>
<cfset estadoD = " Todos">
<cfset placaInicial  = " No Definida">
<cfset placaFinal    = " No Definida">
<cfset placaInicialD = " ">
<cfset placaFinalD   = " ">

<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
	<cfset placaInicial  = " " & form.APlacaIni>
	<cfset placaInicialD = " (" & form.ADescripcionIni & ")">	
</cfif>
<cfif isdefined("form.APlacaFin") and len(trim(form.APlacaFin))>
	<cfset placaFinal  = " " & form.APlacaFin>
	<cfset placaFinalD = " (" & form.ADescripcionFin & ")">	
</cfif>
<cfif isdefined("form.estado") and len(trim(form.estado))>
	<cfif form.estado eq 2>
		<cfset estadoD = " Activos">
	<cfelseif form.estado eq 3>
		<cfset estadoD = " Inactivos">	
	<cfelseif form.estado eq 4>
		<cfset estadoD = " En Tr&Aacute;nsito">
	</cfif>
</cfif>


<cfset MaxLineasReporte = 30>

<!--- Se Pinta el Encabezado del Reporte cuando es invocado --->
<cfsavecontent variable="encabezado">
	<cfoutput>
		<tr><td align="center" colspan="12"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
		<tr><td align="center" colspan="12"><font size="2"><strong>Documentos por Placa</strong></font></td></tr>
		<tr><td align="center" colspan="12"><hr></td></tr>	
		<tr>
			<td align="left" bgcolor="##CCCCCC"><strong>Placa: </strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Descripci&oacute;n: </strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>C&eacute;dula: </strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Nombre: </strong></td>
			<td align="center" bgcolor="##CCCCCC"><strong>Centro Custodia: </strong></td>
			<td align="center" bgcolor="##CCCCCC"><strong>Categor&iacute;a: </strong></td>
			<td align="center" bgcolor="##CCCCCC"><strong>Clase: </strong></td>
			<td align="center" bgcolor="##CCCCCC"><strong>Fecha Ingreso: </strong></td>
		</tr>
		<tr><td align="center" colspan="8"><hr></td></tr>
	</cfoutput>
</cfsavecontent>

<!--- Se Pinta el Detalle del Reporte cuando es invocado--->
<cfsavecontent variable="reporte">
	<cfoutput>
		<cfif rsReporte.recordcount gt 0>
			<cfset corte = "">
			<cfset contador = 0>
			
			<cfloop query="rsReporte">
				<cfif contador mod MaxLineasReporte EQ 0 and rsReporte.currentRow NEQ 1>
					<!--- Corte de Pagina --->
					<tr class="pageEnd"><td colspan="8" nowrap>&nbsp;</td></tr>
					<!--- Encabezado --->
					#encabezado#
				</cfif>
				<tr>				
					<td align="right" ><font size="1" face="Courier New, Courier, mono">#placa#</font></td>
					<td align="right" ><font size="1" face="Courier New, Courier, mono">#descPlaca#</font></td>
					<td align="right" ><font size="1" face="Courier New, Courier, mono">>#cedula#</font></td>
					<td align="right" ><font size="1" face="Courier New, Courier, mono">#nombre#</font></td>
					<td align="right" ><font size="1" face="Courier New, Courier, mono">#CC#</font></td>
					<td align="right" ><font size="1" face="Courier New, Courier, mono">#Categoria#</font></td>
					<td align="right" ><font size="1" face="Courier New, Courier, mono">#Clase#</font></td>
					<td align="right" ><font size="1" face="Courier New, Courier, mono">#LSDateFormat("#FI#","dd/mm/yyyy")#</font></td>
				</tr>
				<cfset contador = contador + 1 >
			</cfloop>
		<cfelse>
			<tr><td align="center" colspan="8">&nbsp;</td></tr>
			<tr><td align="center" colspan="8"><strong> --- La consulta no gener&oacute; ning&uacute;n resultado. --- </strong></td></tr>
		</cfif>
	</cfoutput>
</cfsavecontent>

<!--- Se Pinta el Reporte Completo--->
<cfoutput>
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
		#encabezado#
		#reporte#
		<tr><td align="center" colspan="8">&nbsp;</td></tr>
		<tr><td colspan="8" nowrap align="center"><strong> --- Fin de la Consulta --- </strong></td></tr>
	</table>
</cfoutput>

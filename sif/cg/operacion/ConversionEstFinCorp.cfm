<cfset LobjCorp				= createObject("component","sif.Componentes.CG_EstadosFinancieros")>
<cfset LvarParametros		= LobjCorp.fnParametrosCorp(LvarB15)>
<cfset LvarCtasNivUtilidad	= LvarParametros.LvarCtasNivUtilidad>
<cfset LvarMesFiscal		= LvarParametros.LvarMesFiscal>
<cfset LvarMesCorporativo	= LvarParametros.LvarMesCorporativo>
<cfset LvarFechaArranque	= LvarParametros.LvarFechaArranque>

<cfif LvarFechaArranque NEQ "">
	<cfset LvarFechaArranque = LSparseDateTime(LvarFechaArranque)>
	<cfset LvarMesCerrado = datepart("m",dateadd("m",-1,LvarFechaArranque))>
<cfelse>
	<cfset LvarMesCerrado = 0>
</cfif>

<cfif LvarMesCerrado EQ LvarMesCorporativo>
	<cfreturn>
</cfif>

<cfif LvarMesCorporativo EQ 12>
	<cfset LvarMesInicio = 1>
<cfelse>
	<cfset LvarMesInicio = LvarMesCorporativo + 1>
</cfif>

<cfsetting requesttimeout="36000">

<cfquery datasource="#session.dsn#">
	update Parametros 
	   set Pvalor = ''
	 where Ecodigo = #session.Ecodigo#
	<cfif LvarB15>
	   and Pcodigo = 49
	<cfelse>
	   and Pcodigo = 48
	</cfif>
</cfquery>

<cfquery name="rsPer" datasource="#session.dsn#">
	select distinct Speriodo, Smes
	  from SaldosContablesConvertidos
	 where Ecodigo = #session.Ecodigo#
	<cfif LvarB15>
	   and B15		> 0
	<cfelse>
	   and B15		= 0
	</cfif>
	 order by 1,2
</cfquery>
<cfif rsPer.recordCount EQ 0>
	<cfreturn>
</cfif>
<table id="tablePer">
	<tr>
		<td colspan="10"><strong>Proceso de Arranque de Saldos Convertidos Corporativos<cfif LvarB15> (B-15)</cfif></strong></td>

	</tr>
	<cfoutput>
	<tr>
		<td colspan="10">Mes de Cierre Fiscal = #LvarMesFiscal#, Mes de Cierre Corporativo= #LvarMesCorporativo#</td>
	</tr>
	</cfoutput>
	<cfif LvarMesCorporativo EQ LvarMesFiscal>
		<tr>
			<td colspan="10">El Periodo Corporativo corresponde al Periodo Fiscal, por tanto únicamente se copian los saldos fiscales a los corporativos</td>
		</tr>
	<cfelse>
		<tr>
			<td colspan="10">El Periodo Corporativo es diferente al Periodo Fiscal, por tanto se recalculan los saldos de las Cuentas de Ingresos y Gastos y de la Cuenta de Utilidad</td>
		</tr>
		<tr>
			<td colspan="10">a partir del Primer mes del primer periodo corporativo que se encuentre</td>
		</tr>
	</cfif>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><strong>Periodo-Mes</strong></td>
		<td><strong>Status</strong></td>
	</tr>
<cfset LvarMesArranque = 0>
<cfset LvarAnoArranque = 0>
<cfset LvarPerNuevo = rsPer.Speriodo>
<cfset LvarMesNuevo = rsPer.Smes>
<cfset LvarFaltan = false>
<cfloop query="rsPer">
	<cfset LvarAnoMesProceso = rsPer.Speriodo*100+rsPer.Smes>

	<tr>
		<cfoutput>
		<td>#rsPer.Speriodo#-#numberFormat(rsPer.Smes,"00")#</td>
		</cfoutput>
	<cfif LvarAnoMesProceso NEQ LvarPerNuevo*100+LvarMesNuevo>
		<td><strong><font color="#FF0000">FALTAN SALDOS CONVERTIDOS</font></strong></td>
		<cfset LvarFaltan = true>
		<cfset LvarPerNuevo = rsPer.Speriodo>
		<cfset LvarMesNuevo = rsPer.Smes>
		<cfset LvarAnoMesFaltan = rsPer.Speriodo*100+rsPer.Smes>
	<cfelseif LvarMesArranque EQ 0 AND (rsPer.Smes EQ LvarMesInicio OR LvarMesCorporativo EQ LvarMesFiscal)>
		<td>OK <strong>Arranque de Saldos Convertidos Corporativos</strong></td>
		<cfset LvarMesArranque = rsPer.Smes>
		<cfset LvarAnoArranque = rsPer.Speriodo>
	<cfelseif LvarMesArranque EQ 0>
		<td>Antes de Arranque de Saldos Convertidos Corporativos (Saldos Corporativos en cero)</td>
	<cfelse>
		<td>OK</td>
	</cfif>
	</tr>

	<cfset LvarMesNuevo = (rsPer.Smes MOD 12) + 1>
	<cfif LvarMesNuevo eq 1>
		<cfset LvarPerNuevo = rsPer.Speriodo + 1>
	<cfelse>
		<cfset LvarPerNuevo = rsPer.Speriodo>
	</cfif>

	<cfset LobjCorp.sbCalculaSaldoCorp (LvarB15, rsPer.Speriodo, rsPer.Smes, LvarParametros, LvarAnoArranque, LvarMesArranque, LvarFaltan)>
</cfloop>

<cfset LvarFechaArranque = "">
<cfif LvarFaltan>
	<cfloop query="rsPer">
		<cfset LvarAnoMesProceso = rsPer.Speriodo*100+rsPer.Smes>
		<cfif LvarAnoMesProceso EQ LvarAnoMesFaltan>
			<cfbreak>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update SaldosContablesConvertidos
			   set SLinicialGE = 0,
				   SOinicialGE = 0
			 where Ecodigo = #session.Ecodigo#
			   and Speriodo = #rsPer.Speriodo#
			   and Smes		= #rsPer.Smes#
			<cfif LvarB15>
			   and B15		> 0
			<cfelse>
			   and B15		= 0
			</cfif>
		</cfquery>
	</cfloop>
	<tr>
		<td colspan="10">
			<font color="#FF0000">
				<strong>Existen datos inconsistentes que deben ser solucionados para poder continuar</strong>
			</font>
		</td>
	</tr>
<cfelseif LvarMesArranque EQ 0 AND LvarMesNuevo EQ LvarMesInicio>
	<cfquery datasource="#session.dsn#">
		update Parametros 
		   set Pvalor = '01/#numberFormat(LvarMesNuevo,"00")#/#LvarPerNuevo#'
		 where Ecodigo = #session.Ecodigo#
		<cfif LvarB15>
		   and Pcodigo = 49
		<cfelse>
		   and Pcodigo = 48
		</cfif>
	</cfquery>
	<cfoutput>
	<tr>
		<td>#LvarPerNuevo#-#numberFormat(LvarMesNuevo,"00")#</td>
		<td>OK <strong>Arranque de Saldos Convertidos Corporativos</strong></td>
	</tr>
	</cfoutput>
<cfelseif LvarMesArranque EQ 0>
	<tr>
		<td colspan="10">
			<strong>No se ha llegado al Inicio del primer Periodo Corporativo</strong>
		</td>
	</tr>
	<tr>
		<td colspan="10">
			Se volverá a intentar encontrar el inicio del primer Periodo Corporativo durante la próxima Conversión de Estados Financieros
		</td>
	</tr>
<cfelse>
	<cfquery datasource="#session.dsn#">
		update Parametros 
		   set Pvalor = '01/#numberFormat(LvarMesArranque,"00")#/#LvarAnoArranque#'
		 where Ecodigo = #session.Ecodigo#
		<cfif LvarB15>
		   and Pcodigo = 49
		<cfelse>
		   and Pcodigo = 48
		</cfif>
	</cfquery>
	<tr>
		<td colspan="10">
			<strong>El Arranque de los Saldos Convertidos Corporativos se ejecutó con éxito</strong>
		</td>
	</tr>
	<tr>
		<td colspan="10">
			Ya no se volverá a ejecutar este proceso mientras no se cambie el Mes de Cierre del Periodo Corporativo
		</td>
	</tr>
</cfif>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="10">
			<input type="button" value="Continuar" onclick="document.getElementById('tablePer').style.display='none';document.getElementById('divTCs').style.display='';"/>
		</td>
	</tr>
</table>
<script language="javascript">
	window.setTimeout("document.getElementById('divTCs').style.display='none';",1)
</script>

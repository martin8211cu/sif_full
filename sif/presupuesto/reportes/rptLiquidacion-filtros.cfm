<!--- ************************************************************* --->
<!---  				EXTRAE EL PERIODO POR DEFECTO 					--->
<!--- ************************************************************* --->
	<cfquery name="rsPeriodos" datasource="#Session.DSN#">
		select CPPid
		from CPresupuestoPeriodo p
		where p.Ecodigo = #Session.Ecodigo#
		  and p.CPPestado <> 0
	</cfquery>

	<cfparam name="form.CPPid"	default="#rsPeriodos.CPPid#">
	<cfset session.CPPid = form.CPPid>
<!--- ************************************************************* --->
<!---  				RS DEL COMBO DE ORIGENES 					    --->
<!--- ************************************************************* --->
	<cfquery name="rsORigenes" datasource="#Session.DSN#">
		select Oorigen,Odescripcion from Origenes
	</cfquery>
    
    <cfinclude template="../../Utiles/sifConcat.cfm">
<!--- ************************************************************* --->
<!---  				RS DEL COMBO DE MESES       					--->
<!--- ************************************************************* --->
	<cfquery name="rsMeses" datasource="#session.dsn#">
		select a.CPCano, a.CPCmes,
				<cf_dbfunction name="to_char" datasource="sifControl" args="a.CPCano"> #_Cat# ' - ' #_Cat#
				case a.CPCmes
					when 1 then 'Enero'
					when 2 then 'Febrero'
					when 3 then 'Marzo'
					when 4 then 'Abril'
					when 5 then 'Mayo'
					when 6 then 'Junio'
					when 7 then 'Julio'
					when 8 then 'Agosto'
					when 9 then 'Septiembre'
					when 10 then 'Octubre'
					when 11 then 'Noviembre'
					when 12 then 'Diciembre'
				end as descripcion
		  from CPmeses a
		 where a.Ecodigo = #session.ecodigo#
		   and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		 order by a.CPCano, a.CPCmes
	</cfquery>
	
	<cf_CPSegUsu_setCFid>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<form name="form1" method="post" action="rptLiquidacion-imprimir.cfm">
<table width="100%" border="0">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Reporte:
		</td>
		<td colspan="3">
			<cfoutput>
			<strong> Liquidación de Período de Presupuesto</strong>
			</cfoutput>
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Período Presupuestario:
		</td>
		<td colspan="2">
		<cf_cboCPPid value="#session.CPPid#" CPPestado="1,2">
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Centro Funcional:
		</td>
		<td colspan="2">
			<cf_CPSegUsu_cboCFid value="#form.CFid#" Consultar="true"> 
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Tipo de Liquidación:
		</td>
		<cfparam name="form.CPTpoMov" default="">
		<td colspan="2">
			<select name="CPTpoMov">
					<option value="0" <cfif form.CPTpoMov EQ "0">selected</cfif>>Todas las cuentas a Liquidar</option>
					<option value="1" <cfif form.CPTpoMov EQ "1">selected</cfif>>Cuentas Liquidadas</option>
					<option value="2" <cfif form.CPTpoMov EQ "2">selected</cfif>>Cuentas No Liquidadas con Error</option>
					<option value="3" <cfif form.CPTpoMov EQ "3">selected</cfif>>Cuentas No Liquidadas sin Fondos en nuevo Período</option>
					<option value="4" <cfif form.CPTpoMov EQ "4">selected</cfif>>Cuentas No Liquidadas sin Cuenta en nuevo Período</option>
			</select>		
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<cfparam name="form.CPformato1" default="">
		<cfparam name="form.CPformato2" default="">
		<td nowrap>
			Cuentas de presupuesto:
		</td>
		<td>
			<cf_CuentaPresupuesto name="CPformato1" value="#form.CPformato1#">
		</td>
		<td>
			<cf_CuentaPresupuesto name="CPformato2" value="#form.CPformato2#">
		</td>
	</tr>	

<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Origen:
		</td>
		<td colspan="2">
			<cfparam name="form.Oorigen" default="">
			<select name="Oorigen">
				<option value=""> (Todos los Origenes)</option>
				<cfoutput query="rsORigenes">
					<option value="#rsORigenes.Oorigen#" <cfif form.Oorigen EQ rsORigenes.Oorigen>selected</cfif>>#rsORigenes.Oorigen#-#rsORigenes.Odescripcion#</option>
				</cfoutput>
			</select>
		</td>
	</tr>	
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<cf_btnImprimir name="rptLiquidacion" TipoPagina="Carta Horizontal (Letter Landscape)">
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
</table>
</form>
<script>
	var GvarSubmit = false;
	function sbSubmit()
	{
		GvarSubmit = true;
		return true;
	}
</script>
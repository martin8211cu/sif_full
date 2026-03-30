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
<form name="form1" method="post" action="rptProyectado-imprimir.cfm" onSubmit="return sbSubmit();">
<table width="100%" border="0">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Reporte:
		</td>
		<td colspan="3">
			<cfoutput>
			<strong> Movimientos de Presupuesto</strong>
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
		<cf_cboCPPid value="#session.CPPid#" onChange="this.form.action='';this.form.submit();" CPPestado="5,1,2">
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
			Tipo de Cuenta Contable:
		</td>
		<td colspan="2">
			<cfparam name="form.Ctipo" default="">
			<select name="Ctipo">
				<option value="" <cfif form.Ctipo EQ "">selected</cfif>>Todas las cuentas</option>
				<option value="A,P,C" <cfif form.Ctipo EQ "A,P,C">selected</cfif>>Cuentas de Balance</option>
				<option value="A" <cfif form.Ctipo EQ "A">selected</cfif>>Activos</option>
				<option value="P" <cfif form.Ctipo EQ "P">selected</cfif>>Pasivos</option>
				<option value="C" <cfif form.Ctipo EQ "C">selected</cfif>>Capital</option>
				<option value="I,G" <cfif form.Ctipo EQ "A,P,C">selected</cfif>>Cuentas de Resultado</option>
				<option value="I" <cfif form.Ctipo EQ "I">selected</cfif>>Ingresos</option>
				<option value="G" <cfif form.Ctipo EQ "G">selected</cfif>>Gastos</option>
			</select>
		</td>
	</tr>

<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Nivel de Cuenta:
		</td>
		<td colspan="2">
			<cfparam name="form.CPCNivel" default="">
			<cfparam name="form.chkTotalizarNiveles" default="0">
			<select name="CPCNivel">
				<cfoutput>
				<cfloop list="U,0,1,2,3,4,5" index="i">
					<option value="#i#" <cfif form.CPCNivel EQ i>selected</cfif>><cfif i EQ "U">Último Nivel<cfelse>Nivel #i#</cfif></option>
				</cfloop>
				</cfoutput>
			</select>
		</td>
	</tr>
	
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<cf_btnImprimir name="rptProyectado" TipoPagina="Carta Horizontal (Letter Landscape)">
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
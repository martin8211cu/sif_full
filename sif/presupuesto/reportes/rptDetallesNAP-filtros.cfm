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
<form name="form1" method="post" action="rptDetallesNAP-imprimir.cfm" onSubmit="return sbSubmit();">
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
		<cf_cboCPPid value="#session.CPPid#" onChange="this.form.action='';this.form.submit();" CPPestado="1,2" IncluirTodos= "true">
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
			Mes de presupuesto:
		</td>
		<td colspan="2">
			<cfparam name="form.CPCanoMes" default="0">
			<select name="CPCanoMes">
				<cfoutput query="rsMeses">
					<option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif form.CPCanoMes mod 100 EQ rsMeses.CPCmes>selected</cfif>>#rsMeses.descripcion#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Tipo de Movimientos:
		</td>
		<td colspan="2">
			<cfparam name="form.CPTpoMov" default="">
			<cfset LvarValor = evaluate("form.CPTpoMov")>
			<select name="CPTpoMov">
				<option value="" 		<cfif LvarValor EQ "">		selected</cfif>>(Todos los tipos de Movimientos)</option>
				<option value="[A]" 	<cfif LvarValor EQ "[A]">	selected</cfif>>[A]  = Aprobación Presupuesto Ordinario</option>
				<option value="[M]" 	<cfif LvarValor EQ "[M]">	selected</cfif>>[M]  = Modificación Presupuesto Extraordinario</option>
				<option value="[*PF]" 	<cfif LvarValor EQ "[*PF]">	selected</cfif>>MOVIMIENTOS DE FORMULACION ([A],[M])</option>
				<option value="[T]" 	<cfif LvarValor EQ "[T]">	selected</cfif>>[T]  = Traslados de Presupuesto Internos</option>
				<option value="[TE]" 	<cfif LvarValor EQ "[TE]">	selected</cfif>>[TE] = Traslados con Autorización Externa</option>
				<option value="[VC]" 	<cfif LvarValor EQ "[VC]">	selected</cfif>>[VC] = Variación Cambiaria</option>
				<option value="[*PP]" 	<cfif LvarValor EQ "[*PP]">	selected</cfif>>MOVIMIENTOS DE PRESUPUESTO PLANEADO ([A],[M],[T],[TE],[VC])</option>
				<option value="[ME]"	<cfif LvarValor EQ "[ME]">	selected</cfif>>[ME] = Modificación por Excesos Autorizados</option>
				<option value="[*PA]" 	<cfif LvarValor EQ "[*PA]">	selected</cfif>>MOVIMIENTOS DE PRESUPUESTO AUTORIZADO ([A],[M],[T],[TE],[VC],[ME])</option>
				<option value="[RA]" 	<cfif LvarValor EQ "[RC]">	selected</cfif>>[RA] = Presupuesto Reservado Período Anterior</option>
				<option value="[CA]" 	<cfif LvarValor EQ "[CC]">	selected</cfif>>[CA] = Presupuesto Comprometido Período Anterior</option>
				<option value="[RC]" 	<cfif LvarValor EQ "[RC]">	selected</cfif>>[RC] = Presupuesto Reservado</option>
				<option value="[CC]" 	<cfif LvarValor EQ "[CC]">	selected</cfif>>[CC] = Presupuesto Comprometido</option>
				<option value="[E]" 	<cfif LvarValor EQ "[E]">	selected</cfif>>[E]  = Ejecutado Contable</option>
				<option value="[E2]" 	<cfif LvarValor EQ "[E2]">	selected</cfif>>[E2] = Ejecutado No Contable</option>
				<option value="[ET]" 	<cfif LvarValor EQ "[ET]">	selected</cfif>>[ET]: EJECUTADO TOTAL ([E],[E2])</option>
				<option value="[*PCA]" 	<cfif LvarValor EQ "[*PCA]">selected</cfif>>MOVIMIENTOS DE CONSUMO DE AUX/CONTA ([RA],[CA],[RC],[CC],[E],[E2])</option>
				<option value="[RP]" 	<cfif LvarValor EQ "[RP]">	selected</cfif>>[RP] = Provisiones Presupuestarias</option>
				<option value="[*PC]" 	<cfif LvarValor EQ "[*PC]">	selected</cfif>>MOVIMIENTOS DE PRESUPUESTO CONSUMIDO ([RA],[CA],[RC],[CC],[E],[E2],[RP])</option>
				<option disabled>Movimientos de Flujo de Efectivo</option>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 1140
			</cfquery>
			<cfif rsSQL.Pvalor EQ "S">
				<option value="[EJ]" 	<cfif LvarValor EQ "[EJ]">	selected</cfif>>[EJ] = Ejercido</option>
				<option value="[P]" 	<cfif LvarValor EQ "[P]">	selected</cfif>>[P]  = Pagado</option>
				<option value="[*FE]" 	<cfif LvarValor EQ "[*FE]">	selected</cfif>>MOVIMIENTOS DE FLUJO DE EFECTIVO ([EJ],[P])</option>
			<cfelse>
				<option value="[P]" 	<cfif LvarValor EQ "[P]">	selected</cfif>>[P]  = Pagado</option>
			</cfif>

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
		<cf_btnImprimir name="rptDetallesNAP" TipoPagina="Carta Horizontal (Letter Landscape)">
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
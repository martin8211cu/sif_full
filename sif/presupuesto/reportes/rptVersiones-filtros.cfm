<!--- ************************************************************* --->
<!---  				EXTRAE EL PERIODO POR DEFECTO 					--->
<!--- ************************************************************* --->
	
	<cfif isdefined('form.CPPid')>
		<cfset form.CPPid = ListFirst(#form.CPPid#,',')>
	</cfif>
	
	<cfquery name="rsVersiones" datasource="#Session.DSN#">
		select p.CVid, p.CVdescripcion, p.CPPid, p.CVtipo
		from CVersion p
		<cfif isdefined('form.CPPid') and form.CPPid neq -1>
			inner join CPresupuestoPeriodo cp on p.Ecodigo = cp.Ecodigo and p.CPPid = cp.CPPid
		</cfif>	
		where p.Ecodigo = #Session.Ecodigo#
		  and p.CVaprobada = <cfif isdefined("form.chkAprobadas")>1<cfelse>0</cfif>
		  <cfif isdefined('form.CPPid') and form.CPPid neq -1>
		  and p.CPPid = #form.CPPid#
		  </cfif>
	</cfquery>

	<cfparam name="form.CVid"	default="#rsVersiones.CVid#">
	<cfparam name="form.CPPid"	default="-1">
	<cfparam name="form.CVtipo"	default="#rsVersiones.CVtipo#">
	<cfset session.CVid = form.CVid>
	
	<cf_CPSegUsu_setCFid>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<script>
	var GvarSubmit = false;
	function sbSubmit()
	{
		GvarSubmit = true;
		return true;
	}
	function PeriodoPresOnChange()
	{	document.form1.action="rptVersiones.cfm"; 
		document.form1.submit();
		
	}
</script>
<form name="form1" method="post" action="rptVersiones-imprimir.cfm" onSubmit="return sbSubmit();">
<table width="100%" border="0">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Tipo de Reporte:
		</td>
		<td colspan="3">
			<cfparam name="form.cboTipo" default="">
			<select name="cboTipo"
					 onChange="document.getElementById('tagTipoPagina').innerHTML = (this.value == '1') ? 'Carta Horizontal (Letter Landscape)' : 'Legal Horizontal (Legal Landscape)    '"
			>
				<option value="1" <cfif form.cboTipo EQ 1>selected</cfif>>Formulación mensual solicitada</option>
				<option value="2" <cfif form.cboTipo EQ 2>selected</cfif>>Formulación total por Mes columnar</option>
			</select>
		</td>
	</tr>
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Per&iacute;odo Presupuestario:
		</td>
		<td colspan="3">
			<cf_cboCPPid value="#form.CPPid#" onChange="PeriodoPresOnChange()" IncluirTodos="YES">
		</td>
	</tr>
<!--- ************************************************************* --->
	<tr>
		<td nowrap>
			Versión de Formulación:
		</td>
		<td colspan="2">
<cfif rsVersiones.recordCount EQ 0>
			No hay Versiones
			&nbsp;&nbsp;<input type="checkbox" name="chkAprobadas" value="1" <cfif isdefined("form.chkAprobadas")>checked</cfif> onClick="this.form.action='';this.form.submit();"> Ver Versiones ya aprobadas
		</td></tr></table>
	<cfreturn>
</cfif>
			<select name="CVid" onChange="this.form.action='';this.form.submit();">
				<cfoutput query="rsVersiones">
					<option value="#rsVersiones.CVid#" <cfif form.CVid EQ rsVersiones.CVid>selected	<cfset form.CPPid = rsVersiones.CPPid><cfset form.CVtipo = rsVersiones.CVtipo></cfif>>#rsVersiones.CVdescripcion#</option>
				</cfoutput>
			</select>
			&nbsp;&nbsp;<input type="checkbox" name="chkAprobadas" value="1" <cfif isdefined("form.chkAprobadas")>checked</cfif> onClick="this.form.action='';this.form.submit();"> Ver Versiones ya aprobadas
		</td>
	</tr>
<!--- ************************************************************* --->
<!---  				RS DEL COMBO DE MESES       					--->
<!--- ************************************************************* --->
	<cfinclude template="../../Utiles/sifConcat.cfm">
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
		<cfparam name="form.CPCanoMes1" default="0">
		<cfparam name="form.CPCanoMes2" default="0">
		<td nowrap>
			Mes de presupuesto:
		</td>
		<td>
			<select name="CPCanoMes1">
					<option></option>
				<cfoutput query="rsMeses">
					<option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif form.CPCanoMes1 NEQ "" AND form.CPCanoMes1 mod 100 EQ rsMeses.CPCmes>selected</cfif>>#rsMeses.descripcion#</option>
				</cfoutput>
			</select>
		</td>
		<td>
			<select name="CPCanoMes2">
					<option></option>
				<cfoutput query="rsMeses">
					<option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif form.CPCanoMes2 NEQ "" AND form.CPCanoMes2 mod 100 EQ rsMeses.CPCmes>selected</cfif>>#rsMeses.descripcion#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
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
			
		</td>
		<td colspan="2">
			<input type="checkbox" name="chkConCeros" 
				<cfif isdefined("form.chkConCeros")>checked</cfif>
				value="1">&nbsp;&nbsp;
			<cfif form.CVtipo EQ 2>
				Incluir Modificaciones Solicitadas en Cero
			<cfelse>
				Incluir Montos Finales Solicitados en Cero
			</cfif>

		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<cf_btnImprimir name="rptVersiones" TipoPagina="Carta Horizontal (Letter Landscape)" Refrescar="#form.CVtipo EQ 2 AND not isdefined('form.chkAprobadas')#">
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
</table>
</form>

<cf_templateheader title="Procesa Ajuste Costo de Ventas">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ajuste Costo de Ventas'>

<cfif isdefined("url.Periodos")>
	<cfset Form.Periodos = url.Periodos>
</cfif>
<cfif isdefined("url.Meses")>
	<cfset Form.Meses = url.Meses>
</cfif>

<!---Obtener el mes y periodo Actual --->
<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Código del Parámetro --->">
	<cfquery datasource="#Session.DSN#" name="rsget_val">
		select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
	</cfquery>
	<cfreturn #rsget_val#>
</cffunction>

<cfif NOT isdefined("Form.Periodos")>
	<cfset periodo="#get_val(30).Pvalor#">
<cfelse>
	<cfset periodo = Form.Periodos>
</cfif>
<cfif NOT isdefined("Form.Meses")>
	<cfset mes="#get_val(40).Pvalor#">
<cfelse>
	<cfset mes = Form.Meses>
</cfif>

<cfset Actperiodo="#get_val(30).Pvalor#">
<cfset Actmes="#get_val(40).Pvalor#">
 
<!---Obtiene los periodos procesados--->
<cfquery name="rspproc" datasource="#Session.DSN#">
	select distinct Speriodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Speriodo desc
</cfquery>

<form style="margin: 0" name="filtros" action="ProcAjusteCV.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td width="20%" align="left"> Saldos anteriores a:</td>
			<td width="10%" align="right">Periodo:</td>
			<td width="15%">
				<select name="Periodos"><cfoutput query="rspproc"> 
                       <option value="#rspproc.Speriodo#" <cfif trim(periodo) EQ trim(rspproc.Speriodo)>selected</cfif>>#rspproc.Speriodo#</option>
				</cfoutput>
				</select>
			</td>
			<td width="5%" align="right">Mes:</td>
			<td valign="top" width="15%">
				<select name="meses" size="1" tabindex="2">
					<option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
					<option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
					<option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
					<option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
					<option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
					<option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
					<option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
					<option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
					<option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
					<option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
					<option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
					<option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
				</select>		
			</td>
			<td width="25%" align="center"><input name="Filtrar" type="submit" value="Filtrar"></td>
			
		</tr>
	</table>
</form>
<cfif isdefined("Form.botonsel")>

	<cfif Form.botonsel EQ "Continuar">
		<cfinclude template="AjusteCV-sql.cfm">
	</cfif>
	<cfif form.botonsel EQ "btnRegresar">
		<cfquery datasource="sifinterfaces">
			delete ACostoVentas where sessionid = #session.monitoreo.sessionid#
		</cfquery> 
			<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/AjusteCV/AjusteCVParam.cfm">
	</cfif>
	<cfif form.botonsel EQ "btnImprimir">
		<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/AjusteCV/ACVImprimir.cfm?Periodos=#periodo#&Meses=#mes#">
	</cfif>
	<cfif form.botonsel EQ "btnAplicar">
		<cfif isDefined("Form.chk")>
			<cfset chequeados = ListToArray(Form.chk)>
			<cfset cuantos = ArrayLen(chequeados)>
		</cfif>
		<cfloop from="1" to="#cuantos#" index="id">
			<cfset arreglo = ListToArray(#chequeados[id]#,"|")>
			<cfset Orden = Trim(arreglo[6])>
			<cfset OCid = Trim(arreglo[7])>
			<cfset Producto = Trim(arreglo[9])>
			<cfset Modulo = Trim(arreglo[5])>
			<cfset Costo = Trim(arreglo[8])>
			<cfset Moneda = Trim(arreglo[4])>
			<cfset Mcodigo = val(Trim(arreglo[3]))>
			<cfinvoke 
				component="ACVAplica" 
				method="AjusteCV" 
				Orden="#Orden#"
				OCid="#OCid#"
				Producto="#Producto#"
				Modulo="#Modulo#"
				Costo="#Costo#"
				Moneda="#Moneda#"
				Mcodigo="#Mcodigo#"
			/> 
		</cfloop>
		<cfinclude template="AjusteCV-sql.cfm">
	</cfif>
</cfif>
<cfinclude template="AjusteCV-lista.cfm">
<cf_web_portlet_end>
<cf_templatefooter>
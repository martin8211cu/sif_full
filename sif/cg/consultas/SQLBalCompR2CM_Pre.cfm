<cfparam name="url.IncluirOficina" default="N">
<cfparam name="url.chkCeros" default = "N">
<cfparam name="url.formato" default="HTML">
<cfparam name="url.CHKMesCierre" default="0">
<cfparam name="url.CHKMensual" default="0">
<cfparam name="url.CHKNivelSeleccionado" default="0">

<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>

<cfquery name="rsMesCierreConta" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 45
</cfquery>

<cfset LvarCHKMesCierre = url.CHKMesCierre>
<cfif rsMesCierreConta.Pvalor NEQ url.mes and url.CHKMesCierre EQ "1">
	<cfset LvarCHKMesCierre = "0">
</cfif>

<cfif not isdefined('form.mes') and isdefined('url.mes')>
	<cfset form.mes = url.mes>
</cfif>
<cfif not isdefined('form.periodo') and isdefined('url.periodo')>
	<cfset form.periodo = url.periodo>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfinvoke key="CMB_Mes" 			default="Mes" 				returnvariable="CMB_Mes" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
    select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
    from Empresas a, Monedas b 
    where a.Ecodigo = #Session.Ecodigo#
      and a.Mcodigo = b.Mcodigo
</cfquery>

<cfif rsMonedaLocal.Mcodigo neq url.Mcodigo>
    <cfquery datasource="#Session.DSN#" name="rsTC">	
        select Mcodigo,TCtipocambio from TipoCambioReporte
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and TCperiodo = #Form.periodo# and TCmes = #Form.mes# and Mcodigo = #url.Mcodigo#
    </cfquery>
    <cfif rsTC.recordCount eq 0>
        <cfset MSG_TipoCambio = t.Translate('MSG_TipoCambio','No está definido el Tipo de Cambio para el periodo')>
        <cf_errorCode code = "50194" msg = "#MSG_TipoCambio# #Form.periodo# #CMB_Mes# #Form.mes#">
        <cfabort>
    </cfif> 
</cfif> 

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Formato" 		default="Visualizar en Formato"					returnvariable="LB_Formato"	xmlfile="SQLBalCompR2_Pre.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Generar" 		default="Generar"					
returnvariable="BTN_Generar"	xmlfile="SQLBalCompR2_Pre.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Regresar" 		default="Regresar"	
returnvariable="BTN_Regresar"	xmlfile="SQLBalCompR2_Pre.xml"/>
<form name="form1" method="post">
 <table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td><strong><cfoutput>#LB_Formato#</cfoutput>:</strong></td>
		<td>
			<select name="formato">
				<option value="flashpaper" <cfif ucase(form.formato) EQ "FLASHPAPER">selected</cfif> >FLASHPAPER</option>
				<option value="pdf" <cfif ucase(form.formato) EQ "PDF">selected</cfif> >PDF</option>
				<option value="HTML" <cfif ucase(form.formato) EQ "HTML">selected</cfif> >HTML</option>
			</select>
		</td><cfoutput>
		<td><input name="visualiza" type="submit" value="#BTN_Generar#"></td>
		<td><input name="Regresar" type="button" value="#BTN_Regresar#" onclick="funcRegresar()"></td></cfoutput>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
<cfoutput>
<cfif not isdefined('form.Formato')>
	<cfset form.formato = 'HTML'>
</cfif>
<cfset LvarAction = "BalCompRCM.cfm" >
<cfif isdefined("url.LvarSumasSaldos")>
	<cfset LvarAction = "BalSumSldosCM.cfm" >
</cfif>

<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action="<cfoutput>#LvarAction#</cfoutput>";
		document.form1.submit();
	}
</script>

<cfset LvarComponente = "SQLBalCompCMR2.cfm">
<cfif url.CHKMensual EQ "1">
	<cfset LvarComponente = "SQLBalCompCMR2Mensual.cfm">
	<cfset form.formato = "HTML">
</cfif>

<cfif form.formato EQ "HTML">
	<form name="form1n" action="#LvarComponente#" method="post">
		<cfif isdefined("url.LvarSumasSaldos")>
			<input name="LvarSumasSaldos" type="hidden" value="1" />
		</cfif>
		<input type="hidden" name="IncluirOficina" value="#url.IncluirOficina#" />
		<input type="hidden" name="CHKMesCierre" value="#LvarCHKMesCierre#" />
		<input type="hidden" name="CMAYOR_CCUENTA1" value="#url.CMAYOR_CCUENTA1#" />
		<input type="hidden" name="CMAYOR_CCUENTA2" value="#url.CMAYOR_CCUENTA2#" />
		<input type="hidden" name="FORMATO" value="#form.FORMATO#" />
		<input type="hidden" name="MCODIGO" value="#url.MCODIGO#" />
		<input type="hidden" name="MCODIGOOPT" value="#url.MCODIGOOPT#" />
		<input type="hidden" name="MES" value="#url.MES#" />
		<input type="hidden" name="NIVEL" value="#url.NIVEL#" />
		<input type="hidden" name="PERIODO" value="#url.PERIODO#" />
		<input type="hidden" name="UBICACION" value="#url.UBICACION#" />
		<input type="hidden" name="MostrarCeros" value="#url.chkCeros#" />	
		<input type="hidden" name="Mensual" value="#url.CHKMensual#" />	
        <input type="hidden" name="NivelSeleccionado" value="#url.CHKNivelSeleccionado#"/>	
		<input type="hidden" name="Idioma" value="#url.Idioma#" />	</form>
	<script language="javascript" type="text/javascript">
		document.form1n.submit();
	</script>
<cfelse>
	<cfset LvarSrc = "#LvarComponente#?NivelSeleccionado=#url.CHKNivelSeleccionado#&IncluirOficina=#url.IncluirOficina#&CHKMesCierre=#LvarCHKMesCierre#&CMAYOR_CCUENTA1=#url.CMAYOR_CCUENTA1#&CMAYOR_CCUENTA2=#url.CMAYOR_CCUENTA2#&FORMATO=#form.FORMATO#&MCODIGO=#url.MCODIGO#&MCODIGOOPT=#url.MCODIGOOPT#&MES=#url.MES#&NIVEL=#url.NIVEL#&PERIODO=#url.PERIODO#&UBICACION=#url.UBICACION#&MostrarCeros=#url.chkCeros#">
	<cfif isdefined("url.LvarSumasSaldos")>
		<cfset LvarSrc = "#LvarComponente#?NivelSeleccionado=#url.CHKNivelSeleccionado#&IncluirOficina=#url.IncluirOficina#&CHKMesCierre=#LvarCHKMesCierre#&CMAYOR_CCUENTA1=#url.CMAYOR_CCUENTA1#&CMAYOR_CCUENTA2=#url.CMAYOR_CCUENTA2#&FORMATO=#form.FORMATO#&MCODIGO=#url.MCODIGO#&MCODIGOOPT=#url.MCODIGOOPT#&MES=#url.MES#&NIVEL=#url.NIVEL#&PERIODO=#url.PERIODO#&UBICACION=#url.UBICACION#&MostrarCeros=#url.chkCeros#&LvarSumasSaldos=1">
	</cfif>
	<iframe id="frBalCompR2" frameborder="0" width="100%" 
	height="85%" src="#LvarSrc#"></iframe>
</cfif>

</cfoutput>

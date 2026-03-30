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
<cfset LvarAction = "BalCompR.cfm" >
<cfif isdefined("url.LvarSumasSaldos")>
	<cfset LvarAction = "BalSumasSaldos.cfm" >
</cfif>

<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action="<cfoutput>#LvarAction#</cfoutput>";
		document.form1.submit();
	}
</script>

<cfset LvarComponente = "SQLBalCompR2.cfm">
<cfif url.CHKMensual EQ "1">
	<cfset LvarComponente = "SQLBalCompR2Mensual.cfm">
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
	</form>
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

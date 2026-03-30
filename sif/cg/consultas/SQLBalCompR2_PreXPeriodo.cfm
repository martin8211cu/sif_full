<cfparam name="url.IncluirOficina" default="N">
<cfparam name="url.chkCeros" default = "N">
<cfparam name="url.formato" default="HTML">

<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>

<form name="form1" method="post">
 <table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td><strong>Visualizar en formato:</strong></td>
		<td>
			<select name="formato">
				<option value="flashpaper" <cfif ucase(form.formato) EQ "FLASHPAPER">selected</cfif> >FLASHPAPER</option>
				<option value="pdf" <cfif ucase(form.formato) EQ "PDF">selected</cfif> >PDF</option>
				<option value="HTML" <cfif ucase(form.formato) EQ "HTML">selected</cfif> >HTML</option>
			</select>
		</td>
		<td><input name="visualiza" type="submit" value="Generar"></td>
		<td><input name="Regresar" type="button" value="Regresar" onclick="funcRegresar()"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
<cfoutput>
<cfif not isdefined('form.Formato')>
	<cfset form.formato = 'HTML'>
</cfif>
<cfset LvarAction = "BalCompRxPeriodo.cfm" >

<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action="<cfoutput>#LvarAction#</cfoutput>";
		document.form1.submit();
	}
</script>

<cfset LvarComponente = "SQLBalCompR2xPeriodo.cfm">

<cfif form.formato EQ "HTML">
	<form name="form1n" action="#LvarComponente#" method="post">
		<input type="hidden" name="IncluirOficina" value="#url.IncluirOficina#" />
		<input type="hidden" name="CMAYOR_CCUENTA1" value="#url.CMAYOR_CCUENTA1#" />
		<input type="hidden" name="CMAYOR_CCUENTA2" value="#url.CMAYOR_CCUENTA2#" />
		<input type="hidden" name="FORMATO" value="#form.FORMATO#" />
		<input type="hidden" name="MCODIGO" value="#url.MCODIGO#" />
		<input type="hidden" name="MCODIGOOPT" value="#url.MCODIGOOPT#" />
		<input type="hidden" name="MESDES" value="#url.MESDES#" />
        <input type="hidden" name="MESHAS" value="#url.MESHAS#" />
		<input type="hidden" name="NIVEL" value="#url.NIVEL#" />
		<input type="hidden" name="PERIODODES" value="#url.PERIODODES#" />
        <input type="hidden" name="PERIODOHAS" value="#url.PERIODOHAS#" />
		<input type="hidden" name="UBICACION" value="#url.UBICACION#" />
		<input type="hidden" name="MostrarCeros" value="#url.chkCeros#" />	
	</form>
	<script language="javascript" type="text/javascript">
		document.form1n.submit();
	</script>
<cfelse>
	<cfset LvarSrc = "#LvarComponente#?IncluirOficina=#url.IncluirOficina#&CMAYOR_CCUENTA1=#url.CMAYOR_CCUENTA1#&CMAYOR_CCUENTA2=#url.CMAYOR_CCUENTA2#&FORMATO=#form.FORMATO#&MCODIGO=#url.MCODIGO#&MCODIGOOPT=#url.MCODIGOOPT#&MESDES=#url.MESDES#&MESHAS=#url.MESHAS#&NIVEL=#url.NIVEL#&PERIODODES=#url.PERIODODES#&PERIODOHAS=#url.PERIODOHAS#&UBICACION=#url.UBICACION#&MostrarCeros=#url.chkCeros#">
	<iframe id="frBalCompR2" frameborder="0" width="100%" 
	height="85%" src="#LvarSrc#"></iframe>
</cfif>

</cfoutput>

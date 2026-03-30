<cfif isdefined("url.FCVtipo") and len(url.FCVtipo) and not isdefined("form.FCVtipo")><cfset form.FCVtipo = url.FCVtipo></cfif>
<cfif isdefined("url.FCPPid") and len(url.FCPPid) and not isdefined("form.FCPPid")><cfset form.FCPPid = url.FCPPid></cfif>

<BR>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
		<cfinclude template="versiones_header.cfm">
</table>
<cfif qry_cvm.CVtipo EQ 1>
	<cfset session.chkNuevas = true>
<cfelse>
	<cfset session.chkNuevas = false>
	<input type="checkbox" name="chkNuevas" value="1"
		onclick="document.getElementById('ifrChkNuevas').src = 'importacion.cfm?chkNuevas=' + (this.checked ? '1' : '0');"
	>
	Permitir sólo Formulaciones Nuevas
	<BR>
	<cfset session.chkMesesAnt = false>
	<input type="checkbox" name="chkMesesAnt" value="1"
		onclick="document.getElementById('ifrChkNuevas').src = 'importacion.cfm?chkMesesAnt=' + (this.checked ? '1' : '0');"
	>
	Permitir Formulaciones de Meses Anteriores
	<BR>
	<iframe name="ifrChkNuevas" id="ifrChkNuevas" frameborder="0" height="0" width="0"></iframe>
</cfif>
<BR>
<hr>

<cfif isdefined("url.chkMesesAnt")>
	<cfset form.chkMesesAnt = url.chkMesesAnt>
</cfif>

		<cf_sifimportar eicodigo="CV_FORMULAC" mode="in" width="100%" height="400">
		<cf_sifimportarparam name="MesesAnt" value="#isdefined("form.chkMesesAnt")#">
		</cf_sifimportar>









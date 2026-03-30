<!--- Proveduria Corporativa --->
<cfif isdefined('url.Ecodigo') and url.Ecodigo eq -1>
    <cfparam name="form.EcodigoE" default="#session.Ecodigo#">
    <cfset lvarProvCorp = false>
    <cfset lvarFiltroEcodigo = #session.Ecodigo#>
    <cfquery name="rsProvCorp" datasource="#session.DSN#">
        select Pvalor 
        from Parametros 
        where Ecodigo=#session.Ecodigo#
        and Pcodigo=5100
    </cfquery>
    <cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
        <cfset lvarProvCorp = true>
        <cfquery name="rsEProvCorp" datasource="#session.DSN#">
            select EPCid
            from EProveduriaCorporativa
            where Ecodigo = #session.Ecodigo#
             and EPCempresaAdmin = #session.Ecodigo#
        </cfquery>
        <cfif rsEProvCorp.recordcount gte 1>
            <cfquery name="rsDProvCorp" datasource="#session.DSN#">
                select DPCecodigo as Ecodigo, Edescripcion
                from DProveduriaCorporativa dpc
                    inner join Empresas e
                        on e.Ecodigo = dpc.DPCecodigo
                where dpc.Ecodigo = #session.Ecodigo#
                 and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
                union
                select e.Ecodigo, e.Edescripcion
                from Empresas e
                where e.Ecodigo = #session.Ecodigo#
                order by 2
            </cfquery>
            <cfloop from="1" to="#rsDProvCorp.recordcount#" index="i">
                <cfset Ecodigos = ValueList(rsDProvCorp.Ecodigo)>
            </cfloop>
        </cfif>    
        <cfif not isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
            <cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
        </cfif>
    </cfif>
     <cfparam name="Ecodigos" default="#session.Ecodigo#">
    <cfset url.Ecodigo = #Ecodigos#>	
 </cfif>
<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.CMSid") and not isdefined("Form.CMSid")>
	<cfparam name="Form.CMSid" default="#Url.CMSid#">
</cfif>
<cfif isdefined("Url.CMScodigo") and not isdefined("Form.CMScodigo")>
	<cfparam name="Form.CMScodigo" default="#Url.CMScodigo#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfif isdefined("url.Ecodigo") and len(trim("url.Ecodigo"))>
	<cfset form.Ecodigo = url.Ecodigo>
</cfif>

<!--- Filtros --->
<cfif isdefined("url.CMSnombre") and not isdefined("form.CMSnombre")>
	<cfset form.CMSnombre = url.CMSnombre >
</cfif>

<cfoutput>
<script language="JavaScript" type="text/javascript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function Asignar(CMSid,CMScodigo,nombre) {
		if (window.opener != null) {
			window.opener.document.#form.formulario#.#form.CMSid#.value = CMSid;
			window.opener.document.#form.formulario#.#form.CMScodigo#.value = CMScodigo;
			window.opener.document.#form.formulario#.#form.desc#.value = trim(nombre);
			
			if (window.opener.func#form.CMSid#) {
				window.opener.func#form.CMSid#()
			}
			window.close();
		}
}
</script>
</cfoutput>
<!--- Filtro --->
<cfset filtro = "">
<cfset navegacion = "&formulario=#form.formulario#&CMSid=#form.CMSid#&CMScodigo=#form.CMScodigo#&desc=#form.desc#&Ecodigo=#Form.Ecodigo#">
<cfif isdefined("Form.CMSnombre") and Len(Trim(Form.CMSnombre)) neq 0>
 	<cfset filtro = filtro & " and upper(CMSnombre) like '%" & ucase(Form.CMSnombre) & "%'">
	<cfset navegacion = navegacion & "&CMSnombre=" & Form.CMSnombre>
</cfif>

<html>
<head>
<title>Lista de Solicitantes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroSolicitante" method="post" action="ConlisSolicitantesConsulta.cfm?Ecodigo=<cfoutput>#form.Ecodigo#</cfoutput>" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td width="1%" align="right"><strong>Solicitante</strong></td>
				<td> 
					<input name="CMSnombre" type="text" id="desc" size="25" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.CMSnombre")>#Form.CMSnombre#</cfif>">
				</td>

				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.CMSid") and len(trim(form.CMSid))>
						<input type="hidden" name="CMSid" value="#form.CMSid#">
					</cfif>
					<cfif isdefined("form.CMScodigo") and len(trim(form.CMScodigo))>
						<input type="hidden" name="CMScodigo" value="#form.CMScodigo#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
                    <input type="hidden" name="Ecodigo" value="<cfoutput>#form.Ecodigo#</cfoutput>">	
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfset select = " a.CMSid, rtrim(a.CMScodigo) as CMScodigo, a.CMSnombre " >
		<cfset from = " CMSolicitantes a " >
		<cfset where = " a.Ecodigo in (#form.Ecodigo#)" >
		<cfset where = where & filtro & " order by a.CMScodigo, a.CMSnombre">

		<cfinvoke 
		 component="sif.Componentes.pListas" a
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="#from#"/>
			<cfinvokeargument name="columnas" value="#select#"/>
			<cfinvokeargument name="desplegar" value="CMScodigo,CMSnombre"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo,Solicitante"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="#where#"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisSolicitantesConsulta.cfm"/>
			<cfinvokeargument name="formName" value="listaSolicitantes"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="CMSid,CMScodigo,CMSnombre"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>
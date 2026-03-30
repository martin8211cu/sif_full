<!-----Parametros de la navegacion ----->
<cfparam name="url.formulario" default="form1">

<cfif isdefined("Url.CMScodigo") and not isdefined("Form.CMScodigo")>
	<cfparam name="Form.CMScodigo" default="#Url.CMScodigo#">
</cfif>
<cfif isdefined("Url.CMSid") and not isdefined("Form.CMSid")>
	<cfparam name="Form.CMSid" default="#Url.CMSid#">
</cfif>
<cfif isdefined("Url.CMSnombre") and not isdefined("Form.CMSnombre")>
	<cfparam name="Form.CMSnombre" default="#Url.CMSnombre#">
</cfif>

<cfset index = ""><!---Variable con el indice (#) de conlis llamados desde la pantalla---->
<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.index")>
	<cfset index = Url.idx>
</cfif>

<cfoutput>
<script language="JavaScript" type="text/javascript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function Asignar<cfoutput>#index#</cfoutput>(CMSid,CMScodigo,nombre) {
		if (window.opener != null) {
			window.opener.document.<cfoutput>#url.formulario#</cfoutput>.CMSid<cfoutput>#index#</cfoutput>.value = CMSid;
			window.opener.document.<cfoutput>#url.formulario#</cfoutput>.CMScodigo<cfoutput>#index#</cfoutput>.value = trim(CMScodigo);
			window.opener.document.<cfoutput>#url.formulario#</cfoutput>.CMSnombre<cfoutput>#index#</cfoutput>.value = trim(nombre);						
			window.close();
		}

	}
</script>
</cfoutput>

<cfset filtro = "">
<!---<cfset navegacion = "&formulario=#form.formulario#&CMSid=#form.CMSid#&CMScodigo=#form.CMScodigo#&desc=#form.desc#">---->
<cfset navegacion = ''>
<cfif isdefined("Form.CMSnombre") and Len(Trim(Form.CMSnombre)) neq 0>
 	<cfset filtro = filtro & " and upper(CMSnombre) like '%" & ucase(Form.CMSnombre) & "%'">
	<cfset navegacion = navegacion & "&CMSnombre=" & Form.CMSnombre>
</cfif>
<cfif isdefined("Form.CMScodigo") and Len(Trim(Form.CMScodigo)) neq 0>
 	<cfset filtro = filtro & " and upper(CMScodigo) like '%" & ucase(Form.CMScodigo) & "%'">
	<cfset navegacion = navegacion & "&CMScodigo=" & Form.CMScodigo>
</cfif>
<cfif isdefined("Form.CMSid") and Len(Trim(Form.CMSid)) neq 0>
 	<cfset filtro = filtro & " and CMSid=" & Form.CMSid>
	<cfset navegacion = navegacion & "&CMSid=" & Form.CMSid>
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
		<form style="margin:0;" name="filtroSolicitantes" method="post" action="ConlisSolicitantes.cfm" >
			<cfif Len(Trim(index))>
					<input type="hidden" name="idx" value="#index#">
			</cfif>
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td width="7%" align="right"><strong>Solicitante</strong></td>
				<td width="6%">
					<input maxlength="10"  size="10" type="text" name="CMScodigo" value="<cfif isdefined("form.CMScodigo") and len(trim(form.CMScodigo))>#form.CMScodigo#</cfif>"><!----<cfif isdefined("form.CMScodigo") and len(trim(form.CMScodigo))>AAAA#form.CMScodigo#</cfif>---->
				</td>
				<td width="19%"> 
					<input name="CMSnombre" type="text" id="desc" size="30" maxlength="120" onClick="this.select();" value="<cfif isdefined("Form.CMSnombre")>#Form.CMSnombre#</cfif>">
				</td>				
				<td width="68%">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.CMSid") and len(trim(form.CMSid))>
						<input type="hidden" name="CMSid" value="#form.CMSid#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfset select = " a.CMSid, rtrim(a.CMScodigo) as CMScodigo, a.CMSnombre " >
		<cfset from = " CMSolicitantes a " >
		<cfset where = " a.Ecodigo=#session.Ecodigo# " >
		<cfset where = where & filtro & " order by a.CMScodigo, a.CMSnombre">

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="#from#"/>
			<cfinvokeargument name="columnas" value="#select#"/>
			<cfinvokeargument name="desplegar" value="CMScodigo,CMSnombre"/>
			<cfinvokeargument name="etiquetas" value="Código,Solicitante"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="#where#"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisSolicitantes.cfm"/>
			<cfinvokeargument name="formName" value="listaSolicitantes"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar#index#"/>
			<cfinvokeargument name="fparams" value="CMSid,CMScodigo,CMSnombre"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>
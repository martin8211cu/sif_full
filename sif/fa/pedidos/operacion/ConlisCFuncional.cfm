<cfif isdefined("url.CMSid") and not isdefined("form.CMSid")>
	<cfset form.CMSid= url.CMSid >
</cfif>

<cfif isdefined("url.ABC") and not isdefined("form.CMSid")>
	<cfset form.CMSid= url.ABC >
</cfif>

<cfif isdefined("url.CMCid") and not isdefined("form.CMCid")>
	<cfset form.CMCid= url.CMCid >
</cfif>
<cfif isdefined("url.form") and not isdefined("form.form")>
	<cfset form.form= url.form >
<cfelse>
	<cfset form.form= 'form1'>
</cfif>

<cfif isdefined("url.id") and not isdefined("form.id")>
	<cfset form.id= url.id >
<cfelse>
	<cfset form.name= 'CFid' >
</cfif>
<cfif isdefined("url.name") and not isdefined("form.name")>
	<cfset form.name= url.name >
<cfelse>
	<cfset form.name= 'CFcodigo' >
</cfif>
<cfif isdefined("url.desc") and not isdefined("form.desc")>	
	<cfset form.desc= url.desc >
<cfelse>
	<cfset form.desc= 'CFdescripcion' >
</cfif>

<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.id#</cfoutput>.value   = id;
		window.opener.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.name#</cfoutput>.value = name;
		window.opener.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.desc#</cfoutput>.value = desc;
		if (window.opener.tipos) window.opener.tipos(id);
		window.close();
	}
}
</script>

<cfif isdefined("Url.CFcodigo") and not isdefined("Form.CFcodigo")>
	<cfparam name="Form.CFcodigo" default="#Url.CFcodigo#">
</cfif>
<cfif isdefined("Url.CFdescripcion") and not isdefined("Form.CFdescripcion")>
	<cfparam name="Form.CFdescripcion" default="#Url.CFdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.CFcodigo") and Len(Trim(Form.CFcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(CFcodigo) like '%" & #UCase(Form.CFcodigo)# & "%'">
	<cfset navegacion = navegacion & "&CFcodigo=" & Form.CFcodigo>
</cfif>
<cfif isdefined("Form.CFdescripcion") and Len(Trim(Form.CFdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CFdescripcion) like '%" & #UCase(Form.CFdescripcion)# & "%'">
	<cfset navegacion = navegacion & "&CFdescripcion=" & Form.CFdescripcion>
</cfif>
<cfif isdefined("form.CMCid") and len(trim(form.CMCid))>
	<cfset navegacion = navegacion & "&CMCid=" & Form.CMCid>
</cfif>
<cfif isdefined("form.CMSid") and len(trim(form.CMSid))>
	<cfset navegacion = navegacion & "&ABC=" & Form.CMSid>
</cfif>
<cfif isdefined("form.form") and len(trim(form.form))>
	<cfset navegacion = navegacion & "&form=" & Form.form>
</cfif>
<cfif isdefined("form.id") and len(trim(form.id))>
	<cfset navegacion = navegacion & "&id=" & Form.id>
</cfif>
<cfif isdefined("form.name") and len(trim(form.name))>
	<cfset navegacion = navegacion & "&name=" & Form.name>
</cfif>
<cfif isdefined("form.desc") and len(trim(form.desc))>
	<cfset navegacion = navegacion & "&desc=" & Form.desc>
</cfif>

<html>
<head>
<title>Lista de Centros Funcionales</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>



<cfoutput>
<form style="margin:0;" name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="CFcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.CFcodigo")>#Form.CFcodigo#</cfif>" onFocus="javascript:this.select();" >
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="CFdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CFdescripcion")>#Form.CFdescripcion#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
		<cfif isdefined("form.CMSid")>
			<input type="hidden" name="CMSid" value="#form.CMSid#">
		</cfif>
		<cfif isdefined("form.CMCid")>
			<input type="hidden" name="CMCid" value="#form.CMCid#">
		</cfif>
	</tr>
</table>
</form>
</cfoutput>

<cfif isdefined("form.CMSid") and len(trim(form.CMSid))>
	<cfset from = "	CMSolicitantesCF a
			   	inner join CFuncional b
				on a.CFid=b.CFid 
				   and b.Ecodigo = #Session.Ecodigo#" >
	<cfset filtroX = "a.CMSid=#form.CMSid#">
<cfelseif isdefined("form.CMCid")>
	<cfset from = "	CFuncional b" >
	<cfset filtroX = "b.Ecodigo = #Session.Ecodigo#">
 <cfelse>
	<cf_errorCode	code = "50289" msg = " No está definido ni el comprador ni el solicitante!, Proceso Cancelado!"><!--- --->
</cfif>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="tabla" value="#from#"/>
	<cfinvokeargument name="columnas" value="b.CFid, b.CFcodigo, b.CFdescripcion"/>
	<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="#filtroX# #filtro# "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisCFuncional.cfm"/>
	<cfinvokeargument name="formName" value="listaCFuncional"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CFid,CFcodigo,CFdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke>

</body>
</html>


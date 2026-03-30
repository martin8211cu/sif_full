<cfset DEBUG = false>

<cfparam name="Url.PCEcodigo" default="">
<cfparam name="Url.PCEdescripcion" default="">

<cfparam name="Form.PCEcodigo" default="#Url.PCEcodigo#">
<cfparam name="Form.PCEdescripcion" default="#Url.PCEdescripcion#">

<cfset filtro = ''>
<cfset navegacion = ''>
<cfif isdefined('form.PCEcodigo') and Len(Trim(form.PCEcodigo))>
	<cfset filtro = filtro & " and upper(PCEcodigo) like '%#Ucase(Form.PCEcodigo)#%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "PCEcodigo=" & Form.PCEcodigo>
</cfif>
<cfif isdefined('form.PCEdescripcion') and Len(Trim(form.PCEdescripcion))>
	<cfset filtro = filtro & " and Upper(PCEdescripcion) like Upper('%#form.PCEdescripcion#%')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "PCEdescripcion=" & Form.PCEdescripcion>
</cfif>
<cfset filtro = filtro & " and exists (Select 1 from PCECatalogoUsr a where a.PCEcatid=PCECatalogo.PCEcatid and a.Usucodigo=#session.Usucodigo#)">
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td nowrap colspan="4" align="center">
				<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
				<form style="margin:0" name="formFiltro" method="post" action="#GetFileFromPath(GetTemplatePath())#">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
				  <tr>
					<td width="15%"><strong>C&oacute;digo</strong></td>
					<td width="49%"><strong>Descripci&oacute;n</strong></td>
				  </tr>
				  <tr>
					<td>
						<input type="text" name="PCEcodigo" id="PCEcodigo" value="<cfif isdefined('form.PCEcodigo') and form.PCEcodigo NEQ ''>#form.PCEcodigo#</cfif>" size="20" maxlength="20" onfocus="javascript: this.select();">
						
					</td>
					<td><input name="PCEdescripcion" type="text" id="PCEdescripcion" size="80" maxlength="80" value="<cfif isdefined('form.PCEdescripcion') and form.PCEdescripcion NEQ ''>#form.PCEdescripcion#</cfif>"></td>
				
					<td width="5%" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Filtrar">
					</tr>
				</table>
				</form>
				
			</td>
		</tr>
		<tr>
		  <td nowrap colspan="4">
			<cfset img_checked = "<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>">
			<cfset img_unchecked = "<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>">
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="PCECatalogo"/>
				<cfinvokeargument name="columnas" value="PCEcatid, PCEcodigo, PCEdescripcion, PCElongitud, 
															case PCEvaloresxmayor when 1 then '#img_checked#' else '#img_unchecked#' end as PCEvaloresxmayor,  
															case PCEempresa when 1 then '#img_checked#' else '#img_unchecked#' end as PCEempresa, 
															case PCEref when 1 then '#img_checked#' else '#img_unchecked#' end as PCEref, 
															case PCEreferenciar when 1 then '#img_checked#' else '#img_unchecked#' end as PCEreferenciar, 
															case PCEactivo when 1 then '#img_checked#' else '#img_unchecked#' end as PCEactivo, 1 as IncVal "/>
				<cfinvokeargument name="desplegar" value="PCEcodigo, PCEdescripcion, PCElongitud, PCEvaloresxmayor,PCEempresa, PCEref, PCEreferenciar, PCEactivo"/>
				<cfinvokeargument name="etiquetas" value="Código, Descripción, Longitud,Valores por<BR> Cuenta Mayor, Valores por<BR>Empresa, Puede ser<BR>Referenciado, Debe<BR>Referenciar, Activo"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S,S"/>
				<cfinvokeargument name="filtro" value="CEcodigo = #Session.CEcodigo# #filtro#"/>
				<cfinvokeargument name="align" value="left,left,right,center,center,center,center,center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="PlanCuentas-Catalogos.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true">
				<cfinvokeargument name="navegacion" value="#navegacion#">
				<cfinvokeargument name="debug" value="N">
			</cfinvoke>
		  </td>
		</tr>
	</table>
</cfoutput>

<cfif DEBUG>
	<cfdump var="#Form#" expand="no" label="Form">
	<cfdump var="#Url#" expand="no" label="Url">
	<cfdump var="#Session#" expand="no" label="Session">
</cfif>
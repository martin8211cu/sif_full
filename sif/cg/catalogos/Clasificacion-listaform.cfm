<cfset DEBUG = false>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap colspan="4" align="center">
			<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
			<form style="margin:0" name="formFiltro" method="post" action="">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
			  <tr>
				<td width="15%"><strong>C&oacute;digo</strong></td>
				<td width="49%"><strong>Descripci&oacute;n</strong></td>
				
			  </tr>
			  <tr>
				<td>
					<input type="text" name="PCCEcodigo" id="PCCEcodigo" value="<cfif isdefined('form.PCCEcodigo') and form.PCCEcodigo NEQ ''><cfoutput>#form.PCCEcodigo#</cfoutput></cfif>" size="20" maxlength="20" onfocus="javascript: this.select();">
				</td>
				<td><input name="PCCEdescripcion" type="text" id="PCCEdescripcion" size="80" maxlength="80" value="<cfif isdefined('form.PCCEdescripcion') and form.PCCEdescripcion NEQ ''><cfoutput>#form.PCCEdescripcion#</cfoutput></cfif>"></td>
				<td width="5%" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Filtrar">
				</tr>
			</table>
			</form>
			
		</td>
	</tr>
	<cfset filtro = ''>
	
	<cfif isdefined('form.PCCEcodigo') and form.PCCEcodigo NEQ ''>
		<cfset filtro = filtro & " and upper(PCCEcodigo) like '%#Ucase(Form.PCCEcodigo)#%'">
	</cfif>
	<cfif isdefined('form.PCCEdescripcion') and form.PCCEdescripcion NEQ ''>
		<cfset filtro = filtro & " and Upper(PCCEdescripcion) like Upper('%#form.PCCEdescripcion#%')">
	</cfif>
	
    <tr>
	  <td nowrap colspan="4">
		<cfset img_checked = "<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>">
		<cfset img_unchecked = "<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>">
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="PCClasificacionE"/>
			<cfinvokeargument name="columnas" value="PCCEclaid, PCCEcodigo, PCCEdescripcion, 
														case PCCEempresa when 1 then '#img_checked#' else '#img_unchecked#' end as PCCEempresa, 
														case PCCEactivo when 1 then '#img_checked#' else '#img_unchecked#' end as PCCEactivo "/>
			<cfinvokeargument name="desplegar" value="PCCEcodigo, PCCEdescripcion, PCCEempresa, PCCEactivo"/>
			<cfinvokeargument name="etiquetas" value="Código, Descripción, Valores por<BR>Empresa, Activo"/>
			<cfinvokeargument name="formatos" value="S,S,S,S"/>
			<cfinvokeargument name="filtro" value="CEcodigo = #Session.CEcodigo# #filtro#"/>
			<cfinvokeargument name="align" value="left,left,center,center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="Clasificacion.cfm"/>
			<cfinvokeargument name="botones" value="Nuevo">
			<cfinvokeargument name="showEmptyListMsg" value="true">
			<cfinvokeargument name="debug" value="N">			
		</cfinvoke>
	  </td>
	</tr>
</table>
<cfif DEBUG>
	<cfdump var="#Form#" expand="no" label="Form">
	<cfdump var="#Url#" expand="no" label="Url">
	<cfdump var="#Session#" expand="no" label="Session">
</cfif>
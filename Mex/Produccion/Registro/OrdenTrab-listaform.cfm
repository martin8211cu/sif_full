<cfset DEBUG = false>

<cfparam name="Url.OTEcodigo" default="">
<cfparam name="Url.OTdescripcion" default="">

<cfparam name="Form.OTEcodigo" default="#Url.OTEcodigo#">
<cfparam name="Form.OTEdescripcion" default="#Url.OTdescripcion#">

<cfset filtro = ''>
<cfset navegacion = ''>
<cfif isdefined('form.OTEcodigo') and Len(Trim(form.OTEcodigo))>
	<cfset filtro = filtro & " and upper(OTcodigo) like '%#Ucase(Form.OTEcodigo)#%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "OTcodigo=" & Form.OTEcodigo>
</cfif>
<cfif isdefined('form.OTEdescripcion') and Len(Trim(form.OTEdescripcion))>
	<cfset filtro = filtro & " and Upper(OTdescripcion) like Upper('%#form.OTEdescripcion#%')">
<!---	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "OTEdescripcion=" & Form.OTEdescripcion>
--->
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td nowrap colspan="4" align="center">
<!---				<script language="JavaScript" type="text/javascript" src="../../sif/js/utilesMonto.js">//</script>
--->				
				<form style="margin:0" name="formFiltro" method="post" action="#GetFileFromPath(GetTemplatePath())#">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
				  <tr>
					<td width="15%"><strong>C&oacute;digo</strong></td>
					<td width="49%"><strong>Descripci&oacute;n</strong></td>
				  </tr>
				  <tr>
					<td>
						<input type="text" name="OTEcodigo" id="OTEcodigo" value="<cfif isdefined('form.OTEcodigo') and form.OTEcodigo NEQ ''>#form.OTEcodigo#</cfif>" size="20" maxlength="20" onfocus="javascript: this.select();">
						
					</td>
					<td><input name="OTEdescripcion" type="text" id="OTEdescripcion" size="80" maxlength="80" value="<cfif isdefined('form.OTEdescripcion') and form.OTEdescripcion NEQ ''>#form.OTEdescripcion#</cfif>"></td>
					<td width="5%" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Filtrar">
					</tr>
				</table>
				</form>
				
			</td>
		</tr>
		<tr>
		  <td nowrap colspan="4">
<!---			<cfset img_checked = "<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>">
			<cfset img_unchecked = "<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>">
--->            
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
             
				<cfinvokeargument name="tabla" value="Prod_OT o inner join SNegocios s on o.Ecodigo=s.Ecodigo and o.SNcodigo=s.SNcodigo"/>
				<cfinvokeargument name="columnas" value="o.OTcodigo,o.OTdescripcion,o.OTfechaRegistro,o.OTfechaCompromiso,s.SNnombre "/>
                                                            
				<cfinvokeargument name="desplegar" value="OTcodigo, OTdescripcion, OTfechaRegistro, OTfechaCompromiso, SNnombre"/>
				<cfinvokeargument name="etiquetas" value="Código, Descripción, Fecha Registro, Fecha Compromiso, Cliente"/>
				<cfinvokeargument name="formatos" value="S,S,D,D,S"/>
				<cfinvokeargument name="filtro" value="o.Ecodigo = #Session.Ecodigo# #filtro#"/>
				<cfinvokeargument name="align" value="left,left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="RegOrdenTr.cfm"/>
				<cfinvokeargument name="botones" value="Nuevo">
				<cfinvokeargument name="showEmptyListMsg" value="true">
				<cfinvokeargument name="navegacion" value="#navegacion#">
				<cfinvokeargument name="debug" value="N">
			</cfinvoke>
		  </td>
		</tr>
	</table>
</cfoutput>

<!---<cfif DEBUG>
	<cfdump var="#Form#" expand="no" label="Form">
	<cfdump var="#Url#" expand="no" label="Url">
	<cfdump var="#Session#" expand="no" label="Session">
</cfif>--->
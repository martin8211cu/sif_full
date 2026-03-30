<cfif isdefined("url.ESidsolicitud") and not isdefined("form.ESidsolicitud")>
	<cfset form.ESidsolicitud = url.ESidsolicitud >
</cfif>


<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		window.opener.document.form1.CFid_Detalle.value   		 = id;
		window.opener.document.form1.CFcodigo_Detalle.value 	 = name;
		window.opener.document.form1.CFdescripcion_Detalle.value = desc;
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
	<cfset filtro = filtro & " and upper(CFcodigo) like '%#UCase(Form.CFcodigo)#%' ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFcodigo=" & Form.CFcodigo>
</cfif>
<cfif isdefined("Form.CFdescripcion") and Len(Trim(Form.CFdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CFdescripcion) like '%#UCase(Form.CFdescripcion)#%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFdescripcion=" & Form.CFdescripcion>
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
			<input name="CFcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.CFcodigo")>#Form.CFcodigo#</cfif>" style="text-transform: uppercase;" onFocus="javascript:this.select();" >
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="CFdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CFdescripcion")>#Form.CFdescripcion#</cfif>" style="text-transform: uppercase;" onFocus="javascript:this.select();">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
		<cfif isdefined("form.ESidsolicitud")>
			<input type="hidden" name="ESidsolicitud" value="#form.ESidsolicitud#">
		</cfif>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="dataSolicitud" datasource="#session.DSN#">
	select CMTScodigo
	from ESolicitudCompraCM
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
</cfquery>

<cfquery name="rsLista" datasource="#session.DSN#">
	select d.CFcodigo,d.CFdescripcion,d.CFid,a.SNcodigo
	from ESolicitudCompraCM a
	
		inner join CMTiposSolicitud b
			on a.CMTScodigo = b.CMTScodigo
			and a.Ecodigo = b.Ecodigo
			
			inner join CMTSolicitudCF c
				on b.CMTScodigo = c.CMTScodigo
				and b.Ecodigo = c.Ecodigo
			
				inner join CFuncional d
					on c.CFid = d.CFid
					and c.Ecodigo = d.Ecodigo
	
				inner join CMSolicitantesCF e
					on d.CFid = e.CFid
	
	where e.CMSid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.compras.solicitante#">
	and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ESidsolicitud#">
	and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dataSolicitud.CMTScodigo)#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    <cfif isdefined("form.CFcodigo") and len(trim(form.CFcodigo))>
		and upper(d.CFcodigo) like upper('%#form.CFcodigo#%')
    </cfif>
    <cfif isdefined("form.CFdescripcion") and len(trim(form.CFdescripcion))>
    	and upper(d.CFdescripcion) like upper('%#form.CFdescripcion#%')
    </cfif> 
</cfquery>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisCFDetalleSolicitud.cfm"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CFid,CFcodigo,CFdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke>
</body>
</html>
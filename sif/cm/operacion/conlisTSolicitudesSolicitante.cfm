<cfif isdefined("url.fCMTScodigo") and not isdefined("form.fCMTScodigo")>
	<cfset form.fCMTScodigo= url.fCMTScodigo>
</cfif>
<cfif isdefined("url.fCMTSdescripcion") and not isdefined("form.fCMTSdescripcion")>
	<cfset form.fCMTSdescripcion= url.fCMTSdescripcion >
</cfif>
<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario= url.formulario >
</cfif>


<script language="JavaScript" type="text/javascript">
//La funcion recibe el CMTScodigo y CMTSdescripcion
function Asignar(id,descripcion){
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.fCMTScodigo.value   = id;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.fCMTSdescripcion.value = descripcion;
		window.close();
	}
}
</script>

<!---  Se asignan las variables que vienen por URL a FORM  ----->
<cfif isdefined("Url.fCMTScodigo") and not isdefined("Form.fCMTScodigo")>
	<cfparam name="Form.fCMTScodigo" default="#Url.fCMTScodigo#">
</cfif>
<cfif isdefined("Url.fCMTSdescripcion") and not isdefined("Form.fCMTSdescripcion")>
	<cfparam name="Form.fCMTSdescripcion" default="#Url.fCMTSdescripcion#">
</cfif>

<!---- Se establecen las variables de navegacion y filtros ----->
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fCMTScodigo") and Len(Trim(Form.fCMTScodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CMTScodigo) like '%" & #UCase(Form.fCMTScodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCMTScodigo=" & Form.fCMTScodigo>
</cfif>
<cfif isdefined("Form.fCMTSdescripcion") and Len(Trim(Form.fCMTSdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CMTSdescripcion) like '%" & #UCase(Form.fCMTSdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCMTSdescripcion=" & Form.fCMTSdescripcion>
</cfif>


<html>
<head>
<title>Lista de Tipos de Solicitud</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="1%" align="right"><strong>Código</strong></td>
		<td> 
			<input name="fCMTScodigo" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.fCMTScodigo")>#Form.fCMTScodigo#</cfif>" onFocus="javascript:this.select();" >
		</td>
		<td width="1%" align="right"><strong>Descripción</strong></td>
		<td> 
			<input name="fCMTSdescripcion" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.fCMTSdescripcion")>#Form.fCMTSdescripcion#</cfif>" onFocus="javascript:this.select();" >
		</td>

		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsSolicitudes" datasource="#session.DSN#" maxrows="200">
	select distinct rtrim(a.CMTScodigo) as CMTScodigo, a.CMTSdescripcion
	from CMTiposSolicitud a	
			inner join CMTSolicitudCF b
				on a.CMTScodigo = b.CMTScodigo
				and a.Ecodigo = b.Ecodigo
			
				inner join CMSolicitantesCF c
					on b.CFid = c.CFid
				
					inner join CMSolicitantes d
						on c.CMSid = d.CMSid
					
	where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif not isdefined("url.NoEsSolicitante") and isdefined('session.compras.solicitante') and len(trim(session.compras.solicitante))>
			and d.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.compras.solicitante#">
		</cfif>
		#preservesinglequotes(filtro)#	
	order by CMTSdescripcion
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
	<cfinvokeargument name="query" 				value="#rsSolicitudes#"/> 
	<cfinvokeargument name="desplegar" 			value="CMTScodigo, CMTSdescripcion"/> 
	<cfinvokeargument name="etiquetas" 			value="Código, Descripción"/> 
	<cfinvokeargument name="formatos" 			value="V,V"/> 
	<cfinvokeargument name="align" 				value="left,left"/> 
	<cfinvokeargument name="ajustar" 			value="N"/> 
	<cfinvokeargument name="checkboxes" 		value="N"/> 
	<cfinvokeargument name="irA" 				value="conlisTSolicitudesSolicitante.cfm"/> 
	<cfinvokeargument name="formname" 			value="listaSol"/> 
	<cfinvokeargument name="maxrows" 			value="15"/> 				
	<cfinvokeargument name="funcion" 			value="Asignar"/>
	<cfinvokeargument name="fparams" 			value="CMTScodigo,CMTSdescripcion"/>
	<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" 	value="yes"/>
</cfinvoke> 

</body>
</html>
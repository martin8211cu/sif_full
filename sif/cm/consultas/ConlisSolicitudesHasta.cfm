<!--- Recibe conexion, form, name y desc --->
<!----<cfset index = "">----->

<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.index")>
	<cfset index = Url.idx>
</cfif>
<cfif isdefined("Form.estado") and Len(Trim(Form.estado))>
	<cfset estado = Form.estado>
<cfelseif isdefined("Url.estado") and Len(Trim(Url.estado)) and not isdefined("Form.estado")>
	<cfset estado = Url.estado>
</cfif>

<script language="JavaScript" type="text/javascript">

function Asignar<cfoutput>#index#</cfoutput>(ESidsolicitud,ESnumero,ESobservacion) {
	if (window.opener != null) {
		window.opener.document.form1.ESidsolicitud<cfoutput>#index#</cfoutput>.value = ESidsolicitud;
		window.opener.document.form1.ESnumero<cfoutput>#index#</cfoutput>.value = ESnumero;
		window.opener.document.form1.ESobservacion<cfoutput>#index#</cfoutput>.value = ESobservacion;
		window.close();
	}
}
</script>

<cfif isdefined("Url.ESnumero") and not isdefined("Form.ESnumero")>
	<cfparam name="Form.ESnumero" default="#Url.ESnumero#">
</cfif>
<cfif isdefined("Url.ESobservacion") and not isdefined("Form.ESobservacion")>
	<cfparam name="Form.ESobservacion" default="#Url.ESobservacion#">
</cfif>

<cfif isdefined("Url.CMTScodigo") and not isdefined("Form.CMTScodigo")>
	<cfparam name="Form.CMTScodigo" default="#Url.CMTScodigo#">
</cfif>

<cfset filtroSol = "">
<cfset filtroObserv = "">
<cfset filtrotipo = "">
<cfset navegacion = "">

<cfif isdefined("Form.ESnumero") and Len(Trim(Form.ESnumero)) NEQ 0>
 	<cfset filtroSol = filtroSol & " and a.ESnumero =" & form.ESnumero >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ESnumero=" & Form.ESnumero>
</cfif>

<cfif isdefined("Form.ESobservacion") and Len(Trim(Form.ESobservacion)) NEQ 0>
 	<cfset filtroObserv = filtroObserv & " and upper(ESobservacion) like '%" & #UCase(Form.ESobservacion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ESobservacion=" & Form.ESobservacion>
</cfif>

<cfif isdefined("Form.CMTScodigo") and Len(Trim(Form.CMTScodigo)) NEQ 0>
 	<cfset filtrotipo = filtrotipo & " and a.CMTScodigo='#form.CMTScodigo#' " >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMTScodigo=" & Form.CMTScodigo>
</cfif>

<html>
<head>
<title>Lista de Solicitudes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>

<cfquery name="rsTipos" datasource="#session.DSN#">
	select a.CMTScodigo, a.CMTSdescripcion
	from CMTiposSolicitud a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsLista" datasource="#session.DSN#">
	select a.ESidsolicitud, c.CMTScodigo, c.CMTSdescripcion, a.ESnumero, a.ESfecha, a.CMSid, a.ESobservacion,b.CMSnombre	
	from ESolicitudCompraCM a
		
		inner join CMSolicitantes b
			on a.CMSid=b.CMSid
			and a.Ecodigo=b.Ecodigo
			#preservesinglequotes(filtroSol)#
			
		inner join CMTiposSolicitud c
			on a.Ecodigo=c.Ecodigo
			and a.CMTScodigo=c.CMTScodigo
			#preservesinglequotes(filtrotipo)#
					
	where a.ESestado in (-10,0,10,20,25,40,50,60)
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	#preservesinglequotes(filtroObserv)#
	order by a.CMTScodigo
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<form style="margin:0;" name="filtroOrden" method="post" action="ConlisSolicitudesHasta.cfm">
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td width="11%" align="right" nowrap><strong>Tipo Solicitud</strong></td>
					<td nowrap width="18%"> 
						<cfoutput>
						<select name="CMTScodigo">
							<option value="">Todos</option>
							<cfloop query="rsTipos">
								<option value="#rsTipos.CMTScodigo#" <cfif isdefined("form.CMTScodigo") and form.CMTScodigo eq rsTipos.CMTScodigo>selected</cfif> >#rsTipos.CMTSdescripcion#</option> 
							</cfloop>
						</select>
						</cfoutput>
					</td>
			<cfoutput>
					<td width="12%" align="right" nowrap><strong>N&uacute;mero Solicitud</strong></td>
					
					<td width="7%" nowrap> 
                        <input type="hidden" name="index" id="index" value="#index#">
                        <input type="hidden" name="estado" id="estado" value="#estado#">
						<input name="ESnumero" type="text" id="desc" size="10" maxlength="80" value="<cfif isdefined("Form.ESnumero")>#Form.ESnumero#</cfif>" onFocus="javascript:this.select();">
					</td>

					<td width="9%" align="right"><strong>Observación</strong></td>
					
					<td width="27%" nowrap> 
						<input name="ESobservacion" type="text" id="ESobservacion" size="40" maxlength="80" value="<cfif isdefined("Form.ESobservacion")>#Form.ESobservacion#</cfif>" onFocus="javascript:this.select();">
					</td>
					
					<td width="16%" align="center">
						<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					</td>
				</tr>
			</table>
		</cfoutput>
			</form>
		</td>
	</tr>	
	<tr>
		<td>
			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#rsLista#"/> 
				<cfinvokeargument name="desplegar" value=" ESnumero, ESfecha, CMSnombre, ESobservacion"/> 
				<cfinvokeargument name="etiquetas" value="N&uacute;mero de Solicitud, Fecha, Nombre Solicitante, Observacion"/> 
				<cfinvokeargument name="formatos" value="V,D,V,V"/> 
				<cfinvokeargument name="align" value="left,left,left,left"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="irA" value="ConlisSolicitudesHasta.cfm"/> 
				<!---<cfinvokeargument name="formname" value="listaOC"/> --->
				<cfinvokeargument name="maxrows" value="15"/> 
				
				<cfinvokeargument name="funcion" value="Asignar#index#"/>
				<cfinvokeargument name="fparams" value="ESidsolicitud,ESnumero,ESobservacion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
				<cfinvokeargument name="Cortes" value="CMTScodigo"/>
			</cfinvoke> 
		</td>
	</tr>
</table>
</cfoutput>

</body>
</html>
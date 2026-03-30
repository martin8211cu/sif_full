<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaInicio" default="Fecha Inicio" returnvariable="LB_FechaInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaFin" default="Fecha Fin" returnvariable="LB_FechaFin" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_Cerrada" default="Cerrada" returnvariable="LB_Cerrada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_En_Proceso" default="En proceso" returnvariable="LB_En_Proceso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Estado" default="Estado" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate"/>


<!--- FIN VARIABLES DE TRADUCCION --->
<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>

<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfparam name="Form.tipo" default="#Url.tipo#">
</cfif>

<cfif isdefined("Url.Cerradas") and not isdefined("Form.Cerradas")>
	<cfparam name="Form.Cerradas" default="#Url.Cerradas#">
</cfif>

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		if (window.opener.func#form.id#) {window.opener.func#form.id#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.RHEEdescripcion") and not isdefined("Form.RHEEdescripcion")>
	<cfparam name="Form.RHEEdescripcion" default="#Url.RHEEdescripcion#">
</cfif>

<cfset filtro = "">
<cfif not isdefined ('form.DEid')>
	<cfset form.DEid=''>
</cfif>
<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&desc=#form.desc#&DEid=#form.DEid#" >
<cfif isdefined("Form.RHEEdescripcion") and Len(Trim(Form.RHEEdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHEEdescripcion) like '%" & UCase(Form.RHEEdescripcion) & "%'">
	<cfset navegacion = navegacion & "&RHEEdescripcion=" & Form.RHEEdescripcion>
</cfif>

<html>
<head>
<title><cf_translate key="LB_ListaDeRelacionesDeEvaluacion">Lista de Relaciones de Evaluaci&oacute;n</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="conlisEvaluacion.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				<td> 
					<input name="RHEEdescripcion" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.RHEEdescripcion")>#Form.RHEEdescripcion#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.id") and len(trim(form.id))>
						<input type="hidden" name="id" value="#form.id#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
					<cfif isdefined("form.tipo") and len(trim(form.tipo))>
						<input type="hidden" name="tipo" value="#form.tipo#">
					</cfif>
					
					<cfif isdefined("form.Cerradas") and len(trim(form.Cerradas))>
						<input type="hidden" name="Cerradas" value="#form.Cerradas#">
					</cfif>
					<cfif isdefined("form.DEid") and len(trim(form.DEid))>
						<input type="hidden" name="DEid" value="#form.DEid#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>

		<cfquery name="rsLista" datasource="#session.DSN#">
			select RHEEid, RHEEdescripcion, RHEEfdesde as inicio, RHEEfhasta as fin
			<cfif isdefined("form.Cerradas") and form.Cerradas eq 'S'>
				, case RHEEestado 
					when 2 then '#LB_En_Proceso#' 
					when 3 then '#LB_Cerrada#'
					end as RHEEestados
			</cfif>	
			from RHEEvaluacionDes
			where Ecodigo=#session.Ecodigo# 
			
			<cfif isdefined("form.Cerradas") and form.Cerradas eq 'N'>
				and RHEEestado=3
			<cfelse>
				and RHEEestado in(2,3)
			</cfif>
				
			
			<cfif isdefined("form.tipo") and form.tipo eq 1>	<!--- POR HABILIDADES --->
				and PCid = -1
			<cfelseif isdefined("form.tipo") and form.tipo eq 2><!--- POR CUESTIONARIO --->
				and PCid  not in(-1,0)
			<cfelseif isdefined("form.tipo") and form.tipo eq 3>	<!--- POR CONOCIMIENTOS --->
				and PCid = 0
			<cfelseif isdefined("form.tipo") and form.tipo eq 4>	<!--- POR CONOCIMIENTOS y/o HABILIDADES--->
				and PCid <= 0
			</cfif>
			
			<cfif isdefined('form.DEid') and len(trim(form.DEid))>
		  		and RHEEid in (select distinct RHEEid from RHListaEvalDes where Ecodigo = #Session.Ecodigo# and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
		    </cfif>
		  
			<cfif isdefined("filtro") and len(trim(filtro))>
				#preservesinglequotes(filtro)#
			</cfif>
			
			order by inicio desc
		</cfquery>
		
		<cfif isdefined("form.Cerradas") and form.Cerradas eq 'N' or not isdefined('form.Cerradas')>
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="RHEEdescripcion,inicio,fin"/>
				<cfinvokeargument name="etiquetas" value="#LB_Descripcion#,#LB_FechaInicio#,#LB_FechaFin#"/>
				<cfinvokeargument name="formatos" value="S,D,D"/>
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="conlisEvaluacion.cfm"/>
				<cfinvokeargument name="formName" value="form1"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="RHEEid,RHEEdescripcion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			</cfinvoke>		
		<cfelse>
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="RHEEdescripcion,inicio,fin,RHEEestados"/>
				<cfinvokeargument name="etiquetas" value="#LB_Descripcion#,#LB_FechaInicio#,#LB_FechaFin#,#LB_Estado#"/>
				<cfinvokeargument name="formatos" value="S,D,D,S"/>
				<cfinvokeargument name="align" value="left,left,left,left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="conlisEvaluacion.cfm"/>
				<cfinvokeargument name="formName" value="form1"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="RHEEid,RHEEdescripcion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			</cfinvoke>			
		</cfif>
		

	</td></tr>	
</table>

</body>
</html>
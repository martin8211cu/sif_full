<cf_templateheader title="Inventarios">
	<cf_templatecss>
	<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Art&iacute;culos'>
		<cfinclude template="paramURL-FORM.cfm">	
		
		<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		<cf_dbfunction name="sPart"		args="Adescripcion,1,60"  returnvariable="Adescripcion">
		
		<cfif isdefined("url.btnNuevo") and not isdefined("form.btnNuevo")>
			<cfset form.btnNuevo = url.btnNuevo >
		</cfif>								

		<table width="100%"  border="0" cellpadding="0" cellspacing="0" >			
			<tr><td></td></tr>
			<tr>
				<td valign="top">
					<cfif isdefined('form.Aid') and form.Aid NEQ '' or isdefined('form.btnNuevo')>
						<cfinclude template="formArticulos.cfm">
					<cfelse>
						<!-- Filtro -->
						<cfset filtro = "a.Ecodigo=#Session.Ecodigo# and a.Ecodigo=b.Ecodigo and a.Ccodigo=b.Ccodigo" >
						<cfset campos_extra = '' >
						<cfif isdefined("form.pagenum_lista")>
							<cfset campos_extra = ",'#form.pagenum_lista#' as pagenum_lista" >
						</cfif>						
					
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="Articulos a, Clasificaciones b"/>
							<cfinvokeargument name="columnas" value="
								Aid
								, Acodigo
								, Acodalterno
								,#PreserveSingleQuotes(Adescripcion)# #_Cat#'...' as Adescripcion
								, b.Cdescripcion
								#preservesinglequotes(campos_extra)#"/>
							<cfinvokeargument name="desplegar" 			value="Acodigo, Acodalterno, Adescripcion"/>
							<cfinvokeargument name="etiquetas" 			value="C&oacute;digo, N&uacute;mero de Parte, Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" 			value="S,S,S"/>
							<cfinvokeargument name="filtro" 			value="#filtro# order by b.Cdescripcion"/>
							<cfinvokeargument name="align" 				value="left, left, left"/>
							<cfinvokeargument name="ajustar" 			value="N"/>
							<cfinvokeargument name="checkboxes" 		value="N"/>
							<cfinvokeargument name="keys" 				value="Aid"/>
							<cfinvokeargument name="irA" 				value="articulos-lista.cfm"/>
							<cfinvokeargument name="maxRows" 			value="#form.MaxRows#"/>					
							<cfinvokeargument name="Cortes" 			value="Cdescripcion"/>
							<cfinvokeargument name="mostrar_filtro" 	value="true"/>
							<cfinvokeargument name="botones" 			value="Nuevo"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>							
							<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						  </cfinvoke> 					
					</cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
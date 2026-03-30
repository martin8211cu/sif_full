
<cf_templateheader title="Tipos de Traslados de Presupuesto">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cf_web_portlet_start titulo="Tipos de Traslados de Presupuesto">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
		
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>		
			<cfif isdefined('url.filtro_CPTTcodigo') and not isdefined('form.filtro_CPTTcodigo')>
				<cfset form.filtro_CPTTcodigo = url.filtro_CPTTcodigo>
			</cfif>
			<cfif isdefined('url.filtro_CPTTdescripcion') and not isdefined('form.filtro_CPTTdescripcion')>
				<cfset form.filtro_CPTTdescripcion = url.filtro_CPTTdescripcion>
			</cfif>			
			<cfif isdefined('url.filtro_CPTTtipo') and not isdefined('form.filtro_CPTTtipo')>
				<cfset form.filtro_CPTTtipo = url.filtro_CPTTtipo>
			</cfif>
			<cfif isdefined('url.hfTipo') and not isdefined('form.hfTipo')>
				<cfset form.hfTipo = url.hfTipo>
			</cfif>
			<cfif isdefined('url.CPTTid') and not isdefined('form.CPTTid')>
				<cfset form.CPTTid = url.CPTTid>
			</cfif>				
			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="15">

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfset ffiltro = "">
		
				<tr class="tituloListas">
					<form name="filtroTipo" action="tipos.cfm" method="post" style="margin:0;">

					<td height="30" width="28%" nowrap="nowrap" align="left">Autorización:&nbsp;
						<select name="filtro_CPTTtipo">
							<option value="T" <cfif isdefined("form.filtro_CPTTtipo") and form.filtro_CPTTtipo eq ''>selected</cfif> >(Cualquiera)</option>
							<option value="I" <cfif isdefined("form.filtro_CPTTtipo") and form.filtro_CPTTtipo eq 'I'>selected</cfif> >Interna</option>
							<option value="E" <cfif isdefined("form.filtro_CPTTtipo") and form.filtro_CPTTtipo eq 'E'>selected</cfif> >Externa</option>
						</select>
						<input type="hidden" name="hfTipo" value="<cfif isdefined("form.filtro_CPTTtipo") and form.filtro_CPTTtipo NEQ ''><cfoutput>#form.filtro_CPTTtipo#</cfoutput></cfif>">
					</td>
				</tr>
				<cfset navegacion = "">
				<tr valign="top"> 
					<td colspan="2" valign="top" width="50%"> 
						<cfif isdefined("form.filtro_CPTTtipo") and len(trim(form.filtro_CPTTtipo)) NEQ 0 and form.filtro_CPTTtipo NEQ 'T'>
							<cfset ffiltro = ffiltro & " and CPTTtipo = '" & form.filtro_CPTTtipo & "'">
							<cfset navegacion = navegacion & "&filtro_CPTTtipo=#trim(form.filtro_CPTTtipo)#">
						</cfif>
						
						<cfset f_nuevo = false>
						<cfif isdefined('form.filtro_CPTTtipo') and form.filtro_CPTTtipo NEQ ''
							and isdefined('form.hfTipo') and form.hfTipo NEQ ''
							and form.filtro_CPTTtipo NEQ form.hfTipo>
								<cfset f_nuevo = true>
						</cfif>
						<cfset campos_extra = '' >
						<cfif isdefined("form.Pagina")>
							<cfset campos_extra = ",'#form.Pagina#' as pagenum_lista" >
						</cfif>	

						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="CPtipoTraslado a"/>
							<cfinvokeargument name="columnas" value="CPTTid, CPTTcodigo, 
																CPTTdescripcion, case CPTTtipo when 'I' then 'Traslados de Autorización Interna' when 'E' then 'Traslados de Autorización Externa' end as CPTTtipo
																#preservesinglequotes(campos_extra)#"/>
							<cfinvokeargument name="desplegar" value="CPTTcodigo, CPTTdescripcion"/>
							<cfinvokeargument name="etiquetas" value="Código, Tipo Traslado"/>
							<cfinvokeargument name="formatos" value="S,S"/>
							<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo#  #ffiltro# order by CPTTtipo desc, CPTTcodigo, CPTTdescripcion"/>
							<cfinvokeargument name="align" value="left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="tipos.cfm"/>
							<cfinvokeargument name="keys" value="CPTTid"/>
							<cfinvokeargument name="Cortes" value="CPTTtipo"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>							
							<cfinvokeargument name="incluyeForm" value="false"/>
							<cfinvokeargument name="formName" value="filtroTipo"/>
							<cfinvokeargument name="filtro_nuevo" value="#f_nuevo#"/>
						  </cfinvoke>  
					</td></form>
					<td width="50%" valign="top" ><cfinclude template="tiposForm.cfm"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>
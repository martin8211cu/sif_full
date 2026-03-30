
<cf_templateheader title="Conceptos de Servicio">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cf_web_portlet_start titulo="Conceptos de Servicio">
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
			<cfif isdefined('url.filtro_Ccodigo') and not isdefined('form.filtro_Ccodigo')>
				<cfset form.filtro_Ccodigo = url.filtro_Ccodigo>
			</cfif>
			<cfif isdefined('url.filtro_Cdescripcion') and not isdefined('form.filtro_Cdescripcion')>
				<cfset form.filtro_Cdescripcion = url.filtro_Cdescripcion>
			</cfif>			
			<cfif isdefined('url.fTipo') and not isdefined('form.fTipo')>
				<cfset form.fTipo = url.fTipo>
			</cfif>
			<cfif isdefined('url.hfTipo') and not isdefined('form.hfTipo')>
				<cfset form.hfTipo = url.hfTipo>
			</cfif>
			<cfif isdefined('url.Cid') and not isdefined('form.Cid')>
				<cfset form.Cid = url.Cid>
			</cfif>				
			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="15">

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfset ffiltro = "">
				<cfif session.menues.SMcodigo eq 'CC'>
					<cfset ffiltro = " and Ctipo ='I' ">
				<cfelseif	session.menues.SMcodigo eq 'CP'>
					<cfset ffiltro = " and Ctipo ='G' ">
				</cfif>
			
				<tr class="tituloListas">
					<form name="filtroTipo" action="Conceptos.cfm" method="post" style="margin:0;">

					<td height="30" width="28%" align="right">Tipo:&nbsp;</td>
					<td align="left">
						<select name="fTipo">
							<option value="T" <cfif isdefined("form.fTipo") and form.fTipo eq 'T'>selected</cfif> >Todos</option>
							<option value="G" <cfif isdefined("form.fTipo") and form.fTipo eq 'G'>selected</cfif> >Gastos</option>
							<option value="I" <cfif isdefined("form.fTipo") and form.fTipo eq 'I'>selected</cfif> >Ingresos</option> 
						</select>
						<input type="hidden" name="hfTipo" value="<cfif isdefined("form.fTipo") and form.fTipo NEQ ''><cfoutput>#form.fTipo#</cfoutput></cfif>">
					</td>
				</tr>
				<cfset navegacion = "">
				<tr valign="top"> 
					<td colspan="2" valign="top" width="50%"> 
						<cfif isdefined("form.fTipo") and len(trim(form.fTipo)) NEQ 0 and form.fTipo NEQ 'T'>
							<cfset ffiltro = ffiltro & " and Ctipo = '" & form.fTipo & "'">
							<cfset navegacion = navegacion & "&fTipo=#trim(form.fTipo)#">
						</cfif>
						<!--- <cfset ffiltro = ffiltro & " and Ctipo = 'I'"> --->
						<cfset f_nuevo = false>
						<cfif isdefined('form.fTipo') and form.fTipo NEQ ''
							and isdefined('form.hfTipo') and form.hfTipo NEQ ''
							and form.fTipo NEQ form.hfTipo>
								<cfset f_nuevo = true>
						</cfif>
						<cfset campos_extra = '' >
						<cfif isdefined("form.Pagina")>
							<cfset campos_extra = ",'#form.Pagina#' as pagenum_lista" >
						</cfif>	

						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="Conceptos a"/>
							<cfinvokeargument name="columnas" value="Cid, Ccodigo, 
																Cdescripcion, case Ctipo when 'I' then 'Ingreso' when 'G' then 'Gasto' end as Ctipo
																#preservesinglequotes(campos_extra)#"/>
							 <cfinvokeargument name="desplegar" value="Ccodigo, Cdescripcion"/>
							 <cfinvokeargument name="etiquetas" value="Código, Concepto"/>
							<cfinvokeargument name="formatos" value="S,S"/>
							<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# #ffiltro# order by Ctipo, Ccodigo, Cdescripcion"/>
							<cfinvokeargument name="align" value="left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="Conceptos.cfm"/>
							<cfinvokeargument name="keys" value="Cid"/>
							<cfinvokeargument name="Cortes" value="Ctipo"/>
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
					<td width="50%" valign="top" ><cfinclude template="formConceptos.cfm"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>
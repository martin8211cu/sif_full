<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			
			
			<cfif isdefined("url.MTcodigo") and len(trim(url.MTcodigo))>
				<cfset form.MTcodigo = url.MTcodigo>
			</cfif>
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>					
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
				<cfset form.MTcodigo = 0>
			</cfif>					
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<cfif isdefined("url.Filtro_MTdescripcion") and len(trim(url.Filtro_MTdescripcion))>
				<cfset form.Filtro_MTdescripcion = url.Filtro_MTdescripcion>
			</cfif>
			
			<cfparam name="form.Pagina" default="1">					
			<cfparam name="form.Filtro_MTdescripcion" default="">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
		  		<tr>
					<td width="40%" valign="top">
						
						<cfinvoke component="edu.Componentes.pListas" 
								  method="pListaEdu" 
								  returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="MateriaTipo"/>
							<cfinvokeargument name="columnas" value="convert(varchar,MTcodigo) as MTcodigo, substring(MTdescripcion,1,50) as MTdescripcion"/>
							<cfinvokeargument name="desplegar" value="MTdescripcion"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" value="V"/>
							<cfinvokeargument name="filtro" value="CEcodigo=#Session.Edu.CEcodigo# order by MTdescripcion"/>
							<cfinvokeargument name="align" value="left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="MateriaTipo.cfm"/>
							<cfinvokeargument name="conexion" value="#Session.Edu.Dsn#"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="keys" value="MTcodigo"/>
							<cfinvokeargument name="MaxRows" value="18"/>
						</cfinvoke>

					</td>
					<td valign="top"><cfinclude template="formMateriaTipo.cfm"></td>
				</tr>
		  	</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
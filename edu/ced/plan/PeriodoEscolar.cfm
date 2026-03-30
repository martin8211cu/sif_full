<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 01 de febrero del 2006
	Motivo: Actualizacin de fuentes de educacin a nuevos estndares de Pantallas y Componente de Listas.
 ---> 

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
			
			<cfif isdefined("Url.PEcodigo") and not isdefined("Form.PEcodigo")>
				<cfparam name="Form.PEcodigo" default="#Url.PEcodigo#">
			</cfif>
			<!--- VARIABLE DE LOS FILTROS CUANDO VIENEN DEL SQL --->
			<cfif isdefined('url.Filtro_PEdescripcion') and not isdefined('form.Filtro_PEdescripcion')>
				<cfparam name="Form.Filtro_PEdescripcion" default="#url.Filtro_PEdescripcion#">
			</cfif>
			<cfif isdefined('url.Filtro_PEorden') and not isdefined('form.Filtro_PEorden')>
				<cfparam name="Form.Filtro_PEorden" default="#url.Filtro_PEorden#">
			</cfif>
			<!--- DEFINICION DE VARIABLE --->		
			<cfparam name="form.Pagina" default="1">	
			<cfparam name="form.MaxRows" default="15">
			<cfparam name="form.Filtro_PEdescripcion" default="">
			<cfparam name="form.Filtro_PEorden" default="0">
			<table align="center" width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td valign="top">		
								<cfinvoke 
									component="sif.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value="PeriodoEscolar a, Nivel b"/>
									<cfinvokeargument name="columnas" value="convert(varchar,a.PEcodigo) as PEcodigo, 
																			 convert(varchar,a.Ncodigo) as Ncodigo, 
																			 a.PEorden, substring(a.PEdescripcion,1,50) as PEdescripcion,
																			 substring(b.Ndescripcion,1,50) as Ndescripcion  " />
									<cfinvokeargument name="desplegar" value="PEdescripcion, PEorden"/>
									<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Orden"/>
									<cfinvokeargument name="formatos" value="S,I"/>
									<cfinvokeargument name="filtro" value=" b.CEcodigo = #Session.Edu.CEcodigo# 
																			and a.Ncodigo = b.Ncodigo 
																			order by b.Norden, a.PEorden"/>
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="N,N"/>
									<cfinvokeargument name="cortes" value="Ndescripcion"/>
									<cfinvokeargument name="keys" value="PEcodigo"/>
									<cfinvokeargument name="irA" value="PeriodoEscolar.cfm"/> <!--- Nombre del Cat logo de Educacin --->
									<cfinvokeargument name="Conexion" value="#session.Edu.DSN#"/>
									<cfinvokeargument name="mostrar_filtro" value="true"/>									
									<cfinvokeargument name="filtrar_automatico" value="true"/>																		
									<cfinvokeargument name="filtrar_por" value="PEdescripcion,PEorden"/>
									<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>
								</cfinvoke>
							</td>
							<td valign="top"><cfinclude template="formPeriodoEscolar.cfm"></td>
						</tr>
					</table>
				</td>
			  </tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
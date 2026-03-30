<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
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
			<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
				<cfset form.DEid = url.DEid>
			</cfif>
			<cfif isdefined('url.RESNtipoRol') and not isdefined('form.RESNtipoRol')>
				<cfset form.RESNtipoRol = url.RESNtipoRol>
			</cfif>
			<cfif isdefined('url.filtro_DEidentificacion') and not isdefined('form.filtro_DEidentificacion')>
				<cfset form.filtro_DEidentificacion = url.filtro_DEidentificacion>
			</cfif>
			<cfif isdefined('url.filtro_Nombre') and not isdefined('form.filtro_Nombre')>
				<cfset form.filtro_Nombre = url.filtro_Nombre>
			</cfif>
			<cfif isdefined('url.filtro_corte') and not isdefined('form.filtro_corte')>
				<cfset form.filtro_corte = url.filtro_corte>
			</cfif>
			<cfif isdefined('url.hfiltro_DEidentificacion') and not isdefined('form.hfiltro_DEidentificacion')>
				<cfset form.hfiltro_DEidentificacion = url.hfiltro_DEidentificacion>
			</cfif>
			<cfif isdefined('url.hfiltro_Nombre') and not isdefined('form.hfiltro_Nombre')>
				<cfset form.hfiltro_Nombre = url.hfiltro_Nombre>
			</cfif>
			<cfif isdefined('url.hfiltro_corte') and not isdefined('form.hfiltro_corte')>
				<cfset form.hfiltro_corte = url.filtro_corte>
			</cfif>
			<cfset navegacion = "">
			<cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
				<cfset navegacion = navegacion & '&DEid=#form.DEid#'>
			</cfif>
			<cfif isdefined('form.RESNtipoRol') and LEN(TRIM(form.RESNtipoRol))>
				<cfset navegacion = navegacion & '&RESNtipoRol=#form.RESNtipoRol#'>
			</cfif>

			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr> 
					<td valign="top" width="50%"> 
						<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="10">
						<cfquery name="rsTipo" datasource="#session.DSN#">
							select -1 as value, 'Todos' as description from dual
							union all
							select 1 as value, 'Cobrador' as description from dual
							union all
							select 2 as value, 'Vendedor' as description from dual
							union all
							select 3 as value, 'Ejecutivo de Ventas' as description from dual
						</cfquery>
						<cf_dbfunction name="concat" args="a.DEnombre, ' ', a.DEapellido1, ' ', a.DEapellido2" returnvariable="Lvarnombre">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="DatosEmpleado a
																	inner join RolEmpleadoSNegocios b
																	on a.DEid = b.DEid
																		  and a.Ecodigo = b.Ecodigo"/>
							<cfinvokeargument name="columnas" value="a.DEid,b.Ecodigo, 
																	a.DEidentificacion, 
																	#Lvarnombre# as Nombre, 
																	b.RESNtipoRol,
																	case b.RESNtipoRol 
																	when 1 then 'Cobrador' 
																	when 2 then 'Vendedor' 
																	when 3 then 'Ejecutivo de Ventas' end as corte"/>
							<cfinvokeargument name="desplegar" value="DEidentificacion,Nombre,corte"/>
							<cfinvokeargument name="etiquetas" value="Identificación, Empleado, Rol" />
							<cfinvokeargument name="formatos" value="S,S,US"/>
							<cfinvokeargument name="filtrar_por" value="DEidentificacion,#Lvarnombre#,RESNtipoRol"/>
							<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# order by RESNtipoRol"/>
							<cfinvokeargument name="align" value="left, left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="showEmptyListMsg" value= "1"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<!--- <cfinvokeargument name="cortes" value="corte"/> --->
							<cfinvokeargument name="irA" value="RolEmpleadoCxC.cfm"/>
							<cfinvokeargument name="keys" value="DEid,RESNtipoRol"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>
							<cfinvokeargument name="rscorte" value="#rsTipo#"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
						</cfinvoke>  
					</td>
					<td valign="top" width="50%"><cfinclude template="RolEmpleadoCxC-form.cfm"></td>
				</tr>
			</table>
		<cf_web_portlet_end>	
	<cf_templatefooter>
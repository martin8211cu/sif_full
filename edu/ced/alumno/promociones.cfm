
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
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td>
					<!--- QUERY PARA EL COMBOBOX DEL FILTRO DE LA LISTA  --->
					<cfquery name="rsPRactivo" datasource="#session.Edu.DSN#">
						select -1 as value, '-- todos --' as description, 0 as ord
						union
						select distinct a.PRactivo as value, (case when a.PRactivo = 1 then 'Activo' else 'Inactivo' end) as description, 1 as ord
						from Promocion a, Nivel b, Grado c
						where a.Ncodigo=b.Ncodigo 
							and a.Gcodigo = c.Gcodigo 
							and CEcodigo=#Session.Edu.CEcodigo#
						order by 3,2
					</cfquery>
					
					<!---  VARIABLE LAVE PARA CUANDO VIENE DEL SQL --->
					<cfif isdefined("url.PRcodigo") and len(trim(url.PRcodigo))>
						<cfset form.PRcodigo = url.PRcodigo>
					</cfif>
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
					<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
						<cfset form.Pagina = url.Pagina>
					</cfif>					
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
					<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
						<cfset form.Pagina = url.PageNum_Lista>
						<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
						<cfset form.Ncodigo = 0>
					</cfif>					
					<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
					<cfif isdefined("url.Filtro_Ndescripcion") and len(trim(url.Filtro_Ndescripcion))>
						<cfset form.Filtro_Ndescripcion = url.Filtro_Ndescripcion>
					</cfif>
					<cfif isdefined("url.Filtro_Gdescripcion") and len(trim(url.Filtro_Gdescripcion))>
						<cfset form.Filtro_Gdescripcion = url.Filtro_Gdescripcion>
					</cfif>
					<cfif isdefined("url.Filtro_PRdescripcion") and len(trim(url.Filtro_PRdescripcion))>
						<cfset form.Filtro_PRdescripcion = url.Filtro_PRdescripcion>
					</cfif>	
					<cfif isdefined("url.Filtro_PRano") and len(trim(url.Filtro_PRano))>
						<cfset form.Filtro_PRano = url.Filtro_PRano>
					</cfif>	
					<cfif isdefined("url.Filtro_PRactivo") and len(trim(url.Filtro_PRactivo))>
						<cfset form.Filtro_PRactivo = url.Filtro_PRactivo>
					</cfif>					
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN--->
					<cfparam name="form.Pagina" default="1">					
					<cfparam name="form.Filtro_Ndescripcion" default="">
					<cfparam name="form.Filtro_Gdescripcion" default="">
					<cfparam name="form.Filtro_PRdescripcion" default="">
					<cfparam name="form.Filtro_PRano" default="">
					<cfparam name="form.Filtro_PRactivo" default="">
					<cfif len(trim(form.Pagina)) eq 0>
						<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
						<cfset form.Pagina = 1>
					</cfif>
					<!--- LISTA DEL MANTENIMIENTO --->
					<cfinvoke 
					 component="edu.Componentes.pListas"
					 method="pListaEdu"
					 returnvariable="pListaPlanEvalDet">
						<cfinvokeargument name="tabla" value="Promocion a, Nivel b, Grado c"/>
						<cfinvokeargument name="columnas" value="b.Ndescripcion,c.Gdescripcion,a.PRcodigo,a.PRdescripcion,a.PRano, (case when a.PRactivo = 1 then 'Activo' else 'Inactivo' end) as PRactivo, #form.Pagina# as Pagina"/> 
						<cfinvokeargument name="desplegar" value="Ndescripcion,Gdescripcion,PRdescripcion,PRano,PRactivo"/>
						<cfinvokeargument name="etiquetas" value="Nivel,Grado,Descripci&oacute;n,A&ntilde;o,Estado"/>
						<cfinvokeargument name="filtro" value="a.Ncodigo=b.Ncodigo and a.Gcodigo = c.Gcodigo and CEcodigo=#Session.Edu.CEcodigo# order by Norden,Gorden,PRano,PRdescripcion" /><!--- #filtro#  --->
						<cfinvokeargument name="align" value="left,left,left,center,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="formPromociones.cfm"/>
						<cfinvokeargument name="botones" value="Nuevo"/>
						<cfinvokeargument name="conexion" value="#Session.Edu.Dsn#"/>
						<cfinvokeargument name="keys" value="PRcodigo"/>
						<cfinvokeargument name="formatos" value="S,S,S,S,S"/>
						<cfinvokeargument name="MaxRows" value="20"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="b.Ndescripcion,c.Gdescripcion,a.PRdescripcion,a.PRano,PRactivo"/>
						<cfinvokeargument name="rspractivo" value="#rsPRactivo#"/>
					</cfinvoke>	
				</td>
			  </tr>
			</table>
			<script language="JavaScript" type="text/javascript" >
				function funcNuevo() {
					location.href = "formPromociones.cfm?pagina=<cfoutput>#form.Pagina#</cfoutput>&Filtro_Ndescripcion=<cfoutput>#Form.Filtro_Ndescripcion#</cfoutput>&Filtro_Gdescripcion=<cfoutput>#Form.Filtro_Gdescripcion#</cfoutput>&Filtro_PRdescripcion=<cfoutput>#Form.Filtro_PRdescripcion#</cfoutput>&Filtro_PRano=<cfoutput>#Form.Filtro_PRano#</cfoutput>&Filtro_PRactivo=<cfoutput>#Form.Filtro_PRactivo#</cfoutput>";
					return false;
				}
			</script>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
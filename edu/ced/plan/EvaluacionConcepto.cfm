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
			<!--- Aqui se incluye el form --->
			<!--- js para formatos numericos --->
			<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
		  		<tr><td colspan="2"></td></tr>		
				<tr>
					<td width="40%" valign="top">
							<!---  VARIABLE LAVE PARA CUANDO VIENE DEL SQL --->
							<cfif isdefined("url.ECcodigo") and len(trim(url.ECcodigo))>
								<cfset form.ECcodigo = url.ECcodigo>
							</cfif>
							<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
							<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
								<cfset form.Pagina = url.Pagina>
							</cfif>					
							<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
							<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
								<cfset form.Pagina = url.PageNum_Lista>
								<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
								<cfset form.ECcodigo = 0>
							</cfif>					
							
							<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
							<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
								<cfset form.Pagina = form.PageNum>
							</cfif>
							<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
							<cfif isdefined("url.Filtro_ECnombre") and len(trim(url.Filtro_ECnombre))>
								<cfset form.Filtro_ECnombre = url.Filtro_ECnombre>
							</cfif>
							<cfif isdefined("url.Filtro_ECorden") and len(trim(url.Filtro_ECorden))>
								<cfset form.Filtro_ECorden = url.Filtro_ECorden>
							</cfif>
							<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
							<cfparam name="form.Pagina" default="1">					
							<cfparam name="form.MaxRows" default="15">
							<cfparam name="form.Filtro_ECnombre" default="">
							<cfparam name="form.Filtro_ECorden" default="0.00">
							
						<cfinvoke component="edu.Componentes.pListas" 
								  method="pListaEdu" 
								  returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="EvaluacionConcepto"/>
							<cfinvokeargument name="columnas" value="ECcodigo , substring(ECnombre,1,50) as ECnombre, ECorden"/>
							<cfinvokeargument name="desplegar" value="ECnombre, ECorden"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Orden"/>
							<cfinvokeargument name="formatos" value="V,I"/>
							<cfinvokeargument name="filtro" value="CEcodigo=#Session.Edu.CEcodigo# order by ECorden, upper(ECnombre)"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N,N"/>
							<cfinvokeargument name="irA" value="EvaluacionConcepto.cfm"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="keys" value="ECcodigo"/>
							<cfinvokeargument name="MaxRows" value="#form.MaxRows#"/>
							<cfinvokeargument name="conexion" value="#Session.Edu.DSN#"/>
						</cfinvoke>

					</td>
					<td valign="top"><cfinclude template="formEvaluacionConcepto.cfm"></td>
				</tr>	
		  	</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
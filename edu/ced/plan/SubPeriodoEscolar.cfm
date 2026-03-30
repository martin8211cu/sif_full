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
			
			<!---  VARIABLE LlAVE PARA CUANDO NAVEGA LA LISTA DE DETALLES --->
			<cfif isdefined("url.navega_PEcodigo") and len(trim(url.navega_PEcodigo)) and not isdefined("url.PEcodigo")and not isdefined("form.PEcodigo")>
				<cfset form.PEcodigo = url.navega_PEcodigo>
			</cfif>
			<!---  VARIABLES LlAVE DEL ENCABEZADO PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.SPEcodigo") and len(trim(url.SPEcodigo))>
				<cfset form.SPEcodigo = url.SPEcodigo>
			</cfif>
			<cfif isdefined("url.PEcodigo") and len(trim(url.PEcodigo))>
				<cfset form.PEcodigo = url.PEcodigo>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.Filtro_SPEdescripcion") and len(trim(url.Filtro_SPEdescripcion))>
				<cfset form.Filtro_SPEdescripcion = url.Filtro_SPEdescripcion>
			</cfif>
			<cfif isdefined("url.Filtro_SPEfechainicio") and len(trim(url.Filtro_SPEfechainicio))>
				<cfset form.Filtro_SPEfechainicio = url.Filtro_SPEfechainicio>
			</cfif>	
			<cfif isdefined("url.Filtro_SPEfechafin") and len(trim(url.Filtro_SPEfechafin))>
				<cfset form.Filtro_SPEfechafin = url.Filtro_SPEfechafin>
			</cfif>
			<cfif isdefined("url.Filtro_Vigente") and len(trim(url.Filtro_Vigente))>
				<cfset form.Filtro_Vigente = url.Filtro_Vigente>
			</cfif>
			<cfif isdefined("url.Filtro_FechasMayores") and len(trim(url.Filtro_FechasMayores))>
				<cfset form.Filtro_FechasMayores = url.Filtro_FechasMayores>
			</cfif>
					
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">					
			<cfparam name="form.Filtro_SPEdescripcion" default="">
			<cfparam name="form.Filtro_SPEfechainicio" default="">
			<cfparam name="form.Filtro_SPEfechafin" default="">
			<cfparam name="form.Filtro_Vigente" default="">
			<cfparam name="form.Filtro_FechasMayores" default="">
			
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			
			<!--- PARAMETROS DEL DETALLE Y LA LISTA DE DETALLES --->
			<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.PEevaluacion") and len(trim(url.PEevaluacion))>
				<cfset form.PEevaluacion = url.PEevaluacion>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
				<cfset form.Pagina2 = url.Pagina2>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
				<cfset form.Pagina2 = url.PageNum_Lista2>
				<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
				<cfset form.PEevaluacion = 0>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
				<cfset form.Pagina2 = form.PageNum2>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.Filtro_PEdescripcion") and len(trim(url.Filtro_PEdescripcion))>
				<cfset form.Filtro_PEdescripcion = url.Filtro_PEdescripcion>
			</cfif>
			<cfif isdefined("url.Filtro_FechaInicio") and len(trim(url.Filtro_FechaInicio))>
				<cfset form.Filtro_FechaInicio = url.Filtro_FechaInicio>
			</cfif>
			<cfif isdefined("url.Filtro_Fechafin") and len(trim(url.Filtro_Fechafin))>
				<cfset form.Filtro_Fechafin = url.Filtro_Fechafin>
			</cfif>
			<cfif isdefined("url.Filtro_vigente2") and len(trim(url.Filtro_vigente2))>
				<cfset form.Filtro_vigente2 = url.Filtro_vigente2>
			</cfif>
			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina2" default="1">					
			<cfparam name="form.Filtro_PEdescripcion" default="">
			<cfparam name="form.Filtro_FechaInicio" default="">
			<cfparam name="form.Filtro_Fechafin" default="">
			<cfparam name="form.Filtro_vigente2" default="">
			<cfparam name="form.MaxRows2" default="2">
			<cfif len(trim(form.Pagina2)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina2 = 1>
			</cfif>
			
			<!--- ENVIA LOS VALORES DE LOS IDS, FILTROS Y PAGINA DE LA LISTA PRINCIPAL --->		
			<cfset navega="">
			<!---ids--->
			<cfif isdefined("form.SPEcodigo")and len(trim(form.SPEcodigo))>
				<cfset navega = "SPEcodigo="&form.SPEcodigo>
			</cfif>
			
			<!---pg--->
			<cfif isdefined("form.pagina") and len(trim(form.pagina))>
				<cfset navega = navega & "&pagina="&form.pagina>
			</cfif>
			<!---filtros--->
			<cfif isdefined("form.Filtro_SPEdescripcion") and len(trim(form.Filtro_SPEdescripcion))>
				<cfset navega = navega & "&Filtro_SPEdescripcion="&form.Filtro_SPEdescripcion>
			</cfif>
			<cfif isdefined("form.Filtro_SPEfechainicio") and len(trim(form.Filtro_SPEfechainicio))>
				<cfset navega = navega & "&Filtro_SPEfechainicio="&form.Filtro_SPEfechainicio>
			</cfif>
			<cfif isdefined("form.Filtro_SPEfechafin") and len(trim(form.Filtro_SPEfechafin))>
				<cfset navega = navega & "&Filtro_SPEfechafin="&form.Filtro_SPEfechafin>
			</cfif>
			<cfif isdefined("form.Filtro_Vigente") and len(trim(form.Filtro_Vigente))>
				<cfset navega = navega & "&Filtro_Vigente="&form.Filtro_Vigente>
			</cfif>
			<cfif isdefined("form.Filtro_FechasMayores") and len(trim(form.Filtro_FechasMayores))>
				<cfset navega = navega & "&Filtro_FechasMayores="&form.Filtro_FechasMayores>
			</cfif>
			<cfif isdefined("form.PEcodigo") and len(trim(form.PEcodigo))>
				<cfset navega = navega & "&navega_PEcodigo="&form.PEcodigo>
			</cfif>
			
			<!--- TABLA PARA CONTENER EL MANTENIMIENTO ESTILO ENCABEZADO / LISTA DETALLES | DETATALLES--->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td><cfinclude template="formSubPeriodoEscolar.cfm"></td>
			  </tr>
			  <cfparam name="modo" default="ALTA">
			  <cfif (modo neq "ALTA")>
			  <tr>
				<td>	
					<!--- Lista Detalles --->
					<!--- , case POvigente when 1 then '<img border=''0'' src=''../../Imagenes/educ/DSL_D.gif''>' when 0 then '' else '' end as vigente --->
					<cfinvoke 
					 component="edu.Componentes.pListas"
					 method="pListaEdu"
					 returnvariable="pListaPlan">
						<cfinvokeargument name="tabla" value="SubPeriodoEscolar a, PeriodoOcurrencia b, PeriodoEvaluacion c"/>
						<cfinvokeargument name="columnas" value="#form.SPEcodigo# as SPEcodigo,PEevaluacion,substring(c.PEdescripcion,1,50) as PEdescripcion, b.PEcodigo, POfechainicio as FechaInicio, POfechafin as  Salida
																,#form.Pagina# as pagina
																,'#form.Filtro_SPEdescripcion#' as Filtro_SPEdescripcion,'#form.Filtro_SPEfechainicio#' as Filtro_SPEfechainicio,'#form.Filtro_SPEfechafin#' as Filtro_SPEfechafin,'#form.Filtro_FechasMayores#' as Filtro_FechasMayores,'#form.Filtro_Vigente#' as Filtro_Vigente"/>
						<cfinvokeargument name="desplegar" value="PEdescripcion, FechaInicio, Salida"/>
						<cfinvokeargument name="etiquetas" value="Periódo,Entrada,Salida"/>
						<cfinvokeargument name="formatos" value="S,D,D"/>
						<cfinvokeargument name="filtro" value="a.PEcodigo = #form.PEcodigo# and a.SPEcodigo = #form.SPEcodigo# and a.PEcodigo = b.PEcodigo and a.SPEcodigo = b.SPEcodigo and b.PEevaluacion = c.PEcodigo order by c.PEorden"/>
						<cfinvokeargument name="align" value="left,center,center"/>
						<cfinvokeargument name="irA" value="SubPeriodoEscolar.cfm"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_por" value="PEdescripcion,FechaInicio,Salida"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="keys" value="PEevaluacion"/>
						<cfinvokeargument name="MaxRows" value="#MaxRows2#"/>
						<cfinvokeargument name="formName" value="lista2"/>
						<cfinvokeargument name="PageIndex" value="2"/>
						<cfinvokeargument name="navegacion" value="#navega#"/>
					</cfinvoke>
					
					<script language="javascript" type="text/javascript">
						function funcFiltrar2(){
							document.lista2.action = "SubPeriodoEscolar.cfm<cfoutput>?SPEcodigo=#SPEcodigo#&PEcodigo=#PEcodigo#&Pagina=#Form.Pagina#&Filtro_SPEdescripcion=#Form.Filtro_SPEdescripcion#&Filtro_SPEfechainicio=#Form.Filtro_SPEfechainicio#&Filtro_SPEfechafin=#Form.Filtro_SPEfechafin#&Filtro_Vigente=#Form.Filtro_Vigente#&Filtro_FechasMayores=#Form.Filtro_FechasMayores#</cfoutput>";
							return true;
						}
					</script>
				</td>
			  </tr>
			  </cfif>
			</table>
			
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
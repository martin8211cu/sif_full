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
			
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
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
			
			<!--- SE DEFINE LA NAVEGACION --->
			<cfset nav = "">
			
			<cfif isdefined("form.Filtro_SPEdescripcion") and len(trim(form.Filtro_SPEdescripcion))>
				<cfset nav = nav & "&Filtro_SPEdescripcion="&form.Filtro_SPEdescripcion>
			</cfif>
			<cfif isdefined("form.Filtro_SPEfechainicio") and len(trim(form.Filtro_SPEfechainicio))>
				<cfset nav = nav & "&Filtro_SPEfechainicio="&form.Filtro_SPEfechainicio>
			</cfif>
			<cfif isdefined("form.Filtro_SPEfechafin") and len(trim(form.Filtro_SPEfechafin))>
				<cfset nav = nav & "&Filtro_SPEfechafin="&form.Filtro_SPEfechafin>
			</cfif>
			<cfif isdefined("form.Filtro_Vigente") and len(trim(form.Filtro_Vigente))>
				<cfset nav = nav & "&Filtro_Vigente="&form.Filtro_Vigente>
			</cfif>
			
			<!--- Lista --->
			<cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="tabla" value="SubPeriodoEscolar a, PeriodoEscolar b, Nivel c, PeriodoVigente d"/>
				<cfinvokeargument name="columnas" value="a.SPEcodigo,b.PEcodigo, a.SPEorden, substring(a.SPEdescripcion,1,50) as SPEdescripcion, convert(varchar,a.SPEfechafin,103) as SPEfechafin, convert(varchar,a.SPEfechainicio,103) as SPEfechainicio , c.Ndescripcion + ' : ' + b.PEdescripcion as PEdescripcion, case when d.PEevaluacion is not null then 'Vigente' else '' end as Vigente
														, #form.pagina# as pagina"/>
				<cfinvokeargument name="desplegar" value="SPEdescripcion, SPEfechainicio, SPEfechafin"/>
				<cfinvokeargument name="etiquetas" value="Nombre del Curso Lectivo, Fecha de Inicio, Fecha de T&eacute;rmino"/>
				<cfinvokeargument name="filtro" value=" c.CEcodigo = #Session.Edu.CEcodigo# and a.PEcodigo = b.PEcodigo and b.Ncodigo = c.Ncodigo and b.Ncodigo *= d.Ncodigo and a.PEcodigo *= d.PEcodigo and a.SPEcodigo *= d.SPEcodigo order by c.Norden, b.PEorden, a.SPEorden"/><!--- #filtro# --->
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value="N,N,N"/>
				<cfinvokeargument name="irA" value="SubPeriodoEscolar.cfm"/>
				<cfinvokeargument name="cortes" value="PEdescripcion"/>
				<cfinvokeargument name="botones" value="Nuevo"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
				<cfinvokeargument name="keys" value="SPEcodigo"/>
				<cfinvokeargument name="formatos" value="S,D,D"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="navegacion" value="#nav#"/>
				<cfinvokeargument name="Filtrar_por" value="a.SPEdescripcion,a.SPEfechainicio,a.SPEfechafin"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
			</cfinvoke>
			
			<script language="javascript" type="text/javascript">			
				function funcNuevo(){
					location.href = "SubPeriodoEscolar.cfm<cfoutput>?Pagina=#Form.Pagina#&Filtro_SPEdescripcion=#Form.Filtro_SPEdescripcion#&Filtro_SPEfechainicio=#Form.Filtro_SPEfechainicio#&Filtro_SPEfechafin=#Form.Filtro_SPEfechafin#&Filtro_Vigente=#Form.Filtro_Vigente#</cfoutput>";
					return false;
				}
			</script>
			
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
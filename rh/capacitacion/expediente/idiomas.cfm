
<cfset t = createObject("component", "sif.Componentes.Translate")>
 
<!----- Etiquetas de traduccion------>
<cfset LB_Idiomas = t.translate('LB_Idiomas','Idiomas','/curriculumExt/curriculum.xml')>

<cfinvoke key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="vIdentificacion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Nombre" Default="Nombre" returnvariable="vNombre" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Empleado" Default="Empleado" returnvariable="vEmpleado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
 
<cf_templateheader template="#session.sitio.template#">
	
<cf_web_portlet_start>
	<div class="row">
		<div class="col-sm-12">
			<cf_navegacion name="DEid">	
				
			<cfif isDefined("form.DEid") and len(trim(form.DEid))>
				<cfinclude template="idiomas-form.cfm">
			<cfelse>
				<cfset filtro = "">
				<cfset navegacion = "">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
				<cfif isdefined("Form.FILTRO_NOMBREEMPL") and Len(Trim(Form.FILTRO_NOMBREEMPL)) NEQ 0>
					<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }) like '%" & #TRIM(UCase(Form.FILTRO_NOMBREEMPL))# & "%'">

					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.FILTRO_NOMBREEMPL>
				</cfif>
				<cfif isdefined("Form.FILTRO_DEIDENTIFICACION") and Len(Trim(Form.FILTRO_DEIDENTIFICACION)) NEQ 0>
					<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & TRIM(UCase(Form.FILTRO_DEIDENTIFICACION)) & "%'">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FILTRO_DEIDENTIFICACION=" & Form.FILTRO_DEIDENTIFICACION>
				</cfif>
				<cfquery name="rsLista" result="rsLista_PlistaResult_" datasource="#session.DSN#">
					select DEid,
						   DEidentificacion,
						   DEtarjeta,
						   {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) } as nombreEmpl, 
						   1 as o, 
						   1 as sel,
						   'ALTA' as modo

					from DatosEmpleado

					where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined("filtro") and len(trim(filtro))>
						#PreserveSingleQuotes(filtro)#
					</cfif>
					
					order by DEidentificacion, DEapellido1, DEapellido2, DEnombre
				</cfquery>

				<cfinvoke 
		 			component="rh.Componentes.pListas"
		 			method=	"pListaQuery"
		 			returnvariable="pListaEmpl">
		 			<cfinvokeargument name="query" value="#rsLista#"/>
		 			<cfinvokeargument name="useAJAX" value="yes">
		 			<cfinvokeargument name="queryresult" value="#rsLista_PlistaResult_#">
		 			<cfinvokeargument name="datasource" value="#session.DSN#">
					<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl"/>
					<cfinvokeargument name="etiquetas" value="#vIdentificacion#,#vEmpleado#"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="formName" value="listaEmpleados"/>	
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="idiomas.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="keys" value="DEid"/>
				</cfinvoke>
			</cfif>
		</div>
	</div>
<cf_web_portlet_end>
<cf_templatefooter>


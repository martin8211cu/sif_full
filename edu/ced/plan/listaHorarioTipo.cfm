<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 25 de febrero del 2006
	Motivo: Actualización de fuentes de educación a nuevos estándares de Pantallas y Componente de Listas.
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
			<cfparam name="form.Pagina" default="1">
			<form name="form1" method="post" action="HorarioTipo.cfm" style="margin:0">
				<cfoutput>
				<input name="Pagina" type="hidden" value="#form.Pagina#">
				</cfoutput>
			
				<cfinvoke component="sif.Componentes.pListas"
									 method="pLista"
									 returnvariable="pListaRet">
					<cfinvokeargument name="columnas"  			value="Hcodigo, Hnombre"/>
					<cfinvokeargument name="tabla"  			value="HorarioTipo"/>
					<cfinvokeargument name="filtro"  			value="CEcodigo = #Session.Edu.CEcodigo# group by Hcodigo"/>
					<cfinvokeargument name="desplegar"  		value="Hnombre"/>			
					<cfinvokeargument name="filtrar_por"  		value="Hnombre"/>
					<cfinvokeargument name="etiquetas"  		value="Horario"/>
					<cfinvokeargument name="formatos"   		value="S"/>
					<cfinvokeargument name="align"      		value="left"/>
					<cfinvokeargument name="ajustar"    		value="N"/>
					<cfinvokeargument name="irA"        		value="HorarioTipo.cfm"/>
					<cfinvokeargument name="showLink" 			value="true"/>
					<cfinvokeargument name="botones"    		value="Nuevo"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
					<cfinvokeargument name="maxrows" 			value="15"/>
					<cfinvokeargument name="keys"             	value="Hcodigo"/>
					<cfinvokeargument name="mostrar_filtro"		value="true"/>
					<cfinvokeargument name="filtrar_automatico"	value="true"/>
					<cfinvokeargument name="conexion"			value="#session.Edu.DSN#"/>
					<cfinvokeargument name="incluyeForm"		value="false"/>
					<cfinvokeargument name="formName"			value="form1"/>
					</cfinvoke>
			</form>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
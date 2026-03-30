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
			
			<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.id_tipo") and len(trim(url.id_tipo))>
				<cfset form.id_tipo = url.id_tipo>
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
			<cfif isdefined("url.Filtro_nombre_tipo") and len(trim(url.Filtro_nombre_tipo))>
				<cfset form.Filtro_nombre_tipo = url.Filtro_nombre_tipo>
			</cfif>
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">					
			<cfparam name="form.Filtro_nombre_tipo" default="">
			<cfif len(trim(form.Pagina)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina = 1>
			</cfif>
			
			<!--- PARAMETROS DEL DETALLE Y LA LISTA DE DETALLES --->
			<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.id_atributo") and len(trim(url.id_atributo))>
				<cfset form.id_atributo = url.id_atributo>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
				<cfset form.Pagina2 = url.Pagina2>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
				<cfset form.Pagina2 = url.PageNum_Lista2>
				<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
				<cfset form.id_atributo = 0>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
				<cfset form.Pagina2 = form.PageNum2>
			</cfif>
			<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.Filtro_nombre_atr") and len(trim(url.Filtro_nombre_atr))>
				<cfset form.Filtro_nombre_atr = url.Filtro_nombre_atr>
			</cfif>
			<cfif isdefined("url.Filtro_TipoAtr") and len(trim(url.Filtro_TipoAtr))>
				<cfset form.Filtro_TipoAtr = url.Filtro_TipoAtr>
			</cfif>
			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina2" default="1">					
			<cfparam name="form.Filtro_nombre_atr" default="">
			<cfparam name="form.Filtro_TipoAtr" default="">
			<cfparam name="form.MaxRows2" default="10">
			<cfif len(trim(form.Pagina2)) eq 0>
				<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
				<cfset form.Pagina2 = 1>
			</cfif>
			<!--- TABLA PARA CONTENER EL MANTENIMIENTO ESTILO ENCABEZADO / LISTA DETALLES | DETATALLES--->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td> <cfinclude template="formBiblioteca.cfm"></td>
			  </tr>
			 
			  <cfparam name="modo" default="ALTA">
			  <cfif (modo neq "ALTA")>
			  <tr>
				<td>
					<!--- QUERY PARA EL COMBOBOX DEL FILTRO DE LA LISTA  --->
					<cfquery name="rsTipoAtr" datasource="#session.Edu.DSN#">
						select '' as value, '-- todos --' as description, '0' as ord
						union
						select 'N' as value, 'Numerico' as description, '1' as ord
						union
						select 'T' as value, 'Text' as description, '1' as ord
						union
						select 'F' as value, 'Fecha' as description, '1' as ord
						union
						select 'V' as value, 'Valores' as description, '1' as ord
						order by 3,2
					</cfquery>
					
					<!--- LISTA DEL MANTENIMIENTO --->
					<cfinvoke 
						 component="edu.Componentes.pListas"
						 method="pListaEdu"
						 returnvariable="pListaPlanEvalDet">
						<cfinvokeargument name="tabla" value="MATipoDocumento a,  MAAtributo b"/>
						<cfinvokeargument name="columnas" value="#form.id_tipo# as id_tipo,convert(varchar,b.id_atributo) as id_atributo, b.nombre_atributo as nombre_atr, (case b.tipo_atributo when 'N' then 'Numérico' when 'T' then 'Texto' when 'F' then 'Fecha' when 'V' then 'Valores' else 'No definido' end) as TipoAtr,
																#form.Pagina# as Pagina, '#form.Filtro_nombre_tipo#' as Filtro_nombre_tipo"/>
						<cfinvokeargument name="desplegar" value="nombre_atr, TipoAtr"/>
						<cfinvokeargument name="etiquetas" value="Nombre Atributo,Tipo"/>
						<cfinvokeargument name="filtro" value=" b.CEcodigo = #Session.Edu.CEcodigo# and a.id_tipo = #form.id_tipo# and a.id_tipo = b.id_tipo order by b.orden_atributo, b.nombre_atributo"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N,N"/>
						<cfinvokeargument name="irA" value="Biblioteca.cfm"/>
						<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
						<cfinvokeargument name="keys" value="id_atributo"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="PageIndex" value="2"/>
						<cfinvokeargument name="formname" value="lista2"/>
						<cfinvokeargument name="navegacion" value="&id_tipo=#id_tipo#&Pagina=#Form.Pagina#&Filtro_nombre_tipo=#Form.Filtro_nombre_tipo#"/>
						<cfinvokeargument name="MaxRows" value="#form.MaxRows2#"/>
						<cfinvokeargument name="filtrar_por" value="b.nombre_atributo, b.tipo_atributo"/>
						<cfinvokeargument name="rstipoAtr" value="#rsTipoAtr#"/>
					</cfinvoke>
					
					 <script language="javascript" type="text/javascript">
						function funcFiltrar2(){
							document.lista2.action = "Biblioteca.cfm<cfoutput>?id_tipo=#id_tipo#&Pagina=#Form.Pagina#&Filtro_nombre_tipo=#Form.Filtro_nombre_tipo#</cfoutput>";
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
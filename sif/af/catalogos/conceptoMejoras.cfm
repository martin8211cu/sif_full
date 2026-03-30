<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<!--- Aqui se incluye el form --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr><td>&nbsp;</td></tr>
		  <tr>
			<td>&nbsp;</td>
			<td valign="top" width="45%">
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
				<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
					<cfset form.Pagina = url.Pagina>
				</cfif>					
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
				<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
					<cfset form.Pagina = url.PageNum_Lista>
					<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
					<cfset form.AFCMid = 0>
				</cfif>					
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
				<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
					<cfset form.Pagina = form.PageNum>
				</cfif>
				<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
				<cfif isdefined("url.AFCMid") and len(trim(url.AFCMid))>
					<cfset form.AFCMid = url.AFCMid>
				</cfif>
				
				<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
				<cfparam name="form.Pagina" default="1">					
				<cfparam name="form.MaxRows" default="15">
				
                <fieldset><legend>Lista de Conceptos de Mejoras</legend>
                    <cfinvoke 
                     component="sif.Componentes.pListas"
                     method="pLista"
                     returnvariable="pListaRet">
                        <cfinvokeargument name="tabla" value="AFConceptoMejoras a"/>
                        <cfinvokeargument name="columnas" value="a.AFCMid, a.AFCMcodigo, a.AFCMdescripcion, a.ts_rversion"/>
                        <cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo#"/>
                        <cfinvokeargument name="desplegar" value="AFCMcodigo, AFCMdescripcion"/>
                        <cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
                        <cfinvokeargument name="formatos" value="S,S"/>
                        <cfinvokeargument name="align" value="left,left"/>
                        <cfinvokeargument name="ajustar" value="N,N"/>
                        <cfinvokeargument name="irA" value="conceptoMejoras.cfm"/>
                        <cfinvokeargument name="conexion" value="#session.dsn#"/>
                        <cfinvokeargument name="mostrar_filtro" value="true"/>
                        <cfinvokeargument name="filtrar_automatico" value="true"/>
                        <cfinvokeargument name="keys" value="AFCMid"/>
                        <cfinvokeargument name="MaxRows" value="#form.MaxRows#"/>
                    </cfinvoke>
				</fieldset>
			</td>
			<td>&nbsp;</td>
			<td valign="top" width="45%">
				<!--- MANTENIMIENTO --->
				<cfinclude template="conceptoMejoras-form.cfm">
			</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
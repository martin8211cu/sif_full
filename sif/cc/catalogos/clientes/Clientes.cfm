<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<script language="javascript" type="text/javascript">
				function funcNuevo(){
					location.href='DatosClientes.cfm';
					return true;
				}
			</script>
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="15">
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
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfset navegacion = "">
				<tr valign="top"> 
					<td valign="top" width="100%"> 
						<form name="form1" method="post" action="DatosClientes.cfm">
							<cfoutput>
							<input name="Pagina" type="hidden" value="#form.pagina#">
							<input name="MaxRows" type="hidden" value="#form.MaxRows#">
							</cfoutput>
							<cfquery name="rsEstados" datasource="#session.DSN#">
								select '' as value, 'Todos' as description from dual
								union all
								select 'P' as value, 'En Proceso' as description from dual
								union all
								select 'A' as value, 'Aprobado' as description from dual
								union all
								select 'R' as value, 'Rechazado' as description from dual
								union all
								select 'I' as value, 'Inactivo' as description from dual
							</cfquery>
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="ClienteDetallista"/>
								<cfinvokeargument name="columnas" value="CDid, CDidentificacion, CDapellido1 #_Cat# ' ' #_Cat# CDapellido2 #_Cat#  ', ' #_Cat# CDnombre as CDnombre,case when CDactivo = 'P' then 'En Proceso' when CDactivo = 'A' then 'Aprobado' when CDactivo = 'R' then 'Rechazado' when CDactivo = 'I' then 'Inactivo' else 'No definido' end as rotulo"/>
								 <cfinvokeargument name="desplegar" value="CDidentificacion, CDnombre, rotulo"/>
								 <cfinvokeargument name="etiquetas" value="Identificaci&oacute;n, Nombre, Estado"/>
								<cfinvokeargument name="formatos" value="S,S,S"/>
								<cfinvokeargument name="filtro" value="CEcodigo = #session.CEcodigo# order by  CDidentificacion"/>
								<cfinvokeargument name="filtrar_por" value="CDidentificacion,CDapellido1 #_Cat# ' ' #_Cat# CDapellido2 #_Cat# CDnombre,CDactivo"/>
								<cfinvokeargument name="align" value=" left, left, left "/>
								<cfinvokeargument name="ajustar" value="N,N,N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="incluyeForm" value="false"/>
								<cfinvokeargument name="formName" value="form1"/>	
								<cfinvokeargument name="irA" value="DatosClientes.cfm"/>
								<cfinvokeargument name="keys" value="CDid"/>
								<cfinvokeargument name="botones" value="Nuevo"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="debug" value="N"/>
								<cfinvokeargument name="MaxRows" value="#form.MaxRows#"/>
								<cfinvokeargument name="mostrar_filtro" value="true"/>
								<cfinvokeargument name="filtrar_automatico"	value="true"/>
								<cfinvokeargument name="rsrotulo" value="#rsEstados#"/>
							  </cfinvoke>
						</form>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
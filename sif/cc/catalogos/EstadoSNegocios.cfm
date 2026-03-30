<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<script language="JavaScript1.2" type="text/javascript">
				function socios(){
					document.form1.action     = "SNcorporativo.cfm";
					document.form1.modo.value = "CAMBIO";
					document.form1.submit();
				}
			</script>
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
			<cfif isdefined('url.ESNid')  and not isdefined('form.ESNid')>
				<cfset form.ESNid = url.ESNid>
			</cfif>
			<cfif isdefined('url.filtro_ESNcodigo') and not isdefined('form.filtro_ESNcodigo')>
				<cfset form.filtro_ESNcodigo = url.filtro_ESNcodigo>
			</cfif>
			<cfif isdefined('url.filtro_ESNdescripcion') and not isdefined('form.filtro_ESNdescripcion')>
				<cfset form.filtro_ESNdescripcion = url.filtro_ESNdescripcion>
			</cfif>
			<cfif isdefined('url.filtro_Facturar') and not isdefined('form.filtro_Facturar')>
				<cfset form.filtro_Facturar = url.filtro_Facturar>
			</cfif>

			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="10">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top" width="60%">
						<cfquery name="rsFact" datasource="#session.DSN#">
							select -1 as value, 'Todos' as description from dual
							union
							select 0 as value, 'No Permite' as description from dual
							union
							select 1 as value, 'Permite' as description from dual
							order by 1
						</cfquery>
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="EstadoSNegocios"/>
								<cfinvokeargument name="columnas" value="ESNid, ESNcodigo, ESNdescripcion, ESNfacturacion,
																	 case when ESNfacturacion = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as Factura"/>
							<cfinvokeargument name="desplegar" value="ESNcodigo, ESNdescripcion,Factura"/>
							<cfinvokeargument name="etiquetas" value="Estado, Descripci&oacute;n,Facturar" />
							<cfinvokeargument name="formatos" value="S,S,S"/>
							<cfinvokeargument name="filtrar_por" value="ESNcodigo,ESNdescripcion,ESNfacturacion"/>
							<cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo# order by ESNcodigo"/>
							<cfinvokeargument name="align" value="left, left,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="showEmptyListMsg" value= "1"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="EstadoSNegocios.cfm"/>
							<cfinvokeargument name="keys" value="ESNid"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>
							<cfinvokeargument name="rsFactura" value="#rsFact#"/>
							</cfinvoke> 
					</td>
					<td valign="top" width="40%"><cfinclude template="EstadoSNegocios-form.cfm"></td> 
				</tr>
			</table>
		<cf_web_portlet_end>	
	<cf_templatefooter>

<cf_qforms form = 'filtro'>
<script language="javascript" type="text/javascript">
function limpiar(){
	document.filtro.fESNcodigo.value = ' ';
	document.filtro.fESNdescripcion.value = ' ';
}
</script>
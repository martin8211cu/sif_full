<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
	<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			
			<!---  VARIABLE LLAVE PARA CUANDO VIENE DEL SQL --->
			<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
				<cfset form.SNCEid = url.SNCEid>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<cfset form.Pagina = 1>

			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
				<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
				<cfset form.SNCEid = 0>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="15">
			<cfquery name="rsConsultaCorp" datasource="asp">
				select 1
				from CuentaEmpresarial
				where Ecorporativa is not null
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
			</cfquery>
			<cfif isdefined('session.Ecodigo') and 
				  isdefined('session.Ecodigocorp') and
				  session.Ecodigo NEQ session.Ecodigocorp and
				  rsConsultaCorp.RecordCount GT 0>
				  <cfset filtro = " and Ecodigo=#session.Ecodigo#">
			<cfelse>
				  <cfset filtro = " and Ecodigo is null">								  
			</cfif>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0;">
				<tr>
					<td width="50%" valign="top">
						<!--- LISTA DEL MANTENIMIENTO --->
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
							tabla="SNClasificacionE" 
							columnas="SNCEid, SNCEcodigo, SNCEdescripcion, 
								case when PCCEactivo = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as Activo,
								case when PCCEobligatorio = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as Obligatorio,
								case when SNCEcorporativo = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as Corporativo,
								case when SNCEalertar = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as Alerta,
								case when coalesce(SNCtiposocio, 'A') = 'A' then 'Ambos' when SNCtiposocio = 'C' then 'Cliente' when SNCtiposocio = 'P' then 'Proveedor'  end as tipo" 
							desplegar="SNCEcodigo, SNCEdescripcion, tipo, Corporativo, Obligatorio, Activo, Alerta"
							etiquetas="C&oacute;digo, Clasificaci&oacute;n, Tipo, Corporativo, Obligatorio, Activo, Alerta"
							formatos="S, S, S, S,S, S, S"
							filtro="CEcodigo=#session.CEcodigo# #filtro# order by SNCEcodigo"
							align="left, left, left,center, center, center, center"
							ira="SNClasificaciones.cfm"
							keys="SNCEid"
							maxrows="#maxrows#"
						/>
					</td>
					<td width="50%" valign="top">
						<!--- MANTENIMIENTO --->
						<cfinclude template="formSNClasificaciones.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>
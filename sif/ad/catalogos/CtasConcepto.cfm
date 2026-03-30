<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
				<cfset form.Pagina2 = url.Pagina2>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
				<cfset form.Pagina2 = url.PageNum_Lista2>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
				<cfset form.Pagina2 = form.PageNum2>
			</cfif>
			<cfif isdefined('url.Ccodigo') and not isdefined('form.Ccodigo')>
				<cfset form.Ccodigo = url.Ccodigo>
			</cfif>
			<cfif isdefined('url.Dcodigo') and not isdefined('form.Dcodigo')>
				<cfset form.Dcodigo = url.Dcodigo>
			</cfif>
			<cfif isdefined('url.Cid') and not isdefined('form.Cid')>
				<cfset form.Cid = url.Cid>
			</cfif>
			<cfset regresa='Conceptos.cfm?Ccodigo=#form.Ccodigo#&Cid=#form.Cid#'>
			<cfset navegacion ="">
			<cfif isdefined('url.filtro_Ccodigo') and not isdefined('form.filtro_Ccodigo')>
				<cfset form.filtro_Ccodigo = url.filtro_Ccodigo>
			</cfif>
			<cfif isdefined('url.filtro_Cdescripcion') and not isdefined('form.filtro_Cdescripcion')>
				<cfset form.filtro_Cdescripcion = url.filtro_Cdescripcion>
			</cfif>
			<cfif isdefined('url.hfiltro_Ccodigo') and not isdefined('form.hfiltro_Ccodigo')>
				<cfset form.hfiltro_Ccodigo = url.hfiltro_Ccodigo>
			</cfif>
			<cfif isdefined('url.hfiltro_Cdescripcion') and not isdefined('form.hfiltro_Cdescripcion')>
				<cfset form.hfiltro_Cdescripcion = url.hfiltro_Cdescripcion>
			</cfif>
			<cfif isdefined('url.fTipo') and not isdefined('form.fTipo')>
				<cfset form.fTipo = url.fTipo>
			</cfif>
			<cfif isdefined('url.Pagina') and not isdefined('form.Pagina')>
				<cfset form.Pagina = url.Pagina>
			</cfif>

			<cfif isdefined('form.filtro_Cdescripcion')>
				<cfset regresa = regresa&'&filtro_Cdescripcion=#form.filtro_Cdescripcion#'>
				<cfset navegacion = navegacion&'&filtro_Cdescripcion=#form.filtro_Cdescripcion#'>
			</cfif>
			<cfif isdefined('form.hfiltro_Cdescripcion')>
				<cfset regresa = regresa&'&hfiltro_Cdescripcion=#form.hfiltro_Cdescripcion#'>
				<cfset navegacion = navegacion&'&hfiltro_Cdescripcion=#form.hfiltro_Cdescripcion#'>
			</cfif>
			<cfif isdefined('form.fTipo')>
				<cfset regresa = regresa&'&fTipo=#form.fTipo#'>
				<cfset navegacion = navegacion&'&fTipo=#form.fTipo#'>
			</cfif>
			<cfif isdefined('form.Pagina')>
				<cfset regresa = regresa&'&Pagina=#form.Pagina#'>
				<cfset navegacion = navegacion&'&Pagina=#form.Pagina#'>
			</cfif>
			<cfif isdefined('form.Cid')>
				<cfset navegacion = navegacion&'&Cid=#form.Cid#'>
			</cfif>
			<cfif isdefined('form.Ccodigo')>
				<cfset navegacion = navegacion&'&Ccodigo=#form.Ccodigo#'>
			</cfif>
			<cfif isdefined('form.filtro_Ccodigo')>
				<cfset regresa = regresa&'&filtro_Ccodigo=#form.filtro_Ccodigo#'>
				<cfset navegacion = navegacion &'&filtro_Ccodigo=#form.filtro_Ccodigo#'>
			</cfif>
			<cfif isdefined('form.hfiltro_Ccodigo')>
				<cfset regresa = regresa&'&hfiltro_Ccodigo=#form.hfiltro_Ccodigo#'>
				<cfset navegacion = navegacion &'&hfiltro_Ccodigo=#form.hfiltro_Ccodigo#'>
			</cfif>
			<cfparam name="form.Pagina2" default="1">
			<cfparam name="form.MaxRows2" default="15">
			<table align="center" width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top" width="50%"> 
						<cfquery name="rsListaCuentas" datasource="#session.DSN#">
							select rtrim(ltrim(b.Ccodigo)) as Ccodigo, b.Dcodigo as Dcodigo, b.Ccuenta as Ccuenta,
								b.Cid, 
								c.Ddescripcion, 
								a.Cdescripcion,
								#form.Pagina# as Pagina,
								'#form.filtro_Ccodigo#' as filtro_Ccodigo,
								'#form.filtro_Cdescripcion#' as filtro_Cdescripcion,
								'#form.hfiltro_Ccodigo#' as hfiltro_Ccodigo,
								'#form.hfiltro_Cdescripcion#' as hfiltro_Cdescripcion,
								'#form.fTipo#' as fTipo
							from CuentasConceptos b, Departamentos c, CContables a
							where b.Ccodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Ccodigo)#">
								and b.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
								and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								and a.Ecodigo = b.Ecodigo 
								and a.Ccuenta = b.Ccuenta
								and a.Ecodigo = c.Ecodigo
								and b.Dcodigo = c.Dcodigo
							order by a.Ccuenta 
						</cfquery>
		
						<cfinvoke 
						 component="sif.Componentes.pListas" 
						 method="pListaQuery"
						 returnvariable="pListaCtasCon">
							<cfinvokeargument name="query" value="#rsListaCuentas#"/>
							<cfinvokeargument name="desplegar" value="Ddescripcion, Ccodigo ,  Cdescripcion "/>
							<cfinvokeargument name="etiquetas" value="Departamento, Código, Cuenta"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="CtasConcepto.cfm"/>
							<cfinvokeargument name="keys" value="Dcodigo,Cid,Ccodigo"/>
							<cfinvokeargument name="PageIndex" value="2"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows2#"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
						</cfinvoke> 
					</td>
					<td><cfinclude template="../catalogos/formCtasConcepto.cfm"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
        <cf_web_portlet_end>
<cf_templatefooter>
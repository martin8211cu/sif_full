
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>
<cfif isdefined("Url.RHOid") and not isdefined("Form.RHOid")>
	<cfparam name="Form.RHOid" default="#Url.RHOid#">
</cfif>


<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PruebasRealizadasAl"
	Default="Pruebas realizadas al"
	returnvariable="LB_PruebasRealizadasAl"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Oferente"
	Default="oferente"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Oferente"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Empleado"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	returnvariable="LB_Codigo"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"
	returnvariable="LB_Fecha"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Resultado"
	Default="Resultado"
	returnvariable="LB_Resultado"/>		
	

<table width="99%" align="center">
	<tr><td>
<cfset vstitulo =''>
<cfif isdefined("form.DEid")><!---and not isdefined("form.DEid")>---->
	<cfset vstitulo = LB_Empleado>
<cfelseif isdefined("form.RHOid")><!---- and not isdefined("form.RHOid")>---->
	<cfset vstitulo = LB_Oferente>
</cfif>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
	titulo='<cfoutput>#LB_PruebasRealizadasAl# #vstitulo#</cfoutput>'>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
			<cfset form.DEid = url.DEid>
		</cfif>
		<cfif isdefined("url.RHOid") and not isdefined("form.RHOid")>
			<cfset form.RHOid = url.RHOid>
		</cfif>
		<tr> 
			<td valign="top"> 
				<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
				<cfquery name="rsLista" datasource="#session.DSN#">
					select a.RHPcodigopr,#LvarRHPdescripcionpr# as RHPdescripcionpr,a.RHPfecha,a.RHPNota
						,6 as o, 1 as sel
					<cfif isdefined("form.DEid") and len(trim(form.DEid))>
						,'#form.DEid#' as DEid, '6' as tab	
					<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>	
						,'#form.RHOid#' as RHOid	
					</cfif>
					from RHPruebasOferente a
						inner join RHPruebas b
							on a.RHPcodigopr = b.RHPcodigopr
							and a.Ecodigo = b.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						<cfif isdefined("form.DEid") and len(trim(form.DEid))>
							and  a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">	
						<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
							and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">	
						</cfif>								
					order by a.RHPfecha desc
				</cfquery>
				

				<cfif isdefined("form.DEid") and len(trim(form.DEid))>						
					<cfset ira = "expediente.cfm">
				<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
					<cfset ira = "OferenteExterno.cfm">
				</cfif>	

				<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="RHPcodigopr,RHPdescripcionpr,RHPfecha,RHPNota"/>
					<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Fecha#,#LB_Resultado#"/>
					<cfinvokeargument name="formatos" value="V,V,D,M"/>
					<cfinvokeargument name="align" value="left,left,Center,Right"/>
					<cfinvokeargument name="ajustar" value="S,S,S,S"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="RHPcodigopr,RHOid"/>
					<cfinvokeargument name="irA" value="#ira#"/>
					<cfinvokeargument name="formName" value="formPRuebasLista"/>
				</cfinvoke>
			</td>
			<td width="40%">
				<cfinclude template="PruebasRealizadas-form.cfm">
			</td>
		</tr>
	</table>
<cf_web_portlet_end>
</td></tr>
</table>

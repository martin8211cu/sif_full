<!--- 
	Modificado por: E. Raúl Bravo Gómez
	Fecha: 21 de agosto del 2013
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Btn_Idioma 		= t.Translate('Btn_Idioma','Idioma')>
<cfset Lbl_CtaMay 		= t.Translate('Lbl_CtaMay','Cuentas de Mayor')>
<cfset Lbl_Idioma 		= t.Translate('Lbl_Idioma','Idioma')>
<cfset MSG_Descripcion 	= t.Translate('MSG_Descripcion','Descripcion','/sif/generales.xml')>
<cfset LB_Filtrar 		= t.Translate('LB_Filtrar','Filtrar','/sif/generales.xml')>
<cfset Lbl_Default 		= t.Translate('Lbl_Default','Default')>
<cfset Lbl_Ninguno 		= t.Translate('Lbl_Ninguno','Ninguno')>

<cfif isdefined("url.IdiomaF") and Len(Trim(url.IdiomaF))>
	<cfparam name="form.IdiomaF" default="#url.IdiomaF#">
</cfif>
<cfif isdefined("url.DescripcionF") and Len(Trim(url.DescripcionF))>
	<cfparam name="form.DescripcionF" default="#url.DescripcionF#">
</cfif>
<cfif isdefined("url.Cmayor") and not isdefined("form.Cmayor")>
	<cfparam name="form.Cmayor" default="#url.Cmayor#">
</cfif>


<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select coalesce(Iid,0) as Cve_Idioma
	from Empresa
	where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
</cfquery>
<cfset Empresa_Iid = #rsEmpresa.Cve_Idioma#>

<cfquery name="rsLista" datasource="#Session.DSN#">
select c.Cmayor, i.Iid, c.CdescripcionMI, i.Descripcion, cm.Cdescripcion,
    case i.Iid
    when #Empresa_Iid# 
    then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'  
    else  '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as Def
    from CtasMayorIdioma c
    inner join Idiomas i
    on c.Iid=i.Iid
    inner join CtasMayor cm
    on cm.Ecodigo = c.Ecodigo and cm.Cmayor = c.Cmayor
    where c.Cmayor=<cfqueryparam value="#form.Cmayor#" cfsqltype="cf_sql_char">
    and c.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
    <cfif isdefined("form.IdiomaF") and len(trim(form.IdiomaF))>
    	and c.Iid = <cfqueryparam value="#form.IdiomaF#" cfsqltype="cf_sql_numeric">
    </cfif>
    <cfif isdefined("form.DescripcionF") and len(trim(form.DescripcionF))>
    	and Upper(c.CdescripcionMI) like Upper('%#form.DescripcionF#%')
    </cfif>
</cfquery>

<!---<cfdump var="#form#">--->

<cf_navegacion name="IdiomaF" default="" session>
<cf_navegacion name="DescripcionF" default="" session>

<cfif isdefined("url.IdiomaF")>
	<cfset navegacion = "IdiomaF=" & url.IdiomaF>
</cfif>
<cfif isdefined('url.DescripcionF') and trim(url.DescripcionF) NEQ "">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "DescripcionF=" & #url.DescripcionF#>
</cfif>
<cfif isdefined('form.Cmayor') and trim(form.Cmayor) NEQ "">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "Cmayor=" & #Form.Cmayor#>
</cfif>
<cfif isdefined('form.Cdescripcion') and trim(form.Cdescripcion) NEQ "">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "Cdescripcion=" & #Form.Cdescripcion#>
</cfif>




<cf_templateheader title="SIF - Cuentas de Mayor"> 
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Lbl_CtaMay#'>	
		<table style="width:20%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td valign="top" style="width:20%">
					<cfinclude template="CtasMayorIFiltro.cfm">
					<cfinvoke 
                    component="sif.Componentes.pListas" 
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="Descripcion, CdescripcionMI, Def"/>
						<cfinvokeargument name="etiquetas" value="#Lbl_Idioma#, #MSG_Descripcion#, #Lbl_Default#"/>
						<cfinvokeargument name="formatos" value="S,S,S"/>
						<cfinvokeargument name="align" value="left, left, left"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="irA" value="CtasMayorIdioma.cfm"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="keys" value="Cmayor, Descripcion, CdescripcionMI"/>
						<cfinvokeargument name="formname" value="form1"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/> 
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="maxRows" value="25"/> 
					</cfinvoke>
				</td>
				<td valign="top" style="width:20%">
					<cfinclude template="formCuentasMayorI.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>
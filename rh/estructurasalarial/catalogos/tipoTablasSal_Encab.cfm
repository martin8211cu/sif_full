<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RegistroDeTabla" Default="Registro de Tabla" returnvariable="LB_RegistroDeTabla" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Vigencias" Default="Vigencias" returnvariable="LB_Vigencias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Incremento" Default="Incremento" returnvariable="LB_Incremento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AplicarTabla" Default="Aplicar Tabla" returnvariable="LB_AplicarTabla" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<link href="../../css/rh.css"rel="stylesheet" type="text/css">
<cfparam name="FORM.SEL" type="numeric">
<cfif isdefined("FORM.RHTTid") and len(trim(FORM.RHTTid)) eq 0><cfset FORM.RHTTid = "-1"></cfif>
<cfparam name="FORM.RHTTid" type="numeric" default="-1">
<cfquery name="rs_TablaSal_header" datasource="#session.DSN#">
	select *
	from RHTTablaSalarial
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHTTID#">
</cfquery>

<cfswitch expression="#FORM.SEL#">
	<cfcase value="1"><cfset SECTION.TITLE = LB_RegistroDeTabla></cfcase>
	<cfcase value="2"><cfset SECTION.TITLE = LB_Vigencias></cfcase>
	<cfcase value="3"><cfset SECTION.TITLE = LB_Incremento></cfcase>
	<cfcase value="4"><cfset SECTION.TITLE = LB_AplicarTabla></cfcase>
</cfswitch>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="2" width="1%"><img src="/cfmx/rh/imagenes/number#FORM.SEL#_32.gif"></td>
	<td class="subtitulo_seccion">#SECTION.TITLE#</td>
  </tr>
  <cfif rs_TablaSal_header.RecordCount gt 0>
  <tr>
    <td class="subtitulo_seccion_small" align="center">#rs_TablaSal_header.RHTTdescripcion#&nbsp;</td>
  </tr>
  </cfif>
</table>
</cfoutput>

<cfparam name="url.fRol" default=""><cfset url.fRol = Trim(url.fRol)>
<cfparam name="url.fUid" default=""><cfset url.fUid = Trim(url.fUid)>
<cfparam name="url.fNom" default=""><cfset url.fNom = Trim(url.fNom)>
<cfparam name="url.fEmp" default=""><cfset url.fEmp = Trim(url.fEmp)>
<cf_templateheader title="Definici&oacute;n de roles internos">
<cf_web_portlet_start titulo="Definici&oacute;n de grupos internos">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfinclude template="roles-lista.cfm">

<cf_boton texto="Agregar usuarios a este grupo &gt;&gt;" link="roles-nuevo.cfm" size="320">

<cf_web_portlet_end>
<cf_templatefooter>

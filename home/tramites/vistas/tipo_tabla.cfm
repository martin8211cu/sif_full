<cfparam name="Attributes.name" type="string">
<cfparam name="Attributes.value" type="string">
<cfparam name="Attributes.nombre_tabla" type="string">
<cfparam name="Attributes.id_tipo" type="string">
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfset Gvar_Name = Attributes.name>
<cfset Gvar_Value = Attributes.value>
<cfset Gvar_id_tipo = Attributes.id_tipo>
<cfinclude template="tablas/T#Attributes.nombre_tabla#.cfm">
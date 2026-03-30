<cfparam name="url.tabnumber" type="numeric" default="1">
<cfparam name="url.id_producto" default="">
<cfif REFind('^[0-9]+$',url.id_producto) Is 0><cfset url.id_producto=""></cfif>
<cfquery name="rsProducto" datasource="#Session.DSN#">
	select *
	from Producto p
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and p.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_producto#" null="#Len(url.id_producto) Is 0#">
	order by upper(p.nombre_producto) asc
</cfquery>
<cfif rsProducto.RecordCount Is 0>
	<cfset url.id_producto = "">
</cfif>
<!--- estos cfquery los requieren todas las pantallas producto_t*.cfm --->
<cfquery datasource="#session.dsn#" name="moneda">
	select Miso4217 as moneda
	from Monedas m, Empresas e
	where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and m.Ecodigo = e.Ecodigo
	  and m.Mcodigo = e.Mcodigo
</cfquery>

<cfif len(url.id_producto)>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>
<cf_template>
<cf_templatearea name="title"> Productos</cf_templatearea>
<cf_templatearea name="left"> </cf_templatearea>
<cf_templatearea name="header"> </cf_templatearea>
<cf_templatearea name="body">

<link rel="stylesheet" type="text/css" href="../../../css/sif.css">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfparam name="url.tabnumber" default="1">
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Productos">      
		<script type="text/javascript" language="javascript1.2" src="../../../js/utilesMonto.js"></script>
		<center>
			<form action="producto_go.cfm" method="post" name="form1" id="form1" onSubmit="return validar();" onReset="" enctype="multipart/form-data">
		    <cfinclude template="producto_top.cfm">
				<cfoutput>
				<input type="hidden" name="tabnumber" value="#HTMLEditFormat(url.tabnumber)#">
				</cfoutput>
				<cfinclude template="producto_tab.cfm">
				<cfinclude template="producto_tab#tabnumber#.cfm">
			</form>
		</center>
		</cf_web_portlet>

</cf_templatearea>
</cf_template>
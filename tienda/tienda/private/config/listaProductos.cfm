<cf_template>
<cf_templatearea name="title"> Buscar Producto</cf_templatearea>
<cf_templatearea name="left"> </cf_templatearea>
<cf_templatearea name="header"> </cf_templatearea>
<cf_templatearea name="body">

<link rel="stylesheet" type="text/css" href="../../../css/sif.css">
<cfinclude template="/home/menu/pNavegacion.cfm">

		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Buscar Producto">      


		<cfinclude template="formListaProductos.cfm">
		</cf_web_portlet>


</cf_templatearea>
</cf_template>
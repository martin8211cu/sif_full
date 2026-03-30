
<cf_template>
<cf_templatearea name="title"> Categor&iacute;as </cf_templatearea>
<cf_templatearea name="left"> </cf_templatearea>
<cf_templatearea name="header"> </cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">


		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Categor&iacute;as">

		    <cfinclude template="categoria_p.cfm">
		</cf_web_portlet>

</cf_templatearea>
</cf_template>

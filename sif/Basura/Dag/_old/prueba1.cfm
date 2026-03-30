<cfinclude template="../../Application.cfm">
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Activos Fijos
	</cf_templatearea>
	<cf_templatearea name="body">
	<cfdump var="#form#">
  <form action="" method="post" name="form1">
		<cf_monto decimales="2" size="3">
		<cf_botones>
	</form>
	</cf_templatearea>
</cf_template>

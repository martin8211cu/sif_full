<cfparam name="form.back_MEDdescripcion" default="">
<cfparam name="form.back_MEDimporte" default="">
<cfparam name="form.back_MEDmoneda" default="">
<cfparam name="form.back_MEDproyecto" default="">

<cfquery datasource="#session.dsn#">
delete MEDTarjetas
where MEDtcid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
  and MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">
</cfquery>
<cfoutput><html><body onLoad="document.form1.submit()">
<form action="donacion_registro.cfm" name="form1" id="form1" method="post">
<!---<input type="hidden" name="tarjeta" value="#form.id#">--->
<input type="hidden" name="MEDdescripcion" value="#form.back_MEDdescripcion#">
<input type="hidden" name="MEDimporte"     value="#form.back_MEDimporte#">
<input type="hidden" name="MEDmoneda"      value="#form.back_MEDmoneda#">
<input type="hidden" name="MEDproyecto"    value="#form.back_MEDproyecto#">
</form>
<script type="text/javascript">
<!--
document.form1.submit();
-->
</script>
</body></html>
</cfoutput>
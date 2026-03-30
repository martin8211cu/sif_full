<cfparam name="form.back_MEDdescripcion" default="">
<cfparam name="form.back_MEDimporte" default="">
<cfparam name="form.back_MEDmoneda" default="">
<cfparam name="form.back_MEDproyecto" default="">

<cfset MEDtcvence = form.mm & "/" & Right(form.yy,2)>

<cfquery datasource="#session.dsn#">
	update MEDTarjetas
	set MEDtctipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtctipo#">,
		<cfif REFind('[*|x|X]', form.MEDtcnumero) eq 0 >MEDtcnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcnumero#">,</cfif>
		MEDtcvence = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MEDtcvence#">,
		MEDtcnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcnombre#">,
		MEDtcdigito = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdigito#">,
		MEDtcdireccion1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdireccion1#">,
		MEDtcdireccion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdireccion2#">,
		MEDtcciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcciudad#">,
		MEDtcestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcestado#">,
		MEDtcpais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcpais#">,
		MEDtczip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtczip#">,
		BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
		BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
		BMfechamod = getdate()
	where MEDtcid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
	  and MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">
</cfquery>

<cfoutput><html><body onLoad="document.form1.submit()">
<form action="donacion_registro.cfm" name="form1" id="form1" method="post">
<input type="hidden" name="tarjeta" value="#form.id#">
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
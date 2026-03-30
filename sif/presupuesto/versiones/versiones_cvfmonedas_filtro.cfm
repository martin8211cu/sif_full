<cfif pantalla EQ 5>
<cfset form.Focodigo = form.ocodigo>
</cfif>
<cfquery name="qry_oficinas" datasource="#session.dsn#">
	select Ocodigo, Odescripcion from Oficinas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="qry_cv" datasource="#Session.dsn#">
	select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, ts_rversion
	from CVersion
	where Ecodigo = #session.ecodigo#
	and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
</cfquery>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="qry_cpm" datasource="#session.dsn#">
	select a.CPCano, a.CPCmes,
			<cf_dbfunction name="to_char" datasource="sifControl" args="a.CPCano"> #_Cat# ' - ' #_Cat#
			case a.CPCmes
				when 1 then 'Enero'
				when 2 then 'Febrero'
				when 3 then 'Marzo'
				when 4 then 'Abril'
				when 5 then 'Mayo'
				when 6 then 'Junio'
				when 7 then 'Julio'
				when 8 then 'Agosto'
				when 9 then 'Septiembre'
				when 10 then 'Octubre'
				when 11 then 'Noviembre'
				when 12 then 'Diciembre'
			end as descripcion
	from CPmeses a
	where a.Ecodigo = #session.ecodigo#
	and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_cv.cppid#">
	and a.CPCano*100+a.CPCmes >= #LvarAuxAnoMes#
	order by a.CPCano, a.CPCmes
</cfquery>

<cfif not isdefined("form.CPPid")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CPPid
		  from CVersion v
		where v.Ecodigo 	= #session.ecodigo#
		  and v.CVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
	</cfquery>
	<cfset form.CPPid = rsSQL.CPPid>
</cfif>
<cfif isdefined("form.btnMonedas")>
	<cfparam name="form.Mcodigo" default="#LvarMcodigoEmpresa#">
	<!--- Obtiene la Moneda de Solicitud --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select m.Mcodigo, m.Mnombre
		from Monedas m
		where m.Ecodigo = #session.ecodigo#
		  and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>
	<cfif find(",",rsSQL.Mnombre) GT 0>
		<cfset LvarMnombreSolicitud = trim(mid(rsSQL.Mnombre,find(",",rsSQL.Mnombre)+1,100))>
	<cfelse>	
		<cfset LvarMnombreSolicitud = rsSQL.Mnombre>
	</cfif>
</cfif>
<cfparam name="form.ocodigo" default="#qry_oficinas.ocodigo#">
<form action="/cfmx/sif/presupuesto/versiones/versionesComun.cfm" method="post" name="formFiltro">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
	<cfinclude template="versiones_header.cfm">
	<cfinclude template="versiones_header2.cfm">
</table>
</form>
<script language="javascript" type="text/javascript">
<!--//
	function setanomes(o){
		var form = o.form;
		var ano = form.CPCano;
		var mes = form.CPCmes;
		var anomes = o.value;
		var arranomes = anomes.split('|');
		ano.value = arranomes[0];
		mes.value = arranomes[1];
	}
//-->
</script>
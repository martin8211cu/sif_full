<cfinclude template="SociosModalidad.cfm">
<cfif not modalidad.importar>
	<cf_errorCode	code = "50014" msg = "La configuración actual no le permite importar socios de negocio corporativos">
</cfif>

<cftransaction>

<cfquery datasource="#session.dsn#" name="cat">
	select CSNid from CategoriaSNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CSNcodigo = '1'
</cfquery>
<cfif cat.RecordCount EQ 0>
	<cfquery datasource="#session.dsn#" name="cat">
		insert into CategoriaSNegocios 
		(Ecodigo, CSNcodigo, CSNdescripcion, CSNidPadre, CSNpath, BMUsucodigo)
		values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
		'1', 'General', null, '00001', <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="cat">
	<cfset CSNid = cat.identity>
<cfelse>
	<cfset CSNid = cat.CSNid>
</cfif>

<cfquery datasource="#session.dsn#" name="est">
	select ESNid from EstadoSNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and ESNcodigo = '1'
</cfquery>

<cfif est.RecordCount EQ 0>
	<cfquery datasource="#session.dsn#" name="est">
		insert into EstadoSNegocios 
		(Ecodigo, ESNcodigo, ESNdescripcion, ESNfacturacion, BMUsucodigo)
		values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		'1', 'General', 1, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="est">
	<cfset ESNid = est.identity>
<cfelse>
	<cfset ESNid = est.ESNid>
</cfif>

<cfquery name="Mcodigo" datasource="#session.dsn#">
	select Mcodigo
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="SNcodigo" datasource="#session.dsn#">
	select coalesce(max(SNcodigo),0)+1 as SNcodigo
	from SNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and SNcodigo <> 9999
</cfquery>

<cfquery datasource="#session.dsn#" name="selectNuevo">
	select
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo.SNcodigo#"> as SNcodigo,
			SNidentificacion,
		SNtipo, SNnombre, SNdireccion, Ppais, 
		SNtelefono, SNFax, SNemail, LOCidioma, 
		SNcertificado, SNactivoportal, SNcodigoext, SNFecha, 
		SNtiposocio, SNvencompras, SNvenventas, SNinactivo, 
		EUcodigo, SNnumero, null as SNcuentacxc, null as SNcuentacxp,
		SNplazoentrega, SNplazocredito, 
		cuentac, <cfqueryparam cfsqltype="cf_sql_numeric" value="#CSNid#"> as CSNid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#ESNid#"> as ESNid, 
		DEidEjecutivo, DEidVendedor, DEidCobrador,  
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo.Mcodigo#"> as Mcodigo, SNmontoLimiteCC, SNdiasVencimientoCC, SNdiasMoraCC, 
		SNdocAsociadoCC, 1 as SNesCorporativo, SNid, null as SNidPadre, 
		id_direccion, EcodigoInclusion, SNinclusionAutoriz, SNidEquivalente 
	from SNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>

<cfquery datasource="#session.dsn#" name="nuevo">
	insert into SNegocios (
		Ecodigo, SNcodigo, SNidentificacion,
		SNtipo, SNnombre, SNdireccion, Ppais, 
		SNtelefono, SNFax, SNemail, LOCidioma, 
		SNcertificado, SNactivoportal, SNcodigoext, SNFecha, 
		SNtiposocio, SNvencompras, SNvenventas, SNinactivo, 
		EUcodigo, SNnumero, SNcuentacxc, SNcuentacxp, 
		SNplazoentrega, SNplazocredito, 
		cuentac, CSNid, ESNid, 
		DEidEjecutivo, DEidVendedor, DEidCobrador,  
		Mcodigo, SNmontoLimiteCC, SNdiasVencimientoCC, SNdiasMoraCC, 
		SNdocAsociadoCC, SNesCorporativo, SNidCorporativo, SNidPadre, 
		id_direccion, EcodigoInclusion, SNinclusionAutoriz, SNidEquivalente, 
		BMUsucodigo 
		)
		VALUES(
       #session.Ecodigo#,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNcodigo#"            voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectNuevo.SNidentificacion#"    voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectNuevo.SNtipo#"              voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectNuevo.SNnombre#"            voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectNuevo.SNdireccion#"         voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectNuevo.Ppais#"               voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectNuevo.SNtelefono#"          voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectNuevo.SNFax#"               voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectNuevo.SNemail#"             voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#selectNuevo.LOCidioma#"           voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNcertificado#"       voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNactivoportal#"      voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  value="#selectNuevo.SNcodigoext#"         voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectNuevo.SNFecha#"             voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectNuevo.SNtiposocio#"         voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNvencompras#"        voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNvenventas#"         voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNinactivo#"          voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.EUcodigo#"            voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#selectNuevo.SNnumero#"            voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.SNcuentacxc#"         voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.SNcuentacxp#"         voidNull>,
	   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNplazoentrega#"      voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNplazocredito#"      voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectNuevo.cuentac#"             voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.CSNid#"               voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.ESNid#"               voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.DEidEjecutivo#"       voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.DEidVendedor#"        voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.DEidCobrador#"        voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.Mcodigo#"             voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectNuevo.SNmontoLimiteCC#"     voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNdiasVencimientoCC#" voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.SNdiasMoraCC#"        voidNull>,
       <cfqueryparam       cfsqltype="cf_sql_blob"              value="#selectNuevo.SNdocAsociadoCC#"     null="#trim(form.SNdocAsociadoCC) EQ ""#">,
       <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectNuevo.SNesCorporativo#"     voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.SNidCorporativo#"     voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.SNidPadre#"           voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.id_direccion#"        voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNuevo.EcodigoInclusion#"    voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectNuevo.SNinclusionAutoriz#"  voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectNuevo.SNidEquivalente#"     voidNull>,
       #session.Usucodigo#
)
		
	
	<cf_dbidentity1>
</cfquery>
<cf_dbidentity2 name="nuevo">

<cfquery datasource="#session.dsn#">
	insert into SNClasificacionSN (SNid, SNCDid, BMUsucodigo)
	select <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo.identity#">,
		c.SNCDid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	from SNegocios s
		join SNClasificacionSN c
			on c.SNid = s.SNid
		join SNClasificacionD d
			on d.SNCDid = c.SNCDid
		join SNClasificacionE e
			on e.SNCEid = d.SNCEid
			and e.Ecodigo is null
	where s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">
	  and s.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>


<cfquery datasource="#session.dsn#">
	insert into SNDirecciones (
				SNid, id_direccion, Ecodigo, SNcodigo,
				SNDfacturacion, SNDenvio, SNDactivo,
				SNDlimiteFactura, DEid, BMUsucodigo)
	select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo.identity#">, id_direccion,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo.SNcodigo#">,
				SNDfacturacion, SNDenvio, SNDactivo,
				0, null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	from SNDirecciones s
	where s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">
	  and s.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>

</cftransaction>

<cflocation url="Socios.cfm?SNcodigo=#URLEncodedFormat(SNcodigo.SNcodigo)#">




<cfif form.parentEntrancePoint eq 'Convenios.cfm'>
	<cfset returnTo="Convenios_form.cfm?a=1&b=0">
<cfelse>
	<cfset returnTo="Convenios_form.cfm?b=1&a=0">
</cfif>
<cfset modo="">

<cfif isdefined('form.ALTA')>

	<cfquery name="q_conveniosPrevios" datasource="#session.dsn#">
		select cv.id, sn.SNnombre from CRCConvenios cv 
			inner join CRCCuentas cc 
				on cc.id = cv.CRCCuentasid
			inner join SNegocios sn
				on sn.SNid = cc.SNegociosSNid
		where 
			CRCCuentasid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CuentaID#">
			and Estado = 'P';
	</cfquery>

	<cfif q_conveniosPrevios.recordCount eq 0>

		<cfset condonacionID = "">
		<cfset fechaIni = listToArray(form.fechaInicio,"/",false,false)>
		<cfset fechaIni = "#fechaIni[3]#-#fechaIni[2]#-#fechaIni[1]#">

		<cfquery name="q_insert" datasource="#session.DSN#">
			insert into crcconvenios (CodigoConvenio,CRCCuentasid,CRCTipoTransaccionid,CRCTipoTransaccionid2,
				CRCCondonacionesid,MontoConvenio,MontoGastoCobranza,esPorcentaje,DescripConvenio,Observaciones,Parcialidades,
				Ecodigo,Usucrea,createdat,fechaInicio,Estado) values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodigoC#">
					,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CuentaID#">
					,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoTransaccionID#">
					,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoTransaccionID2#">
					,	null
					,	<cfqueryparam cfsqltype="cf_sql_money" value="#NumberFormat(Replace(form.MONTOCONVENIR,',','','all'),'0.00')#">
					,	<cfqueryparam cfsqltype="cf_sql_money" value="#NumberFormat(Replace(form.GASTOCONVENIO,',','','all'),'0.00')#">
					,	<cfif isdefined('form.Porciento')><cfif form.Porciento eq "on">1<cfelse>0</cfif><cfelse>0</cfif>
					,	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DescripcionC#">
					,	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ObservacionC#">
					,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Parcialidades#">
					,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					,	<cfqueryparam cfsqltype="cf_sql_date" value="#Replace(Replace(Now(),"{ts '",'','all'),"'}",'','all')#">
					,	<cfqueryparam cfsqltype="cf_sql_date" value="#fechaIni#">
					,	<cfqueryparam cfsqltype="cf_sql_char" value="P">
				);
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery> 
		<cf_dbidentity2 datasource="#session.DSN#" name="q_insert">	
		<cfset form.id = q_insert.identity>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfthrow message="El Socio (#q_conveniosPrevios.SNnombre#) tiene convenios pendientes de aplicar">
	</cfif>
</cfif>

<cfif isdefined('form.CAMBIO') || isdefined('form.APLICAR')>
	<cfset fechaIni = listToArray(form.fechaInicio,"/",false,false)>
	<cfset fechaIni = "#fechaIni[3]#-#fechaIni[2]#-#fechaIni[1]#">
	<cfquery name="q_insert" datasource="#session.DSN#">
		update crcconvenios set
				CodigoConvenio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodigoC#">
			,	CRCCuentasid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CuentaID#">
			,	CRCTipoTransaccionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoTransaccionID#">
			,	CRCTipoTransaccionid2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoTransaccionID2#">
			, 	CRCCondonacionesid = null
			,	MontoConvenio = <cfqueryparam cfsqltype="cf_sql_money" value="#NumberFormat(Replace(form.MONTOCONVENIR,',','','all'),'0.00')#">
			,	MontoGastoCobranza = <cfqueryparam cfsqltype="cf_sql_money" value="#NumberFormat(Replace(form.GASTOCONVENIO,',','','all'),'0.00')#">
			,	esPorcentaje = <cfif isdefined('form.Porciento')><cfif form.Porciento eq "on">1<cfelse>0</cfif><cfelse>0</cfif>
			,	DescripConvenio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DescripcionC#">
			,	Observaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ObservacionC#">
			,	Parcialidades = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Parcialidades#">
			,	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			,	Usumodif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			,	updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#Replace(Replace(Now(),"{ts '",'','all'),"'}",'','all')#">
			,	fechaInicio = <cfqueryparam cfsqltype="cf_sql_date" value="#fechaIni#">
			where id = #form.id#
	</cfquery> 

	<cfset form.id = form.id>
	<cfset modo="CAMBIO">
</cfif>

<cfif isdefined('form.BAJA')>
	<cfquery name="q_DELETE" datasource="#session.DSN#">
		delete from CRCConvenios where id = #form.ID#
	</cfquery>
	<cfset returnTo="#form.parentEntrancePoint#">

</cfif>

<cfif isdefined('form.REGRESAR') or isdefined('form.BTNREGRESAR') >
	<cfset returnTo="#form.parentEntrancePoint#">
</cfif>

<cfif isdefined('form.APLICAR')>
	
	<cfinvoke  component ="crc.Componentes.convenio.CRCConvenio" method="AplicarConvenio">
		<cfinvokeargument name="ID_Convenio" value="#form.id#" >
	</cfinvoke>

	<cfquery name="q_update" datasource="#session.DSN#">
		update CRCConvenios set 
				convenioAplicado = 1
			,	FechaAplicacion = CURRENT_TIMESTAMP
			,	updatedat = CURRENT_TIMESTAMP
			,	Usumodif = #session.usucodigo#
			,	Estado = 'A'
			where id = #form.id#
	</cfquery>
</cfif>


<!---VALIDADOR--->

<cfoutput>
	<form action="#returnTo#" method="post" name="sql">
		<cfif isdefined("Form.Nuevo")>
			<input name="Nuevo" type="hidden" value="Nuevo">
		</cfif>
		<cfif isdefined("Form.Regresar")>
			<input name="Regresar" type="hidden" value="Regresar">
		</cfif>
		
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">

		<cfif modo neq 'ALTA' and modo neq ''>
			<input name="id" type="hidden" value="<cfif isdefined("Form.id")>#Form.id#</cfif>">
		</cfif>
	</form>

	<HTML>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
		<body>
			<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
		</body>
	</HTML>

</cfoutput>
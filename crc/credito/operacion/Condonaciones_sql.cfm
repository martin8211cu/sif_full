
<cfset returnTo="Condonaciones_form.cfm">
<cfset modo="">


<cfif isdefined('form.filtrar')>

	<cfset form.id = form.id>
	<cfset form.filtro_cliente = form.filtro_cliente>
	<cfset form.filtro_fecha = form.filtro_fecha>
	<cfset form.filtro_monto = form.filtro_monto>
	<cfset form.filtro_observ = form.filtro_observ>
	<cfset form.filtro_parcial= form.filtro_parcial>
	<cfset form.chk_id= form.chk_id>
	<cfset modo="CAMBIO">

<cfelse>

	<cfif isdefined('form.ALTA')>

		<cfquery name="TipoTransaccion" datasource="#session.DSN#">
			select Codigo, TipoMov,
				isnull(afectaSaldo,0) afectaSaldo, 
				isnull(afectaInteres,0) afectaInteres, 
				isnull(afectaCompras,0) afectaCompras, 
				isnull(afectaPagos,0) afectaPagos, 
				isnull(afectaCondonaciones,0) afectaCondonaciones, 
				isnull(afectaGastoCobranza,0) afectaGastoCobranza 
			from CRCTipoTransaccion where id = #form.TipoTransaccionID#
		</cfquery>
		<cfquery name="q_insert" datasource="#session.DSN#">
			insert into CRCCondonaciones 
				(CodigoCondonacion,CRCCuentasid,CRCTipoTransaccionid,DescripCondonacion,Observaciones,
				CondonacionAplicada,esFutura,Ecodigo,UsuCrea,createdat,
				TipoMov,afectaSaldo,afectaInteres,afectaCompras,afectaPagos,afectaCondonaciones,afectaGastoCobranza,CodigoTipoTransaccion 
				,Estado
				)
			values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodigoC#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CuentaID#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoTransaccionID#">
				,	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DescripcionC#">
				,	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ObservacionC#">
				,	<cfqueryparam cfsqltype="cf_sql_char" value="0">
				,	<cfif isdefined('form.esFuturo')> 1 <cfelse> 0 </cfif>
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				,	<cfqueryparam cfsqltype="cf_sql_date" value="#Replace(Replace(Now(),"{ts '",'','all'),"'}",'','all')#">
				,	<cfqueryparam cfsqltype="cf_sql_varchar" value="#TipoTransaccion.TipoMov#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaSaldo#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaInteres#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaCompras#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaPagos#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaCondonaciones#">
				,	<cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaGastoCobranza#">
				,	<cfqueryparam cfsqltype="cf_sql_varchar" value="#TipoTransaccion.Codigo#">
				,	<cfqueryparam cfsqltype="cf_sql_varchar" value="P">
				 
				);
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="q_insert">	
		<cfset form.id = q_insert.identity>
		<cfset modo="CAMBIO">
	</cfif>

	<cfif isdefined('form.CAMBIO') or isdefined('form.APLICAR')>
		<cfquery name="TipoTransaccion" datasource="#session.DSN#">
			select 
				Codigo, TipoMov,
				isnull(afectaSaldo,0) afectaSaldo, 
				isnull(afectaInteres,0) afectaInteres, 
				isnull(afectaCompras,0) afectaCompras, 
				isnull(afectaPagos,0) afectaPagos, 
				isnull(afectaCondonaciones,0) afectaCondonaciones, 
				isnull(afectaGastoCobranza,0) afectaGastoCobranza 
			from CRCTipoTransaccion where id = #form.TipoTransaccionID#
		</cfquery>
		
		<cfset query = "">
		<cfset monto = 0>
		
		<cfif isdefined('form.chk_id')>
			<cfset idTransac=ListToArray(form.chk_id,",",false,false)>
			<cfloop array="#idTransac#" index="idx">
				<cfset query = "#query# insert into CRCCondonacionDetalle (CRCCondonacionesid,CRCTransaccionid,Ecodigo,UsuCrea,createdat) values (#form.id#,#idx#,#session.ecodigo#,#session.usucodigo#,CURRENT_TIMESTAMP)">
			</cfloop>
		<cfelse>
			<cfloop list="#form.FIELDNAMES#" index="key">
				<cfif FIND('CHECK_',key) eq 1 or FIND('MONTO_',key) eq 1>
					<cfif form[key] neq "">
						<cfset MC_id = ListToArray(key,'_',false,false)[2]>
						<cfset monto += form[key]>
						<cfset query = "#query# insert into CRCCondonacionDetalle (CRCCondonacionesid,CRCMovimientoCuentaid,Monto,Ecodigo,UsuCrea,createdat) values (#form.id#,#MC_id#,#form[key]#,#session.ecodigo#,#session.usucodigo#,CURRENT_TIMESTAMP)">
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfquery name="q_update1" datasource="#session.DSN#">
			update CRCCondonaciones set
					CodigoCondonacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodigoC#">
				,	CRCCuentasid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CuentaID#">
				,	DescripCondonacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DescripcionC#">
				,	Observaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ObservacionC#">
				,	UsuModif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				,	updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#Replace(Replace(Now(),"{ts '",'','all'),"'}",'','all')#">
				,	TipoMov = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TipoTransaccion.TipoMov#">
				,	afectaSaldo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaSaldo#">
				,	afectaInteres = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaInteres#">
				,	afectaCompras = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaCompras#">
				,	afectaPagos = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaPagos#">
				,	afectaCondonaciones = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaCondonaciones#">
				,	afectaGastoCobranza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoTransaccion.afectaGastoCobranza#">
				,	CodigoTipoTransaccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TipoTransaccion.Codigo#">
				,	MontoCondonacion = <cfqueryparam cfsqltype="cf_sql_money" value="#monto#">
				where id = #form.id# and ecodigo = #session.ecodigo#;
		</cfquery>
		

		<cfquery name="q_update2" datasource="#session.DSN#">
			delete from CRCCondonacionDetalle where CRCCondonacionesid = #form.id#;
			#query#
		</cfquery>
		
		<cfset form.id = form.id>
		<cfset modo="CAMBIO">
	</cfif>

	<cfif isdefined('form.BAJA')>
		<cfquery name="q_update2" datasource="#session.DSN#">
			delete from CRCCondonacionDetalle where CRCCondonacionesid = #form.id#;
		</cfquery>
		<cfquery name="q_DELETE" datasource="#session.DSN#">
			delete from CRCCondonaciones where id = #form.ID#
		</cfquery>
		<cfset returnTo="Condonaciones.cfm">

	</cfif>

	<cfif isdefined('form.REGRESAR') or isdefined('form.BTNREGRESAR') >
		<cfset returnTo="Condonaciones.cfm">
	</cfif>

	<cfif isdefined('form.APLICAR')>
		<cftransaction>
			
			<cfinvoke  component ="crc.Componentes.condonaciones.CRCCondonacion" method="AplicarCondonacion">
				<cfinvokeargument name="ID_Condonacion" value=#form.id# >
				<cfinvokeargument name="esFuturo" 		value=#isdefined('form.chk_id')# >
				<cfinvokeargument name="DSN" 			value="#session.DSN#" >
				<cfinvokeargument name="Ecodigo" 		value=#session.ecodigo# >
			</cfinvoke>
			
		</cftransaction>
		<cfset form.id = form.id>
		<cfset modo="CAMBIO">
	</cfif>

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
			<cfif isdefined('form.filtrar')>
				<input name="filtro_cliente" type="hidden" value="<cfif isdefined("form.filtro_cliente")>#form.filtro_cliente#</cfif>">
				<input name="filtro_fecha" type="hidden" value="<cfif isdefined("form.filtro_fecha")>#form.filtro_fecha#</cfif>">
				<input name="filtro_monto" type="hidden" value="<cfif isdefined("form.filtro_monto")>#form.filtro_monto#</cfif>">
				<input name="filtro_observ" type="hidden" value="<cfif isdefined("form.filtro_observfiltro_observ")>#form.filtro_observ#</cfif>">
				<input name="filtro_parcial" type="hidden" value="<cfif isdefined("form.filtro_parcial")>#form.filtro_parcial#</cfif>">
				<input name="chk_id" type="hidden" value="<cfif isdefined("form.chk_id")>#form.chk_id#</cfif>">
			</cfif>
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
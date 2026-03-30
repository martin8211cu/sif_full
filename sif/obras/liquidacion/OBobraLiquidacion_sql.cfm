<cfset LvarAdmObr = isdefined("LvarAdmObr")>
<cf_navegacion name="OBOid" default="-1" navegacion="">

<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="OBobraLiquidacion"
			redirect="metadata.code.cfm"
			timestamp="#form.ts_rversion#"

			field1="OBOid"
			type1="numeric"
			value1="#form.OBOid#"

			field2="OBOLid"
			type2="numeric"
			value2="#form.OBOLid#"
	>
	<cfset sbVerificaCFformatoLiq()>
	<cftransaction>
		<cfset sbActualizaGATransacciones("CAMBIO")>
		<cfquery datasource="#session.dsn#">
			update OBobraLiquidacion
			   set CFidActivo			= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.CFid#">
				 , CFcuentaActivo		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">
				 , CFformatoLiquidacion	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CFformatoLiquidacion#" null="#form.CFformatoLiquidacion EQ ''#" len="100">
				 , OBOLporcentaje 		= <cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#form.OBOLporcentaje/100#">
				 , OBOLmonto	 		= <cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#replace(form.OBOLmonto,",","","ALL")#">
				 , OBOLactivo	 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.GATdescripcion#" len="40">
			 where OBOid 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.OBOid#">
			   and OBOLid 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.OBOLid#">
		</cfquery>
		<cfset sbActualizaDefault(form.OBOLid)>
	</cftransaction>
	
	<cflocation url="OBobra.cfm?OP=L&OBOid=#form.OBOid#&OBOLid=#form.OBOLid#">

<cfelseif IsDefined("form.Baja")>
	<cftransaction>
		<cfset LvarGATid = sbActualizaGATransacciones("BAJA")>
		<cfquery datasource="#session.dsn#">
			delete from OBobraLiquidacion
			 where OBOid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
			   and OBOLid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOLid#">
		</cfquery>
		<cfset sbActualizaDefault(form.OBOLid)>
	</cftransaction>

	<cflocation url="OBobra.cfm?OP=L&OBOid=#form.OBOid#">
<cfelseif IsDefined("form.Alta")>
	<cfset sbVerificaCFformatoLiq()>
	<cftransaction>
		<cfset LvarGATid = sbActualizaGATransacciones("ALTA")>

		<cfquery name="rsLiquidacion" datasource="#session.dsn#">
			insert into OBobraLiquidacion (
				OBOid,
				CFidActivo,
				Ecodigo, CFformatoLiquidacion,
				CFcuentaActivo,
				OBOLporcentaje,
				OBOLmonto,
				OBOLactivo,
				GATid,
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CFid#">,
				#session.Ecodigo#, <cfqueryparam cfsqltype="cf_varchar" value="#form.CFformatoLiquidacion#" null="#form.CFformatoLiquidacion EQ ''#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#form.OBOLporcentaje / 100#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#replace(form.OBOLmonto,",","","ALL")#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATdescripcion#">,
				#LvarGATid#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
			<cf_dbidentity1 name="rsLiquidacion" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="rsLiquidacion" datasource="#session.dsn#" returnVariable="LvarOBOLid">
		<cfset sbActualizaDefault(LvarOBOLid)>
	</cftransaction>
	
	<cflocation url="OBobra.cfm?OP=L&OBOid=#form.OBOid#&OBOLid=#LvarOBOLid#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OBobra.cfm?OP=L&OBOid=#form.OBOid#&btnNuevo">
<cfelseif IsDefined("url.OP") and url.OP eq "C">
	<cfinvoke component="sif.obras.Componentes.OB_obras"
			method 			= "sbIniciar_LIQUIDACION"
			returnVariable	= "LvarResultado"

			OBOid			= "#form.OBOid#"
	>

	<cflocation url="OBobra.cfm?OP=L&OBOid=#form.OBOid#">
<cfelseif IsDefined("url.OP") and (url.OP eq "L" OR url.OP eq "LL")>
	<cfif LvarAdmObr>
		<cfinvoke component="sif.obras.Componentes.OB_obras"
				method 			= "sbLiquidar_Obra"
	
				OBOid			= "#form.OBOid#"
		>
	<cfelse>
		<cf_errorCode	code = "50429" msg = "Solo se puede ejecutar la Liquidacion desde Administración de Obras">
	</cfif>
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OBobra.cfm?OP=L&OBOid=#form.OBOid#">
</cfif>

<cffunction name="sbActualizaDefault"  access="private">
	<cfargument name="OBOLid" type="numeric" required="yes">
	
	<!--- Actualiza el OBOtipoValorLiq --->
	<cfif isdefined("form.OBOtipoValorLiq")>
		<cfquery datasource="#session.dsn#">
			update OBobra
			   set OBOtipoValorLiq = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOtipoValorLiq#">
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
		</cfquery>
	</cfif>
	
	<cfquery name="rsOBO" datasource="#session.dsn#">
		select OBOtipoValorLiq, OBOLidDefault, OBOLid
		  from OBobra o
		  	left join OBobraLiquidacion ol
			  on ol.OBOLid = o.OBOLidDefault
		 where o.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
	</cfquery>

	<!--- Verifica que exista el OBOLidDefault, y si no convierte el actual en default --->
	<cfquery name="rsOBO" datasource="#session.dsn#">
		select OBOtipoValorLiq, OBOLidDefault, OBOLid
		  from OBobra o
		  	left join OBobraLiquidacion ol
			  on ol.OBOLid = o.OBOLidDefault
		 where o.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
	</cfquery>
	<cfif rsOBO.OBOLid EQ "">
		<cfset LvarOBOLidDefault = Arguments.OBOLid>
		<cfquery datasource="#session.dsn#">
			update OBobra
			   set OBOLidDefault = #LvarOBOLidDefault#
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
		</cfquery>
	<cfelse>
		<cfset LvarOBOLidDefault = rsOBO.OBOLidDefault>
	</cfif>
	
	<!--- Actualiza el porcentaje del OBOLidDefault, que no puede ser mayor que 100% --->
	<cfif rsOBO.OBOtipoValorLiq EQ "P">
		<cfquery name="rsDefault" datasource="#session.dsn#">
			select coalesce(
						(
							select sum(OBOLporcentaje)
							  from OBobraLiquidacion
							 where OBOid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
							   and OBOLid 	<> o.OBOLidDefault
						), 0) as Diferencia
			  from OBobra o
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
		</cfquery>

		<cfif rsDefault.Diferencia GT 1>
			<cf_errorCode	code = "50430"
							msg  = "El Total de Porcentajes digitados es @errorDat_1@%, que no puede ser mayor que 100%"
							errorDat_1="#rsDefault.Diferencia * 100#"
			>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update OBobraLiquidacion
			   set OBOLporcentaje = 1 - #rsDefault.Diferencia#
			 where OBOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
			   and OBOLid = #LvarOBOLidDefault#
		</cfquery>
	</cfif>

	<!--- Actualiza la cuenta de liquidación cuando el tipo es Cuenta Única --->
	<cfquery datasource="#session.dsn#" name="rsOBTP">
		select tp.OBTPtipoCtaLiquidacion
		  from OBproyecto p
			inner join OBtipoProyecto tp
				on tp.OBTPid = p.OBTPid
		 where p.OBPid = #session.obras.OBPid#
	</cfquery>
	<cfif rsOBTP.OBTPtipoCtaLiquidacion EQ "2" AND NOT IsDefined("form.Baja")>
		<cfquery datasource="#session.dsn#">
			update OBobraLiquidacion
			   set CFformatoLiquidacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFformatoLiquidacion#">
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="sbActualizaGATransacciones" output="false" access="private" returntype="numeric">
	<cfargument name="modo" type="string" required="yes">
	
	<cfif Arguments.modo EQ "ALTA">
		<cfquery name="rsGATransacciones" datasource="#session.dsn#">
			insert into GATransacciones (Ecodigo, GATdescripcion)
			values (#session.Ecodigo#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATdescripcion#">)
			<cf_dbidentity1 name="rsGATransacciones" datasource="#session.dsn#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rsGATransacciones" datasource="#session.dsn#" verificar_transaccion="false" returnVariable="LvarGATid">
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select GATid
				  from OBobraLiquidacion
			 where OBOid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
			   and OBOLid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOLid#">
		</cfquery>
		<cfset LvarGATid = rsSQL.GATid>
	</cfif>

	<cfif Arguments.modo EQ "BAJA">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			delete from GATransacciones
			 where ID = #LvarGATid#
		</cfquery>
		<cfreturn LvarGATid>
	</cfif>
	<cfquery datasource="#session.dsn#" name="rsCFuncional">
		select Ocodigo from CFuncional where CFid = #form.CFid#
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		update GATransacciones 
			set Cconcepto      = null, 
			    GATperiodo     = null, 
			    GATmes 	       = null, 
			    Edocumento     = null, 
				GATmonto 	   = null, 
				GATfecha       = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfecha)#" null="#form.GATfecha EQ ""#">, 
			    GATdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#form.GATdescripcion#">, 
			    Ocodigo 	   = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsCFuncional.Ocodigo#">, 
				ACid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.ACid#" 	null="#form.ACid EQ ""#">,
				ACcodigo 	   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.ACcodigo#" null="#form.ACcodigo EQ ""#">,
				AFMid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.AFMid#" 	null="#form.AFMid EQ ""#">,
				AFMMid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.AFMMid#" 	null="#form.AFMMid EQ ""#">,
				GATserie 	   = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GATserie#" null="#(len(trim(form.GATserie)) eq 0)#">,
				GATplaca 	   = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GATplaca#" null="#form.GATplaca EQ ""#">,
				GATfechainidep = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfechainidep)#" null="#form.GATfechainidep EQ ""#">,
				GATfechainirev = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfechainirev)#" null="#form.GATfechainirev EQ ""#">,
				CFid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CFid#">,
				CRCCid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CRCCid#" 	null="#form.CRCCid EQ ""#">,
				CRTDid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CRTDid#" 	null="#form.CRTDid EQ ""#">,
				DEid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.DEid#" 	null="#form.DEid EQ ""#">,
		<cfif isdefined("form.Aid") and len(trim(form.Aid)) and form.Aid gt 0>
		    <cfif (0.00+Replace(form.GATmonto,',','','all') GTE 0) and (isdefined("form.GATvutil") and len(trim(form.GATvutil)))>
				AFRmotivo     = null, 
				GATvutil      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATvutil#" null="#form.GATvutil EQ ""#">,
			<cfelseif (0.00+Replace(form.GATmonto,',','','all') LT 0) and (isdefined("form.AFRmotivo") and len(trim(form.AFRmotivo)) and form.AFRmotivo GT 0)>
				AFRmotivo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFRmotivo#" null="#form.AFRmotivo EQ ""#">,
				GATvutil      = 0, 
			</cfif>
		<cfelse>
				AFRmotivo     = null, 
				GATvutil      = 0, 
		</cfif>
				BMUsucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				CFcuenta      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">, 
				AFCcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFCcodigo#" null="#form.AFCcodigo EQ ""#">,
				GATestado     = 0,
				GATReferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATreferencia#" null="#(len(trim(form.GATreferencia)) eq 0)#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and ID      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGATid#">
	</cfquery>
	
	<cfreturn LvarGATid>
</cffunction>
	
<cffunction name="sbVerificaCFformatoLiq"  access="private">
	<cfif form.CFformatoLiquidacion NEQ "">
		<cfinvoke 
			component="sif.Componentes.PC_GeneraCuentaFinanciera"
			method="fnGeneraCuentaFinanciera"
			returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" 		value="#form.CFformatoLiquidacion#"/>
				<cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
				<cfinvokeargument name="Lprm_SoloVerificar" 	value="yes"/>
				<cfinvokeargument name="Lprm_NoVerificarPres" 	value="yes"/>
		</cfinvoke>
		<cfif LvarError NEQ "NEW" AND LvarError NEQ "OLD">
			<script language="javascript">
				alert("<cfoutput>#fnJSStringFormat(LvarError)#</cfoutput>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>	
</cffunction>

<cffunction name="fnJSStringFormat" returntype="string" output="false">
	<cfargument name="LvarLinea" type="string" required="yes">
	
	<cfset LvarLinea = replace(JSStringFormat(LvarLinea),"\\n","\n","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&aacute;","á","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&eacute;","é","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&iacute;","í","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&oacute;","ó","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&uacute;","ú","ALL")>
	
	<cfreturn LvarLinea>
</cffunction>


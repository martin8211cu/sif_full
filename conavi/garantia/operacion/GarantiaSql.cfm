<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">

<cfif isdefined('form.btnAceptar')>
	<cfset lineae = "">
	<cfset lineaS = "">
		<cfloop delimiters="," list="#form.chk#" index="i">
			 <cfset proceso 	= #ListGetAt(#form.chk#,1,'|')#>
			 <cfset solicitud  = #ListGetAt(i,2,'|')#>
			 <cfset linea  = ListGetAt(i,3,'|')>
			 <cfset lineae &=  linea & ',' >
			 <cfset primero = true>
		</cfloop>
	
	<cfset lineae =  mid(lineae,1,LEN(lineae) - 1)>
	<cfset LvarInsert = false> 
	<cfset lvarwhere1 = "">
	<cfset lvarwhere2 = "">
	<cfloop delimiters="," list="#form.chk#" index="i">
		<cfset solicitud  = #ListGetAt(i,2,'|')#>
		<cfset linea 		= #ListGetAt(i,3,'|')#>
				<cfset lvarwhere1 &= "(select count(1) from CMDProceso d where d.CMPid = e.CMPid and ESidsolicitud = #solicitud# and DSlinea = #linea#) > 0">	
				<cfset lvarwhere2 &= "(d.ESidsolicitud = #solicitud# and d.DSlinea = #linea#)">
				<cfset lvarwhere1 &= " and ">
				<cfset lvarwhere2 &= " or ">
				<cfset lvarwhere3 =  mid(lvarwhere2,1,LEN(lvarwhere2) - 3)>
		
	</cfloop>
		<!---/***ver si existe****/--->	
		<cfquery name="rsVProceso" datasource="#session.dsn#">
			select e.CMPid from CMProceso e where 
		<!---/****QUE EXISTAN TODAS LAS COMBINACIONES*******/--->
				#lvarwhere1#
		<!---/****QUE NO EXISTA NINGUNA OTRA COMBINACION****/--->	
				(select count(1) from CMDProceso d where d.CMPid = e.CMPid and NOT (#lvarwhere3#)) = 0
		</cfquery>
			<cfif rsVProceso.recordcount eq 0>
				<cfset LvarInsert = true> 
			</cfif>		
		<cfif LvarInsert eq false>	
			<cfquery name="rsCMProceso1" datasource="#session.dsn#">
					select CMPid,CMPid_CM,CMPProceso,CMPLinea,Ecodigo,Mcodigo,CMPMontoProceso,BMUsucodigo
						from CMProceso 
					where CMPid_CM = #proceso#
			</cfquery>
		</cfif>						
				
	<cftransaction>
	
	<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
		<cfset LvarCantidad = 0> 
		
		<cfloop delimiters="," list="#form.chk#" index="i">
			<cfset linea 		= #ListGetAt(i,3,'|')#>
				<cfquery name="rsVer" datasource="#session.dsn#">
					 select count(1) as cantidad from DSolicitudCompraCM
						where DSlinea  = #linea# and  Ecodigo = #session.Ecodigo#
				</cfquery>
					<cfset LvarCantidad  +=#rsVer.cantidad#> 
		</cfloop> 
		<cfset LvarCantidad   + 1> 
	</cfif>	

		<cfif LvarInsert eq true>
			<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
				<cfset proceso 	= #ListGetAt(#form.chk#,1,'|')#>
						
					<cfset LvarCantidad = 0> 
					
					<cfloop delimiters="," list="#form.chk#" index="i">
						<cfset linea 		= #ListGetAt(i,3,'|')#>
							<cfquery name="rsVer" datasource="#session.dsn#">
								 select count(1) as cantidad from DSolicitudCompraCM
									where DSlinea  = #linea# and  Ecodigo = #session.Ecodigo#
							</cfquery>
								<cfset LvarCantidad  +=#rsVer.cantidad#> 
					</cfloop> 
					<cfset LvarCantidad   + 1> 
					
					<cfif #LvarCantidad# eq 1>
						<cfquery name="rsDatos" datasource="#session.dsn#">
							select 
							<cf_dbfunction name="sPart"	args=" rtrim(ltrim(cc.CMPcodigoProceso))  #_Cat#  ' ' #_Cat# rtrim(ltrim(e.DSdescripcion)) #_Cat# ' - ' #_Cat# rtrim(ltrim(b.CMTSdescripcion)) #_Cat# ' - ' #_Cat# rtrim(ltrim(cc.CMPdescripcion));1; 100" delimiters=";"> as CMPdescripcion
							, cc.CMPcodigoProceso
							from ESolicitudCompraCM a
							inner join CMTiposSolicitud b 
								on b.Ecodigo = a.Ecodigo 
								and b.CMTScodigo = a.CMTScodigo
							inner join CFuncional c 
								on c.CFid = a.CFid 
							inner join DSolicitudCompraCM e 
								on e.ESidsolicitud = a.ESidsolicitud
							inner join CMLineasProceso  pr
								on pr.DSlinea = e.DSlinea
							inner join CMProcesoCompra  cc
								on cc.CMPid = pr.CMPid
							where cc.CMPid = #proceso#
						</cfquery>	
					<cfelse>
						<cfquery name="rsDatos" datasource="#session.dsn#">
							select 
								<cf_dbfunction name="sPart"	args=" rtrim(ltrim(CMPcodigoProceso))  #_Cat#  ' ' #_Cat# rtrim(ltrim(CMPdescripcion));1; 100" delimiters=";"> as CMPdescripcion							
							from CMProcesoCompra 
							where CMPid = #proceso#
						</cfquery>
					</cfif>			
						
							<cfquery name="insertProceso" datasource="#session.dsn#">
								insert into CMProceso 
									(	
										CMPid_CM,
										CMPProceso,
										CMPLinea,
										Ecodigo,
										Mcodigo,
										CMPMontoProceso,
										BMUsucodigo
									)
									values
									(
										#proceso#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CMPdescripcion#">,
										1,
										#session.Ecodigo#,
										1,
										0.00,
										#session.Usucodigo#
									)
							<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
							</cfquery>
						<cf_dbidentity2 datasource="#Session.DSN#" name="insertProceso" verificar_transaccion="false" returnvariable="CMPid">
					
					<cfquery name="rsCMProceso" datasource="#session.dsn#">
						select CMPid,CMPid_CM,CMPProceso,CMPLinea,Ecodigo,Mcodigo,CMPMontoProceso,BMUsucodigo
							from CMProceso 
						where CMPid = <cfif isdefined('CMPid') and #CMPid# neq ''>#CMPid# <cfelse>#proceso#</cfif>
					</cfquery>
			
					<cfloop delimiters="," list="#form.chk#" index="i">
						<cfset solicitud  = #ListGetAt(i,2,'|')#>
						<cfset linea 		= #ListGetAt(i,3,'|')#>
						
							<cfquery name="rsMonto" datasource="#session.dsn#">
							    select sum(DStotallinest)  as  DStotallinest from DSolicitudCompraCM
                    			where DSlinea  = #linea# and  Ecodigo = #session.Ecodigo#
							</cfquery>
						
			
							<cfquery name="insertProcesoDetalle" datasource="#session.dsn#">
								insert into CMDProceso 
									(	
										CMPid,
										ESidsolicitud,
										DSlinea,
										Ecodigo,
										BMUsucodigo
									)
									values
									(
										#CMPid#,
										#solicitud#,
										#linea#,
										#session.Ecodigo#,
										#session.Usucodigo#
									)
							<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
							</cfquery>
						<cf_dbidentity2 datasource="#Session.DSN#" name="insertProcesoDetalle" verificar_transaccion="false" returnvariable="CMDPid">
						
							 <cfquery name="rsVerificaM" datasource="#session.DSN#">
								 select CMPMontoProceso 
								  from CMProceso
								  where CMPid = #CMPid# and Ecodigo = #session.Ecodigo#
							 </cfquery>
							 <cfset LvarMT = #rsVerificaM.CMPMontoProceso#>

							<cfset monto = (#LvarMT# + #rsMonto.DStotallinest#)>
							<cfquery datasource="#session.DSN#">
								 update CMProceso 
								  set CMPMontoProceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#monto#" scale="2">
								  where CMPid = #CMPid#
							 </cfquery>
					 </cfloop>
			</cfif>
		<cfelse>
			<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
					<cfset proceso 	= #ListGetAt(#form.chk#,1,'|')#>

					<cfset LvarCantidad = 0> 
					
					<cfloop delimiters="," list="#form.chk#" index="i">
						<cfset linea 		= #ListGetAt(i,3,'|')#>
							<cfquery name="rsVer" datasource="#session.dsn#">
								 select count(1) as cantidad from DSolicitudCompraCM
									where DSlinea  = #linea# and  Ecodigo = #session.Ecodigo#
							</cfquery>
								<cfset LvarCantidad  +=#rsVer.cantidad#> 
					</cfloop> 
					<cfset LvarCantidad   + 1> 
					
					<cfif #LvarCantidad# eq 1>
						<cfquery name="rsDatos" datasource="#session.dsn#">
							select 
							<cf_dbfunction name="sPart"	args="rtrim(ltrim(e.DSdescripcion)) #_Cat# ' - ' #_Cat# rtrim(ltrim(b.CMTSdescripcion)) #_Cat# ' - ' #_Cat# rtrim(ltrim(cc.CMPdescripcion));1; 100" delimiters=";"> as CMPdescripcion
							from ESolicitudCompraCM a
							inner join CMTiposSolicitud b 
								on b.Ecodigo = a.Ecodigo 
								and b.CMTScodigo = a.CMTScodigo
							inner join CFuncional c 
								on c.CFid = a.CFid 
							inner join DSolicitudCompraCM e 
								on e.ESidsolicitud = a.ESidsolicitud
							inner join CMLineasProceso  pr
								on pr.DSlinea = e.DSlinea
							inner join CMProcesoCompra  cc
								on cc.CMPid = pr.CMPid
							where cc.CMPid = #proceso#
						</cfquery>	
					<cfelse>
						<cfquery name="rsDatos" datasource="#session.dsn#">
							select CMPdescripcion 
								from CMProcesoCompra 
							where CMPid = #proceso#
						</cfquery>
					</cfif>			
					
				<cfquery datasource="#session.DSN#">
					 update CMProceso 
					  set CMPProceso = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CMPdescripcion#">
					 where CMPid_CM = #proceso#
				 </cfquery>
		 </cfif>
		 </cfif>
	</cftransaction>

		<script language="javascript1.2" type="text/javascript">
			<cfif LvarInsert eq true>
				<cfset id =evaluate("rsCMProceso.CMPid")>
				<cfset desc ="'"&evaluate("rsCMProceso.CMPProceso")&"'">
			<cfelse>
				<cfset id =evaluate("rsCMProceso1.CMPid")>
				<cfset desc ="'"&evaluate("rsCMProceso1.CMPProceso")&"'">
			</cfif>	
			<cfif isdefined("form.funcionT") and Len(Trim(form.funcionT))>						
					window.opener.document.form1.CMPid.value=<cfoutput>#id#</cfoutput>;
					window.opener.document.form1.CMPid_codigo.value=<cfoutput>#id#</cfoutput>;
					window.opener.document.form1.CMPid_descripcion.value=<cfoutput>#desc#</cfoutput>;
			<cfelse>
					window.opener.document.form1.CMPid.value=<cfoutput>#id#</cfoutput>;
					window.opener.document.form1.CMPid_codigo.value=<cfoutput>#id#</cfoutput>;
					window.opener.document.form1.CMPid_descripcion.value=<cfoutput>#desc#</cfoutput>;
			</cfif>
				window.close();
		</script>
	<cfabort>
</cfif>

<cfif isdefined("url.COEGReciboGarantia") and not isdefined("form.COEGReciboGarantia") and len(trim(url.COEGReciboGarantia)) or isdefined("url.COEGReciboGarantia") and isdefined("form.COEGReciboGarantia") and len(trim(url.COEGReciboGarantia))>
	<cfset form.COEGReciboGarantia = url.COEGReciboGarantia>
</cfif>
<cfif isdefined("url.COEGVersion") and not isdefined("form.COEGVersion") and len(trim(url.COEGVersion)) or isdefined("url.COEGVersion") and isdefined("form.COEGVersion") and len(trim(url.COEGVersion))>
	<cfset form.COEGVersion = url.COEGVersion>
</cfif>
<cfif isdefined("url.COEGid") and not isdefined("form.COEGid") and len(trim(url.COEGid)) or isdefined("url.COEGid") and isdefined("form.COEGid") and len(trim(url.COEGid))>
	<cfset form.COEGid = url.COEGid>
</cfif>
<cfif isdefined("url.CODGid") and not isdefined("form.CODGid") and len(trim(url.CODGid)) or isdefined("url.CODGid") and isdefined("form.CODGid") and len(trim(url.CODGid))>
	<cfset form.CODGid = url.CODGid>
</cfif>
<cfif isdefined("url.COEGEstado") and not isdefined("form.COEGEstado") and len(trim(url.COEGEstado)) or isdefined("url.COEGEstado") and isdefined("form.COEGEstado") and len(trim(url.COEGEstado))>
	<cfset form.COEGEstado = url.COEGEstado>
</cfif>

<cfif isdefined("form.nuevoE")>
	<cflocation url="GarantiaForm.cfm" addtoken="no">
</cfif>
<cfif isdefined("form.nuevoD")>
	<cflocation url="GarantiaForm.cfm?COEGid=#form.COEGid#" addtoken="no">
</cfif>

<cfif isdefined("Form.AltaE")>

	<cfquery name="rsVerifica" datasource="#session.DSN#">
    	select count(1) as cantidad
        from COEGarantia
        where  1 =1
		and CMPid = 
        <cfif len(trim(form.CMPid))>
	        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
		<cfelse>
			-1
        </cfif>
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and COEGTipoGarantia = #form.COEGTipoGarantia#
        and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
        and not exists (select 1 
					   from COHEGarantia
					   where COEGEstado = 8
					   and CMPid = 
					   <cfif len(trim(form.CMPid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
						<cfelse>
							-1
						</cfif>
						)
    </cfquery>
    
    <cfif rsVerifica.cantidad gt 0 >
        <cfquery name="rsVerifica" datasource="#session.DSN#">
            select SNnumero
            from SNegocios
            where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
        </cfquery>
        <cfset LvarSNnumero = rsVerifica.SNnumero>

        <cfswitch expression="#form.COEGTipoGarantia#">
            <cfcase value="1">
            	<cfset LvarCOEGTipoGarantia = 'Participación'>
            </cfcase>
             <cfcase value="2">
            	<cfset LvarCOEGTipoGarantia = 'Cumplimiento'>
            </cfcase>
        </cfswitch>

		<cfset LvarCMPProceso = ' '>
    	<cfif isdefined("CMPid") and len(trim(CMPid))>
            <cfquery name="rsVerifica" datasource="#session.DSN#">
                select CMPProceso
                from CMProceso
                where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CMPid#">
            </cfquery>
        	<cfset LvarCMPProceso = rsVerifica.CMPProceso>
        </cfif>
        <cfif form.CMPid NEQ ''>
    		<cfthrow message="El proveedor ya entregó la garantía, para el proceso: '#LvarCMPProceso#', Proveedor: '#LvarSNnumero#' para el tipo de garantía: '#LvarCOEGTipoGarantia#'. Acción Cancelada!">
    	</cfif>	
    </cfif>
	<cflock scope="application" timeout="7" type="exclusive">
		<cfset LvarConsecutivo = fnGetParametro (session.Ecodigo, 4000,  "Consecutivo Recibo Número de Garantia")>
		<cfif len(trim(lvarConsecutivo)) gt 0 and isnumeric(lvarConsecutivo)>
			<cfset lvarConsecutivo = lvarConsecutivo + 1>
		<cfelse>
			<cfthrow message="El parametro 'Consecutivo Recibo Número de Garantia' no ha sido definido o configurado, para continuar se debe de ir a Garantías -> Parametros Generales.">
		</cfif>
		<cfquery name="rsConseControlGarantia" datasource="#session.DSN#">
            select coalesce(max(COEGNumeroControl),0) + 1 as consecutivoControl 
            from COHEGarantia
            where COEGVersionActiva = 1 <!--- Activa --->
        </cfquery>
        <cfset LvarConsecutivoControl = rsConseControlGarantia.consecutivoControl> 
		<cftransaction>
			<cfquery name="rsInserta" datasource="#session.DSN#">
				insert into COEGarantia(Ecodigo, 
					  <cfif len(trim(CMPid))>
							CMPid,                                
					  </cfif> 
							SNid,
							COEGTipoGarantia, 
							COEGPersonaEntrega, 
							COEGIdentificacion, 
							COEGReciboGarantia, 
							COEGMontoTotal, 
							Mcodigo, 
							COEGFechaRecibe, 
							COEGEstado, 
							COEGVersion, 
							COEGUsuCodigo, 
							BMUsucodigo,
							COEGVersionActiva,
							COEGContratoAsociado,
							COEGNumeroControl
						  )
				values(
							#session.Ecodigo#,
					  <cfif len(trim(CMPid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">,
					  </cfif>							
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
							#form.COEGTipoGarantia#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COEGPersonaEntrega#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COEGIdentificacion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarConsecutivo#">,
							#form.COEGMontoTotal#,
							#form.Mcodigo#, <!---Hay que modificar pa q la moneda llegue cuando es una Garantia sin proceso, ejemlios yo los case en 1--->                               
							#form.COEGFechaRecibe#,
							#form.COEGEstado#,
							#form.COEGVersion#,
							#session.Usucodigo#,
							#session.Usucodigo#,
							1, <!--- 1: Version activa, 2: Versión Inactiva --->
							<cfif isdefined("form.COEGContratoAsociado")>'S'<cfelse>'N'</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarConsecutivoControl#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsInserta" returnvariable="LvarCOEGid">
			<cfset updateDato(4000,LvarConsecutivo)>
		</cftransaction>
    </cflock>
    
    <cflocation url="GarantiaForm.cfm?COEGid=#LvarCOEGid#" addtoken="no">
<cfelseif isdefined("Form.CambioE")>
	<cfquery datasource="#session.DSN#">
	    update COEGarantia 
        set
        <cfif isdefined('form.CMPid')>
        	CMPid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CMPid#" VoidNull>,
        </cfif>    
        COEGContratoAsociado=<cfif isdefined("form.COEGContratoAsociado")>'S'<cfelse>'N'</cfif>,
        SNid = #form.SNid#,
        COEGTipoGarantia = #form.COEGTipoGarantia#,
        COEGVersion = #form.COEGVersion#,
        COEGPersonaEntrega = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COEGPersonaEntrega#">,
        COEGIdentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COEGIdentificacion#">
        where COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
    </cfquery>
    <cfset LvarUpdate = fnUpdateTotalGarantia(form.COEGid)>

	<cflocation url="GarantiaForm.cfm?COEGid=#form.COEGid#" addtoken="no">
<cfelseif isdefined("Form.BajaE")>
	<cftransaction action="begin">
		<!--- no debe eliminar garantías con tipos de rendición que generan depósitos --->
        <cfquery datasource="#session.DSN#">
            delete from CODGarantia 
            where COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
            and (
                select count(1)
                from COTipoRendicion a
                where a.COTRid = CODGarantia.COTRid 
                and a.COTRGenDeposito = 1 <!--- 0: No genera depósito, 1: Si genera depósito  --->
                ) =0
        </cfquery>
        <cfquery name="rsVerificaBorrado" datasource="#session.DSN#">
        	select count(1) as cantidad
            from CODGarantia 
            where COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
        </cfquery>
        <cfif rsVerificaBorrado.cantidad gt 0>
        	<cfthrow message="No se pueden eliminar Garantías con tipos de rendición que generan depósito. Borrado cancelado!">
            <cftransaction action="rollback"/>
        </cfif>
        <cfquery datasource="#session.DSN#">
            delete from COEGarantia 
            where COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
        </cfquery>
    </cftransaction>
    <cflocation url="Garantia.cfm" addtoken="no">
</cfif>

<cfif isdefined("Form.AltaD")>
	<cfset LvarfechaIni = createdate(mid(form.CODGFechaIni, 7, 4), mid(form.CODGFechaIni, 4, 2), mid(form.CODGFechaIni, 1, 2))>
    <cfset LvarfechaFin = createdate(mid(form.CODGFechaFin, 7, 4), mid(form.CODGFechaFin, 4, 2), mid(form.CODGFechaFin, 1, 2))>
    <cfquery name="rsCuenta" datasource="#session.DSN#">
    	select CcuentaGarantiaRecibida 
        from COTipoRendicion
        where COTRid = #form.COTRid#
    </cfquery>
     <cfif rsCuenta.recordcount eq 0 or len(trim(rsCuenta.CcuentaGarantiaRecibida)) eq 0>
    	<cfthrow message="No se ha definido la Cuenta de Garantia Recibida para el Tipo de Rendición que se está utilizando.">
    </cfif>
    <cfset LvarCcuentaGarantiaRecibida = rsCuenta.CcuentaGarantiaRecibida>
    
    <cfquery name="rsTranDep" datasource="#session.DSN#">
    	select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
        and Pcodigo = 1810
        and Mcodigo = 'GA'
    </cfquery>
    <cfif rsTranDep.recordcount eq 0>
    	<cfthrow message="No se ha definido el siguiente parámetro en administración del sistema: Transacción Bancaria para Depósitos de Garantía, favor escoger una y hacer click en aceptar.">
    </cfif>
    
    <cfset LvarBTid = rsTranDep.Pvalor>
    
	<cftransaction>
        <cfquery name="rsInsertD" datasource="#session.DSN#">
            insert into CODGarantia 
                (COEGid, 
                 Ecodigo, 
                 CODGFecha, 
                 CODGMonto, 
                 CODGMcodigo, 
                 CODGTipoCambio, 
                 CODGNumeroGarantia, 
                 COTRid, 
                 CODGFechaIni, 
                 CODGFechaFin, 
                 CODGObservacion, 
                 CODGUsucodigo, 
                 CcuentaRecibida, 
                 CcuentaGarxPagar,
                 CODGNumDeposito,
                 Bid, 
                 CBid, 
                 BMUsucodigo,
                 COEGReciboGarantia,
                 COEGVersion,
                 BTid,
                 Ccuenta
                )
            values 
            (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">,
                #session.Ecodigo#,
                #form.CODGFecha#,
                <cfqueryparam cfsqltype="cf_sql_money" value="#form.CODGMonto#">,
                #form.CODGMcodigo#,
                <cfqueryparam cfsqltype="cf_sql_money" value="#form.CODGTipoCambio#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CODGNumeroGarantia#">,
                #form.COTRid#,
                #LvarfechaIni#,
                #LvarfechaFin#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CODGObservacion#">,
                #session.Usucodigo#,
                #form.CcuentaRecibida#,
                #form.CcuentaGarxPagar#,
                <cfif isdefined("form.CODGNumDeposito") and len(trim(form.CODGNumDeposito))>'#form.CODGNumDeposito#'<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"></cfif>,
                #form.Bid#,
                <cfif isdefined("form.CBid") and len(trim(form.CBid))>#form.CBid#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>,
                #session.Usucodigo#,
                #form.COEGReciboGarantia#,
                #form.COEGVersion#,

                <cfif isdefined("LvarBTid") and len(trim(LvarBTid))>#LvarBTid#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>,
                <cfif isdefined("LvarCcuentaGarantiaRecibida") and len(trim(LvarCcuentaGarantiaRecibida))>#LvarCcuentaGarantiaRecibida#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>
            )
            <cf_dbidentity1 datasource="#Session.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertD" returnvariable="LvarCODGid">
        
        <!--- Actualiza el encabezado con la suma de los detalles en la moneda local
		OJO poner un coalesce --->
		<cfset LvarUpdate = fnUpdateTotalGarantia(form.COEGid)>
    </cftransaction>
    <cflocation url="GarantiaForm.cfm?COEGid=#form.COEGid#&CODGid=#LvarCODGid#" addtoken="no">
<cfelseif isdefined("Form.CambioD")>
	<cfset LvarfechaIni = createdate(mid(form.CODGFechaIni, 7, 4), mid(form.CODGFechaIni, 4, 2), mid(form.CODGFechaIni, 1, 2))>
    <cfset LvarfechaFin = createdate(mid(form.CODGFechaFin, 7, 4), mid(form.CODGFechaFin, 4, 2), mid(form.CODGFechaFin, 1, 2))>
    
     <cfquery name="rsCuenta" datasource="#session.DSN#">
    	select CcuentaGarantiaRecibida 
        from COTipoRendicion
        where COTRid = #form.COTRid#
    </cfquery>
     <cfif rsCuenta.recordcount eq 0 or len(trim(rsCuenta.CcuentaGarantiaRecibida)) eq 0>
    	<cfthrow message="No se ha definido la Cuenta de Garantia Recibida para el Tipo de Rendición que se está utilizando.">
    </cfif>
    <cfset LvarCcuentaGarantiaRecibida = rsCuenta.CcuentaGarantiaRecibida>
    <cfquery name="rsTranDep" datasource="#session.DSN#">
    	select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
        and Pcodigo = 1810
        and Mcodigo = 'GA'
    </cfquery>
    <cfif rsTranDep.recordcount eq 0>
    	<cfthrow message="No se ha definido el siguiente parámetro en administración del sistema: Transacción Bancaria para Depósitos de Garantía, favor escoger una y hacer click en aceptar.">
    </cfif>
    
    <cfset LvarBTid = rsTranDep.Pvalor>
    
	<!--- Valida que la lineas de detalle no sea de deposito y no aya sido activada--->
	<cfquery name="rsDetallesConDeposito" datasource="#session.dsn#">
		select gd.CODGid, gd.COEGid, gd.COEGVersion, tr.COTRGenDeposito
		from CODGarantia gd
			inner join COTipoRendicion tr
				on tr.COTRid = gd.COTRid
			inner join COHDGarantia hgd
				on hgd.CODGid = gd.CODGid 
		  		  and hgd.COEGid = gd.COEGid 
		  		  and hgd.COEGVersion = gd.COEGVersion
		where gd.CODGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CODGid#">
	</cfquery>
	<cfif rsDetallesConDeposito.recordcount gt 0 and rsDetallesConDeposito.COTRGenDeposito eq '1'>
		<cfthrow message="El detalle de la garantía de se no puede editar ya que es de tipo deposito.">
	</cfif>

	<cftransaction>
        <cfquery datasource="#session.DSN#">
            update CODGarantia 
                set CODGMonto = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CODGMonto#">,
                CODGMcodigo = #form.CODGMcodigo#,
                CODGTipoCambio = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CODGTipoCambio#">,
                CODGNumeroGarantia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CODGNumeroGarantia#">,
                COTRid = #form.COTRid#,
                CODGFechaIni = #LvarfechaIni#,
                CODGFechaFin = #LvarfechaFin#,
                CODGObservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CODGObservacion#">,
                Bid = #form.Bid#,
                CODGNumDeposito = <cfif isdefined("form.CODGNumDeposito") and len(trim(form.CODGNumDeposito))>'#form.CODGNumDeposito#'<cfelse>null</cfif>,
                CBid = <cfif isdefined("form.CBid") and len(trim(form.CBid))>#form.CBid#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>,
                BTid = <cfif isdefined("LvarBTid") and len(trim(LvarBTid))>#LvarBTid#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>,
                Ccuenta = <cfif isdefined("LvarCcuentaGarantiaRecibida") and len(trim(LvarCcuentaGarantiaRecibida))>#LvarCcuentaGarantiaRecibida#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>
            where CODGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CODGid#">
        </cfquery>
    
        <!--- Actualiza el encabezado con la suma de los detalles en la moneda local --->
		<cfset LvarUpdate = fnUpdateTotalGarantia(form.COEGid)>    </cftransaction>
	<cflocation url="GarantiaForm.cfm?COEGid=#form.COEGid#&CODGid=#form.CODGid#" addtoken="no">
<cfelseif isdefined("Form.BajaD")>
	<cftransaction>
        <cfquery datasource="#session.DSN#">
            delete from CODGarantia 
            where CODGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CODGid#">
        </cfquery>
        
        <!--- Actualiza el encabezado con la suma de los detalles en la moneda local
		OJO poner un coalesce --->
        <cfquery datasource="#session.DSN#">
        	update COEGarantia
            set COEGMontoTotal =  coalesce(
            	(
            	select 
            	sum(CODGMonto * CODGTipoCambio)
                from CODGarantia b 
                where b.COEGid = COEGarantia.COEGid
                ),0)
            where COEGid = #form.COEGid#
        </cfquery>
    </cftransaction>
	<cflocation url="GarantiaForm.cfm?COEGid=#form.COEGid#" addtoken="no">
<cfelseif isdefined("Form.BTNActivar")>

	<!--- 
		-- Pasa el registro a la tabla de históricos
		
		Una en edición cuando se activa la primera vez:
		- Graba la garantía en el histórico como vigente y activa
		- Cambia el estado en COEGarantia de Edición a Vigente.
		- Genera Asiento.
		- Si genera depósito el tipo de rendición entonces hay que generar un documento de depósito bancario y aplicarlo.
		
		Una vigente cuando se Edita:
		- Cambia el estado en COEGarantia de Vigente a Edición.
		- Pone la versión que estaba vigente como histórica.
		
		Una en edición cuando se activa luego de la primera vez:
		- Graba la garantía con la nueva versión en el histórico como vigente y activa
		- Cambia el estado en COEGarantia de Edición a Vigente.
		- Genera Asiento reversando Versión vigente (con montos negativos) y agregando los movimientos de la nueva versión (positivos).
		- Si genera depósito el tipo de rendición entonces hay que ver como reversar el documento depósito generado anteriormente y generar un documento de 
		  depósito bancario nuevo y aplicarlo Esta parte se puede complicar por los cierres de mes....
		
	 --->
	<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">
	<cfinvoke component="conavi.Componentes.garantia" method="fnGetParametro" returnvariable="correo">
		<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
		<cfinvokeargument name="Pcodigo" value="2100"/>
		<cfinvokeargument name="Pdescripcion" value="Correo Persona encargada de garantías"/>
	</cfinvoke>
		
	<cftransaction action="begin">
		<cfset LvarHistoria = fnHistoria(form.COEGid, form.COEGEstado, 'BTNActivar', form.COEGReciboGarantia, form.COEGVersion)>
        <cfset LvarGeneraAsieto = fnGeneraAsieto(form.COEGid, form.COEGEstado, 'BTNActivar', form.COEGReciboGarantia, form.COEGVersion)>
	</cftransaction>
	<cfsavecontent variable="contenido">
		<cfinclude template="correoGarantiaActiva.cfm">
	</cfsavecontent>
	<cfif len(trim(correo))><!---Si esta configurado la persona encargada de las garantias--->
		<cfinvoke component="conavi.Componentes.garantia" method="CORREO_GARANTIA" returnvariable="correo">
			<cfinvokeargument name="remitente" value="#enviadoPor#"/>
			<cfinvokeargument name="destinario" value="#correo#"/>
			<cfinvokeargument name="asunto" value="Garantía #rsEncabezado.COEGReciboGarantia#-#rsEncabezado.COEGVersion# ha sido #rsEncabezado.msg#a"/>
			<cfinvokeargument name="texto" value="#contenido#"/>
			<cfinvokeargument name="usuario" value="#session.usucodigo#"/>
			<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
		</cfinvoke>
	</cfif>

	<!---Si realiza bien el cftransaction manda a imprimir--->
	<cfinclude template="imprimeGarantia.cfm">
	<cfabort> 
	<!---<cflocation url="Garantia.cfm" addtoken="no">--->
<cfelseif isdefined("Form.EDITARE")>
	<cftransaction>
		<cfset LvarHistoria = fnHistoria(form.COEGid, form.COEGEstado, 'EDITARE', form.COEGReciboGarantia, form.COEGVersion)>
        <!--- <cfset LvarGeneraAsieto = fnGeneraAsieto(form.COEGid, form.COEGEstado, 'EDITARE', form.COEGReciboGarantia, form.COEGVersion)> --->
    </cftransaction>
	<cflocation url="GarantiaForm.cfm?COEGid=#form.COEGid#" addtoken="no">
<cfelseif isdefined("Form.BTNDESCARTAR")>

	<cftransaction>
        <cfquery datasource="#session.DSN#">
            update COEGarantia set 
                COEGEstado = 1, <!--- Lo deja en Vigente --->
                COEGVersionActiva = 1
                <!--- esto solo se hace la segunda vez  --->
                <cfif form.COEGVersion gt 1>
                	, COEGVersion = #form.COEGVersion# - 1
                </cfif>
            where COEGReciboGarantia = #form.COEGReciboGarantia#
            and COEGVersion = #form.COEGVersion# <!--- si viene por el botón descartar me envían la versión vigente no la versión en edición --->
        </cfquery>

        <!--- Como en la historia solo se guardan los movimientos activos, entonces no hay que borrar nada --->
    </cftransaction>
	<cflocation url="Garantia.cfm" addtoken="no">
</cfif>

<cflocation url="Garantia.cfm" addtoken="no">	



<cffunction name="fnHistoria" access="public" output="no" returntype="any">
	<cfargument name="COEGid" 		type="numeric"  required="yes">
    <cfargument name="COEGEstado" 	type="numeric"  required="yes">
    <cfargument name="InvocadoPor" 	type="string"  required="yes">
    <cfargument name="COEGReciboGarantia" 	type="numeric"  required="yes">
    <cfargument name="COEGVersion" 	type="numeric"  required="yes">
    <cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
    <cfargument name='Ecodigo' 		type='numeric' 	required='false' default	= "#Session.Ecodigo#">
	
    <!--- Solo grava el vigente en la historia --->
    <cfif arguments.InvocadoPor eq 'BTNActivar'><!--- <cfdump var="#form#"><cf_dump var="#form#"> --->
	<cfquery name="rsConseControlHGarantia" datasource="#session.DSN#">
            select coalesce(max(COEGNumeroControl),0) + 1 as consecutivoHControl 
            from COHEGarantia
            where COEGVersionActiva = 1 <!--- Activa --->
    </cfquery>
    <cfset LvarConsecutivoHControl = rsConseControlHGarantia.consecutivoHControl> 
		<!--- Pasa el encabezado de la garantía al histórico --->
        <cfquery datasource="#arguments.Conexion#">
            insert into COHEGarantia(
                                    COEGid,
                                    Ecodigo,
                                    CMPid,
                                    SNid,
                                    COEGTipoGarantia,
                                    COEGPersonaEntrega,
                                    COEGIdentificacion,
                                    COEGReciboGarantia,
                                    COEGMontoTotal,
                                    Mcodigo,
                                    COEGFechaRecibe,
                                    COEGEstado,
                                    COEGVersion,
                                    COEGUsuCodigo,
                                    COEGFechaActiva,
                                    COEGVersionActiva,
                                    COEGDocDevOEjec,
                                    COEGFechaDevOEjec,
                                    COEGUsuCodigoDevOEjec,
                                    BMUsucodigo,
									COEGContratoAsociado,
									COEGNumeroControl
                                   )
            select  
                                    COEGid,
                                    Ecodigo,
                                    CMPid,
                                    SNid,
                                    COEGTipoGarantia,
                                    COEGPersonaEntrega,
                                    COEGIdentificacion,
                                    COEGReciboGarantia,
                                    COEGMontoTotal,
                                    Mcodigo,
                                    COEGFechaRecibe,
                                    <cfif arguments.InvocadoPor eq 'BTNActivar'>1<cfelseif arguments.InvocadoPor eq 'EDITARE'>2</cfif>,
                                    #arguments.COEGVersion#,
                                    COEGUsuCodigo,
                                    COEGFechaActiva,
                                    COEGVersionActiva,
                                    COEGDocDevOEjec,
                                    COEGFechaDevOEjec,
                                    COEGUsuCodigoDevOEjec,
                                    BMUsucodigo,
                                    COEGContratoAsociado,
									#LvarConsecutivoHControl#
            from COEGarantia
            where COEGid = #arguments.COEGid#
        </cfquery>
		
		<cfif #arguments.COEGVersion# NEQ  1>
			<cfquery datasource="#arguments.Conexion#">				
					update COHEGarantia set 
							COEGVersionActiva = 2
					where COEGReciboGarantia = #arguments.COEGReciboGarantia# 
					and COEGVersion = #arguments.COEGVersion# - 1
					and COEGid = #arguments.COEGid#			
			</cfquery>
			<cfquery datasource="#arguments.Conexion#">				
					update COEGarantia set 
							COEGNumeroControl = #LvarConsecutivoHControl#
					where COEGReciboGarantia = #arguments.COEGReciboGarantia# 
					and COEGVersion = #arguments.COEGVersion# 
					and COEGid = #arguments.COEGid#			
			</cfquery>
        </cfif>	
		
        <!--- Pasa el detalle de la garantía al histórico --->
        <cfquery datasource="#arguments.Conexion#">
            insert into COHDGarantia(
                                    CODGid,
                                    COEGid,
                                    Ecodigo,
                                    CODGFecha,
                                    CODGMonto,
                                    CODGMcodigo,
                                    CODGTipoCambio,
                                    CODGNumeroGarantia,
                                    COTRid,
                                    CODGFechaIni,
                                    CODGFechaFin,
                                    CODGObservacion,
                                    CODGUsucodigo,
                                    CcuentaRecibida,
                                    CcuentaGarxPagar,
                                    CODGNumDeposito,
                                    Bid,
                                    CBid,
                                    BMUsucodigo,
                                    COEGReciboGarantia, 
                                    COEGVersion
                                   )
            select 
                                    CODGid,
                                    COEGid,
                                    Ecodigo,
                                    CODGFecha,
                                    CODGMonto,
                                    CODGMcodigo,
                                    CODGTipoCambio,
                                    CODGNumeroGarantia,
                                    COTRid,
                                    CODGFechaIni,
                                    CODGFechaFin,
                                    CODGObservacion,
                                    CODGUsucodigo,
                                    CcuentaRecibida,
                                    CcuentaGarxPagar,
                                    CODGNumDeposito,
                                    Bid,
                                    CBid,
                                    BMUsucodigo,
                                    COEGReciboGarantia, 
                                    #arguments.COEGVersion#
            from CODGarantia
            where COEGid = #arguments.COEGid#
        </cfquery>
    
    	<cfquery datasource="#arguments.Conexion#">
        	update COEGarantia set 
            	COEGEstado = 1, <!--- Lo deja en Vigente --->
                COEGVersionActiva = 1
            where COEGReciboGarantia = #arguments.COEGReciboGarantia#
            and COEGVersion = #arguments.COEGVersion#
        </cfquery>
    <cfelseif arguments.InvocadoPor eq 'EDITARE'>
	    <!--- Si esta vigente Actualiza COEGarantia con versión + 1, estado en 2 y COEGVersionActiva en 1 --->
    	<cfquery datasource="#arguments.Conexion#">
        	update COEGarantia set 
            	COEGEstado = 2, <!--- Lo deja en Edición --->
            	COEGVersion = #arguments.COEGVersion# + 1, <!--- El incremento lo maneja el form según el estado del documento --->
                COEGVersionActiva = 1,
				COEGFechaRecibe = #now()#
            where COEGReciboGarantia = #arguments.COEGReciboGarantia#
            and COEGVersion = #arguments.COEGVersion#
        </cfquery>
  	</cfif>
    <cfreturn 1>
</cffunction>


<cffunction name="fnGeneraAsieto" access="public" output="yes" returntype="any">
	<cfargument name="COEGid" 		type="numeric"  required="yes">
    <cfargument name="COEGEstado" 	type="numeric"  required="yes">
    <cfargument name="InvocadoPor" 	type="string"  required="yes">
    <cfargument name="COEGReciboGarantia" 	type="numeric"  required="yes">
    <cfargument name="COEGVersion" 	type="numeric"  required="yes">
    <cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
    <cfargument name='Ecodigo' 		type='numeric' 	required='false' default	= "#Session.Ecodigo#">

	<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
    <cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
        
        <!--- 
			Garantía Recibida:  Débito
			Garantía por pagar: Crédito
		--->
    
        <!--- Garantía Recibida:  Débito --->
        <cfset LvarAnoAux 				= fnGetParametro (Arguments.Ecodigo, 50,  "Periodo de Auxiliares")>
        <cfset LvarMesAux 				= fnGetParametro (Arguments.Ecodigo, 60,  "Mes de Auxiliares")>
    
        <!---==Obtiene la minima oficina del Asiento, si no tienen entonces la minina Oficina para la empresa==---> 
        <!---==============La oficina se le manda al genera asiento para que agrupe===========================--->
        <cfquery name="rsMinOficinaINTARC" datasource="#session.dsn#">
            select Min(Ocodigo) as MinOcodigo
            from #INTARC#
        </cfquery>
        <cfquery name="rsMinOficina" datasource="#session.dsn#">
            select Min(Ocodigo) as MinOcodigo
            from Oficinas
            where Ecodigo = #Arguments.Ecodigo#
        </cfquery>
        <cfif isdefined("rsMinOficinaINTARC") and rsMinOficinaINTARC.recordcount GT 0 and len(trim(rsMinOficinaINTARC.MinOcodigo))>
            <cfset LvarOcodigo = rsMinOficinaINTARC.MinOcodigo>
        <cfelseif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
            <cfset LvarOcodigo = rsMinOficina.MinOcodigo>
        <cfelse>
            <cfset LvarOcodigo = -100>
        </cfif>
        
        <cf_dbfunction name="to_char" args="a.COEGReciboGarantia" returnvariable="LvarRecibo">
        <!--- Si la versión es mayor que uno hay que hacer asiento con montos negativos de la versión anterior. --->
        <cfif arguments.COEGVersion gt 1>
            <!--- Se busca en el histórico la versión anterior para hacer la línea del asiento negativo de la Cuenta Garantía Recibida: Débito --->
            <!--- Pero contablemente un negativo es un movimiento contrario (pasa el monto de débito a crédito por ejemplo). Por lo tanto este asiento debe ser crédito por el 
                  monto positivo (sabiendo que originalmente se generó un débito) --->
            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
                insert into #INTARC# 
                    ( 
                        INTORI, 
                        INTREL, 
                        INTDOC, 
                        
                        INTREF, 
                        INTTIP, 
                        
                        INTDES, 
                        INTFEC, 
                        Periodo, 
                        Mes, 
                        Ccuenta, 
                        Ocodigo, 
                        Mcodigo, 
                        INTMOE, 
                        INTCAM, 
                        INTMON
                    )
                select 
                        'COGA',
                        1,
                        #preservesinglequotes(LvarRecibo)#,
                        
                        ' - GARANTIA (reversión)', 
                        'C',
                        <cf_dbfunction name="concat" args="'Garantía Recibida: ' + #trim(preservesinglequotes(LvarRecibo))# + ', Proveedor: ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#">,
                        '#dateFormat(now(),"YYYYMMDD")#',
                        #LvarAnoAux#,
                        #LvarMesAux#,
                        b.CcuentaRecibida,
                        #LvarOcodigo#,
        
                        b.CODGMcodigo,
                        
                        b.CODGMonto,
                        b.CODGTipoCambio,
                        round(b.CODGMonto * b.CODGTipoCambio,2)
                from COHEGarantia a
                    inner join COHDGarantia b
                         on b.COEGReciboGarantia = a.COEGReciboGarantia
                        and b.COEGVersion = a.COEGVersion
                        and b.Ecodigo = a.Ecodigo
                    inner join SNegocios c
                         on c.SNid = a.SNid
                    inner join COTipoRendicion d
                        on d.COTRid = b.COTRid
                where a.COEGReciboGarantia = #arguments.COEGReciboGarantia#
                  and a.COEGVersion = #arguments.COEGVersion# - 1
                  and a.COEGEstado = 1 <!--- Vigente --->
                  and a.COEGVersionActiva = 2
            </cfquery>
            <!--- se busca en el histórico la versión anterior para hacer la línea del asiento negativo de la Cuenta Garantía por Pagar: Crédito --->
            <!--- Pero contablemente un negativo es un movimiento contrario (pasa el monto de crédito a débito por ejemplo). Por lo tanto este asiento debe ser débito por el 
					monto positivo (sabiendo que originalmente se generó un crédito) --->
            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
                insert into #INTARC# 
                    ( 
                        INTORI, 
                        INTREL, 
                        INTDOC, 
                        
                        INTREF, 
                        INTTIP, 
                        
                        INTDES, 
                        INTFEC, 
                        Periodo, 
                        Mes, 
                        Ccuenta, 
                        Ocodigo, 
                        Mcodigo, 
                        INTMOE, 
                        INTCAM, 
                        INTMON
                    )
                select 
                        'COGA',
                        1,
                        #preservesinglequotes(LvarRecibo)#,
                        
                        ' - GARANTIA (reversión)', 
                        'D',
                        <cf_dbfunction name="concat" args="'Garantía por pagar: ' + #trim(preservesinglequotes(LvarRecibo))# + ', Proveedor: ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#">,
                        '#dateFormat(now(),"YYYYMMDD")#',
                        #LvarAnoAux#,
                        #LvarMesAux#,
                        b.CcuentaGarxPagar,
                        #LvarOcodigo#,
            
                        b.CODGMcodigo,
                        
                        b.CODGMonto,
                        b.CODGTipoCambio,
                        round(b.CODGMonto * b.CODGTipoCambio,2)
                from COHEGarantia a
                    inner join COHDGarantia b
                         on b.COEGReciboGarantia = a.COEGReciboGarantia
                        and b.COEGVersion = a.COEGVersion
                        and b.Ecodigo = a.Ecodigo
                    inner join SNegocios c
                         on c.SNid = a.SNid
                    inner join COTipoRendicion d
                        on d.COTRid = b.COTRid
                where a.COEGReciboGarantia = #arguments.COEGReciboGarantia#
                  and a.COEGVersion = #arguments.COEGVersion# - 1
                  and a.COEGEstado = 1 <!--- Vigente --->
                  and a.COEGVersionActiva = 2
            </cfquery>
		</cfif>
        <cf_dbfunction name="concat" args="'Garantía Recibida: ' + #trim(preservesinglequotes(LvarRecibo))# + ', Proveedor: ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#" returnvariable="LvarDescripcionRecibida">
        <!--- Se hace la línea del asiento para la cuenta Garantia Recibida  --->
        <cfquery datasource="#Arguments.Conexion#">
            insert into #INTARC# 
                ( 
                    INTORI, 
                    INTREL, 
                    INTDOC, 
                    
                    INTREF, 
                    INTTIP, 
                    
                    INTDES, 
                    INTFEC, 
                    Periodo, 
                    Mes, 
                    Ccuenta, 
                    Ocodigo, 
                    Mcodigo, 
                    INTMOE, 
                    INTCAM, 
                    INTMON
                )
            select 
                    'COGA',
                    1,
                    #preservesinglequotes(LvarRecibo)#,
                    
                    'GARANTIA', 
                    'D',
                    #preservesinglequotes(LvarDescripcionRecibida)#,
                    '#dateFormat(now(),"YYYYMMDD")#',
                    #LvarAnoAux#,
                    #LvarMesAux#,
                    b.CcuentaRecibida,
                    #LvarOcodigo#,
    
                    b.CODGMcodigo,
                    
                    b.CODGMonto,
                    b.CODGTipoCambio,
                    round(b.CODGMonto * b.CODGTipoCambio,2)
            from COEGarantia a
                inner join CODGarantia b
                    on b.COEGid = a.COEGid
                inner join SNegocios c
                     on c.SNid = a.SNid
                inner join COTipoRendicion d
                    on d.COTRid = b.COTRid
            where a.COEGid = #arguments.COEGid#
              and a.COEGEstado = 1 <!--- Vigente --->
              and a.COEGVersionActiva = 1 <!--- Activa --->
        </cfquery>
        
         <cf_dbfunction name="concat" args="'Garantía por pagar: ' + #trim(preservesinglequotes(LvarRecibo))# + ', Proveedor: ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#"  returnvariable="LvarDescripcionPagada">
        <!--- Garantía por pagar: Crédito --->
        <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
            insert into #INTARC# 
                ( 
                    INTORI, 
                    INTREL, 
                    INTDOC, 
                    
                    INTREF, 
                    INTTIP, 
                    
                    INTDES, 
                    INTFEC, 
                    Periodo, 
                    Mes, 
                    Ccuenta, 
                    Ocodigo, 
                    Mcodigo, 
                    INTMOE, 
                    INTCAM, 
                    INTMON
                )
            select 
                    'COGA',
                    1,
                    #preservesinglequotes(LvarRecibo)#,
                    
                    'GARANTIA', 
                    'C',
                    #preservesinglequotes(LvarDescripcionPagada)#,
                    '#dateFormat(now(),"YYYYMMDD")#',
                    #LvarAnoAux#,
                    #LvarMesAux#,
                    b.CcuentaGarxPagar,
                    #LvarOcodigo#,
        
                    b.CODGMcodigo,
                    
                    b.CODGMonto,
                    b.CODGTipoCambio,
                    round(b.CODGMonto * b.CODGTipoCambio,2)
            from COEGarantia a
                inner join CODGarantia b
                    on b.COEGid = a.COEGid
                inner join SNegocios c
                     on c.SNid = a.SNid
                inner join COTipoRendicion d
                    on d.COTRid = b.COTRid
            where a.COEGid = #arguments.COEGid#
              and a.COEGEstado = 1 <!--- Vigente --->
              and a.COEGVersionActiva = 1 <!--- Activa --->
        </cfquery>
        
   		<!---<cfquery name="rsINTARC" datasource="#session.DSN#">
        	select * from #INTARC#
        </cfquery>
        <cf_dump var="#rsINTARC#"> --->
        
        <cfquery name="rsGarantia" datasource="#arguments.conexion#">
            select 
                a.COEGReciboGarantia,
                a.COEGFechaRecibe
            from COEGarantia a
                inner join CODGarantia b
                    on b.COEGid = a.COEGid
            where a.COEGid = #arguments.COEGid#
        </cfquery>
        
        
        <!--- Genera el Asiento Contable --->
        <cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
            <cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
            <cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
            <cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
            <cfinvokeargument name="Efecha"			value="#rsGarantia.COEGFechaRecibe#"/>
            <cfinvokeargument name="Oorigen"		value="COGA"/>
            <cfinvokeargument name="Edocbase"		value="#rsGarantia.COEGReciboGarantia#"/>
            <cfinvokeargument name="Ereferencia"	value="Garantía"/>
            <cfinvokeargument name="Edescripcion"	value="Garantía CONAVI: #rsGarantia.COEGReciboGarantia#"/>
            <cfinvokeargument name="Ocodigo"		value="#LvarOcodigo#"/>						
            <cfinvokeargument name="PintaAsiento"	value="false"/>						
        </cfinvoke>
        <!--- <cflog file="GarantiaSql" type="information" date="yes" time="yes" text="ID contable Generado: #LvarIDcontable#" > --->
        <cfif LvarIDcontable eq 0>
            <cftransaction action="rollback"/>
            <cfthrow message="No se pudo generar el asiento contable, IDcontable: #LvarIDcontable#. Proceso cancelado!!!">
            <cfabort>
        </cfif>
        
        <!--- Revisar si el tipo de rendición genera depósito bancario --->
		<cfquery name="rsDeposito" datasource="#arguments.conexion#">
            select  a.CODGid, 
                    a.CODGNumeroGarantia, 
                    a.CBid, 
                    a.BTid, 
                    a.CODGTipoCambio,
                    a.CODGMonto,
                    a.Ccuenta,
					a.CODGFecha
            from CODGarantia a
                inner join COTipoRendicion b
                on b.COTRid = a.COTRid
            where COEGReciboGarantia = #arguments.COEGReciboGarantia#
              and COEGVersion = #arguments.COEGVersion#
              and COTRGenDeposito = 1 <!--- Genera depósito --->
			  <cfif arguments.COEGVersion gt 1>
			  	and not exists(select 1 
					from COHDGarantia hgd 
					where hgd.CODGid = a.CODGid and hgd.COEGid = a.COEGid and hgd.COEGVersion = a.COEGVersion - 1)
			  </cfif>
        </cfquery>
        <cfif isdefined("rsDeposito") and rsDeposito.recordcount gt 0 and len(trim(rsDeposito.CODGid))>
            <cfloop query="rsDeposito">
                <cfinvoke component="sif.Componentes.MovimientosBancarios"
                    method="ALTA"
                    fecha="#LSdateFormat(rsDeposito.CODGFecha,'dd/mm/yyyy')#"
                    tipoSocio="0" 
                    descripcion="Deposito Garantia "
                    referencia="#arguments.COEGReciboGarantia#"
                    documento="#rsDeposito.CODGNumeroGarantia#"
                    cuentaBancaria="#rsDeposito.CBid#"
                    tipoTransaccion="#rsDeposito.BTid#"
                    tipocambio="#rsDeposito.CODGTipoCambio#"
                    total="#rsDeposito.CODGMonto#"		
                    empresa="#session.Ecodigo#"
                    Ocodigo="#LvarOcodigo#"
                    returnvariable="LvarEMid"
                />
                <!--- Esto en Peajes esta raro pues usa un parametro para referenciar el BTid de la tabla BTransacciones la cual es un catlogo lo que implica que el usuario puede definir los valores que quiera. --->
                <!---0 es Bancos ver en pantalla Registro de Movimientos Bancarios --->
                
                <cfset Lvardescripcion = 'Depósito número garantía: '&rsDeposito.CODGNumeroGarantia>
                <cfquery datasource="#arguments.Conexion#">
                    insert into DMovimientos ( EMid, Ecodigo, Ccuenta, DMmonto, DMdescripcion)
                    values ( <cfqueryparam value="#LvarEMid#" cfsqltype="cf_sql_numeric">,
                              <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">,
                              <cfqueryparam value="#rsDeposito.Ccuenta#" cfsqltype="cf_sql_numeric">,
                              <cfqueryparam value="#rsDeposito.CODGMonto#" cfsqltype="cf_sql_money">,
                              '#Lvardescripcion#'
                            )
                </cfquery>
                <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                    <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
                    <cfinvokeargument name="EMid" value="#LvarEMid#"/>				
                    <cfinvokeargument name="usuario" value="#session.usucodigo#"/>			
                    <cfinvokeargument name="debug" value="N"/>
                    <cfinvokeargument name="transaccionActiva" value="true"/>
					 <cfinvokeargument name="IDGarantia" value="#arguments.COEGid#"/> 
                </cfinvoke>
            </cfloop>
        </cfif>
    <cfreturn LvarIDcontable>
</cffunction>

<cffunction name="fnGetParametro" returntype="string" access="private">
    <cfargument name='Ecodigo'		type='numeric' 	required='true'>	 
    <cfargument name='Pcodigo'		type='string' 	required='true'>	 
    <cfargument name='Pdescripcion'	type='string' 	required='true'>
    <cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
    <cfargument name='Pdefault'		type='string' 	required='no' default="°°">

    <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
        select Pvalor
        from Parametros
        where Ecodigo = #Arguments.Ecodigo# 
          and Pcodigo = #Arguments.Pcodigo# 
    </cfquery>
    <cfif rsSQL.recordCount EQ 0>
        <cfif Arguments.Pdefault EQ "°°">
            <cfthrow message="No se ha definido el Parámetro: #Arguments.Pcodigo#, #Arguments.Pdescripcion#">
        <cfelse>
            <cfreturn Arguments.Pdefault>
        </cfif>
    </cfif>
	<cfreturn rsSQL.Pvalor>
</cffunction>

<cffunction name="fnUpdateTotalGarantia" returntype="any" access="private">
	<cfargument name="COEGid" type="numeric" required="yes">
    <cfquery name="rsTCVentaEnc" datasource="#session.DSN#">
        select 
            coalesce((select 
                     TCventa
                     from Htipocambio h
                        where h.Mcodigo = a.Mcodigo
                        and h.Hfecha <= a.COEGFechaRecibe
                        and h.Hfechah >a.COEGFechaRecibe
                      ),1) as TCventa
        from COEGarantia a 
                inner join CODGarantia b
                on b.COEGid = a.COEGid
                where a.COEGid = #arguments.COEGid#
    </cfquery>

	<cfif rsTCVentaEnc.recordcount eq 0>
	    	<cfset LvarTC = 1>  
	<cfelse>
	  	<cfset LvarTC = #rsTCVentaEnc.TCventa#>
	</cfif>
	
	<cfquery datasource="#session.DSN#">
        update COEGarantia
        set COEGMontoTotal = 
            coalesce(
            (
            select 
                sum( 
				 case when b.CODGMcodigo = a.Mcodigo 
			      then b.CODGMonto 
			  else (b.CODGMonto * b.CODGTipoCambio) / #LvarTC# 
			      end )
                from COEGarantia a 
                inner join CODGarantia b
                on b.COEGid = a.COEGid
                where a.COEGid = #arguments.COEGid#
            ) , 0)
        where COEGid = #arguments.COEGid#

    </cfquery>    
    <cfreturn true>
</cffunction>

<!--- Actualiza los datos del registro según el pcodigo --->
<cffunction name="updateDato" returntype="boolean" access="private">					
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfargument name="pvalor" type="string" required="true">
	<cfquery name="updDato" datasource="#Session.DSN#">
		update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn true>
</cffunction>

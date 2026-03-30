<!---
 --->

<cfset LvarCredAbierto = 0>
<cfif isdefined('form.DCreditoAbierto')>
	<cfset LvarCredAbierto = 1>
</cfif>

<cfset LvarPermiteContraValor = 0>
<cfif isdefined('form.PermiteContraValor')>
	<cfset LvarPermiteContraValor = 1>
</cfif>

<cfif isdefined('form.idD')>
	<cfset LvarId = 'idD'>
	<cfset Tab = 7>
<cfelseif isdefined('form.idTC')>
	<cfset Tab = 8>
<cfelseif isdefined('form.idTM')>
	<cfset Tab = 9>
<cfelseif isdefined('form.idTCDet') and isdefined('modo') and modo eq 'CAMBIO' and isdefined('form.SNid')>
	<cfset Tab = 8>
	<cfset LvarId = 'idTCDet'>
	<cfset LvarValor = "#form.idTCDet#">
<cfelseif isdefined('form.idTCDetM') and isdefined('modo') and modo eq 'CAMBIO' and isdefined('form.SNid')>
	<cfset Tab = 9>
	<cfset LvarId = 'idTCDetM'>
	<cfset LvarValor = "#form.idTCDetM#">
</cfif>

<cfset codExt = []>
<cfloop list="#form.FIELDNAMES#" index="key">
	<cfif Find('CODIGOEXT',key)>
		<cfset codExttmp = ListToArray('#replace(key,"CODIGOEXT","","ALL")#,#form[key]#')>
		
		
		<cfif ArrayLen(codExttmp) gte 2>
			<cfquery name="rsTiendaExt" datasource="#session.dsn#">
				select * from CRCTiendaExterna where Codigo = '#codExttmp[2]#' and Ecodigo = #Session.Ecodigo#
			</cfquery>
			<cfif ArrayLen(codExttmp) gt 2>
				<cfset ArrayAppend(codExt,"-#rsTiendaExt.id#:#codExttmp[3]#-")>
			</cfif>
		</cfif>
	</cfif>
</cfloop>

<cfset codExt = ArrayToList(codExt,',')>	

<cfif isdefined("form.btnGenerarTAMDet")>
	<cfif
		isdefined('form.SNCodigo') 		and form.SNCodigo 	neq ''
		and isdefined('form.Tipo') 		and form.Tipo 		neq ''
		and isDefined('form.idTCDetM')	and form.idTCDetM    neq ''
		>
																			
		<cfset LvarZona ="#Mid(form.NTarj,5,2)#">								
																																																		
		<cfquery datasource="#session.dsn#" name="rsSNid">
			select count(1) as cantidad from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
				inner join CRCTarjeta ct
					on ct.CRCCuentasid  = cc.id
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
			and ct.CRCTarjetaAdicionalid = #form.idTCDetM#
		</cfquery>

		<cfif rsSNid.cantidad GT 0>
			<cfthrow message="Ya existe  una cuenta para este socio de negocio.">							
		</cfif>
													 				
		<cfquery datasource="#session.dsn#" name="rsidCta">
			select cc.id as idCta from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'						
		</cfquery>
													
		<cfinvoke component="crc.Componentes.CRCTarjetas" method="CreaTarjeta" returnVariable="result"> 
		    <cfinvokeargument name="Zona" 			value="#LvarZona#">
		    <cfinvokeargument name="Cuentaid" 		value="#rsidCta.idCta#">
		    <cfinvokeargument name="Mayorista" 		value="true">
			<cfinvokeargument name="AdicionalID" 	value="#form.idTCDetM#">
		</cfinvoke>

		<cfset LvarId 		= 'idTCDetM'>
		<cfset LvarValor 	= '#form.idTCDetM#'>
	</cfif>
	<cfset Tab = 9>
<cfelseif isdefined("form.btnGenerarTADet")>	

	<cfif
		isdefined('form.SNCodigo') 		and form.SNCodigo 	neq ''
		and isdefined('form.Tipo') 		and form.Tipo 		neq ''
		and isDefined('form.idTCDet')	and form.idTCDet    neq ''
		>
																			
		<cfset LvarZona ="#Mid(form.NTarj,5,2)#">								
																																																		
		<cfquery datasource="#session.dsn#" name="rsSNid">
			select count(1) as cantidad from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
				inner join CRCTarjeta ct
					on ct.CRCCuentasid  = cc.id
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
			and ct.CRCTarjetaAdicionalid = #form.idTCDet#
		</cfquery>

		<cfif rsSNid.cantidad GT 0>
			<cfthrow message="Ya existe  una cuenta para este socio de negocio.">							
		</cfif>
													 				
		<cfquery datasource="#session.dsn#" name="rsidCta">
			select cc.id as idCta from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'						
		</cfquery>
													
		<cfinvoke component="crc.Componentes.CRCTarjetas" method="CreaTarjeta" returnVariable="result"> 
		    <cfinvokeargument name="Zona" 			value="#LvarZona#">
		    <cfinvokeargument name="Cuentaid" 		value="#rsidCta.idCta#">
		    <cfinvokeargument name="Mayorista" 		value="false">
			<cfinvokeargument name="AdicionalID" 	value="#form.idTCDet#">
		</cfinvoke>

		<cfset LvarId 		= 'idTCDet'>
		<cfset LvarValor 	= '#form.idTCDet#'>
	</cfif>
	<cfset Tab = 8>
<cfelseif isdefined("form.btnGenerarD")>

	<cfif
		isdefined('form.DMontoValeCredito') 	and form.DMontoValeCredito neq ''
		and isdefined('form.DMontoCredito') 	and form.DMontoCredito neq ''
		and isdefined('form.DSeguro') 			and form.DSeguro neq ''
		and isdefined('form.SNCodigo') 			and form.SNCodigo neq ''
		and isdefined('form.Tipo') 				and form.Tipo neq ''
		and isdefined('codExt')
		>

		<cfquery datasource="#session.dsn#" name="rsSNid">
			select count(1) as cantidad from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
		</cfquery>

		<cfif rsSNid.cantidad GT 0>
			<cfthrow message="Ya existe  una cuenta para este socio de negocio.">							
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsSNid">
			select SNid from SNegocios
			where SNcodigo = #form.SNCodigo#
			and Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfinvoke component="crc.Componentes.CRCCuentas" method="CreaCuenta" returnVariable="idCuenta"> 
		    <cfinvokeargument name="snid" value="#rsSNid.SNid#">
		    <cfinvokeargument name="tipo" value="#form.Tipo#">
		    <cfinvokeargument name="monto" value="#form.DMontoCredito#">
		    <cfinvokeargument name="categoriaid" value="#ListToArray(form.NCat,'|')[1]#">	
		</cfinvoke>
		
		
					
		<cfquery datasource="#session.dsn#">
			insert into CRCTCParametros(DMontoValeCredito,DCreditoAbierto,DSeguro,SNegociosSNid,TiendaExterna,CRCCuentasid,PorcSobregiro,PermiteContraValor)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DMontoValeCredito#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCredAbierto#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSeguro#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNid.SNid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#codExt#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#idCuenta#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.PorcSobregiro#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPermiteContraValor#">
				)
		</cfquery>
		<cfquery datasource="#session.dsn#" name="rsId">
			select max(id) as idD from CRCTCParametros
			
		</cfquery>
		<cfset idD 		= "#rsId.idD#">
		<cfset LvarId = 'idD'>
	</cfif>
	<cfset Tab = 7>			
<cfelseif isdefined("form.btnGuardarD")>

	<cfif 
		isdefined('form.DMontoValeCredito') 	and form.DMontoValeCredito neq ''
		and isdefined('form.DSeguro') 			and form.DSeguro 	neq ''
		and isdefined('form.SNCodigo') 			and form.SNCodigo 	neq ''
		and isdefined('form.idD') 				and form.idD 		neq ''
		and isdefined('codExt')>
																							
<!--- 		<cfquery datasource="#session.dsn#" name="rsSNid">
			select SNid from SNegocios
			where SNcodigo = #form.SNCodigo#
		</cfquery> --->
		
		<cfquery datasource="#session.dsn#">
			update CRCTCParametros set 
				DMontoValeCredito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LSParseNumber(form.DMontoValeCredito)#">,
				DCreditoAbierto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCredAbierto#">,
				Dseguro 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSeguro#">,
				TiendaExterna 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#codExt#">,
				PermiteContraValor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPermiteContraValor#">,
				PorcSobregiro	 = <cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(form.PorcSobregiro)#">
				<!---,
				SNegociosSNid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNid.SNid#">
				--->
			where id = #form.idD#
		</cfquery>
		<cfquery name="q_cuenta" datasource="#session.dsn#">
			select CRCCuentasid from CRCTCParametros where id = #form.idD#;
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update CRCCuentas set 
				CRCCategoriaDistid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListToArray(form.NCat,'|')[1]#">
			where id = #q_cuenta.CRCCuentasid#
		</cfquery>

		<!--- <cfquery datasource="#session.dsn#" name="rsId">
			select max(id) as idD from CRCTCParametros
		<!---/*where Ecodigo = #Session.Ecodigo#*/--->
		</cfquery> --->
		<cfset idD 		= "#form.idD#">
		<cfset LvarId = 'idD'>
	<cfelse>
		<cfset idD 		= -1>			
	</cfif>

	<cfset Tab = 7>
<!--- <cfelseif isdefined("form.btnEliminarD")>
	<cfif isdefined('form.idD') 		and form.idD neq ''>
		<cfquery datasource="#session.dsn#">
			delete CRCTCParametros
			where id 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idD#">
		</cfquery>
	</cfif>
	<cfset Tab = 7> --->
<!--- <cfelseif isdefined("form.btnActualizarD")>		
	<cfif 
		isdefined('form.DMontoValeCredito') and form.DMontoValeCredito neq ''
		and isdefined('form.DSeguro') 			and form.DSeguro neq ''
		and isdefined('form.idD') 				and form.idD neq ''>

		<cfquery datasource="#session.dsn#">
			update CRCTCParametros set
				DMontoValeCredito 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DMontoValeCredito#">,
				DCreditoAbierto 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCredAbierto#">,
				DSeguro 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Dseguro#">
			where id 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idD#">
		</cfquery>
		<cfset idD="#form.idD#">
		<cfset LvarId = 'idD'>
	</cfif>
	<cfset Tab = 7> --->
<cfelseif isdefined("form.btnGenerarTC")>

	<cfif
		isdefined('form.TCLimiteCredito') 		and form.TCLimiteCredito 	neq ''
		and isdefined('form.TCSeguro') 			and form.TCSeguro 			neq ''
		and isdefined('form.Tipo') 				and form.Tipo 				neq ''
		>

		<cfquery datasource="#session.dsn#" name="rsSNid">
			select count(1) as cantidad from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
		</cfquery>

		<cfif rsSNid.cantidad GT 0>
			<cfthrow message="Ya existe  una cuenta para este socio de negocio.">							
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsSNid">
			select SNid from SNegocios
			where SNcodigo = #form.SNCodigo#
			and Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfinvoke component="crc.Componentes.CRCCuentas" method="CreaCuenta" returnVariable="idCuenta"> 
		    <cfinvokeargument name="snid" value="#rsSNid.SNid#">
		    <cfinvokeargument name="tipo" value="#form.Tipo#">
		    <cfinvokeargument name="monto" value="#form.TCLimiteCredito#">
		    <cfinvokeargument name="categoriaid" value="1">	
		</cfinvoke>
		<cfquery datasource="#session.dsn#" name="rsSNid">
			select SNid from SNegocios
			where SNcodigo = #form.SNCodigo#
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into CRCTCParametros(TCLimiteCredito,TCSeguro,SNegociosSNid,CRCCuentasid)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCLimiteCredito#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCSeguro#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNid.SNid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#idCuenta#">
			)
		</cfquery>
		<cfquery datasource="#session.dsn#" name="rsId">
			select max(id) as idTC from CRCTCParametros
		</cfquery>
		<cfset idTC="#rsId.idTC#">
		<cfset LvarId = 'idTC'>
	</cfif>

	<cfset Tab = 8>

<cfelseif isdefined("form.btnGenerarTar")>

		<cfif
		isdefined('form.TCLimiteCredito') 		and form.TCLimiteCredito 	neq ''
		and isdefined('form.TCSeguro') 			and form.TCSeguro 			neq ''
		and isdefined('form.Tipo') 				and form.Tipo 				neq ''
		>
				
		<cfquery datasource="#session.dsn#" name="rsSNid">
			select count(1) as cantidad from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
				inner join CRCTarjeta ct
					on ct.CRCCuentasid  = cc.id
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
			and ct.CRCTarjetaAdicionalid is null
		</cfquery>

		<cfif rsSNid.cantidad GT 0>
			<cfthrow message="Ya existe  una cuenta para este socio de negocio.">							
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsidCta">
			select cc.id as idCta from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
		</cfquery>

		<cfquery datasource="#session.dsn#" name="q_Zonas">
			select codigo from CRCZonas
			where id = #form.IdZonas#
		</cfquery>

		<cfinvoke component="crc.Componentes.CRCTarjetas" method="CreaTarjeta" returnVariable="result"> 
		    <cfinvokeargument name="Zona" 			value="#q_Zonas.codigo#">
		    <cfinvokeargument name="Cuentaid" 		value="#rsidCta.idCta#">
		<!--- <cfinvokeargument name="Mayorista" 		value="false"> --->
		<!---  <cfinvokeargument name="AdicionalID" 	value="0">	 --->
		</cfinvoke>
										
	</cfif>
	<cfset Tab = 8>
<cfelseif isdefined("form.btnGuardarTC")>

	<cfif 
		isdefined('form.TCSeguro') 			and form.TCSeguro neq ''
		<!--- and isdefined('form.SNCodigo') 		and form.SNCodigo neq ''--->
		and isdefined('form.idTC') 			and form.idTC 	  neq ''>

<!--- 		<cfquery datasource="#session.dsn#" name="rsSNid">
			select SNid from SNegocios
			where SNcodigo = #form.SNCodigo#
			and Ecodigo = #Session.Ecodigo#
		</cfquery>					
				 --->
		<cfquery datasource="#session.dsn#">
			update  CRCTCParametros set  
				TCSeguro 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCSeguro#">
			where id = #form.idTC#
		</cfquery>
		<!--- <cfquery datasource="#session.dsn#" name="rsId">
			select max(id) as idTC from CRCTCParametros
			<!---/*where Ecodigo = #Session.Ecodigo#*/--->
		</cfquery>
		 --->
		 <cfset idTC="#form.idTC#">
		<cfset LvarId = 'idTC'>
	</cfif>
	<cfset Tab = 8>

<cfelseif isdefined("form.btnGenerarTarTM")>

	<cfif
		isdefined('form.TMLimiteCredito') 		and form.TMLimiteCredito 	neq ''
		and isdefined('form.TMDiasGracia') 	and form.TMDiasGracia 		neq ''
		and isdefined('form.TMSeguro') 			and form.TMSeguro 			neq ''
		and isdefined('form.SNCodigo') 			and form.SNCodigo 			neq ''
		and isdefined('form.Tipo') 				and form.Tipo 				neq ''>
				
		<cfquery datasource="#session.dsn#" name="rsSNid">
			select count(1) as cantidad from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
				inner join CRCTarjeta ct
					on ct.CRCCuentasid  = cc.id
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
		</cfquery>

		<cfif rsSNid.cantidad GT 0>
			<cfthrow message="Ya existe  una cuenta para este socio de negocio.">							
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsidCta">
			select cc.id as idCta from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
		</cfquery>

		<cfquery datasource="#session.dsn#" name="q_Zonas">
			select codigo from CRCZonas
			where id = #form.IdZonas#
		</cfquery>


		<cfinvoke component="crc.Componentes.CRCTarjetas" method="CreaTarjeta" returnVariable="result"> 
		    <cfinvokeargument name="Zona" 			value="#q_Zonas.codigo#">
		    <cfinvokeargument name="Cuentaid" 		value="#rsidCta.idCta#">
			<cfinvokeargument name="Mayorista" 		value="true">
		<!---  <cfinvokeargument name="AdicionalID" 	value="0">	 --->
		</cfinvoke>		
	</cfif>
	<cfset Tab = 9>
	<cfset LvarId = 'IdTM'>
<cfelseif isdefined("form.btnGenerarTM")>

	<cfif 
		isdefined('form.TMLimiteCredito') 		and form.TMLimiteCredito 	neq ''
		and isdefined('form.TMDiasGracia') 		and form.TMDiasGracia 		neq ''
		and isdefined('form.TMSeguro') 			and form.TMSeguro 			neq ''
		and isdefined('form.SNCodigo') 			and form.SNCodigo 			neq ''
		and isdefined('form.Tipo') 				and form.Tipo 				neq ''>

		<cfquery datasource="#session.dsn#" name="rsSNid">
			select count(1) as cantidad from CRCCuentas cc
				inner join SNegocios sn 
					on cc.SNegociosSNid = sn.SNid
			where sn.SNcodigo = #form.SNCodigo#
			and cc.Ecodigo = #Session.Ecodigo#
			and cc.Tipo = '#form.Tipo#'
		</cfquery>
		<cfif rsSNid.cantidad GT 0>
			<cfthrow message="Ya existe  una cuenta para este socio de negocio.">							
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsSNid">
			select SNid from SNegocios
			where SNcodigo = #form.SNCodigo#
			and Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfinvoke component="crc.Componentes.CRCCuentas" method="CreaCuenta" returnVariable="idCuenta"> 
		    <cfinvokeargument name="snid" 			value="#rsSNid.SNid#">
		    <cfinvokeargument name="tipo" 			value="#form.Tipo#">
		    <cfinvokeargument name="monto" 			value="#form.TMLimiteCredito#">
		    <cfinvokeargument name="categoriaid" 	value="1">	
		</cfinvoke>
									
		<cfquery datasource="#session.dsn#">
			insert into CRCTCParametros(TMLimiteCredito,TMDiasGracia,TMSeguro,SNegociosSNid,CRCCuentasid)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TMLimiteCredito#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TMDiasGracia#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TMSeguro#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNid.SNid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#idCuenta#">
			)
		</cfquery>
		<cfquery datasource="#session.dsn#" name="rsId">
			select max(id) as idTM from CRCTCParametros
		</cfquery>
		<cfset IdTM = "#rsId.idTM#">
		<cfset LvarId = 'IdTM'>
	</cfif>
	<cfset Tab = 9>
<cfelseif isdefined("form.btnGuardarTM")>

	<cfif 
		isdefined('form.TMDiasGracia') 		and form.TMDiasGracia 		neq ''
		and isdefined('form.TMSeguro') 			and form.TMSeguro 			neq ''
		and isdefined('form.idTM') 				and form.idTM 				neq ''>
		
		<cfquery datasource="#session.dsn#">
			update CRCTCParametros  set 
				TMDiasGracia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TMDiasGracia#">,
				TMSeguro 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TMSeguro#">
			where id = #form.idTM#
		</cfquery>
		<cfset IdTM = "#form.idTM#">
		<cfset LvarId = 'IdTM'>
	<cfelse>
		<cfset IdTM = -1>
	</cfif>	
		<cfset Tab = 9>			
<cfelseif isdefined("form.btnGuardarTAM")>

	<cfif isdefined('form.TCcodPostalM') 			and form.TCcodPostalM neq ''
		and isdefined('form.TCpaisM') 				and form.TCpaisM neq ''
		and isdefined('form.TCestadoM') 				and form.TCestadoM neq ''
		and isdefined('form.TCciudadM') 				and form.TCciudadM neq ''
		and isdefined('form.TelefonoM') 				and form.TelefonoM neq ''
		and isdefined('form.TCdireccion1M') 			and form.TCdireccion1M neq ''
		and isdefined('form.SNnombre1M') 			and form.SNnombre1M neq ''
		and isdefined('form.SNid') 					and form.SNid neq ''>


		<cfquery datasource="#session.dsn#" name="rsTarAdi">
			select count(1) as conta from CRCTarjetaAdicional where SNid = #form.SNid#
		</cfquery>


		<!--componente de parametros--> 
		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
 		 
 		<cfset resultT = "">
		<!-- Dia corte tarjeta credito-->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo='30200502',conexion=#session.dsn#,ecodigo=#session.Ecodigo#,
			descripcion="Cantidad de tarjetas adicionales permitidas")> 
		<cfif paramInfo.valor eq "" >
			<cfset resultT = "No existe o no se ha configurado el parámetro que define la cantidad de tarjetas adicionales permitidas">
		</cfif>	


		<cfif rsTarAdi.conta GTe paramInfo.valor>
			<cfset resultT = "No es posible agregar tarjetas adicionales, se excede el máximo permitido">	
									
		<cfelseif resultT eq "">

			<cfquery datasource="#session.dsn#">
				insert into CRCTarjetaAdicional(
					SNid,
					SNnombre,
					TCdireccion1,
					Telefono,
					TCciudad,
					TCestado,
					TCcodPostal,
					TCpais,
					TCfechaNacimiento,
					Ecodigo,
					MontoMaximo,
					esMayorista)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnombre1M#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCdireccion1M#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TelefonoM#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCciudadM#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCestadoM#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodPostalM#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCpaisM#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#form.TCfechaNacimientoM#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.montoMaxCorteM#">,
					1
					)
			</cfquery>

		</cfif>
		<cfquery datasource="#session.dsn#" name="rsId">
			select max(id) as idTC from CRCTarjetaAdicional
		</cfquery>
		<cfset idTCDet = "#rsId.idTC#">
		<cfset LvarId = 'idTCDet'>
	</cfif>
	<cfset Tab = 9>

<cfelseif isdefined("form.btnActualizarTAM")>

	<cfif isdefined('form.TCfechaNacimientoM') 		and form.TCfechaNacimientoM neq ''
		and isdefined('form.TCcodPostalM') 			and form.TCcodPostalM neq ''
		and isdefined('form.TCpaisM') 				and form.TCpaisM neq ''
		and isdefined('form.TCestadoM') 					and form.TCestadoM neq ''
		and isdefined('form.TCciudadM') 					and form.TCciudadM neq ''
		and isdefined('form.TelefonoM') 					and form.TelefonoM neq ''
		and isdefined('form.TCdireccion1M') 				and form.TCdireccion1M neq ''
		and isdefined('form.SNnombre1M') 				and form.SNnombre1M neq ''
		and isdefined('form.SNid') 						and form.SNid neq ''
		and isdefined('form.idTCDetM') 					and form.idTCDetM neq ''>

		<cfquery datasource="#session.dsn#">
			update CRCTarjetaAdicional set
				SNnombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnombre1M#">,
				TCdireccion1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCdireccion1M#">,
				Telefono 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TelefonoM#">,
				TCciudad 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCciudadM#">,
				TCestado 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCestadoM#">,
				TCcodPostal 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodPostalM#">,
				TCpais 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCpaisM#">,
				TCfechaNacimiento 	= <cfqueryparam cfsqltype="cf_sql_date"    value="#form.TCfechaNacimientoM#">,
				Ecodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				MontoMaximo			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.montoMaxCorteM#">
			where id 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idTCDetM#">
		</cfquery>
		<cfset idTCDetM = "#form.idTCDetM#">
		<cfset LvarId = 'idTCDetM'>
	</cfif>
	<cfset Tab = 9>
<cfelseif isdefined("form.btnEliminarTAM")>

	<cfif isdefined('form.idTCDetM') and form.idTCDetM neq ''>
		<cfquery datasource="#session.dsn#">
			delete CRCTarjetaAdicional
			where id 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idTCDetM#">
		</cfquery>	
	</cfif>
	<cfset Tab = 9>
<cfelseif isdefined("form.btnNuevoTAM")>
	<cfset Tab = 9>


<cfelseif isdefined("form.btnGuardarTA")>

	<cfif isdefined('form.TCfechaNacimiento') 		and form.TCfechaNacimiento neq ''
		and isdefined('form.TCcodPostal') 			and form.TCcodPostal neq ''
		and isdefined('form.TCpais') 				and form.TCpais neq ''
		and isdefined('form.TCestado') 				and form.TCestado neq ''
		and isdefined('form.TCciudad') 				and form.TCciudad neq ''
		and isdefined('form.Telefono') 				and form.Telefono neq ''
		and isdefined('form.TCdireccion1') 			and form.TCdireccion1 neq ''
		and isdefined('form.SNnombre1') 			and form.SNnombre1 neq ''
		and isdefined('form.SNid') 					and form.SNid neq ''>

		<cfquery datasource="#session.dsn#" name="rsTarAdi">
			select count(1) as conta from CRCTarjetaAdicional where SNid = #form.SNid#
		</cfquery>


		<!--componente de parametros--> 
		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
 		 
 		<cfset resultT = "">
		<!-- Dia corte tarjeta credito-->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo='30200502',conexion=#session.dsn#,ecodigo=#session.Ecodigo#,
			descripcion="Cantidad de tarjetas adicionales permitidas")> 
		<cfif paramInfo.valor eq "" >
			<cfset resultT = "No existe o no se ha configurado el parámetro que define la cantidad de tarjetas adicionales permitidas">
		</cfif>	


		<cfif rsTarAdi.conta GTe paramInfo.valor>
			<cfset resultT = "No es posible agregar tarjetas adicionales, se excede el máximo permitido">	
									
		<cfelseif resultT eq "">

			<cfquery datasource="#session.dsn#">
				insert into CRCTarjetaAdicional(
					SNid,
					SNnombre,
					TCdireccion1,
					Telefono,
					TCciudad,
					TCestado,
					TCcodPostal,
					TCpais,
					TCfechaNacimiento,
					Ecodigo,
					MontoMaximo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnombre1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCdireccion1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Telefono#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCciudad#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCestado#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodPostal#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCpais#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#form.TCfechaNacimiento#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.montoMaxCorte#">
					)
			</cfquery>

		</cfif>
		<cfquery datasource="#session.dsn#" name="rsId">
			select max(id) as idTC from CRCTarjetaAdicional
		</cfquery>
		<cfset idTCDet = "#rsId.idTC#">
		<cfset LvarId = 'idTCDet'>
	</cfif>
	<cfset Tab = 8>
<cfelseif isdefined("form.btnActualizarTA")>

	<cfif isdefined('form.TCfechaNacimiento') 		and form.TCfechaNacimiento neq ''
		and isdefined('form.TCcodPostal') 			and form.TCcodPostal neq ''
		and isdefined('form.TCpais') 				and form.TCpais neq ''
		and isdefined('form.TCestado') 					and form.TCestado neq ''
		and isdefined('form.TCciudad') 					and form.TCciudad neq ''
		and isdefined('form.Telefono') 					and form.Telefono neq ''
		and isdefined('form.TCdireccion1') 				and form.TCdireccion1 neq ''
		and isdefined('form.SNnombre1') 				and form.SNnombre1 neq ''
		and isdefined('form.SNid') 						and form.SNid neq ''
		and isdefined('form.idTCDet') 					and form.idTCDet neq ''>

		<cfquery datasource="#session.dsn#">
			update CRCTarjetaAdicional set
				SNnombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnombre1#">,
				TCdireccion1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCdireccion1#">,
				Telefono 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Telefono#">,
				TCciudad 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCciudad#">,
				TCestado 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCestado#">,
				TCcodPostal 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodPostal#">,
				TCpais 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCpais#">,
				TCfechaNacimiento 	= <cfqueryparam cfsqltype="cf_sql_date"    value="#form.TCfechaNacimiento#">,
				Ecodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				MontoMaximo			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.montoMaxCorte#">
			where id 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idTCDet#">
		</cfquery>
		<cfset idTCDet = "#form.idTCDet#">
		<cfset LvarId = 'idTCDet'>
	</cfif>
	<cfset Tab = 8>
<cfelseif isdefined("form.btnEliminarTA")>

	<cfif isdefined('form.idTCDet') and form.idTCDet neq ''>
		<cfquery datasource="#session.dsn#">
			delete CRCTarjetaAdicional
			where id 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idTCDet#">
		</cfquery>	
	</cfif>
	<cfset Tab = 8>
<cfelseif isdefined("form.btnNuevoTA")>
	<cfset Tab = 8>


<cfelseif isdefined("form.BTNKILLMASTERTC")>
	<cftransaction>
		<cfset inci = false>
		<cfif isDefined('form.chkKillMasterTC')><cfset inci = true></cfif>
		<cfset newTarjetaID = killTC(NumTC="#form.NUMTC#", incidencia="#inci#")>
	</cftransaction>
	<cfset Tab = 8>

<cfelseif isdefined("form.btnKillMayoristaTC")>
	<cftransaction>
		<cfset inci = false>
		<cfif isDefined('form.chkKillMayoristaTC')><cfset inci = true></cfif>
		<cfset newTarjetaID = killTC(NumTC="#form.NUMTC#", Mayorista="true", incidencia="#inci#")>
	</cftransaction>
	<cfset Tab = 9>

<cfelseif isdefined("form.BTNKILLADDTC")>
	<cftransaction>
		<cfset inci = false>
		<cfif isDefined('form.chkKillAddTC')><cfset inci = true></cfif>
		<cfset newTarjetaID = killTC( NumTC = "#form.NUMTC#", AdditionalID = "#form.idTCDet#", incidencia="#inci#")>
	</cftransaction>
	<cfset Tab = 8>
<cfelseif isdefined("form.BTNKILLADDTM")>
	<cftransaction>
		<cfset inci = false>
		<cfif isDefined('form.chkKillAddTM')><cfset inci = true></cfif>
		<cfset newTarjetaID = killTC( NumTC = "#form.NUMTC#", AdditionalID = "#form.idTCDetM#", Mayorista="true", incidencia="#inci#")>
	</cftransaction>
	<cfset Tab = 8>
</cfif>

<cfif isdefined('idD')>
	<cfset LvarValor = "#idD#">
<cfelseif isdefined('idTM')>
	<cfset LvarValor = "#idTM#">
<cfelseif isdefined('idTC')>
	<cfset LvarValor = "#idTC#">
<cfelseif isdefined('idTCDet')>
	<cfset LvarValor = "#idTCDet#">
<cfelseif isdefined('idTCDetM')>
	<cfset LvarValor = "#idTCDetM#">
</cfif>

<cfif isdefined('btnEliminarTA') || isdefined('btnEliminarTAM')>
	<cfset LvarValor = "-1">	
</cfif>
<cfset LvarSNcodigo = -1>
<cfif isdefined('form.SNcodigo')>
	<cfset LvarSNcodigo = #form.SNcodigo#>
<cfelse>
	<cfquery name="rsSocioN" datasource="#Session.DSN#">
		select SNcodigo from SNegocios where SNid = #form.SNid#
	</cfquery>
	<cfset LvarSNcodigo = rsSocioN.SNcodigo>		
</cfif>

<cfoutput>
	<form action="Socios.cfm?id=1" method="post" name="sql">
		<input name="SNcodigo" type="hidden" value="#LvarSNcodigo#">
		<input name="tab" type="hidden" value="#Tab#">
		<cfif isdefined('LvarId')>
			<input name="#LvarId#" type="hidden" value="#LvarValor#">	
		</cfif>
			<input type="hidden" name="resultT" id="resultT" value="<cfif isdefined("resultT")><cfoutput>#resultT#</cfoutput></cfif>">
	</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cffunction  name="killTC">
	<cfargument  name="NumTC" required="true">
	<cfargument  name="AdditionalID" required="false" default ="-1">
	<cfargument  name="Mayorista" required="false" default ="false">
	<cfargument  name="incidencia" required="false" default ="false">
	
	<cfset codZona = Mid("#arguments.NUMTC#",5,2)>

	<cfquery name="q_oldTC" datasource="#session.dsn#">
		select id,CRCCuentasid from CRCTarjeta where Numero = '#arguments.NUMTC#';
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update CRCTarjeta set 
				Estado = 'X' 
			, MotivoCancelado = Replace(MotivoCancelado,'Cancelada:','Anulada:')
			, updatedat = CURRENT_TIMESTAMP
			, deletedat = CURRENT_TIMESTAMP
			, usumodif = #session.usucodigo#
			, oldCRCCuentasid = CRCCuentasid
			, CRCCuentasid = null
		where id = #q_oldTC.id#
	</cfquery>

	<cfinvoke component="crc.Componentes.CRCTarjetas" method="CreaTarjeta" returnVariable="newTarjetaID"> 
		<cfinvokeargument name="Zona" 			value="#codZona#">
		<cfinvokeargument name="Cuentaid" 		value="#q_oldTC.CRCCuentasid#">
		<cfinvokeargument name="Mayorista" 		value="#arguments.Mayorista#"> 
		<cfinvokeargument name="AdicionalID" 	value="#arguments.AdditionalID#">
	</cfinvoke>
	
	<cfif arguments.incidencia>
		<cfquery name="q_newTC" datasource="#session.dsn#">
			select id,numero,CRCCuentasid from CRCTarjeta where id = '#newTarjetaID#';
		</cfquery>
		<cfquery name="q_tipoTrans" datasource="#session.dsn#">
			select id from CRCTipoTransaccion where ecodigo = '#session.ecodigo#' and codigo = 'GT';
		</cfquery>
		<cfif q_tipoTrans.recordCount eq 0><cfthrow message="No se ha definido una transaccion (GT - Gasto por reposición de Tarjeta)"></cfif>

		<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
		<cfset param = objParams.getParametroInfo('30100503')>
		<cfif param.codigo eq ''><cfthrow message="El parametro (30100503 - Monto por reposición de Tarjeta) no esta definido"></cfif>
		<cfif param.valor eq ''><cfthrow message="El parametro (30100503 - Monto por reposición de Tarjeta) no tiene valor"></cfif>

		<cfset componentPath = "crc.Componentes.incidencias.CRCIncidencia">
		<cfset objIncidencias = createObject("component","#componentPath#")>
		<cfset inciID = objIncidencias.crearIncidencia(
			CuentaID = "#q_oldTC.CRCCuentasid#",
			Mensaje = "Cargo por reposición de Tarjeta: #q_newTC.numero#",
			CRCTipoTransaccionid = "#q_tipoTrans.id#",
			Monto = "#param.valor#"
		)>
		<cfset objIncidencias.AplicarIncidencia(inciID)>
	</cfif>

	<cfreturn newTarjetaID>

</cffunction>
	<cfcomponent output="no">
<!--- 
	Creado por: Oscar Bonilla
		Fecha: 4-NOV-2009
		Motivo: Emisión de Transferencias de Fondos
				Impresión de Instrucciones de Pago y
				Generación de Transferencias Electrónicas
--->
	<cffunction name="Verificar" output="no" access="public" returntype="void">
		<cfargument name="TESTLid"		type="numeric">

		<cfquery name="rsTESTL" datasource="#session.dsn#">
			select 	tl.TESTMPtipo, 
					tl.TESTLdatos,
					tg.TESTGcodigoTipo,
					tg.TESTGtipoCtas,
					tg.TESTGcfc,
					tg.TESTGid
			  from TEStransferenciasL tl
				inner join TESmedioPago mp
					 on mp.TESid		= tl.TESid
					and mp.CBid			= tl.CBid
					and mp.TESMPcodigo	= tl.TESMPcodigo
				left join TEStransferenciaG tg
					on tg.TESTGid = mp.TESTGid
			 where tl.TESid		= #session.Tesoreria.TESid#
			   and tl.TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.TESTLid#">
		</cfquery>	
		<cfif rsTESTL.TESTMPtipo NEQ 3> <!--- Verifica Tipo de Lote --->
			<cfthrow message="Se esta tratando de Generar un Lote que no es Lote de Transferencia Electrónica de Fondos (TRE)">
		<cfelseif rsTESTL.TESTGcfc EQ "">
			<cfthrow message="No se ha definido el componente de generación del Archivo TEF">
		<cfelseif not fileExists("#getDirectoryFromPath(getCurrentTemplatePath())##rsTESTL.TESTGcfc#.cfc")>	
			<cfthrow message="No existe el fuente del componente de generación del Archivo TEF: #rsTESTL.TESTGcfc#.cfc">
		</cfif>
		<cfset LvarObj = createObject("component",rsTESTL.TESTGcfc)>
		<cfif not isdefined("LvarObj.Verificar")>
			<cfthrow message="No existe función 'Verificar' en el componente de generación del Archivo TEF: #rsTESTL.TESTGcfc#">
		<cfelseif not isdefined("LvarObj.Generar")>
			<cfthrow message="No existe función 'Generar' en el componente de generación del Archivo TEF: #rsTESTL.TESTGcfc#">
		</cfif>

		<cf_dbfunction name="OP_concat" returnvariable="_cat">
		<cfquery name="rsTESTD" datasource="#session.dsn#">
			select 	op.TESOPnumero, 
					case
						when mp.TESid <> tl.TESid OR mp.CBid <> tl.CBid OR mp.TESMPcodigo <> tl.TESMPcodigo then
							<!--- Otro medio de pago --->
							'Otro Medio de Pago: '  #_cat# rtrim(mp.TESMPcodigo)
						when ip.Miso4217 <> op.Miso4217Pago then
							<!--- No es Misma Moneda --->
							'Cta.Destino de otra moneda'
						when mp.TESTGcodigoTipo <> ip.TESTPcodigoTipo then
							<!--- No es Mismo TESTGcodigoTipo --->
							'Cta.Destino Tipo ' #_cat# 
								case ip.TESTPcodigoTipo
									when 0 then 'Nacional'
									when 1 then 'ABA'
									when 2 then 'SWIFT'
									when 3 then 'IBAN'
									else 'Especial'
								end
						when mp.TESTGcodigoTipo = 0 then
							case
								when ip.Bid is null then
									<!--- No hay banco --->
									'Cta.Destino sin Banco'
								when mp.TESTGtipoCtas = 0 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0) then
									'Cta.Destino propia de otro banco'
								when mp.TESTGtipoCtas = 1 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid) then
									'Cta.Destino no es propia del banco de pago'
								when mp.TESTGtipoCtas = 2 and NOT (ip.TESTPtipoCtaPropia = 0) then
									'Cta.Destino no es interbancaria'
								when mp.TESTGtipoCtas = 2 and NOT (ip.Bid <> cb.Bid) then
									'Cta.Destino no es de otros bancos'
								when mp.TESTGtipoCtas = 3 and NOT (ip.TESTPtipoCtaPropia = 0) then
									'Cta.Destino no es interbancaria'
								when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 1 and ip.Bid <> cb.Bid) then
									'Cuenta Destino es propia de otro banco'
								when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 0 and ip.Bid = cb.Bid) then
									'Cuenta Destino no es propia del banco de pago'
							end
					end as error
			  from TEStransferenciasD td
				inner join TEStransferenciasL tl 
					on tl.TESTLid = td.TESTLid 
			  	inner join TESordenPago op 
					on op.TESOPid = td.TESOPid 
				inner join TESmedioPago mp 
						inner join CuentasBancos cb on cb.CBid = mp.CBid 
					on mp.TESid = op.TESid and mp.CBid = op.CBidPago and mp.TESMPcodigo = op.TESMPcodigo 
				left join TEStransferenciaP ip 
					on ip.TESTPid = op.TESTPid 
			 where td.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">	
			   and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
               and 
					case
						when mp.TESid <> tl.TESid OR mp.CBid <> tl.CBid OR mp.TESMPcodigo <> tl.TESMPcodigo then
							<!--- Otro medio de pago --->
							1
						when ip.Miso4217 <> op.Miso4217Pago then
							<!--- No es Misma Moneda --->
							2
						when mp.TESTGcodigoTipo <> ip.TESTPcodigoTipo then
							<!--- No es Mismo TESTGcodigoTipo --->
							3
						when mp.TESTGcodigoTipo = 0 then
							case
								when ip.Bid is null then
									4
								when mp.TESTGtipoCtas = 0 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0) then
									5
								when mp.TESTGtipoCtas = 1 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid) then
									6
								when mp.TESTGtipoCtas = 2 and NOT (ip.TESTPtipoCtaPropia = 0) then
									7
								when mp.TESTGtipoCtas = 2 and NOT (ip.Bid <> cb.Bid) then
									8
								when mp.TESTGtipoCtas = 3 and NOT (ip.TESTPtipoCtaPropia = 0) then
									9
								when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 1 and ip.Bid <> cb.Bid) then
									10
								when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 0 and ip.Bid = cb.Bid) then
									11
							end
					end > 0 
			order by td.TESTDid
		</cfquery>
		<cfif rsTESTD.recordCount NEQ 0>
			<cfthrow message="Orden de Pago #rsTESTD.TESOPnumero#: #rsTESTD.Error#">
		</cfif>
		
		<cfset LvarObj.Verificar(arguments.TESTLid, rsTESTL.TESTLdatos, rsTESTL.TESTGid)>
	</cffunction>
		
	<cffunction name="Generar" output="no" access="public" returntype="struct">
		<cfargument name="TESTLid" type="numeric">
		
		<cftry>
			<cfset Verificar(Arguments.TESTLid)>
			<cfset LvarResult = LvarObj.Generar (url.TESTLid)>
			<cfset LvarResult.msg = "OK">
		<cfcatch type="any">		
			<cfset LvarError = "">
			<cfif isdefined("cfcatch.TagContext")>
				<cfset LvarError = cfcatch.TagContext[1].Template>
				<cfset LvarError = REReplace(mid(LvarError,find(expandPath("/"),LvarError),100),"[/\\]","/ ","ALL") & ": " & cfcatch.TagContext[1].Line>
			</cfif>
			<cfset LvarResult = structNew()>
			<cfset LvarResult.msg = "#cfcatch.Message# #cfcatch.Detail# #LvarError#">
		</cfcatch>
		</cftry>
		<cfreturn LvarResult>
	</cffunction>
</cfcomponent>

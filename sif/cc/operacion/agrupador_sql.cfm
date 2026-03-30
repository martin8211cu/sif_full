<!---Agregar Parametros--->
<cfif isdefined ('form.AgregaP')>
	<cfquery name="inParam" datasource="#session.dsn#">
		insert into ConsecutivoCxC(
				Ecodigo,
				CCxCinicio,
				CCxCconsecutivo,
				CCxCceros,
				CCxCpref,
				BMUsucodigo,
				BMfecha
				)
		values(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.inicio#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.inicio#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ceros#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pref#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				)
	</cfquery>	
	<cflocation url="agrupador.cfm">
</cfif>

<!---Regresar Parametros--->
<cfif isdefined ('form.irListaP')>
	<cflocation url="../MenuCC.cfm">
</cfif>

<!---Reporte--->
<cfif isdefined ('form.reporte')>
	<cflocation url="agrupador_Reporte.cfm?EAid=#form.EAid#">
</cfif>

<!---Regresar--->
<cfif isdefined ('form.irLista')>
	<cflocation url="agrupador.cfm">
</cfif>

<!---Agregar--->
<cfif isdefined ('form.agrega')>
	<cftransaction>
		<cfquery name="inSQL" datasource="#session.dsn#">
			insert into EAgrupador (
			EAdescrip,
			EAfecha,
			EAfechaVen,
			CxCGid,
			EAestado,
			Ecodigo,
			BMUsucodigo)
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EAdescrip#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(now(),'DD/MM/YYYY')#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.EAfechaVen)#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.config#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="En Proceso">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">				
			)
				<cf_dbidentity1 datasource="#session.DSN#" name="inSQL">
			</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="inSQL" returnvariable="LvarEAid">
		</cftransaction>
		<cfset #form.EAid#=#LvarEAid#>
	<cflocation url="agrupador.cfm?EAid=#LvarEAid#">
</cfif>

<!---Nuevo--->
<cfif isdefined ('form.nuevo')>
	<cflocation url="agrupador.cfm?Nuevo=1">
</cfif>

<!---Modificar--->
<cfif isdefined ('form.modifica')>
	<cfquery name="modSQL" datasource="#session.dsn#">
		update EAgrupador set
		EAdescrip= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EAdescrip#">,
		EAfechaVen=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.EAfechaVen)#">,
		CxCGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.config#">
		where EAid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EAid#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
	<cflocation url="agrupador.cfm?EAid=#form.EAid#">
</cfif>

<!---Generar--->
<cfif isdefined ('form.generar')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select * from EAgrupador 
		where 
		EAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAid#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
	
	<cfquery name="rsConfig" datasource="#session.dsn#">
		select Ocodigo,CCTcodigoD from CxCGeneracion 
		where 
		CxCGid= #rsSQL.CxCGid#
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="inGen" datasource="#session.dsn#">
		insert into DAgrupador(
				EAid,
				McodigoOri,
				McodigoD,
				Ecodigo,
				CCTcodigo,
				DdocumentoId,
				Aplica,
				DAmonedaP,
				DAmontoD,
				DAmontoC,
				Ddocumento,			
				BMUsucodigo			
							)
		(select 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.EAid#">,
				a.Mcodigo,
				a.Mcodigo,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				b.CCTcodigo,
				b.DdocumentoId,
				0,
				a.Mcodigo,
				b.Dsaldo,
				b.Dsaldo,
				b.Ddocumento,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				
				 from Documentos b
	
				inner join SNegocios f
						 on b.Ecodigo=f.Ecodigo 
						and b.SNcodigo = f.SNcodigo

				inner join CContables c
					on c.Ccuenta = b.Ccuenta
					
				inner join Monedas a
					on a.Mcodigo = b.Mcodigo 

				inner join CCTransacciones d
					 on d.Ecodigo = b.Ecodigo 
					and d.CCTcodigo = b.CCTcodigo 
					and d.CCTtipo = 'D'
					and coalesce( d.CCTpago, 0) < 1
					and coalesce( d.CCTvencim, 0) > -1
						
				where 
					b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
					and b.Dsaldo > 0 
					and not exists (
					select 1 
						from DPagos h
						where h.Ecodigo = b.Ecodigo
						  and h.Doc_CCTcodigo = b.CCTcodigo
						  and h.Ddocumento = b.Ddocumento
					)
					and not exists (
					select 1
						from DAgrupador g
							where g.Ecodigo=b.Ecodigo
							and g.CCTcodigo=b.CCTcodigo
							and g.Ddocumento=b.Ddocumento
							and g.DdocumentoId=b.DdocumentoId
					)
	
					and b.Ocodigo=#rsConfig.Ocodigo#
					and b.CCTcodigo='#rsConfig.CCTcodigoD#'
					and b.DEdiasVencimiento=0
					and b.Dvencimiento <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSQL.EAfechaVen#">	
		)
	</cfquery>
		<cflocation url="agrupador.cfm?EAid=#form.EAid#&Genera=1">
</cfif>

<!---Eliminar--->
<cfif isdefined ('form.Baja')>

	<cfquery name="rs" datasource="#session.dsn#">
		select count(1) as cantidad from DPagos p
		where EAid=#form.EAid# 
	</cfquery>
	
	<cfquery name="rs1" datasource="#session.dsn#">
		select count(1) as cantidad from BMovimientos d
		where EAid=#form.EAid# 
	</cfquery>

	<cfif rs.cantidad gt 0 or rs1.cantidad gt 0>
		<cf_errorCode	code = "50170" msg = "No se puede Eliminar el Documento porque tiene Facturas asociadas que ya fueron Aplicadas">
	
	<cfelseif rs.cantidad eq 0 and rs1.cantidad eq 0>
		<cfquery name="elD" datasource="#session.dsn#">
			delete from DAgrupador where EAid=#form.EAid#
		</cfquery>
		
		<cfquery name="elE" datasource="#session.dsn#">
			delete from EAgrupador where EAid=#form.EAid#
		</cfquery>		
		
		<cflocation url="agrupador.cfm">
	</cfif>
</cfif>

<!---Aplicar--->
<cfif isdefined ('form.Aplicar')>

	<cfif not isdefined('form.CHKAPLICA')>
		<cflocation url="agrupador.cfm?EAid=#form.EAid#&ErrorS=ErrorS">
	</cfif>

	<cfquery name="rsEA" datasource="#session.dsn#">
		select 
		EAid, 
		CxCGid, 
		EAdescrip, 
		EAfecha, 
		EAfechaVen, 
		EAestado, 
		Ecodigo, 
		BMUsucodigo
		from EAgrupador
		where EAid=#form.EAid#
	</cfquery>

	<cfquery name="rsCxCG" datasource="#session.dsn#">
		select 
		g.CxCGid, 
		g.CxCGdescrip, 
		g.CxCGcod, 
		g.Ecodigo, 
		g.BMUsucodigo, 
		g.SNCEid, 
		g.SNCDid, 
		g.CCTcodigoD, 
		g.ID, 
		g.Ocodigo, 
		g.CCTcodigoR, 
		cg.Ccuenta
		from CxCGeneracion g
		inner join CuentasCxC cc
		on cc.ID = g.ID
		
		inner join CFinanciera cf
		on cf.CFcuenta = cc.CFcuenta
		
		inner join CContables cg
		on cg.Ccuenta = cf.Ccuenta
		where g.CxCGid = #rsEA.CxCGid#
	</cfquery>

	<cfquery name="rsEnc" datasource="#session.dsn#">
		select s.SNcodigo,d.McodigoD
		from DAgrupador d 
		inner join Documentos s 
		on d.DdocumentoId=s.DdocumentoId 
		where d.EAid=#form.EAid#
		and d.Aplica=1
		group by s.SNcodigo,d.McodigoD
	</cfquery>

	<cfset Error=''>

	<cfloop query="rsEnc" >		
		<cflock scope="application" timeout="30">					
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 
				CCxCconsecutivo,
				CCxCpref 
				from ConsecutivoCxC 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>				
			<cfif isdefined("application.GeneraRecibos") and application.GeneraRecibos LT rsSQL.CCxCconsecutivo>
				<cfset application.GeneraRecibos = rsSQL.CCxCconsecutivo >					
			<cfelse>
				<cfset application.GeneraRecibos = rsSQL.CCxCconsecutivo >	
			</cfif>			
		</cflock>
		
		<cfquery name="TCsug" datasource="#session.dsn#">
			select tc.Mcodigo, tc.TCcompra, tc.TCventa
			from Htipocambio tc
			where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
			and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
			and Mcodigo=#rsEnc.McodigoD#
		</cfquery>
		
		<cfquery name="rsPara" datasource="#session.dsn#">
			select min(CCxCceros) as Ceros from ConsecutivoCxC where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		
		<cfset ceros= rsPara.Ceros>			
		
		<cftransaction>
			<cfset LvarPvalorParam      = application.GeneraRecibos>
			<cfset LvarPvalorParamNuevo = LvarPvalorParam + 1>
			<cfset LvarPvalorParamInsert = repeatstring('0',ceros) & LvarPvalorParamNuevo >
			
			
			<cfquery datasource="#session.dsn#">
				insert into Pagos(
				Ecodigo,
				CCTcodigo,
				Pcodigo,
				Ocodigo,
				Mcodigo,
				Ccuenta,
				SNcodigo,
				Ptipocambio,
				Ptotal,
				Pfecha,
				Pusuario
				)
				values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				'#rsCxCG.CCTcodigoR#',
				'#rsSQL.CCxCpref# - #LvarPvalorParamInsert#',
				#rsCxCG.Ocodigo#,
				#rsEnc.McodigoD#,
				#rsCxCG.Ccuenta#,
				#rsEnc.SNcodigo#,
				<cfif len(trim(TCsug.TCcompra)) gt 0>
				<cfqueryparam cfsqltype="cf_sql_float" value="#TCsug.TCcompra#">, 
				<cfelse>
				1.00,
				</cfif>
				0,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">
				)
			</cfquery>
			
			<cfloop list="#form.CHKAPLICA#" delimiters="," index="valor">
				<cfset lvarValor = valor> 
				<cfquery name="valida" datasource="#session.dsn#">
					select count(1) as cantidad from DAgrupador where DdocumentoId=#lvarValor# and Aplica > 0 and EAid=#form.EAid#
				</cfquery>
				
				<cfif valida.cantidad gt 0>
					<cfquery name="rs" datasource="#session.dsn#">
						select 
						d.CCTcodigo, 
						d.Ddocumento,  
						d.Mcodigo, 
						a.DAmontoC, 
						a.DAmontoD, 
						a.DAretencion
						from Documentos d
						inner join DAgrupador a
						on a.DdocumentoId = d.DdocumentoId
						where d.DdocumentoId = #lvarValor#
						and d.SNcodigo     = #rsEnc.SNcodigo#
						and a.McodigoD     = #rsEnc.McodigoD#
					</cfquery>
		
					<cfif rs.recordCount gt 0>						
						<!---Calcular el tipo de cambio-Factor de Conversion--->
						<cfquery name="rsSQLM" datasource="#Session.DSN#">
							select Mcodigo
							from Empresas
							where Ecodigo = #session.Ecodigo#
						</cfquery>
						<cfset LvarMcodigoLocal = rsSQLM.Mcodigo>
						<cfset LvarMcodigoPago = rsEnc.McodigoD>
						<cfset LvarMcodigoDoc  = rs.Mcodigo>
					
							<cfif LvarMcodigoPago EQ LvarMcodigoDoc>
								<cfset FC = 1>
							<cfelse>
								<cfif LvarMcodigoPago    EQ LvarMcodigoLocal>
									<cfset Form.Ptipocambio = 1>
								</cfif>
								<cfset LvarTCpago = #TCsug.TCcompra#>
									<cfif LvarMcodigoDoc EQ LvarMcodigoLocal>
										<cfset LvarTCdoc = 1>
									<cfelse>
										<cfquery name="rsTC" datasource="#Session.DSN#">
											select tc.TCcompra
											from Htipocambio tc
											where tc.Mcodigo = #LvarMcodigoDoc#
											and tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
											and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
											and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
										</cfquery>
												<cfif rsTC.TCcompra gt 0>
													<cfset LvarTCdoc = rsTC.TCcompra>
												<cfelse>
													<cfset LvarTCdoc = 1>
												</cfif>
									</cfif>
								<cfset FC = LvarTCpago / LvarTCdoc>
							</cfif>
														
						<!---Inserta a DPagos--->
						<cfquery name="inDPagos" datasource="#session.dsn#">
							insert into DPagos(
								Ecodigo, 
								CCTcodigo, 
								Pcodigo, 
								Doc_CCTcodigo,
								Ddocumento,
								Mcodigo, 
								Ccuenta,
								DPmonto,
								DPtipocambio, 
								DPmontodoc,
								DPtotal, 
								DPmontoretdoc, 
								PPnumero,
								EAid) 
							values ( 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								'#rsCxCG.CCTcodigoR#', 
								'#rsSQL.CCxCpref# - #LvarPvalorParamInsert#',
								'#rs.CCTcodigo#', 
								'#rs.Ddocumento#', 
								#rs.Mcodigo#,
								#rsCxCG.Ccuenta#,
								#rs.DAmontoC#,
								#FC#,
								<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DAmontoC#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DAmontoC#">, 
								<cfif len(trim(rs.DAretencion)) gt 0>
								<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DAretencion#">,
								<cfelse>
								0.00,
								</cfif>
								0,
								#form.EAid#
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
			
			
			<cfquery name="rsVerif" datasource="#session.dsn#">
				select * from DPagos where Pcodigo='#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'
			</cfquery>
			
			<cfif rsVerif.recordcount eq 0>
				<cfquery datasource="#session.dsn#">
					update Pagos 
					set Ptotal = 0 where Ecodigo = #session.Ecodigo#
					and Pcodigo='#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.dsn#">
					update Pagos 
					set Ptotal = (
					select sum(DPtotal) 
					from DPagos d
					where d.Ecodigo   = Pagos.Ecodigo
					and d.Pcodigo   = Pagos.Pcodigo
					and d.CCTcodigo = Pagos.CCTcodigo
					) 
					where Ecodigo = #session.Ecodigo#
					and Pcodigo='#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'
				</cfquery>
			</cfif>
			
			<cfquery  datasource="#session.dsn#">
				update ConsecutivoCxC
				set CCxCconsecutivo = #LvarPvalorParamNuevo#
				where Ecodigo = #session.Ecodigo#
			</cfquery>
		
		</cftransaction>
		

		<!--- ejecuta el proc.--->
		<cfset hubo_error = false >
		<!---<cftry>
		<cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status"
			Ecodigo 	= "#session.Ecodigo#"
			CCTcodigo	= "#rsCxCG.CCTcodigoR#"
			Pcodigo		= "#rsSQL.CCxCpref# - #LvarPvalorParamInsert#"
			usuario  	= "#session.usulogin#"
			EAid 		= "#form.EAid#"
			debug		= "false"/>		
		<cfcatch type="any"><cfdump var="#cfcatch.Message#"><cfset hubo_error = true ><cfset Error=Error & '#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'&','></cfcatch></cftry>	
	--->
	</cfloop>
		<cfquery name="rss" datasource="#session.dsn#">
			select * from DPagos where Pcodigo='#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'
		</cfquery>
		
	<cfif hubo_error eq false>
		<cfquery name="rsDelDA" datasource="#session.dsn#">
			delete from DAgrupador where EAid=#form.EAid#
		</cfquery>			
	</cfif>

	<cfquery name="coEnc" datasource="#session.dsn#">
		select count (1) as cantidad 
		from DAgrupador where EAid=#EAid#
	</cfquery>

	<cfquery name="coDet" datasource="#session.dsn#">
		select count (1) as cantidadD 
		from DAgrupador 
		where EAid=#EAid# and Aplica=1
	</cfquery>

		<cfif coEnc.cantidad eq coDet.cantidadD>
			<cfquery name="upEst" datasource="#session.dsn#">
				update EAgrupador set EAestado='Aplicado' where EAid=#EAid#
			</cfquery>
		</cfif>		
		<cflocation url="agrupador.cfm?EAid=#form.EAid#&Error=#Error#">
</cfif>


<!---borrar una linea del detalle--->
<cfif isdefined ('form.btnBorrarSel') and #form.btnBorrarSel# gt 0 >
	<cfquery name="elSQL" datasource="#session.dsn#">
		delete from DAgrupador where DdocumentoId=#form.btnBorrarSel# and EAid=#form.EAid#
	</cfquery>
		<cflocation url="agrupador.cfm?EAid=#form.EAid#&Genera=1">
</cfif>


<!---AplicarLista--->
<cfif isdefined ('form.AplicarLista')>

	<cfif not isdefined ('form.chk')>
		<cf_errorCode	code = "50172" msg = "No escogio ninguna opción, debe escoger al menos una">
		<cflocation url="agrupador.cfm">
	</cfif>


	<cfloop list="#form.chk#" delimiters="," index="bb">
		<cfset EAid=#listgetat(bb, 1, ',')#>	
		
			<cfquery name="rsDeta" datasource="#session.dsn#">
				select count (1) as cantidad from DAgrupador where EAid=#EAid# and Aplica=1
			</cfquery>			
			
			<cfif rsDeta.cantidad eq 0>
				<cf_errorCode	code = "50173" msg = "No se puede procesar un registro que no tenga documentos">
			</cfif>
	
	</cfloop>


		<cfloop list="#form.chk#" delimiters="," index="bb">
			<cfset EAid=#listgetat(bb, 1, ',')#>
			
				<cfquery name="rsEA" datasource="#session.dsn#">
					select 
						EAid, 
						CxCGid, 
						EAdescrip, 
						EAfecha, 
						EAfechaVen, 
						EAestado, 
						Ecodigo, 
						BMUsucodigo
					from EAgrupador
					where EAid=#EAid#
				</cfquery>
			
				<cfquery name="rsCxCG" datasource="#session.dsn#">
					select 
						g.CxCGid, 
						g.CxCGdescrip, 
						g.CxCGcod, 
						g.Ecodigo, 
						g.BMUsucodigo, 
						g.SNCEid, 
						g.SNCDid, 
						g.CCTcodigoD, 
						g.ID, 
						g.Ocodigo, 
						g.CCTcodigoR, 
						cg.Ccuenta
					from CxCGeneracion g
						inner join CuentasCxC cc
						on cc.ID = g.ID
						
						inner join CFinanciera cf
						on cf.CFcuenta = cc.CFcuenta
						
						inner join CContables cg
						on cg.Ccuenta = cf.Ccuenta
					where g.CxCGid = #rsEA.CxCGid#
				</cfquery>
			
				<cfquery name="rsEnc" datasource="#session.dsn#">
					select s.SNcodigo,d.McodigoD
						from DAgrupador d 
						inner join Documentos s 
						on d.DdocumentoId=s.DdocumentoId 
					where d.EAid=#EAid#
					and d.Aplica>0
					group by s.SNcodigo,d.McodigoD
				</cfquery>
					
				<cfset ErrorL=''>
			
				
						<cfloop query="rsEnc">
							<cflock scope="application" timeout="30">					
								<cfquery name="rsSQL" datasource="#session.dsn#">
									select 
									CCxCconsecutivo,
									CCxCpref 
									from ConsecutivoCxC 
									where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
								</cfquery>
												
								<cfif isdefined("application.GeneraRecibos") and application.GeneraRecibos LT rsSQL.CCxCconsecutivo>
									<cfset application.GeneraRecibos = rsSQL.CCxCconsecutivo >					
								<cfelse>
									<cfset application.GeneraRecibos= rsSQL.CCxCconsecutivo>
								</cfif>			
							</cflock>
							
							
							<cfquery name="TCsug" datasource="#session.dsn#">
								select tc.Mcodigo, tc.TCcompra, tc.TCventa
								from Htipocambio tc
								where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
									and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
									and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
									and Mcodigo=#rsEnc.McodigoD#
							</cfquery>
						
						<cfquery name="rsPara" datasource="#session.dsn#">
							select min(CCxCceros) as Ceros from ConsecutivoCxC where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
						
						<cfset ceros= rsPara.Ceros>	
			
						<cftransaction>

							<cfset LvarPvalorParam      = application.GeneraRecibos>
							<cfset LvarPvalorParamNuevo = LvarPvalorParam + 1>
							<cfset LvarPvalorParamInsert = repeatstring('0',ceros) & LvarPvalorParamNuevo >
							<cfset LvarPvalorParam      = application.GeneraRecibos>
						
							
								<cfquery datasource="#session.dsn#">
									insert into Pagos(
										Ecodigo,
										CCTcodigo,
										Pcodigo,
										Ocodigo,
										Mcodigo,
										Ccuenta,
										SNcodigo,
										Ptipocambio,
										Ptotal,
										Pfecha,
										Pusuario
										)
									values(
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
										'#rsCxCG.CCTcodigoR#',
										'#rsSQL.CCxCpref# - #LvarPvalorParamInsert#',
										#rsCxCG.Ocodigo#,
										#rsEnc.McodigoD#,
										#rsCxCG.Ccuenta#,
										#rsEnc.SNcodigo#,
										<cfif len(trim(TCsug.TCcompra)) gt 0>
											<cfqueryparam cfsqltype="cf_sql_float" value="#TCsug.TCcompra#">, 
										<cfelse>
											1.00,
										</cfif>
										0,
										<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">
										)
								</cfquery>			
												
							
								<cfquery name="rs" datasource="#session.dsn#">
									select * from Documentos d
										inner join DAgrupador a
										on d.DdocumentoId=a.DdocumentoId
										and a.McodigoD=#rsEnc.McodigoD#
									where EAid=#EAid#
									and a.Aplica=1
									and d.SNcodigo=#rsEnc.SNcodigo#
								</cfquery>
				
										<cfloop query="rs">
											<cfif rs.recordCount gt 0>
												<!---Calcular el tipo de cambio-Factor de Conversion--->
											<cfquery name="rsSQLM" datasource="#Session.DSN#">
												select Mcodigo
												from Empresas
												where Ecodigo = #session.Ecodigo#
											</cfquery>
												<cfset LvarMcodigoLocal = rsSQLM.Mcodigo>
												<cfset LvarMcodigoPago = rsEnc.McodigoD>
												<cfset LvarMcodigoDoc  = rs.Mcodigo>
												
											<cfif LvarMcodigoPago EQ LvarMcodigoDoc>
												<cfset FC = 1>
											<cfelse>
												<cfif LvarMcodigoPago    EQ LvarMcodigoLocal>
													<cfset Form.Ptipocambio = 1>
												</cfif>
												<cfset LvarTCpago = #TCsug.TCcompra#>
												<cfif LvarMcodigoDoc     EQ LvarMcodigoLocal>
													<cfset LvarTCdoc = 1>
												<cfelse>
													<cfquery name="rsTC" datasource="#Session.DSN#">
													select tc.TCcompra
													from Htipocambio tc
													where tc.Mcodigo = #LvarMcodigoDoc#
													and tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
													and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
													and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
													</cfquery>
														<cfif rsTC.TCcompra gt 0>
															<cfset LvarTCdoc = rsTC.TCcompra>
														<cfelse>
															<cfset LvarTCdoc = 1>
														</cfif>
												</cfif>
											<cfset FC = LvarTCpago / LvarTCdoc>
										</cfif>
													<!---Inserta a DPagos--->
													<cfquery name="inDPagos" datasource="#session.dsn#">
														insert into DPagos(
															Ecodigo, 
															CCTcodigo, 
															Pcodigo, 
															Doc_CCTcodigo,
															Ddocumento,
															Mcodigo, 
															Ccuenta,
															DPmonto,
															DPtipocambio, 
															DPmontodoc,
															DPtotal, 
															DPmontoretdoc, 
															PPnumero,
															EAid) 
														values ( 
															<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
															'#rsCxCG.CCTcodigoR#', 
															'#rsSQL.CCxCpref# - #LvarPvalorParamInsert#',
															'#rs.CCTcodigo#', 
															'#rs.Ddocumento#', 
															#rs.Mcodigo#,
															#rsCxCG.Ccuenta#,
															#rs.DAmontoC#,
															#FC#,
															<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DAmontoC#">, 
															<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DAmontoC#">, 
															<cfif len(trim(rs.DAretencion)) gt 0>
																<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DAretencion#">,
															<cfelse>
																0.00,
															</cfif>
															0,
															#EAid#
														)
													</cfquery>
												</cfif>
										</cfloop>
				
						<cfquery name="rsVerif" datasource="#session.dsn#">
						select * from DPagos where Pcodigo='#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'
						</cfquery>
				
						<cfif rsVerif.recordcount eq 0>
							<cfquery datasource="#session.dsn#">
								update Pagos 
										set Ptotal = 0 where Ecodigo = #session.Ecodigo#
									  and Pcodigo='#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'
							  </cfquery>
						<cfelse>
								<cfquery datasource="#session.dsn#">
									update Pagos 
										set Ptotal =(
									select sum(DPtotal) 
									from DPagos d
									where d.Ecodigo   = Pagos.Ecodigo
									  and d.Pcodigo   = Pagos.Pcodigo
									  and d.CCTcodigo = Pagos.CCTcodigo
									  ) 
							where Ecodigo = #session.Ecodigo#
							  and Pcodigo='#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'
								</cfquery>
						 </cfif>
						 
						<cfquery  datasource="#session.dsn#">
							update ConsecutivoCxC
							set CCxCconsecutivo = #LvarPvalorParamNuevo#
							where Ecodigo = #session.Ecodigo#
						</cfquery>
					</cftransaction>
					
				<!--- ejecuta el proc.--->
			<cfset hubo_error = false >
	
			<!---<cftry>
			<cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" 
				method="PosteoPagosCxC" returnvariable="status"
				Ecodigo 	= "#session.Ecodigo#"
				CCTcodigo	= "#rsCxCG.CCTcodigoR#"
				Pcodigo		= "#rsSQL.CCxCpref# - #LvarPvalorParamInsert#"
				usuario  	= "#session.usulogin#"
				EAid 		= "#EAid#"
				debug		= "false"/>		
			<cfcatch type="any"><cfdump var="#cfcatch.Message#"><cfset hubo_error = true ><cfset ErrorL=ErrorL & '#rsSQL.CCxCpref# - #LvarPvalorParamInsert#'&','></cfcatch></cftry>	
				--->
			
		</cfloop>
</cfloop>
			<cfif hubo_error eq false>
				 <cfquery name="rsDelDA" datasource="#session.dsn#">
					 delete from DAgrupador where EAid=#EAid#
				 </cfquery>			
			</cfif>
        <cfquery name="coEnc" datasource="#session.dsn#">
            select count (1) as cantidad 
            from DAgrupador where EAid=#EAid#
        </cfquery>
        
        <cfquery name="coDet" datasource="#session.dsn#">
            select count (1) as cantidadD 
			from DAgrupador 
            where EAid=#EAid# and Aplica=1
        </cfquery>
        
        <cfif coEnc.cantidad eq coDet.cantidadD>
            <cfquery name="upEst" datasource="#session.dsn#">
                update EAgrupador set EAestado='Aplicado' where EAid=#EAid#
            </cfquery>
        </cfif>		
		
				<cflocation url="agrupador.cfm?EAid=#form.EAid#&ErrorL=#ErrorL#">

</cfif>

<!---Borrar--->
<cfif isdefined('form.BorrarLista')>
	<cfif not isdefined ('form.chk')>
		<cf_errorCode	code = "50172" msg = "No escogio ninguna opción, debe escoger al menos una">
		<cflocation url="agrupador.cfm">
	</cfif>
		<cfloop list="#form.chk#" delimiters="," index="bb">
			<cfset EAid=#listgetat(bb, 1, ',')#>
			
			<cfquery name="rsDeta" datasource="#session.dsn#">
				select count (1) as cantidad from DPagos where EAid=#EAid#
			</cfquery>
			
			<cfquery name="rsDeta1" datasource="#session.dsn#">
				select count (1) as cantidad from BMovimientos where EAid=#EAid# 
			</cfquery>
			
			<cfoutput>
				<cfif rsDeta.cantidad gt 0 or rsDeta1.cantidad gt 0>
					<cf_errorCode	code = "50174" msg = "No se puede eliminar un registro ya que tiene Documentos Generados Asociados">
				</cfif>
			</cfoutput>
		</cfloop>

	<cfif rsDeta.cantidad eq 0 and rsDeta1.cantidad eq 0>
		<cfloop list="#form.chk#" delimiters="," index="bb">
			<cfset EAid=#listgetat(bb, 1, ',')#>		
			
				<cfquery name="elD" datasource="#session.dsn#">
					delete from DAgrupador where EAid=#EAid#
				</cfquery>
				
				<cfquery name="elE" datasource="#session.dsn#">
					delete from EAgrupador where EAid=#EAid#
				</cfquery>						
		</cfloop>
		<cflocation url="agrupador.cfm">
	</cfif>
</cfif>




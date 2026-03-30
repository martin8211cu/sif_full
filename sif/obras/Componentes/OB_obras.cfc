<cfcomponent>
	<cffunction name="sbLiquidar_Obra">
		<cfargument name="OBOid" 	type="numeric" required="yes">
		
        <cfinclude template="../../Utiles/sifConcat.cfm">
        
		<cfquery name="rsOBO" datasource="#session.dsn#">
			select 
				   o.OBOestado
				 , o.OBOLidDefault
				 , o.OBOnumLiquidacion
				 , o.OBOcodigo
				 , o.PCDcatidObr
				 , o.OBOtipoValorLiq
				 , p.OBPcodigo
				 , tp.OBTPtipoCtaLiquidacion
				 , IDcontableLiquidacion
				 , cm.OBCliquidacion
				 , o.OBOdescripcion
			  from OBobra o
				inner join OBproyecto p
					inner join OBtipoProyecto tp
						inner join OBctasMayor cm
						   on cm.Ecodigo	= #session.Ecodigo#
						  and cm.Cmayor		= tp.Cmayor
						on tp.OBTPid = p.OBTPid
				   on p.OBPid = o.OBPid
			 where o.OBOid = #Arguments.OBOid#
		</cfquery>
		
		<cfset LvarObra = "#trim(rsOBO.OBPcodigo)#-#trim(rsOBO.OBOcodigo)#">
		<cfset LvarNumLiquidacion = rsOBO.OBOnumLiquidacion + 1>
	
		<cfif rsOBO.OBTPtipoCtaLiquidacion EQ 99 or rsOBO.OBCliquidacion NEQ "1">
			<!--- 
				Liquidación externa
				Pedir Asiento de Liquidación y poner obra como liquidada
				NO SE HACE ASIENTO CONTABLE
			--->
			<cfif url.OP EQ "L">
				<cfif isdefined("url.ver")>
					<cfinclude template="../liquidacion/Poliza_form.cfm">
				<cfelse>
					<cfinclude template="../liquidacion/Poliza_list.cfm">
				</cfif>
				<cfreturn>
			<cfelseif not isdefined("url.IDcontable") OR not isnumeric(url.IDcontable)>
				<cf_errorCode	code = "51418" msg = "Falta indicar el Asiento Contable">
			</cfif>

			<cftransaction>
				<cfquery datasource="#session.dsn#">
					update PCDCatalogo
					   set PCDactivo = 0
					 where PCDcatid = #rsOBO.PCDcatidObr#
				</cfquery>
				
				<cfquery datasource="#session.dsn#">
					update OBobra
					   set OBOestado 				= '3'
						 , OBOfechaLiquidado		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						 , UsucodigoLiquidado		= #session.Usucodigo#
						 , OBOnumLiquidacion 		= #LvarNumLiquidacion#
						 , IDcontableLiquidacion 	= #url.IDcontable#
					 where OBOid = #Arguments.OBOid#
				</cfquery>
			</cftransaction>
			<script>
				alert ("La obra ha quedado registrada como Liquidada");
				location.href="OBobra.cfm";
			</script>
			<cfreturn>
		</cfif>
		
		<cfquery name="rsACTIVOS_TOTs" datasource="#session.dsn#">
			select 	count(1) as cantidad,
				<cfif rsOBO.OBTPtipoCtaLiquidacion EQ "2">
					max(CFformatoLiquidacion) as CFformatoLiquidacionUnico,
				</cfif>
				<cfif rsOBO.OBOtipoValorLiq EQ "P">
					sum(OBOLporcentaje)
				<cfelse>
					sum(OBOLmonto)
				</cfif>
					as Total
			  from OBobraLiquidacion
			 where OBOid = #Arguments.OBOid#
		</cfquery>
		<cfif rsOBO.OBOestado NEQ "2">
			<cf_errorCode	code = "51419" msg = "La obra no ha sido cerrada">
		<cfelseif rsACTIVOS_TOTs.cantidad EQ 0>
			<cf_errorCode	code = "51420" msg = "No se han definido Activos a Generar en los Parámetros de Liquidación">
		<cfelseif rsOBO.OBOtipoValorLiq EQ "P" AND rsACTIVOS_TOTs.Total NEQ 1>
			<cf_errorCode	code = "51421"
							msg  = "El total de porcentajes '@errorDat_1@%' no es 100%"
							errorDat_1="#rsOBO.Total*100#"
			>
		</cfif>
	
		<cfinvoke component="sif.obras.Componentes.OB_obras"
				method 			= "sbIniciar_LIQUIDACION"
				returnVariable	= "LvarResultado"
	
				OBOid			= "#Arguments.OBOid#"
		>
		<cfset LvarPeriodos 		= LvarResultado.Periodos>
		<cfset LIQUIDACION			= LvarResultado.Liquidacion>
		<cfset rsLIQUIDACION_TOTs	= LvarResultado.rsLiquidacion_Tots>
	
		<cfif rsLIQUIDACION_TOTs.cantidad EQ 0>
			<cf_errorCode	code = "51422" msg = "La obra no ha tenido Movimientos">
		<cfelseif rsLIQUIDACION_TOTs.MontoL LTE 0>
			<cf_errorCode	code = "51423"
							msg  = "El monto total de la obra @errorDat_1@ no puede ser liquidado"
							errorDat_1="#numberFormat(rsOBO.OBOtipoValorLiq,",9.00")#"
			>
		<cfelseif rsOBO.OBOtipoValorLiq EQ "M" AND rsLIQUIDACION_TOTs.MontoL NEQ rsACTIVOS_TOTs.Total>
			<cf_errorCode	code = "51424"
							msg  = "El total de montos asignados a Activos @errorDat_1@ no corresponde al monto total a liquidar de la obra @errorDat_2@"
							errorDat_1="#numberFormat(rsACTIVOS_TOTs.Total,",9.00")#"
							errorDat_2="#numberFormat(rsLIQUIDACION_TOTs.MontoL,",9.00")#"
			>
		</cfif>
	
		<!--- Se calcula el procentaje a asignar a cada activo correspondiente al monto absoluto asignado --->
		<cfif rsOBO.OBOtipoValorLiq EQ "M">
			<cfquery datasource="#session.dsn#">
				update OBobraLiquidacion
				   set OBOLporcentaje = OBOLmonto / #rsLIQUIDACION_TOTs.MontoL#
				 where OBOid = #Arguments.OBOid#
			</cfquery>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select OBOLmonto as Monto_asignado, OBOLporcentaje as Porcentaje_calculado, OBOLporcentaje * #rsLIQUIDACION_TOTs.MontoL# as Total_calculado, OBOLmonto - OBOLporcentaje * #rsLIQUIDACION_TOTs.MontoL# as Variacion
				  from OBobraLiquidacion
				 where OBOid = #Arguments.OBOid#
				   and OBOLmonto <> OBOLporcentaje * #rsLIQUIDACION_TOTs.MontoL#
			</cfquery>
			<cfif rsSQL.recordCount NEQ 0>
				CALCULOS DEL PORCENTAJE A ASIGNAR A ACTIVOS QUE NO COINCIDEN CON EL MONTO ABSOLUTO ASIGNADO. MONTO TOTAL A LIQUIDAR = #numberFormat(#rsLIQUIDACION_TOTs.MontoL#,",9.00")
				<cf_dump var="#rsSQL#">
			</cfif>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update OBobraLiquidacion
				   set OBOLmonto =  OBOLporcentaje * #rsLIQUIDACION_TOTs.MontoL#
				 where OBOid = #Arguments.OBOid#
			</cfquery>
		</cfif>
	
		<cfif rsOBO.OBTPtipoCtaLiquidacion EQ 0>
			<!--- 
				Liquidación reversando las Cuentas de la Obra
				Actualizar Tipo a L=Liquidacion
			--->
			<cfquery datasource="#session.dsn#">
				update #LIQUIDACION# 
				   set TipoOA = 'L'
			</cfquery>
		<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 1>
			<!--- 
				Liquidación sustituyendo valores fijos a las Cuentas de la Obra
				Sustituir los niveles por los valores fijos
				Actualizar Tipo a L=Liquidacion
			--->
			<cfquery name="rsNiveles" datasource="#session.dsn#">
				select 	ld.OBTPLnivel		as Niv
					 ,	ld.OBTPLvalor		as Val
					 ,	nm.PCNlongitud		as Lon
					 , 	len(m.PCEMformato) 	as Tot
					 ,	coalesce(
							(
								select sum(nm2.PCNlongitud)
								  from PCNivelMascara nm2
								 where nm2.PCEMid	= tp.PCEMid
								   and nm2.PCNid	< ld.OBTPLnivel
							), 0) as Acum
				  from OBobra o
					inner join OBproyecto p
						inner join OBtipoProyecto tp
							inner join OBTPliquidacionDet ld
							   on ld.OBTPid = tp.OBTPid
							inner join PCNivelMascara nm
								inner join PCEMascaras m
								   on m.PCEMid	= nm.PCEMid
							   on nm.PCEMid	= tp.PCEMid
							  and nm.PCNid	= ld.OBTPLnivel
						   on tp.OBTPid = p.OBTPid
					   on p.OBPid = o.OBPid
				 where o.OBOid = #Arguments.OBOid#
			</cfquery>
			<cfset LvarIni = 1>
			<cfset LvarUpdate = "">
            
			<cfloop query="rsNiveles">
				<cfset LvarIniNiv 	= (rsNiveles.Niv - 1) + rsNiveles.Acum + 6>
				<cfset LvarUpdate 	= "#LvarUpdate#substring(CFformato,#LvarIni#,#LvarIniNiv-1#) #_Cat# '#rsNiveles.Val#' #_Cat# ">
				<cfset LvarIni		= LvarIniNiv + rsNiveles.Lon>
			</cfloop>
			<cfif LvarIni LTE rsNiveles.Tot>
				<cfset LvarUpdate = "#LvarUpdate#substring(CFformato,#LvarIni#,#rsNiveles.Tot-LvarIni+1#)">
			<cfelse>
				<cfset LvarUpdate = mid(LvarUpdate,1,len(LvarUpdate)-4)>
			</cfif>
			<cfquery datasource="#session.dsn#">
				update #LIQUIDACION# 
				   set TipoOA = 'L'
					 , CFcuenta = null
					 , Ccuenta = null
					 , CFformato = #preserveSingleQuotes(LvarUpdate)#
			</cfquery>
		<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 2>
			<!--- 
				Liquidación a una única Cuenta de Liquidacion
				Inclur el total de montos con la cuenta única de Liquidación por oficina y moneda
			--->
			<cfif rsACTIVOS_TOTs.CFformatoLiquidacionUnico EQ "">
				<cf_errorCode	code = "51425" msg = "No se ha definido la Cuenta de Liquidación Única para la Obra">
			</cfif>
			<cfquery datasource="#session.dsn#">
				insert into #LIQUIDACION# 
					( 
						TipoOA, TipoDC, CFformato, Ocodigo, Mcodigo, 
						MontoO, 
						MontoL
					)
				select	'L', 'C', '#rsACTIVOS_TOTs.CFformatoLiquidacionUnico#', LIQ.Ocodigo, LIQ.Mcodigo, 
						sum(LIQ.MontoO), 
						sum(LIQ.MontoL)
				  from #LIQUIDACION# LIQ
				 group by LIQ.Ocodigo, LIQ.Mcodigo
			</cfquery>
		<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 3>
			<!--- 
				Liquidación proporcional a una Cuenta de Liquidacion por Activo
				Inclur proporcionalmente el total de montos a la cuenta de Liquidación del Activo por oficina y moneda
			--->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select	count(1) as cantidad
				  from OBobraLiquidacion ol
				 where ol.OBOid = #Arguments.OBOid#
				   and ol.CFformatoLiquidacion is null
			</cfquery>
			<cfif rsSQL.cantidad GT 0>
				<cf_errorCode	code = "51426" msg = "Falta definir Cuentas de Liquidación en los Activos de la Obra">
			</cfif>
	
			<cfquery datasource="#session.dsn#">
				insert into #LIQUIDACION# 
					( 
						TipoOA, TipoDC, CFformato, CFcuenta, Ccuenta, Ocodigo, Mcodigo, 
						MontoO, 
						MontoL
					)
				select	'L', 'C', ol.CFformatoLiquidacion, null, null, LIQ.Ocodigo, LIQ.Mcodigo, 
						round(sum(LIQ.MontoO * ol.OBOLporcentaje),2), 
						round(sum(LIQ.MontoL * ol.OBOLporcentaje),2)
				  from OBobraLiquidacion ol, #LIQUIDACION# LIQ
				 where ol.OBOid = #Arguments.OBOid#
				 group by ol.CFformatoLiquidacion, LIQ.Ocodigo, LIQ.Mcodigo 
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "51427"
							msg  = "Tipo Cuenta Liquidación '@errorDat_1@' no implementado"
							errorDat_1="#rsOBO.OBTPtipoCtaLiquidacion#"
			>
		</cfif>
	
		<!--- 
			GENERAR CUENTAS DE LIQUIDACION:
				Obtiene el CFcuenta de las cuentas de liquidación sustituidas
				Si no existen se generan
		--->
		<cfquery datasource="#session.dsn#">
			update #LIQUIDACION# 
			   set CFcuenta = 
				(
					select CFcuenta
					  from CFinanciera
					 where Ecodigo = #session.Ecodigo#
					   and CFformato = #LIQUIDACION#.CFformato
				)
			 where TipoOA = 'L'
			   and CFcuenta is null
		</cfquery>
		<cfquery name="rsCFformatos" datasource="#session.dsn#">
			select distinct Ocodigo, CFformato
			  from #LIQUIDACION# 
			 where TipoOA = 'L'
			   and CFcuenta is null
		</cfquery>
	
		<cfif rsCFformatos.recordCount GT 0>
			<cfinvoke component="sif.obras.Componentes.OB_obras"
					method 				= "fnGeneraCtas"
					returnvariable 		= "LvarGeneracionOK"
	
					rsCFformatoOcodigo	= "#rsCFformatos#"
					mostrarSoloErrores	= "false"
					generarCuentas		= "true"
			>
			<cfif not LvarGeneracionOK>
				<div align="center">
				<input type="button" value="Regresar" onclick='location.href="OBobra.cfm?OP=L&OBOid=<cfoutput>#Arguments.OBOid#</cfoutput>";' />
				</div>
				<cfreturn>
			</cfif>
			<cfquery datasource="#session.dsn#">
				update #LIQUIDACION# 
				   set CFcuenta = 
					(
						select cf.CFcuenta
						  from CFinanciera cf
							inner join CPVigencia vg
							   on vg.Ecodigo = cf.Ecodigo 
							  and vg.CPVid 	 = cf.CPVid 
							  and vg.Cmayor	 = cf.Cmayor
							  and #dateformat(now(),"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
						 where cf.CFformato 	= #LIQUIDACION#.CFformato
						   and cf.Ecodigo 		= #session.Ecodigo#
	
					)
				 where TipoOA = 'L'
				   and CFcuenta is null
			</cfquery>
		</cfif>
	
		<!--- Incluir las Cuentas de Activos --->
		<cfquery datasource="#session.dsn#">
			insert into #LIQUIDACION# 
				( 
					TipoOA, TipoDC, 
					<!---CFformato, --->
					CFcuenta, 
					<!---Ccuenta, --->
					Ocodigo, OcodigoL, Mcodigo, 
					Activo,
					MontoO, 
					MontoL
				)
			select	'A', 'D', 
					<!---null, --->
					ol.CFcuentaActivo, 
					<!---null, --->
					cf.Ocodigo, LIQ.Ocodigo, LIQ.Mcodigo, 
					ol.OBOLactivo,
					round(sum(LIQ.MontoO * ol.OBOLporcentaje),2), 
					round(sum(LIQ.MontoL * ol.OBOLporcentaje),2)
			  from OBobraLiquidacion ol
					inner join CFuncional cf
					   on cf.CFid = ol.CFidActivo
				 , #LIQUIDACION# LIQ
			 where ol.OBOid = #Arguments.OBOid#
			   and LIQ.TipoOA <> 'O'
			 group by ol.CFcuentaActivo, cf.Ocodigo, LIQ.Ocodigo, LIQ.Mcodigo, ol.OBOLactivo
		</cfquery>
	
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" />
	
		<cfset LvarOrigen = 'OBLQ'>
        
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, Ocodigo, 
					INTTIP, INTDES, 
					CFcuenta, Ccuenta, 
					Mcodigo, INTMOE, INTCAM, INTMON
				)
			select
					'#LvarOrigen#', 1, '#LvarObra#', '#LvarNumLiquidacion#',
					'#dateFormat(LvarPeriodos.Actual.Fecha,"YYYYMMDD")#',
					#LvarPeriodos.Actual.Ano#, #LvarPeriodos.Actual.Mes#, 
					LIQ.Ocodigo,
					LIQ.TipoDC,
					case 
						when TipoOA = 'L' then 'Liquidación Obra #LvarObra#'
						else 'Generación Activo ' #_Cat# Activo
					end,
					LIQ.CFcuenta, c.Ccuenta,
					LIQ.Mcodigo,
					sum(LIQ.MontoO),
					round(sum(LIQ.MontoL)/sum(LIQ.MontoO),4),
					sum(LIQ.MontoL)
			  from #LIQUIDACION# LIQ
				inner join CFinanciera c
					on c.CFcuenta = LIQ.CFcuenta
			 where TipoOA in ('A', 'L')
			 group by
					LIQ.Ocodigo,
					LIQ.TipoDC,
					TipoOA, Activo, 
					LIQ.CFcuenta, c.Ccuenta,
					LIQ.Mcodigo
			 order by
					TipoOA desc
		</cfquery>
	
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select	i.INTLIN,
					i.INTDES, cf.CFformato, o.Oficodigo,
					i.INTTIP, i.INTMOE, m.Miso4217, i.INTMON
			  from #INTARC# i
				inner join CFinanciera cf
				   on cf.CFcuenta = i.CFcuenta
				inner join Monedas m
				   on m.Ecodigo = #session.Ecodigo#
				  and m.Mcodigo = i.Mcodigo	
				inner join Oficinas o
				   on o.Ecodigo = #session.Ecodigo#
				  and o.Ocodigo = i.Ocodigo	
			UNION
			select	10000 INTLIN,
					'CxC Oficina de Obras ' #_Cat# ol.Oficodigo #_Cat# ' a ' #_Cat# oa.Oficodigo INTDES,
					'' CFformato,
					ol.Oficodigo,
					'D' INTTIP,
					sum(LIQ.MontoO) INTMOE,
					m.Miso4217,
					sum(LIQ.MontoL) INTMON
			  from #LIQUIDACION# LIQ
				inner join Monedas m
				   on m.Ecodigo = #session.Ecodigo#
				  and m.Mcodigo = LIQ.Mcodigo	
				inner join Oficinas ol
				   on ol.Ecodigo = #session.Ecodigo#
				  and ol.Ocodigo = LIQ.OcodigoL
				inner join Oficinas oa
				   on oa.Ecodigo = #session.Ecodigo#
				  and oa.Ocodigo = LIQ.Ocodigo
			 where LIQ.TipoOA = 'A'
			   and LIQ.Ocodigo <> LIQ.OcodigoL
			 group by
					ol.Oficodigo, oa.Oficodigo, m.Miso4217
			UNION
			select 10001 INTLIN,
					'CxP Oficina de Activos ' #_Cat# oa.Oficodigo #_Cat# ' a ' #_Cat# ol.Oficodigo INTDES,
					'' CFformato,
					oa.Oficodigo,
					'C' INTTIP,
					sum(LIQ.MontoO) INTMOE,
					m.Miso4217,
					sum(LIQ.MontoL) INTMON
			  from #LIQUIDACION# LIQ
				inner join Monedas m
				   on m.Ecodigo = #session.Ecodigo#
				  and m.Mcodigo = LIQ.Mcodigo	
				inner join Oficinas ol
				   on ol.Ecodigo = #session.Ecodigo#
				  and ol.Ocodigo = LIQ.OcodigoL
				inner join Oficinas oa
				   on oa.Ecodigo = #session.Ecodigo#
				  and oa.Ocodigo = LIQ.Ocodigo
			 where LIQ.TipoOA = 'A'
			   and LIQ.Ocodigo <> LIQ.OcodigoL
			 group by
					ol.Oficodigo, oa.Oficodigo, m.Miso4217
			 order by 1
		</cfquery>
	
		<cf_templatecss>
		<table align="center">
			<tr class="tituloListas">
				<td colspan="8" align="center">
					<strong>
				<cfif rsOBO.OBTPtipoCtaLiquidacion EQ 0>
					Liquidación reversando cada Cuenta de la Obra
				<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 1>
					Liquidación sustituyendo niveles con valores fijos
				<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 2>
					Liquidación a una única Cuenta de Liquidacion: #rsACTIVOS_TOTs.CFformatoLiquidacionUnico#
				<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 3>
					Liquidación proporcional a una Cuenta de Liquidacion por Activo
				<cfelseif rsOBO.OBTPtipoCtaLiquidacion EQ 99>
					Liquidación Externa
				</cfif>
					</strong>
				</td>
			</tr>
	
			<tr class="tituloListas">
				<td><strong>Descripcion</strong></td>
				<td><strong>Cuenta</strong></td>
				<td><strong>Oficina&nbsp;</strong></td>
				<td><strong>Tipo</strong></td>
				<td align="right"><strong>Monto</strong></td>
				<td align="center"><strong>Moneda</strong></td>
				<td align="right"><strong>Debitos</strong></td>
				<td align="right"><strong>Creditos</strong></td>
			</tr>
		<cfset LvarDBs = 0>
		<cfset LvarCRs = 0>
		<cfoutput query="rsSQL">
			<tr>
				<td>#rsSQL.INTDES#&nbsp;</td>
				<td>#rsSQL.CFformato#&nbsp;</td>
				<td>#rsSQL.Oficodigo#&nbsp;</td>
				<td align="center">
				<cfif (rsSQL.INTTIP EQ "D" AND rsSQL.INTMON GTE 0) OR (rsSQL.INTTIP EQ "C" AND rsSQL.INTMON LT 0)>
					D
				<cfelse>
					C
				</cfif>
				</td>
				<td align="right">&nbsp;#numberFormat(abs(rsSQL.INTMOE),",9.00")#</td>
				<td align="center">#rsSQL.Miso4217#s</td>
				<td align="right">
				<cfif (rsSQL.INTTIP EQ "D" AND rsSQL.INTMON GTE 0) OR (rsSQL.INTTIP EQ "C" AND rsSQL.INTMON LT 0)>
					&nbsp;#numberFormat(abs(rsSQL.INTMON),",9.00")#
					<cfset LvarDBs = LvarDBs + rsSQL.INTMON>
				</cfif>
				</td>
				<td align="right">
				<cfif (rsSQL.INTTIP EQ "C" AND rsSQL.INTMON GTE 0) OR (rsSQL.INTTIP EQ "D" AND rsSQL.INTMON LT 0)>
					&nbsp;#numberFormat(abs(rsSQL.INTMON),",9.00")#
					<cfset LvarCRs = LvarCRs + rsSQL.INTMON>
				</cfif>
				</td>
			</tr>
		</cfoutput>
			<tr class="tituloListas">
				<td colspan="6" align="right"><strong>TOTALES</strong></td>
				<cfoutput>
				<td align="right">&nbsp;<strong>#numberFormat(LvarDBs,",9.00")#</strong></td>
				<td align="right">&nbsp;<strong>#numberFormat(LvarCRs,",9.00")#</strong></td>
				</cfoutput>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
		
		<!--- 
			BALANCE POR OFICINAS: Si hay oficinas distintas busca en la tabla CuentaBalanceOficina
			Sólo si CuentaBalanceOficina está activo, si no lo deja para parámetros en GeneraAsiento
		--->
		<cfquery name="rsOficinas" datasource="#session.dsn#">
			select distinct OcodigoL as OcodigoCxC, Ocodigo as OcodigoCxP
			  from #LIQUIDACION# 
			 where Ocodigo <> OcodigoL
			   and TipoOA = 'A'
		</cfquery>
	
		<cfif rsOficinas.recordCount GT 0>
			<cfquery name="rsHayCuentasBalanceOficina" datasource="#session.dsn#">
				select 1
				from CuentaBalanceOficina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsHayCuentasBalanceOficina.recordcount GT 0>
				<table align="center">
				<cfset LvarError = false>
				
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select 	distinct
							OL.Oficodigo c1, OL.Odescripcion d1, 
							OA.Oficodigo c2, OA.Odescripcion d2
					  from #LIQUIDACION# l
						inner join Oficinas OL
						   on OL.Ecodigo = #session.Ecodigo#
						  and OL.Ocodigo = l.OcodigoL
						inner join Oficinas OA
						   on OA.Ecodigo = #session.Ecodigo#
						  and OA.Ocodigo = l.Ocodigo
					 where l.TipoOA = 'A'
					   and l.Ocodigo <> l.OcodigoL
					   and not exists
						(
							select 1
							  from CuentaBalanceOficina a
							 inner join ConceptoContable b
								on b.Ecodigo = a.Ecodigo
							   and b.Cconcepto = a.Cconcepto
							   and b.Oorigen = '#LvarOrigen#'
							 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							   and Ocodigoori = l.OcodigoL
							   and Ocodigodest = l.Ocodigo
						)
					order by OL.Oficodigo, OA.Oficodigo
				</cfquery>
				<cfif rsSQL.recordCount GT 0>
					<cfset LvarError = true>
					<tr class="tituloListas">
						<td align="center" colspan="3">Cuentas por Cobrar de Balance por Oficina no encontradas con origen <cfoutput>'#LvarOrigen#'</cfoutput></td>
					</tr>
					<tr class="tituloListas">
						<td>Oficina Origen</td>
						<td>Oficina Destino</td>
					</tr>
					<cfoutput query="rsSQL">
						<tr>
							<td>#rsSQL.c1# - #rsSQL.d1#</td>
							<td>#rsSQL.c2# - #rsSQL.d2#</td>
						</tr>
					</cfoutput>
				</cfif>
	
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select 	distinct
							OL.Oficodigo c1, OL.Odescripcion d1, 
							OA.Oficodigo c2, OA.Odescripcion d2
					  from #LIQUIDACION# l
						inner join Oficinas OL
						   on OL.Ecodigo = #session.Ecodigo#
						  and OL.Ocodigo = l.OcodigoL
						inner join Oficinas OA
						   on OA.Ecodigo = #session.Ecodigo#
						  and OA.Ocodigo = l.Ocodigo
					 where l.TipoOA = 'A'
					   and l.Ocodigo <> l.OcodigoL
					   and not exists
						(
							select 1
							  from CuentaBalanceOficina a
							 inner join ConceptoContable b
								on b.Ecodigo = a.Ecodigo
							   and b.Cconcepto = a.Cconcepto
							   and b.Oorigen = '#LvarOrigen#'
							 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							   and Ocodigoori = l.Ocodigo
							   and Ocodigodest = l.OcodigoL
						)
					order by OA.Oficodigo, OL.Oficodigo
				</cfquery>
				<cfif rsSQL.recordCount GT 0>
					<cfset LvarError = true>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr class="tituloListas">
						<td align="center" colspan="3">Cuentas por Pagar de Balance por Oficina no encontradas con origen <cfoutput>'#LvarOrigen#'</cfoutput></td>
					</tr>
					<tr class="tituloListas">
						<td>Oficina Origen</td>
						<td>Oficina Destino</td>
					</tr>
					<cfoutput query="rsSQL">
						<tr>
							<td>#rsSQL.c2# - #rsSQL.d2#</td>
							<td>#rsSQL.c1# - #rsSQL.d1#</td>
						</tr>
					</cfoutput>
				</cfif>
				</table>
				<cfif LvarError>
					<div align="center">
					<input type="button" value="Regresar" onclick='location.href="OBobra.cfm?OP=L&OBOid=<cfoutput>#Arguments.OBOid#</cfoutput>";' />
					</div>
					<cfreturn>
				</cfif>
	
				<cfquery datasource="#session.dsn#">
					insert into #INTARC# 
						( 
							INTORI, INTREL, INTDOC, INTREF, 
							INTFEC, Periodo, Mes, Ocodigo, 
							INTTIP, INTDES, 
							CFcuenta, Ccuenta, 
							Mcodigo, INTMOE, INTCAM, INTMON
						)
					select
							'#LvarOrigen#', 1, '#LvarObra#', '#LvarNumLiquidacion#',
							'#dateFormat(LvarPeriodos.Actual.Fecha,"YYYYMMDD")#',
							#LvarPeriodos.Actual.Ano#, #LvarPeriodos.Actual.Mes#, 
							LIQ.OcodigoL,
							'D',
							'CxC Oficina de Obras ' #_Cat# ol.Oficodigo #_Cat# ' a ' #_Cat# oa.Oficodigo,
							coalesce(a.CFcuentacxc,1), coalesce(c.Ccuenta,1),
							LIQ.Mcodigo,
							sum(LIQ.MontoO),
							round(sum(LIQ.MontoL)/sum(LIQ.MontoO),4),
							sum(LIQ.MontoL)
					  from #LIQUIDACION# LIQ
						inner join Oficinas ol
						   on ol.Ecodigo = #session.Ecodigo#
						  and ol.Ocodigo = LIQ.OcodigoL
						inner join Oficinas oa
						   on oa.Ecodigo = #session.Ecodigo#
						  and oa.Ocodigo = LIQ.Ocodigo
						left join CuentaBalanceOficina a
							 inner join CFinanciera c
								on c.CFcuenta = a.CFcuentacxc
	
							 inner join ConceptoContable b
								on b.Ecodigo = a.Ecodigo
							   and b.Cconcepto = a.Cconcepto
							   and b.Oorigen = '#LvarOrigen#'
						   on a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and Ocodigoori 	= LIQ.OcodigoL
						  and Ocodigodest 	= LIQ.Ocodigo
					 where LIQ.TipoOA = 'A'
					   and LIQ.Ocodigo <> LIQ.OcodigoL
					 group by
							LIQ.OcodigoL,
							ol.Oficodigo, oa.Oficodigo, 
							coalesce(a.CFcuentacxc,1), coalesce(c.Ccuenta,1),
							LIQ.Mcodigo
				</cfquery>
	
				<cfquery datasource="#session.dsn#">
					insert into #INTARC# 
						( 
							INTORI, INTREL, INTDOC, INTREF, 
							INTFEC, Periodo, Mes, Ocodigo, 
							INTTIP, INTDES, 
							CFcuenta, Ccuenta, 
							Mcodigo, INTMOE, INTCAM, INTMON
						)
					select
							'#LvarOrigen#', 1, '#LvarObra#', '#LvarNumLiquidacion#',
							'#dateFormat(LvarPeriodos.Actual.Fecha,"YYYYMMDD")#',
							#LvarPeriodos.Actual.Ano#, #LvarPeriodos.Actual.Mes#, 
							LIQ.Ocodigo,
							'C',
							'CxP Oficina de Activos ' #_Cat# oa.Oficodigo #_Cat# ' a ' #_Cat# ol.Oficodigo,
							coalesce(a.CFcuentacxp,1), coalesce(c.Ccuenta,1),
							LIQ.Mcodigo,
							sum(LIQ.MontoO),
							round(sum(LIQ.MontoL)/sum(LIQ.MontoO),4),
							sum(LIQ.MontoL)
					  from #LIQUIDACION# LIQ
						inner join Oficinas ol
						   on ol.Ecodigo = #session.Ecodigo#
						  and ol.Ocodigo = LIQ.OcodigoL
						inner join Oficinas oa
						   on oa.Ecodigo = #session.Ecodigo#
						  and oa.Ocodigo = LIQ.Ocodigo
						left join CuentaBalanceOficina a
							 inner join CFinanciera c
								on c.CFcuenta = a.CFcuentacxp
							 inner join ConceptoContable b
								on b.Ecodigo = a.Ecodigo
							   and b.Cconcepto = a.Cconcepto
							   and b.Oorigen = '#LvarOrigen#'
						   on a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and Ocodigoori 	= LIQ.Ocodigo
						  and Ocodigodest 	= LIQ.OcodigoL
					 where LIQ.TipoOA = 'A'
					   and LIQ.Ocodigo <> LIQ.OcodigoL
					 group by
							LIQ.Ocodigo,
							ol.Oficodigo, oa.Oficodigo, 
							coalesce(a.CFcuentacxp,1), coalesce(c.Ccuenta,1),
							LIQ.Mcodigo
				</cfquery>
			</cfif>
		</cfif>
		<cfif url.OP EQ "L">
			<div align="center">
			<input type="button" value="Liquidar" class="btnAplicar"  onclick='location.href="OBobraLiquidacion_sql.cfm?OP=LL&OBOid=<cfoutput>#Arguments.OBOid#</cfoutput>";' />
			<input type="button" value="Regresar" class="btnAnterior" onclick='location.href="OBobra.cfm?OP=L&OBOid=<cfoutput>#Arguments.OBOid#</cfoutput>";' />
			</div>
			<cfreturn>
		</cfif>
		<!--- 
			GENERA ASIENTO:
				VerficarInactivas = NO
		--->
		<cftransaction>
			<cfquery datasource="#session.dsn#">
				update PCDCatalogo
				   set PCDactivo = 1
				 where PCDcatid = #rsOBO.PCDcatidObr#
			</cfquery>
			
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
				<cfinvokeargument name="Oorigen"		value="#LvarOrigen#"/>
				<cfinvokeargument name="Eperiodo"		value="#LvarPeriodos.Actual.Ano#"/>
				<cfinvokeargument name="Emes"			value="#LvarPeriodos.Actual.Mes#"/>
				<cfinvokeargument name="Efecha"			value="#LvarPeriodos.Actual.Fecha#"/>
				<cfinvokeargument name="Edescripcion"	value="Liquidación Obra Terminada '#trim(rsOBO.OBPcodigo)#-#trim(rsOBO.OBOcodigo)# = #trim(rsOBO.OBOdescripcion)#'"/>
				<cfinvokeargument name="Edocbase"		value="#LvarObra#"/>
				<cfinvokeargument name="Ereferencia"	value="#LvarNumLiquidacion#"/>
				<cfinvokeargument name="Ecodigo"		value="#session.Ecodigo#"/>
				<cfinvokeargument name="Conexion"		value="#session.DSN#"/>
				<cfinvokeargument name="NAP"			value="0"/>
			</cfinvoke>
			
			<!--- Inactiva la Obra --->
			<cfquery datasource="#session.dsn#">
				update PCDCatalogo
				   set PCDactivo = 0
				 where PCDcatid = #rsOBO.PCDcatidObr#
			</cfquery>
			
			<!--- 
				Completa los datos en Gestion de Activos con:
					- datos del asiento
						Cconcepto
						GATperiodo
						GATmes
						Edocumento
						IDcontable
					- monto de activos generados:
						GATmonto
			--->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select IDcontable, Cconcepto, Eperiodo, Emes, Edocumento
				  from EContables
				 where IDcontable = #LvarIDcontable#
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update GATransacciones
				   set 	Cconcepto	= #rsSQL.Cconcepto#
					 ,	GATperiodo	= #rsSQL.Eperiodo#
					 ,	GATmes		= #rsSQL.Emes#
					 ,	Edocumento	= #rsSQL.Edocumento#
					 ,	IDcontable	= #rsSQL.IDcontable#

					 ,	GATmonto	=
									(
										select OBOLmonto
										  from OBobraLiquidacion ol
										 where ol.OBOid = #Arguments.OBOid#
										   and ol.GATid = GATransacciones.ID
									)
				 where exists 
				 	(
						select 1
						  from OBobraLiquidacion ol
						 where ol.OBOid = #Arguments.OBOid#
						   and ol.GATid = GATransacciones.ID
					)
			</cfquery>

			<!--- Pone la obra como Liquidada --->
			<cfquery datasource="#session.dsn#">
				update OBobra
				   set OBOestado 				= '3'
					 , OBOfechaLiquidado		= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
					 , UsucodigoLiquidado		= #session.Usucodigo#
					 , OBOnumLiquidacion 		= #LvarNumLiquidacion#
					 , IDcontableLiquidacion 	= #LvarIDcontable#
				 where OBOid = #Arguments.OBOid#
			</cfquery>
		</cftransaction>
	</cffunction>

	<cffunction name="fnGeneraCtasObra">
		<cfargument name="IrA" 	 type="string" required="yes">
		<cfargument name="OBOid" type="string" default="">
		<cfargument name="OBEid" type="string" default="">
	
		<cfquery datasource="#session.dsn#" name="rsCFformatos">
			select ec.OBEid, e.OBEdescripcion, ec.CFformato, ec.CFcuenta, e.Ocodigo, o.PCDcatidObr, p.PCDcatidPry
			  from OBetapaCuentas ec
				inner join OBetapa e
					inner join OBobra o
						inner join OBproyecto p
							 on p.OBPid		= o.OBPid
							and p.Ecodigo	= o.Ecodigo
					   on o.OBOid = e.OBOid 
					  and o.OBOestado = '1'		<!--- Obra Activa --->
				   on e.OBEid = ec.OBEid 
				  and e.OBEestado = '1'			<!--- Etapa Activa --->
			   where 
			<cfif Arguments.OBEid NEQ "">
					ec.OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBEid#">
			<cfelseif Arguments.OBOid NEQ "">
					o.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBOid#">
			<cfelse>
					1=2
			</cfif>
				and ec.OBECestado = '0'			<!--- Cuenta sin generar --->
			order by ec.OBEid
		</cfquery>
		<cfif rsCFformatos.recordCount EQ 0>
			<script>
				alert('No hay cuentas para generar');
				<cfoutput>
				<cfif Arguments.IrA EQ "OBetapa.cfm">
					location.href="#Arguments.IrA#?OBEid=#Arguments.OBEid#";
				<cfelse>
					location.href="#Arguments.IrA#";
				</cfif>
				</cfoutput>
			</script>
		<cfelse>
			<cfoutput><BR>
			<div align="center">
			<cfif Arguments.IrA EQ "OBetapa.cfm">
				<input type="button" value="Seguir" onclick='location.href="#Arguments.IrA#?OBEid=#Arguments.OBEid#";' />
			<cfelse>
				<input type="button" value="Seguir" onclick='location.href="#Arguments.IrA#";' />
			</cfif>
			</div><BR>
			</cfoutput>
			<cfset fnGeneraCtas (rsCFformatos)>
			<cfoutput><BR>
			<div align="center">
			<cfif Arguments.IrA EQ "OBetapa.cfm">
				<input type="button" value="Seguir" onclick='location.href="#Arguments.IrA#?OBEid=#Arguments.OBEid#";' />
			<cfelse>
				<input type="button" value="Seguir" onclick='location.href="#Arguments.IrA#";' />
			</cfif>
			</div>
			</cfoutput>
		</cfif>
	</cffunction>
	
	<cffunction name="fnGeneraCtas" access="public" output="true" returntype="boolean">
		<cfargument name="rsCFformatoOcodigo" 	type="query">
		<cfargument name="Fecha" 				type="string" default="#now()#">
		<cfargument name="mostrarSoloErrores" 	type="boolean" default="yes">
		<cfargument name="generarCuentas" 		type="boolean" default="no">
	
		<!--- Activa la Oficina de la Etapa en el valor de Catalogo de Proyecto, si dichos catalogos tienen valores por oficina --->
		<cfif isdefined("arguments.rsCFformatoOcodigo.PCDcatidPry")>
			<!--- Catalogo de Proyecto --->
			<cfset rsSQL = arguments.rsCFformatoOcodigo>
			<cfquery name="rsSQL" dbtype="query">
				select distinct PCDcatidPry, Ocodigo from rsSQL
			</cfquery>
			<cfloop query="rsSQL">
				<cfquery name="rsSQL1" datasource="#session.dsn#">
					select e.PCEoficina, vo.PCDcatid
					  from PCDCatalogo d
						inner join PCECatalogo e
						   on e.PCEcatid = d.PCEcatid
						  and e.PCEempresa = 1 and e.PCEoficina = 1
						 left join PCDCatalogoValOficina vo
						   on vo.PCDcatid	= d.PCDcatid
						  and vo.Ecodigo	= d.Ecodigo
						  and vo.Ocodigo	= #rsSQL.Ocodigo#
					 where d.Ecodigo	= #session.Ecodigo#
					   and d.PCDcatid 	= #rsSQL.PCDcatidPry#
				</cfquery>
				<cfif rsSQL1.PCEoficina EQ "1" AND rsSQL1.PCDcatid EQ "">
					<cfquery datasource="#session.dsn#">
						insert into PCDCatalogoValOficina
							(PCDcatid,Ecodigo,Ocodigo)
						values 
							(#rsCFformatos.PCDcatidPry#,#session.Ecodigo#,#rsSQL.Ocodigo#)
					</cfquery>
				</cfif>
			</cfloop>			
		</cfif>
	
		<!--- Activa la Oficina de la Etapa en el valor de Catalogo de Obras, si dichos catalogos tienen valores por oficina --->
		<cfif isdefined("arguments.rsCFformatoOcodigo.PCDcatidObr")>
			<!--- Catalogo de Obras --->
			<cfset rsSQL = arguments.rsCFformatoOcodigo>
			<cfquery name="rsSQL" dbtype="query">
				select distinct PCDcatidObr, Ocodigo from rsSQL
			</cfquery>
			<cfloop query="rsSQL">
				<cfquery name="rsSQL1" datasource="#session.dsn#">
					select e.PCEoficina, vo.PCDcatid
					  from PCDCatalogo d
						inner join PCECatalogo e
						   on e.PCEcatid = d.PCEcatid
						  and e.PCEempresa = 1 and e.PCEoficina = 1
						 left join PCDCatalogoValOficina vo
						   on vo.PCDcatid	= d.PCDcatid
						  and vo.Ecodigo	= d.Ecodigo
						  and vo.Ocodigo	= #rsSQL.Ocodigo#
					 where d.Ecodigo	= #session.Ecodigo#
					   and d.PCDcatid 	= #rsCFformatos.PCDcatidObr#
				</cfquery>
				<cfif rsSQL1.PCEoficina EQ "1" AND rsSQL1.PCDcatid EQ "">
					<cfquery datasource="#session.dsn#">
						insert into PCDCatalogoValOficina
							(PCDcatid,Ecodigo,Ocodigo)
						values 
							(#rsSQL.PCDcatidObr#,#session.Ecodigo#,#rsSQL.Ocodigo#)
					</cfquery>
				</cfif>
			</cfloop>			
		</cfif>
		
		<!--- Verifica las cuentas Financieras --->
		<cf_templatecss>
		<table width="80%" align="center">
			<tr class="tituloListas">
				<td colspan="3" align="center"><strong>RESULTADO DE LA GENERACION DE CUENTAS PARA OBRAS</strong></td>
			</tr>
			<tr class="tituloListas">
				<td><strong>Cuenta Financiera</strong></td>
				<td><strong>Resultado</strong></td>
			</tr>
		<cfset LvarOBEidAnt = "">
		<cfset LvarConErrores = false>
	
		<cfloop query="arguments.rsCFformatoOcodigo">
			<cfif arguments.rsCFformatoOcodigo.CFcuenta NEQ "">
				<cfset LvarCFcuenta = arguments.rsCFformatoOcodigo.CFcuenta>
				<cfset LvarMSG = "OLD">
			<cfelse>
				<cfif arguments.generarCuentas>
					<cfinvoke	component="sif.Componentes.PC_GeneraCuentaFinanciera"
								method="fnGeneraCFformato"
								returnvariable="LvarMSG">

						<cfinvokeargument name="Lprm_Ecodigo"	 			value="#session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_CFformato" 			value="#Arguments.rsCFformatoOcodigo.CFformato#"/>
						<cfinvokeargument name="Lprm_Ocodigo" 				value="#Arguments.rsCFformatoOcodigo.Ocodigo#"/>
						<cfinvokeargument name="Lprm_Fecha" 				value="#Arguments.fecha#"/>
			
						<cfinvokeargument name="Lprm_TransaccionActiva"		value="false"/>
						<cfinvokeargument name="Lprm_NoVerificarObras" 		value="yes"/>
					</cfinvoke>
				<cfelse>
					<cfinvoke	component="sif.Componentes.PC_GeneraCuentaFinanciera"
								method="fnVerificaCFformato"
								returnvariable="LvarMSG">
						<cfinvokeargument name="Lprm_Ecodigo"	 			value="#session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_CFformato" 			value="#Arguments.rsCFformatoOcodigo.CFformato#"/>
						<cfinvokeargument name="Lprm_Ocodigo" 				value="#Arguments.rsCFformatoOcodigo.Ocodigo#"/>
						<cfinvokeargument name="Lprm_Fecha" 				value="#Arguments.fecha#"/>
			
						<cfinvokeargument name="Lprm_VerificarExistencia"	value="false"/>
						<cfinvokeargument name="Lprm_NoVerificarPres"		value="false"/>
						<cfinvokeargument name="Lprm_NoVerificarObras" 		value="yes"/>
					</cfinvoke>
				</cfif>

				<cfif LvarMSG EQ "OLD" OR LvarMSG EQ "NEW">
					<cfinvoke	 component="sif.Componentes.PC_GeneraCuentaFinanciera"
								 method="fnObtieneCFcuenta"
								 returnvariable="rsCta">
						<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_CFformato" 		value="#Arguments.rsCFformatoOcodigo.CFformato#"/>
						<cfinvokeargument name="Lprm_fecha" 			value="#Arguments.fecha#"/>
					</cfinvoke>
					<cfset LvarCFcuenta = rsCta.CFcuenta>
				<cfelse>
					<cfset LvarConErrores = true>
				</cfif>
			</cfif>
	
			<cfif NOT (LvarMSG EQ "OLD" OR LvarMSG EQ "NEW")>
				<tr>
					<td style="color:##FF0000;" nowrap>#Arguments.rsCFformatoOcodigo.CFformato#</td>
					<td style="color:##FF0000;">#LvarMSG#</td>
				</tr>
			<cfelseif not Arguments.MostrarSoloErrores>
				<tr>
				<cfif LvarMSG EQ "OLD">
					<td nowrap>#Arguments.rsCFformatoOcodigo.CFformato#</td>
					<td>OK = Cuenta Financiera ya estaba generada</td>
				<cfelseif arguments.generarCuentas>
					<td nowrap>#Arguments.rsCFformatoOcodigo.CFformato#</td>
					<td>OK = Cuenta Financiera Generada</td>
				<cfelse>
					<td nowrap>#LvarError.CFformato#</td>
					<td>OK = Cuenta Financiera Activada</td>
				</cfif>
				</tr>
			</cfif>
			
			<cfif isdefined("arguments.rsCFformatoOcodigo.OBEid")>
				<cfquery datasource="#session.dsn#">
					update OBetapaCuentas
					   set OBECfechaGeneracion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						 , OBECusucodigoGeneracion = #session.Usucodigo#
						 , OBECmsgGeneracion =
							 <cfif (LvarMSG EQ "OLD" OR LvarMSG EQ "NEW")>
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> 
								, OBECestado 	= '1'
								, CFcuenta 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuenta#" null="#LvarCFcuenta EQ ""#">
							 <cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnJSStringFormat(replace(LvarMSG,"'","","ALL"))#">
							 </cfif>
					 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.rsCFformatoOcodigo.OBEid#">
					   and CFformato 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rsCFformatoOcodigo.CFformato#">
				</cfquery>
			</cfif>
		</cfloop>
		</table>
		<cfreturn not LvarConErrores>
	</cffunction>

	<cffunction name="sbIniciar_LIQUIDACION" access="public" output="true" returntype="struct">
		<cfargument name="OBOid" 	type="numeric" required="yes">
		<cfargument name="porOBEC" 	type="boolean" default="no">
		
		<cfinclude template="../Componentes/functionsPeriodo.cfm">
		<cfset LvarPeriodos = fnPeriodoContable ()>

		<cf_dbtemp name="LIQOB_V1" returnvariable="LIQUIDACION" datasource="#session.dsn#">
			<cf_dbtempcol name="TipoOA"    			type="char(1)"      mandatory="no">
			<cf_dbtempcol name="CFformato" 			type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CFcuenta"  			type="numeric"      mandatory="no">
			<cf_dbtempcol name="Ccuenta"  			type="numeric"      mandatory="no">
			<cf_dbtempcol name="Ocodigo"		 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="OcodigoL"		 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="Mcodigo"		 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="MontoO"				type="money"        mandatory="no">
			<cf_dbtempcol name="MontoL"				type="money"        mandatory="no">
			<cf_dbtempcol name="TipoDC"    			type="char(1)"      mandatory="no">
			<cf_dbtempcol name="Activo"    			type="varchar(40)"  mandatory="no">
		</cf_dbtemp>

		<cfif Arguments.porOBEC>
			<cfquery datasource="#session.dsn#">
				update OBetapaCuentas
				   set CFcuenta = 
						(
							select CFcuenta
							  from CFinanciera cf
								inner join CPVigencia vg
								   on vg.Ecodigo = cf.Ecodigo 
								  and vg.CPVid 	 = cf.CPVid 
								  and vg.Cmayor	 = cf.Cmayor
								  and #dateformat(now(),"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
							 where cf.CFformato = OBetapaCuentas.CFformato
							   and cf.Ecodigo 	= OBetapaCuentas.Ecodigo
						)
				 where exists
						(
							select 1
							  from OBetapa e
							 where e.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBOid#">
							   and e.OBEid = OBetapaCuentas.OBEid
						)
				   and CFcuenta is null
			</cfquery>
		
			<cfquery datasource="#session.dsn#">
				insert into #LIQUIDACION# 
					( 
						TipoOA, TipoDC, CFformato, CFcuenta, Ccuenta, Ocodigo, Mcodigo, 
						MontoO, 
						MontoL
					)
				select	'O', 'C', ec.CFformato, ec.CFcuenta, s.Ccuenta, s.Ocodigo, s.Mcodigo, 
						sum(SOinicial + DOdebitos - COcreditos), 
						sum(SLinicial + DLdebitos - CLcreditos)
				  from OBetapa e
					inner join OBetapaCuentas ec
						inner join CFinanciera cf
							inner join SaldosContables s
							   on s.Ccuenta 	= cf.Ccuenta
							  and s.Speriodo 	= #LvarPeriodos.Actual.Ano#
							  and s.Smes		= #LvarPeriodos.Actual.Mes#
							  and s.Ecodigo		= #session.Ecodigo#
						   on cf.CFcuenta = ec.CFcuenta
					   on ec.OBEid = e.OBEid
				 where e.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBOid#">
				 group by ec.CFformato, ec.CFcuenta, s.Ccuenta, s.Ocodigo, s.Mcodigo
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into #LIQUIDACION# 
					( 
						TipoOA, TipoDC, CFformato, CFcuenta, Ccuenta, Ocodigo, Mcodigo, 
						MontoO, 
						MontoL
					)
				select	'O', 'C', cf.CFformato, cf.CFcuenta, cf.Ccuenta, s.Ocodigo, s.Mcodigo, 
						sum(SOinicial + DOdebitos - COcreditos), 
						sum(SLinicial + DLdebitos - CLcreditos)
				  from OBobra o
					inner join OBproyecto p
						inner join OBtipoProyecto tp
						   on tp.OBTPid = p.OBTPid
					    on p.Ecodigo = o.Ecodigo
					   and p.OBPid   = o.OBPid	
					inner join CFinanciera cf
						inner join SaldosContables s
						   on s.Ccuenta 	= cf.Ccuenta
						  and s.Speriodo 	= #LvarPeriodos.Actual.Ano#
						  and s.Smes		= #LvarPeriodos.Actual.Mes#
						  and s.Ecodigo		= #session.Ecodigo#
					   on cf.Ecodigo		= s.Ecodigo
					  and cf.Cmayor			= tp.Cmayor
					 
				 where o.OBOid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.OBOid#">				 
				   and exists (	select 1
								 from PCDCatalogoCuentaF cuboPry, PCDCatalogoCuentaF cuboObr
								where cuboPry.CFcuenta	= cf.CFcuenta
								  and cuboPry.PCDCniv	= tp.OBTPnivelProyecto
								  and cuboPry.PCDcatid	= p.PCDcatidPry
								  and cuboObr.CFcuenta	= cf.CFcuenta
								  and cuboObr.PCDCniv 	= tp.OBTPnivelObra
								  and cuboObr.PCDcatid	= o.PCDcatidObr
								)
				 group by cf.CFformato, cf.CFcuenta, cf.Ccuenta, s.Ocodigo, s.Mcodigo
			 </cfquery>
		</cfif>		

		<cfquery name="rsLIQUIDACION_TOTs" datasource="#session.dsn#">
			select	count(1) as cantidad,
					coalesce(sum(MontoO),0) as MontoO, 
					coalesce(sum(MontoL),0) as MontoL
			  from #LIQUIDACION# 
		</cfquery>
		
		<cfquery datasource="#session.dsn#">
			update OBobra
			   set OBOmontoLiq = <cfqueryparam cfsqltype="cf_sql_money" value="#rsLIQUIDACION_TOTs.MontoL#">
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBOid#">
		</cfquery>
		
		<cfset LvarResultado = structNew()>
		<cfset LvarResultado.Periodos			= LvarPeriodos>
		<cfset LvarResultado.Liquidacion		= LIQUIDACION>
		<cfset LvarResultado.rsLiquidacion_Tots	= rsLIQUIDACION_TOTs>
		<cfreturn LvarResultado>

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
</cfcomponent>


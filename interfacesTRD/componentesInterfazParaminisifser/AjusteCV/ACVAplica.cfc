<cfcomponent>
	<cffunction name="AjusteCV" access="public" output="true">
		<cfargument name="Orden" type="string" required="yes">
		<cfargument name="OCid" type="numeric" required="yes">
		<cfargument name="Producto" type="string" required="yes">
		<cfargument name="Modulo" type="string" required="yes">
		<cfargument name="Costo" type="numeric" required="yes">
		<cfargument name="Moneda" type="string" required="yes">
		<cfargument name="Mcodigo" type="numeric" required="yes">
		
		<cfset varOrden = arguments.Orden>
		<cfset varOCid = arguments.OCid>
		<cfset varModulo = arguments.Modulo>
		<cfset varCosto = arguments.Costo>
		<cfset varProducto = arguments.Producto>
		<cfset varMoneda = arguments.Moneda>
		<cfset varMcodigo = arguments.Mcodigo>
<cftransaction>
	<cfquery datasource="sifinterfaces">
		if object_id('##Destinos') is not null
			drop table ##Destinos
		if object_id('##DestinosAlmacen') is not null
			drop table ##DestinosAlmacen
	</cfquery>
	
	<cfquery datasource="sifinterfaces">
		create table ##Destinos (
		Destino varchar(20) null,
		OCidDestino integer null,
		DestinoTipo varchar(2) null, 
		TC numeric(18,4) null,
		Total money null
		)
		
		create table ##DestinosAlmacen (
		OCTid integer null,
		Alm_Aid integer null,
		TC numeric(18,4) null,
		Total money null
		)
	</cfquery>
	
	<cfset minisifdb = Application.dsinfo[session.dsn].schema>

	<!---Obtener el mes y periodo Actual --->
	<cfset Actperiodo="#obten_val(30).Pvalor#">
	<cfset Actmes="#obten_val(40).Pvalor#">
	<cfset varCFcuenta="#obten_val(980).Pvalor#">
	<cfset varFechaPoliza = createdatetime(Actperiodo,Actmes + 1,1,23,59,59)>
	<cfset varFechaPoliza = DateAdd('D',-1,varFechaPoliza)>
	<cfset varDescripcion = "Poliza de Ajuste de Costo de Ventas">
	
	<!--- Cuenta Balance --->
	<cfquery name="rsCuentaB" datasource="sifinterfaces">
		select CFformato
		from #minisifdb#..CFinanciera 
		where CFcuenta = #varCFcuenta#
	</cfquery>
	<cfif rsCuentaB.recordcount EQ 1 and rsCuentaB.CFformato NEQ "">
		<cfset varCuentaB = rsCuentaB.CFformato>
	<cfelse>
		<cfabort showerror="NO SE HA PARAMETRIADO LA CUENTA DE BALANE PARA REVERSION DE ESTIMACIONES">
	</cfif>
	
	<!--- Oficina para la empresa --->
	<cfquery name="rsOffice" datasource="sifinterfaces">
		select min(Ocodigo) as Ocodigo from #minisifdb#..Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfif rsOffice.recordcount GT 0>
		<cfset ws_coffice = "#rsOffice.Ocodigo#">
	<cfelse>
		<cfabort showerror="No existe Oficina parametrizada para esta Empresa">
	</cfif> 
	
	<!---Verifica si existe ya la poliza en Importacion Documentos--->
	<cfquery name="rsPoliza" datasource="sifinterfaces">
		select * 
		from #minisifdb#..EContablesImportacion
		where Edocbase = 'ACV#Actperiodo##Actmes#'
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Eperiodo = #Actperiodo#
		and Emes = #Actmes#
		and Cconcepto = 0
	</cfquery>
	<cfif rsPoliza.recordcount EQ 0>
			<cfquery datasource="sifinterfaces">
				insert into #minisifdb#..EContablesImportacion (Ecodigo,
					Cconcepto, Eperiodo, Emes, Efecha,
					Edescripcion, Edocbase, Ereferencia,
					BMfalta, BMUsucodigo, ECIreversible)
				values(#session.Ecodigo#,0,#Actperiodo#, #Actmes#, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">, 
					'#varDescripcion#','ACV#Actperiodo##Actmes#',null,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value=0>)
			</cfquery>
			<cfquery name="rsPoliza" datasource="sifinterfaces">
				select MAX(ECIid) as ECIid
				from #minisifdb#..EContablesImportacion
			</cfquery>
	</cfif>

	<cfset varID = rsPoliza.ECIid>
	
	<!---Busca el Aid de el Producto--->
	<cfquery name="rsProducto" datasource="sifinterfaces">
		select Aid 
		from #minisifdb#..Articulos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Acodigo = '#varProducto#'
	</cfquery>
	<cfset varAid = rsProducto.Aid>
	
	<cfif varModulo EQ 'CC'>
	
		<!--- Concepto de Ingreso --->
		<cfquery name="rsConcepto" datasource="sifinterfaces">
			select CFcomplementoIngreso 
			from #minisifdb#..OCconceptoIngreso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and OCIcodigo = '00'
		</cfquery>
		<cfif rsConcepto.recordcount EQ 0 OR rsConcepto.CFcomplementoIngreso EQ "">
			<cfabort showerror="No Existe el Complemento de Concepto Ingreso: Producto">
		<cfelse>
			<cfset varConcepto = rsConcepto.CFcomplementoIngreso>
		</cfif>
		
		<!--- Obtiene Promedio Ponderado de TC --->
		<cfquery name="rsDocumentos" datasource="sifinterfaces">
			select sum(Dtotal) as Total
			from #minisifdb#..HDocumentos ed 
				inner join #minisifdb#..HDDocumentos dd 
				on ed.CCTcodigo = dd.CCTcodigo and ed.Ddocumento = dd.Ddocumento and ed.Ecodigo = dd.Ecodigo and ed.HDid = dd.HDid
			where dd.DDtipo = 'O'
			and dd.CCTcodigo in ('EC','DC','FC','NC')
			and dd.OCid = #varOCid#
			and dd.DDcodartcon = #varAid#
			and ed.Mcodigo = #varMcodigo#
		</cfquery>
		<cfset varSuma = rsDocumentos.Total>
		<cfquery name="rsDocumentos" datasource="sifinterfaces">
			select round(sum(ed.Dtipocambio * (ed.Dtotal/#varSuma#)),4) as PorcentajeTC
			from #minisifdb#..HDocumentos ed 
				inner join #minisifdb#..HDDocumentos dd 
				on ed.CCTcodigo = dd.CCTcodigo and ed.Ddocumento = dd.Ddocumento and ed.Ecodigo = dd.Ecodigo and ed.HDid = dd.HDid
			where dd.DDtipo = 'O'
			and dd.CCTcodigo in ('EC','DC','FC','NC')
			and dd.OCid = #varOCid#
			and dd.DDcodartcon = #varAid#
			and ed.Mcodigo = #varMcodigo#
		</cfquery>
		<cfset varTC = rsDocumentos.PorcentajeTC>
		<cfset varTC = numberformat(varTC,"9.9999")>
		<cfset varMontoLocal = numberformat(varCosto,"9.99") * numberformat(varTC,"9.9999")>
				
		<!--- Complemento Socio de Negocio --->
		<cfquery name="rsComplemento" datasource="sifinterfaces">
			select cuentac
			from #minisifdb#..SNegocios sn
				inner join #minisifdb#..OCordenComercial oc
				on sn.Ecodigo = oc.Ecodigo 
				and sn.SNid = oc.SNid
				and oc.Ecodigo = 8
				and oc.OCid = #varOCid#
		</cfquery>	
		<cfif rsComplemento.recordcount EQ 0 OR rsComplemento.recordcount GT 1 OR rsComplemento.cuentac EQ "">
			<cfabort showerror="Error al Obtener el Codigo del complemento del Socio de Negocios">
		<cfelse>
			<cfset varComplementoS = "#left(rsComplemento.cuentac,3)#-#right(rsComplemento.cuentac,3)#">
		</cfif>
				
		<!--- Complemento Articulo --->
		<cfquery name="rsComplemento" datasource="sifinterfaces">
			select CFcomplementoCostoVenta
			from #minisifdb#..OCcomplementoArticulo
			where Aid = #varAid#
		</cfquery>	
		<cfif rsComplemento.recordcount EQ 0 OR rsComplemento.recordcount GT 1 OR rsComplemento.CFcomplementoCostoVenta EQ "">
			<cfabort showerror="Error al Obtener el Codigo del complemento del Articulo">
		<cfelse>
			<cfset varComplementoP = "#left(rsComplemento.CFcomplementoCostoVenta,3)#-#right(rsComplemento.CFcomplementoCostoVenta,3)#">
		</cfif>
		
		<!--- Busca cuentas de Ingreso --->
		<cfquery name="rsCuentas" datasource="sifinterfaces">
			select CFmascaraIngreso
			from #minisifdb#..OCtipoVenta ov 
				inner join #minisifdb#..OCordenComercial oc
				on ov.Ecodigo = oc.Ecodigo 
				and ov.OCVid = oc.OCVid 
				and oc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and oc.OCid =  #varOCid#
		</cfquery>
		<cfset varCuentaIngreso = rsCuentas.CFmascaraIngreso>
		
		<cfset varCuentaIngreso = replace(varCuentaIngreso,"SSS-SSS",varComplementoS)>
		<cfset varCuentaIngreso = replace(varCuentaIngreso,"AAA-AAA",varComplementoP)>
		<cfset varCuentaIngreso = replace(varCuentaIngreso,"III",varConcepto)>
		
		<!--- Busca Consecutivo Detalle--->
		<cfquery name="rsConsecutivo" datasource="sifinterfaces">
			select MAX(DCIconsecutivo) as Consecutivo
			from #minisifdb#..DContablesImportacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and ECIid = #varID#
		</cfquery>
		<cfif rsConsecutivo.recordcount EQ 0 OR rsConsecutivo.Consecutivo EQ 0 OR rsConsecutivo.Consecutivo EQ "">
			<cfset varConsecutivo = 1>
		<cfelse>
			<cfset varConsecutivo = rsConsecutivo.Consecutivo + 1>
		</cfif>
		
		<!---Inserta linea de Ajuste--->
		<!---Balance--->
		<cfset varDetalleDesc = "Ajuste Cuenta Balance OC:#VarOrden#">
		<cfif varCosto GT 0>
			<cfset varDC = "D">
		<cfelse>
			<cfset varDC = "C">
		</cfif>
			<cfquery datasource="sifinterfaces">
				insert #minisifdb#..DContablesImportacion (ECIid,
				DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
				Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
				CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
				Doriginal, Dlocal, Dtipocambio, Cconcepto,
				BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
				Referencia2, Referencia3, Resultado, MSG)
				values(#varID#, 
				#varConsecutivo#,  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">, #Actperiodo#, #Actmes#, 
				'#varDetalleDesc#', null, null, '#varDC#',
				'#varCuentaB#', null, null, #ws_coffice#, #varMcodigo#,
				<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCosto,"9.99"))#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varMontoLocal,"9.99"))#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varTC,"9.9999")#">, 0,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				#session.usucodigo#, #session.Ecodigo#, null,
				null, null, 0, null)
			</cfquery>
		<cfset varConsecutivo = varConsecutivo + 1>
		<!---Ingreso--->
		<cfset varDetalleDesc = "Ajuste Cuenta Ingreso OC:#VarOrden#">
		<cfif varCosto GT 0>
			<cfset varDC = "C">
		<cfelse>
			<cfset varDC = "D">
		</cfif>
		<cfquery datasource="sifinterfaces">
			insert #minisifdb#..DContablesImportacion (ECIid,
			DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
			Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
			CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
			Doriginal, Dlocal, Dtipocambio, Cconcepto,
			BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
			Referencia2, Referencia3, Resultado, MSG)
			values(#varID#, 
			#varConsecutivo#,  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">, #Actperiodo#, #Actmes#, 
			'#varDetalleDesc#', null, null, '#varDC#',
			'#varCuentaIngreso#', null, null, #ws_coffice#, #varMcodigo#,
			<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCosto,"9.99"))#">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varMontoLocal,"9.99"))#">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varTC,"9.9999")#">, 0,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			#session.usucodigo#, #session.Ecodigo#, null,
			null, null, 0, null)
		</cfquery>
		<cfset varConsecutivo = varConsecutivo + 1>
		<!--- Saldo a 0 y cambio de Tipo de Movimiento --->
		<cfquery datasource="sifinterfaces">
			update DocumentoReversion
			set OriCosto = 0, TipoMovimiento = 'ACV' + TipoMovimiento
			from DocumentoReversion dr			
			where OriCosto != 0 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and TipoMovimiento like 'F%'
			and OCid = #varOCid#
			and Producto = '#varProducto#'
			and Mcodigo = #varMcodigo#
			and Modulo = 'CC'
			and IDREV = (select max(IDREV) 
						from DocumentoReversion 
						where OCid = dr.OCid 
						and Ecodigo = dr.Ecodigo
						and TipoMovimiento like 'F%'
						group by OCid,Mcodigo,Producto)
		</cfquery>
	<cfelse>
	<!--- PARA ORDENES COMERCIALES DE COMPRA --->
		<!--- Concepto de Compra --->
		<cfquery name="rsConcepto" datasource="sifinterfaces">
			select CFcomplementoCostoVenta, CFmascaraTransito
			from #minisifdb#..OCconceptoCompra
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and OCCcodigo = '00'		
		</cfquery>
		<cfif rsConcepto.recordcount EQ 0 OR rsConcepto.CFcomplementoCostoVenta EQ "">
			<cfabort showerror="No Existe el Complemento de Concepto Compra: Producto">
		<cfelse>
			<cfset varConcepto = rsConcepto.CFcomplementoCostoVenta>
			<cfset varMascaraTransito = rsConcepto.CFmascaraTransito>
			<cfquery name="rsComplArt" datasource="sifinterfaces">
				select CFcomplementoTransito 
				from #minisifdb#..OCcomplementoArticulo
				where Aid = #varAid#
			</cfquery>
			<cfset varMascaraTransito = replace(varMascaraTransito,"AAA",rsComplArt.CFcomplementoTransito)>
		</cfif>
		
		<!--- Obtiene Promedio Ponderado de TC de Compras para los Destinos Almacen--->
		<cfquery name="rsDocumentos" datasource="sifinterfaces">
			select sum(Dtotal) as Total
			from #minisifdb#..HEDocumentosCP ed 
				inner join #minisifdb#..HDDocumentosCP dd 
				on ed.CPTcodigo = dd.CPTcodigo and ed.Ddocumento = dd.Ddocumento 
				and ed.Ecodigo = dd.Ecodigo and ed.IDdocumento = dd.IDdocumento
			where dd.DDtipo = 'O'
			and dd.CPTcodigo in ('EC','DC','FC','NC')
			and dd.OCid = #varOCid#
			and dd.DDcoditem = #varAid#
			and ed.Mcodigo = #varMcodigo#
		</cfquery>
		<cfset varSuma = rsDocumentos.Total>
		<cfquery name="rsDocumentos" datasource="sifinterfaces">
			select round(sum(ed.Dtipocambio * (ed.Dtotal/#varSuma#)),4) as PorcentajeTC
			from #minisifdb#..HEDocumentosCP ed 
				inner join #minisifdb#..HDDocumentosCP dd 
				on ed.CPTcodigo = dd.CPTcodigo and ed.Ddocumento = dd.Ddocumento 
				and ed.Ecodigo = dd.Ecodigo and ed.IDdocumento = dd.IDdocumento
			where dd.DDtipo = 'O'
			and dd.CPTcodigo in ('EC','DC','FC','NC')
			and dd.OCid = #varOCid#
			and dd.DDcoditem = #varAid#
			and ed.Mcodigo = #varMcodigo#
		</cfquery>
		<cfset varTCC = rsDocumentos.PorcentajeTC>
		
		<!--- Verifica los Destinos de las Compras --->
		<cfquery datasource="sifinterfaces">
			insert into ##Destinos (Destino,OCidDestino,DestinoTipo,TC,Total)
			select distinct oc.OCcontrato as Destino,oc.OCid as OCidDestino,
					oc.OCtipoOD + oc.OCtipoIC as DestinoTipo, 0.0 as TC, 0.0 as Total
			from #minisifdb#..OCordenComercial oc
				inner join #minisifdb#..OCtransporteProducto od
					inner join #minisifdb#..OCtransporteProducto tp 
					on od.OCTid = tp.OCTid and od.Ecodigo = tp.Ecodigo and od.OCid != tp.OCid 
				on oc.OCid = od.OCid and oc.Ecodigo = od.Ecodigo 
			where od.OCtipoOD = 'D'
			and tp.OCid = #varOCid#
			and tp.Aid = #varAid#
		</cfquery>
		
		<cfquery name="rsDestinos" datasource="sifinterfaces">
			select * from ##Destinos where DestinoTipo = 'DC'
		</cfquery>
		<cfif rsDestinos.recordcount GT 0>
			<cfloop query="rsDestinos">
				<!--- Obtiene Promedio Ponderado de TC para Destinos Venta--->
				<cfquery name="rsDocumentos" datasource="sifinterfaces">
					select sum(Dtotal) as Total
					from #minisifdb#..HDocumentos ed 
						inner join #minisifdb#..HDDocumentos dd 
						on ed.CCTcodigo = dd.CCTcodigo and ed.Ddocumento = dd.Ddocumento 
						and ed.Ecodigo = dd.Ecodigo and ed.HDid = dd.HDid
					where dd.DDtipo = 'O'
					and dd.CCTcodigo in ('EC','DC','FC','NC')
					and dd.OCid = #rsDestinos.OCidDestino#
					and ed.Mcodigo = #varMcodigo#
				</cfquery>
				<cfset varSuma = rsDocumentos.Total>
				<cfquery name="rsDocumentos" datasource="sifinterfaces">
					select round(sum(ed.Dtipocambio * (ed.Dtotal/#varSuma#)),4) as PorcentajeTC
					from #minisifdb#..HDocumentos ed 
						inner join #minisifdb#..HDDocumentos dd 
						on ed.CCTcodigo = dd.CCTcodigo and ed.Ddocumento = dd.Ddocumento 
						and ed.Ecodigo = dd.Ecodigo and ed.HDid = dd.HDid
					where dd.DDtipo = 'O'
					and dd.CCTcodigo in ('EC','DC','FC','NC')
					and dd.OCid = #rsDestinos.OCidDestino#
					and ed.Mcodigo = #varMcodigo#
				</cfquery>
				<cfset varTC = rsDocumentos.PorcentajeTC>
				<cfquery datasource="sifinterfaces">
					update ##Destinos
					set TC = #varTC#, Total = #varSuma#
					where OCidDestino = #rsDestinos.OCidDestino#
				</cfquery>
			</cfloop>
		</cfif>
		<!--- Si existen Destinos Almacen Verifica con que almacenes hay relacion --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from ##Destinos where DestinoTipo = 'DI'
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset varDestinosAlmacen = true>
		<cfelse>
			<cfset varDestinosAlmacen = false>
		</cfif>
		
		<cfif varDestinosAlmacen EQ true>
			<cfquery datasource="sifinterfaces">
				insert into ##DestinosAlmacen (OCTid,Alm_Aid,TC,Total)
				select distinct tp.OCTid,oi.Alm_Aid,0.0 as TC, 0.0 as Total
				from #minisifdb#..OCinventario oi 
					inner join #minisifdb#..OCinventarioProducto op on oi.OCIid = op.OCIid
					inner join #minisifdb#..OCtransporteProducto tp on op.OCTid = tp.OCTid and tp.Ecodigo = oi.Ecodigo
					inner join #minisifdb#..Almacen a on a.Ecodigo =oi.Ecodigo and a.Aid = oi.Alm_Aid
				where oi.OCIfechaAplicacion is not null
				and tp.OCid = #varOCid#
				and op.Aid =  #varAid#
				and oi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

			<!--- para DEstinos Inventario toma el promedio ponderado de las compras --->
			<cfquery datasource="sifinterfaces">
				update ##DestinosAlmacen
				set TC = #varTCC#
			</cfquery>

			<cfquery name="rsDestinos" datasource="sifinterfaces">
				select * from ##DestinosAlmacen 
			</cfquery>
			<cfif rsDestinos.recordcount GT 0>
				<cfloop query="rsDestinos">
					<cfquery name="rsTotalAlm" datasource="sifinterfaces">
						select sum (OCIcostoValuacion) as TotalAlm
						from #minisifdb#..OCinventarioProducto op
							inner join #minisifdb#..OCinventario oi on oi.OCIid = op.OCIid and oi.Ecodigo = 8
						where op.OCTid = #rsDestinos.OCTid#
						and oi.Alm_Aid = #rsDestinos.Alm_Aid#
						and op.Aid = #varAid#
					</cfquery>
					<cfset varTotalAlm = rsTotalAlm.TotalAlm>
					<cfquery datasource="sifinterfaces">
						update ##DestinosAlmacen
						set Total = #varTotalAlm#
						where OCTid = #rsDestinos.OCTid#
						and Alm_Aid = #rsDestinos.Alm_Aid#
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
		
		<!--- Obtiene la Suma total entre destinos Almacen y Destinos Ventas --->
		<cfquery name="rsTotal" datasource="sifinterfaces">
			select sum(Total) as Total
			from ##Destinos
		</cfquery>
		<cfif rsTotal.Total EQ "">
			<cfset varTotalDes = 0>
		<cfelse>
			<cfset varTotalDes = rsTotal.Total>
		</cfif>
		<cfif varDestinosAlmacen EQ true>
			<cfquery name="rsTotal" datasource="sifinterfaces">
				select sum(Total) as Total
				from ##DestinosAlmacen
			</cfquery>
			<cfif rsTotal.Total NEQ "">
				<cfset varTotalDes = varTotalDes + rsTotal.Total>
			</cfif>
		</cfif>

		<!--- Calcula el TC Ponderado --->
		<cfif varTotalDes EQ 0 OR varTotalDes EQ "">
			<cfset varTCPond = 0>
		<cfelse>
			<cfquery name="rsTotal" datasource="sifinterfaces">
				select round(sum(TC * (Total/#varTotalDes#)),4) as TotalTC
				from ##Destinos
			</cfquery>
			<cfif rsTotal.TotalTC EQ "">
				<cfset varTCPond = 0>
			<cfelse>
				<cfset varTCPond = rsTotal.TotalTC>
			</cfif>
			<cfif varDestinosAlmacen EQ true>
				<cfquery name="rsTotal" datasource="sifinterfaces">
					select round(sum(TC * (Total/#varTotalDes#)),4) as TotalTC
					from ##DestinosAlmacen
				</cfquery>
				<cfif rsTotal.TotalTC NEQ "">
					<cfset varTCPond = varTCPond + rsTotal.TotalTC>
					<cfset varTCPond = numberformat(VarTCPond,"9.9999")>
				</cfif>
			</cfif>
		</cfif>
		<cfset varMontoLocal = numberformat(varCosto,"9.99") * numberformat(VarTCPond,"9.9999")>
		
		<!---Aplicacion de los Movimientos a La Poliza--->
		<!---Inserta linea de Ajuste--->
		<!--- Busca Consecutivo Detalle--->
		<cfquery name="rsConsecutivo" datasource="sifinterfaces">
			select MAX(DCIconsecutivo) as Consecutivo
			from #minisifdb#..DContablesImportacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and ECIid = #varID#
		</cfquery>
		<cfif rsConsecutivo.recordcount EQ 0 OR rsConsecutivo.Consecutivo EQ 0 OR rsConsecutivo.Consecutivo EQ "">
			<cfset varConsecutivo = 1>
		<cfelse>
			<cfset varConsecutivo = rsConsecutivo.Consecutivo + 1>
		</cfif>
		
		<!---Valida que existan destinos a los que ajustar --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from ##Destinos
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset varTransito = true>
			<cfquery name="rsTCtran" datasource="sifinterfaces">
				select hd.Dtipocambio
				from DocumentoReversion dr 
					inner join #minisifdb#..HEDocumentosCP hd 
					on dr.Documento = hd.Ddocumento 
					and dr.CodigoTransaccion = hd.CPTcodigo 
					and dr.SNcodigo = hd.SNcodigo 
					and dr.Ecodigo = hd.Ecodigo
				where dr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and dr.OCid = #varOCid#
				and IDREV = (select max(IDREV) 
								from DocumentoReversion 
								where OCid = dr.OCid 
								and SNcodigo != 0
								and Ecodigo = dr.Ecodigo
								group by OCid,Mcodigo,Producto)
			</cfquery>
			<cfset varTCPond = rsTCtran.Dtipocambio>
			<cfset varTCPond = numberformat(VarTCPond,"9.9999")>
			<cfset varMontoLocal = numberformat(varCosto,"9.99") * numberformat(varTCPond,"9.9999")>
		</cfif>

		<!---Balance--->
		<cfset varDetalleDesc = "Ajuste Cuenta Balance OC:#VarOrden#">
		<cfif varCosto GT 0>
			<cfset varDC = "C">
		<cfelse>
			<cfset varDC = "D">
		</cfif>
			<cfquery datasource="sifinterfaces">
				insert #minisifdb#..DContablesImportacion (ECIid,
				DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
				Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
				CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
				Doriginal, Dlocal, Dtipocambio, Cconcepto,
				BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
				Referencia2, Referencia3, Resultado, MSG)
				values(#varID#, 
				#varConsecutivo#,  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">, #Actperiodo#, #Actmes#, 
				'#varDetalleDesc#', null, null, '#varDC#',
				'#varCuentaB#', null, null, #ws_coffice#, #varMcodigo#,
				<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCosto,"9.99"))#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varMontoLocal,"9.99"))#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varTCPond,"9.9999")#">, 0,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				#session.usucodigo#, #session.Ecodigo#, null,
				null, null, 0, null)
			</cfquery>
		<cfset varConsecutivo = varConsecutivo + 1>
		<cfset varConsecutivoAjuste = varConsecutivo>
		<cfif isdefined("varTransito") AND varTransito EQ true>
			<!--- Transito --->
			<cfset varDetalleDesc = "Ajuste Cuenta Transito OC:#VarOrden# SIN DESTINOS">
			<cfif varCosto GT 0>
				<cfset varDC = "D">
			<cfelse>
				<cfset varDC = "C">
			</cfif>
			<cfquery datasource="sifinterfaces">
				insert #minisifdb#..DContablesImportacion (ECIid,
				DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
				Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
				CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
				Doriginal, Dlocal, Dtipocambio, Cconcepto,
				BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
				Referencia2, Referencia3, Resultado, MSG)
				values(#varID#, 
				#varConsecutivo#,  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">, #Actperiodo#, #Actmes#, 
				'#varDetalleDesc#', null, null, '#varDC#',
				'#varMascaraTransito#', null, null, #ws_coffice#, #varMcodigo#,
				<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCosto,"9.99"))#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varMontoLocal,"9.99"))#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varTCPond,"9.9999")#">, 0,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				#session.usucodigo#, #session.Ecodigo#, null,
				null, null, 0, null)
			</cfquery>
			<cfset varConsecutivo = varConsecutivo + 1>
		</cfif>
		
		
		<!--- DEstinos Ventas --->
		<cfquery name="rsDestinos" datasource="sifinterfaces">
			select * from ##Destinos where DestinoTipo = 'DC'
		</cfquery>
		
		<cfif rsDestinos.recordcount GT 0>
			<cfloop query="rsDestinos">
				<!--- Arma la cuenta Costo de Ventas para esta Orden Destino Venta --->
				<!--- Complemento Socio de Negocio --->
				<cfquery name="rsComplemento" datasource="sifinterfaces">
					select cuentac
					from #minisifdb#..SNegocios sn
						inner join #minisifdb#..OCordenComercial oc
						on sn.Ecodigo = oc.Ecodigo 
						and sn.SNid = oc.SNid
						and oc.Ecodigo = 8
						and oc.OCid = #rsDestinos.OCidDestino#
				</cfquery>	
				<cfif rsComplemento.recordcount EQ 0 OR rsComplemento.recordcount GT 1 OR rsComplemento.cuentac EQ "">
					<cfabort showerror="Error al Obtener el Codigo del complemento del Socio de Negocios">
				<cfelse>
					<cfset varComplementoS = "#left(rsComplemento.cuentac,3)#-#right(rsComplemento.cuentac,3)#">
				</cfif>
				
				<!--- Complemento Articulo --->
				<cfquery name="rsComplemento" datasource="sifinterfaces">
					select CFcomplementoCostoVenta
					from #minisifdb#..OCcomplementoArticulo
					where Aid = #varAid#
				</cfquery>	
				<cfif rsComplemento.recordcount EQ 0 OR rsComplemento.recordcount GT 1 OR rsComplemento.CFcomplementoCostoVenta EQ "">
					<cfabort showerror="Error al Obtener el Codigo del complemento del Articulo">
				<cfelse>
					<cfset varComplementoP =
					"#left(rsComplemento.CFcomplementoCostoVenta,3)#-#right(rsComplemento.CFcomplementoCostoVenta,3)#">
				</cfif>
				<!--- Busca cuentas de Costo Ventas --->
				<cfquery name="rsCuentas" datasource="sifinterfaces">
					select CFmascaraCostoVenta
					from #minisifdb#..OCtipoVenta ov 
						inner join #minisifdb#..OCordenComercial oc
						on ov.Ecodigo = oc.Ecodigo 
						and ov.OCVid = oc.OCVid 
						and oc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and oc.OCid =  #rsDestinos.OCidDestino#
				</cfquery>
				<cfset varCuentaCostoVenta = rsCuentas.CFmascaraCostoVenta>
		
				<cfset varCuentaCostoVenta = replace(varCuentaCostoVenta,"SSS-SSS",varComplementoS)>
				<cfset varCuentaCostoVenta = replace(varCuentaCostoVenta,"AAA-AAA",varComplementoP)>
				<cfset varCuentaCostoVenta = replace(varCuentaCostoVenta,"CCC",varConcepto)>
								
				<!--- Calcula el Monto para esta linea de ajuste --->
				<cfset Porcentaje = rsDestinos.Total/varTotalDes>
				<cfset varCostoDes = varCosto * Porcentaje>
				<cfset varCostoDesLoc = numberformat(varCostoDes,"9.99") * numberformat(VarTCPond,"9.9999")>
				<!---Ingreso--->
				<cfset varDetalleDesc = "Ajuste Cuenta Costo Venta OC:#VarOrden#">
				<cfif varCosto GT 0>
					<cfset varDC = "D">
				<cfelse>
					<cfset varDC = "C">
				</cfif>
				<cfquery datasource="sifinterfaces">
					insert #minisifdb#..DContablesImportacion (ECIid,
					DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
					Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
					CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
					Doriginal, Dlocal, Dtipocambio, Cconcepto,
					BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
					Referencia2, Referencia3, Resultado, MSG)
					values(#varID#, 
					#varConsecutivo#,  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">, #Actperiodo#, #Actmes#, 
					'#varDetalleDesc#', null, null, '#varDC#',
					'#varCuentaCostoVenta#', null, null, #ws_coffice#, #varMcodigo#,
					<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCostoDes,"9.99"))#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCostoDesLoc,"9.99"))#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varTCPond,"9.9999")#">, 0,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					#session.usucodigo#, #session.Ecodigo#, null,
					null, null, 0, null)
				</cfquery>
				<cfset varConsecutivo = varConsecutivo + 1>
			</cfloop>
		</cfif>
		<!--- DEstinos Almacen --->
		<cfif varDestinosAlmacen EQ true>
			<cfquery name="rsDestinos" datasource="sifinterfaces">
				select * from ##DestinosAlmacen
			</cfquery>
			<cfif rsDestinos.recordcount GT 0>
				<cfloop query="rsDestinos">
					<!--- Calcula el Monto para esta linea de ajuste --->
					<cfset Porcentaje = rsDestinos.Total/varTotalDes>
					<cfset varCostoDes = varCosto * Porcentaje>
					<cfset varCostoDesLoc = numberformat(varCostoDes,"9.99") * numberformat(VarTCPond,"9.9999")>
					
					<!--- Ajuste de Inventario --->
					<cfquery name="rsAjusteInv" datasource="sifinterfaces">
						select EAid 
						from #minisifdb#..EAjustes 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and Aid = #rsDestinos.Alm_Aid#
						and EAdocumento like 'A-#varOrden#-#Actperiodo##Actmes#'
					</cfquery>
					<cfif rsAjusteInv.recordcount EQ 1>
						<cfset varEAid = rsAjusteInv.EAid>
					<cfelse>
						<cfquery datasource="sifinterfaces">
							insert #minisifdb#..EAjustes (Aid,EAdescripcion,EAfecha,EAdocumento,EAusuario)
							values(#rsDestinos.Alm_Aid#,'Ajuste de Costo de Ventas Orden:#varOrden#',
									<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">,
									'A-#varOrden#-#Actperiodo##Actmes#', '#Session.usuario#')
						</cfquery>
						<cfquery name="rsIDAjuste" datasource="sifinterfaces">	
							select MAX(EAid) as EAid
							from #minisifdb#..EAjustes
						</cfquery>
						<cfset varEAid = rsIDAjuste.EAid>
					</cfif>
					<!--- Conversion del costo de Ajusta a Dolares --->
					<cfset varCostoAjuste = varCostoDes>
					<cfquery name="rsVerif" datasource="sifinterfaces">
						select *
						from #minisifdb#..Monedas where Miso4217 = 'USD'
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
					<cfset varCodigoDolar = rsVerif.Mcodigo>
					<cfquery name="rsVerif" datasource="sifinterfaces">
						select *
						from #minisifdb#..Empresas 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
					<cfset varCodigoLocal = rsVerif.Mcodigo>
					<cfif varMcodigo NEQ varCodigoDolar>
						<cfif varMcodigo NEQ varCodigoLocal>
							<!--- Se convierte a Moneda Local --->
							<cfquery name="rsVerif" datasource="sifinterfaces">
								select *
								from #minisifdb#..Htipocambio tca
								where tca.Mcodigo = #varMcodigo#
								and tca.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and tca.Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">
							</cfquery>
							<cfif rsVerif.recordcount EQ 0 OR rsVerif.TCcompra EQ "">
								<cfabort showerror="No se encuentra Tipo de cambio para la moneda de la orden #varOrden#">
							</cfif>
							<cfset varTClocal = rsVerif.TCcompra>
							<cfset varCostoAjuste = varCostoAjuste * varTCLocal>
						</cfif>
						<cfquery name="rsVerif" datasource="sifinterfaces">
							select *
							from #minisifdb#..Htipocambio tca
							where tca.Mcodigo = #varCodigoDolar#
							and tca.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and tca.Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">
						</cfquery>
						<cfif rsVerif.recordcount EQ 0 OR rsVerif.TCcompra EQ "">
							<cfabort showerror="No se encuentra Tipo de cambio para Dolar en la fecha #varFechaPoliza#">
						</cfif>
						<cfset varTCDolar = 1/rsVerif.TCcompra>
						<cfset varCostoAjuste = varCostoAjuste * varTCLocal>
					</cfif>
					<cfquery datasource="sifinterfaces">
						insert #minisifdb#..DAjustes (EAid,Aid,DAcantidad,DAcosto,DAtipo)
						values(#varEAid#,#varAid#,0,
								<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCostoAjuste,"9.99"))#">,1)
					</cfquery>
					
					<!--- Busca cuentas de Almacen --->
					<cfquery name="rsCuentaAlm" datasource="sifinterfaces">
						select c.Cformato
						from #minisifdb#..Existencias e 
							inner join #minisifdb#..IAContables a 
								inner join #minisifdb#..CContables c on a.IACinventario = c.Ccuenta and a.Ecodigo = c.Ecodigo 
							on e.IACcodigo = a.IACcodigo and e.Ecodigo = a.Ecodigo
						where e.Aid = #varAid#
						and e.Alm_Aid = #rsDestinos.Alm_Aid#
						and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
					<cfif rsCuentaAlm.recordcount EQ 0 OR rsCuentaAlm.Cformato EQ "">
						<cfabort showerror=	"NO SE LOGRO ENCONTRAR CUENTA DE ALMACEN PARA Almacenid:#rsDestinos.Alm_Aid# Articulo:#varProducto# Destino de la Orden:#varOrden#">
					<cfelse>
						<cfset varCuenaAlmacen = rsCuentaAlm.Cformato>
					</cfif>
					
					<!---Ingreso--->
					<cfset varDetalleDesc = "Ajuste Cuenta Almacen OC:#VarOrden#">
					<cfif varCosto GT 0>
						<cfset varDC = "D">
					<cfelse>
						<cfset varDC = "C">
					</cfif>
					<cfquery datasource="sifinterfaces">
						insert #minisifdb#..DContablesImportacion (ECIid,
						DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
						Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
						CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
						Doriginal, Dlocal, Dtipocambio, Cconcepto,
						BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
						Referencia2, Referencia3, Resultado, MSG)
						values(#varID#, 
						#varConsecutivo#,  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaPoliza#">, #Actperiodo#, #Actmes#, 
						'#varDetalleDesc#', null, null, '#varDC#',
						'#varCuenaAlmacen#', null, null, #ws_coffice#, #varMcodigo#,
						<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCostoDes,"9.99"))#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#abs(numberformat(varCostoDesLoc,"9.99"))#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varTCPond,"9.9999")#">, 0,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						#session.usucodigo#, #session.Ecodigo#, null,
						null, null, 0, null)
					</cfquery>
					<cfset varConsecutivo = varConsecutivo + 1>
				</cfloop>
			</cfif>
		</cfif>
		
		<!--- Ajuste de Centavos --->
		<cfquery name="rsAjusteC" datasource="sifinterfaces">
			select sum(Doriginal) as Diferencia
			from #minisifdb#..DContablesImportacion
			where ECIid = #varID#
			and DCIconsecutivo >= #varConsecutivoAjuste#
		</cfquery>
		<cfif rsAjusteC.Diferencia NEQ "" and rsAjusteC.Diferencia GT 0>
			<cfset varDiferencia = abs(varCosto) -  rsAjusteC.Diferencia>
			<cfif varDiferencia NEQ 0>
				<cfquery datasource="sifinterfaces">
					update #minisifdb#..DContablesImportacion
					set Dlocal =  (Doriginal + <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varDiferencia,"9.99")#">) * Dtipocambio,
					Doriginal = Doriginal + <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varDiferencia,"9.99")#">
					where ECIid = #varID#
					and DCIconsecutivo = #varConsecutivoAjuste#
				</cfquery>
			</cfif>
		</cfif>
		
		<!--- Saldo a 0 y cambio de Tipo de Movimiento --->
		<cfquery datasource="sifinterfaces">
			update DocumentoReversion
			set OriCosto = 0, TipoMovimiento = 'ACV' + TipoMovimiento
			from DocumentoReversion dr
			where OriCosto != 0 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and TipoMovimiento like 'F%'
			and OCid = #varOCid#
			and Producto = '#varProducto#'
			and Mcodigo = #varMcodigo#
			and Modulo = 'CP'
			and IDREV = (select max(IDREV) 
						from DocumentoReversion 
						where OCid = dr.OCid 
						and Ecodigo = dr.Ecodigo
						group by OCid,Mcodigo,Producto)
		</cfquery>
	</cfif>
	
</cftransaction>
	</cffunction>

	<cffunction name="obten_val" access="public" returntype="query">
		<cfargument name="valor" type="numeric" required="true" default="<!--- Código del Parámetro --->">
		<cfquery datasource="sifinterfaces" name="rsobten_val">
			select ltrim(rtrim(Pvalor)) as Pvalor from #minisifdb#..Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
		</cfquery>
		<cfreturn #rsobten_val#>
	</cffunction>

</cfcomponent>
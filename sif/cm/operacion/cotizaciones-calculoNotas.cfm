<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Insertar líneas de cotización a evaluar --->
<cfquery name="rsLineasEvaluar" datasource="#Session.DSN#">
	insert into CMResultadoEval (Ecodigo, CMPid, ECid, ECnumero, DClinea, DSlinea, DScant, DCcantidad, total_loc, DCgarantia, SNcodigo, DCplazoentrega, DCplazocredito, SNnombre, DSconsecutivo, Mcodigo, ECfechacot, DCpreciou, Usucodigo, fechaalta)
	select  
			a.Ecodigo,
			a.CMPid 	as id_procesocompra,
			a.ECid 		as id_cotizacion,
			a.ECnumero  as numeroCot,
			b.DClinea 	as linea_cotizacion,
			b.DSlinea 	as linea_solicitud,
			c.DScant 	as cant_solicitada,
			b.DCcantidad as cant_cotizada,
			b.DCtotallin * a.ECtipocambio as total_loc,
			b.DCgarantia as garantia,
			a.SNcodigo as Proveedor,
			b.DCplazoentrega as plazoEntrega,
			b.DCplazocredito as plazoCredito,
			d.SNnombre as nombre,
			c.DSconsecutivo,
			a.Mcodigo as Moneda,
			a.ECfechacot,
			#LvarOBJ_PrecioU.enSQL_AS("b.DCpreciou")#,
			#Session.Usucodigo# as Usucodigo,
			<cf_dbfunction name="now"> as fechaalta
	from ECotizacionesCM a 
		inner join DCotizacionesCM b
			on a.ECid = b.ECid
			and a.Ecodigo = b.Ecodigo 
			and b.DCconversion = 1
		inner join DSolicitudCompraCM c
			on b.DSlinea = c.DSlinea
			and b.Ecodigo = c.Ecodigo
		inner join SNegocios d
			on a.SNcodigo = d.SNcodigo	
			and a.Ecodigo = d.Ecodigo
	where a.Ecodigo = #Session.Ecodigo#
	and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	and a.ECestado <> 0
	and not exists (
		select 1
		from CMResultadoEval x
		where x.CMPid = a.CMPid
		and x.ECid = a.ECid
		and x.DClinea = b.DClinea
	)
</cfquery>

<cfquery name="rsAll" datasource="#Session.DSN#">
	select a.CMPid, a.ECid, a.DClinea, a.ECnumero, a.Ecodigo, a.DSlinea, a.DScant, a.DCcantidad, a.total_loc, 
		   a.DCgarantia, a.SNcodigo, a.DCplazoentrega, a.DCplazocredito, a.SNnombre, a.DSconsecutivo, a.Mcodigo, 
		   a.ECfechacot, 
		   #LvarOBJ_PrecioU.enSQL_AS("a.DCpreciou")#, 
		   a.P1, a.preNotaPrecio, a.G1, a.preNotaGarantia, a.TE1, a.preNotaTiempoEnt, 
		   a.PC1, a.preNotaPlazoCred, a.PesoPrecio, a.PesoGarantia, a.PesoTiempoEnt, a.PesoPlazoCredito, a.PesoNotaTec, 
		   a.NotaPrecio, a.NotaGarantia, a.NotaTiempoEnt, a.NotaPlazoCred, a.NotaTec, a.NotaTotalLinea, a.NotaGlobal, 
		   a.CMRsugerido, a.CMRseleccionado, a.Usucodigo, a.fechaalta, a.CMCid, a.CMRfechamod,  a.ts_rversion
	from CMResultadoEval a
	where a.Ecodigo = #Session.Ecodigo#
	and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
</cfquery>

<!--- Si existen registros para evaluar --->
<cfif isdefined('rsAll') and rsAll.recordCount GT 0>
	<!---  actualización de pesos de los conceptos a evaluar ---->
	<cfquery name="pesoPrecio" datasource="#Session.DSN#">
		update CMResultadoEval
			set PesoPrecio = (
				select CPpeso from 
				CMCondicionesProceso 
				where CCid = 2 
				and CMPid = CMResultadoEval.CMPid
			)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="pesoGarantia" datasource="#Session.DSN#">
		update CMResultadoEval
			set PesoGarantia = (
				select CPpeso 
				from CMCondicionesProceso 
				where CCid = 1
				and CMPid = CMResultadoEval.CMPid
			)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="pesoTiempoEnt" datasource="#Session.DSN#">
		update CMResultadoEval
			set PesoTiempoEnt = (
				select CPpeso 
				from CMCondicionesProceso 
				where CCid = 3
				and CMPid = CMResultadoEval.CMPid
			)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="pesoPlazoCredito" datasource="#Session.DSN#">
		update CMResultadoEval
			set PesoPlazoCredito = (
				select CPpeso 
				from CMCondicionesProceso 
				where CCid = 4
				and CMPid = CMResultadoEval.CMPid
			)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="pesoNotaTec" datasource="#Session.DSN#">
		update CMResultadoEval
			set PesoNotaTec = (
				select CPpeso 
				from CMCondicionesProceso 
				where CCid = 5
				and CMPid = CMResultadoEval.CMPid
			)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>

	<!--- 
		Calcular las líneas de cotización con la nota más alta por línea de solicitud en los conceptos evaluados
		P1 = precio mas bajo
		G1 = garantia mas alta
		TE1 = menor tiempo de entrega
		PC1 = mayor plazo de credito
	--->

	<cfquery name="rs1" datasource="#Session.DSN#">
		update CMResultadoEval set 
			P1 = (
					select min(a.total_loc)
					from CMResultadoEval a
					where a.Ecodigo = #Session.Ecodigo#
					and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
					and CMResultadoEval.DSlinea = a.DSlinea
					and a.total_loc > 0  
				),
			G1 = (
					select max(a.DCgarantia)
					from CMResultadoEval a
					where a.Ecodigo = #Session.Ecodigo#
					and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
					and CMResultadoEval.DSlinea = a.DSlinea
				),
			TE1 = (
					select coalesce(min(a.DCplazoentrega),0)
					from CMResultadoEval a
					where a.Ecodigo = #Session.Ecodigo#
					  and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
					  and CMResultadoEval.DSlinea = a.DSlinea
				),
			PC1 = (
					select max(a.DCplazocredito)
					from CMResultadoEval a
					where a.Ecodigo = #Session.Ecodigo#
					and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
					and CMResultadoEval.DSlinea = a.DSlinea
			)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>

	<!--- calculo de preNotas para cada línea de cotización comparadas con la nota de la mejor línea de cotización --->
	<cfquery name="calcPrecios" datasource="#Session.DSN#">
		update CMResultadoEval
			set preNotaPrecio = (P1 * 100.00 / total_loc)
		where P1 > 0.00	
		and total_loc > 0.00
		and Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="calcGarantia" datasource="#Session.DSN#">
		update CMResultadoEval
			set preNotaGarantia = (DCgarantia * 100.00 / G1)
		where G1 > 0.00
		and Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>

	<cfquery name="calcTiempoEnt" datasource="#Session.DSN#">
		update CMResultadoEval
			set preNotaTiempoEnt = (case when TE1 = 0 then 0.9999 else TE1 end * 100.00 / case when DCplazoentrega = 0 then 0.9999 else DCplazoentrega end)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>

	<cfquery name="calcTiempoEnt" datasource="#Session.DSN#">
		update CMResultadoEval
			set preNotaTiempoEnt = 100.00
		where DCplazoentrega = 0
		and Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="calcPlazoCred" datasource="#Session.DSN#">
		update CMResultadoEval
			set preNotaPlazoCred = (DCplazocredito * 100.00 / PC1)
		where PC1 > 0.00
		and Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<!--- calculo de Notas de las líneas de cotización de acuerdo al Peso que representa en cada concepto --->
	<cfquery name="calcNotaPrecio" datasource="#Session.DSN#">
		update CMResultadoEval
			set NotaPrecio = ((preNotaPrecio * coalesce(PesoPrecio,0)) / 100)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="calcNotaGarantia" datasource="#Session.DSN#">
		update CMResultadoEval
			set NotaGarantia = ((preNotaGarantia * coalesce(PesoGarantia,0)) / 100)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="calcNotaTiempEnt" datasource="#Session.DSN#">
		update CMResultadoEval
			set NotaTiempoEnt = ((preNotaTiempoEnt * coalesce(PesoTiempoEnt,0)) / 100)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<cfquery name="calcNotaPlazoCred" datasource="#Session.DSN#">
		update CMResultadoEval
			set NotaPlazoCred = ((preNotaPlazoCred * coalesce(PesoPlazoCredito,0)) / 100)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>

	<!--- Calculo de nota obtenidas por cada línea de cotización de acuerdo a la suma de las notas de todos los conceptos evaluados --->
	<cfquery name="rsNotaTotalLinea" datasource="#Session.DSN#">
		update CMResultadoEval
			set NotaTotalLinea = 
					coalesce(NotaPrecio, 0.00) 
					+ coalesce(NotaGarantia, 0.00) 
					+ coalesce(NotaTiempoEnt, 0.00) 
					+ coalesce(NotaPlazoCred, 0.00) 
					+ coalesce(NotaTec, 0.00)
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	
	<!--- Calculo de nota obtenidas en forma global para la cotización completa de acuerdo a la suma de las notas de todas sus líneas --->
	<cfquery name="rsNotaGlobal" datasource="#Session.DSN#">
		select ECid, sum(NotaTotalLinea) / (case count(1) when 0 then 1 else count(1) end) as nota
		from CMResultadoEval
		where Ecodigo = #Session.Ecodigo#
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		group by ECid
	</cfquery>
	
	<cfloop query="rsNotaGlobal">
		<cfquery name="updateNota" datasource="#Session.DSN#">
			update CMResultadoEval
			set NotaGlobal = <cfqueryparam cfsqltype="cf_sql_money" value="#rsNotaGlobal.nota#">
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNotaGlobal.ECid#">
			and Ecodigo = #Session.Ecodigo#
			and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		</cfquery>
	</cfloop>
</cfif>

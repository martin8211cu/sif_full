<cfcomponent>
	<!--- Esta función permite agregar impuestos y gastos declarados en una factura a una póliza de desalmacenaje por Factura --->
	<cffunction name="insertIntoDPolizaByEDIid" access="public" returntype="string">
		<cfargument name="EDIid" type="numeric" required="true">
		<cfargument name="incluyeTransaction" type="boolean" required="false" default="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.incluyeTransaction>
			<cftransaction>
			<cfreturn insertIntoDPolizaByEDIidL(Arguments.EDIid,Arguments.Debug)>
			</cftransaction>
		<cfelse>
			<cfreturn insertIntoDPolizaByEDIidL(Arguments.EDIid,Arguments.Debug)>
		</cfif>
	</cffunction>
	
	<cffunction name="insertIntoDPolizaByEDIidL" access="public" returntype="string">
		<cfargument name="EDIid" type="numeric" required="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
		</cfif>
		<cfset myResult=true>
		
		<cfquery datasource="#Session.Dsn#">
			insert into FacturasPoliza
				(EPDid, DOlinea, DDlinea, Ecodigo, SNcodigo, Cid, FMmonto, FPfecha, FPafecta, Usucodigo, fechaalta)
			select ddi.EPDid, ddi.DOlinea, ddi.DDlinea, ddi.Ecodigo, edi.SNcodigo, ddi.Cid, 
				ddi.DDItotallinea * edi.EDItc, 
				edi.EDIfecha, ddi.DDIafecta,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			from EDocumentosI edi
				inner join DDocumentosI ddi
					on ddi.EDIid = edi.EDIid
					and ddi.Ecodigo = edi.Ecodigo
					and ddi.DDIafecta in (1,2,4)
					and ddi.EPDid is not null
					and ddi.DDlinea not in  (
						select y.DDlinea from EPolizaDesalmacenaje x
							inner join FacturasPoliza y
								on x.EPDid = y.EPDid
								and x.Ecodigo = y.Ecodigo
						where x.EPDestado = 0
						and x.Ecodigo = edi.Ecodigo
					)
			where edi.EDIimportacion = 1
				and edi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
				and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<!--- Si se va a agregar un impuesto de ventas por servicios,
			  se verifica que existan en la misma factura líneas
			  de fletes, o seguros, o gastos --->
		<cfquery name="rsValidaImpuestos" datasource="#session.dsn#">
			select 1
			from DDocumentosI ddi
			where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
				and ddi.DDIafecta = 5
				and ddi.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
				and ddi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfif rsValidaImpuestos.RecordCount gt 0>
			<cfquery name="rsLineasFSG" datasource="#session.dsn#">
				select 1
				from DDocumentosI ddi
				where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
					and ddi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ddi.DDIafecta in (1, 2, 4)
			</cfquery>
			
			<cfif rsLineasFSG.RecordCount eq 0>
				<cf_errorCode	code = "50890" msg = "No se puede agregar impuesto de ventas por servicios si no existen líneas de fletes, seguros o gastos en la factura">
			</cfif>
		</cfif>

		<!--- Inserta las líneas de impuestos --->
		<cfquery name="insertimpuestos" datasource="#session.dsn#">
			insert into CMImpuestosPoliza
				(EPDid, Ecodigo, DDlinea, Icodigo, CMIPmonto, CMIPcridotfiscal, Usucodigo, fechaalta)
			select ddi.EPDid, ddi.Ecodigo, ddi.DDlinea, ddi.Icodigo, ddi.DDItotallinea * edi.EDItc, i.Icreditofiscal,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			from EDocumentosI edi
				inner join DDocumentosI ddi
					on ddi.EDIid = edi.EDIid
					and ddi.Ecodigo = edi.Ecodigo
					and ddi.DDIafecta = 5
					and ddi.DDlinea not in  (
						select y.DDlinea from EPolizaDesalmacenaje x
							inner join CMImpuestosPoliza y
								on x.EPDid = y.EPDid
								and x.Ecodigo = y.Ecodigo
						where x.Ecodigo = edi.Ecodigo
					)
				inner join Impuestos i
					on i.Icodigo = ddi.Icodigo
					and i.Ecodigo = ddi.Ecodigo
			where edi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
				and edi.EDIimportacion = 1
				and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfif Arguments.Debug>
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join FacturasPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join CMImpuestosPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cftransaction action="rollback"/>
		</cfif>
		<cfreturn myResult>
	</cffunction>
	
	<!--- Esta función permite agregar impuestos y gastos declarados en una factura a una póliza de desalmacenaje por Línea de Factura --->
	<cffunction name="insertIntoDPolizaByDDlinea" access="public" returntype="string">
		<cfargument name="DDlinea" type="numeric" required="true">
		<cfargument name="incluyeTransaction" type="boolean" required="false" default="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.incluyeTransaction>
			<cftransaction>
			<cfreturn insertIntoDPolizaByDDlineaL(Arguments.DDlinea,Arguments.Debug)>
			</cftransaction>
		<cfelse>
			<cfreturn insertIntoDPolizaByDDlineaL(Arguments.DDlinea,Arguments.Debug)>
		</cfif>
	</cffunction>
	<cffunction name="insertIntoDPolizaByDDlineaL" access="public" returntype="string">
		<cfargument name="DDlinea" type="numeric" required="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
		</cfif>
		<cfset myResult=true>
		<cfquery datasource="#Session.Dsn#">
			insert into FacturasPoliza
				(EPDid, DOlinea, DDlinea, Ecodigo, SNcodigo, Cid, FMmonto, FPfecha, FPafecta, Usucodigo, fechaalta)
			select ddi.EPDid, ddi.DOlinea, ddi.DDlinea, ddi.Ecodigo, edi.SNcodigo, ddi.Cid, 
				round(ddi.montorestante * edi.EDItc,2), 
				edi.EDIfecha, ddi.DDIafecta,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			from EDocumentosI edi
				inner join DDocumentosI ddi
					on ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
					and ddi.EDIid = edi.EDIid
					and ddi.Ecodigo = edi.Ecodigo
					and ddi.cantidadrestante > 0
					and ddi.DDIafecta in (1,2,4)
					and ddi.EPDid is not null
					and ddi.DDlinea not in  (
						select y.DDlinea from EPolizaDesalmacenaje x
							inner join FacturasPoliza y
								on x.EPDid = y.EPDid
								and x.Ecodigo = y.Ecodigo
						where x.EPDestado = 0
						and x.Ecodigo = edi.Ecodigo
					)
			where edi.EDIestado = 10
				and edi.EDIimportacion = 1
				and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery datasource="#Session.Dsn#">
			insert into CMImpuestosPoliza
				(EPDid, Ecodigo, DDlinea, Icodigo, CMIPmonto, CMIPcridotfiscal, Usucodigo, fechaalta)
			select ddi.EPDid, ddi.Ecodigo, ddi.DDlinea, ddi.Icodigo, 
				round(ddi.montorestante * edi.EDItc,2), 
				i.Icreditofiscal,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			from EDocumentosI edi
				inner join DDocumentosI ddi
						inner join Impuestos i
							on i.Icodigo = ddi.Icodigo
							and i.Ecodigo = ddi.Ecodigo
					on ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
					and ddi.EDIid = edi.EDIid
					and ddi.Ecodigo = edi.Ecodigo
					and ddi.cantidadrestante > 0
					and ddi.DDIafecta = 5
					and ddi.EPDid is not null
					and ddi.DDlinea not in  (
						select y.DDlinea from EPolizaDesalmacenaje x
							inner join CMImpuestosPoliza y
								on x.EPDid = y.EPDid
								and x.Ecodigo = y.Ecodigo
						where x.EPDestado = 0
						and x.Ecodigo = edi.Ecodigo
					)
			where edi.EDIestado = 10
				and edi.EDIimportacion = 1
				and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif Arguments.Debug>
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join FacturasPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#"><cfabort>
			</cfquery>
			<cfdump var="#rsDebug#">
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join CMImpuestosPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cftransaction action="rollback"/>
		</cfif>
		<cfreturn myResult>
	</cffunction>
	
	<!--- Esta función permite cambiar impuestos y gastos declarados en una factura a una póliza de desalmacenaje por Factura --->
	<cffunction name="updateDPolizaByEDIid" access="public" returntype="string">
		<cfargument name="EDIid" type="numeric" required="true">
		<cfargument name="incluyeTransaction" type="boolean" required="false" default="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.incluyeTransaction>
			<cftransaction>
			<cfreturn updateDPolizaByEDIidL(Arguments.EDIid,Arguments.Debug)>
			</cftransaction>
		<cfelse>
			<cfreturn updateDPolizaByEDIidL(Arguments.EDIid,Arguments.Debug)>
		</cfif>
	</cffunction>
	<cffunction name="updateDPolizaByEDIidL" access="public" returntype="string">
		<cfargument name="EDIid" type="numeric" required="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
		</cfif>
		<cfset myResult=true>
		<cfquery name="rsForUpdate" datasource="#Session.Dsn#">
			select ddi.EPDid, ddi.DOlinea, ddi.DDlinea, ddi.Ecodigo, edi.SNcodigo, ddi.Cid, 
				round(ddi.montorestante * edi.EDItc,2) as Monto, 
				edi.EDIfecha, ddi.DDIafecta,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			from EDocumentosI edi
				inner join DDocumentosI ddi
					on ddi.EDIid = edi.EDIid
					and ddi.Ecodigo = edi.Ecodigo
					and ddi.cantidadrestante > 0
					and ddi.DDIafecta in (1,2,4,5)
					and ddi.EPDid is not null
					and ddi.DDlinea not in  (
						select y.DDlinea from EPolizaDesalmacenaje x
							inner join FacturasPoliza y
								on x.EPDid = y.EPDid
								and x.Ecodigo = y.Ecodigo
						where x.EPDestado = 0
						and x.Ecodigo = edi.Ecodigo
						and x.EPDid <> ddi.EPDid
					)
					and ddi.DDlinea not in  (
						select y.DDlinea from EPolizaDesalmacenaje x
							inner join CMImpuestosPoliza y
								on x.EPDid = y.EPDid
								and x.Ecodigo = y.Ecodigo
						where x.EPDestado = 0
						and x.Ecodigo = edi.Ecodigo
						and x.EPDid <> ddi.EPDid
					)
			where edi.EDIestado = 10
				and edi.EDIimportacion = 1
				and edi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
				and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfloop query="rsForUpdate">
			<cfif rsForUpdate.DDIafecta neq 5>
				<cfquery datasource="#Session.Dsn#">
					update FacturasPoliza
					set 
						SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForUpdate.SNcodigo#">
						, FMmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#rsForUpdate.Monto#">
						, Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where 
						Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForUpdate.DDlinea#">
				</cfquery>
			<cfelse>
				<cfquery datasource="#Session.Dsn#">
					update CMImpuestosPoliza
					set 
						CMIPmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#rsForUpdate.Monto#">
						, Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where 
						Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForUpdate.DDlinea#">
				</cfquery>
			</cfif>
		</cfloop>
		<cfif Arguments.Debug>
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join FacturasPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join CMImpuestosPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cftransaction action="rollback"/>
		</cfif>
		<cfreturn myResult>
	</cffunction>
	
	<!--- Esta función permite cambiar impuestos y gastos declarados en una factura a una póliza de desalmacenaje por Línea de Factura --->
	<cffunction name="updateDPolizaByDDlinea" access="public" returntype="string">
		<cfargument name="DDlinea" type="numeric" required="true">
		<cfargument name="incluyeTransaction" type="boolean" required="false" default="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.incluyeTransaction>
			<cftransaction>
			<cfreturn updateDPolizaByDDlineaL(Arguments.DDlinea,Arguments.Debug)>
			</cftransaction>
		<cfelse>
			<cfreturn updateDPolizaByDDlineaL(Arguments.DDlinea,Arguments.Debug)>
		</cfif>
	</cffunction>
	<cffunction name="updateDPolizaByDDlineaL" access="public" returntype="string">
		<cfargument name="DDlinea" type="numeric" required="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
		</cfif>
		<cfset myResult=true>
		<cfquery name="rsForUpdate" datasource="#Session.Dsn#">
			select ddi.EPDid, ddi.DOlinea, ddi.DDlinea, ddi.Ecodigo, edi.SNcodigo, ddi.Cid, 
				round(ddi.montorestante * edi.EDItc,2) as Monto, 
				edi.EDIfecha, ddi.DDIafecta,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			from EDocumentosI edi
				inner join DDocumentosI ddi
					on ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
					and ddi.EDIid = edi.EDIid
					and ddi.Ecodigo = edi.Ecodigo
					and ddi.cantidadrestante > 0
					and ddi.DDIafecta in (1,2,4,5)
					and ddi.EPDid is not null
					and ddi.DDlinea not in  (
						select y.DDlinea from EPolizaDesalmacenaje x
							inner join FacturasPoliza y
								on x.EPDid = y.EPDid
								and x.Ecodigo = y.Ecodigo
						where x.EPDestado = 0
						and x.Ecodigo = edi.Ecodigo
						and x.EPDid <> ddi.EPDid
					)
					and ddi.DDlinea not in  (
						select y.DDlinea from EPolizaDesalmacenaje x
							inner join CMImpuestosPoliza y
								on x.EPDid = y.EPDid
								and x.Ecodigo = y.Ecodigo
						where x.EPDestado = 0
						and x.Ecodigo = edi.Ecodigo
						and x.EPDid <> ddi.EPDid
					)
			where edi.EDIestado = 10
				and edi.EDIimportacion = 1
				and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsForUpdate.RecordCount>
			<cfif rsForUpdate.DDIafecta neq 5>
				<cfquery datasource="#Session.Dsn#">
					update FacturasPoliza
					set 
						SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForUpdate.SNcodigo#">
						, FMmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#rsForUpdate.Monto#">
						, Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where 
						Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
				</cfquery>
			<cfelse>
				<cfquery datasource="#Session.Dsn#">
					update CMImpuestosPoliza
					set 
						CMIPmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#rsForUpdate.Monto#">
						, Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where 
						Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
				</cfquery>
			</cfif>
		</cfif>
		<cfif Arguments.Debug>
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join FacturasPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join CMImpuestosPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cftransaction action="rollback"/>
		</cfif>
		<cfreturn myResult>
	</cffunction>
	
	<!--- Esta función permite agregar impuestos y gastos declarados en una factura a una póliza de desalmacenaje por Factura --->
	<cffunction name="deleteDPolizaByEDIid" access="public" returntype="string">
		<cfargument name="EDIid" type="numeric" required="true">
		<cfargument name="incluyeTransaction" type="boolean" required="false" default="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.incluyeTransaction>
			<cftransaction>
			<cfreturn deleteDPolizaByEDIidL(Arguments.EDIid,Arguments.Debug)>
			</cftransaction>
		<cfelse>
			<cfreturn deleteDPolizaByEDIidL(Arguments.EDIid,Arguments.Debug)>
		</cfif>
	</cffunction>
	<cffunction name="deleteDPolizaByEDIidL" access="public" returntype="string">
		<cfargument name="EDIid" type="numeric" required="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
		</cfif>
		<cfset myResult=true>
		<cfquery datasource="#Session.Dsn#">
			delete from FacturasGastoItem
			where 
				FPid in
				(
					select fp.FPid 
					from DDocumentosI ddi
						inner join FacturasPoliza  fp
						on fp.DDlinea = ddi.DDlinea
						and fp.Ecodigo = ddi.Ecodigo
					where ddi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
				)
		</cfquery>
		<cfquery datasource="#Session.Dsn#">
			delete from FacturasPoliza
			where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DDlinea in
				(
					select ddi.DDlinea
					from DDocumentosI ddi
					where ddi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
				)
		</cfquery>
		<cfquery datasource="#Session.Dsn#">
			delete from CMImpuestosItem
			where 
				Icodigo in
				(
					select fp.Icodigo
					from DDocumentosI ddi
						inner join CMImpuestosPoliza fp
						on fp.DDlinea = ddi.DDlinea
						and fp.Ecodigo = ddi.Ecodigo
					where ddi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
				)
		</cfquery>
		<cfquery datasource="#Session.Dsn#">
			delete from CMImpuestosPoliza
			where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DDlinea in
				(
					select ddi.DDlinea
					from DDocumentosI ddi
					where ddi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
				)
		</cfquery>
		<cfif Arguments.Debug>
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join FacturasPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join CMImpuestosPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDIid#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cftransaction action="rollback"/>
		</cfif>
		<cfreturn myResult>
	</cffunction>
	
	<!--- Esta función permite agregar impuestos y gastos declarados en una factura a una póliza de desalmacenaje por Línea de Factura --->
	<cffunction name="deleteDPolizaByDDlinea" access="public" returntype="string">
		<cfargument name="DDlinea" type="numeric" required="true">
		<cfargument name="incluyeTransaction" type="boolean" required="false" default="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.incluyeTransaction>
			<cftransaction>
			<cfreturn deleteDPolizaByDDlineaL(Arguments.DDlinea,Arguments.Debug)>
			</cftransaction>
		<cfelse>
			<cfreturn deleteDPolizaByDDlineaL(Arguments.DDlinea,Arguments.Debug)>
		</cfif>
	</cffunction>
	<cffunction name="deleteDPolizaByDDlineaL" access="public" returntype="string">
		<cfargument name="DDlinea" type="numeric" required="true">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
		</cfif>
		<cfset myResult=true>
		<cfquery datasource="#Session.Dsn#">
			delete from FacturasGastoItem
			where 
				FPid in
				(
					select FPid 
					from FacturasPoliza 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
				)
		</cfquery>
		<cfquery datasource="#Session.Dsn#">
			delete from FacturasPoliza
			where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
		</cfquery>
		<cfquery datasource="#Session.Dsn#">
			delete from CMImpuestosItem
			where 
				Icodigo in
				(
					select Icodigo
					from CMImpuestosPoliza
					where 
						Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
				)
		</cfquery>
		<cfquery datasource="#Session.Dsn#">
			delete from CMImpuestosPoliza
			where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
		</cfquery>
		<cfif Arguments.Debug>
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join FacturasPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cfquery name="rsDebug" datasource="#session.dsn#">
				select fp.*
				from DDocumentosI ddi
					inner join CMImpuestosPoliza fp
						on ddi.DDlinea = fp.DDlinea
						and ddi.Ecodigo = fp.Ecodigo
				where ddi.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DDlinea#">
			</cfquery>
			<cfdump var="#rsDebug#">
			<cftransaction action="rollback"/>
		</cfif>
		<cfreturn myResult>
	</cffunction>

</cfcomponent>


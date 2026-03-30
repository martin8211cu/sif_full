<cfcomponent displayname="CM_ImportaCotizaciones" hint="Importa Cotizaciones Capturadas en sifpublica y las inserta en 'dsn' en EContizacionesCM y DCotizacionesCM">
	<cfset CM_precioU = createobject("component","sif.Componentes.CM_PrecioU").init()>	
	<cffunction access="public" displayname="CM_ObtieneCotizaciones" hint="Obtiene Cotizaciones Capturadas en sifpublica" name="CM_ObtieneCotizaciones" output="false" returntype="query">
		<cfargument name="Ecodigo" required="no" type="numeric" hint="Código de la Empresa" default="#Session.Ecodigo#">
		<cfargument name="Conexion" required="no" type="string" hint="Nombre del Cache" default="#Session.dsn#">
		<cfargument name="Usucodigo" required="no" type="string" hint="Nombre del Cache" default="#Session.Usucodigo#">
		<cfargument name="CMPid" required="no" type="string" hint="Lista de Procesos de Compra" default="">
		<!--- Consulta sifpublica  --->
		<!--- SNcodigo, CMCid, Icodigo, Ucodigo --->
		<cfquery name="qry_select" datasource="sifpublica">
			select c.CMPid, c.Ecodigo, 0 as SNcodigo, 0 as CMCid 
				, a.CPnumero as ECnumprov 
				, a.CPid, a.Mcodigo, a.CPtipocambio 
				, a.CPdescripcion as ECdescprov, a.CPobs as ECobsprov, a.CPprocesado as ECprocesado 
				, a.CPsubtotal as ECsubtotal, a.CPtotdesc as ECtotdesc, a.CPtotimp as ECtotimp 
				, a.CPtotal as ECtotal, a.CPfechacoti as ECfechacot
				, d.DSlinea
				, b.DCPcantidad as DCcantidad, b.DCPpreciou as DCpreciou, b.DCPgarantia as DCgarantia, b.DCPplazocredito as DCplazocredito
				, b.DCPplazoentrega as DCplazoentrega, '' as Icodigo, b.DCPimpuestos as DCporcimpuesto, DCPdesclin as DCdesclin
				, b.DCPtotimp as DCtotimp, b.DCPtotallin as DCtotallin, coalesce(nullif(ltrim(rtrim(b.DCPdescprov)),' '), d.DSdescripcion) as DCdescprov, b.DCPunidadcot as DCunidadcot 
				, b.DCPconversion as DCconversion, '' as Ucodigo
				, a.UsucodigoP , c.UsucodigoC, c.EcodigoASP 
				, a.CMIid, a.CMFPid, a.ECfechavalido
			from CotizacionesProveedor a
			inner join DCotizacionProveedor b
				on b.CPid = a.CPid
			inner join ProcesoCompraProveedor c
				on c.PCPid = a.PCPid
				and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			inner join LineasProcesoCompras d
				on d.LPCid = b.LPCid
			where a.CPestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="10"> --cotizacion pública aplicada
			and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMPid#">
		</cfquery>
		<cfloop query="qry_select">
			<cfquery name="rsProveedor" datasource="asp">
				select llave as SNcodigo
				from UsuarioReferencia e
				where e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.UsucodigoP#">
				and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.EcodigoASP#">
				and e.STabla = 'SNegocios'
			</cfquery>
			
			<cfset QuerySetCell(qry_select, "SNcodigo", rsProveedor.SNcodigo, currentRow)>
			<cfquery name="rsComprador" datasource="asp">
				select llave as CMCid
				from UsuarioReferencia e
				where e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.UsucodigoC#">
				and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.EcodigoASP#">
				and e.STabla = 'CMCompradores'
			</cfquery>

			<cfset QuerySetCell(qry_select, "CMCid", rsComprador.CMCid, currentRow)>
			<cfquery name="rsDetalle" datasource="#Arguments.Conexion#">
				select Icodigo, Ucodigo
				from DSolicitudCompraCM f
				where f.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.DSlinea#">
				and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#qry_select.Ecodigo#">
			</cfquery>

			<cfset QuerySetCell(qry_select, "Icodigo", rsDetalle.Icodigo, currentRow)>
			<cfset QuerySetCell(qry_select, "Ucodigo", rsDetalle.Ucodigo, currentRow)>
		</cfloop>
		<cfreturn qry_select>
	</cffunction>
	
	<cffunction access="public" displayname="CM_ImportaCotizaciones" hint="Importa Cotizaciones Capturadas en sifpublica y las inserta en 'dsn' en EContizacionesCM y DCotizacionesCM" name="CM_ImportaCotizaciones" output="true" returntype="boolean">
		<cfargument name="Ecodigo" required="no" type="numeric" hint="Código de la Empresa" default="#Session.Ecodigo#">
		<cfargument name="Conexion" required="no" type="string" hint="Nombre del Cache" default="#Session.dsn#">
		<cfargument name="Usucodigo" required="no" type="string" hint="Nombre del Cache" default="#Session.Usucodigo#">
		<cfargument name="CMPid" required="no" type="string" hint="Lista de Procesos de Compra" default="">
		<cfargument name="Debug" required="no" type="boolean" hint="Debug" default="false">
		<!--- Trae las Cotizaciones por importar y sus detalles --->
		<cfinvoke component="CM_ImportaCotizaciones" method="CM_ObtieneCotizaciones" returnvariable="qry_select">
				<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#">
				<cfinvokeargument name="Conexion" value="#Arguments.Conexion#">
				<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo#">
				<cfinvokeargument name="CMPid" value="#Arguments.CMPid#">
		</cfinvoke>
			<!--- Para cada cotización inserta un encabecado de cotización y sus detalles --->
			<cfoutput query="qry_select" group="CPid">
				<!--- Inicia Transacción en Arguments.Conexion --->
				<cftransaction action="begin">
				<!--- Borra la Cotización si ya fue importada para actualizarla --->
				<!--- Obtiene el Consecutivo --->
				<cfquery name="qry_consec" datasource="#Arguments.Conexion#">
					select coalesce(max(ECconsecutivo),0)+1 as ECconsecutivo
					from ECotizacionesCM
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfquery>
				
<!--- <cfdump var="#qry_select#">

<cf_abort errorInterfaz=""> --->
				
				<!--- Inserta el encabezado de la cotización --->
				<cfquery name="qry_insert" datasource="#Arguments.Conexion#">
					insert into ECotizacionesCM 
						(CMPid, Ecodigo, SNcodigo, CMCid, 
						ECconsecutivo, ECnumero, ECnumprov, 
						CPid, Mcodigo, ECtipocambio,
						ECdescprov, ECobsprov, ECprocesado, 
						ECsubtotal, ECtotdesc, ECtotimp, 
						ECtotal, ECfechacot, ECestado, 
						CMIid, CMFPid, ECfechavalido,
						Usucodigo, fechaalta)
					values
						(<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.CMPid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.SNcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.CMCid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_consec.ECconsecutivo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#qry_select.ECnumprov#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#qry_select.ECnumprov#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.CPid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.Mcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_float" value="#qry_select.CPtipocambio#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_select.ECdescprov#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_select.ECobsprov#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_select.ECprocesado#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#qry_select.ECsubtotal#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#qry_select.ECtotdesc#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#qry_select.ECtotimp#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#qry_select.ECtotal#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#qry_select.ECfechacot#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="10">, --cotizacion local aplicada
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.CMIid#" null="#Len(Trim(qry_select.CMIid)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.CMFPid#" null="#Len(Trim(qry_select.CMFPid)) EQ 0#">,
						<cfif Len(Trim(qry_select.ECfechavalido))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_select.ECfechavalido#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					<cf_dbidentity1 datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 datasource="#Arguments.Conexion#" name="qry_insert">
				<!--- Inserta los detalles de la cotización --->
				<cfoutput>
					<cfquery name="qry_insert_det" datasource="#Arguments.Conexion#">
						insert into DCotizacionesCM 
							(ECid, CMPid, DSlinea, Ecodigo, 
							DCcantidad, DCpreciou, DCgarantia, DCplazocredito, 
							DCplazoentrega, Icodigo, DCporcimpuesto, DCdesclin, 
							DCtotimp, DCtotallin, DCdescprov, DCunidadcot, 
							DCconversion, Ucodigo)
						values
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_insert.identity#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.CMPid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.DSlinea#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_float" value="#qry_select.DCcantidad#">, 
							#CM_precioU.enCF(qry_select.DCpreciou)#, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.DCgarantia#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.DCplazocredito#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_select.DCplazoentrega#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_select.Icodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_float" value="#qry_select.DCporcimpuesto#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#qry_select.DCdesclin#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#qry_select.DCtotimp#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#qry_select.DCtotallin#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_select.DCdescprov#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_select.DCunidadcot#">, 
							<cfqueryparam cfsqltype="cf_sql_float" value="#qry_select.DCconversion#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_select.Ucodigo#">)
					</cfquery>
				</cfoutput><!--- qry_select : detalles --->
				</cftransaction>
				<!--- Actualiza la Cotización del Proveedor --->
				<cfquery name="qry_update" datasource="sifpublica">
					update CotizacionesProveedor
					set CPestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="20"> --cotizacion pública importada
					where CPid = #qry_select.CPid#
				</cfquery>
			</cfoutput><!--- qry_select : encabezado --->
			<cfif Arguments.Debug>
				<cfdump var="#qry_select#">
				<cfset cpidlist = "">
				<cfoutput query="qry_select" group="CPid">
					<cfset cpidlist = cpidlist & "," & CPid>
				</cfoutput>
				<cfset cpidlist = Mid(cpidlist,2,Len(cpidlist)-1)>
				<cfquery name="rs" datasource="minisif">
					select * from ECotizacionesCM where CPid in (#cpidlist#)
				</cfquery>
				<cfdump var="#rs#">
				<cfquery name="rsd" datasource="minisif">
					select * from DCotizacionesCM det inner join ECotizacionesCM enc on det.ECid = enc.ECid and enc.CPid in (#cpidlist#)	
				</cfquery>
				<cfdump var="#rsd#">
			</cfif>
		<cfreturn true>
	</cffunction>

</cfcomponent>
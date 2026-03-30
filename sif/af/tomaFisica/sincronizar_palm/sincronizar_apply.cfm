<cfsetting enablecfoutputonly="yes" requesttimeout="600000">
<cfset LvarPrueba = false>

<cfif isdefined("form.btnDownload")>

	<cfquery name="rsEmpresas" datasource="#session.dsn#">
		select Ecodigo
		  from Empresas
		 where cliente_empresarial = #session.CEcodigo#
	</cfquery>
	<cfset LvarEmpresas = ValueList(rsEmpresas.Ecodigo)>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from AFTFHojaConteo a
		 where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
		   and AFTFestatus_hoja = 1
		   and AFTFid_dispositivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTFid_dispositivo#">
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cf_errorCode	code = "50138"
						msg  = "No existen Hojas de Conteo en Estado '1=En Dispositivo Móvil: @errorDat_1@'"
						errorDat_1="#form.AFTFcodigo_dispositivo#"
		>
	</cfif>

	<cfquery name="verificaRH" datasource="#session.dsn#">
		select count(1) as Cantidad
		  from DatosEmpleado a
			inner join LineaTiempo b
				 on b.Ecodigo = a.Ecodigo
		  		and b.DEid = a.DEid
				and <cf_dbfunction name="today">
					between b.LTdesde and b.LThasta 
			inner join RHPlazas c
				 on c.Ecodigo = a.Ecodigo
				and c.RHPid = b.RHPid
		where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
	</cfquery>

	<cfoutput>
	<cfif verificaRH.Cantidad GT 0>
		<!--- Sincronizar: Datos Empleado a Empleados --->
			<cfsavecontent variable="myquery">
			select 	a.Ecodigo,
					a.DEid				as ID,
					a.DEidentificacion	as Cedula,
					<cf_dbfunction name="concat" args="a.DEapellido1 ,' ',a.DEapellido2 ,' ' ,a.DEnombre"> 
										as Nombre,
					a.DEtelefono1		as Telefono,
					c.CFid				as IDCentroCosto
			  from DatosEmpleado a
				inner join LineaTiempo b
					 on b.Ecodigo = a.Ecodigo
					and b.DEid = a.DEid
				    and <cf_dbfunction name="today">
						between b.LTdesde and b.LThasta 
				inner join RHPlazas c
					 on c.Ecodigo = a.Ecodigo
					and c.RHPid = b.RHPid
			where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
			</cfsavecontent>
	<cfelse>
			<cfsavecontent variable="myquery">
			select 	a.Ecodigo,
					a.DEid				as ID,
					a.DEidentificacion	as Cedula,
					<cf_dbfunction name="concat" args="a.DEapellido1 ,' ',a.DEapellido2 ,' ' ,a.DEnombre"> 
										as Nombre,
					a.DEtelefono1		as Telefono,
					b.CFid				as IDCentroCosto
			  from DatosEmpleado a
				inner join EmpleadoCFuncional b
					 on b.Ecodigo = a.Ecodigo
					and b.DEid = a.DEid
				    and <cf_dbfunction name="today">
						between b.ECFdesde and b.ECFhasta 
			where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
			</cfsavecontent>
	</cfif>
	</cfoutput>

	<!--- DOWNLOAD --->
	<cfheader name="Content-Disposition" value="Attachment;filename=SIFHH_#dateFormat(now(),"YYYYMMDD")#.xml">
	<cfheader name="Expires" value="0">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfcontent type="text/xml">
	
	<cfflush interval="32">


	<cfoutput><?xml version="1.0" standalone="yes"?>
<TablesStructureDataSet xmlns="http://tempuri.org/TablesStructureDataSet.xsd">

	<!-- Registro de Control -->
	<Control>
		<Operacion>Download</Operacion>
		<Dispositivo>#form.AFTFcodigo_dispositivo#</Dispositivo>
		<Fecha>#fnXMLdate(now())#</Fecha>
	</Control>
	</cfoutput>

	<cftry>
	<!--- Sincronizar: Centro Funcional a Centros de Costos --->
	<cf_jdbcquery_open name="rsSQL" datasource="#session.dsn#">
		<cfoutput>
		select 	a.Ecodigo,
				a.CFid			as ID,
				a.CFcodigo		as Codigo,
				a.CFdescripcion	as Nombre,
				<cf_dbfunction name="concat" args="rtrim(o.Oficodigo),' - ',o.Odescripcion"> as Sucursal,
				d.ciudad		as Ubicacion,
				o.telefono
		from CFuncional a
			inner join Oficinas o
				 on o.Ecodigo = a.Ecodigo
				and o.Ocodigo = a.Ocodigo
			left join Direcciones d
				 on d.id_direccion = o.id_direccion
		where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
		</cfoutput>
	</cf_jdbcquery_open>
	
	<!-- Sincronizar: Centro Funcional a Centros de Costos -->
	<cfoutput query="rsSQL">
	<CentrosCostosTbl>
		<ID>#ID#</ID>
		<Codigo>#fnXmlString(Codigo,10)#</Codigo>
		<Nombre>#fnXmlString(Nombre,30)#</Nombre>
		<Sucursal>#fnXmlString(Sucursal,30)#</Sucursal>
		<Ubicacion>#fnXmlString(Ubicacion,30)#</Ubicacion>
		<Telefono>#fnXmlString(Telefono,20)#</Telefono>
		<Ecodigo>#Ecodigo#</Ecodigo>
	</CentrosCostosTbl>

	</cfoutput>
	<cf_jdbcquery_close>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfrethrow>
	</cfcatch>
	</cftry>
	
	<cftry>
	<cf_jdbcquery_open name="rsSQL" datasource="#session.dsn#">
	<cfoutput>
		#preservesinglequotes(myquery)#
	</cfoutput>
	</cf_jdbcquery_open>

	<!-- Sincronizar: Datos Empleado a Empleados -->
	<cfoutput query="rsSQL">
	<EmpleadoTbl>
		<ID>#ID#</ID>
		<Cedula>#fnXmlString(Cedula,20)#</Cedula>
		<Nombre>#fnXmlString(Nombre,30)#</Nombre>
		<Telefono>#fnXmlString(Telefono,20)#</Telefono>
		<IDCentroCosto>#IDCentroCosto#</IDCentroCosto>
		<Ecodigo>#Ecodigo#</Ecodigo>
	</EmpleadoTbl>
	</cfoutput>
	<cf_jdbcquery_close>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfrethrow>
	</cfcatch>
	</cftry>

	<cftry>
	<!--- Sincronizar: Activos --->
	<cf_jdbcquery_open name="rsSQL" datasource="#session.dsn#">
		<cfoutput>
		select  'false'				as EsNuevo,
				a.Ecodigo, 
				a.Aid				as ID,
				b.Adescripcion		as Descripcion,
				b.Aplaca 			as Placa,
				b.Aserie 			as Serie,
				g.AFMdescripcion	as Marca,
				h.AFMMdescripcion	as Modelo,            
				ta.TAfecha			as FechaCompra,
				coalesce(a.AFSsaldovutiladq,0) 
									as SaldoVidaUtil,
				ta.TAmontooriadq	as Costo,
				coalesce((AFSvaladq + AFSvalmej  + AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev) , 0.00)
									as ValorLibros,
				b.Astatus			as Estado,
				' ' 				as Observaciones
		  from AFSaldos a
			inner join Activos b
				 on a.Aid = b.Aid
				and a.Ecodigo = b.Ecodigo
			<cfif LvarPrueba>
				inner join AFTFDHojaConteo hd
				inner join AFTFHojaConteo he
				on he.AFTFid_hoja = hd.AFTFid_hoja
				and AFTFestatus_hoja = 1
				on hd.Aid = b.Aid
			</cfif>
			inner join TransaccionesActivos ta
				 on ta.Aid = b.Aid
				and ta.Ecodigo = b.Ecodigo
				and ta.IDtrans = 1
			inner join ACategoria e
				 on e.Ecodigo = b.Ecodigo
				and e.ACcodigo = b.ACcodigo
			   inner join AClasificacion f
				 on f.Ecodigo = a.Ecodigo
				and f.ACcodigo = b.ACcodigo
				and f.ACid = b.ACid
			inner join AFMarcas g
				 on g.Ecodigo = b.Ecodigo
				and g.AFMid = b.AFMid
			inner join AFMModelos h
				 on h.Ecodigo = b.Ecodigo
				and h.AFMMid = b.AFMMid
		where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
		  and a.AFSperiodo =
		  		(
					select <cf_dbfunction name="to_number" args="Pvalor">
					  from Parametros 
					 where Ecodigo = a.Ecodigo 
					   and Pcodigo = 50
				)
		  and a.AFSmes =
		  		(
					select <cf_dbfunction name="to_number" args="Pvalor">
					  from Parametros 
					 where Ecodigo = a.Ecodigo 
					   and Pcodigo = 60
				)
		UNION
		select  'true'					as EsNuevo,
				a.Ecodigo, 
				-a.AFTFid_detallehoja	as ID,
				a.Adescripcion			as Descripcion,
				a.Aplaca 				as Placa,
				a.Aserie 				as Serie,
				g.AFMdescripcion		as Marca,
				h.AFMMdescripcion		as Modelo,
				<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#createDate(1900,1,1)#">
										as FechaCompra,
				0	 					as SaldoVidaUtil,
				coalesce(Avutil,0.00)	as Costo,
				0.00 					as ValorLibros,
				0						as Estado,
				a.AFTFobservaciondetalle as Observaciones
		  from AFTFDHojaConteo a
			inner join AFTFHojaConteo he
				 on he.AFTFid_hoja = a.AFTFid_hoja
				and he.AFTFestatus_hoja = 1
				and he.AFTFid_dispositivo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFTFid_dispositivo#">
			left join AFMarcas g
				 on g.Ecodigo = a.Ecodigo
				and g.AFMid = a.AFMid
			left join AFMModelos h
				 on h.Ecodigo = a.Ecodigo
				and h.AFMMid = a.AFMMid
		where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
		  and a.Aid is null
		  
		 UNION
		 select  'false'			as EsNuevo,
				b.Ecodigo, 
				b.Aid				as ID,
				b.Adescripcion		as Descripcion,
				b.Aplaca 			as Placa,
				b.Aserie 			as Serie,
				g.AFMdescripcion	as Marca,
				h.AFMMdescripcion	as Modelo,            
				ta.TAfecha			as FechaCompra,
				0                   as SaldoVidaUtil,
				ta.TAmontooriadq	as Costo,
				0                   as ValorLibros,
				b.Astatus			as Estado,
				' ' 				as Observaciones
		  from Activos b
			inner join TransaccionesActivos ta
				 on ta.Aid = b.Aid
				and ta.Ecodigo = b.Ecodigo
				and ta.IDtrans = 5
			inner join ACategoria e
				 on e.Ecodigo = b.Ecodigo
				and e.ACcodigo = b.ACcodigo
			   inner join AClasificacion f
				 on f.Ecodigo = b.Ecodigo
				and f.ACcodigo = b.ACcodigo
				and f.ACid = b.ACid
			inner join AFMarcas g
				 on g.Ecodigo = b.Ecodigo
				and g.AFMid = b.AFMid
			inner join AFMModelos h
				 on h.Ecodigo = b.Ecodigo
				and h.AFMMid = b.AFMMid
		where <cf_whereInList column="b.Ecodigo" valueList="#LvarEmpresas#">

		</cfoutput>
	</cf_jdbcquery_open>

	<!-- Sincronizar: Activos -->
	<cfoutput query="rsSQL">
		<cfsilent>
		<cfif EsNuevo>
			<cfif Marca EQ "">
				<cfset LvarPto = find ("MARCA: ",Observaciones)>
				<cfif LvarPto GT 0>
					<cfset LvarTexto = mid(Observaciones,LvarPto+6,80)>
					<cfset LvarPto = find (chr(13),Observaciones)>
					<cfif LvarPto GT 0>
						<cfset LvarTexto = mid(LvarTexto,1,LvarPto-1)>
					<cfelse>
						<cfset LvarTexto = "Marca no especificada">
					</cfif>
					<cfset Marca = trim(LvarTexto)>
				</cfif>
			</cfif>
			<cfif Modelo EQ "">
				<cfset LvarPto = find ("MODELO: ",Observaciones)>
				<cfif LvarPto GT 0>
					<cfset LvarTexto = mid(Observaciones,LvarPto+7,80)>
					<cfset LvarPto = find (chr(13),Observaciones)>
					<cfif LvarPto GT 0>
						<cfset LvarTexto = mid(LvarTexto,1,LvarPto-1)>
					<cfelse>
						<cfset LvarTexto = "Modelo no especificado">
					</cfif>
					<cfset Modelo = trim(LvarTexto)>
				</cfif>
			</cfif>
		</cfif>
		</cfsilent>
	<ActivosTbl>
		<ID>#ID#</ID>
		<Descripcion>#fnXmlString(Descripcion,100)#</Descripcion>
		<Marca>#fnXmlString(Marca,80)#</Marca>
		<Placa>#fnXmlString(Placa,20)#</Placa>
		<Serie>#fnXmlString(Serie,50)#</Serie>
		<Modelo>#fnXmlString(Modelo,80)#</Modelo>
		<Costo>#fnXmlMoney(Costo)#</Costo>
		<FechaCompra>#fnXmlDate(FechaCompra)#</FechaCompra>
		<VidaUtil>#SaldoVidaUtil#</VidaUtil>
		<ValorActual>#fnXmlMoney(ValorLibros)#</ValorActual>
		<EsNuevo>#EsNuevo#</EsNuevo>
		<Ecodigo>#Ecodigo#</Ecodigo>
		<Estado><cfif Estado EQ "60">0<cfelse>1</cfif></Estado>
	</ActivosTbl>
	</cfoutput>
	<cf_jdbcquery_close>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfrethrow>
	</cfcatch>
	</cftry>

	<cftry>
	<!--- Sincronizar: Hojas de Conteo --->
	<cf_jdbcquery_open name="rsSQL" datasource="#session.dsn#">
		<cfoutput>
		select a.AFTFid_hoja 			as ID, 
			   a.AFTFfecha_hoja 		as FechaInicio,
			   a.AFTFfecha_conteo_hoja 	as FechaPrevista,
			   a.AFTFdescripcion_hoja 	as Descripcion,
			   a.DEid					as IDEmpleado,
			   a.Ecodigo,
			   e.Edescripcion			as Empresa
		  from AFTFHojaConteo a
		  	inner join Empresas e on e.Ecodigo = a.Ecodigo
		 where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
		   and AFTFestatus_hoja = 1
		   and AFTFid_dispositivo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFTFid_dispositivo#">
		 order by a.Ecodigo
		</cfoutput>
	</cf_jdbcquery_open>
	
	<!-- Sincronizar: Hojas de Conteo -->
	<cfoutput query="rsSQL">
	<HojaConteoTbl>
		<ID>#ID#</ID>
		<FechaInicio>#fnXmlDate(FechaInicio)#</FechaInicio>
		<FechaPrevista>#fnXmlDate(FechaPrevista)#</FechaPrevista>
		<Descripcion>#fnXmlString(Descripcion,25)#</Descripcion>
		<IDEmpleado>#IDEmpleado#</IDEmpleado>
		<Finalizada>false</Finalizada>
		<Ecodigo>#Ecodigo#</Ecodigo>
		<Empresa>#fnXmlString(Empresa,30)#</Empresa>
	</HojaConteoTbl>
	</cfoutput>
	<cf_jdbcquery_close>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfrethrow>
	</cfcatch>
	</cftry>

	<!--- Sincronizar: Detalle Hojas de Conteo a Activos de Hojas de Conteo --->
	<cftry>
	<cf_jdbcquery_open name="rsSQL" datasource="#session.dsn#">
		<cfoutput>
		select	a.AFTFid_hoja			as IDHojaConteo, 
				b.DEid					as IDEmpleado,
				coalesce(b.Aid,-b.AFTFid_detallehoja)
			   							as IDActivo,
				b.CFid					as IDCentroCosto,
				b.AFTFcantidad			as NumeroTomas,
				b.AFTFfalta				as FechaUltimoConteo
		  from AFTFHojaConteo a
			inner join AFTFDHojaConteo b
				 on b.AFTFid_hoja = a.AFTFid_hoja
		 where <cf_whereInList column="a.Ecodigo" valueList="#LvarEmpresas#">
		   and AFTFestatus_hoja = 1
		   and AFTFid_dispositivo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFTFid_dispositivo#">
		</cfoutput>
	</cf_jdbcquery_open>
	
	<!-- Sincronizar: Detalle Hojas de Conteo a Activos de Hojas de Conteo -->
	<cfoutput query="rsSQL">
	<HojasConteo_ActivosTbl>
		<IDHojaConteo>#IDHojaConteo#</IDHojaConteo>
		<IDEmpleado>#IDEmpleado#</IDEmpleado>
		<IDActivo>#IDActivo#</IDActivo>
		<IDCentroCosto>#IDCentroCosto#</IDCentroCosto>
		<NumeroTomas>#NumeroTomas#</NumeroTomas>
		<FechaUltimoConteo>#fnXmlDate(FechaUltimoConteo)#</FechaUltimoConteo>
	</HojasConteo_ActivosTbl>
	</cfoutput>
	<cf_jdbcquery_close>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfrethrow>
	</cfcatch>
	</cftry>

	<cfoutput>
	</TablesStructureDataSet>
	</cfoutput>

<cfelseif isdefined("form.btnUpload")>
	<cfquery name="rsEmpresas" datasource="#session.dsn#">
		select Ecodigo
		  from Empresas
		 where cliente_empresarial = #session.CEcodigo#
	</cfquery>
	<cfset LvarEmpresas = ValueList(rsEmpresas.Ecodigo)>
	<cf_dbtemp name="HHUPL_1" returnvariable="HOJAS" datasource="#session.dsn#">
		<cf_dbtempcol name="AFTFid_hoja" type="numeric" mandatory="yes">
		<cf_dbtempcol name="Ecodigo"	 type="integer" mandatory="yes">
		<cf_dbtempcol name="Finalizada"  type="integer" mandatory="yes">
		<cf_dbtempkey cols="AFTFid_hoja">
	</cf_dbtemp>

	<cffile action="Upload" filefield="form.txtFile" 
		destination="#gettempdirectory()#" nameconflict="makeunique" accept="text/*">

	<!--- HHSIF_#dateFormat(now(),"YYYYMMDD")#.xml" --->
	<cfset LvarFile = cffile.ServerDirectory & "/" & cffile.serverFile>
	<cftry>
		<cfset LvarFR = createobject("java", "java.io.FileReader").init(LvarFile)>
		<cfset LvarFct = createobject("java", "javax.xml.stream.XMLInputFactory").newInstance()>
		<cfset LvarXMLr = LvarFct.createXMLStreamReader(LvarFR)>
		<cfset LvarElemType = 0>
		<cfset LvarElemLevel = 0>
		<cfset LvarElems = arrayNew(1)>

		<cfset LvarHojasFin			= 0>
		<cfset LvarHojasNoFin		= 0>

		<cfset LvarHojasDetViejo	= 0>
		<cfset LvarHojasDetNuevo	= 0>
		<cfset LvarHojasDetActNuevo	= 0>
		
		
		<!--- Obtiene Periodo AUX --->
		<cfquery name="rsPerAux" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 50
				and Mcodigo = 'GN'						
		</cfquery>
		
		<!--- Obtiene Mes AUX --->
		<cfquery name="rsMesAux" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 60
				and Mcodigo = 'GN'
		</cfquery>
		
		<cfset LvarPerAux = rsPerAux.Pvalor>
		<cfset LvarMesAux = rsMesAux.Pvalor>
			

		<cftransaction>
		<cfloop condition="true">
			<cfset LvarRow = fnXMLnextRow()>
			<cfif LvarRow.elementName EQ "eof">
				<cfbreak>
			<cfelseif LvarRow.elementName EQ "CONTROL">
				<cfif ucase(LvarRow.Operacion) NEQ "UPLOAD">
					<cf_errorCode	code = "50139" msg = "El Archivo XML no corresponde a la Operacion 'UPLOAD'">
				<cfelseif dateFormat(fnXmlDateParse(LvarRow.Fecha),"YYYY-MM-DD") NEQ dateFormat(now(),"YYYY-MM-DD")>
					<cf_errorCode	code = "50140"
									msg  = "Se está intentando sincronizar una Hoja de Conteo de otra fecha '@errorDat_1@'"
									errorDat_1="#dateFormat(fnXmlDateParse(LvarRow.Fecha),"DD/MM/YYYY")#"
					>
				</cfif>
			<cfelseif LvarRow.elementName EQ "HOJACONTEOTBL">
				<!--- Sincronizar: Hojas de Conteo --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select AFTFid_hoja, AFTFestatus_hoja
					  from AFTFHojaConteo
					 where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.ID#">
				</cfquery>
				<cfif rsSQL.AFTFid_hoja EQ "">
					<cf_errorCode	code = "50141"
									msg  = "Se está intentando sincronizar una Hoja de Conteo ID=@errorDat_1@ no existente"
									errorDat_1="#LvarRow.ID#"
					>
				<cfelseif rsSQL.AFTFestatus_hoja NEQ "1">
					<cf_errorCode	code = "50142"
									msg  = "Se está intentando sincronizar una Hoja de Conteo ID=@errorDat_1@ que no está en estado '1=En Dispositivo'"
									errorDat_1="#LvarRow.ID#"
					>
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into #HOJAS# (AFTFid_hoja, Ecodigo, Finalizada)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.ID#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarRow.Ecodigo#">, 
						<cfif LvarRow.Finalizada>
							1
							<cfset LvarHojasFin = LvarHojasFin + 1>
						<cfelse>
							0
							<cfset LvarHojasNoFin = LvarHojasNoFin + 1>
						</cfif>
					)
				</cfquery>
				<cfif LvarRow.Finalizada>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update AFTFHojaConteo
						   set AFTFestatus_hoja = 2,
						       AFTFfecha_conteo_hoja = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						 where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.ID#">
					</cfquery>
				</cfif>
			<cfelseif LvarRow.elementName EQ "HOJASCONTEO_ACTIVOSTBL" OR LvarRow.elementName EQ "HOJASCONTEO_ACTIVOSHHSIFTBL">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select Ecodigo, Finalizada
					  from #HOJAS#
					 where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDHojaConteo#">
				</cfquery>
				<cfif rsSQL.Finalizada EQ "">
					<cf_errorCode	code = "50143"
									msg  = "Se está intentando sincronizar un Activo de una Hoja de Conteo ID=@errorDat_1@ que no se está sincronizando"
									errorDat_1="#LvarRow.IDHojaConteo#"
					>
				</cfif>
				<cfset LvarEcodigo		= rsSQL.Ecodigo>
				<cfset LvarFinalizada	= rsSQL.Finalizada EQ "1">
				<cfif LvarRow.IDActivo LT 0>
					<cfset LvarDetalleID = "">
				<cfelse>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select AFTFid_detallehoja, AFTFbanderaproceso
						  from AFTFDHojaConteo
						 where AFTFid_hoja	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDHojaConteo#">
						   and Aid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDActivo#">
					</cfquery>
					<cfset LvarDetalleID	= rsSQL.AFTFid_detallehoja>
					<cfset LvarDetalleNuevo	= rsSQL.AFTFbanderaproceso EQ 4>
				</cfif>

				<cfif LvarDetalleID NEQ "">
					<!--- Detalle Viejo: se actualiza la información del detalle --->
					<cfset LvarHojasDetViejo = LvarHojasDetViejo + 1>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update AFTFDHojaConteo
						   set
								DEid_lectura =
									<CFIF LvarRow.IDEmpleado EQ -1>
							   			NULL,
									<CFELSE>
									case 
							   			when DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDEmpleado#"> then null
										else <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDEmpleado#">
									end,
									</CFIF>
								CFid_lectura =
									<CFIF LvarRow.IDCentroCosto EQ -1>
									case 
							   			when CFid =
                                        	(select max(b.CFid)
                                              from AFSaldos b
                                             where b.Ecodigo =#session.Ecodigo#
                                               and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerAux#">
                                               and b.AFSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesAux#">
                                               and b.Aid = AFTFDHojaConteo.Aid
                                               ) then null
										else (select max(CFid)
                                              from AFSaldos b
                                             where b.Ecodigo =#session.Ecodigo#
                                               and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerAux#">
                                               and b.AFSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesAux#">
                                               and b.Aid = AFTFDHojaConteo.Aid
                                               )
									end,
									<CFELSE>
									case 
							   			when CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDCentroCosto#"> then null
										else <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDCentroCosto#">
									end,
									</CFIF>
								AFTFcantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarRow.NumeroTomas#">,
								AFTFbanderaproceso =
									<cfif LvarDetalleNuevo>
											4									<!--- Detalle Nuevo --->
									<cfelseif LvarRow.NumeroTomas EQ 0>
										<cfif LvarFinalizada>
											2									<!--- No contado --->
										<cfelse>
											0									<!--- Sin definir --->
										</cfif>
									<cfelseif LvarRow.NumeroTomas EQ 1>
											1									<!--- Contado OK --->
									<cfelseif LvarRow.NumeroTomas GT 1>
											3									<!--- Contado más de una vez --->
									</cfif>
						 where AFTFid_detallehoja = #LvarDetalleID#
					</cfquery>
				<cfelseif LvarRow.IDActivo GTE 0>
					<!--- Nuevo detalle con Activo existente: se toma toda la información del Activo --->
					<cfset LvarHojasDetNuevo = LvarHojasDetNuevo + 1>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select Aid
						  from Activos
						 where Aid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDActivo#">
					</cfquery>
					<cfif rsSQL.Aid EQ "">
						<cf_errorCode	code = "50144"
										msg  = "Se está intentando incluir un nuevo detalle a la Hoja de Conteo ID=@errorDat_1@ con un Activo ID=@errorDat_2@ que no existe"
										errorDat_1="#LvarRow.IDHojaConteo#"
										errorDat_2="#LvarRow.IDActivo#"
						>
					</cfif>
					
										
					
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into AFTFDHojaConteo
							(
							   AFTFid_hoja,
							   Ecodigo,
							
							   Aid,
							   AFMid,
							   AFMMid,
							   ACcodigo,
							   ACid,
							   AFCcodigo,
							   Aplaca,
							   Aserie,
							   Adescripcion,
							   Astatus,
							   Avutil,
							   Avalrescate,
							
							   DEid,
							   CFid,
							
							   AFTFcantidad,
							   AFTFbanderaproceso,
							   AFTFfalta
							)
						select 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDHojaConteo#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEcodigo#">,
							
							   a.Aid,
							   a.AFMid,
							   a.AFMMid,
							   a.ACcodigo,
							   a.ACid,
							   a.AFCcodigo,
							   a.Aplaca,
							   a.Aserie,
							   a.Adescripcion,
							   a.Astatus,
							   a.Avutil,
							   a.Avalrescate,
							   
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDEmpleado#" null="#LvarRow.IDEmpleado EQ -1#">,
							   
							   <cfif LvarRow.IDCentroCosto eq -1>
							   		<!--- Obtiene el último Centro Funcional de AFSaldos para el Activo--->
									(Select Max(b.CFid)
									from AFSaldos b
									where b.Ecodigo = a.Ecodigo
									  and b.Aid = a.Aid
									  and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerAux#">
									  and b.AFSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesAux#">),
							   <cfelse>	
							   		<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDCentroCosto#">,
							   </cfif>

							   <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarRow.NumeroTomas#">,
							   4, <!--- AFTFbanderaproceso = Detalle nuevo --->
							   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						  from Activos a
						 where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDActivo#">
					</cfquery>
				<cfelse>
					<!--- Nuevo detalle con Activo nuevo: se toma toda la información del XML --->
                    
					<cfset LvarHojasDetActNuevo = LvarHojasDetActNuevo + 1>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						delete from AFTFDHojaConteo
						 where 	Aid 			is null
						   and 	coalesce(Aplaca,
						   		<cfqueryparam cfsqltype="cf_sql_varchar" value="">) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRow.Placa#">
						   and 	coalesce(Aserie,
						   		<cfqueryparam cfsqltype="cf_sql_varchar" value="">) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRow.Serie#">
						   and 	coalesce(Adescripcion,
						   		<cfqueryparam cfsqltype="cf_sql_varchar" value="">) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRow.Descripcion#">
					</cfquery>

					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into AFTFDHojaConteo
							(
							   AFTFid_hoja,
							   Ecodigo,
							
							   Aid,
							   AFMid,
							   AFMMid,
							   ACcodigo,
							   ACid,
							   AFCcodigo,

							   Aplaca,
							   Aserie,
							   Adescripcion,
							   Astatus,
							   Avutil,
							   Avalrescate,
							
							   DEid,
							   CFid,
							
							   AFTFcantidad,
							   AFTFbanderaproceso,
							   AFTFobservaciondetalle,
							   AFTFfalta
							)
						values (
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDHojaConteo#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEcodigo#">,
							
							   null, <!--- Aid --->
							   null, <!--- AFMid --->
							   null, <!--- AFMMid --->
							   null, <!--- ACcodigo --->
							   null, <!--- ACid --->
							   null, <!--- AFCcodigo --->

							   <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRow.Placa#">,
							   <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRow.Serie#">,
							   <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRow.Descripcion#">,
							   0,	<!--- Astatus --->
							   0, 	<!--- Avutil --->
							   0,	<!--- Avalrescate --->
							
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDEmpleado#" null="#LvarRow.IDEmpleado EQ -1#">,

								<cfif LvarRow.IDCentroCosto eq -1>
							   		<!--- Usa el último Centro Funcional de AFSaldos para el Activo--->
							   		null,
								<cfelse>	
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRow.IDCentroCosto#">,
								</cfif>
							
							   <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarRow.NumeroTomas#">,
							   4, <!--- AFTFbanderaproceso = Detalle nuevo --->
							   <cfqueryparam cfsqltype="cf_sql_varchar" value="ACTIVO: #LvarRow.Placa# #LvarRow.Descripcion##chr(13)##chr(10)#MARCA: #LvarRow.Marca##chr(13)##chr(10)#MODELO: #LvarRow.Modelo##chr(13)##chr(10)#">,
							   		<!--- AFTFobservaciondetalle --->
							   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							)
					</cfquery>
				</cfif>
			<cfelseif LvarRow.elementName NEQ "">
				<cf_errorCode	code = "50145"
								msg  = "Se encontró un tipo de registro '@errorDat_1@' que no corresponde con el XML de una hoja de Conteo de HandHeld"
								errorDat_1="#LvarRow.elementName#"
				>
			</cfif>
		</cfloop>
		</cftransaction>
		<cfset LvarFR.close()>
		<cfset LvarXMLr.close()>
	<cfcatch type="any">
		<cftransaction action="rollback">
		<cftry><cfset LvarFR.close()><cfcatch type="any"></cfcatch></cftry>
		<cftry><cfset LvarXMLr.close()><cfcatch type="any"></cfcatch></cftry>
		
		<cfrethrow>
	</cfcatch>
	</cftry>
	<cfoutput>
		<table align="center">
			<tr>
				<td colspan="4" align="center">
					<strong>RESULTADO DEL UPLOAD DE LAS HOJAS DE CONTEO</strong>
				</td>
			</tr>
			<tr>
				<td><strong>Hojas procesadas</strong></td>
				<td>#LvarHojasFin+LvarHojasNoFin#</td>
			</tr>
			<tr>
				<td align="right">Terminadas</td>
				<td>#LvarHojasFin#</td>
			</tr>
			<tr>
				<td align="right">En Proceso</td>
				<td>#LvarHojasNoFin#</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td><strong>Detalle de Hojas procesadas</strong></td>
				<td>#LvarHojasDetViejo+LvarHojasDetNuevo+LvarHojasDetActNuevo#</td>
			</tr>
			<tr>
				<td align="right">Detalles Existentes</td>
				<td>#LvarHojasDetViejo#</td>
			</tr>
			<tr>
				<td align="right">Detalles Nuevos</td>
				<td>#LvarHojasDetNuevo+LvarHojasDetActNuevo#</td>
				<td align="right">
					Con Activos Existentes = #LvarHojasDetNuevo#<BR>
					Con Activos Nuevos = #LvarHojasDetActNuevo#
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="4" align="center">
					<input type="button" value="Continuar" onclick="location.href='sincronizar.cfm';">
				</td>
			</tr>
		</table>
	</cfoutput>
	<cfabort>
</cfif>
<cflocation url="sincronizar.cfm">

<cffunction name="fnThrow" access="private" output="false" returntype="void">
	<cfargument name="hilera"	type="string" required="yes">
	<cfthrow message="#hilera#">
</cffunction>

<cffunction name="fnDump" access="private" output="true" returntype="void">
	<cfargument name="hilera"	type="any" required="yes">
	<cfargument name="abortar"	type="boolean" required="no" default="no">

	<cfdump var="#hilera#">
	<cfif abortar><cfabort></cfif>
</cffunction>

<cffunction name="fnXmlString" access="private" output="false" returntype="string">
	<cfargument name="hilera"	type="string" required="yes">
	<cfargument name="longitud"	type="numeric" required="no">
	
	<cfif isdefined("Arguments.longitud")>
		<cfreturn xmlFormat(trim(mid(Arguments.hilera,1,Arguments.longitud)))>
	<cfelse>
		<cfreturn xmlFormat(trim(Arguments.hilera))>
	</cfif>
</cffunction>
		
<cffunction name="fnXmlDate" access="private" output="false" returntype="string">
	<cfargument name="fecha"	type="string" required="yes">
	
	<cfif trim(fecha) EQ "">
		<cfreturn "">
	</cfif>
	<cfset fecha = "#dateFormat(Arguments.fecha,"YYYY-MM-DD")#T#timeFormat(Arguments.fecha,"HH:MM:SS")#.0">
	<cfreturn fecha>
</cffunction>
		
<cffunction name="fnXmlDateParse" access="private" output="false" returntype="string">
	<cfargument name="fecha"	type="string" required="yes">
	
    <cfset LvarSDF = CreateObject("java", "java.text.SimpleDateFormat").init("yyyy-MM-dd'T'HH:mm:ss.SSSSSSS")>
	<cftry>
		<cfset fecha = LvarSDF.parse(fecha)>
	<cfcatch type="any"></cfcatch>
	</cftry>
	<cfreturn fecha>
</cffunction>
		
<cffunction name="fnXmlMoney" access="private" output="false" returntype="string">
	<cfargument name="monto"	type="numeric" required="yes">
	
	<cfreturn numberFormat(Arguments.monto,"9.99")>
</cffunction>
		
<cfscript>
	function fnXMLnextRow()
	{
		while(LvarXMLr.hasNext())
		{
			LvarElemTypeName = fnEventTypeName(LvarXMLr.getEventType());
			if (LvarElemTypeName EQ "START_ELEMENT")
			{
				LvarElemLevel = LvarElemLevel + 1;
				if (LvarElemLevel GT 3)
					fnThrow ("Se encontraron mas de 3 niveles");

				LvarElems[LvarElemLevel] = structNew();
				LvarElems[LvarElemLevel].elementName	= ucase(LvarXMLr.getLocalName());
				LvarElems[LvarElemLevel].elementValue	= "";
				LvarElemType = 1;
			}
			else if (LvarElemTypeName EQ "END_ELEMENT")
			{
				if (LvarElems[LvarElemLevel].elementName NEQ ucase(LvarXMLr.getLocalName()))
					fnThrow ("Se esperaba fin de elemento #LvarElems[LvarElemLevel].elementName# pero se encontró #LvarXMLr.getLocalName()#");

				LvarElemLevel = LvarElemLevel - 1;
				LvarElemType = 0;
				if (LvarElemLevel EQ 2)
				{
					LvarElems[LvarElemLevel][LvarElems[LvarElemLevel+1].elementName] = LvarElems[LvarElemLevel+1].elementValue;
				}
				else if (LvarElemLevel EQ 1)
				{
					LvarXMLr.next();
					return LvarElems[LvarElemLevel+1];
				}
				else
				{
					LvarElement = structNew();
					LvarElement.elementName = "";
					LvarXMLr.next();
					return LvarElement;
				}
			}
			else if (LvarElemType EQ 1 AND LvarElemTypeName EQ "CHARACTERS" AND NOT LvarXMLr.isWhiteSpace())
				LvarElems[LvarElemLevel].elementValue = LvarElems[LvarElemLevel].elementValue & LvarXMLr.getText();

			LvarXMLr.next();
		}

		LvarElement = structNew();
		LvarElement.elementName = "eof";
		return LvarElement;
	}
	
	function fnEventTypeName (eventType)
	{
		switch (eventType)
		{
			case  1: return "START_ELEMENT"; break;
			case  2: return "END_ELEMENT"; break;
			case  3: return "PROCESSING_INSTRUCTION"; break;
			case  4: return "CHARACTERS"; break;
			case  5: return "COMMENT"; break;
			case  6: return "SPACE"; break;
			case  7: return "START_DOCUMENT"; break;
			case  8: return "END_DOCUMENT"; break;
			case  9: return "ENTITY_REFERENCE"; break;
			case 10: return "ATTRIBUTE"; break;
			case 11: return "DTD"; break;
			case 12: return "CDATA"; break;
			case 13: return "NAMESPACE"; break;
			case 14: return "NOTATION_DECLARATION"; break;
			case 15: return "ENTITY_DECLARATION"; break;
			default: return "NULL";
		}
	}
</cfscript>


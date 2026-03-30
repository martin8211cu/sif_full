<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<!--- establecimiento de los modos (ENC y DET)--->	
<cfset modo  = 'ALTA'>
<cfif isdefined("form.ECid") and len(trim(form.ECid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<!--- Impuestos --->
<cfquery name="rsImpuestos" datasource="#session.DSN#">
	select rtrim(Icodigo) as Icodigo, Idescripcion, Iporcentaje 
	from Impuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<!--- Unidades --->
<cfquery name="rsUnidades" datasource="#session.DSN#">
	select rtrim(Ucodigo) as Ucodigo, Udescripcion 
	from Unidades 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<!--- Formas de Pago --->
<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
	select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
	from CMFormasPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CMFPcodigo
</cfquery>

<!--- Incoterm --->
<cfquery name="rsCMIncoterm" datasource="#session.dsn#">
	select CMIid, CMIcodigo, CMIdescripcion, CMIpeso
	from CMIncoterm
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CMIcodigo
</cfquery>

<!--- Formas de Pago e Incoterm del Proceso de Compra --->
<cfquery name="defaultProcesoCompra" datasource="#Session.DSN#">
	select a.CMIid, a.CMFPid
	from CMProcesoCompra a
	where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!---- Seleccion de las marcas ---->
<cfquery name="rsMarcas" datasource="#session.DSN#">
	select AFMid, AFMcodigo, AFMdescripcion 
	from AFMarcas 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and AFMuso in ('I','A')
</cfquery>
<!----- Selección de la forma de pago del socio de negocio ------>
<cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>
	<cfif len(trim(defaultProcesoCompra.CMFPid)) eq 0>
        <cfquery name="rsSNFormaPagoDias" datasource="#session.dsn#">
            select coalesce(SNvencompras, -1) as Dias
            from SNegocios
            where Ecodigo = #session.Ecodigo#															
                and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#"> 
        </cfquery>
        <cfquery name="rsFormaPagoSocio" datasource="#session.DSN#" maxrows="1">
            select min(CMFPid) as CMFPid
            from CMFormasPago 
            where Ecodigo = #session.ecodigo#
              and CMFPplazo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSNFormaPagoDias.Dias#">
        </cfquery>
    <cfelse>
        <cfquery name="rsFormaPagoSocio" datasource="#session.DSN#" maxrows="1">
            select b.CMFPid
            from SNegocios a
                left outer join CMFormasPago b
                    on a.SNplazocredito = b.CMFPplazo
                    and a.Ecodigo = b.Ecodigo
            where a.SNcodigo = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo1#">	
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
        </cfquery>
  	</cfif>
</cfif>

<!--- Lineas del Proceso de Compra --->
<!---
	select a.CMPid, a.ESidsolicitud, a.DSlinea, b.Aid, b.Cid,b.Ecodigo,
		   b.DScant, rtrim(b.Ucodigo) as Ucodigo, rtrim(b.Icodigo) as Icodigo,
		   b.DSdescripcion, b.DSdescalterna, b.DSobservacion,c.NumeroParte, c.AFMid	
		   
		   when c.AFMid != d.AFMid then c.AFMid
--->
<cfquery name="rsLineasProceso" datasource="#session.DSN#">
	select	c.AFMid,d.AFMid, a.DSlinea,
		  <cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>c.NumeroParte<cfelse>d.Acodalterno</cfif> as NumeroParte,  
			a.CMPid, a.ESidsolicitud, a.DSlinea, b.Aid, b.Cid,b.Ecodigo,
			b.DScant, b.DScant-b.DScantsurt as CantDisponible, rtrim(b.Ucodigo) as Ucodigo, rtrim(b.Icodigo) as Icodigo,
			case when c.AFMid = d.AFMid then d.AFMid
				 end as marca,
			case when b.Aid is not null then d.Acodigo else null end as Acodigo,			
			b.DSdescripcion, b.DSdescalterna, b.DSobservacion<!---,c.NumeroParte---->
					
	from CMLineasProceso a	
	
		inner join DSolicitudCompraCM b
			on b.Ecodigo = #lvarFiltroEcodigo#
			and a.ESidsolicitud = b.ESidsolicitud
			and a.DSlinea = b.DSlinea					
			
			left outer join Conceptos e
					on b.Cid = e.Cid
			
			left outer join NumParteProveedor c
				on b.Aid = c.Aid
				and b.Ecodigo = c.Ecodigo
				<cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>
					and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo1#">
				</cfif>	
				
				left outer join Articulos d
					on c.Aid = d.Aid			
				
	where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#"> 
	Order by c.NumeroParte,marca 
</cfquery>
<cfquery name="rsLineas" datasource="#session.DSN#">
	select a.CMPid, a.ESidsolicitud, a.DSlinea, b.Aid, b.Cid,b.Ecodigo,
		   b.DScant, b.DScant-b.DScantsurt as CantDisponible, rtrim(b.Ucodigo) as Ucodigo, rtrim(b.Icodigo) as Icodigo,
		   b.DSdescripcion, b.DSdescalterna, b.DSobservacion
		
	from CMLineasProceso a	
	
		inner join DSolicitudCompraCM b
			on b.Ecodigo = #lvarFiltroEcodigo#
			and a.ESidsolicitud = b.ESidsolicitud
			and a.DSlinea = b.DSlinea	
			
			
			
			left outer join NumParteProveedor c
				on b.Aid = c.Aid
				and b.Ecodigo = c.Ecodigo	
															
	where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#"> 
	Order by a.DSlinea
</cfquery>
<!--- Seleccion solo los artículos de las lineas de la solicitud ---->
<cfquery name="rsArticulos" dbtype="query" >
	select distinct Aid
	from rsLineasProceso
	where Aid is not null	
</cfquery>
<!--- Se asignan a una variable separados por comas todos los articulos del proceso de compra ---->
<cfif rsArticulos.RecordCount NEQ 0>
	<cfset vsArticulos = ValueList(rsArticulos.Aid,',')>
</cfif>
<!--- Se selecciona solo los servicios de las lineas de la solicitud ---->
<cfquery name="rsServicios" dbtype="query" >
	select distinct Cid
	from rsLineasProceso
	where Cid is not null	
</cfquery>
<!--- Se asingnan los servicios a una variable separados por comas ---->
<cfif rsServicios.RecordCount NEQ 0>
	<cfset vsServicios = ValueList(rsServicios.Cid,',')>
</cfif>

<cfif isdefined("url.SNcodigo") and isdefined("form.btnNuevo")><!----and isdefined("form.btnNuevo")>---->
	<cfset form.SNcodigo = url.SNcodigo>
	<cfset vnSocio = 1>		<!--- Variable para pintar socio de negocio --->
	<cfif isdefined("vsArticulos") and len(trim(vsArticulos))>
		<!---- Seleccion de Articulos que tienen un parte con ese socio o que esten dentro de la calsificacion asignada al socio seleccionado---->
		<cfquery name="rsLineasArticulosCon" datasource="#session.DSN#">	
			select distinct a.Aid
			from NumParteProveedor a		
			where a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
				and a.Aid in (#vsArticulos#)				
				and #now()# between a.Vdesde and a.Vhasta								
			
			union
				
			select distinct b.Aid
			from Articulos b
				inner join Clasificaciones c
					on b.Ccodigo = c.Ccodigo
					and b.Ecodigo = c.Ecodigo
					
				left outer  join ClasificacionItemsProv d
					on c.Ccodigo = d.Ccodigo
					and b.Ecodigo = d.Ecodigo
					and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			
			where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and b.Aid in (#vsArticulos#)
		</cfquery>
					
		<cfif rsLineasArticulosCon.RecordCount NEQ 0><!--- Si hay articulos con partes y/o en la clasificacion del proveedor seleccionado ---->
			<cfset vnLineasArticulosCon = ValueList(rsLineasArticulosCon.Aid,',')>			
			<!--- Seleccion de los articulos que sobran ---->
			<cfquery name="rsArticulosFaltan" dbtype="query">
				select Aid
				from rsArticulos 		
				where Aid not in (#vnLineasArticulosCon#)
			</cfquery> 
		
			<cfif rsArticulosFaltan.RecordCount NEQ 0><!--- Si faltan articulos por evaluar ---->
				<cfset vnLineasArticulosSin = ValueList(rsArticulosFaltan.Aid,',')>
				<!--- Seleccion de los articulos que tienen partes o estan asignados a una clasificacion pero con un socio que NO ES el seleccionado ---->
				<cfquery name="rsLineasArticulosSin" datasource="#session.DSN#"	>
					select distinct a.Aid
					from NumParteProveedor a		
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
						and a.Aid in (#vnLineasArticulosSin#)	
						and #now()# between a.Vdesde and a.Vhasta	
						
					union
						
					select distinct b.Aid
					from Articulos b
						inner join Clasificaciones c
							on b.Ccodigo = c.Ccodigo
							and b.Ecodigo = c.Ecodigo
							
						left outer  join ClasificacionItemsProv d
							on c.Ccodigo = d.Ccodigo
							and b.Ecodigo = d.Ecodigo
					
					where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and b.Aid in (#vnLineasArticulosSin#)
				</cfquery>	
				<cfif rsLineasArticulosSin.RecordCount NEQ 0><!--- Si hay articulos que tengan parte o clasificacion con otro Socio ---->
					<cfset vnArticulosSontos = ValueList(rsLineasArticulosSin.Aid,',')>
					<!--- Se seleccionan los articulos que no tienen ni partes ni ningun socio ha sido asigando a su clasificacion ---->
					<cfquery name="rsArticulosSolos" dbtype="query">
						select Aid 
						from  rsArticulosFaltan
						where Aid not in (#vnArticulosSontos#)					
					</cfquery>
					<cfif rsArticulosSolos.RecordCount NEQ 0>
						<cfset vnArticulosSolos = ValueList(rsArticulosSolos.Aid,',')>
					</cfif>
				</cfif>	<!--- If hay articulos Sin partes ni clasificacion asignada ---->
			</cfif><!--- Si falta algun articulo por evaluar ---->
		<!--- si no hay articulos con clasificacion del socio ni con partes del socio ---->
		<cfelse>
			<cfquery name="rsLineasArticulosSin" datasource="#session.DSN#"	>
				select distinct a.Aid
				from NumParteProveedor a		
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
					and a.Aid in (#vsArticulos#)	
					
				union
					
				select distinct b.Aid
				from Articulos b
					inner join Clasificaciones c
						on b.Ccodigo = c.Ccodigo
						and b.Ecodigo = c.Ecodigo
						
					inner  join ClasificacionItemsProv d
						on c.Ccodigo = d.Ccodigo
						and b.Ecodigo = d.Ecodigo
				
				where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and b.Aid in (#vsArticulos#)
			</cfquery>
			<cfif rsLineasArticulosSin.RecordCount NEQ 0><!--- Si hay articulos que tengan parte o clasificacion con otro Socio ---->
				
				<cfset vnArticulosSontos = ValueList(rsLineasArticulosSin.Aid,',')>
				<!--- Se seleccionan los articulos que no tienen ni partes ni ningun socio ha sido asigando a su clasificacion ---->
				<cfquery name="rsArticulosSolos" dbtype="query">
					select Aid 
					from  rsArticulos
					where Aid not in (#vnArticulosSontos#)					
				</cfquery>
				
				<cfif rsArticulosSolos.RecordCount NEQ 0>
					<cfset vnArticulosSolos = ValueList(rsArticulosSolos.Aid,',')>
				</cfif>				
			</cfif>			
		</cfif>	<!--- Fin de si hay articulos con partes y/o clasificacion asignada al proveedor seleccionado ---->	
		<cfif (isdefined("vnLineasArticulosCon") and len(trim(vnLineasArticulosCon))) or (isdefined("vnArticulosSolos") and len(trim(vnArticulosSolos)))>			
			<cfquery name="Articulos" dbtype="query">
				select 	Aid
				from rsLineasProceso
				where Ecodigo = #lvarFiltroEcodigo#
					<cfif (isdefined("vnLineasArticulosCon") and len(trim(vnLineasArticulosCon))) AND (isdefined("vnArticulosSolos") and len(trim(vnArticulosSolos)))>
						and Aid in (#vnLineasArticulosCon#)
						or Aid in (#vnArticulosSolos#)
					<cfelseif (isdefined("vnLineasArticulosCon") and len(trim(vnLineasArticulosCon))) AND not(isdefined("vnArticulosSolos") and len(trim(vnArticulosSolos)))>
						and Aid in (#vnLineasArticulosCon#)
					<cfelseif (isdefined("vnArticulosSolos") and len(trim(vnArticulosSolos))) AND not(isdefined("vnLineasArticulosCon") and len(trim(vnLineasArticulosCon)))>
						and Aid in (#vnArticulosSolos#)
					</cfif>
			</cfquery>
			<cfif Articulos.RecordCount NEQ 0>
				<cfset articulos = ValueList(Articulos.Aid,',')>
			</cfif>
		</cfif>	
			
	</cfif>	
	<cfif isdefined("vsServicios") and len(trim(vsServicios ))>
		<!--- Seleccion de servicios que esten dentro de la clasificacion asignada al socio de negocio ---->
		<cfquery name="rsLineasServiciosCon" datasource="#session.DSN#">
			select distinct b.Cid
			from Conceptos b
				left outer join CConceptos c
					on b.CCid = c.CCid and b.Ecodigo = c.Ecodigo
				inner join ClasificacionItemsProv d
					on c.CCid = d.CCid and c.Ecodigo = d.Ecodigo
					  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			where b.Cid in (#vsServicios#)
		</cfquery>
		<cfif rsLineasServiciosCon.RecordCount NEQ 0><!--- 1.Si hay servicios en alguna clasificacion del socio neg.---->
			<cfset vnLineasServiciosCon = ValueList(rsLineasServiciosCon.Cid,',')>	
			<!--- Se obtienen los servicios que faltan ---->
			<cfquery name="rsServiciosFaltan" dbtype="query"><!---Selecciona los que sobraron ---->
				select Cid
				from rsServicios
				where Cid not in (#vnLineasServiciosCon#)
			</cfquery>
			
			<cfif rsServiciosFaltan.RecordCount NEQ 0>	<!--- 2. Si sobran y no se han evaluado ---->						
				<cfset vnServiciosFaltan= ValueList(rsServiciosFaltan.Cid,',')>
				<!---- Seleccion de los servicios que no estan en la clasificacion del socio seleccionado pero SI en otras---->				
				<cfquery name="rsLineasServiciosSin" datasource="#session.DSN#">
					select distinct b.Cid
					from Conceptos b
							
						left outer join CConceptos c
							on b.CCid = c.CCid
							and b.Ecodigo = c.Ecodigo
						
						inner join ClasificacionItemsProv d
							on c.CCid = d.CCid
							and c.Ecodigo = d.Ecodigo
					
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">				
						and b.Cid in (#vnServiciosFaltan#)
				</cfquery>
				<cfif rsLineasServiciosSin.RecordCount NEQ 0><!--- 3. Se obtienen los servicios que si tienen una categoria asignada aunque sea de OTRO proveedor ---->
					<cfset vnServiciosOtros = ValueList(rsLineasServiciosSin.Cid,',')>
					<cfquery name="rsServicios" dbtype="query">
						select Cid
						from rsServicios
						where Cid not in (#vnServiciosOtros#)
					</cfquery>
					<cfif rsServicios.RecordCount NEQ 0>
						<cfset vnServiciosSolos = ValueList(rsServicios.Cid,',')> 
					</cfif>
				</cfif><!--- If 3--->
			</cfif>	<!--- If 2 --->
		<cfelse><!--- SI no hay servicios en la (s) clasificacion(es) del socio seleccionado ---->
			<cfquery name="rsLineasServiciosSin" datasource="#session.DSN#">
				select distinct b.Cid
				from Conceptos b
						
					left outer join CConceptos c
						on b.CCid = c.CCid
						and b.Ecodigo = c.Ecodigo
					
					inner join ClasificacionItemsProv d
						on c.CCid = d.CCid
						and c.Ecodigo = d.Ecodigo
				
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">				
					and b.Cid in (#vsServicios#)
			</cfquery>

			<cfif rsLineasServiciosSin.RecordCount NEQ 0><!--- 3. Se obtienen los servicios que si tienen una categoria asignada aunque sea de OTRO proveedor ---->
				<cfset vnServiciosOtros = ValueList(rsLineasServiciosSin.Cid,',')>
				<cfquery name="rsServicios" dbtype="query">
					select Cid
					from rsServicios
					where Cid not in (#vnServiciosOtros#)
				</cfquery>
				<cfif rsServicios.RecordCount NEQ 0>
					<cfset vnServiciosSolos = ValueList(rsServicios.Cid,',')> 
				</cfif>
			</cfif>
		</cfif><!---- If 1 ---->
		<!--- Si los servicios NO estan en la clasificacion del socio seleccionado y estan en la clasificacion de OTRO socio no se incluyen ---->
		<cfif (isdefined("vnLineasServiciosCon") and len(trim(vnLineasServiciosCon))) or (isdefined("vnServiciosSolos") and len(trim(vnServiciosSolos)))>
			<cfquery name="Servicios" dbtype="query">
				select 	Cid	
				from rsLineasProceso
				where Ecodigo = #lvarFiltroEcodigo#			
					<cfif (isdefined("vnLineasServiciosCon") and len(trim(vnLineasServiciosCon))) and (isdefined("vnServiciosSolos") and len(trim(vnServiciosSolos)))>
						and Cid in (#vnLineasServiciosCon#)
						or Cid in (#vnServiciosSolos#)
					<cfelseif (isdefined("vnLineasServiciosCon") and len(trim(vnLineasServiciosCon))) AND not (isdefined("vnServiciosSolos") and len(trim(vnServiciosSolos)))>
						and Cid in (#vnLineasServiciosCon#)
					<cfelseif (isdefined("vnServiciosSolos") and len(trim(vnServiciosSolos))) AND not (isdefined("vnLineasServiciosCon") and len(trim(vnLineasServiciosCon)))>
						and Cid in (#vnServiciosSolos#)
					</cfif>
			</cfquery>			
			<cfif Servicios.RecordCount NEQ 0>
				<cfset servicios = ValueList(Servicios.Cid,',')>
			</cfif>
		</cfif> 
	</cfif><!--- Fin de si hay servicios en la(s) solicitud(es)--->		
		
	<cfif isdefined ("articulos") and len(trim(articulos)) or (isdefined("servicios") and len(trim(servicios)))>
		<cfquery dbtype="query" name="rsLineasProveedor">
			select * 
			from rsLineasProceso
			where Ecodigo = #lvarFiltroEcodigo#
				<cfif isdefined ("articulos") and len(trim(articulos)) and isdefined("servicios") and len(trim(servicios))>
					and Aid in (#articulos#)
					or Cid in (#servicios#)
				<cfelseif isdefined ("articulos") and len(trim(articulos)) and not(isdefined("servicios") and len(trim(servicios)))>
					and Aid in (#articulos#)
				<cfelseif isdefined("servicios") and len(trim(servicios)) and not (isdefined ("articulos") and len(trim(articulos)))>
					and Cid in (#servicios#)
				</cfif>
				<!----
				<cfif isdefined("servicios") and len(trim(servicios))>
					or  Cid in (#servicios#)
				</cfif>
				----->
		</cfquery>	
	<cfelse>
		<cfset rsLineasProveedor = querynew('AFMid')>
	</cfif>
			
	<cfset rsLineasProceso = rsLineasProveedor> 
	
	<!----<cfdump var="#rsLineasProceso#">---->

	
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery datasource="#session.DSN#" name="rsForm">
		select a.ECid, a.CMPid, a.SNcodigo, 
			   a.ECconsecutivo, a.ECnumero, a.ECestado, 
			   a.ECnumprov, a.ECdescprov, a.ECobsprov, 
			   a.ECfechacot, a.Mcodigo, a.ECtipocambio, 
			   a.CMIid, a.CMFPid, a.ECfechavalido, 
			   a.ts_rversion,
			   b.Mcodigo, b.Mnombre
		from ECotizacionesCM a				
			inner join Monedas b
				on b.Ecodigo = a.Ecodigo
				and b.Mcodigo = a.Mcodigo
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
	</cfquery>
	<cfquery name="rsLineasProceso" datasource="#session.DSN#">
		select 	a.ECid, a.CMPid, a.DSlinea, a.Ecodigo, 
				coalesce(a.DCcantidad,0) as DCcantidad, 
				#LvarOBJ_PrecioU.enSQL_AS("coalesce(a.DCpreciou,0)","DCpreciou")#, 
				a.DCgarantia,
			   	a.DCplazocredito, 
				a.DCplazoentrega, 
				rtrim(a.Icodigo) as Icodigo, 
				coalesce(a.DCdesclin,0) as DCdesclin, 
				a.DCdescprov, 
			   	a.DCunidadcot, 
				a.DCconversion,
				rtrim(a.Ucodigo) as Ucodigo, 
				coalesce(a.DCtotallin,0) as DCtotallin,
				a.ts_rversion, 
				a.DCporcimpuesto,
			   	b.DSdescripcion,
				a.numparte,
				a.AFMid,
				b.Aid, 
				case when b.Aid  is not null then c.Acodigo else null 
					end as Acodigo,
				b.Cid,
				b.Ecodigo,
		   		b.DScant,
				b.DScant-b.DScantsurt as CantDisponible,
		   		b.DSdescripcion, 
				b.DSdescalterna, 
				b.DSobservacion
		from DCotizacionesCM a, 
			DSolicitudCompraCM b
						
				left outer join Conceptos d
					on b.Cid = d.Cid
				
				left outer join Articulos c
						on b.Aid = c.Aid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		  and b.Ecodigo = #lvarFiltroEcodigo#
		  and a.DSlinea = b.DSlinea
	  	Order by a.DSlinea
	</cfquery>
	<cfquery name="rsDetalles" datasource="#session.DSN#">
		select 	a.ECid, a.CMPid, a.DSlinea, a.Ecodigo, 
				coalesce(a.DCcantidad,0) as DCcantidad, 
				#LvarOBJ_PrecioU.enSQL_AS("coalesce(a.DCpreciou,0)","DCpreciou")#, 
				a.DCgarantia,
			   	a.DCplazocredito, 
				a.DCplazoentrega, 
				rtrim(a.Icodigo) as Icodigo, 
				coalesce(a.DCdesclin,0) as DCdesclin, 
				a.DCdescprov, 
			   	a.DCunidadcot, 
				a.DCconversion,
				rtrim(a.Ucodigo) as Ucodigo, 
				coalesce(a.DCtotallin,0) as DCtotallin,
				a.ts_rversion, 
				a.DCporcimpuesto,
			   	b.DSdescripcion,
				a.numparte,
				a.actnumparteprov,
				a.AFMid
		from DCotizacionesCM a, 
			 DSolicitudCompraCM b	
			 
			 left outer join Conceptos d
					on b.Cid = d.Cid
				
			left outer join Articulos c
						on b.Aid = c.Aid
 	
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		  and b.Ecodigo = #lvarFiltroEcodigo#
		  and a.DSlinea = b.DSlinea
		 order by a.DSlinea
	</cfquery>
</cfif>


<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language='JavaScript' type='text/JavaScript' src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">

	function info(){
		open('/cfmx/sif/cm/operacion/compraProceso-cotizmanual-info.cfm', 'infoadicional', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=600,height=260,left=250, top=200,screenX=250,screenY=200');
	}

	function asignaTC() {	
		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			formatCurrency(document.form1.TC,2);
			document.form1.ECtipocambio.disabled = true;			
		}
		else{
			document.form1.ECtipocambio.disabled = false;
		}	
		var estado = document.form1.ECtipocambio.disabled;
		document.form1.ECtipocambio.disabled = false;
		document.form1.ECtipocambio.value = fm(document.form1.TC.value,2);
		document.form1.ECtipocambio.disabled = estado;
	}

	<!--- Objectos para el manejo de plazos de crédito según la forma de pago --->
	var fp = new Object();
	<cfoutput query="rsCMFormasPago">
		fp['#CMFPid#'] = #CMFPplazo#;
	</cfoutput>
	
	function getPlazo(id) {
		if (fp[id] != null) {
		<cfoutput query="rsLineasProceso">
			document.form1.DCplazocredito_#rsLineasProceso.DSlinea#.value = fp[id];
		</cfoutput>
		}
	}

	<!---
	function doConlisProcesoLineas() {
		var params ="";
		popUpWindow("/cfmx/sif/cm/operacion/compraProceso-cotizmanual-conlislineas.cfm?CMPid=<cfoutput>#rsForm.CMPid#</cfoutput>&ECid=<cfoutput>#rsForm.ECid#</cfoutput>",250,200,650,400);
	}
	---->
	
	//Funcion para calcular el impuesto 
	function FuncCalculaImpuesto(obj, vnLinea){
		var vnCantidad = parseFloat(qf(document.form1['DCcantidad_'+vnLinea].value)); 		//variable con la cantidad
		var vnPrecio = parseFloat(qf(document.form1['DCpreciou_'+vnLinea].value));			//variable con el precio
		var vnDescuento = parseFloat(qf(document.form1['DCdesclin_'+vnLinea].value));		//variable con el descuento		
		var voSeleccionado = obj.selectedIndex;
		var vsTexto = obj.options[voSeleccionado].text.split('-');
		var vnIndice = vsTexto.length -1;
		var vsPorcentaje = vsTexto[vnIndice];			
		var vnImpuestos = ((vnCantidad * vnPrecio - vnDescuento)* parseFloat(vsPorcentaje))/100.00
		document.form1['MtoImpuesto_'+vnLinea].value = vnImpuestos;
		fm(document.form1['MtoImpuesto_'+vnLinea],3);
		FuncTotLinea(vnLinea);
	}

	//Funcion para calcular el monto de descuento cuando se ha digitado el porcentaje (con regla de 3)
	function FuncCalculoDesc(vnLinea){		
		var vnSubtotal; 
		var vnCantidad = parseFloat(qf(document.form1['DCcantidad_'+vnLinea].value)); 	//variable con la cantidad
		var vnPrecio = parseFloat(qf(document.form1['DCpreciou_'+vnLinea].value));		//variable con el precio									
		var vnDescuento = parseFloat(qf(document.form1['PorcDCdesclin_'+vnLinea].value));
		vnSubtotal = vnCantidad * vnPrecio;
		document.form1['DCdesclin_'+vnLinea].value = (vnDescuento*vnSubtotal)/100;		
		fm(document.form1['DCdesclin_'+vnLinea],2);		
		//FuncTotLinea(vnLinea);		
		FuncCalculaImpuesto(document.form1['Icodigo_'+vnLinea],vnLinea);
	}

	//Funcion para calcular el porcentaje correspondiente a un monto digitado (con regla de 3) 
	function FuncCalculoMonto(vnLinea){		
		var vnSubtotal; 
		var vnCantidad =  parseFloat(qf(document.form1['DCcantidad_'+vnLinea].value)); 	//variable con la cantidad
		var vnPrecio =  parseFloat(qf(document.form1['DCpreciou_'+vnLinea].value));		//variable con el precio
		var vnDescuento = parseFloat(qf(document.form1['DCdesclin_'+vnLinea].value));
		vnSubtotal = vnCantidad * vnPrecio;				
		document.form1['PorcDCdesclin_'+vnLinea].value = (100*vnDescuento)/vnSubtotal;		
		fm(document.form1['PorcDCdesclin_'+vnLinea],2);			
		FuncCalculaImpuesto(document.form1['Icodigo_'+vnLinea],vnLinea);
	}
	
	//Función para calcular el subtotal (cantidad * precio unitario)
	function FuncSubtotal(vnLinea){
		var vnCantidad = parseFloat(qf(document.form1['DCcantidad_'+vnLinea].value)); 	//variable con la cantidad
		var vnPrecio = parseFloat(qf(document.form1['DCpreciou_'+vnLinea].value));		//variable con el precio
		document.form1['Subtotal_'+vnLinea].value = vnCantidad * vnPrecio;
		fm(document.form1['Subtotal_'+vnLinea],2);
		FuncTotLinea(vnLinea);	
		FuncCalculoMonto(vnLinea);
		FuncCalculoDesc(vnLinea);
		FuncCalculaImpuesto(document.form1['Icodigo_'+vnLinea],vnLinea);
	}		
	
	//Función para  obtener el total de la linea
	function FuncTotLinea(vnLinea){
		var vnSubtotal = parseFloat(qf(document.form1['Subtotal_'+vnLinea].value)); 	//variable con la cantidad
		var vnDescuento = parseFloat(qf(document.form1['DCdesclin_'+vnLinea].value));		//variable con el precio
		var vnImpuesto = parseFloat(qf(document.form1['MtoImpuesto_'+vnLinea].value));
		document.form1['DCtotallin_'+vnLinea].value = (vnSubtotal - vnDescuento + vnImpuesto);
		fm(document.form1['DCtotallin_'+vnLinea],2);
		document.form1['MtoSImpuesto_'+vnLinea].value = (vnSubtotal - vnDescuento);
		fm(document.form1['MtoSImpuesto_'+vnLinea],2);	
		fnTotal();	
	}		
	
	function fnTotal(){
		vnSubtotal = 0;
		vnDescuento = 0;
		vnImpuesto = 0;
		<cfloop query="rsLineasProceso">
			vnSubtotal = vnSubtotal + parseFloat(qf(document.form1['Subtotal_<cfoutput>#rsLineasProceso.DSlinea#</cfoutput>'].value));
			vnDescuento = vnDescuento + parseFloat(qf(document.form1['DCdesclin_<cfoutput>#rsLineasProceso.DSlinea#</cfoutput>'].value));
			vnImpuesto = vnImpuesto + parseFloat(qf(document.form1['MtoImpuesto_<cfoutput>#rsLineasProceso.DSlinea#</cfoutput>'].value));
		</cfloop>
		document.form1.totalE.value = fm(vnSubtotal - vnDescuento + vnImpuesto,2);
	}
	
</script>

<form action="compraProceso-cotizmanual-sql.cfm" method="post" name = "form1" onSubmit="javascript: return _endform();" >
	<input type="hidden" name="opt" value="">
	<!---- El input opcion me indica si se selecciono la opcion a) Cotización por proceso la b)Cotización por proveedor
	los valores son: 0: para la opcion a y 1:para la opcion b----->
	<input type="hidden" name="opcion" value="<cfif isdefined("form.opcion")><cfoutput>#form.opcion#</cfoutput><cfelse>1</cfif>">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td class="subTitulo" align="center"><font size="2">Encabezado de Cotizaci&oacute;n</strong></td>
		</tr>
		<tr> 
			<td>
				<cfif modo neq 'ALTA'>
					<cfset ts = "">	
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
					<input type="text" name="ECid" value="#form.ECid#">					
				</cfif>
				<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >
					<tr>
						<td nowrap align="right"><strong>Consecutivo:&nbsp;</strong></td>
						<td nowrap><cfif modo neq 'ALTA'>#rsForm.ECconsecutivo#<cfelse>Sin asignar</cfif></td>
						<td align="right" nowrap><strong>Proveedor:</strong>&nbsp;</td>
					 	<td colspan="3" nowrap>															
							<cfquery name="rsSocio" datasource="#session.dsn#">
								select SNcodigo,SNnumero, SNnombre
								from SNegocios
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">								
									<cfif isdefined("form.SNcodigo") and len(trim(form.SNCodigo))>										
										and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#"> 									
									</cfif>
									<cfif isdefined("rsForm.SNcodigo")>
										and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.SNcodigo#">
									</cfif>		
							</cfquery>	
							 <cfoutput>
								<input type="hidden" name="SNcodigo1" value="<cfif not isdefined("vnSocio") and isdefined("form.btnNueva_cotizacion_proveedor")><cfelseif isdefined("rsSocio") and (rsSocio.RecordCount NEQ 0)>#rsSocio.SNcodigo#</cfif>">
								<input type="text" size="10" name="SNnumero1" value="<cfif not isdefined("vnSocio") and isdefined("form.btnNueva_cotizacion_proveedor")><cfelseif isdefined("rsSocio") and rsSocio.RecordCount NEQ 0>#rsSocio.SNnumero#</cfif>" onBlur="javascript:traerSocioNegocio(this.value,1);">								
								<input type="text" size="40" name="SNnombre1" value="<cfif not isdefined("vnSocio") and isdefined("form.btnNueva_cotizacion_proveedor")><cfelseif isdefined("rsSocio") and rsSocio.RecordCount NEQ 0>#rsSocio.SNnombre#</cfif>" readonly="" disabled>									
							 </cfoutput>
							 <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Socios de Negocio" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisocioNegociosProceso(1);'></a>							 
                        </td>
						<td align="right"><strong>N&uacute;mero:&nbsp;</strong></td>
						<td><input tabindex="1" type="text" name="ECnumero" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.ECnumero)#</cfif>" size="15" maxlength="10"  onFocus="this.select();" >&nbsp;</td>
					</tr>
					<tr>
					  <td align="right" nowrap><strong>Moneda:</strong>&nbsp;</td>
					  <td>
                        <cfif modo NEQ "ALTA">
                          <cf_sifmonedas tabindex="1" query="#rsForm#" valuetc="#rsForm.ECtipocambio#" onchange="asignaTC();" fechasugtc="#LSDateFormat(rsForm.ECfechacot,'DD/MM/YYYY')#">
                          <cfelse>
                          <cf_sifmonedas onchange="asignaTC();" fechasugtc="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
                        </cfif>
                      </td>
						<td align="right" nowrap><strong>Tipo de Cambio:</strong>&nbsp;</td>
						<td>
                          <input tabindex="1" type="text" name="ECtipocambio" style="text-align:right"size="14" maxlength="10" 
										onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
										onFocus="javascript:this.select();" 
										onChange="javascript: fm(this,4);"
										value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsForm.ECtipocambio,',9.0000')#</cfoutput></cfif>">
                        </td>
						<td align="right" nowrap><strong>Referencia:&nbsp;</strong></td>
						<td><input tabindex="1" type="text" name="ECnumprov" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.ECnumprov)#</cfif>" size="18" maxlength="10"   onFocus="this.select();"></td>
						<td align="right"><strong>Fecha:&nbsp;</strong></td>
						<td>
                          <cfset fecha = Now() >
                          <cfif modo neq 'ALTA'>
                            <cfset fecha = rsForm.ECfechacot>
                          </cfif>
                          <cf_sifcalendario tabindex="1" name="ECfechacot" value="#LSDateFormat(fecha, 'dd/mm/yyyy')#"> 
						</td>
					</tr>
					<tr>
					  <td align="right" nowrap><strong>V&aacute;lido hasta:</strong>&nbsp;</td>
					  <td nowrap>
                          <cfset fechavalida = Now() >
                          <cfif modo EQ 'CAMBIO'>
                            <cfset fechavalida = rsForm.ECfechavalido >
                          </cfif>
                          <cf_sifcalendario tabindex="1" name="ECfechavalido" value="#LSDateFormat(fechavalida, 'dd/mm/yyyy')#"> 
					  </td>
					  <td align="right" nowrap><strong>Forma pago:</strong>&nbsp;</td>
					  <td nowrap>
                        <select name="CMFPid" tabindex="1" onChange="javascript: getPlazo(this.value);">
                          <cfloop query="rsCMFormasPago">
                            <option value="#CMFPid#" <cfif modo EQ 'CAMBIO' and rsCMFormasPago.CMFPid eq rsForm.CMFPid> selected<cfelseif isdefined("rsFormaPagoSocio") and len(trim(rsFormaPagoSocio.CMFPid)) and rsCMFormasPago.CMFPid eq rsFormaPagoSocio.CMFPid>selected<cfelseif modo EQ 'ALTA' and rsCMFormasPago.CMFPid EQ defaultProcesoCompra.CMFPid> selected</cfif>><!----#rsCMFormasPago.CMFPcodigo# - ---->#rsCMFormasPago.CMFPdescripcion#</option>
                          </cfloop>
                        </select>
                      </td>
					  <td align="right" nowrap><strong>Incoterm:</strong>&nbsp;</td>
					  <td colspan="3" nowrap>
                        <select name="CMIid" tabindex="1">
                          <option value="">--Ninguno--</option>
                          <cfloop query="rsCMIncoterm">
                            <option value="#rsCMIncoterm.CMIid#" <cfif modo EQ 'CAMBIO' and rsCMIncoterm.CMIid eq rsForm.CMIid> selected<cfelseif modo EQ 'ALTA' and rsCMIncoterm.CMIid EQ defaultProcesoCompra.CMIid> selected</cfif>>#rsCMIncoterm.CMIcodigo# - #rsCMIncoterm.CMIdescripcion#</option>
                          </cfloop>
                        </select>						
                      </td>
				  </tr>
					<tr>
					  <td align="right" nowrap><strong>Descripci&oacute;n:</strong>&nbsp;</td>
					  <td colspan="5">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                          <tr>
                            <td>
                              <input tabindex="1" type="text" size="70" name="ECdescprov" value="<cfif modo NEQ 'ALTA'>#rsForm.ECdescprov#</cfif>" maxlength="255"  onFocus="this.select();" >
                              <input type="hidden" name="ECobsprov" id="ECobsprov" value="<cfif modo neq 'ALTA'>#rsForm.ECobsprov#</cfif>" >
								&nbsp; <a href="javascript:info();"><img border="0" src="../../imagenes/iedit.gif" alt="Observaciones"></a> </td>
                          </tr>
                      	</table>
					  </td>
                      <td align="right" nowrap><strong>Total Cotizaci&oacute;n:</strong>&nbsp;</td>
                      <td><cf_monto name="totalE" readonly="true"/></td>
					</tr>
				</table>	
				</cfoutput>
			</td>
		</tr>			
		<!---- Detalle de Registro Manual de Cotización --->
		<tr>
			<td class="subTitulo" align="center"> <font size="2">Detalle de Cotizaci&oacute;n</font></td></tr>
		<tr> 

			<td align="center">
				<div style="overflow:auto; height:200; width:778; margin:0;"><!----width:778; ----->
			      <table width="100%" border="0" cellspacing="0" cellpadding="2">
                    <tr>
                      <td class="tituloListas" align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; ">Cantidad</td>
                      <td class="tituloListas" align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Unidades</td>
                      <td class="tituloListas" align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Precio unitario</td>
                      <td class="tituloListas" align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Subtotal</td>
                      <td class="tituloListas" align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">% Descuento</td>
                      <td align="center" class="tituloListas" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Descuento</td>
					  <td align="center" class="tituloListas" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Mto Sin Impuesto</td>
                      <td colspan="2" align="center" class="tituloListas" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Impuesto</td>
                      <td align="center" class="tituloListas" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Mto Impuesto</td>
                      <td align="center" class="tituloListas" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Total Línea</td>
                      <td class="tituloListas" align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Garant&iacute;a<br>
                        (d&iacute;as)</td>
                      <td class="tituloListas" align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Plazo Cr&eacute;dito</td>
                      <td class="tituloListas" align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">Plazo Entrega</td>
                    </tr>				
                   <cfif rsLineasProceso.RecordCount EQ 0>
				    <tr><td colspan="13">&nbsp;</td></tr>
					<tr><td colspan="13" align="center">---------------------  No hay líneas para el proveedor seleccionado   ---------------------</tr>				   
					<tr><td colspan="13">&nbsp;</td></tr>
				   <cfelse>
				   <!---- <cfloop query="rsLineasProceso"> ---->
				   <cfoutput query="rsLineasProceso" group="DSlinea">					  
					  <cfif modo EQ "CAMBIO">                      						
						<cfquery name="rsDetalleLinea" dbtype="query">
						  select * 
						  from rsDetalles 
						  where DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasProceso.DSlinea#">
                        </cfquery>						
						
					  <cfelseif modo EQ 'ALTA'>									  	
					  	<cfset rsDetalleLinea.DCcantidad = 0>
						<cfset rsDetalleLinea.DCpreciou = 0.00>
						<cfset rsDetalleLinea.DCporcimpuesto = 0.00>
                      </cfif>
					  
                      <tr>
                        <td colspan="12" style="border-bottom: 1px solid black; background-color:##999999; color:##FFFFFF; font-weight: bold;">
						  <input name="DSlinea" type="hidden" value="#rsLineasProceso.DSlinea#">
                          <input name="DSdescalterna#rsLineasProceso.DSlinea#" type="hidden" value="#trim(rsLineasProceso.DSdescalterna)#">
                          <input name="DSobservacion#rsLineasProceso.DSlinea#" type="hidden" value="#trim(rsLineasProceso.DSobservacion)#">
                          <a href="javascript:infolinea(#rsLineasProceso.DSlinea#);"><img border="0" src="../../imagenes/iedit.gif" alt="informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a> 
						  &nbsp;Item: 
						  	<!----
							<cfif isdefined("rsLineasProceso.Acodigo") and rsLineasProceso.Acodigo NEQ ''>
								&nbsp;#rsLineasProceso.Acodigo# &nbsp; - 
							</cfif>
							----->
								&nbsp;#rsLineasProceso.DSdescripcion# &nbsp;
						  	<cfif isdefined("vsArticulos") and len(trim(vsArticulos))>
							  <cfif ListContains(vsArticulos,rsLineasProceso.Aid,',') NEQ 0>
									<strong>N° Parte:</strong>&nbsp;<input name="NumeroParte#rsLineasProceso.DSlinea#" type="text" value="<cfif modo EQ 'ALTA'>#rsLineasProceso.NumeroParte#<cfelse>#rsDetalleLinea.numparte#</cfif>" size="15" maxlength="20">								
									&nbsp;<label><strong>Marca:</strong></label>
									&nbsp;
									<select name="AFMid#rsLineasProceso.DSlinea#">
										<option value="">Ninguna</option>
										<cfloop query="rsMarcas">					
											<option value="#rsMarcas.AFMid#" <cfif modo EQ 'CAMBIO' and rsMarcas.AFMid eq rsDetalleLinea.AFMid >selected<cfelseif modo EQ 'ALTA' and  rsMarcas.AFMid EQ rsLineasProceso.AFMid>selected</cfif>>#rsMarcas.AFMcodigo# - #rsMarcas.AFMdescripcion#</option>
										</cfloop>						
									</select>
									&nbsp;<label><strong>Actualiza N° Parte</strong></label>
									&nbsp;<input type="checkbox" name="actnumparteprov#rsLineasProceso.DSlinea#" value="" <cfif modo EQ 'CAMBIO' and (rsDetalleLinea.actnumparteprov EQ 1)>checked</cfif>>
									
							  </cfif>
						  </cfif>
						</td>
                        <!---
						<td colspan="11" style="border-bottom: 1px solid black; background-color:##999999; color:##FFFFFF; font-weight: bold;">
							#rsLineasProceso.DSdescripcion#
							&nbsp;
						</td>					
						<td colspan="6" style="border-bottom: 1px solid black; background-color:##999999; color:##FFFFFF; font-weight: bold;">	
							<input name="DSlinea" type="hidden" value="#rsLineasProceso.DSlinea#">
							<input name="DSdescalterna#rsLineasProceso.DSlinea#" type="hidden" value="#trim(rsLineasProceso.DSdescalterna)#">
							<input name="DSobservacion#rsLineasProceso.DSlinea#" type="hidden" value="#trim(rsLineasProceso.DSobservacion)#">							
							<a href="javascript:infolinea(#rsLineasProceso.DSlinea#);"><img border="0" src="../../imagenes/iedit.gif" alt="informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a>																	
						</td>
						---->
                        <td colspan="2" align="right" class="tituloListas" style="border-bottom: 1px solid black; border-right: 1px solid black; background-color:##999999; color:##FFFFFF; font-weight: bold; "> &nbsp;
                            <!--- Total:  <input name="DCtotallin_#rsLineasProceso.DSlinea#" type="text" size="15" maxlength="20" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCtotallin,',9.00')#<cfelse>0.00</cfif>" style="text-align: right; border: none;" tabindex="-1" readonly>--->
                        </td>
                      </tr>

                      <tr>
                        <td align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; ">
                          <cfset lvarCantidad = rsLineasProceso.CantDisponible><!----rsLineasProceso.DScant>---->
                          <input onChange="javascript: FuncSubtotal(#rsLineasProceso.DSlinea#);" type="text" name="DCcantidad_#rsLineasProceso.DSlinea#" size="10" maxlength="14" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCcantidad, ',9.00')#<cfelseif Len(Trim(lvarCantidad))>#LSNumberFormat(lvarCantidad, ',9.00')#<cfelse>0.00</cfif>" tabindex="2">
                          <input type="hidden" name="DCdescprov_#rsLineasProceso.DSlinea#" value="<cfif modo EQ 'CAMBIO'>#rsDetalleLinea.DCdescprov#</cfif>">
                        </td>

                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">
                          <cfset lvarUnidad = rsLineasProceso.Ucodigo>
						  <select name="Ucodigo_#rsLineasProceso.DSlinea#" tabindex="2">
                            <cfloop query="rsUnidades">
                              <option value="#rsUnidades.Ucodigo#" <cfif modo EQ 'CAMBIO' and rsUnidades.Ucodigo EQ rsDetalleLinea.Ucodigo> selected<cfelseif modo EQ 'ALTA' and rsUnidades.Ucodigo EQ lvarUnidad> selected</cfif>>#rsUnidades.Ucodigo# - #rsUnidades.Udescripcion#</option>
                            </cfloop>
                          </select>

                          <input type="hidden" name="DCconversion_#rsLineasProceso.DSlinea#" value="<cfif modo EQ "CAMBIO">#rsDetalleLinea.DCconversion#<cfelse>1.00</cfif>">
                        </td>
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">
						  <cfparam name="rsDetalleLinea.DCpreciou" default="0">
						  <!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
						  #LvarOBJ_PrecioU.inputNumber("DCpreciou_#rsLineasProceso.DSlinea#", rsDetalleLinea.DCpreciou, "2", false, "", "", "", "FuncSubtotal(#rsLineasProceso.DSlinea#);")#
                        </td>						
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">                          
						  <!----- and not isdefined("form.SNcodigo")---->
						  <input readonly="" class="cajasinbordeb" name="Subtotal_#rsLineasProceso.DSlinea#" type="text" size="12" maxlength="20" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCcantidad*rsDetalleLinea.DCpreciou,',9.00')#<cfelse>0.00</cfif>" style="text-align: right;" tabindex="2">
                        </td>
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">
						  <input onChange="javascript: FuncCalculoDesc(#rsLineasProceso.DSlinea#);" name="PorcDCdesclin_#rsLineasProceso.DSlinea#" type="text" size="12" maxlength="20" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'><cfelse>0.00</cfif>" style="text-align: right;" tabindex="2">						  
                        </td>
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">                          
						  <input onChange="javascript: FuncCalculoMonto(#rsLineasProceso.DSlinea#);" name="DCdesclin_#rsLineasProceso.DSlinea#" type="text" size="12" maxlength="20" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCdesclin,',9.00')#<cfelse>0.00</cfif>" style="text-align: right;" tabindex="2">
                        </td>
						<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">                          
						  <input readonly="" class="cajasinbordeb" name="MtoSImpuesto_#rsLineasProceso.DSlinea#" type="text" size="12" maxlength="20" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo NEQ 'CAMBIO'>0.00</cfif>" style="text-align: right;" tabindex="2">
                        </td>
                        <td colspan="2" align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">
							<cfset lvarImpuesto = rsLineasProceso.Icodigo>
							<select name="Icodigo_#rsLineasProceso.DSlinea#" tabindex="2" onChange="javascript:FuncCalculaImpuesto(this,#rsLineasProceso.DSlinea#);">
							<cfloop query="rsImpuestos">
								<option value="#rsImpuestos.Icodigo#" <cfif modo EQ 'CAMBIO' and rsImpuestos.Icodigo EQ rsDetalleLinea.Icodigo> selected<cfelseif modo EQ 'ALTA' and rsImpuestos.Icodigo EQ lvarImpuesto> selected</cfif>>#rsImpuestos.Icodigo# - #rsImpuestos.Iporcentaje#</option>
							</cfloop>
							</select>
                        </td>
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">
							<cfif modo EQ 'CAMBIO' and not isdefined("form.SNcodigo")>
                                <cfset LvarMtoImpuesto = ((rsDetalleLinea.DCcantidad*rsDetalleLinea.DCpreciou-rsDetalleLinea.DCdesclin)*rsDetalleLinea.DCporcimpuesto)/100.00>
                            <cfelse>
                                <cfset LvarMtoImpuesto = 0>
							</cfif>
						  	<input readonly="" class="cajasinbordeb" name="MtoImpuesto_#rsLineasProceso.DSlinea#" 
                            	type="text" size="12" maxlength="20" 
                          		value="#LSNumberFormat(LvarMtoImpuesto,',9.000')#"
                            	onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								style="text-align: right;" tabindex="2"
							>
                        </td>
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; ">
                          <input readonly="" class="cajasinbordeb" name="DCtotallin_#rsLineasProceso.DSlinea#" type="text" size="12" maxlength="20" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCtotallin,',9.00')#<cfelse>0.00</cfif>" style="text-align: right;" tabindex="2">
                        </td>
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; "><input name="DCgarantia_#rsLineasProceso.DSlinea#" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#rsDetalleLinea.DCgarantia#<cfelse>0</cfif>" size="5" maxlength="10" tabindex="2"></td>
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black;"><input name="DCplazocredito_#rsLineasProceso.DSlinea#" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#rsDetalleLinea.DCplazocredito#<cfelse>0</cfif>" size="5" maxlength="10" tabindex="2" readonly></td>
                        <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black;"><input name="DCplazoentrega_#rsLineasProceso.DSlinea#" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#rsDetalleLinea.DCplazoentrega#<cfelse>0</cfif>" size="5" maxlength="10" tabindex="2"></td>
                      </tr>			

						<cfif modo EQ 'CAMBIO'>
							<script language='javascript' type='text/JavaScript'>FuncCalculoMonto(#rsLineasProceso.DSlinea#);</script>
						</cfif>						
                    <!---</cfloop>---->
					</cfoutput>
					</cfif>

                  </table>
			  </div>				
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td align="center">
				<!---
				<cfif modo neq "ALTA"><cfset Aplicar =",Aplicar"><cfelse><cfset Aplicar =""></cfif><cf_botones nameenc="Cotización" generoenc="F" modo = "#modo#" mododet = "#dmodo#" include = "Regresar#Aplicar#" tabindex="3">
				--->
				<input type="submit" name="btnGuardar" value="Guardar" onClick="javascript: return habilitarValidacion();" tabindex="3">
				<cfif modo EQ "CAMBIO">
					<input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript: habilitarValidacion();" tabindex="3">
				</cfif>
				<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: deshabilitarValidacion(); funcRegresar();" tabindex="3">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</form>
<!----</cfoutput>---->

<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>


<script language='javascript' type='text/JavaScript' >
<!--//

	qFormAPI.setLibraryPath('/cfmx/sif/js/qForms/');		
	qFormAPI.include('*');	
	qFormAPI.errorColor = '#FFFFCC';	
	objForm = new qForm('form1');

		
	function __isPositiveFloat(){
		if (!objForm.allowsubmitonerror){
			// Valida si la cantidad es mayor a 0.00
			if (parseFloat(this.obj.form["DCcantidad_"+this.name.split('_')[1]].value) > 0.00) {
				// check to make sure the current value is greater then zero
				if( parseFloat(this.value) < 0.01 ){
					// here's the error message to display					
					this.error = "El campo " + this.description + " debe ser un número mayor a 0.00.";
				}
			}
		}
	}		

	function __isFechaValida() {
		if (this.required && this.obj.form.ECfechavalido.value != "") {
			var a = this.obj.form.ECfechacot.value.split("/");
			var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
			var b = this.obj.form.ECfechavalido.value.split("/");
			var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
			if (fin < ini) {
				this.error = "La fecha de cotización no puede ser mayor a la fecha de validez de cotización";
			}
		}
	}

	_addValidator("isPositiveFloat", __isPositiveFloat);
	_addValidator("isFechaValida", __isFechaValida);
	
	objForm.ECnumero.description = "Número";
	objForm.ECnumero.required=true;
	objForm.ECnumero.obj.focus();
	
	objForm.ECfechacot.description = "Fecha";
	objForm.ECfechacot.required=true;
	objForm.ECfechacot.validateFechaValida();
	
	objForm.CMFPid.required = true;
	objForm.CMFPid.description = "Forma de Pago";

	objForm.SNnumero1.description = "Proveedor";
	objForm.SNnumero1.required=true;


	objForm.SNcodigo1.description = "Proveedor";
	objForm.SNcodigo1.required=true;
	
	objForm.ECdescprov.description = "Descripción";
	objForm.ECdescprov.required=true;
	
	<cfoutput query="rsLineasProceso">
		objForm.DCcantidad_#rsLineasProceso.DSlinea#.description = "Cantidad";
		//objForm.DCcantidad_#rsLineasProceso.DSlinea#.required = true;
		//objForm.DCcantidad_#rsLineasProceso.DSlinea#.validatePositiveFloat();
		objForm.DCgarantia_#rsLineasProceso.DSlinea#.description = "Garantía";
		//objForm.DCgarantia_#rsLineasProceso.DSlinea#.required = true;
		objForm.DCplazocredito_#rsLineasProceso.DSlinea#.description = "Plazo de Crédito";
		//objForm.DCplazocredito_#rsLineasProceso.DSlinea#.required = true;
		objForm.DCplazoentrega_#rsLineasProceso.DSlinea#.description = "Plazo de Entrega";
		//objForm.DCplazoentrega_#rsLineasProceso.DSlinea#.required = true;
		objForm.DCpreciou_#rsLineasProceso.DSlinea#.description = "Precio Unitario";
		//objForm.DCpreciou_#rsLineasProceso.DSlinea#.required = true;
		
		//objForm.DCpreciou_#rsLineasProceso.DSlinea#.validatePositiveFloat();
		
		objForm.Icodigo_#rsLineasProceso.DSlinea#.description = "Impuesto";
		//objForm.Icodigo_#rsLineasProceso.DSlinea#.required = true;
		objForm.Ucodigo_#rsLineasProceso.DSlinea#.description = "Unidades";
		//objForm.Ucodigo_#rsLineasProceso.DSlinea#.required = true;
		objForm.DCdesclin_#rsLineasProceso.DSlinea#.description = "Descuento";
		//objForm.DCdesclin_#rsLineasProceso.DSlinea#.required = true;
		objForm.DCdescprov_#rsLineasProceso.DSlinea#.description = "Descripción";
		//objForm.DCdescprov_#rsLineasProceso.DSlinea#.required = true;
	</cfoutput>


	function habilitarValidacion(){
		objForm.ECnumero.required 	= true;
		objForm.ECfechacot.required = true;
		objForm.SNcodigo1.required	= true;
		objForm.CMFPid.required 	= true;
		objForm.ECdescprov.required = true;
		errorPrecio   = "";
		errorCantidad = "";
		<cfoutput query="rsLineasProceso">
			if (document.form1.DCpreciou_#rsLineasProceso.DSlinea#.value <= 0 && errorPrecio =="")
				errorPrecio = '\n Existen lineas de la Cotización con Precio menor o igual a cero';
				
			if (document.form1.DCcantidad_#rsLineasProceso.DSlinea#.value <= 0 && errorCantidad =="")
				errorCantidad = '\n Existen lineas de la Cotización con cantidad menor o igual a cero';
		</cfoutput>
		
		if (errorPrecio != "" || errorCantidad != "" ){
			alert('Se presentaron los siguientes Errores:'+ errorPrecio + errorCantidad );
			return false;
			objForm.allowsubmitonerror = true;
		}
		else 
			objForm.allowsubmitonerror = false;
	}
	
	function deshabilitarValidacion(){
		objForm.ECnumero.required = false;
		objForm.ECfechacot.required = false;
		objForm.SNcodigo1.required = false;
		objForm.CMFPid.required = false;
		objForm.ECdescprov.required = false;
		<!---
		<cfoutput query="rsLineasProceso">
			objForm.DCcantidad_#rsLineasProceso.DSlinea#.required = false;
			//objForm.DCgarantia_#rsLineasProceso.DSlinea#.required = false;
			//objForm.DCplazocredito_#rsLineasProceso.DSlinea#.required = false;
			//objForm.DCplazoentrega_#rsLineasProceso.DSlinea#.required = false;
			objForm.DCpreciou_#rsLineasProceso.DSlinea#.required = false;
			objForm.Icodigo_#rsLineasProceso.DSlinea#.required = false;
			objForm.Ucodigo_#rsLineasProceso.DSlinea#.required = false;
			objForm.DCdesclin_#rsLineasProceso.DSlinea#.required = false;
			//objForm.DCdescprov_#rsLineasProceso.DSlinea#.required = false;
		</cfoutput>
		--->
		objForm.allowsubmitonerror = true;
	}
	
	function funcAplicar(){
		deshabilitarValidacion();
	}
	
	function _endform(){
		objForm.ECtipocambio.obj.disabled = false;
		
		<cfoutput query="rsLineasProceso">
			objForm.DCcantidad_#rsLineasProceso.DSlinea#.obj.value = qf(objForm.DCcantidad_#rsLineasProceso.DSlinea#.obj.value);
			//objForm.DCgarantia_#rsLineasProceso.DSlinea#.obj.value = qf(objForm.DCgarantia_#rsLineasProceso.DSlinea#.obj.value);
			//objForm.DCplazocredito_#rsLineasProceso.DSlinea#.obj.value = qf(objForm.DCplazocredito_#rsLineasProceso.DSlinea#.obj.value);
			//objForm.DCplazoentrega_#rsLineasProceso.DSlinea#.obj.value = qf(objForm.DCplazoentrega_#rsLineasProceso.DSlinea#.obj.value);
			objForm.DCpreciou_#rsLineasProceso.DSlinea#.obj.value = qf(objForm.DCpreciou_#rsLineasProceso.DSlinea#.obj.value);
			objForm.DCdesclin_#rsLineasProceso.DSlinea#.obj.value = qf(objForm.DCdesclin_#rsLineasProceso.DSlinea#.obj.value);
		</cfoutput>
		return true;
	}
	function funcRegresar(){
		location.href = "compraProceso.cfm?opt=5";
		return false;
	}

	asignaTC();
	<cfif modo EQ 'ALTA'>
		getPlazo(document.form1.CMFPid.value);
	</cfif>
	
	// Funcion para ejecutar componente de observaciones 
	function infolinea(index){		
		open('solicitudes-info.cfm?sololectura=1&index='+index, 'solicitudes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
	
	//Funcion muestra conlis
	function doConlisocioNegociosProceso(valor) {
		popUpWindow("/cfmx/sif/cm/operacion/ConlisocioNegociosProceso.cfm?formulario=form1&idx="+valor,30,100,600,400);
	}
	//Funcion traer datos al conlis cuando se digita
	function traerSocioNegocio(value, index){
	  if (value!=''){	   
	   document.getElementById("fr").src = 'socioNegociosProcesoquery.cfm?formulario=form1&codigo='+value+'&index='+index;
	  }
	  else{
	   document.form1.SNcodigo1.value = '';
	   document.form1.SNnumero1.value = '';
	   document.form1.SNnombre1.value = '';
	  }
	}	

	//-->
</script>

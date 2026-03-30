<cfif isdefined("form.ECid") and len(form.ECid) and not isdefined("form.chk")>
	<cfset form.chk = form.ECid>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("form.chk")>
	
	<cfloop list="#form.chk#" delimiters="," index="i">
		<!--- Actualizar los totales de impuestos y total de linea --->
		<cfquery name="CotizacionDetalle_ABC" datasource="#Session.DSN#">
			update DCotizacionesCM
			set 	DCtotimp = round(((DCcantidad * DCpreciou - DCdesclin)* DCporcimpuesto)/100,2),
					DCtotallin = round((DCcantidad * DCpreciou) + (((DCcantidad * DCpreciou - DCdesclin) * DCporcimpuesto) / 100.00) - DCdesclin,2)
			where ECid = #i#
			and Ecodigo = #session.Ecodigo#
		</cfquery>

		<!--- Actualizar el encabezado de la cotización --->
		<cfquery name="rsTotalesDetalle" datasource="#Session.DSN#">
			select 
				round(coalesce(sum(DCcantidad*DCpreciou),0),2) as ECsubtotal,
				coalesce(sum(DCdesclin),0) as ECtotdesc,
				coalesce(sum(DCtotimp),0) as ECtotimp,
				coalesce(sum(DCtotallin),0) as ECtotal
			from DCotizacionesCM
			where ECid = #i#
			and Ecodigo = #session.Ecodigo#
		</cfquery>

		<cfquery name="updCotizacion" datasource="#Session.DSN#">
			update ECotizacionesCM set
				ECsubtotal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotalesDetalle.ECsubtotal#" scale="2">,
				ECtotdesc = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesDetalle.ECtotdesc#">,
				ECtotimp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotalesDetalle.ECtotimp#" scale="2">,
				ECtotal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotalesDetalle.ECtotal#" scale="2">,
				ECestado = 5
			where ECid = #i#
			and Ecodigo = #session.Ecodigo#
		</cfquery>
						
		<!---- Insertar las clasificaciones al socio de negocio (siempre y cuando no esten ya asignadas al proveedor y la cantidad de la cotización no sea 0) ----->		
		<cfquery datasource="#Session.DSN#">
			insert into ClasificacionItemsProv (Ecodigo, SNcodigo, CCid, Ccodigo, nivel, BMUsucodigo, fechaalta,AClaId)
				select 	distinct 
						#session.Ecodigo# as Ecodigo,
						h.SNcodigo,
						e.CCid,
						d.Ccodigo,
						case when c.Aid is not null then f.Cnivel else g.CCnivel end as nivel,
						#session.Usucodigo# as Usuario,
						<cf_dbfunction name="now">	as fecha,
						cl.AClaId						
										
				from DCotizacionesCM a
							
					inner join ECotizacionesCM h
						on a.ECid = h.ECid
						and a.Ecodigo = h.Ecodigo
				
					inner join CMLineasProceso b
						on a.CMPid = b.CMPid
						and a.DSlinea = b.DSlinea
							
					inner join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and b.ESidsolicitud = c.ESidsolicitud
						
						left outer join Articulos d
							on c.Aid = d.Aid
							and c.Ecodigo = d.Ecodigo
				
							left outer  join Clasificaciones f
								on d.Ccodigo = f.Ccodigo
								and d.Ecodigo = f.Ecodigo
						
						left outer join Conceptos e
							on c.Cid = e.Cid
							and c.Ecodigo = e.Ecodigo		
							
							left outer join CConceptos g
								on e.CCid = g.CCid
								and e.Ecodigo = g.Ecodigo
								
						left outer join AClasificacion cl
							on c.Ecodigo = cl.Ecodigo
							and c.ACcodigo = cl.ACcodigo
							and c.ACid = cl.ACid
													
				where a.Ecodigo = #session.Ecodigo#
				and a.ECid = #i#
				and a.DCcantidad != 0
					and ( not exists (select 1 from ClasificacionItemsProv f	
										 where f.Ecodigo=#session.Ecodigo#  
										  and f.SNcodigo = h.SNcodigo
										  and e.CCid = f.CCid)
					 or not exists (select 1 from ClasificacionItemsProv f	
										 where f.Ecodigo=#session.Ecodigo#  
										  and f.SNcodigo = h.SNcodigo
										  and  d.Ccodigo = f.Ccodigo)
					or not exists (select 1 from ClasificacionItemsProv f	
										 where f.Ecodigo=#session.Ecodigo#  
										  and f.SNcodigo = h.SNcodigo
										  and  cl.AClaId = f.AClaId)
						)
		</cfquery>
		
		<!---- Insertar y/modificar en NumParteProveedor ----->
		<cfquery name="rsLineasCotizacion" datasource="#Session.DSN#">
			select 	a.numparte,
					a.AFMid,
					c.Aid,
					d.SNcodigo,
					d.ECfechavalido
					
			from DCotizacionesCM a
			
				inner join CMLineasProceso b
					on a.CMPid = b.CMPid
					and a.DSlinea = b.DSlinea
			
					inner join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and b.ESidsolicitud = c.ESidsolicitud
						
				inner join ECotizacionesCM d
					on a.	ECid = d.ECid 
					and a.Ecodigo = d.Ecodigo
			
			where a.Ecodigo = #session.Ecodigo#
				and a.ECid = #i#
				and a.actnumparteprov = 1							
		</cfquery>
		<!---- Evaluar c/linea de la cotizacion (con check de actualizacion N° Parte)---->
		<cfloop query="rsLineasCotizacion">
			<!---- Evaluar si tiene partes el articulo con ese socio de negocio y si la fecha de valides de la cotizacion esta dentro de algun periodo ----->
			<cfquery name="rsPartes" datasource="#Session.DSN#">
				select 	NPPid,	
						Vdesde,
						NumeroParte	
				from NumParteProveedor
				where Ecodigo = #session.Ecodigo#
					and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasCotizacion.Aid#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsLineasCotizacion.SNcodigo#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsLineasCotizacion.ECfechavalido#"> between Vdesde and Vhasta
			</cfquery>
			<cfif rsPartes.RecordCount NEQ 0><!--- 1. Si hay partes dentro de cuyo rango se encuentre la fecha de la cotizacion ---->
				<!--- Se le resta un dia a la fecha de validez de la cotizacion ---->				
				<cfset fecha = DateAdd("d",-1,rsLineasCotizacion.ECfechavalido)>
				<!--- Se actualiza la fecha hasta del parte ---->
				<cfif fecha GT rsPartes.Vdesde>									
					<cfquery datasource="#Session.DSN#">
						update NumParteProveedor
						set Vhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">	
						where NPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPartes.NPPid#">				
					</cfquery>
				<cfelse>				
					<cf_errorCode	code = "50292" msg = "El rango de valides del parte es superior a la fecha de la cotización">
				</cfif>
				<!--- Se inserta otro parte cuya fecha desde es la fecha de la valides de la cotizacion y la fecha hasta es indefinida (01-01-6100)----> 
				<cfquery datasource="#Session.DSN#">
					insert into NumParteProveedor (Aid, AFMid, Ecodigo, SNcodigo, NumeroParte, Vdesde, Vhasta, BMUsucodigo, fechaalta)
					values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasCotizacion.Aid#">,
							<cfif len(trim(rsLineasCotizacion.AFMid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasCotizacion.AFMid#"><cfelse>null</cfif>,
							#session.Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLineasCotizacion.SNcodigo#">,							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasCotizacion.numparte#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsLineasCotizacion.ECfechavalido#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">,
							#session.Usucodigo#,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)					
				</cfquery>
				
			<cfelse><!--- Si no hay partes para ese articulo, con ese proveedor y en la fecha de valides de la Cotizacion ---->		
				<!--- Se inserta un parte cuya fecha desde es la fecha de valides de la cotizacion (valido hasta) y la fecha hasta es indefinida (01-01-6100)---->
				<cfquery name="rsInsert" datasource="#Session.DSN#">
					insert into NumParteProveedor (Aid, AFMid, Ecodigo, SNcodigo, NumeroParte, Vdesde, Vhasta, BMUsucodigo, fechaalta)
					values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasCotizacion.Aid#">,
							<cfif len(trim(rsLineasCotizacion.AFMid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasCotizacion.AFMid#"><cfelse>null</cfif>,
							#session.Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLineasCotizacion.SNcodigo#">,							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasCotizacion.numparte#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsLineasCotizacion.ECfechavalido#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">,
							#session.Usucodigo#,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						  )					
				</cfquery>
			</cfif><!--- Fin del IF 1.---->			
		</cfloop>	
	</cfloop>
</cfif>
<cfset form.ECid = "">


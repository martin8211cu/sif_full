<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cfif isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud))>
	<cfset form.ESidsolicitud = url.ESidsolicitud>
</cfif>

<!--- Function recalculaMontos --->
<cffunction name="recalculaMontos">
	<cfargument name="id" type="numeric" required="yes">

	<cfquery datasource="#session.DSN#">
		update DSolicitudCompraCM
		set DStotallinest = round(DScant * DSmontoest,2)
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
	</cfquery>

</cffunction>

<!--- Inicialización de Componente de Aplicacion de Solicitudes --->
<cfinvoke component="sif.Componentes.PRES_Presupuesto" method="CreaTablaIntPresupuesto" Conexion= "#session.dsn#" ContaPresupuestaria="true"/><!---========== Solicitado por Oscar Bonilla (24/05/2006)==========---->
<cfinvoke component="sif.Componentes.CM_AplicaSolicitud" method="init" returnvariable="aplica">

<!--- Recalcula el campo DSlinmontoest para todas las lineas--->
<cfset recalculaMontos(form.ESidsolicitud) >

<!---- //////////// Variables /////////////---->
<cfset vnLineaAsignada = 0>			<!---Variable con la cantidad de lineas que fueron asignadas---->
<cfset vnLineas = 0>				<!---Variable con la cantidad de lineas de la solicitud---->
<cfset vnOrdenes = structnew()>		<!---Estructura con las ordenes de compra creadas para el Socio Negocio (SNcodigo)---->
<cfset vnCMCid = ''>				<!---Variable con el CMCid (comprador) 	que será asignado a todas las OC generadas por los contratos---->
<cfset vbImprimeOrden = false>		<!---Variable booleana (vb) para indicar si se muestra o no el popup con las OC generadas---->

<cftransaction>	
	<cfquery name="rsLineas" datasource="#session.DSN#"><!----Trae todas las lineas de la solicitud----->
		select 	a.DSlinea, 
				a.Aid, 
				a.Cid, 
				a.ACid, 
				b.ESfecha, 
				b.CMTScodigo,
				b.CFid,
				a.DScant, 
				c.CFcomprador, 
				c.CFautoccontrato,
				b.EStotalest,
				b.ESnumero
				
		from DSolicitudCompraCM a
	
			inner join DSProvLineasContrato d
				on a.DSlinea = d.DSlinea
				and a.Ecodigo = d.Ecodigo
	
			inner join ESolicitudCompraCM b
				on a.ESidsolicitud = b.ESidsolicitud
				and a.Ecodigo = b.Ecodigo			
	
				inner join CFuncional c
					on b.CFid = c.CFid
					and b.Ecodigo = c.Ecodigo				
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
	</cfquery>
	
	<!----ACTUALIZA EL COMPRADOR DE LA SOLICITUD---->	
	<cfset vnCMCid = aplica.asignaCompradorSolicitud(form.ESidsolicitud, session.Ecodigo) >

	<cfif rsLineas.RecordCount NEQ 0 and rsLineas.EStotalest NEQ 0><!---Si la solicitud tiene lineas---->		
		<cfif aplica.puedeAplicar(form.ESidsolicitud, session.Ecodigo)><!---Se puede aplicar la solicitud---->					
			<!---1. NO permitir aplicar la solicitud, mientras existan líneas sin asociar en la tabla DSDetalleProveedores ----->
			<cfset vnLineas = rsLineas.RecordCount>	<!---Variable con la cantidad de lineas de la solicitud---->
			<cfloop query="rsLineas"><!----Para c/linea----->
				<cfquery name="rsExisteProveedor" datasource="#session.DSN#"><!---Verificar que haya un registro (este asignada) a un proveedor (tabla:DSDetalleProveedores)----->
					select 1 
					from DSDetalleProveedores a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.DSlinea#">
				</cfquery>
				<cfif rsExisteProveedor.RecordCount NEQ 0>				<!---Si esta asignada la linea---->
					<cfset vnLineaAsignada = vnLineaAsignada + 1>		<!---Aumenta la cantidad de lineas asignadas---->
				</cfif>
			</cfloop>

			<cfif vnLineaAsignada NEQ vnLineas><!---Si las cantidades son diferentes es porque alguna línea no ha sido asignada aun---->
				<cf_errorCode	code = "50290" msg = "Alguna de las líneas de la solicitud no ha sido asignada a un proveedor aún">
			</cfif>
			
			<cfset vnIdsolicitud = form.ESidsolicitud>
			
			<!-----2. Para c/linea verificar si tiene contratos y si el disponible de los mismos alcanza para la cantidad adjudicada----->
			<cfloop query="rsLineas"><!---Para c/linea de la solicitud---->
				<!----<cfset vnCantSolic = 0>					<!---Limpiar la variable de cantidades solicitadas---->---->
				<cfset vnCantSolicitada = 0>		<!---Limpiar la variable de cantidades solicitadas en la linea---->
				<cfset vnLinea = rsLineas.DSlinea>		<!---Variable numerica (vn) con el ID de la linea que se va a procesar----->
				<cfset vnCantSolicitada = rsLineas.DScant>	<!---Variable con la cantidad de bienes solicitados---->		
				<cfquery name="rsContratos" datasource="#session.DSN#"><!----Traer los contratos a los que se adjudico la linea (Tabla: DSDetalleProveedores)----->
					select 	e.ECid, 
							e.CMTOcodigo, 
							e.CMFPid,
							e.CMIid,
							e.ECplazocredito,
							e.ECporcanticipo,
							e.ECtiempoentrega,
							d.Mcodigo, 
							d.DCtipoitem,
							d.Cid,
							d.Aid,
							d.ACcodigo,
							d.ACid,
							d.Icodigo,
							d.Ucodigo,
							d.DCdescripcion,
							d.DCdescalterna,
							c.DSobservacion,
							coalesce(d.DCtc,1.0) as DCtc,
							coalesce(d.DCcantcontrato,0) as DCcantcontrato,
							#LvarOBJ_PrecioU.enSQL_AS("coalesce(d.DCpreciou,0) / d.DCcantcontrato", "DCpreciou")#,
							d.DCgarantia,
							d.DClinea,
							coalesce(d.DCcantcontrato,0) - coalesce(d.DCcantsurtida,0) as CantDisponible,
							coalesce(d.DCcantsurtida,0) as DCcantsurtida,
							c.ESidsolicitud,
							c.DSlinea,
							coalesce(a.DSDcantidad,0) as DSDcantidad,
							a.SNcodigo,
							f.CFid,
							c.DSfechareq,
							f.CMTScodigo,
							round(coalesce(DCpreciou, 0.00),2) as totalLinea,
							f.NAP,
							f.NAPcancel
							
					from	DSDetalleProveedores a
						inner join DSProvLineasContrato b
							on a.DSlinea = b.DSlinea
							and a.Ecodigo = b.Ecodigo
					
						inner join DSolicitudCompraCM c
							on a.DSlinea = c.DSlinea
							and a.Ecodigo = c.Ecodigo
							
							inner join ESolicitudCompraCM f
								on c.ESidsolicitud = f.ESidsolicitud
								and c.Ecodigo = f.Ecodigo
					
							inner join DContratosCM d
								on c.Ecodigo = d.Ecodigo
								and c.Ucodigo = d.Ucodigo	
								and c.DStipo = d.DCtipoitem
								<!---La cantidad disponible del contrato es mayor a 0, es decir hay diponible--->
								and (coalesce(d.DCcantcontrato,0) - coalesce(d.DCcantsurtida,0)) != 0
								<cfif isdefined("rsLineas.Aid") and len(trim(rsLineas.Aid))><!---Si es un articulo---->
									and c.Aid = d.Aid
								<cfelseif isdefined("rsLineas.Cid") and len(trim(rsLineas.Cid))><!---Si es un servicio---->
									and c.Cid = d.Cid
								<cfelse><!---Si es un activo--->
									and c.ACid = d.ACid
								</cfif>
								
								inner join EContratosCM e
									on d.ECid = e.ECid
									and a.SNcodigo = e.SNcodigo
									<!----Al momento/dia de la aplicacion este vigente el contrato----->
									and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between e.ECfechaini and e.ECfechafin
					
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and c.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnLinea#">				
				</cfquery>
								
				<cfif rsContratos.RecordCount NEQ 0><!----SI EL BIEN TIENE CONTRATOS---->												
					<!----Busca comprador al cual se asignaran TODAS las OC generadas por los contratos---->
					<cfset vnCMCidLinea = aplica.determinaCompradorContrato_CMult(rsLineas.CMTScodigo,rsLineas.CFid)><!----Obtener el CMCid (comprador) según un tipo de Solicitud y Centro Funcional de la misma----->

					<cfquery datasource="#session.DSN#"><!---Pone la cantidad solicitada en 0, para luego actualizarla por la cantidad de la OC----->
						update DSolicitudCompraCM
							set DScant = 0,
                            	DScontratos = 1
						where Ecodigo = #session.Ecodigo#
							and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
							and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnLinea#">
					</cfquery>
					
					<cfloop query="rsContratos"><!----Para c/contrato que tiene el bien----->
						<cfset vnCantDisponible = 0>		<!---Limpiar variable de cantidades disponibles en el contrato---->
						<cfset vnCantSolic = 0>				<!---Limpiar la variable de cantidades adjudicadas del contrato---->
						<cfset vnECid = rsContratos.ECid>	<!----Variable con el identificador(ID) del contrato---->
						
						<cfquery name="Contrato" dbtype="query"><!---Seleccionar datos el contrato que se esta procesando---->
							select * from rsContratos
							where ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnECid#">		
						</cfquery>
						
						<cfset vnCantSolic = Contrato.DSDcantidad>			<!---Variable con la cantidad de bienes adjudicados---->		
						<cfset vnCantDisponible = Contrato.CantDisponible>	<!---Varibles con la cantidad disponible en el contrato---->

						<!---- SI LA CANTIDAD DISPONIBLE DEL BIEN EN EL CONTRATO ES MAYOR O IGUAL A LA SOLICITADA EN LA LINEA---->							
						<cfif vnCantDisponible GTE vnCantSolic>										
							<!----	Se genera OC para proveedor/socio de negocio, al que aun no se le haya "abierto" un encabezado (OC),
									Si ya existiera una solamente se le agrega una línea a la misma, esto para evitar crear una OC por c/linea---->												
							<cfset vnOrdenes = aplica.CrearOrden(Contrato.SNcodigo, Contrato, vnOrdenes, vnCMCidLinea, vnCantSolic, 1)>																											
							<cfset vbImprimeOrden = true>
							<cfset vnCantSolicitada = vnCantSolicitada - vnCantDisponible><!---Se actualiza la cantidad solicitada---->
						<!----SI LA CANTIDAD DISPONIBLE DEL CONTRATO ES MENOR QUE LA SOLICITADA---->
						<cfelseif vnCantDisponible LT vnCantSolic>
							<!----	Se genera OC para proveedor/socio de negocio, al que aun no se le haya "abierto" un encabezado (OC),
									Si ya existiera una solamente se le agrega una línea a la misma, esto para evitar crear una OC por c/linea---->																												
							<cfset vnOrdenes = aplica.CrearOrden(Contrato.SNcodigo,Contrato,vnOrdenes,vnCMCidLinea,vnCantDisponible, 1)>												
							<cfset vbImprimeOrden = true>
							<cfset vnCantSolicitada = vnCantSolicitada - vnCantDisponible><!---Se actualiza la cantidad solicitada---->		
						</cfif><!---Fin de la cantidad disponible >= que la solicitada----->
					</cfloop><!---Fin del loop de los contratos----->
                    
                    <cfquery datasource="#session.DSN#">
						update DSolicitudCompraCM
							set DScontratos = 0
						where Ecodigo = #session.Ecodigo#
							and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
							and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnLinea#">
					</cfquery>
					
					<!----	SI QUEDAN CANTIDADES SOLICITADAS SIN SURTIR POR CONTRATO, SE ENVIAN A PROCESO DE PUBLICACION---->						
					<cfif vnCantSolicitada GT 0>
						<!---a)ENVIAR A PROCESO DE PUBLICACION----->
						<!---b)Inserta nueva línea en DSolicitudCompraCM x las lineas que van al proceso de compra---->
						<cfset aplica.CrearLineaSolicitud(vnIdsolicitud, vnLinea, vnCantSolicitada, vnCMCid)>
						<!---Se asigna comprador a la linea----->
						<cfset aplica.asignaCompradorLinea(vnIdsolicitud, session.Ecodigo, vnLinea, vnCMCid)>
						<cfset vbImprimeOrden = true>						
					<cfelse><!---Si no quedan cantidades para el proceso de publicacion, se asigna linea segun contratos multiples--->
						<cfset aplica.asignaCompradorLinea(vnIdsolicitud, session.Ecodigo, vnLinea, vnCMCidLinea)>
					</cfif> 	
				<cfelse><!---Si no tiene contratos---->
					<cfset aplica.asignaCompradorLinea(vnIdsolicitud, session.Ecodigo, vnLinea, vnCMCid)>
				</cfif><!----Fin de si hay contratos---->	
				<!----CAMBIA ESTADO DE LAS LINEAS EN LA TABLA DSProvLineasContrato(0=No aplicadas, 10=Aplicadas)---->
				<cfquery datasource="#session.DSN#">
					Update DSProvLineasContrato
						set Estado = 10
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnLinea#">
				</cfquery>								
			</cfloop><!---Fin del loop de la lineas---->
			<!----ACTUALIZA ESTADO DE LA SOLICITUD---->
			<cfset aplica.cambiarEstado(vnIdsolicitud, session.Ecodigo, 20)>
			<!----NOTIFICAR AL COMPRADOR AUTORIZADO Y SUS SECUASES!)---->
			<!---<cfset aplica.EnviodeCorreos(vnCMCid, session.Ecodigo,'Ordenes de compra',vnIdsolicitud)>----->
			<cfif rsContratos.RecordCount NEQ 0>
				<cfset aplica.EnviodeCorreos(vnCMCidLinea, session.Ecodigo,'Ordenes de compra',vnIdsolicitud, 'Seleccion')>
			</cfif>
		</cfif>	<!---Fin de puede aplicar---->	
	</cfif><!---Fin de si la solicitud tiene lineas---->	
</cftransaction>	
<cfif vbImprimeOrden EQ true>
	<cflocation url="CompradorAutSolicitudes-lista.cfm?impOrden=1&ESidsolicitud=#form.ESidsolicitud#">	
<cfelse>
	<cflocation url="CompradorAutSolicitudes-lista.cfm?ESidsolicitud=#form.ESidsolicitud#">
</cfif>



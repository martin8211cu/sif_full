<cfparam name="LvarPrint" default="FALSE">
<cfset tipoformato = "pdf">
<cfset fecha_hoy = DateFormat(now(),'dd/mm/yyyy')>
<cfset Hora_hoy = TimeFormat(now())>

<!---- Invoca componente para obtener los datos del comprador en sesion/logueado (session.compras.comprador) ---->
 <cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">			 
 <cfset datos = sec.getUsuarioByRef ('#session.compras.comprador#',session.Ecodigosdc, 'CMCompradores') >

<cfset parametro = 0 >

<cfif isdefined("url.opcion") and url.opcion EQ 'proveedor'>
	<cfif isdefined("url.local") and url.local EQ 1>
		<!--- Boton Imprimir cotizacion de Proveedores OK (local) --->
		<cfset parametro = 820 >
		<cfset vsArchivo = "/sif/cm/consultas/Reportes/ResPubCompra.jasper">       
	<cfelseif isdefined("url.local") and url.local EQ 0>
			<!--- Boton Imprimir cotizacion de Proveedores CANCEL (importacion)--->
		<cfset parametro = 830 >
		<cfset vsArchivo = "/sif/cm/consultas/Reportes/ResPubCompraImpo.jasper">
	</cfif>
<cfelseif isdefined("url.opcion") and url.opcion EQ 'proceso'>
	<!--- Boton Imprimir cotizacion del Proceso --->
	<cfif isdefined("url.local") and url.local EQ 1>
		<!--- Boton Imprimir cotizacion del Proceso OK (local)--->
		<cfset parametro = 840 >
		<cfset vsArchivo = "/sif/cm/consultas/Reportes/ResPubCompra-Proceso.jasper">
	<cfelseif isdefined("url.local") and url.local EQ 0>
			<!--- Boton Imprimir cotizacion del Proceso CANCEL (importacion)--->
		<cfset parametro = 850 >
		<cfset vsArchivo = "/sif/cm/consultas/Reportes/ResPubCompraImpo-Proceso.jasper">
	</cfif>
</cfif>
  <cfset Param= "">
<cfif isdefined("url.opcion") and len(trim(url.opcion)) neq 0>
   <cfset Param = Param & "&opcion="&url.opcion>
</cfif>
<cfif isdefined("url.local") and len(trim(url.local)) neq 0>
   <cfset Param = Param & "&local="&url.local>
</cfif>

<!--- Recupera codigo del formato --->
<cfquery name="formato" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	  and Pcodigo = #parametro#
</cfquery>


<cfif formato.recordcount gt 0 and len(trim(formato.Pvalor)) >
	<!--- Recupera los datos del formato --->
	<cfquery name="data_formato" datasource="#session.DSN#">
		select FMT01cfccfm as archivo, FMT01tipfmt
		from FMT001
		where Ecodigo = #session.Ecodigo#
		  and FMT01COD = '#formato.Pvalor#'	
	</cfquery>      
	<cfif data_formato.recordcount gt 0 and listfind('0,1,4', data_formato.FMT01tipfmt) gt 0 and len(trim(data_formato.archivo)) >
		<!--- JASPER --->	
		<cfif data_formato.FMT01tipfmt eq 0 >
			<cfset vsArchivo = data_formato.archivo >
		
		<!--- Html --->		
		<cfelseif data_formato.FMT01tipfmt eq 1>				              
           	<cfset titulo = '' >
		
        		<cfif parametro eq 820 >
				<cfset titulo = 'Solicitud de Cotizaci&oacute;n Local' >
				
				<cfquery name="rs" datasource="#session.DSN#" >
					select distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							<cf_dbfunction name="sPart"	args="c.DSdescalterna,1,215"> as DSdescalterna,
							c.DSobservacion,
							u.Ucodigo,                     
							c.Aid,
							d.NumeroParte,
							q.SNnombre,                            
							q.SNidentificacion,
                            q.SNdireccion,
							q.SNcodigo,
                            coalesce(q.SNtelefono,'N/A') as SNtelefono,
                            q.SNFax, 
                            com.CMCnombre,
                            com.Usucodigo,
                            coalesce(cmfp.CMFPdescripcion, 'Definida por Proveedor') as CMFPdescripcion,
                            e.ESnumero,
                            c.DStipo,    
                            c.Ucodigo,                        
                            c.DSmontoest,
                            c.DStotallinest
				
					from CMProcesoCompra a
				
					LEFT OUTER JOIN CMProveedoresProceso m
								on a.CMPid = m.CMPid  
					LEFT OUTER JOIN  CMLineasProceso b
								on a.CMPid = b.CMPid
					LEFT OUTER JOIN Empresas g
								on g.Ecodigo =a.Ecodigo
					LEFT OUTER JOIN DSolicitudCompraCM c
								on b.DSlinea = c.DSlinea                                    
					LEFT OUTER JOIN  NumParteProveedor  d                          
								on c.Aid = d.Aid
								and a.CMPfmaxofertas between Vdesde and Vhasta
                                and d.Aid in (	select distinct Aid 
												from DSolicitudCompraCM r
												where  r.Ecodigo = #session.Ecodigo#
												   and r.Aid is not null
												   and d.Aid = r.Aid
												   and d.SNcodigo in (	select cmpp.SNcodigo 
																		from CMProveedoresProceso cmpp
																		where CMPid = #Session.Compras.ProcesoCompra.CMPid#  ))
					LEFT OUTER JOIN SNegocios q
								on d.SNcodigo=q.SNcodigo
								and d.Ecodigo=q.Ecodigo                       
					LEFT OUTER JOIN  Unidades u
								on c.Ecodigo = u.Ecodigo
								and c.Ucodigo = u.Ucodigo
					LEFT OUTER JOIN ESolicitudCompraCM e
								on c.ESidsolicitud = e.ESidsolicitud  
                    LEFT OUTER JOIN  CMCompradores com
                             on e.CMCid = com.CMCid
                    LEFT OUTER JOIN CMFormasPago cmfp
                             on a.CMFPid = cmfp.CMFPid

					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado = 20
					  
					union 
				
					select  distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,
							u.Ucodigo,                     
							c.Aid,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as NumeroParte,
							q.SNnombre,
							q.SNidentificacion,
                            q.SNdireccion,
							q.SNcodigo,
                            coalesce(q.SNtelefono,'N/A') as SNtelefono,
                            q.SNFax,
                            com.CMCnombre,
                            com.Usucodigo,
                            coalesce(cmfp.CMFPdescripcion, 'Definida por Proveedor') as CMFPdescripcion,
                            e.ESnumero,
                            c.DStipo,
                            c.Ucodigo,                            
                            c.DSmontoest,
                            c.DStotallinest
					
					from CMProcesoCompra a
						LEFT OUTER join CMProveedoresProceso m
						on a.CMPid = m.CMPid  
						
						LEFT OUTER join CMLineasProceso b
						on a.CMPid = b.CMPid
						
						LEFT OUTER join Empresas g
						on g.Ecodigo =a.Ecodigo
						
						LEFT OUTER join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and c.Aid is not null                               
					
						LEFT OUTER join Articulos h
						on c.Aid = h.Aid
						
						LEFT OUTER join Clasificaciones i
						on h.Ccodigo = i.Ccodigo
						and h.Ecodigo = i.Ecodigo
					
						LEFT OUTER join ClasificacionItemsProv j
						on i.Ccodigo = j.Ccodigo
						and i.Ecodigo = j.Ecodigo
						and j.Ccodigo is not null
						
						LEFT OUTER join SNegocios q
						on j.SNcodigo = q.SNcodigo 
						and j.Ecodigo = q.Ecodigo                                  
					
						LEFT OUTER join Unidades u
						on c.Ecodigo = u.Ecodigo
						and c.Ucodigo = u.Ucodigo
					
						LEFT OUTER join ESolicitudCompraCM e
							on c.ESidsolicitud = e.ESidsolicitud
                        
                        LEFT OUTER join CMCompradores com
                        	on e.CMCid = com.CMCid
                        
                        LEFT OUTER join CMFormasPago cmfp
                        	on a.CMFPid = cmfp.CMFPid
					
					where a.Ecodigo = #session.Ecodigo#
						  and a.CMPid =#Session.Compras.ProcesoCompra.CMPid#
						  and e.ESestado = 20
						  and j.SNcodigo  in ( select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid#)
					
					union 
				
					select distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,
							u.Ucodigo,                     
							c.Cid as Aid,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as NumeroParte,
							q.SNnombre,
							q.SNidentificacion,
                            q.SNdireccion,
							q.SNcodigo,
                            coalesce(q.SNtelefono,'N/A') as SNtelefono,
                            q.SNFax,
                            com.CMCnombre,
                            com.Usucodigo,
                            coalesce(cmfp.CMFPdescripcion, 'Definida por Proveedor') as CMFPdescripcion,
                            e.ESnumero,
                            c.DStipo,
                            c.Ucodigo,                            
                            c.DSmontoest,
                            c.DStotallinest
					
					from CMProcesoCompra a
						LEFT OUTER join CMProveedoresProceso m
						on a.CMPid = m.CMPid  
						
						LEFT OUTER join CMLineasProceso b
						on a.CMPid = b.CMPid
						
						LEFT OUTER join Empresas g
						on g.Ecodigo =a.Ecodigo
						
						LEFT OUTER join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and c.Cid is not null                                           
					
						LEFT OUTER join Conceptos h
						on c.Cid = h.Cid
						and c.Ecodigo = h.Ecodigo
						
						LEFT OUTER join CConceptos i
						on h.CCid = i.CCid
					
						LEFT OUTER join ClasificacionItemsProv j
						on i.CCid = j.CCid
						and i.Ecodigo = j.Ecodigo
						and j.CCid is not null
						
						LEFT OUTER join SNegocios q
						on j.SNcodigo = q.SNcodigo 
						and j.Ecodigo = q.Ecodigo
					
						LEFT OUTER join Unidades u
							on c.Ecodigo = u.Ecodigo
						   and c.Ucodigo = u.Ucodigo
					
						LEFT OUTER join ESolicitudCompraCM e
							on c.ESidsolicitud = e.ESidsolicitud
                        
                        LEFT OUTER join CMCompradores com
                        	on e.CMCid = com.CMCid
                        
                        LEFT OUTER join CMFormasPago cmfp
                        	on a.CMFPid = cmfp.CMFPid
					
					where a.Ecodigo  = #session.Ecodigo#
					  and a.CMPid    = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado = 20
					  and j.SNcodigo  in (select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid#)
					
					order by q.SNcodigo, DSconsecutivo asc, c.Aid,10 desc
				</cfquery>
				
			<cfelseif parametro eq 830 >			
				<cfset titulo = 'Solicitud de Cotizaci&oacute;n de Importaci&oacute;n' >
				<cfquery name="rs" datasource="#session.DSN#" >
					select  distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,           
							u.Ucodigo,                     
							c.Aid,
							d.NumeroParte,
							q.SNnumero,
							q.SNnombre,
							q.SNidentificacion,
                            q.SNdireccion,
							q.SNcodigo,
                            coalesce(q.SNtelefono,'N/A') as SNtelefono,
                            q.SNFax,
                            c.DStipo,                            
                            c.DSmontoest,
                            c.DStotallinest
				
					from CMProcesoCompra a
					LEFT OUTER join CMProveedoresProceso m
					on a.CMPid = m.CMPid  
				
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
				
					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
				
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea                                    
				
					LEFT OUTER join NumParteProveedor  d                          
					on c.Aid = d.Aid
					and a.CMPfmaxofertas between Vdesde and Vhasta
                    and d.Aid in (	select distinct Aid 
									from DSolicitudCompraCM r
									where  r.Ecodigo = #session.Ecodigo#
									and r.Aid is not null
									and d.Aid = r.Aid
									and d.SNcodigo in ( select cmpp.SNcodigo 
														from CMProveedoresProceso cmpp
														where CMPid = #Session.Compras.ProcesoCompra.CMPid#))
					
					LEFT OUTER join SNegocios q
					on d.SNcodigo=q.SNcodigo
					and d.Ecodigo=q.Ecodigo                       
				
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
				
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud      
				
					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado in (20,40)
					  
					union 
				
					select distinct g.Edescripcion,
						   coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,           
							u.Ucodigo,                     
							c.Aid,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as NumeroParte,
							q.SNnumero,
							q.SNnombre,
							q.SNidentificacion,
                            q.SNdireccion,
							q.SNcodigo,
                            coalesce(q.SNtelefono,'N/A') as SNtelefono,
                            q.SNFax,
                            c.DStipo,                            
                            c.DSmontoest,
                            c.DStotallinest
				
					from CMProcesoCompra a
					
					LEFT OUTER join CMProveedoresProceso m
					on a.CMPid = m.CMPid  
					
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
					
					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
					
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
					and c.Aid is not null                               
				
					LEFT OUTER join Articulos h
					on c.Aid = h.Aid
					
					LEFT OUTER join Clasificaciones i
					on h.Ccodigo = i.Ccodigo
					and h.Ecodigo = i.Ecodigo
					
					LEFT OUTER join ClasificacionItemsProv j
					on i.Ccodigo = j.Ccodigo
					and i.Ecodigo = j.Ecodigo
					and j.Ccodigo is not null
					
					LEFT OUTER join SNegocios q
					on j.SNcodigo = q.SNcodigo 
					and j.Ecodigo = q.Ecodigo                                  
					
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
					
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud
				
					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado in (20,40)
					  and j.SNcodigo in ( select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid# ) 
					union 
				
					select distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,           
							u.Ucodigo,                     
							c.Cid as Aid,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as NumeroParte,
							q.SNnumero,
							q.SNnombre,
							q.SNidentificacion,
                            q.SNdireccion,
							q.SNcodigo,
                            coalesce(q.SNtelefono,'N/A') as SNtelefono,
                            q.SNFax,
                            c.DStipo,                            
                            c.DSmontoest,
                            c.DStotallinest
				
					from CMProcesoCompra a
				
					LEFT OUTER join CMProveedoresProceso m
					on a.CMPid = m.CMPid  
				
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
					
					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
					
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
					and c.Cid is not null                                           
					
					LEFT OUTER join Conceptos h
					on c.Cid = h.Cid
					and c.Ecodigo = h.Ecodigo
					
					LEFT OUTER join CConceptos i
					on h.CCid = i.CCid
					
					LEFT OUTER join ClasificacionItemsProv j
					on i.CCid = j.CCid
					and i.Ecodigo = j.Ecodigo
					and j.CCid is not null
					
					LEFT OUTER join SNegocios q
					on j.SNcodigo = q.SNcodigo 
					and j.Ecodigo = q.Ecodigo
					
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
					
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud
				
					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado in (20,40)
					  and j.SNcodigo  in (select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid#)
					  
					order by q.SNcodigo, DSconsecutivo asc, c.Aid,10 desc
				</cfquery>

			<cfelseif parametro eq 840 >
							
				<cfset titulo = 'Solicitud de Cotizaci&oacute;n Local' >
				<cfquery name="rs" datasource="#session.DSN#" >
					select  g.Edescripcion,
                        coalesce(a.CMPnumero,0) as CMPnumero,
                        a.CMPfechapublica,
                        a.CMPfmaxofertas,
                        c.DSconsecutivo,
                        c.DSdescripcion,
                        c.DScant,
                        c.DSdescalterna,
                        c.DSobservacion,
                        u.Ucodigo,                     
                        c.Aid,
                        a.CMPid,
                        h.Acodalterno as NumeroParte                

					from CMProcesoCompra a                                              

					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
					
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
					
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
					
					LEFT OUTER join Articulos h
					on c.Aid = h.Aid                 
					
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
					
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud

					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado in (20,40)

					order by DSconsecutivo asc,h.Acodalterno, c.Aid, c.Cid
				</cfquery>	
				
			<cfelseif parametro eq 850 >
							
				<cfset titulo = 'Solicitud de Cotizaci&oacute;n de Importaci&oacute;n' >
				<cfquery name="rs" datasource="#session.DSN#">
					select  g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,                       
							u.Ucodigo,                     
							c.Aid,
							a.CMPid,
							h.Acodalterno as NumeroParte

					from CMProcesoCompra a                                              

					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
					
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
					
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
					
					left outer join Articulos h
					on c.Aid = h.Aid                  
					
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
					
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud

					where a.Ecodigo = #session.Ecodigo#
			          and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
	           		  and e.ESestado in (20,40)

					order by DSconsecutivo asc , h.Acodalterno, c.Aid, c.Cid
				</cfquery>
			</cfif>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select      
					EDireccion1,         
					EDireccion2,                  
					EIdentificacion          
				from Empresas
				where Ecodigo= #session.Ecodigo#
			</cfquery>
            <cfset LvarFax  = datos.Pfax>
        	<cfset LvarTel  = datos.Poficina>                    
   		    <cfset Lvardir  = datos.direccion1>
		    <cfset LvarIdentificacion  = rsSQL.EIdentificacion>
  		    <cfset LvarDir1 = rsSQL.EDireccion1>
     	    <cfset LvarDir2 = rsSQL.EDireccion2>    
         	<cfif LvarPrint>
           		<cf_rhimprime datos="/sif/cm/operacion/ConlisReporte.cfm" paramsuri="#Param#">            
             </cfif>
            <cfinclude template="#data_formato.archivo#">                    
                  
		<!--- CFR --->
		<cfelseif data_formato.FMT01tipfmt eq 4>
			<cfset titulo = '' >
			<cfif parametro eq 820 >
				<cfset titulo = 'Solicitud de Cotizaci&oacute;n Local' >
				
				<cfquery name="rs" datasource="#session.DSN#" >
					select distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							<cf_dbfunction name="sPart"	args="c.DSdescalterna,1,215"> as ADSdescalterna,
							c.DSobservacion,
							u.Ucodigo,                     
							c.Aid,
							d.NumeroParte,
							q.SNnombre,
							q.SNidentificacion,
							q.SNcodigo
				
					from CMProcesoCompra a
				
					LEFT OUTER join CMProveedoresProceso m
								on a.CMPid = m.CMPid  
					LEFT OUTER join CMLineasProceso b
								on a.CMPid = b.CMPid
					LEFT OUTER join Empresas g
								on g.Ecodigo =a.Ecodigo
					LEFT OUTER join DSolicitudCompraCM c
								on b.DSlinea = c.DSlinea                                    
					LEFT OUTER join NumParteProveedor  d                          
								on c.Aid = d.Aid
								and a.CMPfmaxofertas between Vdesde and Vhasta
                                and d.Aid in (	select distinct Aid 
												from DSolicitudCompraCM r
												where  r.Ecodigo = #session.Ecodigo#
												   and r.Aid is not null
												   and d.Aid = r.Aid
												   and d.SNcodigo in (	select cmpp.SNcodigo 
																		from CMProveedoresProceso cmpp
																		where CMPid = #Session.Compras.ProcesoCompra.CMPid#  ))
					LEFT OUTER join SNegocios q
								on d.SNcodigo=q.SNcodigo
								and d.Ecodigo=q.Ecodigo                       
					LEFT OUTER join Unidades u
								on c.Ecodigo = u.Ecodigo
								and c.Ucodigo = u.Ucodigo
					LEFT OUTER join ESolicitudCompraCM e
								on c.ESidsolicitud = e.ESidsolicitud      
					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado = 20
					  
					union 
				
					select  distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,
							u.Ucodigo,                     
							c.Aid,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as NumeroParte,
							q.SNnombre,
							q.SNidentificacion,
							q.SNcodigo
					
					from CMProcesoCompra a
						LEFT OUTER join CMProveedoresProceso m
						on a.CMPid = m.CMPid  
						
						LEFT OUTER join CMLineasProceso b
						on a.CMPid = b.CMPid
						
						LEFT OUTER join Empresas g
						on g.Ecodigo =a.Ecodigo
						
						LEFT OUTER join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and c.Aid is not null                               
					
						LEFT OUTER join Articulos h
						on c.Aid = h.Aid
						
						LEFT OUTER join Clasificaciones i
						on h.Ccodigo = i.Ccodigo
						and h.Ecodigo = i.Ecodigo
					
						LEFT OUTER join ClasificacionItemsProv j
						on i.Ccodigo = j.Ccodigo
						and i.Ecodigo = j.Ecodigo
						and j.Ccodigo is not null
						
						LEFT OUTER join SNegocios q
						on j.SNcodigo = q.SNcodigo 
						and j.Ecodigo = q.Ecodigo                                  
					
						LEFT OUTER join Unidades u
						on c.Ecodigo = u.Ecodigo
						and c.Ucodigo = u.Ucodigo
					
						LEFT OUTER join ESolicitudCompraCM e
						on c.ESidsolicitud = e.ESidsolicitud
					
					where a.Ecodigo = #session.Ecodigo#
						  and a.CMPid =#Session.Compras.ProcesoCompra.CMPid#
						  and e.ESestado = 20
						  and j.SNcodigo  in ( select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid#)
					
					union 
				
					select distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,
							u.Ucodigo,                     
							c.Cid as Aid,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as NumeroParte,
							q.SNnombre,
							q.SNidentificacion,
							q.SNcodigo
					
					from CMProcesoCompra a
						LEFT OUTER join CMProveedoresProceso m
						on a.CMPid = m.CMPid  
						
						LEFT OUTER join CMLineasProceso b
						on a.CMPid = b.CMPid
						
						LEFT OUTER join Empresas g
						on g.Ecodigo =a.Ecodigo
						
						LEFT OUTER join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and c.Cid is not null                                           
					
						LEFT OUTER join Conceptos h
						on c.Cid = h.Cid
						and c.Ecodigo = h.Ecodigo
						
						LEFT OUTER join CConceptos i
						on h.CCid = i.CCid
					
						LEFT OUTER join ClasificacionItemsProv j
						on i.CCid = j.CCid
						and i.Ecodigo = j.Ecodigo
						and j.CCid is not null
						
						LEFT OUTER join SNegocios q
						on j.SNcodigo = q.SNcodigo 
						and j.Ecodigo = q.Ecodigo
					
						LEFT OUTER join Unidades u
						on c.Ecodigo = u.Ecodigo
						and c.Ucodigo = u.Ucodigo
					
						LEFT OUTER join ESolicitudCompraCM e
						on c.ESidsolicitud = e.ESidsolicitud
					
					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado = 20
					  and j.SNcodigo  in (select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid#)
					
					order by q.SNcodigo, DSconsecutivo asc, c.Aid,10 desc
				</cfquery>
				
			<cfelseif parametro eq 830 >
							
				<cfset titulo = 'Solicitud de Cotizaci&oacute;n de Importaci&oacute;n' >
				<cfquery name="rs" datasource="#session.DSN#" >
					select  distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,           
							u.Ucodigo,                     
							c.Aid,
							d.NumeroParte,
							q.SNnumero,
							q.SNnombre,
							q.SNidentificacion,
							q.SNcodigo
				
					from CMProcesoCompra a
					LEFT OUTER join CMProveedoresProceso m
					on a.CMPid = m.CMPid  
				
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
				
					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
				
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea                                    
				
					LEFT OUTER join NumParteProveedor  d                          
					on c.Aid = d.Aid
					and a.CMPfmaxofertas between Vdesde and Vhasta
                    and d.Aid in (	select distinct Aid 
									from DSolicitudCompraCM r
									where  r.Ecodigo = #session.Ecodigo#
									and r.Aid is not null
									and d.Aid = r.Aid
									and d.SNcodigo in ( select cmpp.SNcodigo 
														from CMProveedoresProceso cmpp
														where CMPid = #Session.Compras.ProcesoCompra.CMPid#) )
					
					LEFT OUTER join SNegocios q
					on d.SNcodigo=q.SNcodigo
					and d.Ecodigo=q.Ecodigo                       
				
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
				
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud      
				
					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado in (20,40)
					  
					union 
				
					select distinct g.Edescripcion,
						   coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,           
							u.Ucodigo,                     
							c.Aid,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as NumeroParte,
							q.SNnumero,
							q.SNnombre,
							q.SNidentificacion,
							q.SNcodigo
				
					from CMProcesoCompra a
					
					LEFT OUTER join CMProveedoresProceso m
					on a.CMPid = m.CMPid  
					
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
					
					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
					
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
					and c.Aid is not null                               
				
					LEFT OUTER join Articulos h
					on c.Aid = h.Aid
					
					LEFT OUTER join Clasificaciones i
					on h.Ccodigo = i.Ccodigo
					and h.Ecodigo = i.Ecodigo
					
					LEFT OUTER join ClasificacionItemsProv j
					on i.Ccodigo = j.Ccodigo
					and i.Ecodigo = j.Ecodigo
					and j.Ccodigo is not null
					
					LEFT OUTER join SNegocios q
					on j.SNcodigo = q.SNcodigo 
					and j.Ecodigo = q.Ecodigo                                  
					
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
					
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud
				
					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado in (20,40)
					  and j.SNcodigo in ( select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid# ) 
					union 
				
					select distinct g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,           
							u.Ucodigo,                     
							c.Cid as Aid,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as NumeroParte,
							q.SNnumero,
							q.SNnombre,
							q.SNidentificacion,
							q.SNcodigo
				
					from CMProcesoCompra a
				
					LEFT OUTER join CMProveedoresProceso m
					on a.CMPid = m.CMPid  
				
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
					
					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
					
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
					and c.Cid is not null                                           
					
					LEFT OUTER join Conceptos h
					on c.Cid = h.Cid
					and c.Ecodigo = h.Ecodigo
					
					LEFT OUTER join CConceptos i
					on h.CCid = i.CCid
					
					LEFT OUTER join ClasificacionItemsProv j
					on i.CCid = j.CCid
					and i.Ecodigo = j.Ecodigo
					and j.CCid is not null
					
					LEFT OUTER join SNegocios q
					on j.SNcodigo = q.SNcodigo 
					and j.Ecodigo = q.Ecodigo
					
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
					
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud
				
					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado in (20,40)
					  and j.SNcodigo  in (select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid#)
					  
					order by q.SNcodigo, DSconsecutivo asc, c.Aid,10 desc
				</cfquery>

			<cfelseif parametro eq 840 >
							
				<cfset titulo = 'Solicitud de Cotizaci&oacute;n Local' >
				<cfquery name="rs" datasource="#session.DSN#" >
					select  g.Edescripcion,
                        coalesce(a.CMPnumero,0) as CMPnumero,
                        a.CMPfechapublica,
                        a.CMPfmaxofertas,
                        c.DSconsecutivo,
                        c.DSdescripcion,
                        c.DScant,
                        c.DSdescalterna,
                        c.DSobservacion,
                        u.Ucodigo,                     
                        c.Aid,
                        a.CMPid,
                        h.Acodalterno as NumeroParte                

					from CMProcesoCompra a                                              

					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
					
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
					
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
					
					LEFT OUTER join Articulos h
					on c.Aid = h.Aid                
					
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
					
					LEFT OUTER join ESolicitudCompraCM e
					on c.ESidsolicitud = e.ESidsolicitud

					where a.Ecodigo = #session.Ecodigo#
					  and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					  and e.ESestado in (20,40)

					order by DSconsecutivo asc,h.Acodalterno, c.Aid, c.Cid
				</cfquery>	
				
			<cfelseif parametro eq 850 >
							
				<cfset titulo = 'Solicitud de Cotizaci&oacute;n de Importaci&oacute;n' >
				<cfquery name="rs" datasource="#session.DSN#">
					select  g.Edescripcion,
							coalesce(a.CMPnumero,0) as CMPnumero,
							a.CMPfechapublica,
							a.CMPfmaxofertas,
							c.DSconsecutivo,
							c.DSdescripcion,
							c.DScant,
							c.DSdescalterna,
							c.DSobservacion,                       
							u.Ucodigo,                     
							c.Aid,
							a.CMPid,
							h.Acodalterno as NumeroParte

					from CMProcesoCompra a                                              

					LEFT OUTER join Empresas g
					on g.Ecodigo =a.Ecodigo
					
					LEFT OUTER join CMLineasProceso b
					on a.CMPid = b.CMPid
					
					LEFT OUTER join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
					
					LEFT OUTER join Articulos h
					on c.Aid = h.Aid                
					
					LEFT OUTER join Unidades u
					on c.Ecodigo = u.Ecodigo
					and c.Ucodigo = u.Ucodigo
					
					LEFT OUTER join ESolicitudCompraCM e
						on c.ESidsolicitud = e.ESidsolicitud

					where a.Ecodigo = #session.Ecodigo#
			          and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
	           		  and e.ESestado in (20,40)

					order by DSconsecutivo asc , h.Acodalterno, c.Aid, c.Cid
				</cfquery>
			</cfif>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select      
					EDireccion1,         
					EDireccion2,                  
					EIdentificacion          
				from Empresas
				where Ecodigo= #session.Ecodigo#
			</cfquery>
	
			<cfif rs.recordcount gt 0 >
<!---			 template="#expandpath(data_formato.archivo)#"--->
				<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
						select Pvalor as valParam
						from Parametros
						where Pcodigo = 20007
						and Ecodigo = #Session.Ecodigo#
				</cfquery>
				<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
				<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
					<cfset typeRep = 1>
					<cf_js_reports_service_tag queryReport = "#rs#" 
						isLink = False 
						typeReport = typeRep
						fileName = "cm.consultas.ConlisReporte"/>
				<cfelse>
				<cfreport format="flashpaper"  template="#expandpath(data_formato.archivo)#" query="rs">
					<cfreportparam name="fax"   value="#datos.Pfax#">
					<cfreportparam name="tel"   value="#datos.Poficina#">
					<cfreportparam name="dir"   value="#datos.direccion1#">
					<cfreportparam name="LvarIdentificacion"     value="#rsSQL.EIdentificacion#">
					<cfreportparam name="LvarDir1"   			 value="#rsSQL.EDireccion1#">
					<cfreportparam name="LvarDir2"  			 value="#rsSQL.EDireccion2#">
				</cfreport>
				</cfif>
			<cfelse>
				<html>
				<body>
					<cfoutput>
					<table width="100%" align="center" cellpadding="3">
						<tr><td align="center"><font size="3"><strong>Reporte de #titulo#</strong></font></td></tr>
						<tr><td align="center">--- No se encontraron registros ---</td></tr>
					</table>
					</cfoutput>
				</body>
				</html>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
</cfif>
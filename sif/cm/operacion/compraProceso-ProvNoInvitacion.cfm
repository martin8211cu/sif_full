<!----- Se crea una tabla temporal para almacenar los socios Invitados que si cumplen con las verificaciones (Partes y/o clasificaciones ----->
	<cf_dbtemp name="sociosInvitados" returnvariable="sociosInvitados" datasource="#session.DSN#">
	 <cf_dbtempcol name="SNcodigo" type="numeric" mandatory="yes">
	</cf_dbtemp>

	<cftransaction>
		<cfif isdefined("url.vnTodos") and url.vnTodos EQ 1><!--- Si se invitaron los proveedores seleccionados hace join con CMProveedoresProceso ---->
			<cfquery datasource="#session.DSN#" name="g">
				insert into #sociosInvitados# (SNcodigo)
				select  distinct  q.SNcodigo			
				from CMProcesoCompra a
			
				inner join CMProveedoresProceso m
					on a.CMPid = m.CMPid  
				
				inner join CMLineasProceso b
					on a.CMPid = b.CMPid		
			
				inner join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea			
			
				inner join NumParteProveedor  d			
					on c.Aid = d.Aid
					and a.CMPfmaxofertas between Vdesde and Vhasta
				
				inner join SNegocios q
					on d.SNcodigo=q.SNcodigo
					and d.Ecodigo=q.Ecodigo				
			
				inner join ESolicitudCompraCM e
					on c.Ecodigo = e.Ecodigo
						and c.ESidsolicitud = e.ESidsolicitud	
						
				where 	a.Ecodigo =#Session.Ecodigo#
					and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					and e.ESestado in (20,40)
					and d.Aid in (select distinct Aid from DSolicitudCompraCM r
									where  r.Ecodigo = #Session.Ecodigo#
										and r.Aid is not null
										and d.Aid = r.Aid
										and d.SNcodigo in (select cmpp.SNcodigo 
														from CMProveedoresProceso cmpp
														where CMPid =#Session.Compras.ProcesoCompra.CMPid#)
									)	
				union 
			
				select  distinct  q.SNcodigo
					
				from CMProcesoCompra a
			
					inner join CMProveedoresProceso m
						on a.CMPid = m.CMPid  
					
					inner join CMLineasProceso b
						on a.CMPid = b.CMPid
				
					inner join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and c.Aid is not null			
			
					inner join Articulos h
						on c.Aid = h.Aid
						and c.Ecodigo = h.Ecodigo
			
					inner join Clasificaciones i
						on h.Ccodigo = i.Ccodigo
						and h.Ecodigo = i.Ecodigo
							
					inner join ClasificacionItemsProv j
						on i.Ccodigo = j.Ccodigo
						and i.Ecodigo = j.Ecodigo
						and j.Ccodigo is not null
								
			
					inner join SNegocios q
						on j.SNcodigo = q.SNcodigo 
						and j.Ecodigo = q.Ecodigo			
						
					inner join ESolicitudCompraCM e
						on c.Ecodigo = e.Ecodigo
							and c.ESidsolicitud = e.ESidsolicitud
				
				where 	a.Ecodigo =#Session.Ecodigo#
					and a.CMPid =#Session.Compras.ProcesoCompra.CMPid#
					and e.ESestado in (20,40)
					and j.SNcodigo	in (select SNcodigo from CMProveedoresProceso  where CMPid =#Session.Compras.ProcesoCompra.CMPid#) 
				union 
			
				select 	 distinct  q.SNcodigo
					
				from CMProcesoCompra a
				
					inner join CMProveedoresProceso m
						on a.CMPid = m.CMPid  
			
					inner join CMLineasProceso b
						on a.CMPid = b.CMPid
				
					inner join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and c.Cid is not null				
			
					inner join Conceptos h
						on c.Cid = h.Cid
						and c.Ecodigo = h.Ecodigo
			
					inner join CConceptos i
						on h.CCid = i.CCid
						and h.Ecodigo = i.Ecodigo
							
					inner join ClasificacionItemsProv j
						on i.CCid = j.CCid
						and i.Ecodigo = j.Ecodigo
						and j.CCid is not null
								 
					inner join SNegocios q
						on j.SNcodigo = q.SNcodigo 
						and j.Ecodigo = q.Ecodigo
								
					inner join ESolicitudCompraCM e
						on c.Ecodigo = e.Ecodigo
							and c.ESidsolicitud = e.ESidsolicitud
				
				where 	a.Ecodigo =#Session.Ecodigo#
					and a.CMPid =#Session.Compras.ProcesoCompra.CMPid#	
					and e.ESestado in(20,40)
					and j.SNcodigo	in (select SNcodigo from CMProveedoresProceso  where CMPid = #Session.Compras.ProcesoCompra.CMPid#)
			</cfquery>	
	
		<cfelseif isdefined("url.vnTodos") and url.vnTodos EQ 0><!--- Si se invitaron TODOS los proveedores no se hace join con CMProveedoresProceso (porque cuando se invitan todos los proveedores no se insertan en la tabla ---->		
			<cfquery datasource="#session.DSN#">
				insert into #sociosInvitados# (SNcodigo)
				select  distinct  q.SNcodigo			
				from CMProcesoCompra a
			
				inner join CMLineasProceso b
					on a.CMPid = b.CMPid		
			
				inner join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea			
			
					inner join NumParteProveedor  d			
						on c.Aid = d.Aid
						and a.CMPfmaxofertas between Vdesde and Vhasta
						and d.Aid in (select distinct Aid from DSolicitudCompraCM r
									where  r.Ecodigo = #Session.Ecodigo#
										and r.Aid is not null
										and d.Aid = r.Aid
									)
				
						inner join SNegocios q
							on d.SNcodigo=q.SNcodigo
							and d.Ecodigo=q.Ecodigo				
			
					inner join ESolicitudCompraCM e
						on c.Ecodigo = e.Ecodigo
							and c.ESidsolicitud = e.ESidsolicitud	
						
				where 	a.Ecodigo =#Session.Ecodigo#
					and a.CMPid = #Session.Compras.ProcesoCompra.CMPid#	
					and e.ESestado in (20,40)
						
				union 
			
				select  distinct  q.SNcodigo
					
				from CMProcesoCompra a
			
					inner join CMLineasProceso b
						on a.CMPid = b.CMPid
				
					inner join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and c.Aid is not null			
			
					inner join Articulos h
						on c.Aid = h.Aid
						and c.Ecodigo = h.Ecodigo
			
						inner join Clasificaciones i
							on h.Ccodigo = i.Ccodigo
							and h.Ecodigo = i.Ecodigo
							
							inner join ClasificacionItemsProv j
								on i.Ccodigo = j.Ccodigo
								and i.Ecodigo = j.Ecodigo
								and j.Ccodigo is not null
												
								inner join SNegocios q
									on j.SNcodigo = q.SNcodigo 
									and j.Ecodigo = q.Ecodigo			
						
					inner join ESolicitudCompraCM e
						on c.Ecodigo = e.Ecodigo
							and c.ESidsolicitud = e.ESidsolicitud
				
				where 	a.Ecodigo =#Session.Ecodigo#
					and a.CMPid =#Session.Compras.ProcesoCompra.CMPid#	
					and e.ESestado in (20,40)
			
				union 
			
				select 	 distinct  q.SNcodigo
					
				from CMProcesoCompra a
			
					inner join CMLineasProceso b
						on a.CMPid = b.CMPid
				
					inner join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
						and c.Cid is not null				
			
					inner join Conceptos h
						on c.Cid = h.Cid
						and c.Ecodigo = h.Ecodigo
			
						inner join CConceptos i
							on h.CCid = i.CCid
							and h.Ecodigo = i.Ecodigo
							
							inner join ClasificacionItemsProv j
								on i.CCid = j.CCid
								and i.Ecodigo = j.Ecodigo
								and j.CCid is not null
			
								inner join SNegocios q
									on j.SNcodigo = q.SNcodigo 
									and j.Ecodigo = q.Ecodigo
			
						
					inner join ESolicitudCompraCM e
						on c.Ecodigo = e.Ecodigo
							and c.ESidsolicitud = e.ESidsolicitud
				
				where 	a.Ecodigo =#Session.Ecodigo#
					and a.CMPid =#Session.Compras.ProcesoCompra.CMPid#	
					and e.ESestado in(20,40)			
			</cfquery>
		</cfif>
		
		<cfquery name="rsProveedores" datasource="#session.DSN#">
			select * from #sociosInvitados#
		</cfquery>
		
		<!---- Carga los proveedores que si cumplen en una variable ----->
		<cfset proveedores = ValueList(rsProveedores.SNcodigo,',')>	
		
	</cftransaction>
	
	<!---- Se obtienen los proveedores que no cumplen para la invitación ----->
	<cfif isdefined("url.vnTodos") and url.vnTodos EQ 1><!--- Si se invitaron solo algunos proveedores ---->
		<cfquery name="rsSociosNoInvitados" datasource="#session.DSN#">
			select	h.SNnumero,
					h.SNnombre,
					h.SNcodigo,
					h.SNidentificacion
			from SNegocios h					
				inner join CMProveedoresProceso cmpp
					on h.SNcodigo = cmpp.SNcodigo
					and h.Ecodigo = cmpp.Ecodigo
			
			where h.Ecodigo = #Session.Ecodigo#
				and cmpp.CMPid = #Session.Compras.ProcesoCompra.CMPid#
				<cfif len(trim(proveedores))> 
					and h.SNcodigo not in (#proveedores#)
				</cfif>
		</cfquery>

	<cfelseif isdefined("url.vnTodos") and url.vnTodos EQ 0><!---- Si se invitaron TODOS los proveedores ---->
		<cfquery name="rsSociosNoInvitados" datasource="#session.DSN#">
			select	h.SNnumero,
					h.SNnombre,
					h.SNcodigo,
					h.SNidentificacion
			from SNegocios h																
			where h.Ecodigo = #Session.Ecodigo#
				<cfif len(trim(proveedores))> 
					and h.SNcodigo not in (#proveedores#)
				</cfif>
		</cfquery>
	</cfif>		
	
	<form name="form1" action="">
		<table width="98%" cellpadding="2" cellspacing="0">
			<tr>					
				<td align="center"><strong>Lista de proveedores que no han sido asignados a las líneas</strong></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<cfif len(trim(proveedores))>
					<td>
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rsSociosNoInvitados#"/> 
						<cfinvokeargument name="desplegar" value="SNnumero,SNnombre,SNidentificacion"/> 
						<cfinvokeargument name="etiquetas" value="Código,Nombre,Cédula Jurídica"/> 
						<cfinvokeargument name="formatos" value="S,S,S"/> 
						<cfinvokeargument name="align" value="left,left,left"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="irA" value=""/>
						<cfinvokeargument name="keys" value="SNcodigo"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>						
						<cfinvokeargument name="maxrows" value="12"/>
						<cfinvokeargument name="navegacion" value=""/>
						<cfinvokeargument name="showLink" value="false"/>
					</cfinvoke>
					</td>
				<cfelse>
					<td align="center">---------------------------   No hay proveedores sin asignar   ---------------------------</td>
				</cfif>
			</tr>
			<tr><td>&nbsp;</td></tr>	
			<tr><td align="center"><input type="button" value="Cerrar" name="btnCerrar" onClick="javascript: window.close();"></td></tr>			
		</table>
	</form>			
	

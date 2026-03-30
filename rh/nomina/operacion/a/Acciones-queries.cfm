<cfif modo NEQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("Form.RHAlinea") AND Len(Trim(Form.RHAlinea)) GT 0>
	<!--- Averiguar si el comportamiento del Tipo de Acción es un cambio de empresa --->
	<cfquery name="rsTipoAccionComp" datasource="#Session.DSN#">
		select 
		coalesce(b.RHTporc, 100) as RHTporc,coalesce(b.RHTporcsal,100) as  RHTporcsal,
		a.EcodigoRef, b.RHTcomportam, b.RHTcempresa, b.RHTnoveriplaza
		from RHAcciones a, RHTipoAccion b
		where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHTid = b.RHTid
	</cfquery>

	<cfif rsTipoAccionComp.RecordCount EQ 0>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSeEncuentraLaAccion"
			Default="No se encuentra la acción"
			returnvariable="MSG_NoSeEncuentraLaAccion"/>

		<cf_throw message="#MSG_NoSeEncuentraLaAccion#" errorCode="1090">
	</cfif>

	<!--- Cambio de Empresa --->
	<cfif rsTipoAccionComp.RHTcomportam EQ 9 and rsTipoAccionComp.RHTcempresa EQ 1>
		<cfquery name="rsAccion" datasource="#Session.DSN#">
			select 	a.RHAlinea, 
				   	a.DEid, 
				   	a.RHTid, 
				   	a.Ecodigo, 
				   	coalesce(a.EcodigoRef,a.Ecodigo) as EcodigoRef, 
				   	rtrim(a.Tcodigo) as Tcodigo, 
				   	rtrim(a.TcodigoRef) as TcodigoRef, 
				   	a.RVid, 
				   	a.Dcodigo, 
				   	a.Indicador_de_Negociado as negociado,
				   	a.RHCPlinea,
				   	a.Ocodigo,								       
				   	a.RHPid, 
				   	rtrim(a.RHPcodigo) as RHPcodigo, 
				   	(select min(coalesce(ltrim(rtrim(r.RHPcodigoext)),rtrim(ltrim(r.RHPcodigo))))
						from RHPuestos r
						where r.Ecodigo = a.EcodigoRef
						   and r.RHPcodigo = a.RHPcodigo
						)as RHPcodigoext,
						a.RHJid,
				   	a.DLfvigencia, 
				   	a.DLfvigencia as rige,
				   	a.DLffin,
				   	a.DLffin as vence,
				   	a.DLsalario, a.DLobs, a.Usucodigo, a.Ulocalizacion, a.RHAporc, a.RHAporcsal,
				   	a.RHAvdisf, 
					a.RHAvcomp, 
				   	a.ts_rversion,
					a.RHAtipo,
					a.RHAdescripcion,
					a.EVfantig,
				   	b.NTIcodigo, b.DEidentificacion, 
					{fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) } as NombreEmp,
				   	rtrim(c.RHTcodigo) as RHTcodigo, c.RHTdesc, c.RHTpfijo, 
				   	c.RHTcomportam, c.RHTpmax, 
					(select min(d.NTIdescripcion)
						from NTipoIdentificacion d
						where d.NTIcodigo = b.NTIcodigo
					) as NTIdescripcion, 				   				   
				   e.RHPdescripcion, rtrim(e.RHPcodigo) as CodPlaza, 
				   (select min(coalesce(ltrim(rtrim(r.RHPcodigoext)),rtrim(ltrim(r.RHPcodigo))))
						from RHPuestos r
						where r.Ecodigo = a.EcodigoRef
						   and r.RHPcodigo = a.RHPcodigo
						)as CodPuesto, 
				   e.Dcodigo as CodDepto, e.Ocodigo as CodOfic,
				   { fn concat(rtrim(e.RHPcodigo), { fn concat(' - ',e.RHPdescripcion)} )} as Plaza, 
					(select min(f.RHPdescpuesto)
						from RHPuestos f
						where f.Ecodigo = a.EcodigoRef
						   and f.RHPcodigo = a.RHPcodigo
					) as RHPdescpuesto,					
					(select min({ fn concat(rtrim(coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo)))), { fn concat(' - ', f.RHPdescpuesto)} )} )
						from RHPuestos f
						where f.Ecodigo = a.EcodigoRef
						   and f.RHPcodigo = a.RHPcodigo
					) as Puesto,					
					(select min(g.Tdescripcion)
						from TiposNomina g
						where g.Ecodigo = a.EcodigoRef
						   and g.Tcodigo = a.TcodigoRef
					) as Tdescripcion,
					(select min(h.Descripcion)
						from RegimenVacaciones h
						where h.RVid = a.RVid
					) as RegVacaciones, 
				   (select min(Odescripcion)
						from Oficinas i
						where i.Ecodigo = a.EcodigoRef
						   and i.Ocodigo = a.Ocodigo
					) as Odescripcion,	 
				   (select min(j.Ddescripcion) 
						from Departamentos j 
						where j.Ecodigo = a.EcodigoRef
						   and j.Dcodigo = a.Dcodigo
					) as Ddescripcion,					
				   <cfif isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1>
					   0 as RHTctiponomina, 0 as RHTcregimenv, 0 as RHTcoficina, 0 as RHTcdepto, 0 as RHTcplaza, 0 as RHTcpuesto, 0 as RHTccomp, 
					   0 as RHTcsalariofijo, 0 as RHTcjornada, 0 as RHTcvacaciones, 0 as RHTccatpaso, 0 as RHTcempresa, 0 as RHTnoveriplaza,
				   <cfelse>
					   c.RHTctiponomina, c.RHTcregimenv, c.RHTcoficina, c.RHTcdepto, c.RHTcplaza, c.RHTcpuesto, c.RHTccomp, 
					   c.RHTcsalariofijo, c.RHTcjornada, 1 as RHTcvacaciones, c.RHTccatpaso, c.RHTcempresa, c.RHTnoveriplaza, 
				   </cfif>				   
				   (select { fn concat(rtrim(k.RHJcodigo), { fn concat(' - ',k.RHJdescripcion)} )}
				   		from RHJornadas k
						where a.EcodigoRef = k.Ecodigo
							and a.RHJid = k.RHJid
				   ) as Jornada,				   
				   s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
				   t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
				   u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,				   
				   ( select min( { fn concat( ltrim(rtrim(cf.CFcodigo)), { fn concat(' - ', ltrim(rtrim(cf.CFdescripcion)))} )})
						from CFuncional cf
						where cf.CFid = e.CFid
					) as Ctrofuncional,
				   pp.RHPPid,
				   pp.RHPPcodigo,
				   pp.RHPPdescripcion,
				   ltp.RHMPnegociado,
				   coalesce(a.IDInterfaz,0) as IDInterfaz,
				   RHAdiasenfermedad,
				   coalesce(c.RHTsubcomportam,0) as RHIsubcomportam,
				   coalesce(a.RHItiporiesgo,0) as RHItiporiesgo,
				   coalesce(a.RHIconsecuencia,0) as RHIconsecuencia,
				   coalesce(a.RHIcontrolincapacidad,0) as RHIcontrolincapacidad
				   
			from RHAcciones a
				 inner join DatosEmpleado b
					on b.DEid = a.DEid

				 inner join RHTipoAccion c
					on c.RHTid = a.RHTid
	
				 left outer join RHPlazas e
					on e.RHPid = a.RHPid
					
						<!---====================================================================================  
							Se une con la linea del tiempo de la plaza presup. para obtener los datos de la plaza de RH 
							en el momento de la accion, se verifica que el puesto de RH tenga asignado el mismo
							puesto presupuestario de plaza presup. 						
						===============================================================================---->						
						left outer join RHLineaTiempoPlaza ltp
							on e.RHPid = ltp.RHPid
							and  a.DLfvigencia between ltp.RHLTPfdesde  and ltp.RHLTPfhasta
							<!----and ltp.RHMPPid = f.RHMPPid---->
	
							left outer join RHPlazaPresupuestaria pp
								on ltp.RHPPid = pp.RHPPid
								and ltp.Ecodigo = pp.Ecodigo
						
				 left outer join RHCategoriasPuesto r
				 	on r.RHCPlinea = a.RHCPlinea

				 left outer join RHTTablaSalarial s
				 	on s.RHTTid = r.RHTTid

				 left outer join RHCategoria t
				 	on t.RHCid = r.RHCid
					
				left outer join RHMaestroPuestoP u 	<!----Puesto presupuestario ----->
					on r.RHMPPid = u.RHMPPid			

			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	<cfelse>
		<cfquery name="rsAccion" datasource="#Session.DSN#">
			select a.RHAlinea, 
				   a.DEid, 
				   a.RHTid, 
				   a.Ecodigo, 
				   coalesce(a.EcodigoRef,a.Ecodigo) as EcodigoRef, 
				   rtrim(a.Tcodigo) as Tcodigo, 
				   a.RVid, 
				   a.Dcodigo,
				   a.Ocodigo,				    
				   a.RHPid, 
				   rtrim(a.RHPcodigo) as RHPcodigo, 
				   (select min(coalesce(ltrim(rtrim(r.RHPcodigoext)),rtrim(ltrim(r.RHPcodigo))))
						from RHPuestos r
						where r.Ecodigo = a.Ecodigo
						   and r.RHPcodigo = a.RHPcodigo
						) as RHPcodigoext,
				   a.RHJid,
				   a.DLfvigencia, 
				   a.DLfvigencia as rige,
				   a.DLffin,
				   a.DLffin as vence,
				   a.DLsalario, a.DLobs, a.Usucodigo, a.Ulocalizacion, a.RHAporc, a.RHAporcsal,
				   a.RHAvdisf, a.RHAvcomp, 
				   a.Indicador_de_Negociado as negociado,
				   a.RHCPlinea,
				   a.ts_rversion,				   
				   b.NTIcodigo, b.DEidentificacion,
					a.RHAtipo,
					a.RHAdescripcion,
					a.EVfantig,

				   {fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) } as NombreEmp,
				   rtrim(c.RHTcodigo) as RHTcodigo, c.RHTdesc, c.RHTpfijo, 
				   <cfif isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1>
					   0 as RHTctiponomina, 0 as RHTcregimenv, 0 as RHTcoficina, 0 as RHTcdepto, 0 as RHTcplaza, 0 as RHTcpuesto, 0 as RHTccomp, 
					   0 as RHTcsalariofijo, 0 as RHTcjornada, 0 as RHTcvacaciones, 0 as RHTccatpaso, 0 as RHTcempresa, 0 as RHTnoveriplaza,
				   <cfelse>
					   c.RHTctiponomina, c.RHTcregimenv, c.RHTcoficina, c.RHTcdepto, c.RHTcplaza, c.RHTcpuesto, c.RHTccomp, 
					   c.RHTcsalariofijo, c.RHTcjornada, 1 as RHTcvacaciones, c.RHTccatpaso, c.RHTcempresa, c.RHTnoveriplaza,
				   </cfif>
				   c.RHTcomportam, c.RHTpmax, 
					(select min(d.NTIdescripcion)
						from NTipoIdentificacion d
						where d.NTIcodigo = b.NTIcodigo
					) as NTIdescripcion, 
				   e.RHPdescripcion, rtrim(e.RHPcodigo) as CodPlaza, 
				   (select min(coalesce(ltrim(rtrim(r.RHPcodigoext)),rtrim(ltrim(r.RHPcodigo))))
						from RHPuestos r
						where r.Ecodigo = a.Ecodigo
						   and r.RHPcodigo = a.RHPcodigo
						) as CodPuesto, 
				   e.Dcodigo as CodDepto, e.Ocodigo as CodOfic,
					(select min(f.RHPdescpuesto)
						from RHPuestos f
						where f.Ecodigo = a.Ecodigo
						   and f.RHPcodigo = a.RHPcodigo
					) as RHPdescpuesto,					
					(select min( {fn concat(coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))),{fn concat(' - ',f.RHPdescpuesto)} )} )
						from RHPuestos f
						where f.Ecodigo = a.Ecodigo
						   and f.RHPcodigo = a.RHPcodigo
					) as Puesto,					
					(select min(g.Tdescripcion)
						from TiposNomina g
						where g.Ecodigo = a.Ecodigo
						   and g.Tcodigo = a.Tcodigo
					) as Tdescripcion,
					(select min(h.Descripcion)
						from RegimenVacaciones h
						where h.RVid = a.RVid
					) as RegVacaciones, 				   
				    (select min(Odescripcion)
						from Oficinas i
						where i.Ecodigo = a.Ecodigo
						   and i.Ocodigo = a.Ocodigo
					) as Odescripcion,	 
				   (select min(j.Ddescripcion) 
						from Departamentos j 
						where j.Ecodigo = a.Ecodigo
						   and j.Dcodigo = a.Dcodigo
					) as Ddescripcion,				 
				   {fn concat(rtrim(e.RHPcodigo),{fn concat(' - ',e.RHPdescripcion)})} as Plaza,
				   (select {fn concat(rtrim(k.RHJcodigo),{fn concat(' - ',k.RHJdescripcion)})}
				   		from RHJornadas k
						where a.Ecodigo = k.Ecodigo
							and a.RHJid = k.RHJid
				   ) as Jornada,				   
				   s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
				   t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
				   u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,				   
				   pp.RHPPid,
				   pp.RHPPcodigo,
				   pp.RHPPdescripcion,
				   ( select min({fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' - ',ltrim(rtrim(cf.CFdescripcion)))})})
						from CFuncional cf
						where cf.CFid = e.CFid
					) as Ctrofuncional,
					ltp.RHMPnegociado,
				   coalesce(a.IDInterfaz,0) as IDInterfaz,
				   RHAdiasenfermedad,
				   RHTNoMuestraCS,
				   coalesce(c.RHTsubcomportam,0) as RHTsubcomportam,
				   coalesce(a.RHItiporiesgo,0) as RHItiporiesgo,
				   coalesce(a.RHIconsecuencia,0) as RHIconsecuencia,
				   coalesce(a.RHIcontrolincapacidad,0) as RHIcontrolincapacidad
			from RHAcciones a

				 inner join DatosEmpleado b
					on a.DEid = b.DEid

				 inner join RHTipoAccion c
					on a.RHTid = c.RHTid

				 left outer join RHPlazas e
					on a.RHPid = e.RHPid
					
					<!---====================================================================================  
						Se une con la linea del tiempo de la plaza presup. para obtener los datos de la plaza de RH 
						en el momento de la accion, se verifica que el puesto de RH tenga asignado el mismo
						puesto presupuestario de plaza presup. 
						Se obtiene de ahi el puesto presup. tabla salarial y categoria.						
					===============================================================================---->
					left outer join RHLineaTiempoPlaza ltp
						on e.RHPid = ltp.RHPid
						and  a.DLfvigencia between ltp.RHLTPfdesde  and ltp.RHLTPfhasta
						<!----and ltp.RHMPPid = f.RHMPPid---->

						left outer join RHPlazaPresupuestaria pp
							on ltp.RHPPid = pp.RHPPid
							and ltp.Ecodigo = pp.Ecodigo
				
				 left outer join RHCategoriasPuesto r
				 	on r.RHCPlinea = a.RHCPlinea
					
				 left outer join RHTTablaSalarial s
				 	on s.RHTTid = r.RHTTid

				 left outer join RHCategoria t
				 	on t.RHCid = r.RHCid
					
				 left outer join RHMaestroPuestoP u 	<!----Puesto presupuestario ----->
					on r.RHMPPid = u.RHMPPid		

			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>

	<!--- Averiguar si los componentes son negociados --->
	<cfif Len(Trim(rsAccion.RHPid))>
		<cfquery name="rsNegociado" datasource="#Session.DSN#">
			select a.RHMPnegociado
			from RHLineaTiempoPlaza a
			where a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHPid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsAccion.DLfvigencia#"> between a.RHLTPfdesde and a.RHLTPfhasta
		</cfquery>
		
		<cfset LvarNegociado = (rsNegociado.RHMPnegociado EQ 'N')>
	<cfelse>
		<cfset LvarNegociado = false>
	</cfif>

	<cfif rsAccion.RecordCount eq 0>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSeEncuentraLaAccion"
			Default="No se encuentra la acción"
			returnvariable="MSG_NoSeEncuentraLaAccion"/>

		<cf_throw message="#MSG_NoSeEncuentraLaAccion#" errorCode="1090">
	</cfif>
	
	<cfquery name="rsEstadoActual" datasource="#Session.DSN#">
		select a.LTid, rtrim(a.Tcodigo) as Tcodigo, 
			   a.RVid,
			   a.Ocodigo, 
			   a.Dcodigo, 
			   a.RHPid, 
			   rtrim(a.RHPcodigo) as RHPcodigo, 
			   (select min(coalesce(ltrim(rtrim(ff.RHPcodigoext)),rtrim(ltrim(ff.RHPcodigo))))
						from RHPuestos ff
						where ff.Ecodigo = a.Ecodigo
						   and ff.RHPcodigo = a.RHPcodigo
						) as RHPcodigoext,
			   a.RHJid,
			   a.LTporcplaza, 
			   a.LTporcsal, 
			   a.LTsalario,
			   a.RHCPlinea,

			  (select min(b.Tdescripcion)
			  	from TiposNomina b
				where a.Ecodigo = b.Ecodigo
						and a.Tcodigo = b.Tcodigo
			  ) as  Tdescripcion, 
			  (select  min(c.Descripcion)
			  	from RegimenVacaciones c
				where a.RVid = c.RVid
			  ) as RegVacaciones, 
 			  (select min(d.Odescripcion)
			  	from Oficinas d
				where a.Ocodigo = d.Ocodigo
					and a.Ecodigo = d.Ecodigo
			  ) as Odescripcion, 
  			  (select min(e.Ddescripcion)
			  	from Departamentos e
				where a.Dcodigo = e.Dcodigo
					and a.Ecodigo = e.Ecodigo
			  ) as Ddescripcion, 			  
			   f.RHPdescripcion, 
			   rtrim(f.RHPcodigo) as CodPlaza,
			   
			   (select min(coalesce(ltrim(rtrim(fx.RHPcodigoext)),rtrim(ltrim(fx.RHPcodigo))))
						from RHPuestos fx
						where fx.Ecodigo = a.Ecodigo
						   and fx.RHPcodigo = a.RHPcodigo
				 ) as CodPuesto, 
			   f.Dcodigo as CodDepto, 
			   f.Ocodigo as CodOfic,
			   {fn concat(rtrim(f.RHPcodigo),{fn concat(' - ',f.RHPdescripcion)})}	as Plaza,  
			   <!----rtrim(f.RHPcodigo) || ' - ' || f.RHPdescripcion as Plaza, ---->
			   (select min(g.RHPdescpuesto)
			   	from RHPuestos g
				where a.RHPcodigo = g.RHPcodigo
					and a.Ecodigo = g.Ecodigo
				) as RHPdescpuesto, 
			   (select 	min({fn concat(rtrim(coalesce(ltrim(rtrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo)))),{fn concat(' - ',g.RHPdescpuesto)})})
			   			<!---min(rtrim(g.RHPcodigo) || ' - ' || g.RHPdescpuesto)--->
			   	from RHPuestos g
				where a.RHPcodigo = g.RHPcodigo
					and a.Ecodigo = g.Ecodigo
			   ) as Puesto,
 			  (select 	min({fn concat(rtrim(j.RHJcodigo),{fn concat(' - ',j.RHJdescripcion)})})
			  			<!---min(rtrim(j.RHJcodigo) || ' - ' || j.RHJdescripcion)--->
			  	from RHJornadas j
				where  a.Ecodigo = j.Ecodigo
					and a.RHJid = j.RHJid
			  )	as Jornada,
			   s.RHTTid, 
			   rtrim(s.RHTTcodigo) as RHTTcodigo, 
			   s.RHTTdescripcion, 
			   t.RHCid, 
			   rtrim(t.RHCcodigo) as RHCcodigo, 
			   t.RHCdescripcion, 
			   u.RHMPPid, 
			   rtrim(u.RHMPPcodigo) as RHMPPcodigo, 
			   u.RHMPPdescripcion,
			  (select 	min({fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' ',ltrim(rtrim(cf.CFdescripcion)))})})
			  			<!----min(ltrim(rtrim(cf.CFcodigo))||' '||ltrim(rtrim(cf.CFdescripcion)))---->
			   from CFuncional cf
				where f.CFid = cf.CFid
					and f.Ecodigo = cf.Ecodigo		
			  )	as Ctrofuncional,
			   pp.RHPPid,
			   pp.RHPPcodigo,
			   pp.RHPPdescripcion,
			   ltp.RHMPnegociado
			   
		from LineaTiempo a

			 inner join RHPlazas f
				on a.RHPid = f.RHPid
				and a.Ecodigo = f.Ecodigo
				
				<!---====================================================================================  
						Se une con la linea del tiempo de la plaza presup. para obtener los datos de la plaza de RH 
						en el momento de la accion, se verifica que el puesto de RH tenga asignado el mismo
						puesto presupuestario de plaza presup. 						
					===============================================================================---->
					left outer join RHLineaTiempoPlaza ltp
						on f.RHPid = ltp.RHPid						
						and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsAccion.DLfvigencia#"> between ltp.RHLTPfdesde 
							and ltp.RHLTPfhasta
						<!----and ltp.RHMPPid = g.RHMPPid----->
						
						left outer join RHPlazaPresupuestaria pp
							on ltp.RHPPid = pp.RHPPid
							and ltp.Ecodigo = pp.Ecodigo
												 
			 left outer join RHCategoriasPuesto r
				on r.RHCPlinea = a.RHCPlinea
				
			 left outer join RHTTablaSalarial s
				on s.RHTTid = r.RHTTid

			 left outer join RHCategoria t
				on t.RHCid = r.RHCid
				
			left outer join RHMaestroPuestoP u 	<!----Puesto presupuestario ----->
				on r.RHMPPid = u.RHMPPid			

		where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsAccion.DLfvigencia#"> between a.LTdesde and a.LThasta
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DEid#" null="#Len(rsAccion.DEid) is 0#">
	</cfquery>
	
	<!--- Conceptos de Pago --->
	<cfquery name="rsConceptosPago" datasource="#Session.DSN#">
		select {fn concat(b.CIcodigo,{fn concat(' - ',b.CIdescripcion)})} as Concepto,
				<!----b.CIcodigo || ' - ' || b.CIdescripcion as Concepto, ---->
			   a.RHCAimporte as Importe, 
			   a.RHCAcant as Cantidad, 
			   a.RHCAres as Resultado
		from RHConceptosAccion a, CIncidentes b
		where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
		and a.CIid = b.CIid
	</cfquery>

	<!--- Si el empleado ya ha sido nombrado y tiene linea del tiempo --->
	<cfif rsEstadoActual.recordCount GT 0>
		<!--- Equipara los componentes salariales para que se respeten los que se tienen ya en la línea de tiempo
			  y se agrega el primer componente salarial si no hay ninguno --->

		<!--- Si no existen componentes para la acción se intenta insertar un componente de tipo salario base --->
		<cfquery name="chkRHDAcciones" datasource="#Session.DSN#">
			select count(1) as cant 
			from RHDAcciones 
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
		</cfquery>
		
		<!--- inserta componentes a partir de los existentes en la linea del tiempo para la primera vez --->
		<!--- Si no es Cambio de Empresa --->
		<cfif not (rsTipoAccionComp.RHTcomportam EQ 9 and rsTipoAccionComp.RHTcempresa EQ 1) and chkRHDAcciones.cant EQ 0>
			<cfquery name="rsEquipararLineaTiempo" datasource="#Session.DSN#">
				insert into RHDAcciones(RHAlinea, CSid, RHDAtabla, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#"  null="#Len(rsAccion.RHAlinea) is 0#">, 
					   a.CSid, a.DLTtabla, 
					   coalesce(a.DLTunidades, 1.00), 
					   case 
				   			when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 then round(coalesce(a.DLTmonto, 0.00) / coalesce(a.DLTunidades, 1.00), 2) * 100
				   			else round(coalesce(a.DLTmonto, 0.00) / coalesce(a.DLTunidades, 1.00), 2)
				   	   end as DLTmontobase,
					   coalesce(a.DLTmonto, 0.00), 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
				from DLineaTiempo a
					left outer join RHMetodosCalculo d
						on d.CSid = a.CSid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between d.RHMCfecharige and d.RHMCfechahasta
						and d.RHMCestadometodo = 1
				where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.LTid#">
				and not exists (
					select 1
					from RHDAcciones b
					where b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
					and b.CSid = a.CSid
				)
			</cfquery>
		</cfif>
		
		<!--- Si no existen componentes para la acción se intenta insertar un componente de tipo salario base --->
		<cfquery name="chkRHDAcciones" datasource="#Session.DSN#">
			select count(1) as cant 
			from RHDAcciones 
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
		</cfquery>
		
		<cfif chkRHDAcciones.cant EQ 0>
			<!--- Insertar Salario Base --->
			<cfquery name="insComponente" datasource="#Session.DSN#">
				insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">, 
					   CSid, 1.00, 0.00, 0.00, 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
				from ComponentesSalariales a
				<!--- Cambio de Empresa --->
				<cfif rsTipoAccionComp.RHTcomportam EQ 9 and rsTipoAccionComp.RHTcempresa EQ 1>
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.EcodigoRef#">
				<cfelse>
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfif>
				and a.CScodigo = (
					select min(CScodigo) from ComponentesSalariales b 
					where b.Ecodigo = a.Ecodigo and b.CSsalariobase = 1
				)
			</cfquery>

			<!--- Si no existen componentes para la acción se intenta insertar el componente con el código menor --->
			<cfquery name="chkRHDAcciones" datasource="#Session.DSN#">
				select count(1) as cant 
				from RHDAcciones 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
			</cfquery>
			
			<cfif chkRHDAcciones.cant EQ 0>
				<cfquery name="insComponente" datasource="#Session.DSN#">
					insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">, 
						   CSid, 1.00, 0.00, 0.00, 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
					from ComponentesSalariales a
					<!--- Cambio de Empresa --->
					<cfif rsTipoAccionComp.RHTcomportam EQ 9 and rsTipoAccionComp.RHTcempresa EQ 1>
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.EcodigoRef#">
					<cfelse>
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfif>
					and a.CScodigo = (
						select min(CScodigo) from ComponentesSalariales b where b.Ecodigo = a.Ecodigo
					)
				</cfquery>
			</cfif>
		</cfif>

		<!--- Componentes de Situacion Posterior --->
		<cfquery name="rsComponentesAccion" datasource="#Session.DSN#">
			select a.RHDAlinea, 
				   a.CSid, 
				   b.CSdescripcion, 
				   b.CSusatabla,
				   b.CSsalariobase,
				   a.RHDAtabla, 
				   a.RHDAunidad, 
				   a.RHDAmontobase, 
				   a.RHDAmontores,
				   a.ts_rversion,
				   coalesce(b.CIid, -1) as CIid,
				   coalesce(c.RHMCcomportamiento, 1) as RHMCcomportamiento,
				   coalesce(c.RHMCvalor, 1.00) as valor
			from RHDAcciones a
				 inner join ComponentesSalariales b 
					on b.CSid = a.CSid
				 left outer join RHMetodosCalculo c
					on c.Ecodigo = b.Ecodigo
					and c.CSid = b.CSid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between c.RHMCfecharige and c.RHMCfechahasta
					and c.RHMCestadometodo = 1
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
			order by b.CSorden, b.CScodigo, b.CSdescripcion
		</cfquery>
		
		<cfif rsComponentesAccion.recordCount GT 0>
			<cfquery name="rsSumComponentesAccion" dbtype="query">
				select sum(RHDAmontores) as Total from rsComponentesAccion
				where CIid = -1
			</cfquery>
		<cfelse>
			<cfset rsSumComponentesAccion = QueryNew("Total", "Double")>
			<cfset tempvar = QueryAddRow(rsSumComponentesAccion, 1)>
			<cfset tempvar = QuerySetCell(rsSumComponentesAccion, "Total", 0.00, 1)>
		</cfif>
		
		<!--- Componentes de Situacion Actual --->
		<!--- Cuando es Cambio de Empresa --->
		<cfif rsTipoAccionComp.RHTcomportam EQ 9 and rsTipoAccionComp.RHTcempresa EQ 1>
			<cfquery name="rsComponentesActual" datasource="#Session.DSN#">
				select c.CSid, 
					   c.CScodigo, 
					   c.CSdescripcion,
					   c.CSusatabla,
					   c.CSsalariobase,
					   b.DLTtabla, 
					   coalesce(b.DLTunidades, 0.00) as DLTunidades, 
					   case when d.RHMCcomportamiento = 1 then round(coalesce(b.DLTmonto, 0.00) * 100.0 / coalesce(b.DLTunidades, 1.00), 2)
					   		else round(coalesce(b.DLTmonto, 0.00)/coalesce(b.DLTunidades, 1.00), 2) 
					   end as DLTmontobase,
					   coalesce(b.DLTmonto, 0.00) as DLTmonto, 
					   coalesce(c.CIid, -1) as CIid,
					   coalesce(d.RHMCcomportamiento, 1) as RHMCcomportamiento,
					   coalesce(d.RHMCvalor, 1.00) as valor
				from DLineaTiempo b
					 inner join ComponentesSalariales c
						on c.CSid = b.CSid
					 left outer join RHMetodosCalculo d
						on d.Ecodigo = c.Ecodigo
						and d.CSid = c.CSid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between d.RHMCfecharige and d.RHMCfechahasta
						and d.RHMCestadometodo = 1
				where b.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.LTid#">
				order by c.CSorden, c.CScodigo, c.CSdescripcion
			</cfquery>

		<cfelse>
			<cfquery name="rsComponentesActual" datasource="#Session.DSN#">
				select c.CSid, 
					   c.CScodigo, 
					   c.CSdescripcion,
					   c.CSorden,
					   c.CSusatabla,
					   c.CSsalariobase,
					   b.DLTtabla, 
					   coalesce(b.DLTunidades, 0.00) as DLTunidades, 
					   case 
							when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 then round(coalesce(b.DLTmonto, 0.00) / coalesce(b.DLTunidades, 1.00), 2) * 100
							else round(coalesce(b.DLTmonto, 0.00) / coalesce(b.DLTunidades, 1.00), 2)
					   end as DLTmontobase,
					   coalesce(b.DLTmonto, 0.00) as DLTmonto, 
					   coalesce(c.CIid, -1) as CIid,
					   coalesce(d.RHMCcomportamiento, 1) as RHMCcomportamiento,
					   coalesce(d.RHMCvalor, 1.00) as valor
				from RHDAcciones a
					 left outer join DLineaTiempo b
						on b.CSid = a.CSid
						and b.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.LTid#">
					 inner join ComponentesSalariales c
						on c.CSid = a.CSid
					 left outer join RHMetodosCalculo d
						on d.Ecodigo = c.Ecodigo
						and d.CSid = c.CSid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between d.RHMCfecharige and d.RHMCfechahasta
						and d.RHMCestadometodo = 1
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
				union
				select c.CSid, 
					   c.CScodigo, 
					   c.CSdescripcion,
					   c.CSorden,
					   c.CSusatabla,
					   c.CSsalariobase,
					   b.DLTtabla, 
					   coalesce(b.DLTunidades, 1.00) as DLTunidades, 
					   case 
							when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 then round(coalesce(b.DLTmonto, 0.00) / coalesce(b.DLTunidades, 1.00), 2) * 100
							else round(coalesce(b.DLTmonto, 0.00) / coalesce(b.DLTunidades, 1.00), 2)
					   end as DLTmontobase,
					   coalesce(b.DLTmonto, 0.00) as DLTmonto, 
					   coalesce(c.CIid, -1) as CIid,
					   coalesce(d.RHMCcomportamiento, 1) as RHMCcomportamiento,
					   coalesce(d.RHMCvalor, 1.00) as valor
				from DLineaTiempo b
					 inner join ComponentesSalariales c
						on c.CSid = b.CSid
					 left outer join RHMetodosCalculo d
						on d.Ecodigo = c.Ecodigo
						and d.CSid = c.CSid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between d.RHMCfecharige and d.RHMCfechahasta
						and d.RHMCestadometodo = 1
				where b.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.LTid#">
				order by 4, 2, 3
			</cfquery>
		</cfif> <!--- Componentes de Situacion Actual --->

		<cfif rsComponentesActual.recordCount GT 0>
			<cfquery name="rsSumComponentesActual" dbtype="query">
				select sum(DLTmonto) as Total from rsComponentesActual
				where CIid = -1
			</cfquery>
		<cfelse>
			<cfset rsSumComponentesActual = QueryNew("Total", "Double")>
			<cfset tempvar = QueryAddRow(rsSumComponentesActual, 1)>
			<cfset tempvar = QuerySetCell(rsSumComponentesActual, "Total", 0.00, 1)>
		</cfif>

	<!--- Si no hay Linea de Tiempo --->
	<cfelse>

		<!--- Si no existen componentes para la acción se intenta insertar un componente de tipo salario base --->
		<cfquery name="chkRHDAcciones" datasource="#Session.DSN#">
			select count(1) as cant 
			from RHDAcciones 
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
		</cfquery>
		
		<cfif chkRHDAcciones.cant EQ 0>
			<!--- Insertar Salario Base --->
			<cfquery name="insComponente" datasource="#Session.DSN#">
				insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">, 
					   CSid, 1.00, 0.00, 0.00, 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
				from ComponentesSalariales a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.CScodigo = (
					select min(CScodigo) from ComponentesSalariales b 
					where b.Ecodigo = a.Ecodigo and b.CSsalariobase = 1
				)
			</cfquery>

			<!--- Si no existen componentes para la acción se intenta insertar el componente con el código menor --->
			<cfquery name="chkRHDAcciones" datasource="#Session.DSN#">
				select count(1) as cant 
				from RHDAcciones 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
			</cfquery>
			
			<cfif chkRHDAcciones.cant EQ 0>
				<cfquery name="insComponente" datasource="#Session.DSN#">
					insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">, 
						   CSid, 1.00, 0.00, 0.00, 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
					from ComponentesSalariales a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.CScodigo = (
						select min(CScodigo) from ComponentesSalariales b where b.Ecodigo = a.Ecodigo
					)
				</cfquery>
			</cfif>
		</cfif>
		
		<!--- Componentes de Situacion Posterior --->
		<cfquery name="rsComponentesAccion" datasource="#Session.DSN#">
			select a.RHDAlinea, 
				   a.CSid, 
				   b.CSdescripcion, 
				   b.CSusatabla,
				   b.CSsalariobase,
				   a.RHDAtabla, 
				   a.RHDAunidad, 
				   a.RHDAmontobase, 
				   a.RHDAmontores,
				   a.ts_rversion,
				   coalesce(b.CIid, -1) as CIid,
				   coalesce(c.RHMCcomportamiento, 1) as RHMCcomportamiento,
				   coalesce(c.RHMCvalor, 1.00) as valor
			from RHDAcciones a
				 inner join ComponentesSalariales b 
					on b.CSid = a.CSid
				 left outer join RHMetodosCalculo c
					on c.Ecodigo = b.Ecodigo
					and c.CSid = b.CSid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between c.RHMCfecharige and c.RHMCfechahasta
					and c.RHMCestadometodo = 1
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
			order by b.CSorden, b.CScodigo, b.CSdescripcion
		</cfquery>
		<cfif rsComponentesAccion.recordCount GT 0>
			<cfquery name="rsSumComponentesAccion" dbtype="query">
				select sum(RHDAmontores) as Total from rsComponentesAccion
				where CIid = -1
			</cfquery>
		<cfelse>
			<cfset rsSumComponentesAccion = QueryNew("Total", "Double")>
			<cfset tempvar = QueryAddRow(rsSumComponentesAccion, 1)>
			<cfset tempvar = QuerySetCell(rsSumComponentesAccion, "Total", 0.00, 1)>
		</cfif>

		<!--- Componentes de Situacion Actual --->
		<cfquery name="rsComponentesActual" datasource="#Session.DSN#">
			select a.RHDAlinea, 
				   a.CSid, 
				   b.CScodigo,
				   b.CSdescripcion, 
				   b.CSusatabla,
				   b.CSsalariobase,
			       null as DLTtabla, 
				   0.00 as DLTunidades, 
				   0.00 as DLTmontobase, 
				   0.00 as DLTmonto, 
				   a.ts_rversion,
				   coalesce(b.CIid, -1) as CIid,
				   coalesce(c.RHMCcomportamiento, 1) as RHMCcomportamiento,
				   coalesce(c.RHMCvalor, 1.00) as valor
			from RHDAcciones a
				 inner join ComponentesSalariales b 
					on b.CSid = a.CSid
				 left outer join RHMetodosCalculo c
					on c.Ecodigo = b.Ecodigo
					and c.CSid = b.CSid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between c.RHMCfecharige and c.RHMCfechahasta
					and c.RHMCestadometodo = 1
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHAlinea#" null="#Len(rsAccion.RHAlinea) is 0#">
			order by b.CSorden, b.CScodigo, b.CSdescripcion
		</cfquery>
		<cfif rsComponentesActual.recordCount GT 0>
			<cfquery name="rsSumComponentesActual" dbtype="query">
				select sum(DLTmonto) as Total from rsComponentesActual
				where CIid = -1
			</cfquery>
		<cfelse>
			<cfset rsSumComponentesActual = QueryNew("Total", "Double")>
			<cfset tempvar = QueryAddRow(rsSumComponentesActual, 1)>
			<cfset tempvar = QuerySetCell(rsSumComponentesActual, "Total", 0.00, 1)>
		</cfif>
		
	</cfif>
	
<cfelseif modo EQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("Form.RHTid") AND Len(Trim(Form.RHTid)) NEQ 0>
	<!--- Tipo de Accion por Defecto ---> 
	<cfquery name="rsTipoAccionDef" datasource="#Session.DSN#">
		select a.RHTid, rtrim(a.RHTcodigo) as RHTcodigo, a.RHTdesc, a.RHTpfijo, a.RHTpmax
		from RHTipoAccion a, RHUsuarioTipoAccion b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
		and a.RHTcomportam not in (7, 8)
		and a.Ecodigo = b.Ecodigo
		and a.RHTid  = b.RHTid 
		and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		union
		select a.RHTid, rtrim(a.RHTcodigo) as RHTcodigo, a.RHTdesc, a.RHTpfijo, a.RHTpmax
		from RHTipoAccion a 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHTcomportam not in (7, 8) 
		  and not exists(select 1 from RHUsuarioTipoAccion b where b.RHTid = a.RHTid)
		order by 2, 3
	</cfquery>	
</cfif>
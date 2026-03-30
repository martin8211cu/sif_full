<cfinclude template="../Utiles/sifConcat.cfm">

<cfquery datasource="#session.DSN#" name="rsCFSol">
	select ltrim(rtrim(substring(CFdescripcion,1,5))) as CFdescripcion, sc.CMTScodigo from ESolicitudCompraCM sc 
	inner join CFuncional cf on sc.CFid = cf.CFid and sc.Ecodigo = cf.Ecodigo                      
    inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
    where ESnumero = #rsTipoSolicitud.ESnumero# and sc.Ecodigo = #session.Ecodigo# and ECFencargado = 1 
</cfquery>

<cfquery datasource="#session.dsn#" name="rsBeneficiario">
		select ESOobs
		from ESolicitudCompraCM s
		where ESnumero = #rsTipoSolicitud.ESnumero# and s.Ecodigo = #session.Ecodigo# 
		and ltrim(rtrim(s.ESOobs)) = (select distinct ltrim(rtrim(de.DEapellido1+
		' '+de.DEapellido2+' '+de.DEnombre)) as Nombre
						    from ESolicitudCompraCM c
							inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			                where ESnumero = #rsTipoSolicitud.ESnumero# and c.Ecodigo = #session.Ecodigo# 
							and ECFencargado = 1)
</cfquery>

<cfquery datasource="#session.DSN#" name="rsReporte">
		select distinct coalesce(rtrim(em.Enombre),'') as Enombre,
			Empresa = ltrim(rtrim(convert(varchar(5),em.Ecodigo))) + '-' +ltrim(rtrim(em.Enombre)),
			b.DSconsecutivo,      		
			b.DSmontoest,
			convert(dec(15,2), b.DStotallinest) as DStotallinest,  
			b.DScant,
			b.Ucodigo,
			b.DSdescalterna,
			b.DSdescripcion,
			b.DSespecificacuenta,
			b.DSformatocuenta,
			b.DSobservacion,
			b.DStipo,
			c.Adescripcion, 
			convert (varchar(10),a.ESfecha,103) as ESfecha,
			a.ESnumero,
			convert(dec(15,2),a.EStotalest) as EStotalest,
			a.Usucodigo,
			em.Etelefono1,  
			em.Efax,                 
			em.Eidentificacion as iden ,
			rtrim(ltrim(e.CMTScodigo)) +'-'+ rtrim(ltrim(e.CMTSdescripcion)) as tipo,
			al.Almcodigo,
			case DStipo when 'A' then coalesce(c.Acodigo,'') 
						when 'S' then coalesce(k.Ccodigo,'')
						when 'F' then coalesce(ac.ACcodigodesc,'') 
			end as codigo,
			b.DSformatocuenta,
			rtrim(ltrim(d.CFcodigo)) +'-'+ rtrim(ltrim(d.CFdescripcion)) as CFuncional,
			a.ESobservacion,
			a.SNcodigo, 
			p.NumeroParte,
			a.ESestado,
			case when a.ESestado = 0 then  'Pendiente' 
				when a.ESestado = 10 then 'En Trámite Aprobación'
				when a.ESestado = -10 then  'Rechazada por presupuesto'
				when a.ESestado = 20 then 'Aplicada'
				when a.ESestado = 25 then  'Compra Directa'
				when a.ESestado = 40 then'Parcialmente Surtida'
				when a.ESestado = 50 then  'Surtida'
				when a.ESestado = 60 then  'Cancelada' 
			end as estado,		
			cfcta.CFformato,
			imp.Iporcentaje,
			a.ProcessInstanceid,
			a.ESOobs as Solicitante,
			u.Usulogin,
			sn.SNnombre,
			k.Ccodigo,
			k.Cdescripcion,
			<cfif rsCFSol.CMTScodigo EQ 'SCINV'>
				Rubro = substring(cfcta.CFformato,16,5), 
				Subrubro = substring(cfcta.CFformato,22,3),
			<cfelse>
				Rubro = substring(k.cuentac,1,5), 
				Subrubro = substring(k.cuentac,6,3),
			</cfif>
			m.Miso4217, a.EStipocambio, oc.EOnumero,
			<cfif trim(rsCFSol.CMTScodigo) EQ 'SCCC'>
				A = 'SI',
			<cfelse>
				<cfif isdefined("rsBeneficiario") and rsBeneficiario.recordcount GT 0>
					A = 'SI',
				<cfelseif trim(rsCFSol.CFdescripcion) NEQ 'DIREC' and trim(rsCFSol.CFdescripcion) NEQ 'ORGAN'>
					A = 'SI',
				<cfelse>
					A = 'NO',
				</cfif>
			</cfif>
			Notificar = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						 from ESolicitudCompraCM sc 
                     	 inner join EmpleadoCFuncional ef on ef.CFid = sc.CFid and ef.Ecodigo = sc.Ecodigo
                      	 inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
                      	 where ESnumero = a.ESnumero and a.Ecodigo = sc.Ecodigo and ECFencargado = 1),
			<cfif trim(rsCFSol.CMTScodigo) NEQ 'SCCC'>
				<cfif trim(rsCFSol.CFdescripcion) EQ 'GEREN'>
					Aprobo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre
			    		from CFuncional cf 
						inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
    		            inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
        		        where cf.CFid = (select CFidresp from ESolicitudCompraCM sc 
						inner join CFuncional cf on sc.CFid = cf.CFid and cf.Ecodigo = cf.Ecodigo
						inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
		                where ESnumero = a.ESnumero and sc.Ecodigo = a.Ecodigo and ECFencargado = 1)
						and cf.Ecodigo = a.Ecodigo and ECFencargado = 1),
				<cfelse>
					Aprobo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						 from ESolicitudCompraCM sc 
                     	 inner join EmpleadoCFuncional ef on ef.CFid = sc.CFid and ef.Ecodigo = sc.Ecodigo
                      	 inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
                      	 where ESnumero = a.ESnumero and a.Ecodigo = sc.Ecodigo and ECFencargado = 1),
				</cfif>
			<cfelse>
				<cfif trim(rsCFSol.CFdescripcion) EQ 'GEREN'>
					Aprobo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre
	  			            from CFuncional cf 
	  					    inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
                      		inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
                      		where cf.CFid = (select CFidresp from ESolicitudCompraCM sc 
 																 inner join CFuncional cf on sc.CFid = cf.CFid and                                                                 cf.Ecodigo = cf.Ecodigo
																 inner join EmpleadoCFuncional ef 
																 on ef.CFid = cf.CFidresp                                                                 and ef.Ecodigo = cf.Ecodigo
									 							 where ESnumero = a.ESnumero and sc.Ecodigo = a.Ecodigo 																		                                                                 and ECFencargado = 1)
		  				    and cf.Ecodigo = a.Ecodigo and ECFencargado = 1),
				<cfelseif trim(rsCFSol.CFdescripcion) EQ 'SUBDI' or trim(rsCFSol.CFdescripcion) EQ 'AREA'>
					Aprobo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						    from ESolicitudCompraCM sc 
							inner join CFuncional cf on sc.CFid = cf.CFid and cf.Ecodigo = sc.Ecodigo
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
			                where ESnumero = a.ESnumero and sc.Ecodigo = a.Ecodigo and ECFencargado = 1),
				<cfelse>
					Aprobo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						 from ESolicitudCompraCM sc 
                     	 inner join EmpleadoCFuncional ef on ef.CFid = sc.CFid and ef.Ecodigo = sc.Ecodigo
                      	 inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
                      	 where ESnumero = a.ESnumero and a.Ecodigo = sc.Ecodigo and ECFencargado = 1),
				</cfif>			
			</cfif>
			<cfif trim(rsCFSol.CMTScodigo) NEQ 'SCCC'>
				<cfif trim(rsCFSol.CFdescripcion) EQ 'GEREN'>
					Autorizo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre
	  			            from CFuncional cf 
	  					    inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
                      		inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
                      		where cf.CFid = (select CFidresp from ESolicitudCompraCM sc 
 																 inner join CFuncional cf on sc.CFid = cf.CFid and                                                                 sc.Ecodigo = cf.Ecodigo
																 inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp                                                                 and ef.Ecodigo = cf.Ecodigo
									 							 where ESnumero = a.ESnumero and sc.Ecodigo = a.Ecodigo 																		                                                                 and ECFencargado = 1)
		  				    and cf.Ecodigo = a.Ecodigo and ECFencargado = 1)
				<cfelseif trim(rsCFSol.CFdescripcion) EQ 'SUBDI' or trim(rsCFSol.CFdescripcion) EQ 'AREA'>
					Autorizo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						   	 	from ESolicitudCompraCM sc 
								inner join CFuncional cf on sc.CFid = cf.CFid and cf.Ecodigo = sc.Ecodigo
								inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
            			    	inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
			                	where ESnumero = a.ESnumero and sc.Ecodigo = a.Ecodigo and ECFencargado = 1)
				<cfelseif trim(rsCFSol.CFdescripcion) EQ 'DIREC' or trim(rsCFSol.CFdescripcion) EQ 'ORGAN'>
					<cfif isdefined("rsBeneficiario") and rsBeneficiario.recordcount GT 0>
						Autorizo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						   	 	from ESolicitudCompraCM sc 
								inner join CFuncional cf on sc.CFid = cf.CFid and cf.Ecodigo = sc.Ecodigo
								inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
            			    	inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
			                	where ESnumero = a.ESnumero and sc.Ecodigo = a.Ecodigo and ECFencargado = 1)
					<cfelse>
						Autorizo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						   	 		from ESolicitudCompraCM sc 
									inner join CFuncional cf on sc.CFid = cf.CFid and cf.Ecodigo = sc.Ecodigo
									inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    		inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
			                		where ESnumero = a.ESnumero and sc.Ecodigo = a.Ecodigo and ECFencargado = 1)
					</cfif>
				</cfif>
			<cfelse>
				Autorizo = (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						    from CFuncional cf 
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
			                where cf.Ecodigo = a.Ecodigo and ECFencargado = 1 and CFdescripcion like 'DIRECCION GENERAL')
			</cfif>					
	from ESolicitudCompraCM a
		inner join CMTiposSolicitud e     
			on a.Ecodigo = e.Ecodigo
		   and a.CMTScodigo = e.CMTScodigo
		   
		inner join CFuncional d
				on a.CFid = d.CFid
		
		inner join Usuario u
				on u.Usucodigo = a.Usucodigo
				
		inner join Monedas m    
			on m.Mcodigo = a.Mcodigo
			
		left outer join SNegocios sn
			on sn.SNcodigo = a.SNcodigo	
		
		inner join Empresa em
			on a.Ecodigo = em.Ereferencia
		
		left outer join DSolicitudCompraCM b
					
			inner join Impuestos imp
				on imp.Ecodigo = b.Ecodigo
			   and imp.Icodigo = b.Icodigo
			
			left join DOrdenCM oc
			on oc.ESidsolicitud = b.ESidsolicitud 
			left outer join Articulos c
				on c.Aid=b.Aid
		
			left outer join Almacen al
				on  al.Aid = b.Alm_Aid
			
			left outer join Conceptos k
				on b.Cid=k.Cid
		
			left outer join AClasificacion ac
				on b.Ecodigo = ac.Ecodigo
			   and b.ACcodigo = ac.ACcodigo
 			   and b.ACid = ac.ACid
			
			left outer join CFinanciera cfcta
			on b.CFcuenta = cfcta.CFcuenta
					
		on a.ESidsolicitud = b.ESidsolicitud 
		
		left outer join NumParteProveedor p
			on c.Aid = p.Aid
			and c.Ecodigo = p.Ecodigo
			and a.SNcodigo = p.SNcodigo
			and a.ESfecha between p.Vdesde and p.Vhasta
where a.Ecodigo = #session.Ecodigo#
		and a.ESnumero = #rsTipoSolicitud.ESnumero#
		and a.CMSid = #rsTipoSolicitud.CMSid#	
	order by a.ESnumero, b.DSconsecutivo	
</cfquery>

<cfreport format="flashpaper" template="SCCIM.cfr" query="rsReporte"></cfreport>



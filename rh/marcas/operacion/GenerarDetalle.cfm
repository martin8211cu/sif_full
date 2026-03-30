<!---- ================== Eliminar las inconsistencias si existen ==================----->
<cfquery name="rsDelete" datasource="#session.DSN#">
	delete RHDetalleIncidencias
	where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
</cfquery>
<!----- ==========================================================================================
			Generar inconsistencias por excepciones en: 
			Hora extra de entrada, Hora extra salida, Hora rebaja entrada, Hora rebaja salida 
			23/02/2006
		========================================================================================== ----->
<!---Tabla temporal de las inconsistencias encontradas (Se guarda un registro por cada una) ----->
<cf_dbtemp name="IncidenciasMarca" returnvariable="IncidenciasMarca" datasource="#session.DSN#">
	<cf_dbtempcol name="RHCMid"				type="numeric"   mandatory="yes">
	<cf_dbtempcol name="RHPMid"				type="numeric"	 mandatory="yes">
	<cf_dbtempcol name="RDHMhorascalc"		type="float"     mandatory="yes">
	<cf_dbtempcol name="RDHMhorasautor"		type="float"     mandatory="yes">
	<cf_dbtempcol name="InicioExcepcion"	type="datetime"  mandatory="yes">
	<cf_dbtempcol name="FinExcepcion"		type="datetime"  mandatory="yes">
	<cf_dbtempcol name="CIid"				type="numeric"   mandatory="yes">
	<cf_dbtempcol name="Indicador"			type="varchar(2)"    mandatory="no">
</cf_dbtemp>		
<!----- ==================== INSERTA HORAS EXTRA DE ENTRADA ====================== ---->
<cfquery datasource="#session.DSN#">
	insert into #IncidenciasMarca# ( RHCMid ,
									RHPMid, 
									RDHMhorascalc , 
									RDHMhorasautor , 
									InicioExcepcion , 
									FinExcepcion,
									CIid,
									Indicador			
								)
	select 	a.RHCMid,
			a.RHPMid,				
			(case when 	convert(varchar, a.RHCMhoraentradac, 108)   >= convert(varchar, b.RHEJhorainicio, 108)   and 
						convert(varchar,a.RHCMhorasalidac, 108)  <= convert(varchar, b.RHEJhorafinal, 108)  then					
							datediff( mi, convert(varchar, a.RHCMhoraentradac, 108), convert(varchar, a.RHCMhorasalidac, 108) )/60 															
						else 
							case when 	convert(varchar, a.RHCMhoraentradac, 108) >= convert(varchar, b.RHEJhorainicio, 108) and
								convert(varchar,a.RHCMhorasalidac, 108)  > convert(varchar, b.RHEJhorafinal, 108)  then
									datediff(mi, 
											(case when convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHEJhorainicio, 108) then 
												convert(varchar, a.RHCMhoraentradac, 108) 
											else 
												convert(varchar, b.RHEJhorainicio, 108) 
											end),
											(case when convert(varchar, f.RHJhoraini, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
												convert(varchar, f.RHJhoraini, 108) 
											else 
												convert(varchar, b.RHEJhorafinal, 108) 
											end)
											)/60.0	
	
						else	
							case when convert(varchar, a.RHCMhoraentradac, 108) <= convert(varchar, b.RHEJhorafinal, 108) then
										datediff( mi, convert(varchar, a.RHCMhoraentradac, 108), (case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
													convert(varchar, a.RHCMhoraentradac, 108) 
												else 
													convert(varchar, b.RHEJhorafinal, 108) 
												end)
													)/60
							else
								0.00
							end 
						end 
			end),
			(case when 	convert(varchar, a.RHCMhoraentradac, 108)   >= convert(varchar, b.RHEJhorainicio, 108)   and 
						convert(varchar,a.RHCMhorasalidac, 108)  <= convert(varchar, b.RHEJhorafinal, 108)  then					
							datediff( mi, convert(varchar, a.RHCMhoraentradac, 108), convert(varchar, a.RHCMhorasalidac, 108) )/60 															
						else 
							case when 	convert(varchar, a.RHCMhoraentradac, 108) >= convert(varchar, b.RHEJhorainicio, 108) and
								convert(varchar,a.RHCMhorasalidac, 108)  > convert(varchar, b.RHEJhorafinal, 108)  then
									datediff(mi, 
											(case when convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHEJhorainicio, 108) then 
												convert(varchar, a.RHCMhoraentradac, 108) 
											else 
												convert(varchar, b.RHEJhorainicio, 108) 
											end),
											(case when convert(varchar, f.RHJhoraini, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
												convert(varchar, f.RHJhoraini, 108) 
											else 
												convert(varchar, b.RHEJhorafinal, 108) 
											end)
											)/60.0	

						else	
							case when convert(varchar, a.RHCMhoraentradac, 108) <= convert(varchar, b.RHEJhorafinal, 108) then
								datediff( mi, convert(varchar, a.RHCMhoraentradac, 108), 
											(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
												convert(varchar, a.RHCMhoraentradac, 108) 
											else 
												convert(varchar, b.RHEJhorafinal, 108) 
											end)
										)/60
							else
								0.00
							end 
						end 
			end),
			b.RHEJhorainicio as InicioExcepcion,
			b.RHEJhorafinal as FinalExcepcion,
			b.CIid,
			'EE'

	from 	RHControlMarcas a, 			
			RHExcepcionesJornada b,			
			RHJornadas c, 
			RHComportamientoJornada d, 
			CIncidentes e,
			RHDJornadas f
		
	where a.RHPMid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and a.RHCMid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
		and a.RHCMmismodia = 1
		
		<!---- Donde la marca de entrada este dentro de la excepcion ---->
		and convert(varchar, a.RHCMhoraentradac, 108) >= convert(varchar, b.RHEJhorainicio, 108)	
		and convert(varchar, a.RHCMhoraentradac, 108) <= convert(varchar, b.RHEJhorafinal, 108)

		and b.CIid = e.CIid
		and e.CInegativo = 1
		and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

		and c.RHJid = f.RHJid
		and c.Ecodigo = f.Ecodigo
		<!---============ 30/03/2006 ============= ----->
		<!----and datepart(dw,a.RHCMfregistro) = f.RHDJdia	---->
		and datepart(dw,a.RHCMhoraentradac) = f.RHDJdia	
		<!---=====================================----->
		
		<!---- El dia de la excepcion corresponda al dia de la marca---->
		and substring(convert(varchar, RHEJdomingo)+ convert(varchar, RHEJlunes)+
					convert(varchar, RHEJmartes)+ convert(varchar, RHEJmiercoles)+
					convert(varchar, RHEJjueves)+ convert(varchar, RHEJviernes)+
					convert(varchar, RHEJsabado), datepart(dw, a.RHCMfcapturada), 1) = '1'

		<!---- Dia de la jornada--->
		and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'

		<!---- Inconsistencia valida---->
		and a.RHJid = c.RHJid
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and c.RHJid = d.RHJid
		and d.RHCJcomportamiento = 'H' 
		and d.RHCJmomento = 'A' 

		and abs(datediff(mi, a.RHCMhoraentradac, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, f.RHJhoraini, 108))) >= d.RHCJperiodot

		<!----No se haya procesado ya esa excepcion---->
		and not exists (
						select 1
						from #IncidenciasMarca# x
						where x.RHPMid = a.RHPMid
						and x.RHCMid = a.RHCMid
						and x.CIid = b.CIid							
					)
		
	Order by b.RHEJhorainicio	
</cfquery>	
<!----======================= HORAS EXTRA DE SALIDA ========================---->
<cfquery datasource="#session.DSN#">		
	insert into #IncidenciasMarca# ( RHCMid ,
								RHPMid, 
								RDHMhorascalc , 
								RDHMhorasautor , 
								InicioExcepcion , 
								FinExcepcion,
								CIid,
								Indicador
							)

	select 	a.RHCMid, 
			a.RHPMid, 			
			(case when convert(varchar, a.RHCMhorasalidac, 108) >= convert(varchar, b.RHEJhorainicio, 108) and 
				convert(varchar, a.RHCMhoraentradac, 108) <= convert(varchar, b.RHEJhorainicio, 108) then
					datediff(mi, convert(varchar, b.RHEJhorainicio, 108), 
							(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
									convert(varchar, a.RHCMhorasalidac, 108) 
								else 
									convert(varchar, b.RHEJhorafinal, 108) end
							)
						   )/60
				else
					case when convert(varchar, a.RHCMhorasalidac, 108) >= convert(varchar, b.RHEJhorainicio, 108) and
					convert(varchar, a.RHCMhoraentradac, 108) >= convert(varchar, b.RHEJhorainicio, 108) then
						<!--- datediff(mi, convert(varchar, a.RHCMhoraentradac, 108), convert(varchar, a.RHCMhorasalidac, 108))/60 ---->
						datediff(mi, 
									(case when convert(varchar, f.RHJhorafin, 108) < convert(varchar, b.RHEJhorainicio, 108) then 
										convert(varchar, f.RHJhorafin, 108) 
									else 
										convert(varchar, b.RHEJhorainicio, 108) 
									end),
									(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
										convert(varchar, a.RHCMhorasalidac, 108) 
									else 
										convert(varchar, b.RHEJhorafinal, 108) 
									end)
								)/60.0
					else
						0.00
					end 
				end		
				),
			(case when convert(varchar, a.RHCMhorasalidac, 108) >= convert(varchar, b.RHEJhorainicio, 108) and 
				convert(varchar, a.RHCMhoraentradac, 108) <= convert(varchar, b.RHEJhorainicio, 108) then
					datediff(mi, convert(varchar, b.RHEJhorainicio, 108), 
							(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
									convert(varchar, a.RHCMhorasalidac, 108) 
								else 
									convert(varchar, b.RHEJhorafinal, 108) end
							)
						   )/60
				else
					case when convert(varchar, a.RHCMhorasalidac, 108) >= convert(varchar, b.RHEJhorainicio, 108) and
						convert(varchar, a.RHCMhoraentradac, 108) >= convert(varchar, b.RHEJhorainicio, 108) then
							<!---datediff(mi, convert(varchar, a.RHCMhoraentradac, 108), convert(varchar, a.RHCMhorasalidac, 108))/60---->
							datediff(mi, 
									(case when convert(varchar, f.RHJhorafin, 108) < convert(varchar, b.RHEJhorainicio, 108) then 
										convert(varchar, f.RHJhorafin, 108) 
									else 
										convert(varchar, b.RHEJhorainicio, 108) 
									end),
									(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
										convert(varchar, a.RHCMhorasalidac, 108) 
									else 
										convert(varchar, b.RHEJhorafinal, 108) 
									end)
								)/60.0
					else 
						0.00
					end 
				end		
				),
			b.RHEJhorainicio as InicioExcepcion,
			b.RHEJhorafinal as FinalExcepcion,
			b.CIid,
			'ES'

	from 	RHControlMarcas a, 			
			RHExcepcionesJornada b,
			RHDJornadas f,			
			RHJornadas c, 
			RHComportamientoJornada d, 
			CIncidentes e

	where a.RHPMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and a.RHCMid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
		and a.RHCMmismodia = 1

		<!---- La marca de salida este dentro de la excepcion---->
		and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHEJhorainicio, 108)

		and c.RHJid = f.RHJid
		and c.Ecodigo = f.Ecodigo
		<!---============ 30/03/2006 ============= ----->
		<!----and datepart(dw,a.RHCMfregistro) = f.RHDJdia	---->
		and datepart(dw,a.RHCMhoraentradac) = f.RHDJdia	
		<!---=====================================----->
	
		<!---- El dia de la semana de la marca corresponda al dia de la excepcion---->
		and substring(convert(varchar, b.RHEJdomingo)+
				convert(varchar, b.RHEJlunes)+
				convert(varchar, b.RHEJmartes)+
				convert(varchar, b.RHEJmiercoles)+
				convert(varchar, b.RHEJjueves)+
				convert(varchar, b.RHEJviernes)+
				convert(varchar, b.RHEJsabado), 
				datepart(dw, a.RHCMfcapturada), 1) = '1'
				
		and b.CIid = e.CIid
		and e.CInegativo = 1
		and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

		<!---- Dia sea de la jornada---->
		and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'

		<!---- Inconsistencia valida, es decir pasa el periodo establecido en el comportamiento de la jornada---->
		and a.RHJid = c.RHJid
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and c.RHJid = d.RHJid
		and d.RHCJcomportamiento = 'H' 
		and d.RHCJmomento = 'D' 

		and abs(datediff(mi, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, f.RHJhorafin, 108), a.RHCMhorasalidac)) >= d.RHCJperiodot
		
		<!---- No se haya procesado ya esa excepcion---->
		and not exists (
			select 1
			from #IncidenciasMarca# x
			where x.RHPMid = a.RHPMid
			and x.RHCMid = a.RHCMid
			and x.CIid = b.CIid		
			and x.InicioExcepcion = b.RHEJhorainicio
			and x.FinExcepcion = b.RHEJhorafinal			
		)
	
	Order by b.RHEJhorainicio	
</cfquery>
<!----================== HORAS DE REBAJA DE ENTRADA =================---->
<cfquery datasource="#session.DSN#">
	insert into #IncidenciasMarca# ( RHCMid ,
								RHPMid, 
								RDHMhorascalc , 
								RDHMhorasautor , 
								InicioExcepcion , 
								FinExcepcion,
								CIid,
								Indicador
							)

	select 	a.RHCMid, 
			a.RHPMid, 
			<!-----
			(case when convert(varchar, a.RHCMhoraentradac, 108) >= convert(varchar, b.RHEJhorainicio, 108) then
				datediff(mi, convert(varchar, b.RHEJhorainicio, 108), 
							(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
								convert(varchar, a.RHCMhoraentradac, 108) 
							else 
								convert(varchar, b.RHEJhorafinal, 108) end))/60
			else 
				00.00
			end),
			(case when convert(varchar, a.RHCMhoraentradac, 108) >= convert(varchar, b.RHEJhorainicio, 108) then
				datediff(mi, convert(varchar, b.RHEJhorainicio, 108), 
							(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
								convert(varchar, a.RHCMhoraentradac, 108) 
							else 
								convert(varchar, b.RHEJhorafinal, 108) end))/60
			else 
				00.00
			end),------>
			(datediff(mi, 
				(case when convert(varchar, f.RHJhoraini, 108) > convert(varchar, b.RHEJhorainicio, 108) then convert(varchar, f.RHJhoraini, 108) else convert(varchar, b.RHEJhorainicio, 108) end),
				(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHEJhorafinal, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHEJhorafinal, 108) end)
			)/60.0),
			(datediff(mi, 
				(case when convert(varchar, f.RHJhoraini, 108) > convert(varchar, b.RHEJhorainicio, 108) then convert(varchar, f.RHJhoraini, 108) else convert(varchar, b.RHEJhorainicio, 108) end),
				(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHEJhorafinal, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHEJhorafinal, 108) end)
			)/60.0),
			b.RHEJhorainicio,
			b.RHEJhorafinal,
			b.CIid,
			'RE'

	from 	RHControlMarcas a, 
			RHExcepcionesJornada b,
			RHDJornadas f,				
			RHJornadas c, 
			RHComportamientoJornada d, 
			CIncidentes e
			
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
		and a.RHCMmismodia = 1

		<!---- Excepciones donde la marca este contemplada---->
		and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHEJhorainicio, 108)
		and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHEJhorafinal, 108)

		and c.RHJid = f.RHJid
		and c.Ecodigo = f.Ecodigo
		<!---============ 30/03/2006 ============= ----->
		<!----and datepart(dw,a.RHCMfregistro) = f.RHDJdia	---->
		and datepart(dw,a.RHCMhoraentradac) = f.RHDJdia	
		<!---=====================================----->
		and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar,f.RHJhoraini, 108)
		
		<!---- El dia de la semana de la excepcion corresponda con el de la marca---->
		and substring(convert(varchar, b.RHEJdomingo)+
					convert(varchar, b.RHEJlunes)+
					convert(varchar, b.RHEJmartes)+
					convert(varchar, b.RHEJmiercoles)+
					convert(varchar, b.RHEJjueves)+
					convert(varchar, b.RHEJviernes)+
					convert(varchar, b.RHEJsabado), 
					datepart(dw, a.RHCMfcapturada), 1) = '1'

		and b.CIid = e.CIid
		and e.CInegativo = -1
		and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

		<!---- El dia sea de la jornada---->
		and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'

		<!---- Inconsistencia valida, es decir pasa el periodo establecido en el comportamiento de la jornada---->
		and a.RHJid = c.RHJid
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and c.RHJid = d.RHJid
		and d.RHCJcomportamiento = 'R' 
		and d.RHCJmomento = 'A' 
		
		and abs(datediff(mi, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, f.RHJhoraini, 108), a.RHCMhoraentradac)) >= d.RHCJperiodot

		<!---- No se haya procesado ya esa excepcion---->
		and not exists (
			select 1
			from #IncidenciasMarca# x
			where x.RHPMid = a.RHPMid
			and x.RHCMid = a.RHCMid
			and x.CIid = b.CIid		
			and x.InicioExcepcion = b.RHEJhorainicio
			and x.FinExcepcion = b.RHEJhorafinal
			and x.Indicador = 'RE' 			<!---- Veerifica que no se haya insertado una rebaja por entrada anteriormente----->
		)

	Order by b.RHEJhorainicio	
</cfquery>

<!---- ========================= HORAS DE REBAJA SALIDA ANTICIPADA ====================---->
<cfquery datasource="#session.DSN#">
	insert into #IncidenciasMarca# ( RHCMid ,
								RHPMid, 
								RDHMhorascalc , 
								RDHMhorasautor , 
								InicioExcepcion , 
								FinExcepcion,
								CIid,
								Indicador
							)

	select 	a.RHCMid,
			a.RHPMid,
			<!-----
			(case when convert(varchar, a.RHCMhorasalidac, 108) >= convert(varchar, b.RHEJhorainicio, 108) then
				datediff(mi, 
						(case when convert(varchar, b.RHEJhorainicio, 108) > convert(varchar, a.RHCMhorasalidac, 108) then
							convert(varchar, b.RHEJhorainicio, 108)
						else 
							convert(varchar, a.RHCMhorasalidac, 108)
						end),	
							/*convert(varchar, b.RHEJhorainicio, 108), */
							(case when convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHEJhorafinal, 108) then 
								convert(varchar, a.RHCMhorasalidac, 108) 
							else 
								convert(varchar, b.RHEJhorafinal, 108) 
							end)
						)/60											  
			else
				00.00
			end),
			(case when convert(varchar, a.RHCMhorasalidac, 108) >= convert(varchar, b.RHEJhorainicio, 108) then
				datediff(mi, 
						(case when convert(varchar, b.RHEJhorainicio, 108) > convert(varchar, a.RHCMhorasalidac, 108) then
							convert(varchar, b.RHEJhorainicio, 108)
						else 
							convert(varchar, a.RHCMhorasalidac, 108)
						end),	
							/*convert(varchar, b.RHEJhorainicio, 108), */
							(case when convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHEJhorafinal, 108) then 
								convert(varchar, a.RHCMhorasalidac, 108) 
							else 
								convert(varchar, b.RHEJhorafinal, 108) 
							end)
						)/60											  
			else
				00.00
			end),---->
			(case when convert(varchar, a.RHCMhorasalidac, 108) >= convert(varchar, b.RHEJhorainicio, 108) then
					datediff(mi, 						
						(case when convert(varchar, f.RHJhorafin, 108) < convert(varchar, a.RHCMhorasalidac, 108) then
							convert(varchar, f.RHJhorafin, 108)
						else 
							convert(varchar, a.RHCMhorasalidac, 108)
						end),
						
						(case when convert(varchar, f.RHJhorafin, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
							convert(varchar, f.RHJhorafin, 108) 
						else 
							convert(varchar, b.RHEJhorafinal, 108) 
						end)
					)/60											  
			else
				00.00
			end),
			(case when convert(varchar, a.RHCMhorasalidac, 108) >= convert(varchar, b.RHEJhorainicio, 108) then
					datediff(mi, 						
						(case when convert(varchar, f.RHJhorafin, 108) < convert(varchar, a.RHCMhorasalidac, 108) then
							convert(varchar, f.RHJhorafin, 108)
						else 
							convert(varchar, a.RHCMhorasalidac, 108)
						end),
						
						(case when convert(varchar, f.RHJhorafin, 108) < convert(varchar, b.RHEJhorafinal, 108) then 
							convert(varchar, f.RHJhorafin, 108) 
						else 
							convert(varchar, b.RHEJhorafinal, 108) 
						end)
					)/60											  
			else
				00.00
			end),
			b.RHEJhorainicio,
			b.RHEJhorafinal,
			b.CIid,
			'RS'
			
	from RHControlMarcas a
		
		inner join RHExcepcionesJornada b
			on convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHEJhorainicio, 108)
			and substring(convert(varchar, b.RHEJdomingo)+
				convert(varchar, b.RHEJlunes)+
				convert(varchar, b.RHEJmartes)+
				convert(varchar, b.RHEJmiercoles)+
				convert(varchar, b.RHEJjueves)+
				convert(varchar, b.RHEJviernes)+
				convert(varchar, b.RHEJsabado), 
				datepart(dw, a.RHCMfcapturada), 1) = '1'
					
		inner join RHJornadas c
				-- Inconsistencia valida
				on a.RHJid = c.RHJid	
				and c.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				-- El dia sea de la jornada
				and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
												
			inner join RHDJornadas f 	
				on c.RHJid = f.RHJid
				and  c.Ecodigo = f.Ecodigo
				and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, f.RHJhorafin, 108)
				and convert(varchar, b.RHEJhorainicio, 108) < convert(varchar, f.RHJhorafin, 108)
				<!---============ 30/03/2006 ============= ----->
				<!----and datepart(dw,a.RHCMfregistro) = f.RHDJdia	---->
				and datepart(dw,a.RHCMhoraentradac) = f.RHDJdia	
				<!---=====================================----->
								
		inner join RHComportamientoJornada d
			on c.RHJid = d.RHJid
			and d.RHCJcomportamiento = 'R' 
			and d.RHCJmomento = 'D'
			and abs(datediff(mi, a.RHCMhorasalidac, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, f.RHJhorafin, 108))) >= d.RHCJperiodot

		inner join CIncidentes e
			on b.CIid = e.CIid
				and e.CInegativo = -1
				and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
		
		<!---- No se haya procesado ya esa excepcion---->
		and not exists (
			select 1
			from #IncidenciasMarca# x
			where x.RHPMid = a.RHPMid
			and x.RHCMid = a.RHCMid
			and x.CIid = b.CIid		
			and x.InicioExcepcion = b.RHEJhorainicio
			and x.FinExcepcion = b.RHEJhorafinal	
			and x.Indicador = 'RS'	
		)


		and (
				(					
					b.RHEJhorainicio is null
				) 
			or
				(
						b.RHEJhorainicio is not null 
						and (convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHEJhorainicio, 108))
				)
			<!----  Trae excepcion donde el final sea mayor a la marca de salida ------>
			or (
						b.RHEJhorainicio is not null 
						and (convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHEJhorafinal, 108))
				)
			<!----------------->
			)
	Order by b.RHEJhorainicio	
</cfquery>

<!---- 	=====================================================================  
				INSERTA EN LA TABLA DE INCONSISTENCIAS 
		==================================================================== ----->
<cfquery datasource="#session.DSN#">	
	insert into RHDetalleIncidencias (RHCMid, 
									RHPMid, 
									CIid, 
									RHDMhorascalc, 
									RHDMhorasautor, 
									BMUsucodigo, 
									BMfecha, 
									BMfmod)
	select 	RHCMid,
			RHPMid,
			CIid,
			sum(RDHMhorascalc) as HorasCalculadas, 
			sum(RDHMhorasautor) as HorasAutor,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	from #IncidenciasMarca#
	where RDHMhorascalc > 0 
	group by RHPMid,RHCMid,CIid
</cfquery>


<!------ =========================== PROCESO ANTERIOR  =================================== 
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">
	-- Horas Extra de Entrada
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, a.RHCMhoraentradac, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108)) >= d.RHCJperiodot
	-- Chequea que no haya un detalle ya insertado
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
	
	-- Actualizacion de Horas Extra de Entrada
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhoraini, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
	    RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhoraini, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, c.RHJhoraini, 108)	
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, a.RHCMhoraentradac, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108)) >= d.RHCJperiodot
	
	-- Horas Extra de Salida
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'D' 
	and datediff(mi, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108), a.RHCMhorasalidac) >= d.RHCJperiodot
	-- Chequea que no haya un detalle ya insertado
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
	
	-- Actualizacion de Horas Extra de Salida
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, c.RHJhorafin, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
		RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, c.RHJhorafin, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'D'
	and datediff(mi, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108), a.RHCMhorasalidac) >= d.RHCJperiodot

	-- Horas de Rebaja Despues de Entrada
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108), a.RHCMhoraentradac) >= d.RHCJperiodot
	-- Chequea que no haya un detalle ya insertado
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)

	-- Actualizacion de Horas de Rebaja Despues de Entrada
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, c.RHJhoraini, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
	    RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, c.RHJhoraini, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108), a.RHCMhoraentradac) >= d.RHCJperiodot


	-- Horas de Rebaja Antes de Salida
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid
			, a.RHPMid
			, b.CIid
			, 0.00
			, 0.00
			, 1
			, getDate()
			, getDate()
	from RHControlMarcas a
		-- Busca si encuentra incidencias para insertar
		inner join RHIncidenciasHora b
			on convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108)
				and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
		
		inner join RHJornadas c
			on convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, c.RHJhorafin, 108)
				and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhorafin, 108)
				-- Chequea que sea un dia de la jornada
				and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
				-- Chequear que sea una inconsistencia valida
				and a.RHJid = c.RHJid	
				and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				
		inner join RHComportamientoJornada d
			on c.RHJid = d.RHJid
				and d.RHCJcomportamiento = 'R' 
				and d.RHCJmomento = 'D'
				and datediff(mi, a.RHCMhorasalidac, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108)) >= d.RHCJperiodot

		inner join CIncidentes e
			on b.CIid = e.CIid
				and e.CInegativo = -1
				and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

		-- Chequea que si existe una excepcion en la jornada, solo inserta si la hora de marca de salida es menor a la hora del inicio de la excepcion
		left outer join RHExcepcionesJornada f
			on f.RHJid = a.RHJid
				and substring(convert(varchar, f.RHEJdomingo)+convert(varchar, f.RHEJlunes)+convert(varchar, f.RHEJmartes)+convert(varchar, f.RHEJmiercoles)+convert(varchar, f.RHEJjueves)+convert(varchar, f.RHEJviernes)+convert(varchar, f.RHEJsabado), datepart(dw, a.RHCMfcapturada), 1) = '1'

		left outer join CIncidentes g
			on g.CIid = f.CIid
				and g.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	where 
		a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
		-- Chequea que no haya un detalle ya insertado
		and not exists (
			select 1
			from RHDetalleIncidencias x
			where x.RHPMid = a.RHPMid
			and x.RHCMid = a.RHCMid
			and x.CIid = b.CIid)
		and (
				(
					f.RHEJhorainicio is null
				) 
			or
				(
						f.RHEJhorainicio is not null 
					and 
						(convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, f.RHEJhorainicio, 108))
				)
			)

	
	-- Actualizacion de Horas de Rebaja Antes de Salida
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (
											datediff(mi, 
												(case when convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
												(case when convert(varchar, c.RHJhorafin, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhfinal, 108) end)
												)/60.0)
												-
													( coalesce(datediff(mi,
														convert(varchar, f.RHEJhorainicio, 108)
														,convert(varchar, c.RHJhorafin, 108)
													)/60.0,0)
										),
		RHDMhorasautor = RHDMhorasautor + ((datediff(mi, 
												(case when convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
												(case when convert(varchar, c.RHJhorafin, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhfinal, 108) end)
												)/60.0)
												-
													( coalesce(datediff(mi,
														convert(varchar, f.RHEJhorainicio, 108)
														,convert(varchar, c.RHJhorafin, 108)
													)/60.0,0)
												)											
											)
		from RHControlMarcas a
			-- Busca si encuentra incidencias para insertar
			inner join RHIncidenciasHora b
				on convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108)
					and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
			
			inner join RHJornadas c
				on convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, c.RHJhorafin, 108)
					and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhorafin, 108)
					-- Chequea que sea un dia de la jornada
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
					-- Chequear que sea una inconsistencia valida
					and a.RHJid = c.RHJid	
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					
			inner join RHComportamientoJornada d
				on c.RHJid = d.RHJid
					and d.RHCJcomportamiento = 'R' 
					and d.RHCJmomento = 'D'
					and datediff(mi, a.RHCMhorasalidac, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108)) >= d.RHCJperiodot
	
			inner join CIncidentes e
				on b.CIid = e.CIid
					and e.CInegativo = -1
					and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	
			-- Chequea que si existe una excepcion en la jornada, solo inserta si la hora de marca de salida es menor a la hora del inicio de la excepcion
			left outer join RHExcepcionesJornada f
				on f.RHJid = a.RHJid
					and substring(convert(varchar, f.RHEJdomingo)+convert(varchar, f.RHEJlunes)+convert(varchar, f.RHEJmartes)+convert(varchar, f.RHEJmiercoles)+convert(varchar, f.RHEJjueves)+convert(varchar, f.RHEJviernes)+convert(varchar, f.RHEJsabado), datepart(dw, a.RHCMfcapturada), 1) = '1'
	
			left outer join CIncidentes g
				on g.CIid = f.CIid
					and g.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		where 
			a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
			and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
			and (
					(
						f.RHEJhorainicio is null
					) 
				or
					(
							f.RHEJhorainicio is not null 
						and 
							(convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, f.RHEJhorainicio, 108))
					)
				)
</cfquery>
======================== FIN DE PROCESO ANTERIOR ------->

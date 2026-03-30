<cfif isdefined('form.ckDPen') and isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
	<cfquery name="rsPath" datasource="#session.DSN#">
		select CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
	</cfquery>
</cfif>

<cfquery name="rsProc" datasource="#session.DSN#">
	<cfif not isdefined('form.ckDPen')>
		Select 
			(select sum(di.RHDMhorasautor) 
			from RHDetalleIncidencias di
			where di.CIid=im.CIid
				and di.RHDMid=im.RHDMid
				and di.RHCMid=im.RHCMid
				and di.RHPMid=im.RHPMid) as sumaHorasAutor
			, case im.RetenerPago
				when 0 then 'SI'
				when 1 then 'NO'
			end RetenerPago
			, (	Select j.RHJcodigo 
				from RHJornadas j
				where j.RHJid = (	select min(p.RHJid) 
								from RHPlanificador p
								where p.DEid = im.DEid
									and cm.RHCMfcapturada between 
										p.RHPJfinicio and p.RHPJffinal
							)
			) as JornadaPlanif
			,(	Select j.RHJcodigo 
				from RHJornadas j
				where j.RHJid = lt.RHJid
			) as JornadaLineaT
			, im.RHCMid
			, rhp.CFid
			, cf.CFdescripcion 
			, cf.CFcodigo	
			, im.CIid
			, ci.CIcodigo
			, CIdescripcion
			, im.DEid
			, de.DEidentificacion
			,rtrim({fn concat({fn concat({fn concat({ fn concat(de.DEnombre, ' ') },rtrim(de.DEapellido1))}, ' ')},rtrim(de.DEapellido2)) })  as NombreEmpleado 
		
		from IncidenciasMarcas im
			inner join CIncidentes ci
				on ci.CIid=im.CIid
					and ci.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		
			inner join DatosEmpleado de
				on de.DEid=im.DEid
					and ci.Ecodigo=de.Ecodigo
		
			inner join LineaTiempo lt 
				on lt.Ecodigo=de.Ecodigo
					and lt.DEid = de.DEid 
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta 
		
			inner join RHPlazas rhp
				on rhp.RHPid = lt.RHPid 
		
			inner join CFuncional cf
				on cf.CFid=rhp.CFid
		
			inner join RHControlMarcas cm
				on cm.RHCMid=im.RHCMid
		where 1=1
			<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
				and im.DEid=<cfqueryparam cfsqltype="cf_sql_integer"  value="#form.DEid#">
			</cfif>		
			<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
				and rhp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
			</cfif>		
			<cfif isdefined("form.tipoHora") and len(trim(form.tipoHora)) NEQ 0 and form.tipoHora NEQ '-1'>
				and im.RetenerPago = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.tipoHora#">
			</cfif>	
			<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) NEQ 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) NEQ 0>
				and cm.RHCMfcapturada between <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LSDateFormat(form.fdesde,'YYYYMMDD')#">
				and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(form.fhasta,'YYYYMMDD')#">
			</cfif>
			order by cf.CFdescripcion,im.DEid
	<cfelse>
		Select 
			(select sum(di.RHDMhorasautor) 
			from RHDetalleIncidencias di
			where di.CIid=im.CIid
				and di.RHDMid=im.RHDMid
				and di.RHCMid=im.RHCMid
				and di.RHPMid=im.RHPMid) as sumaHorasAutor
			, case im.RetenerPago
				when 0 then 'SI'
				when 1 then 'NO'
			end RetenerPago
			, (	Select j.RHJcodigo 
				from RHJornadas j
				where j.RHJid = (	select min(p.RHJid) 
								from RHPlanificador p
								where p.DEid = im.DEid
									and cm.RHCMfcapturada between 
										p.RHPJfinicio and p.RHPJffinal
							)
			) as JornadaPlanif
			,(	Select j.RHJcodigo 
				from RHJornadas j
				where j.RHJid = lt.RHJid
			) as JornadaLineaT
			, im.RHCMid
			, rhp.CFid
			, cf.CFdescripcion 
			, cf.CFcodigo	
			, im.CIid
			, ci.CIcodigo
			, CIdescripcion
			, im.DEid
			, de.DEidentificacion
			,rtrim({fn concat({fn concat({fn concat({ fn concat(de.DEnombre, ' ') },de.DEapellido1)}, ' ')},de.DEapellido2) }) as NombreEmpleado 
		
		from IncidenciasMarcas im
			inner join CIncidentes ci
				on ci.CIid=im.CIid
					and ci.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		
			inner join DatosEmpleado de
				on de.DEid=im.DEid
					and ci.Ecodigo=de.Ecodigo
		
			inner join LineaTiempo lt 
				on lt.Ecodigo=de.Ecodigo
					and lt.DEid = de.DEid 
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta 
		
			inner join RHPlazas rhp
				on rhp.RHPid = lt.RHPid 
		
			inner join CFuncional cf
				on cf.CFid=rhp.CFid
		
			inner join RHControlMarcas cm
				on cm.RHCMid=im.RHCMid
		where 1=1
			<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
				and im.DEid=<cfqueryparam cfsqltype="cf_sql_integer"  value="#form.DEid#">
			</cfif>		
			<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
				and rhp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
			</cfif>		
			<cfif isdefined("form.tipoHora") and len(trim(form.tipoHora)) NEQ 0 and form.tipoHora NEQ '-1'>
				and im.RetenerPago = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.tipoHora#">
			</cfif>	
			<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) NEQ 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) NEQ 0>
				and cm.RHCMfcapturada between <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LSDateFormat(form.fdesde,'YYYYMMDD')#">
				and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(form.fhasta,'YYYYMMDD')#">
			</cfif>
			
UNION

		Select 
			(select sum(di.RHDMhorasautor) 
			from RHDetalleIncidencias di
			where di.CIid=im.CIid
				and di.RHDMid=im.RHDMid
				and di.RHCMid=im.RHCMid
				and di.RHPMid=im.RHPMid) as sumaHorasAutor
			, case im.RetenerPago
				when 0 then 'SI'
				when 1 then 'NO'
			end RetenerPago
			, (	Select j.RHJcodigo 
				from RHJornadas j
				where j.RHJid = (	select min(p.RHJid) 
								from RHPlanificador p
								where p.DEid = im.DEid
									and cm.RHCMfcapturada between 
										p.RHPJfinicio and p.RHPJffinal
							)
			) as JornadaPlanif
			,(	Select j.RHJcodigo 
				from RHJornadas j
				where j.RHJid = lt.RHJid
			) as JornadaLineaT
			, im.RHCMid
			, rhp.CFid
			, cf.CFdescripcion 
			, cf.CFcodigo			
			, im.CIid
			, ci.CIcodigo
			, CIdescripcion
			, im.DEid
			, de.DEidentificacion
			,rtrim({fn concat({fn concat({fn concat({ fn concat(de.DEnombre, ' ') },de.DEapellido1)}, ' ')},de.DEapellido2) })  as NombreEmpleado 
		
		from IncidenciasMarcas im
			inner join CIncidentes ci
				on ci.CIid=im.CIid
					and ci.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">
		
			inner join DatosEmpleado de
				on de.DEid=im.DEid
					and ci.Ecodigo=de.Ecodigo
		
			inner join LineaTiempo lt 
				on lt.Ecodigo=de.Ecodigo
					and lt.DEid = de.DEid 
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta 
		
			inner join RHPlazas rhp
				on rhp.RHPid = lt.RHPid 
		
			inner join CFuncional cf
				on cf.CFid=rhp.CFid
		
			inner join RHControlMarcas cm
				on cm.RHCMid=im.RHCMid
		where 1=1
			<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
				and im.DEid=<cfqueryparam cfsqltype="cf_sql_integer"  value="#form.DEid#">
			</cfif>		
			<cfif isdefined("form.id_centro") and len(trim(form.id_centro)) NEQ 0>
				and rhp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.id_centro#">
			</cfif>		
			<cfif isdefined("form.tipoHora") and len(trim(form.tipoHora)) NEQ 0 and form.tipoHora NEQ '-1'>
				and im.RetenerPago = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.tipoHora#">
			</cfif>	
			<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) NEQ 0 and isdefined("form.fhasta") and len(trim(form.fhasta)) NEQ 0>
				and cm.RHCMfcapturada between <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LSDateFormat(form.fdesde,'YYYYMMDD')#">
				and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(form.fhasta,'YYYYMMDD')#">
			</cfif>
 			<cfif isdefined('rsPath') and rsPath.recordCount GT 0 and rsPath.CFpath NEQ ''>
				and cf.CFpath like '#rsPath.CFpath#/%'
			</cfif>				
		order by cf.CFdescripcion,im.DEid
	</cfif>
</cfquery>
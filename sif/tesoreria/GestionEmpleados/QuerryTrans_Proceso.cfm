
<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
<cfset LvarCortes = "">
	
select 		distinct
			tp.CCHTid as idTransaccion,
			tp.CCHTrelacionada,
			tp.CCHTtipo as tipo,
			ga.GEAnumero as numero,
			ga.GEAfechaSolicitud as Fecha,
			ga.GEAtotalOri as total,
			ga.GEAmsgRechazo as msRechazo,
			
			<!---Solicitante--->
			(
				select us.Usulogin
				from Usuario us
				where us.Usucodigo=ga.UsucodigoSolicitud
			) as usuario,
		<!--- Estado--->
			case ga.GEAestado
				when  0 then 'En Preparación'
				when  1 then 'En Aprobación'
				when  2 then 'Aprobada'
				when  3 then 'Rechazada'
				when  4 then 'Pagada'
				when  5 then 'Liquidada' 
				else 'Estado desconocido'
				end as estado,
				
		<!---Centro Funcional--->
			(select <cf_dbfunction name="concat" args="o.Oficodigo+':'+cf.CFcodigo" delimiters="+">
			from CFuncional cf 
			inner join Oficinas o 
			on o.Ecodigo = cf.Ecodigo 
			and o.Ocodigo = cf.Ocodigo 
			where cf.CFid = ga.CFid) as CFcodigo,
			
			<!---Empleado--->
			(select <cf_dbfunction name="concat" args="Em.DEapellido1+' '+Em.DEapellido2+', '+Em.DEnombre" delimiters="+">
				from DatosEmpleado Em
				inner join TESbeneficiario te
				on Em.DEid=te.DEid 
				where ga.TESBid=te.TESBid  
			) as Empleado,	
			
			<!---Monedas--->
			(
				select Mo.Miso4217
				from Monedas Mo
				where ga.Mcodigo=Mo.Mcodigo
			)as Moneda
			
	from  CCHTransaccionesProceso tp
		inner join GEanticipo ga
			on tp.CCHTrelacionada= ga.GEAid
	where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and tp.CCHTtipo='ANTICIPO'
	and tp.CCHTrelacionada is not null
<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
	and ga.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
</cfif>	
<cfif isdefined('form.UsucodigoSP_F') and len(trim(form.UsucodigoSP_F)) and form.UsucodigoSP_F NEQ "">
	and ga.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
</cfif>			

<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
	and ga.TESBid=
		(select TESBid
		from TESbeneficiario 
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
</cfif>	
<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
	and ga.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
</cfif>	
<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
	and ga.GEAnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numAnti#">
</cfif>
<cfif isdefined("form.chkCancelados")>
	
	and ga.GEAestado in (3)

<cfelse>
	and ga.GEAestado in(1)
</cfif>
<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
	and ga.GEAfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_F#">
</cfif>	
<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
	and ga.GEAfechaPagar >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_I#">
</cfif>

	
union all
	
	select distinct
			tp.CCHTid as IDTransaccion,
			tp.CCHTrelacionada,
			tp.CCHTtipo as tipo,
			gl.GELnumero as numero,
			gl.GELfecha as Fecha,
			gl.GELtotalGastos as total,
			gl.GELmsgRechazo as msRechazo,
			
			<!---Solicitante--->
			(
				select us.Usulogin
				from Usuario us
				where us.Usucodigo=gl.UsucodigoSolicitud
			) as usuario,
			
		<!---	Estados--->
			case gl.GELestado
				when  0 then 'En Preparación'
				when  1 then 'En Aprobación'
				when  2 then 'Aprobada'
				when  3 then 'Rechazada'
				when  4 then 'Finalizada'
				else 'Estado desconocido'
				end as estado,
			
			<!---Centro Funcional--->
			(select <cf_dbfunction name="concat" args="o.Oficodigo+':'+cf.CFcodigo" delimiters="+">
			from CFuncional cf 
			inner join Oficinas o 
			on o.Ecodigo = cf.Ecodigo 
			and o.Ocodigo = cf.Ocodigo 
			where cf.CFid = gl.CFid) as CFcodigo,
			
			<!---Empleado--->
			(select <cf_dbfunction name="concat" args="Em.DEapellido1+' '+Em.DEapellido2+', '+Em.DEnombre" delimiters="+">
				from DatosEmpleado Em
				inner join TESbeneficiario te
				on Em.DEid=te.DEid  
				where gl.TESBid=te.TESBid
			) as Empleado,	
					
			<!---Moneda--->
			(
				select Mo.Miso4217
				from Monedas Mo
				where gl.Mcodigo=Mo.Mcodigo
			)as Moneda
			
	from  CCHTransaccionesProceso tp
		inner join GEliquidacion gl
			on tp.CCHTrelacionada= gl.GELid
	where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and tp.CCHTtipo='GASTO'
	and tp.CCHTrelacionada is not null
<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
	and gl.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
</cfif>	
<cfif isdefined('form.UsucodigoSP_F') and len(trim(form.UsucodigoSP_F)) and form.UsucodigoSP_F NEQ "">
	and gl.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
</cfif>			

<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
	and gl.TESBid=
		(select TESBid
		from TESbeneficiario 
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
</cfif>	
<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
	and gl.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
</cfif>	
<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
	and gl.GELnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numAnti#">
</cfif>
<cfif isdefined("form.chkCancelados")>
	and gl.GELestado in (3,13,23,103)
	and gl.GELidDuplicado is null
<cfelse>
	and gl.GELestado in(1)
</cfif>
<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
	and gl.GELfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_F#">
</cfif>	
<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
	and gl.GELfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_I#">
</cfif>	

union all
	select 	distinct
			tp.CCHTid as idTransaccion,
			tp.CCHTrelacionada,
			tp.CCHTtipo as tipo,
			ga.GECnumero as numero,
			ga.GECfechaSolicitud as Fecha,
			(
				select sum(round(GEAtotalOri*GEAmanual,2))
				  from GEanticipo a
				 where GECid=ga.GECid
				   and GEAestado = 1
			) as total,
			'N/A' as msRechazo,
			
			<!---Solicitante--->
			(
				select us.Usulogin
				from Usuario us
				where us.Usucodigo=ga.UsucodigoSolicitud
			) as usuario,
		<!--- Estado--->
			case ga.GECestado
				when  1 then 'En Proceso'
				when  2 then 'Activa'
				when  3 then 'Rechazada'
				when  4 then 'Terminada'
				else 'Estado desconocido'
				end as estado,
				
		<!---Centro Funcional--->
			(select <cf_dbfunction name="concat" args="o.Oficodigo+':'+cf.CFcodigo" delimiters="+">
			from CFuncional cf 
			inner join Oficinas o 
			on o.Ecodigo = cf.Ecodigo 
			and o.Ocodigo = cf.Ocodigo 
			where cf.CFid = ga.CFid) as CFcodigo,
			
			<!---Empleado--->
			(select <cf_dbfunction name="concat" args="Em.DEapellido1+' '+Em.DEapellido2+', '+Em.DEnombre" delimiters="+">
				from DatosEmpleado Em
				inner join TESbeneficiario te
				on Em.DEid=te.DEid 
				where ga.TESBid=te.TESBid  
			) as Empleado,	
			
			<!---Monedas--->
			'LOCAL' as Moneda
			
	from  CCHTransaccionesProceso tp
		inner join GEcomision ga
			on tp.CCHTrelacionada= ga.GECid
	where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and tp.CCHTtipo='COMISION'
	and tp.CCHTrelacionada is not null
<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
	and ga.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
</cfif>	
<cfif isdefined('form.UsucodigoSP_F') and len(trim(form.UsucodigoSP_F)) and form.UsucodigoSP_F NEQ "">
	and ga.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
</cfif>			

<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
	and ga.TESBid=
		(select TESBid
		from TESbeneficiario 
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
</cfif>	
<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
	and ga.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
</cfif>	
<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
	and ga.GECnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numAnti#">
</cfif>
<cfif isdefined("form.chkCancelados")>
	and ga.GECestado = 3
	and 1 = 2
<cfelse>
	and ga.GECestado in (1,2)	<!--- En Proceso o Activa --->
	and (
		select count(1)
		  from GEanticipo a
		 where GECid=ga.GECid
		   and GEAestado = 1
		) > 0
</cfif>
<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
	and ga.GECfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_F#">
</cfif>	
<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
	and ga.GECfechaPagar >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_I#">
</cfif>
order by Fecha
 
</cfquery>



		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				Cortes="#LvarCortes#"
				desplegar="tipo,numero,CFcodigo,Empleado,fecha,Moneda,total,estado,usuario"
				etiquetas="Tipo Transación,Num.<BR>Transacción,Ofi:Centro<BR>Funcional,Nombre Empleado,Fecha Pago<BR>Solicitada, Moneda, Total Pago<BR>Solicitado, Estado, Solicitante,"
				formatos="S,I,S,S,D,S,M,S,S"
				align="left,left,left,left,center,right,right,left,left"
				ira="#Attributes.IrA#"
				form_method="post"
				showEmptyListMsg="yes"
				keys="CCHTrelacionada"	
				MaxRows="15"
				navegacion="#navegacion#"
				checkboxes="N"
				botones="#Attributes.Botones#"
				filtro_nuevo="#isdefined("form.btnFiltrar")#"
				PageIndex="4"
			/>		
			
			


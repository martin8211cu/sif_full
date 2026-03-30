<cfquery name="rsCustodio" datasource="#session.dsn#">
	select llave as DEid
	  from UsuarioReferencia
	 where Usucodigo= #session.Usucodigo#
	   and Ecodigo	= #session.EcodigoSDC#
	   and STabla	= 'DatosEmpleado'
</cfquery>
<cfif rsCustodio.DEid EQ "">
	<cfthrow message="El Usuario '#session.usulogin#' no está registrado como Empleado">
</cfif>

<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
	select
		1 as tipoT,
		<cf_dbfunction name="concat" args="
			case when ch.CCHtipo = 1 then '&nbsp;&nbsp;Caja Chica: ' else '&nbsp;&nbsp;Caja Especial: ' end,
			ch.CCHcodigo"> as Caja,
		tp.CCHTCfecha,
	
		tp.CCHTid as idTransaccion,
		tp.CCHTCrelacionada,
		tp.CCHTtipo as tipo,
		tp.CCHTCid,
		tp.CCHTCnumero,
		tp.CCHTCestado,
		tp.CCHTCconfirmador,
		ga.GEAtotalOri as anticipoT,
		<cf_jdbcquery_param cfsqltype="cf_sql_money" value="0.00"> as gastoT,
		<cf_jdbcquery_param cfsqltype="cf_sql_money" value="0.00"> as devolucionT,
		
		ga.GEAnumero as numero,
		ga.GEAid as id,
		ga.GEAfechaSolicitud as Fecha,
		ga.GEAtotalOri as total,
		ga.GEAmsgRechazo as msRechazo,
		
		<cf_jdbcquery_param cfsqltype="cf_sql_money" value="0.00"> as neto,
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
			
	from  CCHTransaccionesCProceso tp
		inner join GEanticipo ga
			 on ga.GEAid = tp.CCHTCrelacionada
		inner join CCHica ch
			  on ch.CCHid = ga.CCHid
			 <!---  Filtrar por UsuarioReferencia con #session.Usucodigo#--->
			 and ch.CCHresponsable=#rsCustodio.DEid#
		where tp.Ecodigo=#session.Ecodigo#
				and tp.CCHTtipo='ANTICIPO'
				and tp.CCHTCrelacionada is not null
			<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
				and ga.CFid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
			</cfif>	
			<cfif isdefined('form.UsucodigoSP_F') and len(trim(form.UsucodigoSP_F)) and form.UsucodigoSP_F NEQ "">
				and ga.UsucodigoSolicitud=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
			</cfif>			
			
			<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
				and ga.TESBid=
					(select TESBid
					from TESbeneficiario 
					where DEid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.DEid#">)
			</cfif>	
			<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
				and ga.Mcodigo=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
			</cfif>	
			<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
				and ga.GEAnumero = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.numAnti#">
			</cfif>
			
			<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
				and ga.GEAfechaPagar <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_F#">
			</cfif>	
			<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
				and ga.GEAfechaPagar >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_I#">
			</cfif>
			and tp.CCHTCestado in ('POR CONFIRMAR')
union all
		select 
			2 as tipoT,
			<cf_dbfunction name="concat" args="
				case when ch.CCHtipo = 1 then '&nbsp;&nbsp;Caja Chica: ' else '&nbsp;&nbsp;Caja Especial: ' end,
				ch.CCHcodigo"> as Caja,
			tp.CCHTCfecha,

			tp.CCHTid as IDTransaccion,
			tp.CCHTCrelacionada,
			tp.CCHTtipo as tipo,
			
			tp.CCHTCid,
			tp.CCHTCnumero,
			tp.CCHTCestado,
			tp.CCHTCconfirmador,
			gl.GELtotalAnticipos as anticipoT,
			gl.GELtotalGastos as gastoT,
			gl.GELtotalDevoluciones as devolucionT,
			
			gl.GELnumero as numero,
			gl.GELid as id,
			gl.GELfecha as Fecha,
			gl.GELtotalGastos as total,
			gl.GELmsgRechazo as msRechazo,
			gl.GELtotalAnticipos - (gl.GELtotalGastos + coalesce(gl.GELtotalDevoluciones,0)) as neto, 
			
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
			
	from  CCHTransaccionesCProceso tp
		inner join GEliquidacion gl
			 on tp.CCHTCrelacionada= gl.GELid
		inner join CCHica ch
			 on ch.CCHid = gl.CCHid
			 <!---  Filtrar por UsuarioReferencia con #session.Usucodigo#--->
             and ch.CCHresponsable=#rsCustodio.DEid#
		where tp.Ecodigo=#session.Ecodigo#
			and tp.CCHTtipo='GASTOS'
			and tp.CCHTCrelacionada is not null
		<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
			and gl.CFid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
		</cfif>	
		<cfif isdefined('form.UsucodigoSP_F') and len(trim(form.UsucodigoSP_F)) and form.UsucodigoSP_F NEQ "">
			and gl.UsucodigoSolicitud=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
		</cfif>			
		
		<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
			and gl.TESBid=
				(select TESBid
				from TESbeneficiario 
				where DEid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.DEid#">)
		</cfif>	
		<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
			and gl.Mcodigo=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
		</cfif>	
		<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
			and gl.GELnumero = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.numAnti#">
		</cfif>
		
		<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
			and gl.GELfecha <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_F#">
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
			and gl.GELfecha >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_I#">
		</cfif>	
		and tp.CCHTCestado in ('POR CONFIRMAR')
		order by 1,2
	</cfquery>

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				Cortes="tipo,caja"
				desplegar="tipo,numero,CFcodigo,Empleado,Fecha,Moneda,anticipoT,gastoT,devolucionT, neto,usuario"
				etiquetas="Tipo Transación,Num.<BR>Transacción,Ofi:Centro<BR>Funcional,Nombre Empleado,Fecha Recepci&oacute;n Custodio, Moneda, Anticipos, Gastos, Devoluci&oacute;n, Neto, Aprobador "
				formatos="S,I,S,S,D,S,M,M,M,M,S" 
				align="left,left,left,left,left,left,right,right,right,right,left"
				ira="#Attributes.IrA#"
				form_method="post"
				showEmptyListMsg="yes"
				keys="CCHTCrelacionada"	
				MaxRows="15"
				navegacion="#navegacion#"
				filtro_nuevo="#isdefined("form.btnFiltrar")#"
			/>		

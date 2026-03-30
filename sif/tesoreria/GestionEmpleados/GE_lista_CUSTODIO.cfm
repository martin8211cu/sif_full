<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default ="Tipo" returnvariable="LB_Tipo" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumTransaccion" default ="N&uacute;m. Transacci&oacute;n" returnvariable="LB_NumTransaccion" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_OfiCentroFuncional" default ="Ofi:Centro Funcional" returnvariable="LB_OfiCentroFuncional" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NombreEmpleado" default ="Nombre Empleado" returnvariable="LB_NombreEmpleado" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaRecepcionCustodio" default ="Fecha Recepci&oacute;n Custodio" returnvariable="LB_FechaRecepcionCustodio" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default ="Moneda" returnvariable="LB_Moneda" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Anticipos" default ="Anticipos" returnvariable="LB_Anticipos" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Gastos" default ="Gastos" returnvariable="LB_Gastos" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Devolucion" default ="Devoluci&oacute;n" returnvariable="LB_Devolucion" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Neto" default ="Neto" returnvariable="LB_Neto" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Aprobador" default ="Aprobador" returnvariable="LB_Aprobador" xmlfile = "GE_lista_CUSTODIO.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ElUsuario" default ="El Usuario" returnvariable="MSG_ElUsuario" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoEstaRegistradoComoEmpleado" default ="no ha sido registrado como Empleado de la Empresa" returnvariable="MSG_NoEstaRegistradoComoEmpleado" xmlfile = "GE_lista.xml">


<cfquery name="rsCustodio" datasource="#session.dsn#">
	select llave as DEid
	  from UsuarioReferencia
	 where Usucodigo= #session.Usucodigo#
	   and Ecodigo	= #session.EcodigoSDC#
	   and STabla	= 'DatosEmpleado'
</cfquery>
<cfif rsCustodio.DEid EQ "">
	<cfthrow message="#MSG_ElUsuario# '#session.usulogin#' #MSG_NoEstaRegistradoComoEmpleado#">
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
				and ga.GEAfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_F#">
			</cfif>	
			<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
				and ga.GEAfechaPagar >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_I#">
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
			and gl.GELfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_F#">
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
			and gl.GELfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_I#">
		</cfif>	
		and tp.CCHTCestado in ('POR CONFIRMAR')
		order by 1,2
	</cfquery>

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				Cortes="tipo,caja"
				desplegar="tipo,numero,CFcodigo,Empleado,Fecha,Moneda,anticipoT,gastoT,devolucionT, neto,usuario"
				etiquetas="#LB_Tipo#,#LB_NumTransaccion#,#LB_OfiCentroFuncional#,#LB_NombreEmpleado#,, #LB_Moneda#, #LB_Anticipos#, #LB_Gastos#, #LB_Devolucion#, #LB_Neto#, #LB_Aprobador#"
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

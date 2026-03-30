<!--- Permite filtrar la Liquidaciones según el estado de cada liquidación. Además filtra por empleado, por fecha y por centro funcional.
 --->
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
	select 
		GELid,
	<cfif LvarSAporComision>
		ant.GECid as GECid_comision,
		'COMISION ' #LvarCNCT# <cf_dbfunction name="to_char" args="cc.GECnumero"> #LvarCNCT# ': '  #LvarCNCT# cc.GECdescripcion 
		as COMISION,
	<cfelse>
		0  as GECid_comision,
	</cfif>
		case when (select CCHtipo from CCHica where CCHid = ant.CCHid) = 1 then 'CCH' else 'TES' end as tipo,
		GELdescripcion,
		GELfecha,
		GELmsgRechazo, 
		<!---Centro Funcional--->
		GELnumero,
		( 
			select rtrim(o.Oficodigo) #LvarCNCT# ':' #LvarCNCT# cf.CFcodigo
			from CFuncional cf 
			inner join Oficinas o on o.Ecodigo = cf.Ecodigo and o.Ocodigo = cf.Ocodigo 
			where cf.CFid = ant.CFid
		) as CFcodigo,
		<!---Empleado--->
		(	
			select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2
			from DatosEmpleado Em,TESbeneficiario te
			where ant.TESBid=te.TESBid and   Em.DEid=te.DEid  
		) as Empleado,			
		<!---Moneda--->
		(
			select Mo.Miso4217
			from Monedas Mo
			where ant.Mcodigo=Mo.Mcodigo
		)as Moneda,
		GELtotalGastos,

		<!---Estado--->
		case GELestado
			when  0 then 'En Preparación'
			when  1 then 'En Aprobación'
			when  2 then 'Aprobada'
			when  3 then 'Rechazada'
			when  4 then 'Finalizada'
			when  5 then 'Por Reintegrar'
			else 'Estado desconocido'
			end as estado,
		<!---Solicitante--->
		(
			select us.Usulogin
			from Usuario us
			where us.Usucodigo=ant.UsucodigoSolicitud
		) as usuario,
		0 as nuevo
		from GEliquidacion ant
		<!---Filtros--->
	<cfif LvarSAporComision>
			inner join GEcomision cc on cc.GECid = ant.GECid
	</cfif>
		where ant.GELtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
		and ant.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        
	<cfif #Attributes.PorSolicitante#>
    	and ant.UsucodigoSolicitud=#session.Usucodigo#
    </cfif>    
    
	<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
		and ant.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
	</cfif>	
	<cfif isdefined('form.UsucodigoSP_F') and len(trim(form.UsucodigoSP_F)) and form.UsucodigoSP_F NEQ "">
		and ant.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
	</cfif>			
	
	<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
		and ant.TESBid=
		(select TESBid
				from TESbeneficiario 
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
	</cfif>	
	<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
		and ant.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
	</cfif>	
	<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
		and GELnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numAnti#">
	</cfif>
	<cfif isdefined('form.numComision') and len(trim(form.numComision))>
		and cc.GECnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numComision#">
	</cfif>
	<cfif isdefined("form.chkCancelados")>
		and ant.GELestado in (3,13,23,103)
		and GELidDuplicado is null
	<cfelse>
		and GELestado in(#Attributes.Estado#)
	</cfif>
	<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
		and ant.GELfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_F)#">
	</cfif>	
	<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
		and ant.GELfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_I)#">
	</cfif>	
		and ant.GECid is <cfif LvarSAporComision>not </cfif>null
	<cfif LvarSAporComision>
	UNION
	select 
		0 as GELid,
		
		GECid as GECid_comision,
		'COMISION ' #LvarCNCT# <cf_dbfunction name="to_char" args="cc.GECnumero"> #LvarCNCT# ': '  #LvarCNCT# cc.GECdescripcion as COMISION,
		'NEW' as tipo,
		null as GELdescripcion,

		cc.GECfechaPagar as GELfecha,
		<!---Mensaje de rechazo--->
		null as GELmsgRechazo,
		<!---Centro Funcional--->
		0 as GELnumero,
		( 
			select rtrim(o.Oficodigo) #LvarCNCT# ':' #LvarCNCT# cf.CFcodigo
			from CFuncional cf 
			inner join Oficinas o on o.Ecodigo = cf.Ecodigo and o.Ocodigo = cf.Ocodigo 
			where cf.CFid = cc.CFid
		) as CFcodigo,
		<!---Empleado--->
		(
			select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2

			from DatosEmpleado Em,TESbeneficiario te
			where cc.TESBid=te.TESBid and   Em.DEid=te.DEid  
		) as Empleado,			
		<!---Moneda--->
		null as Moneda,
		null as GELtotalGastos,
		<!---Estado--->
		'Sin Liquidaciones' as estado,
		<!---Solicitante--->
		(
			select us.Usulogin
			from Usuario us
			where us.Usucodigo=cc.UsucodigoSolicitud
		) as usuario,
		1 as nuevo
	from GEcomision cc 
	where (select count(1) from GEliquidacion where GECid=cc.GECid and GELestado in (#Attributes.Estado#))=0
        and GECestado not in (3,4)
        <cfif #Attributes.PorSolicitante#>
            and ant.UsucodigoSolicitud=#session.Usucodigo#
        </cfif>    

		<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
			and cc.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
		</cfif>	
		<cfif isdefined('form.UsucodigoSP_F') and len(trim(form.UsucodigoSP_F)) and form.UsucodigoSP_F NEQ "">
			and cc.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
		</cfif>			
		
		<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
			and cc.TESBid=
				(select TESBid
					from TESbeneficiario 
					where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
		</cfif>	
		<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
			and 1=2
		</cfif>	
		<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
			and 1=2
		</cfif>
		<cfif isdefined('form.numComision') and len(trim(form.numComision))>
			and cc.GECnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numComision#">
		</cfif>
		<cfif isdefined("form.chkCancelados")>
			and 1=2
		</cfif>
		<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
			and cc.GECfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_F)#">
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
			and cc.GECfechaPagar >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_I)#">
		</cfif>	
	</cfif>
		order by 2, GELnumero
</cfquery>

<cfset LvarCortes = "">
<cfif LvarSAporComision>
	<cfset LvarCortes = "COMISION">
</cfif>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		Cortes="#LvarCortes#"
		desplegar="GELnumero,Tipo,CFcodigo,Empleado,GELfecha,Moneda,GELtotalGastos,estado,usuario, GELmsgRechazo"
		etiquetas="Num.<BR>Liquidación,Tipo,Ofi:Centro<BR>Funcional,Nombre Empleado,Fecha, Moneda,   Gastos, Estado, Solicitante, #LvarMSGrechazo#"
		formatos="I,S,S,S,D,S,M,S,S,S"
		align="left,left,left,left,center,center,left,left,left,left"
		ira="#Attributes.IrA#"
		form_method="post"
		showEmptyListMsg="yes"
		keys="GELid"	
		MaxRows="15"
		navegacion="#navegacion#"
		filtro_nuevo="#isdefined("form.btnFiltrar")#"
/>		
	
	

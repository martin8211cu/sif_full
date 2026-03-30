<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
	select 
		GEAid,
	<cfif LvarSAporComision>
		sa.GECid,
		'COMISION ' #LvarCNCT# <cf_dbfunction name="to_char" args="cc.GECnumero"> #LvarCNCT# ': '  #LvarCNCT# cc.GECdescripcion 
		as COMISION,
	<cfelse>
		0 as GECid,
	</cfif>
		GEAdescripcion,
		GEAfechaPagar,
		<!---Mensaje de rechazo--->
		(
		select 	sp.TESSPmsgRechazo
		from TESsolicitudPago sp
		where sp.TESSPid = sa.TESSPid) as mjs,
		<!---Centro Funcional--->
		GEAnumero,
		( 
			select rtrim(o.Oficodigo) #LvarCNCT# ':' #LvarCNCT# cf.CFcodigo
			from CFuncional cf 
			inner join Oficinas o on o.Ecodigo = cf.Ecodigo and o.Ocodigo = cf.Ocodigo 
			where cf.CFid = sa.CFid
		) as CFcodigo,
		<!---Empleado--->
		(
			select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2

			from DatosEmpleado Em,TESbeneficiario te
			where sa.TESBid=te.TESBid and   Em.DEid=te.DEid  
		) as Empleado,			
		<!---Moneda--->
		(
			select Mo.Miso4217
			from Monedas Mo
			where sa.Mcodigo=Mo.Mcodigo
		)as Moneda,
		GEAtotalOri,
		<!---Estado--->
		case GEAestado
			when  0 then 'En Preparaci&oacute;n'
			when  1 then 'En Aprobaci&oacute;n'
			when  2 then 'Aprobada'
			when  3 then 'Rechazada'
			when  4 then 'Pagada'
			when  5 then 'Liquidada' 
			else 'Estado desconocido'
			end as estado,
		<!---Solicitante--->
		(
			select us.Usulogin
			from Usuario us
			where us.Usucodigo=sa.UsucodigoSolicitud
		) as usuario,
		sa.GEAmsgRechazo		
		from GEanticipo sa
	<cfif LvarSAporComision>
			inner join GEcomision cc on cc.GECid = sa.GECid
	</cfif>
		<!---Filtros--->
		where sa.GEAtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
		and sa.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
		and sa.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
	</cfif>	
	<cfif isdefined('form.UsucodigoSP_F') and len(trim(form.UsucodigoSP_F)) and form.UsucodigoSP_F NEQ "">
		and sa.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
	</cfif>			
	
	<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
		and sa.TESBid=
			(select TESBid
				from TESbeneficiario 
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
	</cfif>	
	<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
		and sa.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
	</cfif>	
	<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
		and GEAnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numAnti#">
	</cfif>
	<cfif isdefined('form.numComision') and len(trim(form.numComision))>
		and cc.GECnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numComision#">
	</cfif>
	<cfif isdefined("form.chkCancelados")>
				and sa.GEAestado in (3)	
	<cfelse>
		and GEAestado in(#Attributes.Estado#)
	</cfif>
	<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
		and sa.GEAfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_F)#">
	</cfif>	
	<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
		and sa.GEAfechaPagar >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_I)#">
	</cfif>	
		and sa.GECid is <cfif LvarSAporComision>not </cfif>null
	<cfif LvarSAporComision>
	UNION
	select 
		0 as GEAid,
		GECid,
		'COMISION ' #LvarCNCT# <cf_dbfunction name="to_char" args="cc.GECnumero"> #LvarCNCT# ': '  #LvarCNCT# cc.GECdescripcion as COMISION,
		null as GEAdescripcion,
		cc.GECfechaPagar as GEAfechaPagar,
		<!---Mensaje de rechazo--->
		null as mjs,
		<!---Centro Funcional--->
		0 as GEAnumero,
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
		null as GEAtotalOri,
		<!---Estado--->
		'Sin Anticipos' as estado,
		<!---Solicitante--->
		(
			select us.Usulogin
			from Usuario us
			where us.Usucodigo=cc.UsucodigoSolicitud
		) as usuario,
		null as GEAmsgRechazo		
	from GEcomision cc 
	where (select count(1) from GEanticipo where GECid=cc.GECid and GEAestado in(#Attributes.Estado#))=0
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
		order by 2, GEAnumero
</cfquery>
<cfset LvarCortes = "">
<cfif LvarSAporComision>
	<cfset LvarCortes = "COMISION">
</cfif>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		Cortes="#LvarCortes#"
		desplegar="GEAnumero,CFcodigo,Empleado,GEAfechaPagar,Moneda,GEAtotalOri,estado,usuario,GEAmsgRechazo"
		etiquetas="Num.<BR>Anticipo,Ofi:Centro<BR>Funcional,Nombre Empleado,Fecha Pago<BR>Solicitada, Moneda, Total Pago<BR>Solicitado, Estado, Solicitante, #LvarMSGrechazo#"
		formatos="I,S,S,D,S,M,S,S,S"
		align="left,left,left,center,right,right,left,left,left"
		ira="#Attributes.IrA#"
		form_method="post"
		showEmptyListMsg="yes"
		keys="GEAid"	
		MaxRows="15"
		navegacion="#navegacion#"
		checkboxes="N"
		botones="#Attributes.Botones#"
		filtro_nuevo="#isdefined("form.btnFiltrar")#"
/>		


<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
<cfset LvarCortes = "">
	
select 		distinct
			tp.CCHTid as idTransaccion,
            ga.GEAid as GEAid,
			tp.CCHTrelacionada,
			tp.CCHTtipo as tipo,
			ga.GEAnumero as numero,
<!---			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as comision,--->
			co.GECnumero as comision,
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
            	inner join GEcomision co
			on ga.GECid = co.GECid
	where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and tp.CCHTtipo='ANTICIPO'
	and tp.CCHTrelacionada is not null
    and ga.GEAestado = 2
    <!---Muestra solo los CF donde soy aprobador--->
    and ga.CFid in (select  CFid
                        from TESusuarioSP tu 
                        where tu.Usucodigo = #session.Usucodigo#
                        and tu.TESUSPaprobador = 1 
                        and Ecodigo =  #session.Ecodigo#
                    )
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
<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
	and ga.GEAfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_F#">
</cfif>	
<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
	and ga.GEAfechaPagar >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.TESSPfechaPago_I#">
</cfif>
<cfif isdefined('form.tipoTransaccion') and len(trim(form.tipoTransaccion))>
	and tp.CCHTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tipoTransaccion#">
</cfif>
<cfif isdefined('form.numComision') and len(trim(form.numComision))>
	and co.GECnumero =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.numComision#">
</cfif>

order by Fecha
 
</cfquery>



		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				Cortes="#LvarCortes#"
				desplegar="tipo,numero,comision,CFcodigo,Empleado,fecha,Moneda,total,estado,usuario"
				etiquetas="Tipo,Núm. Transacción,Comisión,Ofi:Centro Funcional,Nombre Empleado,Fecha Pago Solicitada, Moneda, Total Pago Solicitado, Estado, Solicitante,"
				formatos="S,I,I,S,S,D,S,M,S,S"
				align="left,right,center,left,left,center,right,right,left,left"
				ira="#Attributes.IrA#"
				form_method="post"
				showEmptyListMsg="yes"
				keys="CCHTrelacionada"	
				MaxRows="15"
				navegacion="#navegacion#"
				checkboxes="N"
				botones="#Attributes.Botones#"
				filtro_nuevo="#isdefined("form.btnFiltrar")#"
				PageIndex="10"
			/>		
			
			


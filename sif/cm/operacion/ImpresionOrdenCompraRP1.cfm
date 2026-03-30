<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 29 de julio del 2005
	Motivo:	Fuente para el llamado del reporte para la impresion de la orden de compra
----------->
<cfif isdefined("url.EOidorden") and  not isdefined("url.EOidorden")>
	<cfset url.EOidorden = url.EOidorden>
</cfif>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined("url.EOidorden")>
	
	<!----Datos de la orden de compra----->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		  select 	EO.EOImpresion as reimpresion,
		  			EO.EOnumero, 
		  			SNnombre,
					EOfecha, 
					EOrefcot,
					EOtotal,
					u.Usulogin,
					Impuesto, 
					coalesce(ltrim(rtrim(DO.DOalterna)), DO.DOdescripcion) as DOdescripcion,
					DOcantidad,
					#LvarOBJ_PrecioU.enSQL_AS("DOpreciou")#,
					DOtotal,
					DOrefcot, 
					c.CMCnombre, 
				 	Pnombre #_Cat# ' ' #_Cat# Papellido1 #_Cat# ' ' #_Cat# Papellido2 as Nombre,
				 	EO.EOlugarentrega, 
					EO.CMCid,
					EO.Observaciones
          from EOrdenCM EO 
		  	left outer join DOrdenCM DO 
                 on EO.EOidorden = DO.EOidorden 
                 and EO.Ecodigo   = DO.Ecodigo 
                         
			inner join SNegocios SN 
                 on EO.SNcodigo = SN.SNcodigo 
                 and EO.Ecodigo  = SN.Ecodigo 
 
			inner join Usuario u 
                 on EO.Usucodigo = u.Usucodigo 
				 
			left outer join DatosPersonales dp
				on u.datos_personales = dp.datos_personales
 
			inner join CMCompradores c 
				on EO.Ecodigo = c.Ecodigo and
				EO.CMCid = c.CMCid 

		where EO.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  		  and EO.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
	</cfquery>

	<!----Obtener el último comprador que autorizó la OC---->
	<cfset vsComprador = ''>
	<cfquery name="rsAutoriza" datasource="#session.DSN#">
		select * 
		from CMAutorizaOrdenes
		where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
	</cfquery>	
	<cfif rsAutoriza.recordCount gt 0 >
		<!---
			CMAestado (Estado por cada comprador): 0 = En Proceso, 1 = Rechazado, 2 = Aprobado
			CMAestadoproceso (Estado general de la orden de Compra):0 = En Proceso, 5 = Rechazado con posibilidad de revivir, 10 = Rechazado sin opcion de revivir, 15 = Aprobado
			Nivel (Jerarquía de Compradores, el último en autorizar debe ser el que tiene el MAYOR nivel)
		--->
		<!--- ME DICE EL ULTIMO COMPRADOR QUE AUTORIZO O RECHAZO LA ORDEN --->
		<cfquery name="dataComprador" datasource="#session.DSN#" maxrows="1">
			select 	a.CMAid, 
					a.CMCid, 
					a.Nivel, 
					coalesce(a.CMAestadoproceso,0) as CMAestadoproceso,
					b.CMCnombre
			from CMAutorizaOrdenes a 
				inner join CMCompradores b
					on a.Ecodigo = b.Ecodigo
					and a.CMCid = b.CMCid						
			where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">				
				and a.CMAestado in (1,2)
				and a.CMAestadoproceso <> 10
				and a.Nivel = ( select max(Nivel)
							  from CMAutorizaOrdenes 
							  where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
								and CMAestadoproceso <> 10
								and CMAestado in (1,2) )
		</cfquery>
		<cfif dataComprador.recordCount gt 0 and dataComprador.CMAestadoproceso eq 15>
			<cfset vsComprador = dataComprador.CMCnombre>
		</cfif>
	<cfelse>
		<cfquery name="dataComprador" datasource="#session.DSN#">
			select CMCid, CMCnombre
			from CMCompradores
			where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.CMCid#">
		</cfquery>
		<cfset vsComprador = dataComprador.CMCnombre>
	</cfif>

	<!---Se descomenta a solicitud de Juan Carlos Gudiño 24/07/2006---->
	 <cfquery name="request.rsSubReporte" datasource="#session.DSN#">
		select distinct es.ESnumero,
				 		<!---ECnumero,  ---->
						EO.EOtipotransporte as ECnumero,
						CFdescripcion, 
						dp.Pnombre #_Cat# ' ' #_Cat# Papellido1 #_Cat# ' ' #_Cat# Papellido2 as Nombre
		
		from EOrdenCM EO 			
								 
			inner join SNegocios SN 
				on EO.SNcodigo = SN.SNcodigo  
				and EO.Ecodigo = SN.Ecodigo 
						 
			left outer join DOrdenCM DO 
			   on EO.EOidorden = DO.EOidorden 
			   and EO.Ecodigo  = DO.Ecodigo 

			inner join CFuncional cf
				on DO.Ecodigo = cf.Ecodigo 
				and DO.CFid = cf.CFid

			<!--- inner join DSolicitudCompraCM ds --->
			left outer join DSolicitudCompraCM ds
				on DO.ESidsolicitud = ds.ESidsolicitud
				and DO.DSlinea = ds.DSlinea
				and DO.Ecodigo = ds.Ecodigo

			left outer join DCotizacionesCM dc									
				on ds.Ecodigo = dc.Ecodigo
				and ds.DSlinea = dc.DSlinea
				
			<!--- inner join ECotizacionesCM ec --->
			left outer join ECotizacionesCM ec
				on dc.ECid = ec.ECid
				and dc.Ecodigo  = ec.Ecodigo

			<!--- inner join ESolicitudCompraCM es --->
			left outer join ESolicitudCompraCM es 
				on ds.ESidsolicitud = es.ESidsolicitud
				and ds.Ecodigo = es.Ecodigo

			left outer join Usuario u
				on es.Usucodigo = u.Usucodigo 

			left outer join DatosPersonales dp
				on u.datos_personales = dp.datos_personales
						
		where EO.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EO.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
	</cfquery> 
	
	
	<!--------- ACTUALIZA EL CAMPO "EOImpresion" a 'I' si no esta en 'R'-------->
	<cfset reimpresion='I'>
	
	<cfquery name="rsOrdenEstado" datasource="#session.DSN#">
		select EOImpresion
		from EOrdenCM
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
	</cfquery>
	<cfif isdefined("rsOrdenEstado") and rsOrdenEstado.recordCount EQ 1 and not len(trim(rsOrdenEstado.EOImpresion))>
		<cfquery datasource="#session.DSN#">
			update EOrdenCM
			set EOImpresion=<cfqueryparam cfsqltype="cf_sql_char" value="I">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
		</cfquery>
		<cfset reimpresion='I'>
	<cfelseif isdefined("rsOrdenEstado") and rsOrdenEstado.recordCount EQ 1 and trim(rsOrdenEstado.EOImpresion) eq 'I'>
		<cfquery datasource="#session.DSN#">
			update EOrdenCM
			set EOImpresion=<cfqueryparam cfsqltype="cf_sql_char" value="R">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
		</cfquery>
		<cfset reimpresion='R'>
	<cfelseif isdefined("rsOrdenEstado")and rsOrdenEstado.recordCount gt 0 and trim(rsOrdenEstado.EOImpresion) eq 'R'>
		<cfset reimpresion='R'>	
	</cfif>
	<!--------------------------------------------------------------->
		
	<cfquery name="rsEmpresa" datasource="#session.DSN#" >
		select Eidentificacion, coalesce(Etelefono1, '-') as telefono1, coalesce(Etelefono2, '-') as telefono2, coalesce(Efax, '-') as fax
		from Empresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	</cfquery>

    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
			select Pvalor as valParam
			from Parametros
			where Pcodigo = 20007
			and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
		<cfset typeRep = 1>
		<cf_js_reports_service_tag queryReport = "#rsReporte#" 
			isLink = False 
			typeReport = typeRep
			fileName = "cm.consultas.ImpresionOrdenCompraRP2"
			headers = "empresa:#session.enombre#"/>
	<cfelse>
	<cfreport format="flashpaper" template="ImpresionOrdenCompraRP2.cfr" query="rsReporte">
		<cfreportparam name="parUltimoAutorizador" value="#vsComprador#">
		<cfreportparam name="reimpresion" value="#rsOrdenEstado.EOImpresion#">
		<cfreportparam name="empresa" value="#session.Enombre#">
		<cfreportparam name="usuario" value="#session.usulogin#">
		<cfreportparam name="tel1" value="#rsEmpresa.telefono1#">
		<cfreportparam name="tel2" value="#rsEmpresa.telefono2#">
		<cfreportparam name="fax" value="#rsEmpresa.fax#">
		<cfreportparam name="ruc" value="#rsEmpresa.Eidentificacion#">
	</cfreport>	
	</cfif>
		
</cfif>
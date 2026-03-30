<!--- Archivo    :  NoFactProductosA-sql.cfm  --->
<!--- Nota Mental: Se tiene que verificar que el documento no exista en el Historico--->																								 


<!--- Variable Form para CosICTS--->
<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>			
<cfif not isdefined("varCodICTS")>
	<cfabort showerror="No se especifico la Empresa a Procesar">
</cfif>

<cfsetting requesttimeout="1000">	  
<cfobject name="OGeneralProcA" component="interfacesNASA.Componentes.CGeneralProcA">
<cfset LvarHoraInicio = now()>
<!---<cfdump var="#LvarHoraInicio#">--->
<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>
<cfset vFechaFNOW = createdatetime(year(now()),month(now()),day(now()),23,59,59)>
<cfset vFechaM1 = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>
<cfset vFechaM1 = DateAdd('D',1,vFechaM1)>

<cfset session.FechaFolio = "#right(form.FechaF,4)##mid(form.FechaF,4,2)#">
<cfset session.FechaFinal = vFechaF>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">

<!---			 																					 
<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.EmpresaICTS = rsVerifica.CodICTS>
	<cfset session.EcodigoSDCSoin = rsVerifica.EcodigoSDCSoin>
</cfif>
--->
																							 
<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	<!---where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>

<!--- Verifica que se haya ejecutado  la copia de Costos --->

<cfquery name="rsDiaSem" datasource="#session.dsn#">
	select DATENAME(weekday,getdate()) as DiaSem, getdate() as Fechafin
</cfquery>
<cfif rsDiaSem.DiaSem EQ "Monday">
	<cfset diasMenos = -3>

<cfelse>
	<cfset diasMenos = -1>
</cfif>
<cfset Fechaini="getdate()#diasMenos#">
<cfquery name="rsFechaIni" datasource="#session.dsn#">
	select #Fechaini# as Fechaini
</cfquery>

<cfquery name="FcopiaCostos"  datasource="preicts">
	Select count(*) as CopiaCostos
     from PmiSoin6CostCopyRun where run_date 
     between '#rsFechaIni.Fechaini#' and '#rsDiaSem.Fechafin#'
     and status = 'COMPLETED'
</cfquery>
 <cfif FcopiaCostos.CopiaCostos LT 1>
 		<cfabort showerror=" Error al Procesar: No se ejecutado la Copia de Costos.">
 </cfif>
  <cfset IntfzCode = "CPSNF">
  <cfquery name="periodoAux" datasource="#session.dsn#">
		 select Pvalor as periodo from Parametros 
         where Ecodigo = #session.Ecodigo#
         and Pcodigo = 50
  </cfquery>    
  <cfquery name="mesAux" datasource="#session.dsn#">
		 select Pvalor  mes from Parametros 
         where Ecodigo = #session.Ecodigo#
         and Pcodigo = 60
  </cfquery>      
  <!--- Obtiene el  consecutivo  de la Transaccion--->      
 <cfquery name="rsTransCons" datasource="sifinterfaces">
 		select ultimo_numero + 1 as consecutivo from consecutivos  where nombre_tabla = 'PmiSoin6Transaction'
 </cfquery>
 
 <cfquery name ="updTransCons" datasource="sifinterfaces">
 		update consecutivos set ultimo_numero = #rsTransCons.consecutivo# where nombre_tabla = 'PmiSoin6Transaction'
 </cfquery>
 <!--- Guarda la transaccion --->
 <cfquery name ="insTransCons" datasource="preicts"> 
 		Insert into PmiSoin6Transaction (intfz_trans_id,
                                mes_aplicacion,
                                anio_aplicacion,
                                booking_num,                                
                                fecha_aplicacion,
                                usuario_id,
                                intfz_code,
                                param_fecha_ini,
                                param_fecha_fin,
                                aplicado_ind 
                                ) values(#rsTransCons.consecutivo#,
                                #mesAux.mes#,
                                #periodoAux.periodo#,
                                #varCodICTS#,
                                #now()#,
                                '#session.usulogin#',
                                '#IntfzCode#',
                                #vFechaI#,
                                #vFechaF#,'0')
 </cfquery>
 
 <cftry>
	<cfquery datasource="sifinterfaces">
		delete from  PrevIntComprasDet
        where i_folio in(select i_folio from PrevIntComprasEnc where i_empresa_prop=#varCodICTS#) 
	</cfquery> 
<cfcatch type="any">
	<cfthrow message="Error al  borrar la tabla PrevIntComprasDet">
</cfcatch>
</cftry>

 <cftry>
	<cfquery datasource="sifinterfaces">
		delete from  PrevIntComprasEnc
         where i_empresa_prop=#varCodICTS#
	</cfquery> 
<cfcatch type="any">
	<cfthrow message="Error al  borrar la tabla PrevIntComprasEnc">
</cfcatch>
</cftry>
<!---- Obtiene el  Encabezado  de Servicios No FACT---->



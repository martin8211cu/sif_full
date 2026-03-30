<cffunction name="get_CualMes" access="public" returntype="string">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Nombre del mes --->">
		<cfswitch expression="#valor#">
			<cfcase value="1"> 	<cfset CualMes = 'Enero'> 		</cfcase>
			<cfcase value="2"> 	<cfset CualMes = 'Febrero'> 	</cfcase>
			<cfcase value="3"> 	<cfset CualMes = 'Marzo'> 		</cfcase>
			<cfcase value="4"> 	<cfset CualMes = 'Abril'> 		</cfcase>
			<cfcase value="5"> 	<cfset CualMes = 'Mayo'> 		</cfcase>
			<cfcase value="6"> 	<cfset CualMes = 'Junio'>	 	</cfcase>
			<cfcase value="7"> 	<cfset CualMes = 'Julio'> 		</cfcase>
			<cfcase value="8"> 	<cfset CualMes = 'Agosto'> 		</cfcase>
			<cfcase value="9"> 	<cfset CualMes = 'Septiembre'> 	</cfcase>
			<cfcase value="10"> <cfset CualMes ='Octubre'> 		</cfcase>
			<cfcase value="11"> <cfset CualMes = 'Noviembre'> 	</cfcase>
			<cfcase value="12"> <cfset CualMes = 'Diciembre'> 	</cfcase>
			<cfdefaultcase> <cfset CualMes = 'Enero'> </cfdefaultcase>
		</cfswitch>
	<cfreturn #CualMes#>
</cffunction>

<cfset NombMes = '#get_CualMes(url.mes)#'>
<cfset NombMes2 = '#get_CualMes(url.mes2)#'>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="rsMonloc" datasource="#session.DSN#">
	select Mnombre
	from Empresas a
	inner join Monedas m
		on  a.Ecodigo = m.Ecodigo
		and a.Mcodigo = m.Mcodigo
	where a.Ecodigo =  #session.Ecodigo#
</cfquery>
<!--- 
<cfquery name="rsReporte" datasource="#session.DSN#">
select
		distinct d.IDdocumento,
        d.Fecha as Dfecha,
		s.SNidentificacion,
		s.SNnombre,
        i.Iporcentaje,
        r.Rcodigo,
		ct.CPTcodigo #_Cat# ' - ' #_Cat# ct.CPTdescripcion as Concepto,
		doc.Ddocumento,
		coalesce (rtrim(ds.direccion1), ds.direccion2) as direccion1,
		CASE
			WHEN COALESCE(ct.CPTcodigo, '') = 'NC' THEN ((Select (sum(v.DDtotallin) * -1) from HDDocumentosCP v  where v.IDdocumento = doc.IDdocumento) *  doc.Dtipocambio)
			ELSE ((Select sum(v.DDtotallin) from HDDocumentosCP v  where v.IDdocumento = doc.IDdocumento) *  doc.Dtipocambio)
		END AS SubTotalFac, <!--- Importe --->
		CASE
			WHEN COALESCE(ct.CPTcodigo, '') = 'NC' THEN (round(((coalesce(r.Rporcentaje,0) / 100.0 * ( Select sum(v.DDtotallin) from HDDocumentosCP v where v.IDdocumento = doc.IDdocumento))* doc.Dtipocambio),2) * -1)
			ELSE round(((coalesce(r.Rporcentaje,0) / 100.0 * ( Select sum(v.DDtotallin) from HDDocumentosCP v where v.IDdocumento = doc.IDdocumento))* doc.Dtipocambio),2)
		END AS Retencion,<!----Retencion---->
		CASE
			WHEN COALESCE(ct.CPTcodigo, '') = 'NC' THEN (((Select sum(v.DDtotallin) from HDDocumentosCP v  where v.IDdocumento = doc.IDdocumento) *  (coalesce(i.Iporcentaje,0) / 100.0) * doc.Dtipocambio) * -1)
			ELSE ((Select sum(v.DDtotallin) from HDDocumentosCP v  where v.IDdocumento = doc.IDdocumento) *  (coalesce(i.Iporcentaje,0) / 100.0) * doc.Dtipocambio)
		END AS MontoCalculado, <!---Impuestos---->
	case
		when coalesce(mov.BMmontoretori,0.00) != 0.00
		then round((mov.BMmontoref) / mov.BMfactor * mov.Dtipocambio,2)
		else round(mov.Dtotal * mov.Dtipocambio,2)
	end as TotalFac5  <!--- TotalLocal --->,
	CASE
		WHEN COALESCE(ct.CPTcodigo, '') = 'NC' THEN (((Select sum(v.DDtotallin) from HDDocumentosCP v  where v.IDdocumento = doc.IDdocumento) * doc.Dtipocambio) + ((Select sum(v.DDtotallin) from HDDocumentosCP v  where v.IDdocumento = doc.IDdocumento) *  (coalesce(i.Iporcentaje,0) / 100.0) *  doc.Dtipocambio)) * -1
		ELSE ((Select sum(v.DDtotallin) from HDDocumentosCP v  where v.IDdocumento = doc.IDdocumento) * doc.Dtipocambio) + ((Select sum(v.DDtotallin) from HDDocumentosCP v  where v.IDdocumento = doc.IDdocumento) *  (coalesce(i.Iporcentaje,0) / 100.0) *  doc.Dtipocambio)
	END AS TotalFac

from ImpDocumentosCxPMov d
	inner join ImpDocumentosCxP e
	on e.IDdocumento = d.IDdocumento
	and e.Icodigo = d.Icodigo
	and e.Ecodigo = d.Ecodigo

	inner join HEDocumentosCP doc
			inner join CPTransacciones ct
			   on ct.CPTcodigo = doc.CPTcodigo
		      and ct.Ecodigo   = doc.Ecodigo

             left outer join Retenciones r
    			 on r.Ecodigo = doc.Ecodigo
	    		 and r.Rcodigo = doc.Rcodigo

    inner join HDDocumentosCP ddoc
			   on doc.IDdocumento = ddoc.IDdocumento
		      and doc.Ecodigo   = ddoc.Ecodigo


 	   	left outer join Impuestos i
			 on i.Ecodigo = ddoc.Ecodigo
			 and i.Icodigo = ddoc.Icodigo

			inner join SNegocios s
			  on  s.Ecodigo = doc.Ecodigo
			  and s.SNcodigo = doc.SNcodigo

			left outer join DireccionesSIF  ds
			  on ds.id_direccion  = doc.id_direccion
	on doc.IDdocumento = d.IDdocumento

	inner join BMovimientosCxP mov
	  on  mov.Ecodigo     = doc.Ecodigo
	  and mov.SNcodigo    = doc.SNcodigo
	  and mov.CPTRcodigo  = doc.CPTcodigo
	  and mov.DRdocumento = doc.Ddocumento
	  and mov.CPTcodigo   = d.CPTcodigo
	  and mov.Ddocumento  = d.Ddocumento
	where d.Ecodigo =  #session.Ecodigo#
	  <cfif periodo EQ url.periodo2>
	  	and YEAR(d.Fecha) = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and MONTH(d.Fecha) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		and MONTH(d.Fecha) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">
	  <cfelse>
	  	and YEAR(d.Fecha) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and YEAR(d.Fecha) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
		and ((YEAR(d.Fecha) * 100 + MONTH(d.Fecha))  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">))
	  </cfif>
	  and e.TotalFac > e.SubTotalFac
	order by d.Fecha,s.SNnombre,doc.Ddocumento
</cfquery>
 --->

 <!---JARR y Martin Se modifico la consulta --->



<cfquery name="rsReporte" datasource="#session.DSN#">
select
	TESOPid ,
	TESDPidDocumento,
	TESDPdocumentoOri,
	max(TESDPmontoPago) as TotalFac, 
	sum(IvaPagado) as MontoCalculado,
	min(Retencion) as Retencion,
	max(TESDPmontoPago) - (sum(IvaPagado)) as SubTotalFac, 
	SNidentificacion,
	SNnombre,
	Ddocumento,
	Concepto,
	TESOPfechaPago as Dfecha,
	SNdireccion as direccion1
from (
	select tsp.TESOPid, tdp1.TESDPidDocumento, tdp1.TESDPdocumentoOri, tdp1.TESDPmontoPago,
		 hecp1.Rcodigo, hdcp1.Icodigo, r.Rporcentaje, i.Iporcentaje,
		 s.SNidentificacion,s.SNnombre, hecp1.Ddocumento,ct.CPTcodigo +' - ' + ct.CPTdescripcion as Concepto,tsp.TESOPfechaPago,s.SNdireccion,
		 (hdcp1.DDtotallin*(  (  (TESDPmontoPago*100)/hecp1.Dtotal)/100)  )*((isnull(Iporcentaje,0))/100) as IvaPagado,
		case when (TESDPmontoPago-(TESDPmontoPago / (1+ (isnull(Rporcentaje,0))/100)))=0
			then isnull(hecp1.EDretencionVariable ,0)
		else
			TESDPmontoPago-(TESDPmontoPago / (1+ (isnull(Rporcentaje,0))/100))
		end as Retencion
	
	from (select distinct TESOPid,TESSPestado,EcodigoOri,TESSPtipoDocumento 
	 from TESsolicitudPago
	 where TESSPestado =12
     AND EcodigoOri =  #session.Ecodigo#
     AND TESSPtipoDocumento=1)tss
	inner join TESordenPago tsp
		on  tsp.TESOPid = tss.TESOPid 
		and tsp.TESOPestado=12
		and tsp.TESOPid in (select min(tdp1.TESOPid)
							from TESordenPago tsp
								inner join TESdetallePago tdp1
									on tsp.TESOPid = tdp1.TESOPid
									and tdp1.TESDPestado=12
								inner join HEDocumentosCP hecp1
									on hecp1.IDdocumento = tdp1.TESDPidDocumento
									and hecp1.Ddocumento = tdp1.TESDPdocumentoOri
									and hecp1.Ecodigo = tdp1.EcodigoPago
							group by tdp1.TESDPidDocumento,hecp1.Ddocumento)
	inner join TESdetallePago tdp1
		on tsp.TESOPid = tdp1.TESOPid
		and tdp1.TESDPestado=12
		 and  tdp1.TESDPmontoPago>0
	inner join HEDocumentosCP hecp1
		on hecp1.IDdocumento = tdp1.TESDPidDocumento
		and hecp1.Ecodigo = tdp1.EcodigoPago
	inner join CPTransacciones ct
		on ct.CPTcodigo = hecp1.CPTcodigo
		and ct.Ecodigo   = hecp1.Ecodigo
	inner join SNegocios s
		on  s.Ecodigo = hecp1.Ecodigo
		and s.SNcodigo = hecp1.SNcodigo
	inner join HDDocumentosCP hdcp1
		on hecp1.IDdocumento = hdcp1.IDdocumento
	left join Retenciones r
		on hecp1.Rcodigo = r.Rcodigo
		and hecp1.Ecodigo = r.Ecodigo
	left join Impuestos i
  		on i.Icodigo=hdcp1.Icodigo
  		and i.Ecodigo=tdp1.EcodigoPago
	where 1=1
		<cfif periodo EQ url.periodo2>
		and YEAR(tsp.TESOPfechaPago) = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and MONTH(tsp.TESOPfechaPago) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		and MONTH(tsp.TESOPfechaPago) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">
		<cfelse>
		and YEAR(tsp.TESOPfechaPago) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and YEAR(tsp.TESOPfechaPago) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
		and ((YEAR(tsp.TESOPfechaPago) * 100 + MONTH(tss.TESOPfechaPago))  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">))
		</cfif>
) result
group by TESOPid, TESDPidDocumento,TESDPdocumentoOri,SNidentificacion,SNnombre,Ddocumento,Concepto,TESOPfechaPago,SNdireccion
union
select 
TESOPid ,
	TESDPidDocumento,
	TESDPdocumentoOri,
	max(TESDPmontoPago) as TotalFac, 
	sum(IvaPagado) as MontoCalculado, 
	min(Retencion) as Retencion,
	max(TESDPmontoPago) - (sum(IvaPagado)) as SubTotalFac,
	SNidentificacion,
	SNnombre,
	Ddocumento,
	Concepto,
	TESOPfechaPago as Dfecha,
	SNdireccion as direccion1
from (
	select tsp.TESOPid, tdp1.TESDPidDocumento, tdp1.TESDPdocumentoOri, tdp1.TESDPmontoPago,
		 hecp1.Rcodigo, hdcp1.Icodigo, r.Rporcentaje, i.Iporcentaje,
		 s.SNidentificacion,s.SNnombre, hecp1.Ddocumento,ct.CPTcodigo +' - ' + ct.CPTdescripcion as Concepto,tsp.TESOPfechaPago,s.SNdireccion,
		 (hdcp1.DDtotallin*(  (  (TESDPmontoPago*100)/hecp1.Dtotal)/100)  )*((isnull(Iporcentaje,0))/100) as IvaPagado,
		 case when (TESDPmontoPago-(TESDPmontoPago / (1+ (isnull(Rporcentaje,0))/100)))=0
			then isnull(0 ,0)
		else
			TESDPmontoPago-(TESDPmontoPago / (1+ (isnull(Rporcentaje,0))/100))
		end as Retencion
	from  (select distinct TESOPid,TESSPestado,EcodigoOri,TESSPtipoDocumento 
	 from TESsolicitudPago
	 where TESSPestado =12
     AND EcodigoOri =  #session.Ecodigo#
     AND TESSPtipoDocumento=1)tss
	inner join TESordenPago tsp
		on  tsp.TESOPid = tss.TESOPid 
		and tsp.TESOPestado=12
		and tsp.TESOPid not in (select min(tdp1.TESOPid)
							from TESordenPago tsp
								inner join TESdetallePago tdp1
									on tsp.TESOPid = tdp1.TESOPid
									and tdp1.TESDPestado=12
								inner join HEDocumentosCP hecp1
									on hecp1.IDdocumento = tdp1.TESDPidDocumento
									and hecp1.Ddocumento = tdp1.TESDPdocumentoOri
									and hecp1.Ecodigo = tdp1.EcodigoPago
							group by tdp1.TESDPidDocumento,hecp1.Ddocumento)
	inner join TESdetallePago tdp1
		on tsp.TESOPid = tdp1.TESOPid
		and tdp1.TESDPestado=12
		 and  tdp1.TESDPmontoPago>0
	inner join HEDocumentosCP hecp1
		on hecp1.IDdocumento = tdp1.TESDPidDocumento
		and hecp1.Ecodigo = tdp1.EcodigoPago
	inner join CPTransacciones ct
		on ct.CPTcodigo = hecp1.CPTcodigo
		and ct.Ecodigo   = hecp1.Ecodigo
	inner join SNegocios s
		on  s.Ecodigo = hecp1.Ecodigo
		and s.SNcodigo = hecp1.SNcodigo
	inner join HDDocumentosCP hdcp1
		on hecp1.IDdocumento = hdcp1.IDdocumento
	left join Retenciones r
		on hecp1.Rcodigo = r.Rcodigo
		and hecp1.Ecodigo = r.Ecodigo
	left join Impuestos i
  		on i.Icodigo=hdcp1.Icodigo
  		and i.Ecodigo=tdp1.EcodigoPago
	where 1=1
		<cfif periodo EQ url.periodo2>
		and YEAR(tsp.TESOPfechaPago) = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and MONTH(tsp.TESOPfechaPago) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		and MONTH(tsp.TESOPfechaPago) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">
		<cfelse>
		and YEAR(tsp.TESOPfechaPago) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and YEAR(tsp.TESOPfechaPago) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
		and ((YEAR(tsp.TESOPfechaPago) * 100 + MONTH(tss.TESOPfechaPago))  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes2#">))
		</cfif>
) result
group by TESOPid, TESDPidDocumento,TESDPdocumentoOri,SNidentificacion,SNnombre,Ddocumento,Concepto,TESOPfechaPago,SNdireccion
order by SNidentificacion,TESOPfechaPago
</cfquery>


<cfif rsReporte.recordcount GT 10000>
	<br><br>
	<div align="center">*************Se genero un reporte más grande de lo permitido.  Se abortó el proceso**************</div>
	<br><br>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
	<br><br>
	<div align="center">*************No hay datos para generar el reporte.  Se abortó el proceso**************</div>
	<cfabort>
</cfif>

<!--- Define cual reporte va a llamar --->
<cfset archivo = "IVAAcredEfecPago.cfr">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	  from Empresas
 	where Ecodigo =  #session.Ecodigo#
</cfquery>
<!--- INVOCA EL REPORTE --->

<!--- 
SNidentificacion as Identificacion,
			SNnombre as Nombre,
			Ddocumento as Documento,
			Concepto,
			Dfecha as Fecha,
			direccion1 as Direccion,
			SubTotalFac as SubTotal,
			Retencion,
			MontoCalculado,
			TotalFac as Total_Factura


 --->



<!--- <cfif isdefined("url.formato") and url.formato eq 'Tabular'> --->
<!--- 	<cfquery name="rsReporteQoQ" dbtype="query">
		select
			SNidentificacion as Identificacion,
			SNnombre as Nombre,
			Ddocumento as Documento,
			Concepto,
			Dfecha as Fecha,
			direccion1 as Direccion,
			SubTotalFac as SubTotal,
			Retencion,
			MontoCalculado as MontoCalculado,
			TotalFac as Total_Factura
		from rsReporte
		order by Fecha, Nombre, Documento
	</cfquery>
	<cf_exportQueryToFile query="#rsReporteQoQ#" filename="IVA_Efec_Pagado_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="false">
<cfelse> --->
  <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and url.formato EQ "excel">
	  <cfset typeRep = 1>
	  <cfif url.formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		  isLink = False 
		  typeReport = #typeRep#
		  fileName = "cp.consultas.reportes.#IVAAcredEfecPago#"
		  headers = "empresa:#rsEmpresa.Edescripcion#"/>
	<cfelse>
		<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
			<cfreportparam name="Edescripcion" 	value="#rsEmpresa.Edescripcion#">
			<cfreportparam name="periodo" 		value="#url.periodo#">
			<cfreportparam name="mes" 			value="#NombMes#">
			<cfreportparam name="periodo2" 		value="#url.periodo2#">
			<cfreportparam name="mes2" 			value="#NombMes2#">
			<cfreportparam name="Mlocal" 		value="#rsMonloc.Mnombre#">
		</cfreport>
	</cfif>
<!--- </cfif> --->
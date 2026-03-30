<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<!---
	Modificado por: Melissa Cambronero Z.
	Modificación: Se modifico el fuente para que el reporte sea desplegado con el ColdFusion Report y se elimino el jasper
--->

<cfif url.Formato eq 'pdf'>
<cfset tipo ='pdf' >
</cfif>
<cfif url.Formato eq 'fla'>
<cfset tipo ='flashpaper' >
</cfif>
<cfif  len(trim(url.ECnumeroF)) EQ 0>
<cfset url.ECnumeroF=999999999>
</cfif>

<cfif  len(trim(url.ECnumeroI)) EQ 0>
<cfset url.ECnumeroI=0>
</cfif>

<cfquery datasource="#session.DSN#" name="rsReporte">
	select 	
	b.DSlinea as DClinea, 
	b.DCcantidad, 
	#LvarOBJ_PrecioU.enSQL_AS("b.DCpreciou")#,	
	b.DCgarantia,  
	b.Ecodigo,
	b.DCplazoentrega,  
	b.DCtotallin, 
	b.DCdescprov, 
	b.Ucodigo,
	'#LSTimeFormat(now(),"hh:mm:ss")#' as Hora,
	case when b.Icodigo = 'IE' then 'S' else 'N' end as IE,
	a.CMCid, a.ECfechacot, a.ECobsprov, 
	e.Edescripcion , 
	c.CMCnombre, 
	a.ECid, 
	a.ECnumero
from ECotizacionesCM a, DCotizacionesCM b, CMCompradores c, Empresas e , SNegocios f
where a.Ecodigo = #session.Ecodigo#
	<cfif isDefined("url.ECfechacotI") and len(trim(url.ECfechacotI)) NEQ 0 and len(trim(url.ECfechacotF)) EQ 0>
		and a.ECfechacot >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsdateformat(url.ECfechacotI,'YYYY/MM/DD')#">
	</cfif>
	<cfif isDefined("url.ECfechacotF") and len(trim(url.ECfechacotF)) NEQ 0 and len(trim(url.ECfechacotI)) EQ 0 >
		and a.ECfechacot <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsdateformat(url.ECfechacotF,'YYYY/MM/DD')#">
	</cfif>
	<cfif isDefined("url.ECfechacotI") and len(trim(url.ECfechacotI)) NEQ 0 and isDefined("url.ECfechacotF") and len(trim(url.ECfechacotF)) NEQ 0>
		and a.ECfechacot between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsdateformat(url.ECfechacotI,'YYYY/MM/DD')#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsdateformat(url.ECfechacotF,'YYYY/MM/DD')#"> 
	</cfif>
				
	<cfif isDefined("url.SNnumeroI") and len(trim(url.SNnumeroI)) NEQ 0 and len(trim(url.SNnumeroF)) EQ 0>
		and f.SNnumero <= '#url.SNnumeroI#'
	</cfif>

	<cfif isDefined("url.SNnumeroF") and len(trim(url.SNnumeroF)) NEQ 0 and len(trim(url.SNnumeroI)) EQ 0>
		and f.SNnumero >= '#url.SNnumeroF#'
	</cfif>
	<cfif isDefined("url.SNnumeroI") and len(trim(url.SNnumeroI)) NEQ 0 and isDefined("url.SNnumeroF") and len(trim(url.SNnumeroF)) NEQ 0>
		and f.SNnumero between '#url.SNnumeroI#' and '#url.SNnumeroF#'
	</cfif>
	
	<cfif isDefined("url.ECnumeroI") and len(trim(url.ECnumeroI)) NEQ 0 and len(trim(url.ECnumeroF)) EQ 0>
	 and a.ECnumero <='#url.ECnumeroI#'
	</cfif>
	<cfif isDefined("url.ECnumeroF") and len(trim(url.ECnumeroF)) NEQ 0 and len(trim(url.ECnumeroI)) EQ 0>
		 and a.ECnumero >='#url.ECnumeroF#'
	</cfif>
	<cfif isDefined("url.ECnumeroI") and len(trim(url.ECnumeroI)) NEQ 0 and  isDefined("url.ECnumeroF") and len(trim(url.ECnumeroF)) NEQ 0>
	  and a.ECnumero between '#url.ECnumeroI#' and '#url.ECnumeroF#'
	</cfif>
	
  and a.SNcodigo = f.SNcodigo
  and a.Ecodigo = f.Ecodigo
  and a.Ecodigo = b.Ecodigo
  and a.ECid = b.ECid
  and a.CMCid = c.CMCid
  and a.Ecodigo = e.Ecodigo
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
	<cfif tipo EQ "pdf">
		<cfset typeRep = 2>
	</cfif>
	<cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = typeRep
		fileName = "cm.consultas.SolicitudCot"/>
<cfelse>
<cfreport format="#tipo#" template="Reportes/SolicitudCot.cfr" query="rsReporte">
  	<cfreportparam name="ECnumeroI" value="#url.ECnumeroI#">
 	<cfreportparam name="ECnumeroF" value="#url.ECnumeroF#">
    <cfreportparam name="Fecha" value="#LSDateFormat(now(),'dd/mm/yyyy')#">   
</cfreport>
</cfif>
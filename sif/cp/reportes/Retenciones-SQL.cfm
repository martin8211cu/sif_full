<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset LB_Nacional	 = t.Translate('LB_Nacional','Nacional')>
<cfset LB_Extranjero = t.Translate('LB_Extranjero','Extranjero')>

<cffunction name="get_CualMes" access="public" returntype="string">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Nombre del mes --->">
		<cfswitch expression="#valor#">
			<cfcase value="1"> <cfset CualMes = '#CMB_Enero#'> </cfcase>
			<cfcase value="2"> <cfset CualMes = '#CMB_Febrero#'> </cfcase>
			<cfcase value="3"> <cfset CualMes = '#CMB_Marzo#'> </cfcase>
			<cfcase value="4"> <cfset CualMes = '#CMB_Abril#'> </cfcase>
			<cfcase value="5"> <cfset CualMes = '#CMB_Mayo#'> </cfcase>
			<cfcase value="6"> <cfset CualMes = '#CMB_Junio#'> </cfcase>												
			<cfcase value="7"> <cfset CualMes = '#CMB_Julio#'> </cfcase>
			<cfcase value="8"> <cfset CualMes = '#CMB_Agosto#'> </cfcase>
			<cfcase value="9"> <cfset CualMes = '#CMB_Septiembre#'> </cfcase>
			<cfcase value="10"> <cfset CualMes = '#CMB_Octubre#'> </cfcase>
			<cfcase value="11"> <cfset CualMes = '#CMB_Noviembre#'> </cfcase>
			<cfcase value="12"> <cfset CualMes = '#CMB_Diciembre#'> </cfcase>
			<cfdefaultcase> <cfset CualMes = '#CMB_Enero#'> </cfdefaultcase>
		</cfswitch>
	<cfreturn #CualMes#>
</cffunction>

<cfset NombMes = '#get_CualMes(url.mes)#'>
<cfset NombMes2 = '#get_CualMes(url.mes2)#'>

<cffunction name="Creatabla" access="public" returntype="string" output="false">
	<cf_dbtemp name="RetPagCxP_v6" returnvariable="Retenciones">
		<cf_dbtempcol name="Pfecha"  			type="char(50)"		mandatory="yes">	
		<cf_dbtempcol name="Pdocumento" 		type="char(50)"		mandatory="yes">	
		<cf_dbtempcol name="Dfecha"  			type="datetime"  	mandatory="yes">
		<cf_dbtempcol name="Ddocumento"  		type="char(100)"	mandatory="yes">
		<cf_dbtempcol name="Rcodigo"  			type="char(2)"		mandatory="yes">	
		<cf_dbtempcol name="Dtipocambio"  		type="float"		mandatory="yes">
		<cf_dbtempcol name="MontoPago"		  	type="money"		mandatory="yes">
		<cf_dbtempcol name="Retencion"		  	type="money"		mandatory="yes">
		<cf_dbtempcol name="TotalFac"		  	type="money"		mandatory="yes">
		<cf_dbtempcol name="TotalImpuestoCF"  		type="money"		mandatory="yes">
		<cf_dbtempcol name="SubTotalFac"  		type="money"		>
		<cf_dbtempcol name="ImpuestoCF"		  	type="money"		>
		<cf_dbtempcol name="MontoPago_ORI"		type="money"		>
		<cf_dbtempcol name="Retencion_ORI"		type="money"		>
		<cf_dbtempcol name="TotalFac_ORI"		type="money"		>
		<cf_dbtempcol name="TotalImpuestoCF_ORI"  	type="money"		>
		<cf_dbtempcol name="SubTotalFac_ORI"  		type="money"		>
		<cf_dbtempcol name="ImpuestoCF_ORI"	  	type="money"		>
		<cf_dbtempcol name="SNcodigo"  			type="integer"		mandatory="yes">
		<cf_dbtempcol name="id_direccion"  		type="numeric"		>
		<cf_dbtempcol name="Miso4217"  			type="char(3)"		>
		<cf_dbtempcol name="direccion1"  		type="varchar(255)"	>
		<cf_dbtempcol name="origen"  			type="char(20)"		>
		<cf_dbtempcol name="Rdescripcion"  		type="char(80)"		>
		<cf_dbtempcol name="SNidentificacion"  		type="char(50)"		>
		<cf_dbtempcol name="SNidentificacion2"		type="char(50)"		>										
		<cf_dbtempcol name="SNnombre"  			type="char(255)"	>	
	</cf_dbtemp>
	<cfreturn Retenciones>
</cffunction>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsMonloc" datasource="#session.DSN#">
	select Mnombre
	 from Empresas a
	  inner join Monedas m
		 on a.Ecodigo = m.Ecodigo
		and a.Mcodigo = m.Mcodigo
	 where a.Ecodigo =  #session.Ecodigo# 
</cfquery>

<cfquery name="rsPais" datasource="asp">
	select Ppais 
	  from Empresa e
	    inner join  Direcciones  d
		  on d.id_direccion  = e.id_direccion 
	where Ecodigo = #session.ecodigosdc#
</cfquery>

<cfset Retenciones = Creatabla()>

<cfquery name="rsins" datasource="#session.DSN#">
	insert into #Retenciones#(	
		Pfecha,Pdocumento,SNcodigo,id_direccion,
		Dfecha,Ddocumento,Rcodigo,
		Dtipocambio,Miso4217, 
		MontoPago,Retencion,
		TotalFac,TotalImpuestoCF	)
	select 
		a.BMfecha as Pfecha, 		a.CPTcodigo #_Cat# ' - ' #_Cat# a.Ddocumento as Pdocumento,
		b.SNcodigo,
		b.id_direccion,

		b.Dfecha,
		b.CPTcodigo #_Cat# ' - ' #_Cat# b.Ddocumento as Ddocumento,

		b.Rcodigo,

		b.Dtipocambio,
		m.Miso4217,

		a.Dtotal,
		coalesce(a.BMmontoretori,0.00),
		b.Dtotal,
		coalesce((
			select sum (MontoCalculado) 
			  from ImpDocumentosCxP
			 where IDdocumento	= b.IDdocumento
			   and Ecodigo		= b.Ecodigo 
		),0)*coalesce(a.BMmontoretori/b.Dtotal,0.00) as ImpuestoCF
	from BMovimientosCxP a
	inner join HEDocumentosCP b
		 on b.Ecodigo		= a.Ecodigo 
		and b.SNcodigo		= a.SNcodigo
		and b.CPTcodigo	= a.CPTRcodigo
		and b.Ddocumento	= a.DRdocumento
		and b.Rcodigo is not null
		<cfif isdefined("url.Rcodigo") and len(trim(url.Rcodigo)) >
			and b.Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Rcodigo#">
		</cfif>
	inner join Monedas m
		on  a.Ecodigo 		= m.Ecodigo
		and a.Mcodigoref 	= m.Mcodigo
	inner join SNegocios  sn
		on  b.Ecodigo 	= sn.Ecodigo
		and b.SNcodigo = sn.SNcodigo
	left outer join DireccionesSIF  snb
		on   snb.id_direccion  = b.id_direccion 
		<cfif isdefined("url.TipoSocio") and len(trim(url.TipoSocio)) and url.TipoSocio eq 'N'>
			and snb.Ppais =  <cfqueryparam cfsqltype="cf_sql_char" value="#rsPais.Ppais#">
		<cfelseif isdefined("url.TipoSocio") and len(trim(url.TipoSocio)) and url.TipoSocio eq 'E'>
			and snb.Ppais !=  <cfqueryparam cfsqltype="cf_sql_char" value="#rsPais.Ppais#">
		</cfif>
	where   
		a.BMperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		and a.BMperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo2#">
		and (a.BMperiodo * 100 + a.BMmes)  between #url.periodo*100+url.mes# and #url.periodo2*100+url.mes2#
		and a.Ecodigo =  #session.Ecodigo#
		and a.CPTcodigo  <> a.CPTRcodigo
		and a.Ddocumento <> a.DRdocumento
</cfquery>
<cfquery name="rsins" datasource="#session.DSN#">
	update  #Retenciones# 
	set SubTotalFac= Dtipocambio * (MontoPago+Retencion) / TotalFac * (TotalFac - TotalImpuestoCF),
		ImpuestoCF	= Dtipocambio * (MontoPago+Retencion) / TotalFac * (TotalImpuestoCF),
		TotalFac		= Dtipocambio * (MontoPago+Retencion) ,
		Retencion	= -Dtipocambio * Retencion,
		MontoPago	= Dtipocambio * MontoPago,
		ImpuestoCF_ORI	= (MontoPago+Retencion) / TotalFac * (TotalImpuestoCF),
		TotalFac_ORI	= (MontoPago+Retencion) ,
		Retencion_ORI	= Retencion,
		MontoPago_ORI	= MontoPago,
		SubTotalFac_ORI= (MontoPago+Retencion) / TotalFac * (TotalFac - TotalImpuestoCF),
		Rdescripcion= (select Rdescripcion from Retenciones where #Retenciones#.Rcodigo = Rcodigo and  Ecodigo = #session.Ecodigo#),
		direccion1	= (select coalesce(direccion1, direccion2) from DireccionesSIF where #Retenciones#.id_direccion = id_direccion)  
</cfquery>

<cfquery name="PorActrsins" datasource="#session.DSN#">
	select  a.SNidentificacion ,a.SNidentificacion2 ,a.SNnombre ,b.Ppais, a.SNcodigo
		from SNegocios  a
		  left outer join DireccionesSIF  b
			 on a.id_direccion  = b.id_direccion 
		where a.Ecodigo =  #session.Ecodigo#  
		  and Exists(select 1 from #Retenciones# where SNcodigo = a.SNcodigo)
</cfquery>
<cfloop query="PorActrsins">
	<cfquery name="rsins" datasource="#session.DSN#">
		update  #Retenciones# 
		set SNidentificacion 	= '#PorActrsins.SNidentificacion#',
			SNidentificacion2 	= '#PorActrsins.SNidentificacion2#',
			SNnombre 			= '#PorActrsins.SNnombre#',
			origen 				= case '#PorActrsins.Ppais#' when  <cfqueryparam cfsqltype="cf_sql_char" value="#rsPais.Ppais#"> then '#LB_Nacional#' else '#LB_Extranjero#' end
		where SNcodigo = #PorActrsins.SNcodigo#
	</cfquery>
</cfloop>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select * from #Retenciones#
	order by origen,Rcodigo,Dfecha,Ddocumento
</cfquery>
<cfoutput>
<cfif rsReporte.recordcount GT 10000>
<cfset MSG_LimRep 	= t.Translate('MSG_LimRep','Se genero un reporte más grande de lo permitido.  Se abortó el proceso')>
	<br><br>
	<div align="center">*************#MSG_LimRep#**************</div>
	<br><br>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
<cfset MSG_SinDatos 	= t.Translate('MSG_SinDatos','No hay datos para generar el reporte.  Se abortó el proceso')>
	<br><br>
	<div align="center">*************#MSG_SinDatos#**************</div>
	<cfabort>
</cfif>
</cfoutput>
<!--- Define cual reporte va a llamar --->
<cfset archivo = "Retenciones.cfr">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	 from Empresas
 	where Ecodigo =  #session.Ecodigo# 
</cfquery>
<!--- INVOCA EL REPORTE --->

<cfset TIT_RepPgoRet = t.Translate('TIT_RepPgoRet','Reporte sobre pagos y retenciones')>
<cfset LB_CxP 	= t.Translate('LB_CxP','Cuentas por Pagar')>
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_PerHasta 	= t.Translate('LB_Periodo','Periodo Hasta')>
<cfset LB_PerDesde 	= t.Translate('LB_PerDesde','Periodo Desde')>
<cfset CMB_Mes 		= t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
<cfset LB_FecPgo 	= t.Translate('LB_FecPgo','Fecha Pago')>
<cfset LB_DocPgo 	= t.Translate('LB_DocPgo','Doc. Pago')>
<cfset LB_RFC 	= t.Translate('LB_RFC','RFC')>
<cfset LB_CURP 	= t.Translate('LB_CURP','CURP')>
<cfset LB_PROVEEDOR = t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Domicilio = t.Translate('LB_Domicilio','Domicilio Fiscal')>
<cfset LB_CostoFac 	= t.Translate('LB_CostoFac','Costo Fac.')>
<cfset LB_TotalFac 	= t.Translate('LB_TotalFac','Total Fac.')>
<cfset LB_Retencion	= t.Translate('LB_Retencion','Retención')>
<cfset LB_TotalPag 	= t.Translate('LB_TotalPag','Tot.Pago')>
<cfset LB_MonedaOr 	= t.Translate('LB_MonedaOr','Moneda Origen')>
<cfset LB_TotalPor 	= t.Translate('LB_TotalPor','Total por')>
<cfset LB_TotalGral	= t.Translate('LB_TotalGral','Total General:')>
<cfset MSG_FinRep 	= t.Translate('MSG_FinRep','Fin del Reporte')>
<cfset LB_Impuestos = t.Translate('LB_Impuestos','Impuestos')>

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
		fileName = "cp.consultas.reportes.Retenciones"
		headers = "empresa:#rsEmpresa.Edescripcion#"/>
<cfelse>
	<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
		<cfreportparam name="Edescripcion" 	value="#rsEmpresa.Edescripcion#">
		<cfreportparam name="periodo" 		value="#url.periodo#">
		<cfreportparam name="mes" 			value="#NombMes#">
		<cfreportparam name="periodo2" 		value="#url.periodo2#">
		<cfreportparam name="mes2" 			value="#NombMes2#">
		<cfreportparam name="Mlocal" 		value="#rsMonloc.Mnombre#">
		<cfreportparam name="TIT_RepPgoRet" value="#TIT_RepPgoRet#">
		<cfreportparam name="LB_CxP" 		value="#LB_CxP#">
		<cfreportparam name="LB_Hora" 		value="#LB_Hora#">
		<cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
		<cfreportparam name="LB_PerHasta" 	value="#LB_PerHasta#">
		<cfreportparam name="LB_PerDesde" 	value="#LB_PerDesde#">
		<cfreportparam name="CMB_Mes" 		value="#CMB_Mes#">
		<cfreportparam name="LB_FecPgo" 	value="#LB_FecPgo#">
		<cfreportparam name="LB_DocPgo" 	value="#LB_DocPgo#">
		<cfreportparam name="LB_RFC" 		value="#LB_RFC#">
		<cfreportparam name="LB_CURP" 		value="#LB_CURP#">
		<cfreportparam name="LB_PROVEEDOR" 	value="#LB_PROVEEDOR#">
		<cfreportparam name="LB_Documento" 	value="#LB_Documento#">
		<cfreportparam name="LB_Domicilio" 	value="#LB_Domicilio#">
		<cfreportparam name="LB_CostoFac" 	value="#LB_CostoFac#">
		<cfreportparam name="LB_TotalFac" 	value="#LB_TotalFac#"> 
		<cfreportparam name="LB_Retencion" 	value="#LB_Retencion#">
		<cfreportparam name="LB_TotalPag" 	value="#LB_TotalPag#">
		<cfreportparam name="LB_MonedaOr" 	value="#LB_MonedaOr#"> 
		<cfreportparam name="LB_TotalPor" 	value="#LB_TotalPor#">
		<cfreportparam name="LB_TotalGral" 	value="#LB_TotalGral#">
		<cfreportparam name="MSG_FinRep" 	value="#MSG_FinRep#"> 
		<cfreportparam name="LB_Impuestos" 	value="#LB_Impuestos#"> 
	</cfreport>	
</cfif>

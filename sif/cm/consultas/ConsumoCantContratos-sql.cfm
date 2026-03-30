<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Se indica que no es PrecioContrato, porque no se está consultando el DCpreciou, sino el precio unitario con formula --->

<!--- Creado por: 	  Rebeca Corrales Alfaro  --->
<!--- Fecha: 		  27/07/2005  4:00 p.m.   --->
<!--- Modificado por: 						  --->
<!--- Fecha: 		 						  --->

<cfquery name="rsReporte" datasource="#session.DSN#">
select 
	a.Ecodigo,
	a.SNcodigo as Cod_prov,
	c.SNnombre as Desc_prov,
	a.ECid as Cod_contrato,
	a.ECdesc as Desc_contrato,
	b.DClinea as linea,
	b.DCdescripcion as Desc_bien,
	b.DCcantcontrato as Cant_contratada,
	coalesce(b.DCcantsurtida, 0.00) as Cant_consumida,
	b.Ucodigo as Unidad_medida,
	#LvarOBJ_PrecioU.enSQL_AS("(b.DCpreciou / (case when b.DCcantcontrato is null or b.DCcantcontrato = 0 then 1.00 else b.DCcantcontrato end))", "Precio_unitario")#,
	b.DCtipoitem as Item,
   ((b.DCcantcontrato - coalesce(b.DCcantsurtida, 0.00)) * (b.DCpreciou / (case when b.DCcantcontrato is null or b.DCcantcontrato = 0 then 1.00 else b.DCcantcontrato end))) as Saldo_monetario,
	case b.DCtipoitem when 'A' then b.Aid when 'S' then b.Cid else null end as Cod_bien
	
	from EContratosCM a
	
	inner join DContratosCM b
			on b.ECid = a.ECid
	
	inner join SNegocios c
			on c.SNcodigo = a.SNcodigo
			and c.Ecodigo = a.Ecodigo
where 1 = 1 
 <!--- FILTRO POR PROVEEDOR--->
 <cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
 </cfif>
  <!--- FILTRO POR CONTRATO--->
 <cfif isdefined("url.ECid") and len(trim(url.ECid))>
  and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECid#">
 </cfif>

</cfquery>

<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE RELAIZARA EL REPORTE --->
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formato = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formato = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formato = "excel">
	<cfelse>
		<cfset formato = "flashpaper">
	</cfif>
<cfif rsReporte.recordcount GT 10000>
	<br><br>
	<div align="center">Se genero un reporte más grande de lo permitido.  Se abortó el proceso</div>
	<br><br>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
	<br><br>
	<div align="center">No hay datos para generar el reporte.  Se abortó el proceso</div>
	<cfabort>
</cfif>
	<!--- INVOCA EL REPORTE --->
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	    <cfset typeRep = 1>
		<cfif url.formato EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#rsReporte#" 
			isLink = False 
			typeReport = typeRep
			fileName = "cm.consultas.ConsumoCantContratos"
			headers = "empresa:#session.Enombre#"/>
	<cfelse>
	<cfreport format="#formato#" template= "ConsumoCantContratos.cfr" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edesc"   value="#session.Enombre#">
		<cfreportparam name="maskPU"  value="#LvarOBJ_PrecioU.maskRPT()#">
	</cfreport>	
	</cfif>


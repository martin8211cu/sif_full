<cfsetting requesttimeout="3600">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>

<!---<cf_dump var ="#form#">--->

<cfif isdefined("url.periodo")>
	<cfset form.periodo = #url.periodo#>
</cfif>

<!---<cfif isdefined('Form.periodo')>
	<cfset aFiscal = #DateFormat(CreateDate(Form.periodo,12,31),"yyyymmdd")#>
    <cfset inicioFiscal = #DateFormat(CreateDate(Form.periodo+1,01,01),"yyyymmdd")#>
    <cfset yearFiscal = #Form.periodo#>
</cfif>--->


<!---<cfif isdefined("url.linea")>
	<cfset linea = #url.linea#>
</cfif>
--->
<cfif form.periodo EQ -1>
	<cf_throw message="No existe el periodo de Ajuste Anual">
<cfelse>
	<cfquery name="rsAjusteAnualId" datasource="#session.DSN#">
		select RHAAid,RHAAfecharige,RHAAfechavence
		from RHAjusteAnual
		where RHAAPeriodo = #form.periodo#
			and Ecodigo = #session.Ecodigo# 
	</cfquery>
</cfif>

<!---<cf_dump var = "#rsAjusteAnualId#">--->
<cf_dbtemp name="EmpleadosAjusteAnual" datasource = "#session.DSN#" returnvariable = "EmpleadosAjusteAnual">
		<cf_dbtempcol name = "DEid"			type= "int">
        <cf_dbtempcol name = "Periodo"		type= "numeric">
        <cf_dbtempcol name = "AcumuladoEx"	type= "numeric">
        <cf_dbtempcol name = "AcumuladoGr"	type= "numeric">
        <cf_dbtempcol name = "AcumuladoT"	type= "numeric">
        <cf_dbtempcol name = "AcumuladoRenta"	type= "numeric">
        <cf_dbtempcol name = "txt2O"		type= "numeric">
        <cf_dbtempcol name = "Campo1" 		type= "numeric">
        <cf_dbtempcol name = "Campo2" 		type= "numeric">
        <cf_dbtempcol name = "Campo3" 		type= "varchar(50)">
        <cf_dbtempcol name = "Campo4" 		type= "varchar(50)">
        <cf_dbtempcol name = "Campo5" 		type= "varchar(50)">
        <cf_dbtempcol name = "Campo6" 		type= "varchar(50)">
        <cf_dbtempcol name = "Campo7" 		type= "varchar(50)">
        <cf_dbtempcol name = "Campo8"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo9"		type= "numeric">
        <cf_dbtempcol name = "Campo10"		type= "numeric">
        <cf_dbtempcol name = "Campo11"	    type= "numeric">
        <cf_dbtempcol name = "Campo12"		type= "varchar(6)">
        <cf_dbtempcol name = "Campo13"	    type= "numeric">
        <cf_dbtempcol name = "Campo14"		type= "numeric">
        <cf_dbtempcol name = "Campo15"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo16"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo17"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo18"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo19"		type= "varchar(50)">
		<cf_dbtempcol name = "Campo20"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo21"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo22"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo23"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo24"		type= "varchar(50)">
        <cf_dbtempcol name = "Campo25"		type= "varchar(50)"> 
        <cf_dbtempcol name = "Campo26"		type= "numeric"> 
        <cf_dbtempcol name = "Campo27"		type= "numeric"> 
        <cf_dbtempcol name = "Campo28"		type= "numeric"> 
        <cf_dbtempcol name = "Campo29"	    type= "numeric">   
        <cf_dbtempcol name = "Campo30"	    type= "numeric">
        <cf_dbtempcol name = "Campo31"  	type= "numeric">
        <cf_dbtempcol name = "Campo32"      type= "numeric">
        <cf_dbtempcol name = "Campo33"      type= "numeric">
        <cf_dbtempcol name = "Campo34"      type= "numeric">
        <cf_dbtempcol name = "Campo35"      type= "numeric">
        <cf_dbtempcol name = "Campo36"      type= "numeric">
        <cf_dbtempcol name = "Campo37"      type= "numeric">
        <cf_dbtempcol name = "Campo38"      type= "numeric">
        <cf_dbtempcol name = "Campo39"      type= "numeric">
        <cf_dbtempcol name = "Campo40"      type= "numeric">
        <cf_dbtempcol name = "Campo41"      type= "numeric">
        <cf_dbtempcol name = "Campo42"      type= "numeric">
        <cf_dbtempcol name = "Campo43"      type= "numeric">
        <cf_dbtempcol name = "Campo44"      type= "numeric">
        <cf_dbtempcol name = "Campo45"      type= "numeric">
        <cf_dbtempcol name = "Campo46"      type= "numeric">
        <cf_dbtempcol name = "Campo47"      type= "numeric">
        <cf_dbtempcol name = "Campo48"      type= "numeric">
        <cf_dbtempcol name = "Campo49"      type= "numeric">
        <cf_dbtempcol name = "Campo50"      type= "numeric">
        <cf_dbtempcol name = "Campo51"      type= "numeric">
        <cf_dbtempcol name = "Campo52"      type= "numeric">
        <cf_dbtempcol name = "Campo53"      type= "numeric">
        <cf_dbtempcol name = "Campo54"      type= "numeric">
        <cf_dbtempcol name = "Campo55"      type= "numeric">
        <cf_dbtempcol name = "Campo56"      type= "numeric">
        <cf_dbtempcol name = "Campo57"      type= "numeric">
        <cf_dbtempcol name = "Campo58"      type= "numeric">
        <cf_dbtempcol name = "Campo59"		type= "numeric">
        <cf_dbtempcol name = "Campo60"		type= "numeric">
        <cf_dbtempcol name = "Campo61"		type= "numeric">
        <cf_dbtempcol name = "Campo62"		type= "numeric">
        <cf_dbtempcol name = "Campo63"		type= "numeric">
        <cf_dbtempcol name = "Campo64"		type= "numeric">
        <cf_dbtempcol name = "Campo65"		type= "numeric">
        <cf_dbtempcol name = "Campo66"		type= "numeric">
        <cf_dbtempcol name = "Campo67"		type= "numeric">
        <cf_dbtempcol name = "Campo68"		type= "numeric">
        <cf_dbtempcol name = "Campo69"		type= "numeric">
        <cf_dbtempcol name = "Campo70"		type= "numeric">
        <cf_dbtempcol name = "Campo71"		type= "numeric">
        <cf_dbtempcol name = "Campo72"		type= "numeric">
		<cf_dbtempcol name = "Campo73"		type= "numeric">
        <cf_dbtempcol name = "Campo74"		type= "numeric">
        <cf_dbtempcol name = "Campo75"		type= "numeric">
        <cf_dbtempcol name = "Campo76"		type= "numeric">
        <cf_dbtempcol name = "Campo77"		type= "numeric">
        <cf_dbtempcol name = "Campo78"		type= "numeric">
        <cf_dbtempcol name = "Campo79"		type= "numeric">
        <cf_dbtempcol name = "Campo80"		type= "numeric">
        <cf_dbtempcol name = "Campo81"		type= "numeric">
        <cf_dbtempcol name = "Campo82"		type= "numeric">
        <cf_dbtempcol name = "Campo83"		type= "numeric">
        <cf_dbtempcol name = "Campo84"		type= "numeric">
        <cf_dbtempcol name = "Campo85"		type= "numeric">
        <cf_dbtempcol name = "Campo86"		type= "numeric">
        <cf_dbtempcol name = "Campo87"		type= "numeric">
        <cf_dbtempcol name = "Campo88"		type= "numeric">
        <cf_dbtempcol name = "Campo89"		type= "numeric">
		<cf_dbtempcol name = "Campo90"		type= "numeric">
        <cf_dbtempcol name = "Campo91"		type= "numeric">
        <cf_dbtempcol name = "Campo92"		type= "numeric">
        <cf_dbtempcol name = "Campo93"		type= "numeric">
        <cf_dbtempcol name = "Campo94"		type= "numeric">
        <cf_dbtempcol name = "Campo95"		type= "numeric">
        <cf_dbtempcol name = "Campo96"		type= "numeric">
        <cf_dbtempcol name = "Campo97"		type= "numeric">
        <cf_dbtempcol name = "Campo98"		type= "numeric">
        <cf_dbtempcol name = "Campo99"		type= "numeric">
        <cf_dbtempcol name = "Campo100"		type= "numeric">
        <cf_dbtempcol name = "Campo101"		type= "numeric">
        <cf_dbtempcol name = "Campo102"		type= "numeric">
        <cf_dbtempcol name = "Campo103"		type= "numeric">
        <cf_dbtempcol name = "Campo104"		type= "numeric">
        <cf_dbtempcol name = "Campo105"		type= "numeric">
        <cf_dbtempcol name = "Campo106"		type= "numeric">
        <cf_dbtempcol name = "Campo107"		type= "numeric">
        <cf_dbtempcol name = "Campo108"		type= "numeric">
        <cf_dbtempcol name = "Campo109"		type= "numeric">
        <cf_dbtempcol name = "Campo110"		type= "numeric">
        <cf_dbtempcol name = "Campo111"		type= "numeric">
        <cf_dbtempcol name = "Campo112"		type= "numeric">
        <cf_dbtempcol name = "Campo113"		type= "numeric">
        <cf_dbtempcol name = "Campo114"		type= "numeric">
        <cf_dbtempcol name = "Campo115"		type= "numeric">
        <cf_dbtempcol name = "Campo116"		type= "numeric">
        <cf_dbtempcol name = "Campo117"		type= "numeric">
        <cf_dbtempcol name = "Campo118"		type= "numeric">
        <cf_dbtempcol name = "Campo119"		type= "numeric">
        <cf_dbtempcol name = "Campo120"		type= "numeric">
        <cf_dbtempcol name = "Campo121"		type= "numeric">
        <cf_dbtempcol name = "Campo122"		type= "numeric">
        <cf_dbtempcol name = "Campo123"		type= "numeric">
        <cf_dbtempcol name = "Campo124"		type= "numeric">
        <cf_dbtempcol name = "Campo125"		type= "numeric">
        <cf_dbtempcol name = "Campo126"		type= "numeric">
        <cf_dbtempcol name = "Campo127"		type= "numeric">
        <cf_dbtempcol name = "Campo128"		type= "numeric">
        <cf_dbtempcol name = "Campo129"		type= "numeric">
        <cf_dbtempcol name = "Campo130"		type= "numeric">
        <cf_dbtempcol name = "Campo131"		type= "numeric">
        <cf_dbtempcol name = "Campo132"		type= "numeric">
        <cf_dbtempcol name = "Campo133"		type= "numeric">
        <cf_dbtempcol name = "Campo134"		type= "numeric">
</cf_dbtemp>

<cfquery name="rsInsertReporte" datasource="#Session.DSN#">
	insert into #EmpleadosAjusteAnual# (DEid,Periodo, AcumuladoEx,AcumuladoGr, AcumuladoT,AcumuladoRenta, Campo1,Campo2,Campo3,Campo4,Campo5,Campo6,Campo7,Campo8,Campo10,Campo11,Campo12,Campo14,Campo26,Campo27,Campo28,Campo29,Campo31,Campo32,Campo33,Campo34,Campo35,Campo36,Campo37,Campo38,Campo39,Campo40,Campo41,Campo42,Campo120)
	select de.DEid,rhaa.RHAAPeriodo, rhaaa.RHAAAcumuladoExento, rhaaa.RHAAAcumuladoSG,rhaaa.RHAAAcumulado, rhaaa.RHAAAcumuladoRenta,rhaaa.RHAAAMesInicio,rhaaa.RHAAAMesFinal,de.RFC,de.CURP,de.DEapellido1,de.DEapellido2,de.DEnombre,de.ZEid,1,2,'0.0000',0,0,0,0,0,2,1,0,0,0,0,0,0,0,0,0,0,rhaaa.RHAAAcumuladoSubsidio
	from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaaa.RHAAid = rhaa.RHAAid
              inner join DatosEmpleado de on de.DEid = rhaaa.DEid and de.Ecodigo = rhaa.Ecodigo
	where rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
    <cfif isdefined('form.DEid') and len(form.DEid)>
    and de.DEid = #form.DEid#
    </cfif>
      and rhaa.Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo8 = coalesce(Campo8,(select ZEid 
										from ZonasEconomicas 
										where CEcodigo = (select CEcodigo 
				 										  from Empresa
				 										  where Ereferencia =#session.Ecodigo#)			
                                        and ZEcodigo = 'A'))
</cfquery>

<cfquery name="AGSalario" datasource="#session.DSN#">
  update #EmpleadosAjusteAnual# 
    set Campo8 =(select case ZEcodigo
							   when 'A' then '01'
							   when 'B' then '02'
							   when 'C' then '03'
	   						   end as AGSalario
						from ZonasEconomicas 
						where CEcodigo = (select CEcodigo 
				 						  from Empresa
				 						  where Ereferencia = #session.Ecodigo#)			
                        and ZEid = Campo8)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo9 = (select case RHAAAEstatus 
							   when 1 then 1
	                           when 0 then 2
	                           else 0 
	                           end 
                       from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
                       where Ecodigo = #session.Ecodigo#
							and DEid = #EmpleadosAjusteAnual#.DEid)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo13 = (select case Tcodigo
							   when 02 then 1
	                           when 03 then 2
	                           else 2
	                           end 
                       from RHAjusteAnualAcumulado rhaas inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaas.RHAAid
                       where Ecodigo = #session.Ecodigo#
							and DEid = #EmpleadosAjusteAnual#.DEid)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo15= (select case Oficodigo 
	   				         when 01 then '30'
	                         when 02 then '09'
	                         end
                      from Oficinas 
                      where Ecodigo = #session.Ecodigo#
                      and Ocodigo = (select distinct Ocodigo 
			                         from DLaboralesEmpleado 
                                     where Ecodigo = #session.Ecodigo# and DEid = #EmpleadosAjusteAnual#.DEid))
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo30 = (select 1
 						  from DLaboralesEmpleado dle inner join RHTipoAccion rhta on dle.RHTid = rhta.RHTid and rhta.Ecodigo = dle.Ecodigo
                          where dle.Ecodigo = #session.Ecodigo# and dle.RHTid = (select RHTid 
										                          from RHTipoAccion  
										                          where Ecodigo = #session.Ecodigo# and RHTcodigo = 12)
		                  	and dle.DEid = #EmpleadosAjusteAnual#.DEid
                            and DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsAjusteAnualId.RHAAfecharige#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAjusteAnualId.RHAAfechavence#">)
                          
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo43 = (select SUM(coalesce(importe,0))
					from RHLiqIngresos a
						inner join DDConceptosEmpleado b
						on a.DLlinea = b.DLlinea and a.CIid = b.CIid
					inner join CIncidentes c
						on b.CIid = c.CIid and a.Ecodigo = c.Ecodigo
					where a.DEid = #EmpleadosAjusteAnual#.DEid
		  				and a.Ecodigo = #session.Ecodigo#
                        and c.CIcodigo in ('12','13','14')
					group by a.DEid)<!---select coalesce(Round(SUM(importe),0),0) 
 					from RHLiqIngresos rhli inner join CIncidentes ci on ci.CIid = rhli.CIid
 					where rhli.DEid = #EmpleadosAjusteAnual#.DEid and rhli.CIid in (select CIid from CIncidentes where Ecodigo = #session.Ecodigo# and CIcodigo in ('12','13','14')))--->
</cfquery>

<cfquery name="rsSelectDEid" datasource="#Session.DSN#">
	select DEid from #EmpleadosAjusteAnual#
</cfquery>

<cfloop query = "rsSelectDEid">
<cfquery name="rsDetalleRHLiquidacionPersonal" datasource="#session.DSN#">
	select	rhta.RHTdesc, dle.DLfvigencia as DLfechaaplic, eve.EVfantig, dle.DEid
	 from DLaboralesEmpleado  dle
	  inner join RHTipoAccion rhta
		on  dle.Ecodigo = rhta.Ecodigo
		and dle.RHTid = rhta.RHTid
	  <!---inner join RHLiquidacionPersonal rhlp on dle.DLlinea = rhlp.DLlinea--->
	  inner join EVacacionesEmpleado eve
	    on  dle.DEid = eve.DEid 
	where dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and rhta.RHTcodigo = '12'
		and dle.DEid = #rsSelectDEid.DEid#
</cfquery>

<cfif isdefined('rsDetalleRHLiquidacionPersonal') and rsDetalleRHLiquidacionPersonal.RecordCount GT 0>
<cfset ylaborados = DateDiff('yyyy',rsDetalleRHLiquidacionPersonal.EVfantig,rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
<cfset mlaborados = DateDiff('m',DateAdd('yyyy',ylaborados,rsDetalleRHLiquidacionPersonal.EVfantig),rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
<cfif mlaborados GTE 6>
	<cfset ylaborados = ylaborados + 1>
</cfif>
<cfelse>
	<cfset ylaborados = 0>
</cfif>
<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo44 = #ylaborados#
    where DEid = #rsSelectDEid.DEid#
</cfquery>
</cfloop>

<cf_dbtemp name = "Liquidacion" datasource = "#session.DSN#" returnvariable = "Liquidacion"> 
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AniosLaborados"		type = "int"			mandatory = "no">
            <cf_dbtempcol name = "Monto90"				type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoGravado"		type = "money"			mandatory = "no">
</cf_dbtemp>

<cfquery name="insLiquidacion" datasource="#session.DSN#">
	insert into #Liquidacion# (DEid,Acumulado)
     select a.DEid,sum(a.importe)
				from RHLiqIngresos a
					inner join DDConceptosEmpleado b
						on a.DLlinea = b.DLlinea and a.CIid = b.CIid
					inner join CIncidentes c
					on b.CIid = c.CIid and a.Ecodigo = c.Ecodigo
				where
		  			a.Ecodigo = #session.Ecodigo#
					and c.CIcodigo in ('12','13','14')
				group by a.DEid	
</cfquery>

<cfquery name="rsSelectDEid" datasource="#session.DSN#">
     select DEid from #Liquidacion#
</cfquery>

<cfloop query="rsSelectDEid">
<cfquery name="rsSelectSalario" datasource="#session.dsn#">
			select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #rsSelectDEid.DEid#
				and sm.SZEhasta  = (select max(s.SZEhasta) 
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid	
											and s.SZEestado = 1)		
</cfquery>     

<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
	<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
<cfelse>
	<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
</cfif>
            
<cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
	update #Liquidacion# 
    set SalarioMinimo = #SZEsalarioMinimo#
    where DEid = #rsSelectDEid.DEid#                
</cfquery>

<cfquery name="rsAniosLab" datasource="#session.DSN#">
	update #Liquidacion#
    set AniosLaborados = (select Campo44 from #EmpleadosAjusteAnual# where DEid = #rsSelectDEid.DEid# )
    where DEid = #rsSelectDEid.DEid#     
</cfquery>  

<cfquery name="rsMonto90" datasource="#session.DSN#">
	update #Liquidacion#
    set Monto90 =  ((AniosLaborados * 90) * SalarioMinimo)   
</cfquery>          
      
<cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
 	update #Liquidacion# 
    set AcumuladoExento = coalesce((select case when Acumulado > (Monto90) then (Monto90)
                		   else Acumulado
                           end from #Liquidacion#
    			   		   where DEid = #rsSelectDEid.DEid#),0)  
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
 	update #Liquidacion# 
    set AcumuladoGravado = coalesce((select case when Acumulado > (Monto90) then (Acumulado-AcumuladoExento)
                			else 0.00
                            end from #Liquidacion#
    						where DEid = #rsSelectDEid.DEid#),0)
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo45 = (select AcumuladoExento from #Liquidacion# where DEid = #rsSelectDEid.DEid#)
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo46 = (select AcumuladoGravado from #Liquidacion# where DEid = #rsSelectDEid.DEid#)
    where DEid = #rsSelectDEid.DEid#
</cfquery>
</cfloop>


         
<!---<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo45 = (select SUM(coalesce(a.RHLIexento,0)) as RHLIexento
				from RHLiqIngresos a
					inner join DDConceptosEmpleado b
						on a.DLlinea = b.DLlinea and a.CIid = b.CIid
					inner join CIncidentes c
					on b.CIid = c.CIid and a.Ecodigo = c.Ecodigo
				where a.DEid = #EmpleadosAjusteAnual#.DEid
		  			and a.Ecodigo = #session.Ecodigo#
					and c.CIcodigo in ('12','13','14')
				group by a.DEid)<!---(select RHLFLtExentoF
				   from RHLiqFL rhlfl inner join RHLiquidacionPersonal rhlp on rhlfl.DLlinea= rhlp.DLlinea
				   inner join DLaboralesEmpleado dle on dle.DLlinea = rhlp.DLlinea
						inner join RHTipoAccion rhta on rhta.RHTid = dle.RHTid and dle.Ecodigo = rhta.Ecodigo
				   where rhlp.Ecodigo = #session.Ecodigo#  and rhlp.DEid = #EmpleadosAjusteAnual#.DEid
	               		and rhta.RHTcodigo = '12')---><!--- (select coalesce(Round(SUM(RHLIexento),0),0) 
 					from RHLiqIngresos rhli inner join CIncidentes ci on ci.CIid = rhli.CIid
 					where rhli.DEid = #EmpleadosAjusteAnual#.DEid and rhli.CIid in (select CIid from CIncidentes where Ecodigo = #session.Ecodigo# and CIcodigo in ('12','13','14')))--->
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo46 = (select SUM(coalesce(a.RHLIgrabado,0))
				from RHLiqIngresos a
					inner join DDConceptosEmpleado b
						on a.DLlinea = b.DLlinea and a.CIid = b.CIid
					inner join CIncidentes c
					on b.CIid = c.CIid and a.Ecodigo = c.Ecodigo
				where a.DEid = #EmpleadosAjusteAnual#.DEid
		  			and a.Ecodigo = 10
					and c.CIcodigo in ('12','13','14')
				group by a.DEid)<!---(select RHLFLtGrabadoF
				   from RHLiqFL rhlfl inner join RHLiquidacionPersonal rhlp on rhlfl.DLlinea= rhlp.DLlinea
				   inner join DLaboralesEmpleado dle on dle.DLlinea = rhlp.DLlinea
						inner join RHTipoAccion rhta on rhta.RHTid = dle.RHTid and dle.Ecodigo = rhta.Ecodigo
				   where rhlp.Ecodigo = #session.Ecodigo# and rhlp.DEid = #EmpleadosAjusteAnual#.DEid
	               		and rhta.RHTcodigo = '12'
	               		)---><!---(select coalesce(Round(SUM(RHLIgrabado),0),0) 
 				   from RHLiqIngresos rhli inner join CIncidentes ci on ci.CIid = rhli.CIid
                   where rhli.DEid = #EmpleadosAjusteAnual#.DEid and rhli.CIid in (select CIid from CIncidentes where Ecodigo = #session.Ecodigo# and CIcodigo in ('12','13','14')))--->
</cfquery>--->

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo47 = (select RHLFLsalarioMensual
				   from RHLiqFL rhlfl inner join RHLiquidacionPersonal rhlp on rhlfl.DLlinea= rhlp.DLlinea
				   inner join DLaboralesEmpleado dle on dle.DLlinea = rhlp.DLlinea
						inner join RHTipoAccion rhta on rhta.RHTid = dle.RHTid and dle.Ecodigo = rhta.Ecodigo
				   where rhlp.Ecodigo = #session.Ecodigo# and rhlp.DEid = #EmpleadosAjusteAnual#.DEid
	               		and rhta.RHTcodigo = '12')<!---(select DLsalario
				   from RHLiquidacionPersonal rhlp inner join DLaboralesEmpleado dle on dle.DLlinea = rhlp.DLlinea
						inner join RHTipoAccion rhta on rhta.RHTid = dle.RHTid and dle.Ecodigo = rhta.Ecodigo
				   where rhlp.Ecodigo = #session.Ecodigo# and rhlp.DEid = #EmpleadosAjusteAnual#.DEid
	               		and rhta.RHTcodigo = '12')--->
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo48 = (select RHLFLisptSalario
				   from RHLiqFL rhlfl inner join RHLiquidacionPersonal rhlp on rhlfl.DLlinea= rhlp.DLlinea
				   inner join DLaboralesEmpleado dle on dle.DLlinea = rhlp.DLlinea
						inner join RHTipoAccion rhta on rhta.RHTid = dle.RHTid and dle.Ecodigo = rhta.Ecodigo
				   where rhlp.Ecodigo = #session.Ecodigo#  and rhlp.DEid = #EmpleadosAjusteAnual#.DEid
	               		and rhta.RHTcodigo = '12')<!---(select top 1 ROUND(SErenta,0) from HSalarioEmpleado where DEid = #EmpleadosAjusteAnual#.DEid
					order by RCNid desc)--->
    where Campo30 = 1
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo49 = 0
    where Campo30 = 1
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo50 = (select RHLFLisptF
				   from RHLiqFL rhlfl inner join RHLiquidacionPersonal rhlp on rhlfl.DLlinea= rhlp.DLlinea
				   inner join DLaboralesEmpleado dle on dle.DLlinea = rhlp.DLlinea
						inner join RHTipoAccion rhta on rhta.RHTid = dle.RHTid and dle.Ecodigo = rhta.Ecodigo
				   where rhlp.Ecodigo = #session.Ecodigo# and rhlp.DEid = #EmpleadosAjusteAnual#.DEid
	               		and rhta.RHTcodigo = '12')
    where Campo30 = 1
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo51 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo52 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo53 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo54 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo55 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo56 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo57 = 0
</cfquery>

<cfif isdefined('form.Campo58')>
	<cfquery name="rsCampo58G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo58#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo58E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo58#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo58 = 
    			  (select(<cfif isdefined("rsCampo58G") and rsCampo58G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo58G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                          <cfelse> 0 </cfif>
					+
						(select RHAAAcumuladoSalario from RHAjusteAnualAcumulado rhaas
							inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaas.RHAAid 
							where rhaas.DEid = #EmpleadosAjusteAnual#.DEid and rhaa.Ecodigo = #session.Ecodigo#
							 and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)))
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo59 = <cfif isdefined("rsCampo58E") and rsCampo58E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo58E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                          <cfelse> 0 </cfif> <!---(select RHAAAcumuladoExento
                   from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
                   where rhaaa.DEid = #EmpleadosAjusteAnual#.DEid
	                   and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAjusteAnualId.RHAAid#">
	                   and rhaa.Ecodigo = #session.Ecodigo#)--->
</cfquery>


<cfquery name="rsSelectDEid" datasource="#Session.DSN#">
	select DEid from #EmpleadosAjusteAnual#
</cfquery> 

<cf_dbtemp name = "Aguinaldo" datasource = "#session.DSN#" returnvariable = "Aguinaldo">
    		<cf_dbtempcol name = "RHAAid"				type = "varchar(50)" 	mandatory = "no"> 
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
           	<cf_dbtempcol name = "AcumuladoGravado"		type = "money"			mandatory = "no">
</cf_dbtemp>

<cfif isdefined('form.Campo60')>
<cfloop query = "rsSelectDEid">
<cfquery name="rsInsertAguinaldo" datasource="#session.DSN#">
	insert into #Aguinaldo# (RHAAid,DEid,Acumulado)
	select drha.RHAAid,drha.DEid,coalesce(sum(DRHAAAcumulado),0.00)
	from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
    		inner join CIncidentes ci on  drha.CIid = ci.CIid
	where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
	  	and rhaa.Ecodigo = #session.Ecodigo#      
	  	and ci.CIid in (#form.Campo60#)
	  	and drha.DEid = #rsSelectDEid.DEid#
	group by drha.RHAAid,drha.DEid
</cfquery>
            
<cfquery name="rsSelectSalario" datasource="#session.DSN#">
	select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
		from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where de.DEid = #rsSelectDEid.DEid#
				and sm.SZEhasta  = (select max(s.SZEhasta) 
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid	
											and s.SZEestado = 1)		
</cfquery>     

<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
	<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
<cfelse>
	<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
</cfif>
            
<cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
	update #Aguinaldo# 
    set SalarioMinimo = #SZEsalarioMinimo#
    where DEid = #rsSelectDEid.DEid#             
</cfquery>

<cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
 	update #Aguinaldo#  
    set AcumuladoExento = coalesce((select case when Acumulado > (30*SalarioMinimo) then (30*SalarioMinimo)
                		   else Acumulado
                           end from #Aguinaldo#
    			   		   where DEid = #rsSelectDEid.DEid#),0)  
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
 	update #Aguinaldo# 
    set AcumuladoGravado = coalesce((select case when Acumulado > (30*SalarioMinimo) then (Acumulado-AcumuladoExento)
                			else 0.00
                            end from #Aguinaldo#
    						where DEid = #rsSelectDEid.DEid#),0)
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo60 = (select AcumuladoGravado from #Aguinaldo# where DEid = #rsSelectDEid.DEid#)
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo61 = (select AcumuladoExento from #Aguinaldo# where DEid = #rsSelectDEid.DEid#)
    where DEid = #rsSelectDEid.DEid#
</cfquery>

</cfloop>

<!---<cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
	select * from #Aguinaldo# 
    where DEid = 327             
</cfquery>

<cf_dump var = "#rsUpdateSalarioM#">         
   
--->
<cfelse>
<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo60 = 0
   <!--- where DEid = #rsSelectDEid.DEid#--->
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo61 = 0
    <!---where DEid = #rsSelectDEid.DEid#--->
</cfquery>
</cfif>

<cfif isdefined('form.Campo62')>
	<cfquery name="rsCampo62G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo62#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo62E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo62#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo62 = <cfif isdefined("rsCampo62G") and rsCampo62G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo62G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo63 = <cfif isdefined("rsCampo62E") and rsCampo62E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo62E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo64')>
	<cfquery name="rsCampo64G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo64#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo64E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo64#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo64 = <cfif isdefined("rsCampo64G") and rsCampo64G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo64G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo65 = <cfif isdefined("rsCampo64E") and rsCampo64E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo64E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cf_dbtemp name = "PrimaVacacional" datasource = "#session.DSN#" returnvariable = "PrimaVacacional">
    		<cf_dbtempcol name = "RHAAid"				type = "varchar(50)" 	mandatory = "no"> 
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoGravado"		type = "money"			mandatory = "no">
</cf_dbtemp>

<cfif isdefined('form.Campo66') and form.Campo66 NEQ -1>
<cfloop query = "rsSelectDEid">
<cfquery name="rsInsertPVacacional" datasource="#session.DSN#">
             insert into #PrimaVacacional# (RHAAid,DEid,Acumulado)
             select drha.RHAAid,DEid,coalesce(sum(DRHAAAcumulado),0.00)
			 from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
             	inner join CIncidentes ci on  drha.CIid = ci.CIid
			 where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
	  			and rhaa.Ecodigo = #session.Ecodigo#
	  			and ci.CIid in (#form.Campo66#)
	  			and DEid = #rsSelectDEid.DEid#
				group by drha.RHAAid,DEid
            </cfquery>
            
            <cfquery name="rsSelectSalario" datasource="#session.dsn#">
			select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #rsSelectDEid.DEid#
				and sm.SZEhasta  = (select max(s.SZEhasta) 
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid	
											and s.SZEestado = 1)		
			</cfquery>     

			<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
				<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
			<cfelse>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
			</cfif>
            
            <cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
            	update #PrimaVacacional# 
                set SalarioMinimo = #SZEsalarioMinimo#
                where DEid = #rsSelectDEid.DEid#                
            </cfquery>
            
<cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
 	update #PrimaVacacional# 
    set AcumuladoExento = coalesce((select case when Acumulado > (15*SalarioMinimo) then (15*SalarioMinimo)
                		   else Acumulado
                           end from #PrimaVacacional#
    			   		   where DEid = #rsSelectDEid.DEid#),0)  
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
 	update #PrimaVacacional# 
    set AcumuladoGravado = coalesce((select case when Acumulado > (15*SalarioMinimo) then (Acumulado-AcumuladoExento)
                			else 0.00
                            end from #PrimaVacacional#
    						where DEid = #rsSelectDEid.DEid#),0)
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo66 = (select AcumuladoGravado from #PrimaVacacional# where DEid = #rsSelectDEid.DEid#)
    where DEid = #rsSelectDEid.DEid#
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo67 = (select AcumuladoExento from #PrimaVacacional# where DEid = #rsSelectDEid.DEid#)
    where DEid = #rsSelectDEid.DEid#
</cfquery>
</cfloop>

<cfelse>
<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo66 = 0
    <!---where DEid = #rsSelectDEid.DEid#--->
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo67 = 0
   <!--- where DEid = #rsSelectDEid.DEid#--->
</cfquery>
	      
</cfif>

<cfif isdefined('form.Campo68')>
	<cfquery name="rsCampo68G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo68#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo68E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo68#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo68 = <cfif isdefined("rsCampo68G") and rsCampo68G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo68G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo69 = <cfif isdefined("rsCampo68E") and rsCampo68E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo68E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cf_dbtemp name = "PTU" datasource = "#session.DSN#" returnvariable = "PTU">
    		<cf_dbtempcol name = "RHAAid"				type = "varchar(50)" 	mandatory = "no"> 
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoGravado"		type = "money"			mandatory = "no">
</cf_dbtemp>

<cfif isdefined('form.Campo70') and form.Campo70 NEQ -1>
<cfloop query = "rsSelectDEid">
<cfquery name="rsInsertPVacacional" datasource="#session.DSN#">
             insert into #PTU# (RHAAid,DEid,Acumulado)
             select drha.RHAAid,DEid,coalesce(sum(DRHAAAcumulado),0.00)
			 from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
             				inner join CIncidentes ci on  drha.CIid = ci.CIid
			 where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
	  			and rhaa.Ecodigo = #session.Ecodigo#
               	and ci.CIid in (#form.Campo70#)
	  			and DEid = #rsSelectDEid.DEid#
				group by drha.RHAAid,DEid
            </cfquery>
            
            <cfquery name="rsSelectSalario" datasource="#session.dsn#">
			select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #rsSelectDEid.DEid#
				and sm.SZEhasta  = (select max(s.SZEhasta) 
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid	
											and s.SZEestado = 1)		
			</cfquery>     

			<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
				<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
			<cfelse>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
			</cfif>
            
            <cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
            	update #PTU# 
                set SalarioMinimo = #SZEsalarioMinimo#
                where DEid = #rsSelectDEid.DEid#                
            </cfquery>
            
            <cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
 				update #PTU#
    			set AcumuladoExento = coalesce((select case when Acumulado > (15*SalarioMinimo) then (15*SalarioMinimo)
                		   else Acumulado
                           end from #PTU#
    			   		   where DEid = #rsSelectDEid.DEid#),0)  
    			where DEid = #rsSelectDEid.DEid#
			</cfquery>

			<cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
 				update #PTU#
    			set AcumuladoGravado = coalesce((select case when Acumulado > (15*SalarioMinimo) then (Acumulado-AcumuladoExento)
                			else 0.00
                            end from #PTU#
    						where DEid = #rsSelectDEid.DEid#),0)
    			where DEid = #rsSelectDEid.DEid#
			</cfquery>

			<cfquery name="rsUpdReporte" datasource="#session.DSN#">
				update #EmpleadosAjusteAnual# 
    			set Campo70 = (select AcumuladoGravado from #PTU# where DEid = #rsSelectDEid.DEid#)
    			where DEid = #rsSelectDEid.DEid#
			</cfquery>

			<cfquery name="rsUpdReporte" datasource="#session.DSN#">
				update #EmpleadosAjusteAnual# 
    			set Campo71 = (select AcumuladoExento from #PTU# where DEid = #rsSelectDEid.DEid#)
   				where DEid = #rsSelectDEid.DEid#
			</cfquery>
</cfloop>
<cfelse>
<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo70 = 0
    <!---where DEid = #rsSelectDEid.DEid#--->
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo71 = 0
    <!---where DEid = #rsSelectDEid.DEid#--->
</cfquery>
</cfif>
    
<cfif isdefined('form.Campo72')>
	<cfquery name="rsCampo72G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo72#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo72E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo72#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo72 = <cfif isdefined("rsCampo72G") and rsCampo72G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo72G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo73 = <cfif isdefined("rsCampo72E") and rsCampo72E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo72E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo74')>
	<cfquery name="rsCampo74G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo74#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo74E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo74#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo74 = <cfif isdefined("rsCampo74G") and rsCampo74G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo74G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo75 = <cfif isdefined("rsCampo74E") and rsCampo74E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo74E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo76')>
	<cfquery name="rsCampo76G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo76#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo76E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo76#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo76 =  <cfif isdefined("rsCampo76G") and rsCampo76G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo76G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo77 = <cfif isdefined("rsCampo76E") and rsCampo76E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo76E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo78')>
	<cfquery name="rsCampo78G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo78#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo78E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo78#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>


<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo78 = <cfif isdefined("rsCampo78G") and rsCampo78G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo78G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo79 = <cfif isdefined("rsCampo78E") and rsCampo78E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo78E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo80')>
	<cfquery name="rsCampo80G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo80#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo80E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo78#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo80 = <cfif isdefined("rsCampo80G") and rsCampo80G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo80G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo81 = <cfif isdefined("rsCampo80E") and rsCampo80E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo80E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery> 

<cfif isdefined('form.Campo82')>
	<cfquery name="rsCampo82G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo82#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo82E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo82#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo82 = <cfif isdefined("rsCampo82G") and rsCampo82G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo82G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                  <cfelse> 0 </cfif>
</cfquery> 

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo83 = <cfif isdefined("rsCampo82E") and rsCampo82E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo82E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                   <cfelse> 0 </cfif>
</cfquery> 

<cfif isdefined('form.Campo84')>
	<cfquery name="rsCampo84G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo84#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo84E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo84#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo84 = <cfif isdefined("rsCampo84G") and rsCampo84G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo84G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                  <cfelse> 0 </cfif>
</cfquery> 

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo85 = <cfif isdefined("rsCampo84E") and rsCampo84E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo84E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                  <cfelse> 0 </cfif>
</cfquery> 

<cfif isdefined('form.Campo86')>
	<cfquery name="rsCampo86G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo86#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo86E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo86#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo86 = <cfif isdefined("rsCampo86G") and rsCampo86G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo86G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                  <cfelse> 0 </cfif>
</cfquery>  

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo87 = <cfif isdefined("rsCampo86E") and rsCampo86E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo86E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                  <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo88')>
	<cfquery name="rsCampo88G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo88#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo88E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo88#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo88 = <cfif isdefined("rsCampo88G") and rsCampo88G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo88G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                  <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo89 = <cfif isdefined("rsCampo88E") and rsCampo88E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo88E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                  <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo90')>
	<cfquery name="rsCampo90G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo90#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo90E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo90#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo90 = <cfif isdefined("rsCampo90G") and rsCampo90G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo90G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                  <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo91 = <cfif isdefined("rsCampo90E") and rsCampo90E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo90E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo92')>
	<cfquery name="rsCampo92G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo92#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo92E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo92#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo92 = <cfif isdefined("rsCampo92G") and rsCampo92G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo92G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo93 = <cfif isdefined("rsCampo92E") and rsCampo92E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo92E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo94')>
	<cfquery name="rsCampo94G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo94#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo94E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo94#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo94 = <cfif isdefined("rsCampo94G") and rsCampo94G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo94G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo95 = <cfif isdefined("rsCampo94E") and rsCampo94E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo94E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo96')>
	<cfquery name="rsCampo96G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo96#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo96E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo96#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo96 = <cfif isdefined("rsCampo96G") and rsCampo96G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo96G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo97 = <cfif isdefined("rsCampo96E") and rsCampo96G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo96E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo98')>
	<cfquery name="rsCampo98G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo98#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo98E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo98#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo98 = <cfif isdefined("rsCampo98G") and rsCampo98G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo98G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo99 = <cfif isdefined("rsCampo98E") and rsCampo98E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo98E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo100')>
	<cfquery name="rsCampo100G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo100#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo100E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo100#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>
 
 <cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo100 = <cfif isdefined("rsCampo100G") and rsCampo100G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo100G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo101 = <cfif isdefined("rsCampo100E") and rsCampo100E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo100E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo102')>
	<cfquery name="rsCampo102G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo102#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo102E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo102#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo102 = <cfif isdefined("rsCampo100G") and rsCampo100G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo100G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo103 = <cfif isdefined("rsCampo100E") and rsCampo100E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo100E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo104')>
	<cfquery name="rsCampo104G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo104#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo104E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo104#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo104 = <cfif isdefined("rsCampo104G") and rsCampo104G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo104G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo105 = <cfif isdefined("rsCampo104E") and rsCampo104E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo104E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo106')>
	<cfquery name="rsCampo106G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo106#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo106E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo106#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo106 =  <cfif isdefined("rsCampo106G") and rsCampo106G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo106G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>
<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo107 = <cfif isdefined("rsCampo106E") and rsCampo106E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo106E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo108')>
	<cfquery name="rsCampo108G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo108#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo108E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo108#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo108 = <cfif isdefined("rsCampo108G") and rsCampo108G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo108G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo109 = <cfif isdefined("rsCampo108E") and rsCampo108E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo108E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo110')>
	<cfquery name="rsCampo110G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo110#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo110E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo110#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo110 = <cfif isdefined("rsCampo110G") and rsCampo110G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo110G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo111 = <cfif isdefined("rsCampo110E") and rsCampo110E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo110E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfif isdefined('form.Campo112')>
	<cfquery name="rsCampo112G" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo112#) 
			and CInorenta = 0 
    </cfquery>
    
    <cfquery name="rsCampo112E" datasource="#session.DSN#">
			select CIid from CIncidentes 
			where Ecodigo = #session.Ecodigo# and CIid in (#form.Campo112#) 
			and CInorenta = 1 
    </cfquery>    
</cfif>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo112 = <cfif isdefined("rsCampo112G") and rsCampo112G.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo112G.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo113 = <cfif isdefined("rsCampo112E") and rsCampo112E.RecordCount GT 0 >
                  		  (select coalesce(sum(drhaa.DRHAAAcumulado),0) from DRHAjusteAnual drhaa 
						   		inner join CIncidentes ci on  drhaa.CIid = ci.CIid
								inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				  		   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
								and ci.CIid in (#ValueList(rsCampo112E.CIid)#)
								and ci.Ecodigo= #session.Ecodigo#
								and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
                 <cfelse> 0 </cfif>
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo114 = coalesce((select RHAAAcumuladoSG
                   from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
                   where rhaaa.DEid = #EmpleadosAjusteAnual#.DEid
	                   and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
	                   and rhaa.Ecodigo = #session.Ecodigo#),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo115 = coalesce((select RHAAAcumuladoExento
                   from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
                   where rhaaa.DEid = #EmpleadosAjusteAnual#.DEid
	                   and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
	                   and rhaa.Ecodigo = #session.Ecodigo#),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo116 = coalesce((select rhaaa.RHAAAcumuladoRenta
					from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
					where rhaa.Ecodigo = #session.Ecodigo# and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
						and rhaaa.DEid = #EmpleadosAjusteAnual#.DEid),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo117 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo118 =  coalesce((select rhaaa.RHAAAcumuladoISPT 
					from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
					where rhaa.Ecodigo =  #session.Ecodigo# and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
						and rhaaa.RHAAAcumuladoISPT > 0
						and rhaaa.DEid = #EmpleadosAjusteAnual#.DEid),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo119 = 0
</cfquery>

<!---<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo120 = 0
</cfquery>--->

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo121 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo122 = coalesce((select sum(drhaa.DRHAAAcumulado) from DRHAjusteAnual drhaa inner join CIncidentes ci on  drhaa.CIid = ci.CIid
						inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
						and ci.CIcodigo in ('VD','VDADM')
						and ci.Ecodigo= #session.Ecodigo#
						and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo123 = coalesce((select sum(drhaa.DRHAAAcumulado) from DRHAjusteAnual drhaa inner join CIncidentes ci on  drhaa.CIid = ci.CIid
						inner join RHAjusteAnual rhaa on rhaa.RHAAid = drhaa.RHAAid and rhaa.Ecodigo = ci.Ecodigo
				   where drhaa.DEid = #EmpleadosAjusteAnual#.DEid
						and ci.CIcodigo in ('VD','VDADM')
						and ci.Ecodigo= #session.Ecodigo#
						and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo124 = coalesce(Campo114 + Campo115,0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo125 = 0
</cfquery>

<cf_dbtemp name = "Subsidio" datasource = "#session.DSN#" returnvariable = "Subsidio">
        <cf_dbtempcol name = "DEid" 			type = "int"			mandatory = "no">
        <cf_dbtempcol name = "Monto"			type = "money"			mandatory = "no">
</cf_dbtemp>

<cfquery name="rsInsertSub" datasource="#session.DSN#">
	insert into #Subsidio# (DEid,Monto)
    (select a.DEid,a.DCvalor
 	from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion c 
 	where a.DEid = b.DEid
	 and c.Ecodigo = b.Ecodigo
	 and c.TDid = b.TDid
     and RCNid in (select CPid from CalendarioPagos
                   where Ecodigo = #session.Ecodigo#
						and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsAjusteAnualId.RHAAfecharige#">
						and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsAjusteAnualId.RHAAfechavence#">
						and CPtipo = 0)
	<!---and b.TDid  in (21)--->
	and c.Ecodigo = #session.Ecodigo#
	and a.DCvalor < 0
 	group by a.DEid,a.DCvalor,a.RCNid)
    union
   (select a.DEid,a.DCvalor
 	from DeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion c 
 	where a.DEid = b.DEid
	 and c.Ecodigo = b.Ecodigo
	 and c.TDid = b.TDid
     and RCNid in (select CPid from CalendarioPagos
                   where Ecodigo = #session.Ecodigo#
						and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsAjusteAnualId.RHAAfecharige#">
						and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsAjusteAnualId.RHAAfechavence#">
						and CPtipo = 0)
	<!---and b.TDid  in (21)--->
	and c.Ecodigo = #session.Ecodigo#
	and a.DCvalor < 0
 	group by a.DEid,a.DCvalor,a.RCNid)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo126 = coalesce((select sum(Monto) * -1 from #Subsidio#
					where DEid = #EmpleadosAjusteAnual#.DEid),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo127 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo128 = coalesce((select RHAAAcumuladoISR
                   from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
                   where rhaaa.DEid = #EmpleadosAjusteAnual#.DEid
	                   and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
	                   and rhaa.Ecodigo = #session.Ecodigo#),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo129 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo130 = 0
</cfquery>
<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo132 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo133 = 0
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo134 = coalesce((select rhaaa.RHAAAcumuladoSubsidio
					from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
					where rhaa.Ecodigo = #session.Ecodigo# and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
						and rhaaa.DEid = #EmpleadosAjusteAnual#.DEid),0)
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set Campo131 = case when(Campo128-Campo134) > 0 then (Campo128-Campo134)
    					when(Campo128-Campo134) < 0 then 0
                   end
</cfquery>

<cfquery name="rsUpdReporte" datasource="#session.DSN#">
	update #EmpleadosAjusteAnual# 
    set txt2O = (coalesce(Campo131,0) - coalesce(Campo132,0))
</cfquery>

<cfquery name="rsReporte" datasource="#Session.DSN#">
	select * from #EmpleadosAjusteAnual#
    order by Campo5,Campo6,Campo7
</cfquery>

<!---<cf_dump var = "#rsReporte#">--->

<!---<cfoutput>--->
<table cellspacing="0" cellpadding="0">
	<cfif isdefined("rsReporte") and rsReporte.RecordCount NEQ 0>
        <tr>
            <td align="center" colspan="100%">
                <input type="button" name="btnGenerar" value="#BTN_GenerarArchivoDeTexto#" class="btnAplicar" onClick="javascript: funcGenerar();">
            </td>
        </tr>
    </cfif>
    <cfset hilera =''>
    <cfset linea = 1>    
    <cfloop query="rsReporte">
    	<cfif linea GT 1>
			<cfset hilera = hilera & '#chr(13)##chr(10)#'>
		</cfif>
    	<tr>
    		<td>
        		<cfif len(#rsReporte.Campo1#)>
        			#RepeatString("0",2-len(trim(rsReporte.Campo1)))&'#rsReporte.Campo1#'#|
                	<cfset hilera= hilera & RepeatString("0",2-len(trim(rsReporte.Campo1)))&'#rsReporte.Campo1#' &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>    
        	</td>
        	<td>
            	<cfif len(#rsReporte.Campo2#)>
        			#RepeatString("0",2-len(trim(rsReporte.Campo2)))&'#rsReporte.Campo2#'#|
                	<cfset hilera= hilera & RepeatString("0",2-len(trim(rsReporte.Campo2)))&'#rsReporte.Campo2#' &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif> 
        	</td>
        	<td>
            	<cfif len(#rsReporte.Campo3#)>
        			#trim(rsReporte.Campo3)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo3)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>           
        	</td>
        	<td>
            	<cfif len(#rsReporte.Campo4#)>
        			#trim(rsReporte.Campo4)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo4)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td>
        	<td>
            	<cfif len(#rsReporte.Campo5#)>
        			#trim(rsReporte.Campo5)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo5)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td>
        	<td>
            	<cfif len(#rsReporte.Campo6#)>
        			#trim(rsReporte.Campo6)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo6)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td>
       		<td>
            	<cfif len(#rsReporte.Campo7#)>
        			#trim(rsReporte.Campo7)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo7)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td> 
            <td>
            	<cfif len(#rsReporte.Campo8#)>
                    #trim(rsReporte.Campo8)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo8)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td>
            <td>
            	<cfif len(#rsReporte.Campo9#)>
        			#trim(rsReporte.Campo9)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo9)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td>  
            <td>
            	<cfif len(#rsReporte.Campo10#)>
        			#trim(rsReporte.Campo10)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo10)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td> 
            <td>
            	<cfif len(#rsReporte.Campo11#)>
        			#trim(rsReporte.Campo11)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo11)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td> 
             <td>
            	<cfif len(#rsReporte.Campo12#)>
        			#trim(rsReporte.Campo12)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo12)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td> 
            <td>
            	<cfif len(#rsReporte.Campo13#)>
        			#trim(rsReporte.Campo13)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo13)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td>
            <td>
            	<cfif len(#rsReporte.Campo14#)>
        			#trim(rsReporte.Campo14)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo14)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
        	</td>
            <td>
            	<cfif len(#rsReporte.Campo15#)>
        			#trim(rsReporte.Campo15)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo15)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo16#)>
        			#trim(rsReporte.Campo16)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo16)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo17#)>
        			#trim(rsReporte.Campo17)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo17)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo18#)>
        			#trim(rsReporte.Campo18)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo18)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo19#)>
        			#trim(rsReporte.Campo19)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo19)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo20#)>
        			#trim(rsReporte.Campo20)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo20)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo21#)>
        			#trim(rsReporte.Campo21)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo21)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo22#)>
        			#trim(rsReporte.Campo22)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo22)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo23#)>
        			#trim(rsReporte.Campo23)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo23)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo24#)>
        			#trim(rsReporte.Campo24)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo24)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo25#)>
        			#trim(rsReporte.Campo25)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo25)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
                       <td>
            	<cfif len(#rsReporte.Campo26#)>
        			#trim(rsReporte.Campo26)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo26)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo27#)>
        			#trim(rsReporte.Campo27)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo27)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
           	<td>
            	<cfif len(#rsReporte.Campo28#)>
        			#trim(rsReporte.Campo28)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo28)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo29#)>
        			#trim(rsReporte.Campo29)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo29)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo30#)>                
        			#trim(rsReporte.Campo30)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo30)# &"|">
				<cfelse>
                	2|
                    <cfset hilera= hilera & "2|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo31#)>
        			#trim(rsReporte.Campo31)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo31)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo32#)>
        			#trim(rsReporte.Campo32)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo32)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<!---<cfif len(#rsReporte.Campo33#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo33)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo33)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<!---<cfif len(#rsReporte.Campo34#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo34)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo34)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<!---<cfif len(#rsReporte.Campo35#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo35)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo35)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<!---<cfif len(#rsReporte.Campo36#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo36)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo36)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<!---<cfif len(#rsReporte.Campo37#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo37)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo37)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
             <td>
            	<!---<cfif len(#rsReporte.Campo38#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo38)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo38)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
             <td>
            	<!---<cfif len(#rsReporte.Campo39#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo39)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo39)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
             <td>
            	<!---<cfif len(#rsReporte.Campo40#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo40)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo40)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
             <td>
            	<!---<cfif len(#rsReporte.Campo41#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo41)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo41)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
             <td>
            	<!---<cfif len(#rsReporte.Campo42#)>--->
                <cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo42)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo42)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo43)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo43)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo44)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo44)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo45)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo45)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo46)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo46)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo47)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo47)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo48)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo48)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo49)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo49)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo30#) and #rsReporte.Campo30# EQ 1>
        			#trim(rsReporte.Campo50)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo50)# &"|">
				<!---<cfelse>
                	|
                    <cfset hilera= hilera & "|">--->
                </cfif>
            </td>
            <!---<td>
            	<cfif len(#rsReporte.Campo51#)>
        			#trim(rsReporte.Campo51)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo51)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo52#)>
        			#trim(rsReporte.Campo52)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo52)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo53#)>
        			#trim(rsReporte.Campo53)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo53)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo54#)>
        			#trim(rsReporte.Campo54)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo54)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo55#)>
        			#trim(rsReporte.Campo55)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo55)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo56#)>
        			#trim(rsReporte.Campo56)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo56)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo57#)>
        			#trim(rsReporte.Campo57)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo57)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>--->
            <td>
            	<cfif len(#rsReporte.Campo58#)>
        			#trim(rsReporte.Campo58)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo58)# &"|">
				<cfelse>
                	|
                    <cfset hilera = hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo59#)>
        			#trim(rsReporte.Campo59)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo59)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo60#)>
        			#trim(rsReporte.Campo60)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo60)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<!---<cfthrow message="#rsReporte.Campo61#">--->
            	<cfif len(#rsReporte.Campo61#)>
        			#trim(rsReporte.Campo61)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo61)# &"|">
				<cfelse>
                	|
                    <cfset hilera = hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo62#)>
        			#trim(rsReporte.Campo62)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo62)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo63#)>
        			#trim(rsReporte.Campo63)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo63)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo64#)>
        			#trim(rsReporte.Campo64)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo64)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo65#)>
        			#trim(rsReporte.Campo65)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo65)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo66#)>
        			#trim(rsReporte.Campo66)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo66)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo67#)>
        			#trim(rsReporte.Campo67)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo67)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo68#)>
        			#trim(rsReporte.Campo68)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo68)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo69#)>
        			#trim(rsReporte.Campo69)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo69)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo70#)>
        			#trim(rsReporte.Campo70)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo70)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo71#)>
        			#trim(rsReporte.Campo71)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo71)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo72#)>
        			#trim(rsReporte.Campo72)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo72)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo73#)>
        			#trim(rsReporte.Campo73)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo73)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo74#)>
        			#trim(rsReporte.Campo74)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo74)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo75#)>
        			#trim(rsReporte.Campo75)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo75)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo76#)>
        			#trim(rsReporte.Campo76)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo76)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo77#)>
        			#trim(rsReporte.Campo77)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo77)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo78#)>
        			#trim(rsReporte.Campo78)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo78)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo79#)>
        			#trim(rsReporte.Campo79)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo79)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo80#)>
        			#trim(rsReporte.Campo80)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo80)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo81#)>
        			#trim(rsReporte.Campo81)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo81)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo82#)>
        			#trim(rsReporte.Campo82)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo82)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo83#)>
        			#trim(rsReporte.Campo83)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo83)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo84#)>
        			#trim(rsReporte.Campo84)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo84)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo85#)>
        			#trim(rsReporte.Campo85)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo85)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo86#)>
        			#trim(rsReporte.Campo86)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo86)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo87#)>
        			#trim(rsReporte.Campo87)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo87)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo88#)>
        			#trim(rsReporte.Campo88)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo88)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo89#)>
        			#trim(rsReporte.Campo89)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo89)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo90#)>
        			#trim(rsReporte.Campo90)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo90)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo91#)>
        			#trim(rsReporte.Campo91)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo91)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo92#)>
        			#trim(rsReporte.Campo92)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo92)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo93#)>
        			#trim(rsReporte.Campo93)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo93)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo94#)>
        			#trim(rsReporte.Campo94)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo94)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo95#)>
        			#trim(rsReporte.Campo95)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo95)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo96#)>
        			#trim(rsReporte.Campo96)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo96)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo97#)>
        			#trim(rsReporte.Campo97)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo97)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo98#)>
        			#trim(rsReporte.Campo98)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo98)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo99#)>
        			#trim(rsReporte.Campo99)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo99)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo100#)>
        			#trim(rsReporte.Campo100)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo100)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo101#)>
        			#trim(rsReporte.Campo101)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo101)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo102#)>
        			#trim(rsReporte.Campo102)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo102)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo103#)>
        			#trim(rsReporte.Campo103)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo103)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo104#)>
        			#trim(rsReporte.Campo104)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo104)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo105#)>
        			#trim(rsReporte.Campo105)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo105)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo106#)>
        			#trim(rsReporte.Campo106)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo106)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo107#)>
        			#trim(rsReporte.Campo107)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo107)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo108#)>
        			#trim(rsReporte.Campo108)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo108)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo109#)>
        			#trim(rsReporte.Campo109)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo109)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo110#)>
        			#trim(rsReporte.Campo110)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo110)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo111#)>
        			#trim(rsReporte.Campo111)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo111)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo112#)>
        			#trim(rsReporte.Campo112)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo112)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo113#)>
        			#trim(rsReporte.Campo113)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo113)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo114#)>
        			#trim(rsReporte.Campo114)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo114)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo115#)>
        			#trim(rsReporte.Campo115)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo115)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo116#)>
        			#trim(rsReporte.Campo116)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo116)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo117#)>
        			#trim(rsReporte.Campo117)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo117)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo118#)>
        			#trim(rsReporte.Campo118)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo118)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo119#)>
        			#trim(rsReporte.Campo119)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo119)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo120#)>
        			#trim(rsReporte.Campo120)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo120)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo121#)>
        			#trim(rsReporte.Campo121)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo121)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
			<td>
            	<cfif len(#rsReporte.Campo122#)>
        			#trim(rsReporte.Campo122)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo122)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
			<td>
            	<cfif len(#rsReporte.Campo123#)>
        			#trim(rsReporte.Campo123)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo123)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo124#)>
        			#trim(rsReporte.Campo124)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo124)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo125#)>
        			#trim(rsReporte.Campo125)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo125)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo126#)>
        			#trim(rsReporte.Campo126)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo126)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo127#)>
        			#trim(rsReporte.Campo127)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo127)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo128#)>
        			#trim(rsReporte.Campo128)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo128)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
           <td>
            	<cfif len(#rsReporte.Campo129#)>
        			#trim(rsReporte.Campo129)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo129)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo130#)>
        			#trim(rsReporte.Campo130)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo130)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo131#)>
        			#trim(rsReporte.Campo131)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo131)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo132#)>
        			#trim(rsReporte.Campo132)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo132)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
            <td>
            	<cfif len(#rsReporte.Campo133#)>
        			#trim(rsReporte.Campo133)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo133)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
             <td>
            	<cfif len(#rsReporte.Campo134#)>
        			#trim(rsReporte.Campo134)#|
                	<cfset hilera= hilera & #trim(rsReporte.Campo134)# &"|">
				<cfelse>
                	|
                    <cfset hilera= hilera & "|">
                </cfif>
            </td>
        </tr>
        <cfset hilera = REReplaceNoCase(hilera,'�','A',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'�','E',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'�','I',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'�','O',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'�','U',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'�','N',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'�','U',"all")>
		<cfset hilera = Ucase(hilera)>
        <cfset linea=linea + 1>
    </cfloop>   
    <cfset linea = linea - 1>     
</table>

<!---<script type="text/javascript">
	function funcGenerar(){
		location.href = 'DeclaracionInformativa_SQL.cfm?Generar=1&periodo=#Form.periodo#';
	}
</script>--->
<!---</cfoutput>--->




<!----================ GENERA EL ARCHIVO TXT ================---->
<cfif isdefined("form.GenerarTxt")>
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'DeclInformativa')>	
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=DeclaracionInformativa.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
<cfelseif isdefined("form.GenerarPdf")>
<!---<cf_dump var = #form#>--->
<!---<cfloop query="rsReporte">--->
<!---<cfset nomconst = 'constancia' & #rsReporte.DEid# >--->
<cfpdfform action="populate" source="C:/JRun4/servers/APHCenter/cfusion.ear/cfusion.war/rh/nomina/procesoanual/constancia.pdf"> 
        <cfpdfsubform name="formconstancia">
        	<cfpdfformparam name="Campo1" 		value="#RepeatString("0",2-len(trim(rsReporte.Campo1)))&'#rsReporte.Campo1#'#"/> 
            <cfpdfformparam name="Campo2" 		value="#RepeatString("0",2-len(trim(rsReporte.Campo2)))&'#rsReporte.Campo2#'#"/> 
            <cfpdfformparam name="txtPeriodo" 	value="#rsReporte.Periodo#"/>
            <cfpdfformparam name="txtAcumuladoEx" 	value="#rsReporte.AcumuladoEx#"/>
            <cfpdfformparam name="txtAcumuladoT" 	value="#rsReporte.AcumuladoT#"/>
            <cfpdfformparam name="txtAcumuladoGr" 	value="#rsReporte.AcumuladoGr#"/>
            <cfpdfformparam name="txtAcumuladoRenta" 	value="#rsReporte.AcumuladoRenta#"/>
            <cfpdfformparam name="txt2E"		value="0"/>
            <cfpdfformparam name="txt2K"		value="0"/>
            <cfpdfformparam name="txt2L"		value="0"/>
            <cfpdfformparam name="txt2O"		value="#rsReporte.txt2O#"/>
            <cfpdfformparam name="Campo3" 		value="#rsReporte.Campo3#"/> 
            <cfpdfformparam name="Campo3a" 		value="#rsReporte.Campo3#"/> 
            <cfpdfformparam name="Campo4" 		value="#rsReporte.Campo4#"/> 
            <cfpdfformparam name="Campo4a" 		value="#rsReporte.Campo4#"/>
            <cfpdfformparam name="Campo4b" 		value="#rsReporte.Campo4#"/>
            <cfpdfformparam name="Campo5" 		value="#rsReporte.Campo5#"/> 
            <cfpdfformparam name="Campo5a" 		value="#rsReporte.Campo5#"/>
            <cfpdfformparam name="Campo5b" 		value="#rsReporte.Campo5#"/>  
            <cfpdfformparam name="Campo6" 		value="#rsReporte.Campo6#"/>
            <cfpdfformparam name="Campo6a" 		value="#rsReporte.Campo6#"/>
            <cfpdfformparam name="Campo6b" 		value="#rsReporte.Campo6#"/>
            <cfpdfformparam name="Campo6c" 		value="#rsReporte.Campo6#"/> 
            <cfpdfformparam name="Campo7" 		value="#rsReporte.Campo7#"/>
            <cfpdfformparam name="Campo7a" 		value="#rsReporte.Campo7#"/>
            <cfpdfformparam name="Campo7b" 		value="#rsReporte.Campo7#"/>
            <cfpdfformparam name="Campo8" 		value="#rsReporte.Campo8#"/>
            <cfif #rsReporte.Campo9# EQ 1> 
            <cfpdfformparam name="Campo9" 		value=  "X"/>  
            </cfif>
            <cfif #rsReporte.Campo10# EQ 1> 
            <cfpdfformparam name="Campo10" 		value=  "X"/>  
            </cfif>
            <cfif #rsReporte.Campo11# EQ 1> 
            <cfpdfformparam name="Campo11" 		value=  "X"/>  
            </cfif>
            <cfif #rsReporte.Campo13# EQ 1> 
            <cfpdfformparam name="Campo13" 		value=  "X"/>  
            </cfif>
            <cfpdfformparam name="Campo14" 		value="#rsReporte.Campo14#"/>
            <cfpdfformparam name="Campo15" 		value="#rsReporte.Campo15#"/>
            <cfpdfformparam name="Campo26" 		value="#rsReporte.Campo26#"/>   
            <cfif #rsReporte.Campo27# EQ 1> 
            <cfpdfformparam name="Campo27" 		value=  "X"/>  
            </cfif>
            <cfpdfformparam name="Campo28" 		value="#rsReporte.Campo28#"/>
            <cfpdfformparam name="Campo29" 		value="#rsReporte.Campo29#"/>  
            <cfpdfformparam name="Campo33" 		value="#rsReporte.Campo33#"/> 
            <cfpdfformparam name="Campo34" 		value="#rsReporte.Campo34#"/> 
            <cfpdfformparam name="Campo35" 		value="#rsReporte.Campo35#"/> 
            <cfpdfformparam name="Campo36" 		value="#rsReporte.Campo36#"/> 
            <cfpdfformparam name="Campo37" 		value="#rsReporte.Campo37#"/> 
            <cfpdfformparam name="Campo38" 		value="#rsReporte.Campo38#"/> 
            <cfpdfformparam name="Campo39" 		value="#rsReporte.Campo39#"/> 
            <cfpdfformparam name="Campo40" 		value="#rsReporte.Campo40#"/> 
            <cfpdfformparam name="Campo41" 		value="#rsReporte.Campo41#"/> 
            <cfpdfformparam name="Campo42" 		value="#rsReporte.Campo42#"/> 
            <cfpdfformparam name="Campo43" 		value="#rsReporte.Campo43#"/> 
            <cfpdfformparam name="Campo44" 		value="#rsReporte.Campo44#"/> 
            <cfpdfformparam name="Campo45" 		value="#rsReporte.Campo45#"/> 
            <cfpdfformparam name="Campo46" 		value="#rsReporte.Campo46#"/> 
            <cfpdfformparam name="Campo47" 		value="#rsReporte.Campo47#"/> 
            <cfpdfformparam name="Campo48" 		value="#rsReporte.Campo48#"/> 
            <cfpdfformparam name="Campo49" 		value="#rsReporte.Campo49#"/> 
            <cfpdfformparam name="Campo50" 		value="#rsReporte.Campo50#"/> 
            <cfpdfformparam name="Campo51" 		value="#rsReporte.Campo51#"/> 
            <cfpdfformparam name="Campo52" 		value="#rsReporte.Campo52#"/> 
            <cfpdfformparam name="Campo54" 		value="#rsReporte.Campo54#"/> 
            <cfpdfformparam name="Campo55" 		value="#rsReporte.Campo55#"/> 
            <cfpdfformparam name="Campo56" 		value="#rsReporte.Campo55#"/> 
            <cfpdfformparam name="Campo57" 		value="#rsReporte.Campo57#"/> 
            <cfpdfformparam name="Campo58" 		value="#rsReporte.Campo58#"/> 
            <cfpdfformparam name="Campo59" 		value="#rsReporte.Campo59#"/>
            <cfpdfformparam name="Campo60" 		value="#rsReporte.Campo60#"/>
            <cfpdfformparam name="Campo61" 		value="#rsReporte.Campo61#"/>     
            <cfpdfformparam name="Campo62" 		value="#rsReporte.Campo62#"/>  
            <cfpdfformparam name="Campo63" 		value="#rsReporte.Campo63#"/> 
            <cfpdfformparam name="Campo64" 		value="#rsReporte.Campo64#"/>
            <cfpdfformparam name="Campo65" 		value="#rsReporte.Campo65#"/>  
            <cfpdfformparam name="Campo66" 		value="#rsReporte.Campo66#"/>
            <cfpdfformparam name="Campo67" 		value="#rsReporte.Campo67#"/>
            <cfpdfformparam name="Campo68" 		value="#rsReporte.Campo68#"/>
            <cfpdfformparam name="Campo69" 		value="#rsReporte.Campo69#"/>
            <cfpdfformparam name="Campo70" 		value="#rsReporte.Campo70#"/>
            <cfpdfformparam name="Campo71" 		value="#rsReporte.Campo71#"/>
            <cfpdfformparam name="Campo72" 		value="#rsReporte.Campo72#"/>
            <cfpdfformparam name="Campo73" 		value="#rsReporte.Campo73#"/>
            <cfpdfformparam name="Campo74" 		value="#rsReporte.Campo74#"/>
            <cfpdfformparam name="Campo75" 		value="#rsReporte.Campo75#"/>
            <cfpdfformparam name="Campo76" 		value="#rsReporte.Campo76#"/>
            <cfpdfformparam name="Campo77" 		value="#rsReporte.Campo77#"/>
            <cfpdfformparam name="Campo78" 		value="#rsReporte.Campo78#"/>
            <cfpdfformparam name="Campo79" 		value="#rsReporte.Campo79#"/>
            <cfpdfformparam name="Campo80" 		value="#rsReporte.Campo80#"/>
            <cfpdfformparam name="Campo81" 		value="#rsReporte.Campo81#"/>
            <cfpdfformparam name="Campo82" 		value="#rsReporte.Campo82#"/>
            <cfpdfformparam name="Campo83" 		value="#rsReporte.Campo83#"/>
            <cfpdfformparam name="Campo84" 		value="#rsReporte.Campo84#"/> 
            <cfpdfformparam name="Campo85" 		value="#rsReporte.Campo85#"/> 
            <cfpdfformparam name="Campo86" 		value="#rsReporte.Campo86#"/> 
            <cfpdfformparam name="Campo87" 		value="#rsReporte.Campo87#"/> 
            <cfpdfformparam name="Campo88" 		value="#rsReporte.Campo88#"/> 
            <cfpdfformparam name="Campo89" 		value="#rsReporte.Campo89#"/> 
            <cfpdfformparam name="Campo90" 		value="#rsReporte.Campo90#"/> 
            <cfpdfformparam name="Campo91" 		value="#rsReporte.Campo91#"/> 
            <cfpdfformparam name="Campo92" 		value="#rsReporte.Campo92#"/> 
            <cfpdfformparam name="Campo93" 		value="#rsReporte.Campo93#"/> 
            <cfpdfformparam name="Campo94" 		value="#rsReporte.Campo94#"/> 
            <cfpdfformparam name="Campo95" 		value="#rsReporte.Campo95#"/> 
            <cfpdfformparam name="Campo96" 		value="#rsReporte.Campo96#"/> 
            <cfpdfformparam name="Campo97" 		value="#rsReporte.Campo97#"/> 
            <cfpdfformparam name="Campo98" 		value="#rsReporte.Campo98#"/> 
            <cfpdfformparam name="Campo99" 		value="#rsReporte.Campo99#"/> 
            <cfpdfformparam name="Campo100" 	value="#rsReporte.Campo100#"/> 
            <cfpdfformparam name="Campo101" 	value="#rsReporte.Campo101#"/> 
           	<cfpdfformparam name="Campo102" 	value="#rsReporte.Campo102#"/> 
            <cfpdfformparam name="Campo103" 	value="#rsReporte.Campo103#"/> 
            <cfpdfformparam name="Campo104" 	value="#rsReporte.Campo104#"/> 
            <cfpdfformparam name="Campo105" 	value="#rsReporte.Campo105#"/> 
            <cfpdfformparam name="Campo106" 	value="#rsReporte.Campo106#"/> 
            <cfpdfformparam name="Campo107" 	value="#rsReporte.Campo107#"/>
            <cfpdfformparam name="Campo108" 	value="#rsReporte.Campo108#"/>
            <cfpdfformparam name="Campo109" 	value="#rsReporte.Campo108#"/>
            <cfpdfformparam name="Campo110" 	value="#rsReporte.Campo110#"/>
            <cfpdfformparam name="Campo111" 	value="#rsReporte.Campo111#"/>
            <cfpdfformparam name="Campo112" 	value="#rsReporte.Campo112#"/>
            <cfpdfformparam name="Campo113" 	value="#rsReporte.Campo113#"/>
            <cfpdfformparam name="Campo114" 	value="#rsReporte.Campo114#"/>
            <cfpdfformparam name="Campo115" 	value="#rsReporte.Campo115#"/>
            <cfpdfformparam name="Campo116" 	value="#rsReporte.Campo116#"/>
            <cfpdfformparam name="Campo117" 	value="#rsReporte.Campo117#"/>
            <cfpdfformparam name="Campo118" 	value="#rsReporte.Campo118#"/>
            <cfpdfformparam name="Campo119" 	value="#rsReporte.Campo119#"/>
            <cfpdfformparam name="Campo120" 	value="#rsReporte.Campo120#"/>
            <cfpdfformparam name="Campo121" 	value="#rsReporte.Campo121#"/>
            <cfpdfformparam name="Campo122" 	value="#rsReporte.Campo122#"/>
            <cfpdfformparam name="Campo123" 	value="#rsReporte.Campo123#"/>
            <cfpdfformparam name="Campo124" 	value="#rsReporte.Campo124#"/>
            <cfpdfformparam name="Campo125" 	value="#rsReporte.Campo125#"/>
            <cfpdfformparam name="Campo126" 	value="#rsReporte.Campo126#"/>
            <cfpdfformparam name="Campo127" 	value="#rsReporte.Campo127#"/>
            <cfpdfformparam name="Campo128" 	value="#rsReporte.Campo128#"/>
            <cfpdfformparam name="Campo129" 	value="#rsReporte.Campo129#"/> 
            <cfpdfformparam name="Campo130" 	value="#rsReporte.Campo130#"/>
            <cfpdfformparam name="Campo131" 	value="#rsReporte.Campo131#"/>   
            <cfpdfformparam name="Campo132" 	value="#rsReporte.Campo132#"/> 
            <cfpdfformparam name="Campo133" 	value="#rsReporte.Campo133#"/>
            <cfpdfformparam name="Campo134" 	value="#rsReporte.Campo134#"/>   
        </cfpdfsubform> 
    </cfpdfform>
<!---</cfloop>--->
</cfif>



<!--- Componente: ReporteSaldosSocio--->
<!--- Fecha Creacion 28/01/2009  --->
<!--- Consulta administrativa, que muestra saldos por socio en CXP---> 
<!--- Anteriormente dos stores procedure en sybase(sp AD_AntigSaldosDetCxP y sp AD_AntigSaldosCxP). José M--->
<cfcomponent>

	<cffunction name="ReporteSaldosSocio" access="public" returntype="query">
			<cfargument name="Conexion" type="string"  required="yes">
			<cfargument name="Ecodigo" 	type="numeric" required="yes">
			<cfargument name="vencSel" 	type="numeric" required="false" default="-1">
			<cfargument name="SNcodigo" type="numeric" required="false" default="-1">
			<cfargument name="Ocodigo"  type="numeric" required="false" default="-1">
			<cfargument name="venc1" 	type="numeric" required="false" default="30">
			<cfargument name="venc2" 	type="numeric" required="false" default="60">
			<cfargument name="venc3" 	type="numeric" required="false" default="90">
			<cfargument name="venc4" 	type="numeric" required="false" default="120">
			<cfargument name="Resumido" type="boolean" required="false" default="false">
	
			<cfset tempsocios   = fnGetSocios  (#Arguments.SNcodigo#,#Arguments.Conexion#, #Arguments.Ecodigo#)>
			<cfset tempoficinas = fnGetOficinas(#Arguments.Ocodigo#, #Arguments.Conexion#, #Arguments.Ecodigo#)>
		 
			<cf_dbfunction name="now"returnvariable="fechahoy">
			<cf_dbfunction name="datediff"	args="a.Dfechavenc, #PreserveSingleQuotes(fechahoy)#" returnvariable="diasVencimiento">
			<cf_dbfunction name="date_part"	 args="mm, fecha" 	       returnVariable="mesfecha">
			<cf_dbfunction name="date_part"	 args="mm, a.Dfecha" 	    returnVariable="mesDfecha">
            <cf_dbfunction name="date_part"	 args="mm, #fechahoy#" 		returnVariable="mesHoy">

			<cfif Arguments.vencSel EQ -1>
				<cfset filtro = "">
			<cfelseif Arguments.vencSel EQ 1>
				<cfset filtro = "and #PreserveSingleQuotes(diasVencimiento)# <= 0 and #PreserveSingleQuotes(mesDfecha)# <> #PreserveSingleQuotes(mesHoy)#">
			<cfelseif Arguments.vencSel EQ 2>
				<cfset filtro = " and #PreserveSingleQuotes(diasVencimiento)# between 1 and #Arguments.venc1#">
			<cfelseif Arguments.vencSel EQ 3>
				<cfset filtro = "and #PreserveSingleQuotes(diasVencimiento)# between (#Arguments.venc1#+1) and (#Arguments.venc2#)">
			<cfelseif Arguments.vencSel EQ 4>
				<cfset filtro = " and #PreserveSingleQuotes(diasVencimiento)# between (#Arguments.venc2#+1) and (#Arguments.venc3#)">
			<cfelseif Arguments.vencSel EQ 5>
				<cfset filtro = "and #PreserveSingleQuotes(diasVencimiento)# between (#Arguments.venc3#+1) and (#Arguments.venc4#)">
			<cfelseif Arguments.vencSel EQ 6>
				<cfset filtro = "and #PreserveSingleQuotes(diasVencimiento)# > #Arguments.venc4#">
			<cfelseif Arguments.vencSel EQ 7>
				<cfset filtro = "and #PreserveSingleQuotes(diasVencimiento)# <= 0 and #PreserveSingleQuotes(mesDfecha)# = #PreserveSingleQuotes(mesHoy)#">
			<cfelse>
				<cf_errorCode	code = "50891" msg = "Error en el componente AntigSaldosDetCxP el tipo de reporte no esta implementado!">
			</cfif>

			<cf_dbtemp name="temp_v2" returnvariable="temp" datasource="#Arguments.Conexion#">
				<cf_dbtempcol name="socio"   		type="varchar(255)"  	mandatory="yes">
				<cf_dbtempcol name="SNcodigo"   	type="integer"  		mandatory="yes">
				<cf_dbtempcol name="IDdocumento"   	type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="transaccion"   	type="varchar(2)"  		mandatory="yes">
				<cf_dbtempcol name="documento"   	type="varchar(20)"  	mandatory="yes">
				<cf_dbtempcol name="fecha"   		type="date"  	        mandatory="yes">
				<cf_dbtempcol name="fechavenc"   	type="date"         	mandatory="yes">
				<cf_dbtempcol name="monto"   		type="money"  			mandatory="yes">
				<cf_dbtempcol name="saldo"   		type="money"  			mandatory="yes">
				<cf_dbtempcol name="moneda"   		type="varchar(80)"  	mandatory="yes">
				<cf_dbtempcol name="diasvenc"   	type="numeric"  	    mandatory="yes">
				<cf_dbtempcol name="saldolocal"   	type="money"  			mandatory="yes">
			</cf_dbtemp>
			
			<cfquery datasource="#Arguments.Conexion#">
				insert into #temp#(socio,SNcodigo,IDdocumento,transaccion,documento,fecha,fechavenc,monto,saldo,moneda,diasvenc, saldolocal)
					select c.SNnombre as socio, 
						   c.SNcodigo,	
						   coalesce(HD.IDdocumento,-1),	
						   a.CPTcodigo as transaccion,
						   a.Ddocumento as documento,
						   a.Dfecha as fecha,
						   a.Dfechavenc as fechavenc,
						   coalesce(round((case d.CPTtipo when 'C' then 1 when 'D' then -1 else 0 end)*a.Dtotal,2), 0.00) as monto,
						   coalesce(round((case d.CPTtipo when 'C' then 1 when 'D' then -1 else 0 end)*a.EDsaldo,2), 0.00) as saldo,
						   b.Mnombre as moneda,
						   #PreserveSingleQuotes(diasVencimiento)# as diasvenc,
						   coalesce(round((case d.CPTtipo when 'C' then 1 when 'D' then -1 else 0 end)*(a.EDsaldo*a.EDtcultrev),2), 0.00) as saldolocal
					from EDocumentosCP a
					inner join Monedas b
						on a.Mcodigo = b.Mcodigo
					inner join SNegocios c
						on a.Ecodigo = c.Ecodigo
						and a.SNcodigo = c.SNcodigo	
					inner join CPTransacciones d
						on a.Ecodigo = d.Ecodigo
						and a.CPTcodigo = d.CPTcodigo
					left outer  join HEDocumentosCP HD
						on HD.Ecodigo = a.Ecodigo
						and HD.CPTcodigo = a.CPTcodigo
						and HD.Ddocumento = a.Ddocumento
						and HD.SNcodigo = a.SNcodigo
					where a.Ecodigo = #Arguments.Ecodigo#
					and a.EDsaldo > 0
					and a.SNcodigo in (select SNcodigo from #tempsocios#)
					and a.Ocodigo in (select Ocodigo from #tempoficinas#)
					#PreserveSingleQuotes(filtro)#
					order by c.SNnombre, b.Mnombre, a.Dfechavenc desc, transaccion, documento
			</cfquery>
			<cfif Resumido>
			    <!---Etiquetas segun los valores de morosidad de los paramentros--->
			    <cfset desc1 = 'Sin Vencer'>
				<cfset desc2 = '1 - '& #venc1#>
				<cfset desc3 = #venc1# + 1 & ' - ' & #venc2#>
				<cfset desc4 = #venc2# + 1 & ' - ' & #venc3#>
				<cfset desc5 = #venc3# + 1 & ' - ' & #venc4#>
				<cfset desc6 = 'mas de ' & #venc4#>
				<cfset desc7 = 'Corriente'>
				
				<cfquery name="rsConsulta"datasource="#Arguments.Conexion#">
					select 0,Coalesce(sum(saldolocal), 0.00) as monto, '#desc7#' as venc from #temp#  where diasvenc <= 0 and  #PreserveSingleQuotes(mesfecha)# <> #PreserveSingleQuotes(mesHoy)#
					union
					select 1,Coalesce(sum(saldolocal), 0.00) as monto, '#desc1#' as venc from #temp#  where diasvenc <= 0 and #PreserveSingleQuotes(mesfecha)# = #PreserveSingleQuotes(mesHoy)#
					union
					select 2,Coalesce(sum(saldolocal), 0.00) as monto, '#desc2#'  as venc from #temp# where diasvenc between 1 and #venc1#
					union
					select 3,Coalesce(sum(saldolocal), 0.00) as monto, '#desc3#'  as venc from #temp# where diasvenc between #venc1#+1 and #venc2#
					union
					select 4,Coalesce(sum(saldolocal), 0.00) as monto, '#desc4#'  as venc from #temp# where diasvenc between #venc2#+1 and #venc3#
					union
					select 5,Coalesce(sum(saldolocal), 0.00) as monto, '#desc5#'  as venc from #temp# where diasvenc between #venc3#+1 and #venc4#
					union
					select 6,Coalesce(sum(saldolocal), 0.00) as monto, '#desc6#'  as venc from #temp# where diasvenc  > #venc4#
				</cfquery>
			<cfelse>
				<cfquery name="rsConsulta"datasource="#Arguments.Conexion#">
					select socio,SNcodigo,IDdocumento, transaccion, documento, fecha, fechavenc, monto, saldo, moneda, diasvenc, saldolocal 
					 from #temp#
				</cfquery>
			</cfif>
		
			<cfreturn rsConsulta> 	
	</cffunction>
<!---FUNCION PARA CARGAR LOS SOCIO DE NEGOCIOS DEL REPORTE--->	
	<cffunction name="fnGetSocios" access="private" returntype="string">
		<cfargument name="SNcodigo" type="numeric" required="false" default="-1">
		<cfargument name="Conexion" type="string"  required="yes">	
		<cfargument name="Ecodigo" 	type="numeric" required="yes">
		<cf_dbtemp name="RepAdminSocio_v1" returnvariable="tempsocios" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="SNcodigo"   type="integer"  mandatory="yes">
		</cf_dbtemp>
		<cfif Arguments.SNcodigo EQ -1>	
			<cfquery datasource="#Arguments.Conexion#">
				insert into #tempsocios# (SNcodigo) 
				  select SNcodigo
					from SNegocios
				  where Ecodigo = #Arguments.Ecodigo#
					and SNtiposocio in ('A', 'P')
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				 insert into #tempsocios#(SNcodigo) 
					select SNcodigo
					from SNegocios
					where Ecodigo = #Arguments.Ecodigo#
					and SNcodigo = #Arguments.SNcodigo# 
			</cfquery>
		</cfif>
			<cfreturn #tempsocios#>
	</cffunction>
<!---FUNCION PARA CARGAR LAS OFICINAS DE NEGOCIOS DEL REPORTE--->	
	<cffunction name="fnGetOficinas" access="private" returntype="string">
		<cfargument name="Ocodigo"  type="numeric" required="false" default="-1">
		<cfargument name="Conexion" type="string"  required="yes">	
		<cfargument name="Ecodigo" 	type="numeric" required="yes">
		<cf_dbtemp name="tempOficinas_v1" returnvariable="tempoficinas" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Ocodigo"   type="integer"  mandatory="yes">
		</cf_dbtemp>
		<cfif Arguments.Ocodigo EQ -1>	
			<cfquery datasource="#Arguments.Conexion#">
				 insert into #tempoficinas#(Ocodigo) 
					select Ocodigo
					from Oficinas
					where Ecodigo =#Arguments.Ecodigo#
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				 insert into #tempoficinas#(Ocodigo) 
					select Ocodigo
					from Oficinas
					where Ecodigo = #Arguments.Ecodigo#
					  and Ocodigo = #Arguments.Ocodigo#
			</cfquery>
		</cfif>
			<cfreturn #tempoficinas#>
	</cffunction>
</cfcomponent>


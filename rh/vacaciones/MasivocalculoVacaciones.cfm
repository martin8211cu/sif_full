<cfoutput>
<cfset vDebug = false>
<cfsetting requesttimeout="66000">

<cfsetting enablecfoutputonly="yes">
	<cfapplication name="TAREAS" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>	
	
<cfset listadatasourse = "">
<cfset dsinfo = StructNew()>
<cfset factory = CreateObject("java", "coldfusion.server.ServiceFactory")>
<cfset ds_service = factory.datasourceservice>
<cfset datasources = ds_service.getDatasources()>
<cfset data.DEid = 0>
<cfset Periodo  = 0>
<cfset empresa  = 0>
<cfset fechaAntiguedad = now()>
<cfset fechaCalculo = now()>
<cfset dia = 0>
<cfset mes = 0>
<cfset ano = 0>


<cfloop collection="#datasources#" item="i">
	
	<cftry>
		<cfset thisdatasource = datasources[i]>
		<cfif IsDefined('thisdatasource.class')>
			<cfset dsinfoitem = StructNew()>
			<cfset dsinfoitem.name        = thisdatasource.name>
			<cfset dsinfoitem.driverClass = thisdatasource.class>
			<cfset dsinfoitem.driverName  = thisdatasource.driver>
			<cfset dsinfoitem.url         = thisdatasource.url>
			<cfset dsinfoitem.type        =  LCase(thisdatasource.driver)>
			<cfset dsinfo[datasources[i].name] = dsinfoitem>
			<cfset listadatasourse = listadatasourse & "'"& thisdatasource.name  & "',">
		</cfif>
		<cfcatch type="any"></cfcatch>
	</cftry>
</cfloop>

<cfset Application.dsinfo = dsinfo>
<cfset listadatasourse = listadatasourse & "'x'">
<cfset registros = 0 >

<cfquery name="bds" datasource="asp">
	select distinct c.Ccache
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'RH'
	  <cfif vDebug >
	  	and c.Ccache in ('minisif')
	  <cfelse>
	  	and c.Ccache in(#PreserveSingleQuotes(listadatasourse)#)
	  </cfif> 	
	and Ereferencia is not null
</cfquery>

<cfflush interval="1">
<cfloop query="bds">
	<cfif vDebug >***********************************************************<br><b>CACHE:</b> <cfdump var="#bds.Ccache#"><br><br></cfif>
	<cfset cache = trim(bds.Ccache) > 
	
	<cf_dbtemp name="PagosEmplv10" returnvariable="tbl_PagosEmpleado" datasource="#cache#">
		<cf_dbtempcol name="Registro" type="numeric" identity="yes" mandatory="yes"> 
		<cf_dbtempcol name="RCNid" type="numeric">
		<cf_dbtempcol name="DEid" type="numeric"> 
		<cf_dbtempcol name="FechaDesde" type="date">
		<cf_dbtempcol name="FechaHasta" type="date">
		<cf_dbtempcol name="Cantidad" type="int">
		<cf_dbtempkey cols="Registro">
	</cf_dbtemp>
	
	<cf_dbtemp name="PAgosPEriodos10" returnvariable="PAgosPEriodos" datasource="#cache#">
		<cf_dbtempcol name="RCNid"       type="numeric">
		<cf_dbtempcol name="RCNDes"       type="varchar(256)">
		<cf_dbtempcol name="FechaDesde"  type="date">
		<cf_dbtempcol name="FechaHasta"  type="date">
		<cf_dbtempcol name="salario"     type="float">
		<cf_dbtempcol name="incidencias" type="float">
		<cf_dbtempcol name="dias" type="int">
	</cf_dbtemp>
	<cfquery name="updatemasivo" datasource="#cache#">
		update DVacacionesEmpleado  set DVEperiodo  =  <cf_dbfunction name="date_part"	args="yyyy,DVEfecha" >
		where DVEfecha is not null
	</cfquery>
	
	<cfquery name="empresas" datasource="#cache#">
		select Ecodigo
		from Empresas
		<cfif vDebug >
			where Ecodigo = 1 
		</cfif>
	</cfquery>
	<cfloop query="empresas">
		<cfset empresa = empresas.Ecodigo >
		<cfif vDebug ><b>Empresa:</b><cfdump var="#empresa#"><br><br></cfif>
		
		<cfquery datasource="#cache#">
			insert into DVacacionesAcum (DEid, Ecodigo,BMUsucodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha)
			select 
			de.DEid,
			de.Ecodigo,
			null,
			de.DVEperiodo,
			case when coalesce(sum(de.DVEdisfrutados),0)>= 0 then  coalesce(sum(de.DVEdisfrutados),0) else 0 end as  DVEdisfrutados, 
			0.00,
			0.00,
			<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			from DVacacionesEmpleado de 
			where not exists (select 1 from DVacacionesAcum x   where
					x.DEid = de.DEid
					and x.DVAperiodo = de.DVEperiodo 
					and x.Ecodigo  = de.Ecodigo )
			and  de.Ecodigo = #empresa# 
			and  de.DVEperiodo is not null
			<cfif vDebug >
				and  de.Ecodigo = 1 
				and  de.DEid = 4839
			</cfif>
			group by de.DEid,de.Ecodigo,de.DVEperiodo
		</cfquery>
			
		<cfquery name="losrsempleados" datasource="#cache#">
			select  a.DEid,a.Ecodigo,a.DVAperiodo,a.DVAfecha
			from DVacacionesAcum a
			inner join LineaTiempo b
				on  a.DEid = b.DEid
				and  a.Ecodigo = b.Ecodigo
			where <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and  LThasta 
			and a.Ecodigo = #empresa#
			<cfif vDebug>
				and  a.Ecodigo = 1 
				and  a.DEid = 4839
			</cfif>
			order by a.Ecodigo,a.DEid,a.DVAperiodo
		</cfquery>	

		<cfif vDebug>
			<cfif losrsempleados.recordCount GT 0>
				<cfdump var="#losrsempleados#">
			<cfelse>
				***** No hay registros por procesar ****
			</cfif>
		</cfif>
		<cfif losrsempleados.recordCount GT 0>
			<cfloop query="losrsempleados">
				<cfset data.DEid = losrsempleados.DEid>
				<cfset Periodo  = losrsempleados.DVAperiodo>
	
				<cfquery name="rsEVfantig" datasource="minisif">
					select EVfantig  from EVacacionesEmpleado where DEid = #data.DEid#
				</cfquery>
				<cfset fechaAntiguedad = rsEVfantig.EVfantig>
				<cfset fechaAntiguedad = dateadd('d',-1,fechaAntiguedad) >
		
				<cfset dia = datepart('d', fechaAntiguedad)>
				<cfset mes = datepart('m', fechaAntiguedad)>
				<cfset ano = Periodo>
				
				<cfif vDebug>dia :<cfdump var="#dia#"><br/></cfif>
				<cfif vDebug>mes :<cfdump var="#mes#"><br/></cfif>
				<cfif vDebug>ano :<cfdump var="#ano#"><br/></cfif>

				<cfset fechaCalculo = CreateDate( ano, mes, dia)>
				
				<cfinclude template="calculaSalario.cfm">
				
				<cfquery name="update" datasource="#cache#">
					update DVacacionesAcum set 
						DVASalarioProm 		= #SalarioUltimosPeriodos#,
						DVASalarioPdiario 	= #SalarioPromedioDiario#,
						DVAfecha 			= <cfqueryparam cfsqltype="cf_sql_date" value="#fechaCalculo#">
					where DEid  =  #data.DEid#
					and   Ecodigo = #empresa#
					and   DVAperiodo = #Periodo#
				</cfquery>
			</cfloop>
		</cfif>
	</cfloop>
	<cfif vDebug >
		<cfquery name="update" datasource="#cache#">
			select * from  DVacacionesAcum
				where DEid  =  #data.DEid#
				and   Ecodigo = #empresa#
		</cfquery>
		<cfdump var="#update#">
	</cfif>
</cfloop>	






















</cfoutput>

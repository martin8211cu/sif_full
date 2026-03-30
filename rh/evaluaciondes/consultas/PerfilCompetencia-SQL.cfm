	<!--- Creado por: 	  Rodolfo Jimenez Jara  --->
	<!--- Fecha: 		  11/05/2005  3:00 p.m. --->
	<!--- Modificado por: --->
	<!--- Fecha: 		  --->
	
	<cfquery name="rsRelEval" datasource="#session.DSN#">
		Select RHEEdescripcion
		from RHEEvaluacionDes
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid_f#">
	</cfquery>
<!--- VARIABLES DE TRADUCCION --->		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Primordial"
		Default="Primordial"
		returnvariable="LB_Primordial"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Basica"
		Default="Básica"
		returnvariable="LB_Basica"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Complementaria"
		Default="Complementaria"
		returnvariable="LB_Complementaria"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Deseable"
		Default="Deseable"
		returnvariable="LB_Deseable"/>

	<cfquery name="rsReporte" datasource="#session.DSN#">
		select distinct 
		  cf.CFcodigo, cf.CFdescripcion,
		   coalesce(f.RHHtipo, g.RHCtipo) as ttipo,
		  coalesce(d.RHHid, e.RHCid) as Id , a.RHEEid,
		  coalesce(d.RHHdescripcion, e.RHCdescripcion) as descripcion ,
		  avg(  (coalesce(c.RHNEDnotajefe,0)+ coalesce(c.RHNEDpromotros,0))/2  )as Prom,
		   case coalesce(f.RHHtipo, g.RHCtipo)
		     when 0 then '#LB_Primordial#'
		     when 1 then '#LB_Basica#'
		     when 2 then '#LB_Complementaria#'
		     when 3  then '#LB_Deseable#'
		   else '' end tipo
		from RHEEvaluacionDes a
		  inner join RHListaEvalDes b
			on a.RHEEid = b.RHEEid
			and a.Ecodigo = b.Ecodigo
		  inner join RHNotasEvalDes c
			on b.RHEEid = c.RHEEid
		   and b.DEid = c.DEid
		  left outer join LineaTiempo lt
			on lt.DEid = b.DEid
			and lt.Ecodigo = b.Ecodigo
			and lt.RHPcodigo = b.RHPcodigo 
			and getdate() between lt.LTdesde and lt.LThasta
		  left outer join RHPlazas  p
			on lt.RHPid = p.RHPid
		  inner join CFuncional cf
		   on cf.CFid = p.CFid
		  left outer join RHHabilidades d
			on c.RHHid = d.RHHid
			and b.Ecodigo = d.Ecodigo
		  left outer join  RHHabilidadesPuesto f
			on   d.RHHid = f.RHHid
			and b.RHPcodigo = f.RHPcodigo
		    and b.Ecodigo = f.Ecodigo
		
		  left outer join RHConocimientos e
			on c.RHCid = e.RHCid
			and b.Ecodigo = e.Ecodigo
		  left outer join  RHConocimientosPuesto g
			on   e.RHCid = g.RHCid
			 and  b.RHPcodigo = g.RHPcodigo
			 and b.Ecodigo = g.Ecodigo
		  where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("url.RHEEid_f") and len(trim(url.RHEEid_f))>
				and a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid_f#">
			</cfif>

			<cfif isdefined("url.CFid") and len(trim(url.CFid))>
				and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			</cfif>  
			<cfif isdefined("url.RHHtipo") and len(trim(url.RHHtipo))>
				and f.RHHtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RHHtipo#">
			</cfif>  
			
		group by  cf.CFcodigo, cf.CFdescripcion,
		coalesce(f.RHHtipo, g.RHCtipo), a.RHEEid,
		 case coalesce(f.RHHtipo, g.RHCtipo)
		  when 0 then '#LB_Primordial#'
		  when 1 then '#LB_Basica#'
		  when 2 then '#LB_Complementaria#'
		  when 3  then '#LB_Deseable#'
		else '' end ,
		  coalesce(d.RHHid, e.RHCid)  ,
		  coalesce(d.RHHdescripcion, e.RHCdescripcion) ,c.RHNEDnotajefe,c.RHNEDpromotros
		order by cf.CFcodigo, coalesce(f.RHHtipo, g.RHCtipo), descripcion
	</cfquery>

	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formatos = "excel">
	</cfif>
	
	<cfreport format="#formatos#" template= "perfilcom.cfr" query="rsReporte">
		<cfreportparam name="Enombre" value="#session.enombre#">
		<cfreportparam name="RelEval" value="#url.RHEEid_f#">
		<cfreportparam name="DescEval" value="#rsRelEval.RHEEdescripcion#">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
	</cfreport>
	
	
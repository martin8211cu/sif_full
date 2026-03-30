<cfcomponent>
	<cffunction name="Existencias_por_Almacen" access="public" returntype="query" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'			type='numeric' 	required='true'		hint="Código empresa ">
		<cfargument name='almaceni' 		type='numeric' 	required='true' 	hint="Código del Almacén Inicial">
		<cfargument name='almacenf' 		type='numeric' 	required='true' 	hint="Código del Almacén Final">
		<cfargument name='articuloi' 		type='string' 	required='false' 	hint="Código del Artículo Inicial" default="">
		<cfargument name='articulof' 		type='string' 	required='false' 	hint="Código del Artículo Final"   default=""> 
		<cfargument name='clasificacioni' 	type='numeric' 	required='false' 	default="0">	 
		<cfargument name='clasificacionf' 	type='numeric' 	required='false' 	default="0">	 
		<cfargument name='Rid' 				type='numeric' 	required='false' 	default="0">	 
		<cfargument name='debug' 			type='string' 	required='false' 	default="N">

	<cfif len(trim(Arguments.almaceni))>
		<cfquery name="rsAlmaceni" datasource="#session.DSN#">
			select Almcodigo as almini
			from Almacen 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		 	  and Aid     = #Arguments.almaceni#	
		</cfquery>
	<cfelse>
		<cfquery name="rsAlmaceni" datasource="#session.DSN#">
			select min(Almcodigo) as almini
		 	from Almacen 
		 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		 </cfquery>
	</cfif>
	
	<cfif len(trim(Arguments.almacenf))>
		<cfquery name="rsAlmacenf" datasource="#session.DSN#">
	 		select Almcodigo as almfin
			from Almacen 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Aid     = #Arguments.almacenf#	
		</cfquery>	
	<cfelse>
		<cfquery name="rsAlmacenf" datasource="#session.DSN#">	
			select max(Almcodigo) as almfin
			from Almacen 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>	
	</cfif>
		<cfset LvarAlmini = rsAlmaceni.almini>
		<cfset LvarAlmfin = rsAlmacenf.almfin>
	
	<cfif LvarAlmini gt LvarAlmfin>
		<cfset LvarAlmTemp = LvarAlmini>
		<cfset LvarAlmini  = LvarAlmfin>
		<cfset LvarAlmfin  = LvarAlmTemp>
	</cfif>
	
	<cfif len(trim(Arguments.clasificacioni)) and Arguments.clasificacioni NEQ 0>
		<cfquery name="rsClasificacioni" datasource="#session.DSN#">
			select Ccodigoclas as claini
			from Clasificaciones 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Ccodigo = #Arguments.clasificacioni#
		</cfquery>
	<cfelse>
		<cfquery name="rsClasificacioni" datasource="#session.DSN#">
			select min(Ccodigoclas)as claini 
			from Clasificaciones 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
	</cfif>
	
	<cfif len(trim(Arguments.clasificacionf))  and Arguments.clasificacionf NEQ 0>
		<cfquery name="rsClasificacionf" datasource="#session.DSN#">
			select Ccodigoclas as clafin
			from Clasificaciones 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.clasificacionf#">
		</cfquery>
	<cfelse>
		<cfquery name="rsClasificacionf" datasource="#session.DSN#">
			select max(Ccodigoclas) as clafin 
			from Clasificaciones 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
	</cfif>
		<cfset LvarClaini = rsClasificacioni.claini>
		<cfset LvarClafin = rsClasificacionf.clafin>
	
	<cfif LvarClaini gt LvarClafin>
		<cfset LvarAlmTemp = LvarClaini>
		<cfset LvarClaini  = LvarClafin>
		<cfset LvarClafin  = LvarAlmTemp>
	</cfif>
	

<cfif len(trim(Arguments.articuloi)) gt 0 and  len(trim(Arguments.articulof)) gt 0>    
	 <cfif trim(Arguments.articuloi) neq  trim(Arguments.articulof)>   	 		
        <cfset LvarArt ="and a.Acodigo between '#Arguments.articuloi#' and '#Arguments.articulof#'">            
     <cfelseif trim(Arguments.articuloi) eq  trim(Arguments.articulof)>
        <cfset LvarArt ="and a.Acodigo = '#Arguments.articuloi#'">   
     </cfif>         
<cfelseif len(trim(Arguments.articuloi)) gt 0 and not len(trim(Arguments.articulof)) gt 0>    
	 <cfset LvarArt ="and a.Acodigo= '#Arguments.articuloi#'">
<cfelseif not len(trim(Arguments.articuloi)) gt 0 and len(trim(Arguments.articulof)) gt 0>        
	 <cfset LvarArt ="and a.Acodigo = '#Arguments.articulof#'">
<cfelse>
     <cfset LvarArt ="">
</cfif>         
 
<cf_dbfunction name="to_char" args="a.Aid" returnvariable = "Aid">
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
		a.Adescripcion,
		b.Bdescripcion, 
		c.Eexistencia, 
		c.Ecostou, 
		c.Ecostototal, 
		c.Esalidas, 
		#PreserveSingleQuotes(Aid)# as Aid,
		a.Acodigo,
		c.Eexistencia,
        c.Eestante, 
        c.Ecasilla,
        (select sum(dr.DRcantidad)
        	from ERequisicion er 
            	inner join DRequisicion dr
                	on dr.ERid = er.ERid
             where er.Aid = b.Aid
               and dr.Aid = a.Aid
               and er.Estado in (0,1)
               and er.ERidref is null
               ) as reqPedientes,
         (select sum(dr.DRcantidad)
        	from ERequisicion er 
            	inner join DRequisicion dr
                	on dr.ERid = er.ERid
             where er.Aid = b.Aid
               and dr.Aid = a.Aid
               and er.Estado in (0,1)
               and er.ERidref is NOT null
               ) as DebPedientes	
	    from Existencias c
			inner join Articulos a
				 on c.Aid 	  = a.Aid
				and c.Ecodigo = a.Ecodigo
			inner join Almacen b
			   	 on c.Ecodigo = b.Ecodigo
  				and c.Alm_Aid = b.Aid
			inner join Clasificaciones d
				on a.Ccodigo = d.Ccodigo
			   and a.Ecodigo = d.Ecodigo
               
		where c.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
  		  and b.Almcodigo between '#LvarAlmini#' and '#LvarAlmfin#'
		<cfif isdefined ('LvarClaini') and #LvarClaini# neq ''>
  		 and d.Ccodigoclas between '#LvarClaini#' 
		</cfif>
		<cfif isdefined ('LvarClafin') and #LvarClafin# neq ''>
		 and '#LvarClafin#'
		</cfif>
          #preserveSingleQuotes(LvarArt)#            
		order by b.Almcodigo, b.Bdescripcion
	</cfquery>	
	<cfreturn rsReporte>
  </cffunction>
</cfcomponent>
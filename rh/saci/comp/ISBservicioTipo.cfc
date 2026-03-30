<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBservicioTipo">


<cffunction name="ComparaServicios" output="false" returntype="query" access="remote">
  <cfargument name="cuentaid"	type="numeric"	required="Yes" 	displayname="Id de la Cuenta">
  <cfargument name="contratoid" type="numeric"	required="Yes" 	displayname="id del Paquete">
  <cfargument name="idLoginesA" type="string" 	default="" 		required="no"  	displayname="Lista de id de logines activos">	<!---Lista de los id de Logines activos, en caso de que se quiera tomar en cuenta solo algunos logines activos, si no por defecto toma todos los logines activos--->
  <cfargument name="idLoginesR" type="string" 	default="" 		required="no"  	displayname="Lista de id de logines retirados"> <!---Lista de los id de Logines retirados, en caso de que se quiera tomar en cuenta solo algunos logines retirados, si no por defecto toma todos los logines retirados--->
  <cfargument name="Ecodigo"	type="string"	required="No" 	default="#session.Ecodigo#" displayname="Codigo de la empresa">
  <cfargument name="conexion" 	type="string"	required="No"  	default="#session.DSN#" 	displayname="Conexion">
	
  <cfargument name="showServReprogramar"type="boolean"	required="No"  	default="true" 	displayname="Mostrar la cantidad de servicios por reprogramar">
  <cfargument name="showServPermitidos"	type="boolean"	required="No"  	default="true" 	displayname="Mostrar la cantidad de servicios permitidos por el paquete">
  <cfargument name="showServActivos"	type="boolean"	required="No"  	default="true" 	displayname="Mostrar la cantidad de servicios activos en el paquete">
  <cfargument name="showServInactivos"	type="boolean"	required="No"  	default="true" 	displayname="Mostrar la cantidad de servicios inactivos en el paquete">
  <cfargument name="showServMinimos"	type="boolean"	required="No"  	default="true" 	displayname="Mostrar la cantidad de servicios minimos en el paquete">
   	
	
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="plazoLogines">	<!---Consulta el plazo de vencimiento en dias para los logines que estan retirados--->
		<cfinvokeargument name="Pcodigo" value="40">
	</cfinvoke>
		
	<cfquery name="chkServicios" datasource="#Arguments.conexion#">
		select x.TScodigo,x.TSnombre
			
			<cfif Arguments.showServReprogramar>										<!---servicios a reprogramar que posee el producto actual en captura--->
				,coalesce((	select count(1)	from ISBproducto a
					inner join ISBlogin b
						on b.Contratoid = a.Contratoid	and b.Habilitado = 2
						<!---and datediff( day, b.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">	--->
						<cfif isdefined("Arguments.idLoginesR") and len(trim(Arguments.idLoginesR))>	and b.LGnumero in (<cfqueryparam  list="yes" cfsqltype="cf_sql_numeric" value="#Arguments.idLoginesR#">)</cfif>
					inner join ISBserviciosLogin c
						on c.LGnumero = b.LGnumero	and c.PQcodigo = a.PQcodigo	and c.TScodigo = x.TScodigo	and c.Habilitado = 1
					inner join ISBservicio e
						on e.PQcodigo = c.PQcodigo	and e.TScodigo = c.TScodigo	and e.Habilitado = 1
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuentaid#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.contratoid#">
						and a.CTcondicion not in ('C')), 0) as ServReprogramar 		
			</cfif>
			
			<cfif Arguments.showServInactivos>											<!---servicios Inactivos (Retirados cuyo plazo de reprogramacion esta vencido)que posee el producto--->
				,coalesce((	select count(1)	from ISBproducto a
					inner join ISBlogin b
						on b.Contratoid = a.Contratoid	and b.Habilitado = 4
						<!---and datediff( day, b.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) > <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">	--->
						<cfif isdefined("Arguments.idLoginesR") and len(trim(Arguments.idLoginesR))>	and b.LGnumero in (<cfqueryparam  list="yes" cfsqltype="cf_sql_numeric" value="#Arguments.idLoginesR#">)</cfif>
					inner join ISBserviciosLogin c
						on c.LGnumero = b.LGnumero	and c.PQcodigo = a.PQcodigo	and c.TScodigo = x.TScodigo	and c.Habilitado = 1
					inner join ISBservicio e
						on e.PQcodigo = c.PQcodigo	and e.TScodigo = c.TScodigo	and e.Habilitado = 1
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuentaid#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.contratoid#">
						and a.CTcondicion not in ('C')), 0) as ServInactivos 		
			</cfif>
			
			<cfif Arguments.showServActivos>
				,coalesce((	select count(1)	from ISBproducto a							<!---servicios activos que posee el producto actual en captura--->
					inner join ISBlogin b
						on b.Contratoid = a.Contratoid	and b.Habilitado = 1
						<cfif isdefined("Arguments.idLoginesA") and len(trim(Arguments.idLoginesA))>	and b.LGnumero in (<cfqueryparam  list="yes" cfsqltype="cf_sql_numeric" value="#Arguments.idLoginesA#">)</cfif>
					inner join ISBserviciosLogin c
						on c.LGnumero = b.LGnumero	and c.PQcodigo = a.PQcodigo	and c.TScodigo = x.TScodigo	and c.Habilitado = 1
					inner join ISBservicio e
						on e.PQcodigo = c.PQcodigo	and e.TScodigo = c.TScodigo	and e.Habilitado = 1
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuentaid#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.contratoid#">
						and a.CTcondicion not in ('C')), 0) as ServActivos 			
			</cfif>
			
			<cfif Arguments.showServPermitidos>	
				,coalesce((	select sum(b.SVcantidad)	from ISBproducto a				<!---servicios maximos que permite el paquete actual en captura--->
					inner join ISBservicio b
						on b.PQcodigo = a.PQcodigo	and b.TScodigo=x.TScodigo	and b.Habilitado = 1
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuentaid#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.contratoid#">
						and a.CTcondicion not in ('C')), 0) as ServPermitidos			
			</cfif>
				
			<cfif Arguments.showServMinimos>											<!---servicios minimos que permite el paquete actual en captura--->
			,coalesce((	select sum(b.SVminimo) from ISBproducto a
				inner join ISBservicio b
					on b.PQcodigo = a.PQcodigo	and b.TScodigo=x.TScodigo	and b.Habilitado = 1
				where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuentaid#">
					and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.contratoid#">
					and a.CTcondicion not in ('C')), 0) as ServMinimos				
			</cfif>
			
		from ISBservicioTipo x
		where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	</cfquery>
		
	<cfreturn chkServicios>
</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="TSnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="TSdescripcion" type="string" required="No" default="" displayname="Descripción">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="TSobservacion" type="string" required="No" default="" displayname="Observacioners">
  <cfargument name="TStipo" type="string" required="Yes" default="" displayname="Grupo de datos para Configuración">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBservicioTipo"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="TScodigo"
						type1="char"
						value1="#Arguments.TScodigo#">
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update ISBservicioTipo
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, TSnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TSnombre#" null="#Len(Arguments.TSnombre) Is 0#">
		, TSdescripcion = <cfif isdefined("Arguments.TSdescripcion") and Len(Trim(Arguments.TSdescripcion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TSdescripcion#"><cfelse>null</cfif>
		
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, TSobservacion = <cfif isdefined("Arguments.TSobservacion") and Len(Trim(Arguments.TSobservacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TSobservacion#"><cfelse>null</cfif>
		, TStipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TStipo#" null="#Len(Arguments.TStipo) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
	<cfquery datasource="#session.dsn#">
		update ISBservicioTipo
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBservicioTipo
		
		where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="TSnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="TSdescripcion" type="string" required="No" default="" displayname="Descripción">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="TStipo" type="string" required="Yes" displayname="Grupo de datos para Configuración">
  <cfargument name="TSobservacion" type="string" required="No" default="" displayname="Observaciones">

	<cfquery datasource="#session.dsn#">
		insert into ISBservicioTipo (
			
			TScodigo,
			Ecodigo,
			TSnombre,
			TSdescripcion,
			
			Habilitado,
			TSobservacion,
			TStipo,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TSnombre#" null="#Len(Arguments.TSnombre) Is 0#">,
			<cfif isdefined("Arguments.TSdescripcion") and Len(Trim(Arguments.TSdescripcion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TSdescripcion#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfif isdefined("Arguments.TSobservacion") and Len(Trim(Arguments.TSobservacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TSobservacion#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TStipo#" null="#Len(Arguments.TStipo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>


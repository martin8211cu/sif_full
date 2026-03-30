 <!--- 
	******************************************
	* CARGA INICIAL DE CENTROS FUNCIONALES
	* FECHA DE CREACIÃ“N:	09/04/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de generaraciÃ³n final
	* Este archivo requiere es para
	* realizar la copia final de la
	* atabla temporal a la tabla real.
	******************************************
--->

<!--- Inserta los Centros Funcionales --->
<cfquery datasource="#Gvar.Conexion#">		
	insert into CFuncional(	Ecodigo,	
							Dcodigo,	
							Ocodigo, 	
							CFpath, 	
							CFnivel, 	
							CFcodigo, 
     						CFdescripcion, 
							CFcorporativo ) 
	select 	#Gvar.Ecodigo#,
			c.Dcodigo, 
			b.Ocodigo, 
			' ', 
			0, 
			#Gvar.table_name#.CDRHHCFcodigo, 
			#Gvar.table_name#.CDRHHCFdescripcion, 
			0
			
	from #Gvar.table_name#
		inner join Oficinas b
			on #Gvar.table_name#.CDRHHOficodigo = b.Oficodigo
			and b.Ecodigo = #Gvar.Ecodigo#
		
		inner join Departamentos c
			on #Gvar.table_name#.CDRHHDptoCodigo = c.Deptocodigo
			and c.Ecodigo = #Gvar.Ecodigo#

	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>
<cfquery datasource="#Gvar.Conexion#">
	update CFuncional
	set CFidresp = (	select min(b.CFid)
						from #Gvar.table_name# a, CFuncional b 
						where CFuncional.CFcodigo  = a.CDRHHCFcodigo
							and CFuncional.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Gvar.Ecodigo#">
							and CFuncional.Ecodigo = b.Ecodigo  
							and ltrim(rtrim(b.CFcodigo))=ltrim(rtrim(a.CDRHHCFcodigoPadre)) 
					)

	where exists (	select 1
					from #Gvar.table_name# a, CFuncional b 
					where CFuncional.CFcodigo  = a.CDRHHCFcodigo
						and CFuncional.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Gvar.Ecodigo#">  
						and CFuncional.Ecodigo = b.Ecodigo  
						and ltrim(rtrim(b.CFcodigo))=ltrim(rtrim(a.CDRHHCFcodigoPadre)) 	
				 )
</cfquery>

<!--- Si no hay inconsistencias hace la siguiente actualización --->
<cfquery datasource="#Gvar.Conexion#">
	update CFuncional
	set CFidresp = null
	where Ecodigo = #Gvar.Ecodigo# 
    	and CFidresp = CFid
</cfquery>


<!---ACOMODA LOS NIVELES DE LOS CF --->

<cfset CFid = '' >
<cfset CFidt = '' >
<cfset CFidres = '' >
<cfset CFcodigo = '' >
<cfset nivel = '' >
<cfset path = '' >
<cfset salida = '' >

<cfquery name="rs_centro" datasource="#Gvar.Conexion#">
	select min(CFid) as id
	from CFuncional 
	where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Gvar.Ecodigo#">  
</cfquery>
<cfset CFid = rs_centro.id >

<cfloop condition="true">
	<cfset CFidt = CFid >
	<cfset nivel = 0 > 
	<cfset path = '' >
	<cfset salida = 0 >
	
	<cfloop condition="salida neq 1">
	
		<cfquery name="rs1" datasource="#gvar.conexion#">
			select CFcodigo,
				   CFidresp 
			from CFuncional
			where  CFid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidt#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Gvar.Ecodigo#">
		</cfquery>
		<cfset CFcodigo = rs1.CFcodigo >
		<cfset CFidres = rs1.CFidresp >		
		
		<cfif len(trim(CFidres))>
			<cfif len(trim(path)) eq 0>
				<cfset nivel = 1 >
				<cfset path = CFcodigo >
			<cfelse>
				<cfset nivel = nivel + 1 >
				<cfset path = trim(CFcodigo) & '/' & path >
			</cfif>
			<cfset CFidt = CFidres >
		<cfelse>
			<cfif len(trim(path)) eq 0 >
				<cfset nivel = 1 >
				<cfset path = CFcodigo >
			<cfelse>
				<cfset nivel = nivel +1 >
				<cfset path = CFcodigo & '/' & path >
			</cfif>
			<cfset salida = 1 >
		</cfif>
	</cfloop>
	<cfquery datasource="#gvar.conexion#">
		update CFuncional 
		set CFpath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">, 
			CFnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
	</cfquery>
	
	<cfquery name="rs_seguir" datasource="#gvar.conexion#">
		select min(CFid) as id
		from CFuncional
		where CFid  > <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Gvar.Ecodigo#">
	</cfquery>
	<cfset CFid = rs_seguir.id >
	<cfif len(trim(CFid)) eq 0 >
		<cfbreak>
	</cfif>
</cfloop>

<!--- FIN DE ACOMODO --->



<!---<cfdump var="#Gvar.Conexion#">


<!--- Inserta los Centros Funcionales --->
<cfquery datasource="#Gvar.Conexion#" name="bbb" >
	
	
	select 	#Gvar.Ecodigo#,
			c.Dcodigo, 
			b.Ocodigo, 
			' ', 
			0, 
			#Gvar.table_name#.CDRHHCFcodigo, 
			#Gvar.table_name#.CDRHHCFdescripcion, 
			0
			
	from #Gvar.table_name#
		inner join Oficinas b
			on #Gvar.table_name#.CDRHHOficodigo = b.Oficodigo
			and b.Ecodigo = #Gvar.Ecodigo#
		
		inner join Departamentos c
			on #Gvar.table_name#.CDRHHDptoCodigo = c.Deptocodigo
			and c.Ecodigo = #Gvar.Ecodigo#

	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<cf_dump var="#bbb#">
 --->
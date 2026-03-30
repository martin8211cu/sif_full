<cfparam name="url.Bid" 		default="0" >
<cfparam name="url.EcodigoASP" 	default="#session.EcodigoSDC#" >
<cfparam name="url.ERNid" 	 	default="0" >
<cfparam name="url.Estado" 	 	default="h" >

<cf_dbtemp name="Datos" returnvariable="Datos" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="Datos" 	type="char(220)"  	mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="data_tmpTEC" returnvariable="datos_temp_TEC" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="DEid" 		 	 type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="cedula" 		 type="char(20)"  	mandatory="no">
	<cf_dbtempcol name="nombre" 		 type="char(30)"  	mandatory="no">
	<cf_dbtempcol name="numeroCuenta" 	 type="char(17)"  	mandatory="no">
	<cf_dbtempcol name="monto"			 type="varchar(11)"	mandatory="no">			
	<cf_dbtempcol name="fechaemi" 		 type="char(8)"		mandatory="no">	
	<cf_dbtempcol name="constante1" 	 type="char(4)"		mandatory="no">	
	<cf_dbtempcol name="constante2" 	 type="varchar(200)"mandatory="no">		
</cf_dbtemp>

<cfset constante1 = "A01P">
<cfset prefijo = ''>
<cfif url.Estado EQ 'h'><cfset prefijo = 'H'></cfif>
<!--- Concatenador --->
<cf_dbfunction name="OP_concat" returnvariable="CAT" >	
<cfquery name="x" datasource="#session.DSN#">
	insert into #datos_temp_TEC#(DEid ,
								cedula, 
								nombre, 
								numeroCuenta,
								monto,								
								fechaemi,
								constante1,							
								constante2 
						    )

select 	a.DEid ,
		de.DEidentificacion as cedula,  
		<cf_dbfunction name="string_part" args="rtrim(coalesce(upper(de.DEapellido1),'')) #CAT# ' ' #CAT# rtrim(coalesce(upper(de.DEapellido2),'')) #CAT# ' ' #CAT# rtrim(coalesce(upper(de.DEnombre),''))|1|30" 	 delimiters="|"> , 
		de.DEcuenta as numeroCuenta,
		convert(varchar, convert(numeric, coalesce(a.#prefijo#DRNliquido, 0)*100)) as monto,	
	substring(convert(varchar, b.#prefijo#ERNffin,112), 1, 4)+ substring(	convert(varchar, b.#prefijo#ERNffin,112), 5, 2 )+  substring(convert(varchar,  b.#prefijo#ERNffin,112), 7, 2 ),
		'#constante1#' as constante1 ,	
	<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 200)#">	as constante2 
	
    from #prefijo#DRNomina a
    inner join #prefijo#ERNomina b
        on b.ERNid=a.ERNid 
    inner join  DatosEmpleado de
        on de.DEid=a.DEid 
    inner join Monedas m
        on m.Mcodigo=a.Mcodigo 
    inner join CalendarioPagos cp 
        on b.RCNid=cp.CPid 
    where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
    and de.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
    and a.#prefijo#DRNliquido > 0 
</cfquery>


<!--- quita los caracteres que no son letras ni digitos del nombre del empleado --->
<!--- no encontre la forma de hacerlo en base de datos, por eso el ciclo --->
<cfquery name="rs_nombre" datasource="#session.DSN#">
	select DEid, nombre from #datos_temp_TEC#
</cfquery>
<cfloop query="rs_nombre">
	<cfset nombre_nuevo = lcase(rs_nombre.nombre) >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"á","a","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"é","e","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"í","i","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ó","o","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ú","u","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ñ","n","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ä","a","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ë","e","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ï","i","ALL") >			
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ö","o","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ü","u","ALL") >		
	
	<cfset nombre_nuevo = REReplaceNoCase(nombre_nuevo,"[^A-Za-z0-9 ]","","ALL") >
	<cfset nombre_nuevo = ucase(nombre_nuevo) >	
	<cfquery datasource="#session.DSN#">
		update #datos_temp_TEC#
		set nombre = <cfqueryparam cfsqltype="cf_sql_char" value="#nombre_nuevo#">
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nombre.DEid#">
	</cfquery>
</cfloop>

<cf_dbfunction name="string_part" args="rtrim(cedula)|1|10" 	returnvariable="LvarCedula"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCedula#"  		returnvariable="LvarCedulaL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|10-coalesce(#LvarCedulaL#,0)" 	returnvariable="LvarCedulaS" delimiters="|">
				
<cf_dbfunction name="string_part" args="rtrim(nombre)|1|30" 	returnvariable="Lvarnombre"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarnombre#"  		returnvariable="LvarnombreL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|30-coalesce(#LvarnombreL#,0)" 	returnvariable="LvarnombreS" delimiters="|">

<cf_dbfunction name="string_part" args="rtrim(numeroCuenta)|1|17" 	returnvariable="LvarnumeroCuenta"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarnumeroCuenta#"  		returnvariable="LvarnumeroCuentaL" delimiters="|" >
        <cf_dbfunction name="sPart"      args="#LvarnumeroCuenta#|#LvarnumeroCuentaL#|1"  		returnvariable="LvarUltnumeroCuenta" delimiters="|" >
        
				<cf_dbfunction name="sRepeat"     args="' '|17-coalesce(#LvarnumeroCuentaL#,0)" 	returnvariable="LvarnumeroCuentaS" delimiters="|">
				
<cf_dbfunction name="to_char" args="monto" returnvariable="Lvarmonto">
	<cf_dbfunction name="string_part" args="rtrim(#Lvarmonto#)|1|11" 	returnvariable="LvarmontoStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarmontoStr#"  		returnvariable="LvarmontoStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat" args="' '|11-coalesce(#LvarmontoStrL#,0)" 	returnvariable="LvarmontoStrLS" delimiters="|">
				
<cf_dbfunction name="string_part" args="fechaemi|1|8" 	returnvariable="Lvarfechaemi"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarfechaemi#"  		returnvariable="LvarfechaemiL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|8-coalesce(#LvarfechaemiL#,0)" 	returnvariable="LvarfechaemiLS" delimiters="|">				
<cfquery name="ERR" datasource="#session.DSN#">
	select DEidentificacion#CAT#' '#CAT#nombre
    from #datos_temp_TEC# a
    inner join DatosEmpleado b
    	on b.DEid = a.DEid
   where <cf_dbfunction name="length" args="numeroCuenta"> <= 0
   union 
   select '000'#CAT#' '#CAT#'NO HA SIDO DEFINIDA LA CUENTA'
</cfquery>

<cfif ERR.RecordCount LTE 1>
	<cfquery name="ERR" datasource="#session.DSN#">
	select   rtrim(#preservesinglequotes(LvarCedulaS)#) #CAT# #preservesinglequotes(LvarCedula)# #CAT#
			 rtrim(#preservesinglequotes(Lvarnombre)#) #CAT# #preservesinglequotes(LvarnombreS)# #CAT#
			 rtrim(#preservesinglequotes(LvarnumeroCuenta)#) #CAT# #preservesinglequotes(LvarUltnumeroCuenta)#  #CAT# #preservesinglequotes(LvarnumeroCuentaS)# #CAT#
			 #preservesinglequotes(LvarmontoStrLS)# #CAT# rtrim(#preservesinglequotes(LvarmontoStr)#) #CAT#
			 rtrim(#preservesinglequotes(Lvarfechaemi)#) #CAT#
			 constante1 #CAT#
			 rtrim(#preservesinglequotes(Lvarfechaemi)#) #CAT#
			 constante2
	from #datos_temp_TEC#
	</cfquery>
</cfif>
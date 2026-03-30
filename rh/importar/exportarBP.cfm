<cftransaction>
	<cf_dbtemp name="RHExportarBPPR" returnvariable="RHExportarBPPR" datasource="#session.dsn#">
		<cf_dbtempcol name="orden"  type="smallint" mandatory="no">
		<cf_dbtempcol name="data"  	type="varchar(255)" mandatory="no">
	</cf_dbtemp>		 
 
<cf_dbfunction name="OP_concat" returnvariable="concat">

 <!--- Formateo Nombre --->
  <cf_dbfunction name="concat" args="rtrim(c.DEnombre),rtrim(c.DEapellido1),rtrim(c.DEapellido2)" 	returnvariable="LvarNombre"> <!--- ConcatenarNombres--->
	<cf_dbfunction name="string_part" args="#LvarNombre#|1|22" 	returnvariable="LvarSPNombre"  delimiters="|"> <!--- Primero 22 caracteres--->
		<cf_dbfunction name="length"      args="#LvarSPNombre#"  		returnvariable="LvarSPNombreL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|22-coalesce(#LvarSPNombreL#,0)" 	returnvariable="LvarSPNombreS" delimiters="|"> <!--- Espacios Adicionales--->
 
 
 
 <!--- Formateo Identificacion --->
	<cf_dbfunction name="string_part" args="rtrim(c.DEidentificacion)|1|11" 	returnvariable="LvarDEidentificacion"  delimiters="|"> <!--- Primero 11 caracteres--->
		<cf_dbfunction name="length"      args="#LvarDEidentificacion#"  		returnvariable="LvarDEidentificacionL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|11-coalesce(#LvarDEidentificacionL#,0)" 	returnvariable="LvarDEidentificacionS" delimiters="|"> <!--- Espacios Adicionales--->
 
                 
<!--- Formateo Iaba --->
 <cf_dbfunction name="string_part" args="coalesce(d.Iaba,'')|1|9" 	returnvariable="LvarIaba"  delimiters="|">  <!--- Primero 9 --->
		<cf_dbfunction name="length"      args="rtrim(#LvarIaba#)"  		returnvariable="LvarIabaL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|9-coalesce(#LvarIabaL#,0)" 	returnvariable="LvarIabaLS" delimiters="|"> <!--- Espacios Adicionales--->
                
                
<!--- Formateo a.CBcc --->
 <cf_dbfunction name="string_part" args="rtrim(a.CBcc)|1|9" 	returnvariable="LvarCBcc"  delimiters="|">  <!--- Primero 9 --->
		<cf_dbfunction name="length"      args="#LvarCBcc#"  		returnvariable="LvarCBccL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|9-coalesce(#LvarCBccL#,0)" 	returnvariable="LvarCBccLS" delimiters="|"> <!--- Espacios Adicionales--->
                

 <!--- Formateo Liquido --->   
 <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
			<cf_dbfunction name=to_char args=DRNliquido returnvariable="charLiquido"> <!---si es una nomina en proceso---->
 <cfelse>
 			<cf_dbfunction name=to_char args=HDRNliquido returnvariable="charLiquido"> <!---si es una nomina en historico---->
</cfif>
		<cf_dbfunction name="length"      args="rtrim(#charLiquido#)"  		returnvariable="LvarLiquido" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|10-coalesce(#LvarLiquido#,0)" 	returnvariable="LvarLiquidoS" delimiters="|"> <!--- Espacios Adicionales--->
                
                
	<cfquery name="ERR" datasource="#session.DSN#">
    		insert into #RHExportarBPPR# (orden, data)
		select 2,
		#preservesinglequotes(LvarSPNombre)#	 
           #concat#  #preservesinglequotes(LvarSPNombreS)#
                      
	       #concat#  #preservesinglequotes(LvarDEidentificacion)#	 
           #concat#  #preservesinglequotes(LvarDEidentificacionS)#
		
		  #concat# rtrim(#preservesinglequotes(LvarIaba)#)	  
          #concat#  #preservesinglequotes(LvarIabaLS)#

           #concat#  #preservesinglequotes(LvarCBcc)#	 
           #concat#  #preservesinglequotes(LvarCBccLS)#
		
		  #concat# '22'
		
		  #concat# #preservesinglequotes(charLiquido)#	 
		  #concat#  #preservesinglequotes(LvarLiquidoS)#
          
              <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
			     		from DRNomina a, ERNomina b, DatosEmpleado c, Bancos d <!---si es una nomina en proceso---->
		 <cfelse>
 				  	from HDRNomina a, HERNomina b, DatosEmpleado c, Bancos d <!---si es una nomina en historico---->
			</cfif>     

		where a.ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		and b.ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.Bid=d.Bid
		and a.ERNid=b.ERNid
		and a.DEid=c.DEid
		and a.Bid is not null
        
        
         <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
			     and a.DRNestado =1 <!---si es una nomina en proceso y se desea mostrar los que se van a pagar---->
		 <cfelse>
 				  and a.HDRNestado =1 <!---si es una nomina en historico y se desea mostrar los que se van a pagar---->
			</cfif>
   
	</cfquery>

 
	<cfquery name="rscheck1" datasource="#session.DSN#">
		select count(1) as c1
        
              <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
			     		from DRNomina a, ERNomina b <!---si es una nomina en proceso---->
			 <cfelse>
 				  	from HDRNomina a, HERNomina b <!---si es una nomina en historico---->
				</cfif>     
                
		where a.ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		and b.ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.ERNid=b.ERNid
		and a.Bid is not null
	</cfquery>
    
	<cfset bc1 = rscheck1.c1>

	<cfquery name="rscheck2" datasource="#session.DSN#">
		select count(1) as c2
		from #RHExportarBPPR#
	</cfquery>

	<cfset bc2 = rscheck2.c2>

	<cfif bc1 is not bc2>
		<cfquery name="ERR" datasource="#session.DSN#">""'""'
			select 'La cantidad de Personas generadas en el archivo para este Banco no concuerda con la cantidad de Personas en la Relación de Cálculo!' as Error
		</cfquery>
	</cfif>
	
	<cfquery name="ERR" datasource="#session.DSN#">
		select data 
		from #RHExportarBPPR#
		order by orden
	</cfquery>
	 
	<cfquery datasource="#session.DSN#">
		drop table #RHExportarBPPR#
	</cfquery>

</cftransaction>
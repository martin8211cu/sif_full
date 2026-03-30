<cfparam name="url.ERNid" type="numeric">
<cfparam name="url.Bid" type="numeric">

<cf_dbtemp name="reporte" returnvariable="reporte" datasource="#session.dsn#">
	<cf_dbtempcol name="Consecutivo"type="int" 			mandatory="no">
	<cf_dbtempcol name="RFC"  		type="char(13)" 	mandatory="no">
	<cf_dbtempcol name="TipoMovto"  type="char(2)" 		mandatory="no">
	<cf_dbtempcol name="Cuenta"  	type="char(20)" 	mandatory="no">
	<cf_dbtempcol name="Importeint" type="numeric" 		mandatory="no">
	<cf_dbtempcol name="Nombre"  	type="char(255)" 	mandatory="no">
	<cf_dbtempcol name="Campo1"  	type="char(3)" 	mandatory="no">
	<cf_dbtempcol name="Campo2"  	type="char(3)" 	mandatory="no">	
</cf_dbtemp>

<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cfif isdefined('url.Estado') and url.Estado EQ 'h'>
		
		<!---genera los datos--->
        
        	<!---	Version de nomina completa revisar esta mala ljimenez--->
<!---			<cfquery datasource="#session.DSN#" name = "datos">
			insert into #reporte#(Consecutivo,RFC,TipoMovto,Cuenta,Importeint,Nombre,Campo1,Campo2) 
				select 0 as Consecutivo,
				coalesce(<cf_dbfunction name="sPart" args="c.RFC,1,13">,'') as RFC,
				'99' as TipoMovto,
				<cf_dbfunction name="to_char" args ="coalesce(c.DEcuenta,'-1')"> as Cuenta,
				<cf_dbfunction name="to_integer" args ="round(round(a.HDRNliquido,2) * 100,0)"> as Importeint,
				coalesce(c.DEapellido1,'') #_Cat# '' #_Cat# coalesce(c.DEapellido2 ,'') #_Cat# '' #_Cat# coalesce(c.DEnombre,'') as Nombre,
				'001' as Campo1,	 
				'001' as Campo2
					
			from  HERNomina b
				  inner join  HDRNomina a
					on a.ERNid = b.ERNid
					and a.HDRNliquido > 0
				  inner join  DatosEmpleado c
					on c.DEid = a.DEid
				  inner join  HDRIncidencias d
				    on a.DRNlinea=d.DRNlinea
					 inner join CIncidentes e
					 on d.CIid=e.CIid
					 inner join ComponentesSalariales f
					 on e.CSid=f.CSid
					 and f.CSsalarioEspecie=1
			where 
				a.ERNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				and d.HDRICmontores > 0
		</cfquery> --->

        
		<cfquery datasource="#session.DSN#" name = "rsDatos">
			insert into #reporte#(Consecutivo,RFC,TipoMovto,Cuenta,Importeint,Nombre,Campo1,Campo2) 
                select 	0 as Consecutivo,
                    coalesce(<cf_dbfunction name="sPart" args="c.RFC,1,13">,'RFC') as RFC,
                    '99' as TipoMovto,
                    <cf_dbfunction name="to_char" args ="coalesce(c.DEcuenta,'-1')"> as Cuenta,
                      <cf_dbfunction name="to_integer" args ="round(round(sum(h.ICmontores),0) * 100,0)"> as Importeint,
                    coalesce(c.DEapellido1,'') #_Cat# ' ' #_Cat# coalesce(c.DEapellido2 ,'') #_Cat# ' ' #_Cat# coalesce(c.DEnombre,'') as Nombre,
                    '001' as Campo1,	 
                    '001' as Campo2
                from HERNomina b
                    inner join HIncidenciasCalculo h
                        on b.RCNid = h.RCNid
					<!---	and h.ICmontores > 0 --->
                    inner join DatosEmpleado c
                        on h.DEid = c.DEid
                    inner join CIncidentes e
					 on h.CIid = e.CIid
					 inner join ComponentesSalariales f
					 on e.CSid = f.CSid
					 and f.CSsalarioEspecie=1
                where b.ERNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
                and h.ICespecie = 0
                group by h.DEid, coalesce(<cf_dbfunction name="sPart" args="c.RFC,1,13">,'RFC'),  
                	<cf_dbfunction name="to_char" args ="coalesce(c.DEcuenta,'-1')">,
                     coalesce(c.DEapellido1,'') #_Cat# ' ' #_Cat# coalesce(c.DEapellido2 ,'') #_Cat# ' ' #_Cat# coalesce(c.DEnombre,'')
		</cfquery>
        
       <!--- SML. Modificacion para que sume los vales de despensa que son de tipo Incidencia--->
       <cfquery datasource="#session.DSN#" name = "rsDatos">
			insert into #reporte#(Consecutivo,RFC,TipoMovto,Cuenta,Importeint,Nombre,Campo1,Campo2) 
                select 	0 as Consecutivo,
                    coalesce(<cf_dbfunction name="sPart" args="c.RFC,1,13">,'RFC') as RFC,
                    '99' as TipoMovto,
                    <cf_dbfunction name="to_char" args ="coalesce(c.DEcuenta,'-1')"> as Cuenta,
                      <cf_dbfunction name="to_integer" args ="round(round(sum(h.ICmontores),0) * 100,0)"> as Importeint,
                    coalesce(c.DEapellido1,'') #_Cat# ' ' #_Cat# coalesce(c.DEapellido2 ,'') #_Cat# ' ' #_Cat# coalesce(c.DEnombre,'') as Nombre,
                    '001' as Campo1,	 
                    '001' as Campo2
                from HERNomina b
                    inner join HIncidenciasCalculo h
                        on b.RCNid = h.RCNid
					<!---	and h.ICmontores > 0 --->
                    inner join DatosEmpleado c
                        on h.DEid = c.DEid
                    inner join CIncidentes e
					 on h.CIid = e.CIid
					<!--- inner join ComponentesSalariales f
					 on e.CSid = f.CSid--->
					 and e.CIespecie = 1
                where b.ERNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
                and h.ICespecie = 0
                group by h.DEid, coalesce(<cf_dbfunction name="sPart" args="c.RFC,1,13">,'RFC'),  
                	<cf_dbfunction name="to_char" args ="coalesce(c.DEcuenta,'-1')">,
                     coalesce(c.DEapellido1,'') #_Cat# ' ' #_Cat# coalesce(c.DEapellido2 ,'') #_Cat# ' ' #_Cat# coalesce(c.DEnombre,'')
		</cfquery>
        <!--- SML. Modificacion para que sume los vales de despensa que son de tipo Incidencia--->
                
	
		<!---genera el consecutivo--->
		<cfquery name="rsConsecutivo" datasource="#session.DSN#">
			select Consecutivo, RFC, TipoMovto, Cuenta, sum (Importeint) as Importeint, Nombre, Campo1, Campo2 
            from #reporte# 
            group by Consecutivo, RFC, TipoMovto, Cuenta,Nombre, Campo1, Campo2
		</cfquery>
        <!---<cf_dump var = "#rsConsecutivo#">--->
		<cfset cont = 1>
		<cfloop query="rsConsecutivo">
			<cfquery datasource="#session.DSN#">
				update #reporte# 
				set  Consecutivo = #cont#
				where Cuenta ='#rsConsecutivo.Cuenta#'
				and Nombre ='#rsConsecutivo.Nombre#'
			</cfquery>
			<cfset cont = cont+1>
		</cfloop>

<cf_dbfunction name="to_char" args="Consecutivo" returnvariable="LvarConsecutivo">
	<cf_dbfunction name="string_part" args="rtrim(#LvarConsecutivo#)|1|9" 	returnvariable="LvarConsecutivoStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarConsecutivoStr#"  		returnvariable="LvarConsecutivoStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|9-coalesce(#LvarConsecutivoStrL#,0)" 	returnvariable="ConsecutivoFinal" delimiters="|">

<cf_dbfunction name="to_char" args="RFC" returnvariable="LvarRFC">
	<cf_dbfunction name="string_part" args="rtrim(#LvarRFC#)|1|16" 	returnvariable="LvarRFCStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarRFCStr#"  		returnvariable="LvarRFCStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|16-coalesce(#LvarRFCStrL#,0)" 	returnvariable="RFCFinal" delimiters="|">
                
<cf_dbfunction name="to_char" args="Cuenta" returnvariable="LvarCuenta">
	<cf_dbfunction name="string_part" args="rtrim(#LvarCuenta#)|1|20" 	returnvariable="LvarCuentaStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCuentaStr#"  		returnvariable="LvarCuentaStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|20-coalesce(#LvarCuentaStrL#,0)" 	returnvariable="CuentaFinal" delimiters="|"> 
                
<cf_dbfunction name="to_char" args="Importeint" returnvariable="LvarImporteint">
	<cf_dbfunction name="string_part" args="rtrim(#LvarImporteint#)|1|15" 	returnvariable="LvarImporteintStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarImporteintStr#"  		returnvariable="LvarImporteintStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|15-coalesce(#LvarImporteintStrL#,0)" 	returnvariable="ImporteintFinal" delimiters="|">   
                                               
<cf_dbfunction name="to_char" args="Nombre" returnvariable="LvarNombre">
	<cf_dbfunction name="string_part" args="rtrim(#LvarNombre#)|1|40" 	returnvariable="LvarNombreStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarNombreStr#"  		returnvariable="LvarNombreStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|40-coalesce(#LvarNombreStrL#,0)" 	returnvariable="NombreFinal" delimiters="|">                  
		<!---concatena la hilera final--->

				<cfquery name="ERR" datasource="#session.DSN#">
			select  right(('000000000'+convert(varchar,#preservesinglequotes(LvarConsecutivoStr)#)),9) #_CAT# ','#_CAT#
		            'RFC,97,' #_CAT#
                    ltrim(#preservesinglequotes(LvarCuentaStr)#) #_CAT#','#_CAT#
                     right(('000000000000000'+convert(varchar,#preservesinglequotes(LvarImporteintStr)#)),15) #_CAT#','#_CAT#
                     #preservesinglequotes(NombreFinal)# #_CAT# #_CAT# #preservesinglequotes(LvarNombreStr)# #_CAT#','#_CAT#                     
					'001,001' 	from  #reporte# 	
		</cfquery>
<cfelse>
	
	  <!---genera los datos--->
		<cfquery datasource="#session.DSN#" name="datos">
			insert into #reporte#(Consecutivo,RFC,TipoMovto,Cuenta,Importeint,Nombre,Campo1,Campo2) 
			select 
				0 as Consecutivo,
				coalesce(<cf_dbfunction name="sPart" args="c.RFC,1,13">,'') as RFC,
				'97' as TipoMovto,
				<cf_dbfunction name="to_char" args ="coalesce(c.DEcuenta,'-1')"> as Cuenta,
				<cf_dbfunction name="to_integer" args ="round(round(d.ICmontores,2) * 100,0)"> as Importeint,
				coalesce(c.DEapellido1,'') #_Cat# '' #_Cat# coalesce(c.DEapellido2 ,'') #_Cat# '' #_Cat# coalesce(c.DEnombre,'') as Nombre,
				'001' as Campo1,	 
				'001' as Campo2
					
			from  ERNomina b
				  inner join  DRNomina a
					on a.ERNid = b.ERNid
				  inner join  DatosEmpleado c
					on c.DEid = a.DEid
				  inner join  DRIncidencias d
				    on a.DRNlinea=d.DRNlinea
					 inner join CIncidentes e
					 on d.CIid=e.CIid
					 inner join ComponentesSalariales f
					 on e.CSid=f.CSid
					 and f.CSsalarioEspecie=1
			where 
				a.ERNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				and d.ICmontores > 0
		</cfquery>
        <!--- SML. Modificacion para que sume los vales de despensa que son de tipo Incidencia--->
        <cfquery datasource="#session.DSN#" name="datos">
			insert into #reporte#(Consecutivo,RFC,TipoMovto,Cuenta,Importeint,Nombre,Campo1,Campo2) 
			select 
				0 as Consecutivo,
				coalesce(<cf_dbfunction name="sPart" args="c.RFC,1,13">,'') as RFC,
				'97' as TipoMovto,
				<cf_dbfunction name="to_char" args ="coalesce(c.DEcuenta,'-1')"> as Cuenta,
				<cf_dbfunction name="to_integer" args ="round(round(d.ICmontores,2) * 100,0)"> as Importeint,
				coalesce(c.DEapellido1,'') #_Cat# '' #_Cat# coalesce(c.DEapellido2 ,'') #_Cat# '' #_Cat# coalesce(c.DEnombre,'') as Nombre,
				'001' as Campo1,	 
				'001' as Campo2
					
			from  ERNomina b
				  inner join  DRNomina a
					on a.ERNid = b.ERNid
				  inner join  DatosEmpleado c
					on c.DEid = a.DEid
				  inner join  DRIncidencias d
				    on a.DRNlinea=d.DRNlinea
					 inner join CIncidentes e
					 on d.CIid=e.CIid
                     e.CIespecie = 1
					 <!---inner join ComponentesSalariales f
					 on e.CSid=f.CSid
					 and f.CSsalarioEspecie=1--->
			where 
				a.ERNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				and d.ICmontores > 0
		</cfquery>
        
        <!--- SML. Modificacion para que sume los vales de despensa que son de tipo Incidencia--->
		<!---genera el consecutivo--->
		<cfquery name="rsConsecutivo" datasource="#session.DSN#">
			select * from #reporte# 
		</cfquery>
		<cfset cont = 1>
		<cfloop query="rsConsecutivo">
			<cfquery datasource="#session.DSN#">
				update #reporte# 
				set  Consecutivo = #cont#
				where Cuenta ='#rsConsecutivo.Cuenta#'
				and Nombre ='#rsConsecutivo.Nombre#'
			</cfquery>
			<cfset cont = cont+1>
		</cfloop>
        
<cf_dbfunction name="to_char" args="Consecutivo" returnvariable="LvarConsecutivo">
	<cf_dbfunction name="string_part" args="rtrim(#LvarConsecutivo#)|1|9" 	returnvariable="LvarConsecutivoStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarConsecutivoStr#"  		returnvariable="LvarConsecutivoStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|9-coalesce(#LvarConsecutivoStrL#,0)" 	returnvariable="ConsecutivoFinal" delimiters="|">

<cf_dbfunction name="to_char" args="RFC" returnvariable="LvarRFC">
	<cf_dbfunction name="string_part" args="rtrim(#LvarRFC#)|1|16" 	returnvariable="LvarRFCStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarRFCStr#"  		returnvariable="LvarRFCStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|16-coalesce(#LvarRFCStrL#,0)" 	returnvariable="RFCFinal" delimiters="|">
                
<cf_dbfunction name="to_char" args="Cuenta" returnvariable="LvarCuenta">
	<cf_dbfunction name="string_part" args="rtrim(#LvarCuenta#)|1|20" 	returnvariable="LvarCuentaStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCuentaStr#"  		returnvariable="LvarCuentaStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|20-coalesce(#LvarCuentaStrL#,0)" 	returnvariable="CuentaFinal" delimiters="|"> 
                
<cf_dbfunction name="to_char" args="Importeint" returnvariable="LvarImporteint">
	<cf_dbfunction name="string_part" args="rtrim(#LvarImporteint#)|1|15" 	returnvariable="LvarImporteintStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarImporteintStr#"  		returnvariable="LvarImporteintStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|15-coalesce(#LvarImporteintStrL#,0)" 	returnvariable="ImporteintFinal" delimiters="|">   
                                               
<cf_dbfunction name="to_char" args="Nombre" returnvariable="LvarNombre">
	<cf_dbfunction name="string_part" args="rtrim(#LvarNombre#)|1|40" 	returnvariable="LvarNombreStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarNombreStr#"  		returnvariable="LvarNombreStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|40-coalesce(#LvarNombreStrL#,0)" 	returnvariable="NombreFinal" delimiters="|">                  
		<!---concatena la hilera final--->
		<cfquery name="ERR" datasource="#session.DSN#">
			select  #preservesinglequotes(ConsecutivoFinal)# #_CAT#
		            #preservesinglequotes(RFCFinal)# #_CAT#	
                    '97' #_CAT#
                    #preservesinglequotes(CuentaFinal)# #_CAT#
                    #preservesinglequotes(ImporteintFinal)# #_CAT#  
                    #preservesinglequotes(NombreFinal)# #_CAT#                       
					Campo1 #_Cat#	Campo2	from  #reporte# 	
		</cfquery>
        <cf_dump var="#ERR#">
</cfif>




<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="Trabajo" returnvariable="Trabajo" datasource="#session.DSN#">
    <cf_dbtempcol name="Empresa"   			type="varchar(15)" mandatory="yes">
    <cf_dbtempcol name="ETLCid"   			type="numeric"     mandatory="no">
    <cf_dbtempcol name="Cedula"    			type="varchar(15)" mandatory="yes">
    <cf_dbtempcol name="mascara"   			type="varchar(15)" mandatory="yes">
    <cf_dbtempcol name="Nombre"   			type="varchar(100)" mandatory="no">
    <cf_dbtempcol name="Apellido1"   		type="varchar(80)" mandatory="no">
    <cf_dbtempcol name="Apellido2"   		type="varchar(80)" mandatory="no">
    <cf_dbtempcol name="FTLCdescricion1"   	type="varchar(50)" mandatory="no">
    <cf_dbtempcol name="FTLCdescricion2"   	type="varchar(50)" mandatory="no">
    <cf_dbtempcol name="FTLCdescricion3"   	type="varchar(50)" mandatory="no">
    <cf_dbtempcol name="FTLCdescricion4"   	type="varchar(50)" mandatory="no">
    
</cf_dbtemp> 

<cfquery name="rsPersonas" datasource="#session.DSN#">
	select  hilera
	from #table_name# a	
</cfquery>

<cfset list1 = "1,2,3,4,5,6,7,8,9,0">
<cfset list2 = "X,X,X,X,X,X,X,X,X,X">
<cfloop query="rsPersonas">
	<cfset arreglo = listtoarray(rsPersonas.hilera)>
    <cfset largo   = arraylen(arreglo)> 
    <cfquery name="inshilera" datasource="#session.DSN#">
    	insert into #Trabajo# (Empresa,Cedula,Nombre,Apellido1,Apellido2,FTLCdescricion1,FTLCdescricion2,FTLCdescricion3,FTLCdescricion4,mascara)
        values(
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[1]#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[2]#">,
        	<cfif largo gte 3  and len(trim(arreglo[3]))>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[3]#">,	
			<cfelse>
            	null,
			</cfif>
            <cfif largo gte 4  and len(trim(arreglo[4]))>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[4]#">,	
			<cfelse>
            	null,
			</cfif>
            <cfif largo gte 5  and len(trim(arreglo[5]))>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[5]#">,	
			<cfelse>
            	null,
			</cfif>
            <cfif  largo gte 6  and   len(trim(arreglo[6]))>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[6]#">,	
			<cfelse>
            	null,
			</cfif>
            <cfif  largo gte 7  and  len(trim(arreglo[7]))>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[7]#">,	
			<cfelse>
            	null,
			</cfif>
            <cfif  largo gte 8  and len(trim(arreglo[8]))>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[8]#">,	
			<cfelse>
            	null,
			</cfif>
            <cfif  largo gte 9  and len(trim(arreglo[9]))>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arreglo[9]#">,	
			<cfelse>
            	null,
			</cfif>
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ReplaceList(trim(arreglo[2]),list1,list2)#">
         )
    </cfquery>	
</cfloop>

<cfquery name="rsPersonas" datasource="#session.DSN#">
	select *
	from #Trabajo# a	
</cfquery>


<!--- Valida que vengas solo una empresa.  --->
<cfquery name="rsCheck1" datasource="#session.DSN#">
    select Empresa 
	from #Trabajo# 
	group by Empresa
	having count(1) > 1	
</cfquery>

<cfif rsCheck1.RecordCount eq 0>
    <cfquery name="INS_Error" datasource="#session.DSN#">
	    insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
    	values ('Solo se puede importar personas de una empresa por archivo ',1)
    </cfquery>
<cfelse>
	<!--- Valida que la empresa sea valida  --->
    <cfquery name="INS_Error" datasource="#session.DSN#" >
        insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
        select 'No existe una empresa con la cédula jurídica :' + x.Empresa  ,2
        from #Trabajo# x
        where  ltrim(rtrim(x.Empresa)) not in (
            select ltrim(rtrim(a.ETLCpatrono)) 
            from EmpresasTLC  a 
            where a.ETLCespecial != 1)
    </cfquery>

    <cfquery name="buscaEmpresa" datasource="#session.DSN#">
    	select ETLCid from EmpresasTLC 
        where exists ( select distinct Empresa from #Trabajo# where EmpresasTLC.ETLCpatrono = #Trabajo#.Empresa )
    </cfquery>
    
    <cfif buscaEmpresa.RecordCount eq 1>
    
    	<cfquery name="updatecod" datasource="#Session.DSN#">
        	update  #Trabajo# set ETLCid = #buscaEmpresa.ETLCid#
        </cfquery>

        <cfquery name="rsFormato" datasource="#Session.DSN#">
            select 
                FTLCformato
            from  EmpFormatoTLC	
            where  ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscaEmpresa.ETLCid#" >	
        </cfquery>  
        
        <cfif rsFormato.RecordCount eq 0>
        	 <cfquery name="INS_Error" datasource="#session.DSN#">
                insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
                values ('La empresa no tiene definido aún el formato de la cédula',3)
            </cfquery>
		<cfelse>
        	<cfif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 1>
            	<cfset mascara = "XXXXXXXXX">
			<cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 2>
            	<cfset mascara = "XXXXXXX">
			<cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 3>
            	<cfset mascara = "X-XXXX-XXXX">
			<cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 4>
            	<cfset mascara = "X-XXX-XXX">
			</cfif>
            <cfquery name="INS_Error" datasource="#session.DSN#" >
                insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
                select 'La cédula :' + x.Cedula + ' no tiene el formato definido para la empresa ' + '#mascara#' ,4
                from #Trabajo# x
                where  ltrim(rtrim(x.mascara)) != <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(mascara)#">
            </cfquery>
		</cfif>
	</cfif>
</cfif>

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by Mensaje,ErrorNum
</cfquery>

<cfif (err.recordcount) EQ 0>
    <cftransaction>
        <cfquery name="del_Registros" datasource="#session.DSN#" >
            delete TLCPersonas where exists (
                select 1 from #Trabajo# 
                where TLCPersonas.ETLCid = #Trabajo#.ETLCid 
                and  TLCPersonas.TLCPcedula  = #Trabajo#.Cedula )
        </cfquery>
        
        <cfquery name="INS_Registros" datasource="#session.DSN#" >
            insert into TLCPersonas (TLCPcedula,ETLCid,TLCPnombre,TLCPapellido1,TLCPapellido2,TLCPCampo1,TLCPCampo2,TLCPCampo3,TLCPCampo4)
            select 
                Cedula,
                ETLCid,
                Nombre,
                Apellido1,
                Apellido2,
                FTLCdescricion1,
                FTLCdescricion2,
                FTLCdescricion3,
                FTLCdescricion4
            from #Trabajo# 
        </cfquery>
    </cftransaction>
    <cfquery name="rs_TLCPersonas" datasource="#session.DSN#">
    	select TLCPcedula,TLCPCampo1 from TLCPersonas
        where  ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscaEmpresa.ETLCid#" >	
    </cfquery>
    <cfif rs_TLCPersonas.recordCount GT 0>
        <cfquery name="rs_EmpresasTLC" datasource="#Session.DSN#">
            select ETLCid   from EmpresasTLC 
            where ETLCespecial =  1
        </cfquery>
       
        <cftransaction>
            <cfquery name="updatePersonasTLC" datasource="#Session.DSN#">
                update  TLCPersonas  set TLCPSincronizado = 0
                where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscaEmpresa.ETLCid#">
            </cfquery>
            
            <cfquery name="updatePersonasTLC" datasource="#Session.DSN#">
                delete TLCSincronizar 
                where  TLCSeref  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscaEmpresa.ETLCid#">
            </cfquery>
            
    		<cfset cedula ="">
            <cfloop query="rs_TLCPersonas">	
            	<cfset cedula = fnFormatoCedula(rsFormato.FTLCformato,rs_TLCPersonas.TLCPcedula)>
                <cfquery name="rs_sincronizacion" datasource="#Session.DSN#">
                    select  TLCPcedula  from TLCPadronE
                    where TLCPcedula =  <cfqueryparam cfsqltype="cf_sql_char" value="#cedula#">
                </cfquery>
                <cfif rs_sincronizacion.recordCount GT 0>
                    <cfquery name="insertTLCSincronizar" datasource="#Session.DSN#">
                        insert into TLCSincronizar (TLCSepivote,TLCSeref,TLCScedula,TLCSreferencia)
                        values(
                             <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_EmpresasTLC.ETLCid#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscaEmpresa.ETLCid#">,
                            <cfqueryparam cfsqltype="cf_sql_char"    value="#rs_sincronizacion.TLCPcedula#">,
                            <cfqueryparam cfsqltype="cf_sql_char"    value="#rs_TLCPersonas.TLCPCampo1#">
                        )
                    </cfquery>
                    <cfquery name="updatePersonasTLC" datasource="#Session.DSN#">
                        update  TLCPersonas  set TLCPSincronizado = 1
                        where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscaEmpresa.ETLCid#">
                        and TLCPcedula = <cfqueryparam cfsqltype="cf_sql_char" value="#rs_TLCPersonas.TLCPcedula#">
                    </cfquery>
                </cfif>            
			</cfloop>	
        </cftransaction>
	</cfif>
)
</cfif>



<cffunction name="fnFormatoCedula" output="yes" access="private">
	<cfargument name="tipo"		type="string" required="yes">
	<cfargument name="valor" 	type="string" required="yes">
    <cfset var Lvarcedula = "">
    <cfset var Lvartipo		= Arguments.tipo>
    <cfset var Lvarvalor	= Arguments.valor>
    
    <cfswitch expression="#Lvartipo#">    
    	<cfcase value="1">
        	<cfset Lvarcedula = Lvarvalor>
        </cfcase>
        <cfcase value="2">
        	<cfset Lvarcedula  = Insert('0',Lvarvalor,  1)>
            <cfset Lvarcedula  = Insert('0',Lvarcedula,  5)>
        </cfcase>
        <cfcase value="3">
        	<cfset Lvarcedula = replace(Lvarvalor, '-','','all')>
        </cfcase>
        <cfcase value="4">
           <cfset Lvarcedula = replace(Lvarvalor, '-','0','all')>
        </cfcase>
    </cfswitch>
	<cfreturn Lvarcedula>
</cffunction>


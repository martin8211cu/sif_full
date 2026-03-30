<cfif IsDefined("form.cambio")>

<cfset arr1    = ListToArray(form.TESid  , ',', false)>
<cfset arrLen1 = ArrayLen(arr1)>

<cfset arr2    = ListToArray(form.TESOPid  , ',', false)>
<cfset arrLen2 = ArrayLen(arr2)>

<cfset arr3    = ListToArray(form.TESCFDnumFormulario  , ',', false)>
<cfset arrLen3 = ArrayLen(arr3)>

<cfset arr4    = ListToArray(form.TESMPcodigo  , ',', false)>
<cfset arrLen4 = ArrayLen(arr4)>

<cfset arr5    = ListToArray(form.CBid  , ',', false)>
<cfset arrLen5 = ArrayLen(arr5)>
	   	
        <cfloop index="i" from="1" to="#arrLen1#">                                         
		 
            <cfset LvarTESOPid              =  #ListGetAt(arr2[i], 1 ,',')#>      
            <cfset LvarTESCFDnumFormulario  =  #ListGetAt(arr3[i], 1 ,',')#> 
            <cfset LvarTESMPcodigo          =  #ListGetAt(arr4[i], 1 ,',')#> 
            <cfset LvarCBid                 =  #ListGetAt(arr5[i], 1 ,',')#>     

                    <cftransaction>
                        <cfquery datasource="#session.dsn#">
                                    update TEScontrolFormulariosB
                                       set TESCFBultimo = 0
                                         , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                                     where TESid                   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
                                       and CBid                    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBid#">
                                       and TESMPcodigo             = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTESMPcodigo#">
                                       and TESCFDnumFormulario     = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTESCFDnumFormulario#">
                        </cfquery>
                        <cfquery datasource="#session.dsn#">
                                    insert into TEScontrolFormulariosB
                                                (
                                                    TESid, CBid, TESMPcodigo, TESCFDnumFormulario, 
                                                    TESCFBultimo, UsucodigoCustodio,
                                                    TESCFBfecha, TESCFEid, TESCFLUid, TESCFBobservacion, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
                                                )
                                    values
                                                (
                                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBid#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTESMPcodigo#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTESCFDnumFormulario#">
                                                    ,1
                                                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFEid#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLUid#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFBobservacion#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                                                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                                                )
                        </cfquery>
                    </cftransaction>	
                    
      </cfloop>              
</cfif>
<cflocation url="Cambio_Custodia_Cheques_Masivo.cfm">

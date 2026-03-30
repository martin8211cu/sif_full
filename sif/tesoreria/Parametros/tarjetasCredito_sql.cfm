<cfif IsDefined("form.btnAgregar")>
	<cfparam name="form.CBid"	default="-1">
    
    <cftransaction>
    	
        <cfquery name="rsExiste" datasource="#session.dsn#">
        	select CBid from TEScuentasBancos 
            where TESid =  #session.Tesoreria.TESid#
            	and CBid=#form.CBid#
        </cfquery>
        
        <cfif rsExiste.recordcount eq 0>        
            <cfquery datasource="#session.dsn#">
                insert into  TEScuentasBancos
                (TESid, CBid, TESCBactiva) 
                values 
                ( #session.Tesoreria.TESid#, #form.CBid#, 1)
            </cfquery>
		</cfif>        
	</cftransaction>
</cfif>		


<cfif IsDefined("url.ActivarDesactivar")>
	 <cfquery datasource="#session.dsn#">
        update TEScuentasBancos
        set TESCBactiva =#url.Act# 
        where TESid = #session.Tesoreria.TESid#
          AND CBid	= #url.CBid#
    </cfquery>

</cfif>


<cflocation url="tarjetasCredito.cfm">
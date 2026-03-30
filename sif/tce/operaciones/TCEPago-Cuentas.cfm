<cfif len(trim(#url.Bid#)) gt 0>

	<cfif isdefined("URL.Error") and URL.Error eq 1>
	
        <!--- Este caso se da cuando se tienen detalles y la Cta Origen y la Destino tienen monedas diferentes --->
    
        <cfquery name="rsNombreCDestino" datasource="#Session.DSN#">
        select 	coalesce(a.Miso4217,'(NA)') as Miso4217
        from TEStransferenciaP a
            inner join Monedas m
                on m.Miso4217 = a.Miso4217
                and m.Ecodigo = #session.Ecodigo#
        where TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESTPid#">
        </cfquery>    
    
    	<script language="javascript1.2" type="text/javascript">    
			window.parent.document.form1.CtaDestino.length = 1;	
			window.parent.document.form1.CtaDestino.options[0].value = '';
			window.parent.document.form1.CtaDestino.options[0].text  = "Debe seleccionar una cuenta en: <cfoutput>#rsNombreCDestino.Miso4217#</cfoutput>";	    
		</script>
        
    <cfelse>

		<!--- Query que busca la mascara segun la marca de tarjeta seleccionada --->
        <cfquery name="rsCDestino" datasource="#Session.DSN#">
        select 	TESTPid,
                TESid,
                TESTPcuenta as TESTPcuentab, 
                Mnombre,
                a.TESBid, 
                coalesce(a.Bid,0) as Bid,
                a.Miso4217
        from TEStransferenciaP a
            left join Pais p
                on p.Ppais = a.Ppais
            inner join Monedas m
                on m.Miso4217 = a.Miso4217
                and m.Ecodigo = #session.Ecodigo#
        where TESTPestado < 2
        and coalesce(TESBid,0) <> 0  
        and a.TESBid = #url.Bid# 
        and a.Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#url.moneda#">
        </cfquery>
        <cfif rsCDestino.recordcount gt 0 > 
            <script language="javascript1.2" type="text/javascript">
                i = 0;
                <cfoutput query="rsCDestino">
                    window.parent.document.form1.CtaDestino.length = i+1;
                    window.parent.document.form1.CtaDestino.options[i].value = '#rsCDestino.TESTPid#';
                    window.parent.document.form1.CtaDestino.options[i].text  = '#rsCDestino.Mnombre# - #rsCDestino.TESTPcuentab#';
                    <cfif isdefined("URL.TESTPid") and URL.TESTPid eq rsCDestino.TESTPid>
                        window.parent.document.form1.CtaDestino.options[i].selected = true;
                    </cfif>
                    i++;
                </cfoutput>
            </script>
        <cfelse>
            <script language="javascript1.2" type="text/javascript">
               i=0;
               window.parent.document.form1.CtaDestino.length = i+1;	
               window.parent.document.form1.CtaDestino.options[i].value = '';
               window.parent.document.form1.CtaDestino.options[i].text  = 'No existen cuentas en: <cfoutput>#url.moneda#</cfoutput> para el emisor seleccionado';
            </script>   
        </cfif>
    
    </cfif>
    
<cfelse>
   
</cfif>	


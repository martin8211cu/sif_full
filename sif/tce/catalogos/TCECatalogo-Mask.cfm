<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfif len(trim(#url.CBTMid#)) gt 0>
	<!--- Query que busca la mascara segun la marca de tarjeta seleccionada --->
    <cfquery name="rsMascara" datasource="#Session.DSN#">
        select CBTMid, CBTMarca, CBTMascara
        from CBTMarcas
            where CBTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBTMid#">
    </cfquery>
    <cfif rsMascara.recordcount gt 0 > 
        <cfoutput>
            <script language="javascript1.2" type="text/javascript">
                window.parent.document.form1.SNmask.value = '#rsMascara.CBTMascara#' ;
                <!---window.parent.document.form1.SNmask.disabled = true;--->
            </script>
        </cfoutput>
    <cfelse>
       <cfthrow message="No se ha obtenido la mascara de la marca de la tarjeta!">     
    </cfif>
<cfelse>
   <cfthrow message="No se ha obtenido el identificador de la marca de la tarjeta!">
</cfif>	


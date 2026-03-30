<cfif isdefined("URL.CFid") and len(trim(url.CFid)) gt 0>
	<cfif isdefined("url.Aid") and url.Aid gt 0>
    	<cfset campo  = 'd.Aid'>
        <cfset valor  = url.Aid>
        <cfset nombre = 'Articulo'>
    <cfelse>
    	<cfset campo = 'd.Cid'>
        <cfset valor = url.Cid>
        <cfset nombre = 'Concepto'>
    </cfif>
    
    <cfif isdefined("url.LPid") and len(trim(url.LPid)) gt 0>
		<cfset LPid = url.LPid>
    </cfif>
    
    <cfquery name="rsMoneda" datasource="#Session.DSN#">
    	select Miso4217
        from Monedas
        where Mcodigo = #url.moneda#
        and Ecodigo =  #session.Ecodigo#
    </cfquery>
    
    <cfquery name="rsMonedaLoc" datasource="#Session.DSN#">
    	select m.Miso4217
        from Empresas e
        inner join Monedas m
        on m.Mcodigo = e.Mcodigo
        and m.Ecodigo = e.Ecodigo
        where e.Ecodigo =  #session.Ecodigo#
    </cfquery>
    
    <cfquery name="rsNombreCDestino" datasource="#Session.DSN#">
        select e.LPid,
        coalesce(#campo#,0) as codigo, 
		d.DLdescripcion,
		d.DLprecio, 
        d.DLdescuento,
        d.DLrecargo,
        d.moneda,
        d.DLdescuentoTipo,
        d.DLrecargoTipo,
        coalesce(d.CVidD,0) as CVidD,
        coalesce(d.CVidR,0) as CVidR
        from EListaPrecios e
        inner join DListaPrecios d
        on d.LPid = e.LPid
        and d.Ecodigo = e.Ecodigo
        where 
        <cfif isdefined("LPid")>
        	e.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LPid#">
        <cfelse>
            e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
            and e.id_zona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.zona#">
        </cfif>
        and #campo# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#">
        and '#LSDateFormat(url.fecha)#' between d.DLfechaini and d.DLfechafin
        and e.Ecodigo = #session.Ecodigo#
    </cfquery>    
	<cfif rsNombreCDestino.recordcount eq 0>
    	<cfquery name="rsNombreCDestino" datasource="#Session.DSN#">
            select e.LPid,
            coalesce(#campo#,0) as codigo, 
            d.DLdescripcion,
            d.DLprecio, 
            d.DLdescuento,
            d.DLrecargo,
            d.moneda,
            d.DLdescuentoTipo,
            d.DLrecargoTipo,
            coalesce(d.CVidD,0) as CVidD,
            coalesce(d.CVidR,0) as CVidR
            from EListaPrecios e
            inner join DListaPrecios d
            on d.LPid = e.LPid
            and d.Ecodigo = e.Ecodigo
            where e.Ecodigo = #session.Ecodigo#
            and e.LPdefault = 1
            and #campo# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#">
            and '#LSDateFormat(url.fecha)#' between d.DLfechaini and d.DLfechafin
        </cfquery>
    </cfif>
    
	<cfif rsNombreCDestino.recordcount gt 0 and rsNombreCDestino.CVidD neq 0>
    	<cfquery name="rsDescuento" datasource="#Session.DSN#">
        	select e.CVid
            from ECalendarioVentas e
            where e.CVTipo = 'D'
            and e.Ecodigo = #session.Ecodigo#
            and e.CVid = #rsNombreCDestino.CVidD#
            and exists (select 1
            			from DCalendarioVentas d
                        where d.Ecodigo = e.Ecodigo
                        and d.CVid = e.CVid
                        and '#LSDateFormat(url.fecha)#' between d.CVfechaini and d.CVfechafin)
        </cfquery>
    </cfif>
    
    <cfif rsNombreCDestino.recordcount gt 0 and rsNombreCDestino.CVidR neq 0>
        <cfquery name="rsRecargos" datasource="#Session.DSN#">
            select e.CVid
            from ECalendarioVentas e
            where e.CVTipo = 'R'
            and e.Ecodigo = #session.Ecodigo#
            and e.CVid = #rsNombreCDestino.CVidR#
            and exists (select 1
            			from DCalendarioVentas d
                        where d.Ecodigo = e.Ecodigo
                        and d.CVid = e.CVid
                        and '#LSDateFormat(url.fecha)#' between d.CVfechaini and d.CVfechafin)
        </cfquery>
    </cfif>
    
    <cfset tipoC = 0>
    <cfif rsNombreCDestino.recordcount gt 0 and rsNombreCDestino.moneda neq rsMoneda.Miso4217>
       <cfset tipoC = 1>
	   <cfif rsMonedaLoc.Miso4217 neq rsNombreCDestino.moneda>
            <cfquery name="rsTCambioArt" datasource="#Session.DSN#">
                select m.Miso4217, tc.Mcodigo, tc.TCventa
                from Monedas m
                inner join Htipocambio tc
                on  tc.Mcodigo = m.Mcodigo
                and tc.Ecodigo = m.Ecodigo
                where m.Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                  and m.Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#rsNombreCDestino.moneda#">
                  and tc.Hfecha <= '#LSdateformat(url.fecha)#'
                  and tc.Hfechah > '#LSdateformat(url.fecha)#'
            </cfquery>
        <cfelse>
         	<cfset rsTCambioArt.TCventa = 1>
        </cfif>
    </cfif>
    
   
    
<script language="javascript1.2" type="text/javascript">    
<cfoutput>

	
	<cfif isdefined('rsDescuento') and rsDescuento.recordcount gt 0>
		<cfif rsNombreCDestino.DLdescuentoTipo eq 'P'>
			<cfset rsNombreCDestino.DLdescuento = rsNombreCDestino.DLprecio * (rsNombreCDestino.DLdescuento / 100)>
		</cfif>
		<cfif tipoC neq 0>
			<cfset rsNombreCDestino.DLdescuento = rsNombreCDestino.DLdescuento * (rsTCambioArt.TCventa / url.TCambio)>
		</cfif>
		window.parent.document.form1.Desc.value  = #rsNombreCDestino.DLdescuento#;
	</cfif>
	
	<cfif isdefined('rsRecargos') and rsRecargos.recordcount gt 0>
		<cfif rsNombreCDestino.DLrecargoTipo eq 'P'> 
			<cfset rsNombreCDestino.DLrecargo = rsNombreCDestino.DLprecio * (rsNombreCDestino.DLrecargo / 100)>	
		</cfif>
		<cfif tipoC neq 0>
			<cfset rsNombreCDestino.DLrecargo = rsNombreCDestino.DLrecargo * (rsTCambioArt.TCventa / url.TCambio)>
		</cfif>	
		window.parent.document.form1.rec.value   = #rsNombreCDestino.DLrecargo#;		
	</cfif>

	<cfif tipoC neq 0>
		<cfset rsNombreCDestino.DLprecio = rsNombreCDestino.DLprecio * (rsTCambioArt.TCventa / url.TCambio)>
	</cfif>

	<cfif rsNombreCDestino.recordcount gt 0>
		window.parent.document.form1.LPid.value        = #rsNombreCDestino.LPid#;
		window.parent.document.form1.DTpreciou.value   = #rsNombreCDestino.DLprecio#;
		window.parent.fm(window.parent.document.form1.DTpreciou,2);	
		window.parent.suma();
	<cfelse>
		window.parent.document.form1.LPid.value = '';
		window.parent.alert ('El #nombre# no esta asociado a una Lista de Precios o ha cumplido su limite de tiempo');
	</cfif>		
</cfoutput>
</script>
<cfelse>

	<script language="javascript1.2" type="text/javascript">    
		window.parent.alert ('No se ha definido el Centro Funcional del Detalle, para obtener la Lista de Precio');	
	</script>

</cfif>



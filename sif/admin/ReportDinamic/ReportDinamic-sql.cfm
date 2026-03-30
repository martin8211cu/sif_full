<cfparam name="param" default="">
<cf_navegacion name="NUEVO">
<cf_navegacion name="btnEliminar">
<cf_navegacion name="ERDid">

<cfif isdefined('form.NUEVO')>
	<cfset param = "NUEVO">
<cfelseif isdefined('form.BAJA')>
	 <cfinvoke component="sif.Componentes.CA_ReportDinamic" method="BAJAReportDinamic">
        <cfinvokeargument name="ERDid" 	value="#form.ERDid#">
    </cfinvoke>
<cfelseif isdefined('CAMBIO')>
	 <cfinvoke component="sif.Componentes.CA_ReportDinamic" method="CAMBIOReportDinamic">
        <cfinvokeargument name="ERDid" 		value="#form.ERDid#">
        <cfinvokeargument name="ERDcodigo" 	value="#form.ERDcodigo#">
        <cfinvokeargument name="ERDdesc" 	value="#form.ERDdesc#">
        <cfinvokeargument name="ERDmodulo" 	value="#form.ERDmodulo#">
        <cfinvokeargument name="ERDbody" 	value="#form.ERDbody#">
    </cfinvoke>
	<cfset param="ERDid="&form.ERDid>
<cfelseif isdefined('ALTA')>
	<cfinvoke component="sif.Componentes.CA_ReportDinamic" method="ALTAReportDinamic">
        <cfinvokeargument name="ERDcodigo" 	value="#form.ERDcodigo#">
        <cfinvokeargument name="ERDdesc" 	value="#form.ERDdesc#">
        <cfinvokeargument name="ERDmodulo" 	value="#form.ERDmodulo#">
        <cfinvokeargument name="ERDbody" 	value="#form.ERDbody#">
    </cfinvoke>
<cfelse>
	<cfif isdefined('form.ERDid')>
		<cfset param="ERDid="&form.ERDid>
	</cfif>
</cfif>

<cfif isdefined('form.generar')>
	<!---averiguar si existe ya el reporte sino lo creo, posterior si existe la varible sino la homologo--->
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select 	ANHid,ANHcodigo, ANHdescripcion
		from 	ANhomologacion
		where Ecodigo=#session.Ecodigo#
			and ANHcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.ERDcodigo)#">
	</cfquery>
	<!---obtengo las variables a homologar que no sean texto (<18), ni variable(3), ni operaciones arimetica(63) --->
    <cfquery name="rsVariables" datasource="#session.dsn#" >
        select DRDNombre, AnexoCon from DReportDinamic 
        where ERDid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#form.ERDid#">
            and AnexoCon > 18  and AnexoCon != 63
    </cfquery>
    <!--- creo un select quemado--->
   	<cfset descripAnexo = ArrayNew(1)>
    <cfset descripAnexo[21] = "Saldo Inicial">	<cfset descripAnexo[22] = "Débitos Mes">	<cfset descripAnexo[23] = "Créditos Mes">	<cfset descripAnexo[24] = "Movimientos Mes">	
    <cfset descripAnexo[20] = "Saldo Final">	<cfset descripAnexo[32] = "Débitos Acum">	<cfset descripAnexo[33] = "Créditos Acum.">	<cfset descripAnexo[34] = "Movimientos Acum">
    <cfset descripAnexo[25] = "Flujo de Efectivo en el Mes">	<cfset descripAnexo[35] = "Saldo Inicial Cierre">	<cfset descripAnexo[36] = "Débitos Cierre">				<cfset descripAnexo[37] = "Créditos Cierre">	
    <cfset descripAnexo[38] = "Movimientos Cierre">				<cfset descripAnexo[39] = "Saldo Final Cierre">		<cfset descripAnexo[40] = "Presupuesto Contable Ini.">	<cfset descripAnexo[41] = "Presupuesto Contable Mes.">
    <cfset descripAnexo[42] = "Presupuesto Contable Fin.">		<cfset descripAnexo[50] = "Control Presupuesto Mes">	<cfset descripAnexo[51] = "Control Presupuesto Acum">	<cfset descripAnexo[52] = "Control Presupuesto Per">
    <cfset descripAnexo[60] = "Formulación Presup. Mes">		<cfset descripAnexo[61] = "Formulación Presup. Acum">	<cfset descripAnexo[62] = "Presupuesto Contable Per.">	

    <cfif rsExiste.recordcount gt 0>
   		<cfloop query="rsVariables">
        	<cfquery name="rslista" datasource="#session.dsn#">
                select ANHCid,ANHCcodigo,ANHCdescripcion
                    from ANhomologacionCta
                    where ANHid = #rsExiste.ANHid#
                    	and ANHCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsVariables.DRDNombre)#">
            </cfquery>	
            <cfif rslista.recordcount eq 0>
            	 <cfquery name="rsInsert" datasource="#Session.DSN#">
                    insert into ANhomologacionCta (
                            ANHid,
                           ANHCcodigo,
                           ANHCdescripcion,
                           Ecodigo,
                           BMUsucodigo
                          )
                    values (
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExiste.ANHid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVariables.DRDNombre#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVariables.DRDNombre#(#descripAnexo[rsVariables.AnexoCon]#)">,
                            #Session.Ecodigo#,
                            #session.Usucodigo#
                        ) 
                      <cf_dbidentity1 datasource="#session.DSN#" name="rsInsert">   
                </cfquery>
                <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" returnvariable="LvarANHidCta">
                
                 <cfinvoke component="sif.Componentes.CA_ReportDinamic" method="CAMBIODetalleReportDinamic">
                    <cfinvokeargument name="ANHCid" 	value="#LvarANHidCta#">
                    <cfinvokeargument name="ERDid" 		value="#form.ERDid#">
                    <cfinvokeargument name="DRDNombre" 	value="#rsVariables.DRDNombre#">
                 </cfinvoke>
            <cfelse>
                <cfquery name="update" datasource="#Session.DSN#">
                    update ANhomologacionCta set 
                            ANHCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVariables.DRDNombre#(#descripAnexo[rsVariables.AnexoCon]#)">,
                            BMUsucodigo = #session.Usucodigo#
                    where ANHCid       = #rslista.ANHCid#
                </cfquery>      
            </cfif>
        </cfloop>	
    <cfelse>
    	<cfquery name="inHomo" datasource="#session.dsn#">
			insert into ANhomologacion(
				Ecodigo, 
				ANHcodigo,
				ANHdescripcion,
				BMUsucodigo 
			)
			values(
				#session.Ecodigo#,
				'#trim(form.ERDcodigo)#',
				'#form.ERDdesc#',
				#session.Usucodigo#
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="inHomo">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="inHomo" returnvariable="LvarANHid">
   		<cfloop query="rsVariables">
        	<cfquery name="rslista" datasource="#session.dsn#">
                select ANHCid,ANHCcodigo,ANHCdescripcion
                    from ANhomologacionCta
                    where ANHid = #LvarANHid#
                    	and ANHCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsVariables.DRDNombre)#">
            </cfquery>	
            <cfif rsExiste.recordcount eq 0>    	 
                <cfquery name="insert" datasource="#Session.DSN#">
                    insert into ANhomologacionCta (
                            ANHid,
                           ANHCcodigo,
                           ANHCdescripcion,
                           Ecodigo,
                           BMUsucodigo
                          )
                    values (
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarANHid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVariables.DRDNombre#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVariables.DRDNombre#(#descripAnexo[rsVariables.AnexoCon]#)">,
                            #Session.Ecodigo#,
                            #session.Usucodigo#
                        )
                      <cf_dbidentity1 datasource="#session.DSN#" name="insert">   
                </cfquery>
                <cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarANHidCta">
                
                 <cfinvoke component="sif.Componentes.CA_ReportDinamic" method="CAMBIODetalleReportDinamic">
                    <cfinvokeargument name="ANHCid" 	value="#LvarANHidCta#">
                    <cfinvokeargument name="ERDid" 		value="#form.ERDid#">
                    <cfinvokeargument name="DRDNombre" 	value="#rsVariables.DRDNombre#">
                 </cfinvoke>
            <cfelse>
               	<cfquery name="update" datasource="#Session.DSN#">
                    update ANhomologacionCta set 
                            ANHCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVariables.DRDNombre#(#descripAnexo[rsVariables.AnexoCon]#)">,
                            BMUsucodigo = #session.Usucodigo#
                    where ANHCid       = #rslista.ANHCid#
                </cfquery>        
            </cfif>
        </cfloop>
    </cfif>
</cfif>

<cfif isdefined('url.AnexoCon') OR isdefined('url.DRDNegativo') OR isdefined('url.AVid') OR isdefined('url.ANHCid') or isdefined('url.DRDValor') or isdefined('url.DRDMeses')>
 <cfinvoke component="sif.Componentes.CA_ReportDinamic" method="CAMBIODetalleReportDinamic">
 	<cfif isdefined('url.DRDValor')>
         <cfset nDRDValor = replace("#url.DRDValor#","|","+") >
    	<cfinvokeargument name="DRDValor" 		value="#nDRDValor#">
    </cfif>
    <cfif isdefined('url.AVid')>
    	<cfinvokeargument name="AVid" 			value="#url.AVid#">
    </cfif>
	<cfif isdefined('url.AnexoCon')>
        <cfinvokeargument name="AnexoCon" 		value="#URL.AnexoCon#">
    </cfif>
    <cfif isdefined('url.DRDNegativo') and url.DRDNegativo eq 1 >
        <cfinvokeargument name="DRDNegativo" 	value="1">
    <cfelse>
        <cfinvokeargument name="DRDNegativo" 	value="0">
    </cfif>
    <cfif isdefined('url.DRDMeses')>
    	<cfinvokeargument name="DRDMeses" 		value="#url.DRDMeses#">
    </cfif>
 	<cfif isdefined('url.ANHCid') and url.ANHCid neq "">
    	<cfinvokeargument name="ANHCid" 	value="#URL.ANHCid#">
	</cfif>
    
    	<cfinvokeargument name="ERDid" 			value="#URL.ERDid#">
        <cfinvokeargument name="DRDNombre" 		value="#URL.DRDNombre#">
 </cfinvoke>
<cfelse>
	<cflocation addtoken="no" url="ReportDinamic.cfm?#param#">
</cfif>
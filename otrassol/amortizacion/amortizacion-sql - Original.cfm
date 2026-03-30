<!---<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
</body>
</html>

--->

<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">

<cfif isdefined("url.fSTipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.fSTipo>
</cfif>

<cfif isdefined("url.Documento") and not isdefined("form.Documento")>
	<cfset form.Documento = url.Documento>
</cfif>
<cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento")>
	<cfset form.IDdocumento = url.IDdocumento>
</cfif>
<cfif isdefined("url.fSNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.fSNcodigo>
</cfif>
<cfif isdefined("url.tlbUsar")>
	<cfset LvarTablaUsar = url.tlbUsar>
</cfif>
<cfif isdefined("url.tlbUsarD")>
	<cfset LvarTablaUsarD = url.tlbUsarD>
</cfif>
<cfif isdefined("url.meses")>
	<cfset mesesAmort = url.meses>
</cfif>
<cfif isdefined("url.Ccuenta")>
	<cfset form.Ccuenta = url.Ccuenta>
</cfif>
<cfif isdefined("url.FechaIni") and not isdefined("form.FechaIni")>
	<cfset form.FechaIni = url.FechaIni>
</cfif>
<cfif isdefined("url.FechaFin") and not isdefined("form.FechaFin")>
	<cfset form.FechaFin = url.FechaFin>
</cfif>
<cfif isdefined("url.fSNnumero") and not isdefined("form.fSNnumero")>
	<cfset form.SNnumero = url.fSNnumero>
</cfif>

<cfquery name="rsDetDoc" datasource="#session.DSN#">
    select hdd.DDtotallin as total, c.CPTtipo as Cbalancen,
      hdd.Ccuenta as Cuenta, hd.Mcodigo, hd.Ocodigo,hd.EDtipocambioVal as TCambio       
    from #LvarTablaUsar# hd
        inner join #LvarTablaUsarD# hdd
          	on hd.IDdocumento = hdd.IDdocumento
		inner join CPTransacciones c
					on c.Ecodigo   = hd.Ecodigo
				   and c.CPTcodigo = hd.CPTcodigo			
    Where hd.Ecodigo = #Session.Ecodigo#
       and hd.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
</cfquery> 
<cfquery name="rsParam1" datasource="#Session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and Pcodigo = 30
</cfquery>
<cfquery name="rsParam2" datasource="#Session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and Pcodigo = 40
</cfquery>
<cfset vPeriodo = rsParam1.Pvalor>
<cfset vMes = rsParam2.Pvalor>    
<cfset Lprm_Fecha 	= createdate(Year(Now()),Month(Now()),Day(Now()))>
<!---<cfset vPeriodo 	= "#year(Now())#" >	
<cfset vMes 	  	= "#Month(Now())#" >
--->
<cftransaction action="begin">
<cfloop index = "i" from = "1" to = "#mesesAmort#"> 
    <cfquery datasource="#Session.DSN#">
        delete #INTARC#			<!---Se limpian los registros del mes anterior--->
    </cfquery>
    <cfset vMontoAmorT 	 = 0>
    <cfset vMontoAmorTML = 0>
<!---	<cfset vMes = vMes + 1 >
    <cfif vMes gt 12>
        <cfset vPeriodo = vPeriodo + 1 >	
        <cfset vMes 	= 1 >
    </cfif>
--->    
	<cfloop query="rsDetDoc">
        <cfset vMontoAmor = #rsDetDoc.total#/#mesesAmort#>
        <cfset vMontoAmorML = #vMontoAmor# * #rsDetDoc.TCambio#>
    	
		<cfset vMontoAmorT = vMontoAmorT + #vMontoAmor#>
        <cfset vMontoAmorTML = vMontoAmorTML + #vMontoAmorML#>
            <cfset LvarDescripcion 	= "Amortizacion "& "#form.Documento#" & " periodo "&"#i#"&"/"&"#mesesAmort#">
            <cfset LvarReferencia	= #LvarDescripcion#>
			
			<cfquery datasource="#Session.DSN#">
                insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, 
                INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
                values(	<cfqueryparam value="AMOR" cfsqltype="cf_sql_varchar">,
                		<cfqueryparam value= 1 	   cfsqltype="cf_sql_integer">,
                        <cfqueryparam value='#vPeriodo# - #vMes#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#vPeriodo# - #vMes#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value=#vMontoAmorML# cfsqltype="cf_sql_money">,
						<cfqueryparam value="#rsDetDoc.Cbalancen#"	cfsqltype="cf_sql_varchar">,
					
                        <cfqueryparam value="#LvarDescripcion#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value=#Lprm_Fecha# cfsqltype="cf_sql_date">,
                        <cfqueryparam value=#rsDetDoc.TCambio# cfsqltype="cf_sql_float">,
                        <cfqueryparam value=#vPeriodo# cfsqltype="cf_sql_integer">,
                        <cfqueryparam value=#vMes# cfsqltype="cf_sql_integer">,
                        <cfqueryparam value=#rsDetDoc.Cuenta# cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value=#rsDetDoc.Mcodigo# cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value=#rsDetDoc.Ocodigo# cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value=#vMontoAmor# cfsqltype="cf_sql_money">
                )
            </cfquery>
    </cfloop>
    <cfquery datasource="#Session.DSN#">
        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, 
        INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
        values(	<cfqueryparam value="AMOR" 					cfsqltype="cf_sql_varchar">,
                <cfqueryparam value= 1 	   					cfsqltype="cf_sql_integer">,
                <cfqueryparam value='#vPeriodo# - #vMes#' 	cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#vPeriodo# - #vMes#' 	cfsqltype="cf_sql_varchar">,
                <cfqueryparam value=#vMontoAmorTML# 		cfsqltype="cf_sql_money">,
                        <cfif "#rsDetDoc.Cbalancen#" eq "D">
                        	<cfqueryparam value="C" cfsqltype="cf_sql_varchar">,
                        <cfelse>
							<cfqueryparam value="D" cfsqltype="cf_sql_varchar">,
						</cfif>	
                <cfqueryparam value="#LvarDescripcion#" 	cfsqltype="cf_sql_varchar">,
                <cfqueryparam value=#Lprm_Fecha# 			cfsqltype="cf_sql_date">,
                <cfqueryparam value=#rsDetDoc.TCambio# 		cfsqltype="cf_sql_float">,
                <cfqueryparam value=#vPeriodo# 				cfsqltype="cf_sql_integer">,
                <cfqueryparam value=#vMes# 					cfsqltype="cf_sql_integer">,
                <cfqueryparam value=#form.Ccuenta# 			cfsqltype="cf_sql_numeric">,
                <cfqueryparam value=#rsDetDoc.Mcodigo# 		cfsqltype="cf_sql_numeric">,
                <cfqueryparam value=#rsDetDoc.Ocodigo# 		cfsqltype="cf_sql_numeric">,
                <cfqueryparam value=#vMontoAmorT# 			cfsqltype="cf_sql_money">
        )
    </cfquery>   
<!--- Ejecutar el Genera Asiento --->
     <cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="retIDcontable" method="GeneraAsiento"
        Oorigen 		= "AMOR"
        Cconcepto       = "15"
        Eperiodo		= "#vPeriodo#"
        Emes			= "#vMes#"
        Efecha			= "#Createdate(year(now()),month(now()), day(Now()))#"
        Edescripcion	= "#LvarDescripcion#"
        Edocbase		= ""
        Ereferencia		= "#LvarReferencia#"
        />    
	<cfset vMes = vMes + 1 >
    <cfif vMes gt 12>
        <cfset vPeriodo = vPeriodo + 1 >	
        <cfset vMes 	= 1 >
    </cfif>        
</cfloop>
<cfquery datasource="#Session.DSN#">
insert into Amort_DetalleCuenta (Ecodigo, IdDocumento,  Ccuenta, EDmesesAmort, BMUsucodigo, BMfecha)
values( 
	<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">,
    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.IDdocumento#">,
    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Ccuenta#">,
    <cfqueryparam cfsqltype="cf_sql_integer" 	value="#mesesAmort#">,
    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
    <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">	)
</cfquery>
</cftransaction> 

<cflocation url="amortizacion-DetalleDoc.cfm?IDdocumento=#form.IDdocumento#&SNcodigo=#form.SNcodigo#&Ddocumento=#form.Documento#&tipo=#form.tipo#& CPTcodigo=#form.tipo#&FechaIni=#form.FechaIni#&FechaFin=#form.FechaFin#&fSNnumero=#form.SNnumero#">

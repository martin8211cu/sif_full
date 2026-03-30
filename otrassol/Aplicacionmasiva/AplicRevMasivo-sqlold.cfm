<cfsetting showdebugoutput="yes" requesttimeout="1000">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Proceso de reversi&oacute;n de Documentos</title>
</head>

<body>
<!--- Se crea tabla para salida del proceso  --->
<cf_dbtemp name="Errores" returnvariable="Errores" datasource="#session.dsn#">
	<cf_dbtempcol name="orden"  type="smallint" mandatory="no">
	<cf_dbtempcol name="Resultado" type="char(250)" mandatory="no">
</cf_dbtemp>

<cfsetting requesttimeout="3600">

<cfif isdefined('url.tipoCuenta') >
	<cfset form.tipoCuenta = url.tipoCuenta>
</cfif>
<cfset numRegistros = 5>
<cfset modulo = "CXP">
<cfif #form.tipoCuenta# EQ 0>
	<cfset modulo = "CXC">
</cfif>

<cfset session.load_status = "">
<cfset session.load_percent = 0>
<cfset session.load_started = Now()>
<cfset session._time = StructNew()>
<cfset session.load_finished = false>
<cfset session.load_abort   = false>

<cffunction name="status" output="no">
	<cfargument name="text"    required="yes">
	<cfargument name="percent" required="no" default="0">
	<cfset session.load_status  = text>
    <cfset session.load_percent = percent>
    <cfif session.load_abort>
    	<cfabort>
    </cfif>
</cffunction>

<cfquery name="rsCountReg" datasource="#session.dsn#">
    <cfif #form.tipoCuenta# EQ 0>
        select  
        a.CCTcodigo,a.Ddocumento,b.CCTCodigoRef 
        from Documentos a
        inner join CCTransacciones b
        ON b.Ecodigo   = a.Ecodigo
        AND b.CCTcodigo = a.CCTcodigo
        AND b.CCTestimacion = 1
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and a.Dsaldo <> 0.00	
        and a.Dsaldo = a.Dtotal
    <cfelse>
        select 
        a.CPTcodigo,a.IDdocumento,a.Ddocumento 
        from EDocumentosCP a
        inner join CPTransacciones b
        ON b.Ecodigo   = a.Ecodigo
        AND b.CPTcodigo = a.CPTcodigo
        AND b.CPTestimacion = 1
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and a.EDsaldo <> 0.00				
        and a.EDsaldo = a.Dtotal
    </cfif>
</cfquery>
<cfset rowCount = rsCountReg.recordCount>

<cfif len(trim(form.tipo)) EQ 0>
	<script language="javascript1.4" type="text/javascript">
		alert("Debe Seleccionar un tipo de Reversion para Ejecutar el Proceso");
	</script>
<cfelse>
	<cfset Registros = 1>
    <cfset rowindex = 0>
    <cfloop condition="Registros gt 0">
		<cfset rowindex += 1>    
        <cfquery name="rsQuery" datasource="#session.dsn#">
            <cfif #form.tipoCuenta# EQ 0>
                select top #numRegistros# 
                a.CCTcodigo,a.Ddocumento,b.CCTCodigoRef 
                from Documentos a
                inner join CCTransacciones b
                ON b.Ecodigo   = a.Ecodigo
                AND b.CCTcodigo = a.CCTcodigo
                AND b.CCTestimacion = 1
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and a.Dsaldo <> 0.00	
                and a.Dsaldo = a.Dtotal
            <cfelse>
                select top #numRegistros#
                a.CPTcodigo,a.IDdocumento,a.Ddocumento 
                from EDocumentosCP a
                inner join CPTransacciones b
                ON b.Ecodigo   = a.Ecodigo
                AND b.CPTcodigo = a.CPTcodigo
                AND b.CPTestimacion = 1
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and a.EDsaldo <> 0.00				
                and a.EDsaldo = a.Dtotal
            </cfif>
        </cfquery>
        
		<cfset Registros = rsQuery.recordCount>
        
        <cfif rowindex GTE 10>
        	<cfset Registros = 0>
        </cfif>
        
        <cfif Registros gt 0 >
        	<cfscript>
        	Status( "Reversando documento #rowindex-1# de #rowCount#", rowindex*100 / rowCount);
			</cfscript>
            <cfset error = false>
            <cfloop query = "rsQuery" >
            <cftry>
        		<cfif #form.tipoCuenta# EQ 0>
                	<cfset CCTcodigo = rsQuery.CCTcodigo>  
                	<cfset CCTCodigoRef = rsQuery.CCTCodigoRef>
                	<cfset Ddocumento = rsQuery.Ddocumento>
                    <cfinvoke 
                        component="sif.Componentes.ReversionDocNoFact" 
                        method="Reversion" 
                            Modulo="#modulo#"
                            debug="false"
                            ReversarTotal="#Form.TIPO#"
                            CCTcodigo="#CCTcodigo#"
                            CCTCodigoRef="#CCTCodigoRef#"
                            Ddocumento="#Ddocumento#"
                    />
                <cfelse>
                	<cfset CPTcodigo = rsQuery.CPTcodigo>
                    <cfset IDdocumento = rsQuery.IDdocumento>
                    <cfinvoke 
                        component="sif.Componentes.ReversionDocNoFact" 
                        method="Reversion" 
                            Modulo="#modulo#"
                            debug="false"
                            ReversarTotal="#Form.TIPO#"
                            CPTcodigo="#CPTcodigo#"
                            IDdocumento="#IDdocumento#"
                    />
                </cfif>
            <cfcatch type="any">
            
				<cfset error = true >
                <cfset Documento = #rsQuery.IDdocumento# >
                <cfif #form.tipoCuenta# EQ 0>
                	<cfset Documento = #rsQuery.Ddocumento# >
				</cfif>
                <cfquery name="insError" datasource="#session.dsn#">
                    insert  into #Errores#  (orden,Resultado)  
                    values (#rowindex#,'Error de base datos tratando de procesar El documento contable [#Documento#]')
                </cfquery>
                
            </cfcatch>
            </cftry> 
            </cfloop>
        </cfif>
    </cfloop>
</cfif>
<cfset msg="Documentos reversados exitosamente">
<cfif error>
	<cfset msg="No se reversaron todos los documentos">
</cfif>
<cfset session.load_finished = true>
<cfset status(msg, 100.0)>
</body>

<!---<cfif #form.tipoCuenta# EQ 0>
	<cflocation url="ReversoMasivoCC.cfm">
<cfelse>
	<cflocation url="../../../cp/operacion/NoFac/ReversoMasivoCP.cfm">
</cfif>
--->
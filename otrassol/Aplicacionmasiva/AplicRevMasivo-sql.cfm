<cfsetting showdebugoutput="yes" requesttimeout="3600">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Proceso de reversi&oacute;n de Documentos</title>
</head>

<body>

<cfsetting requesttimeout="3600">
<cfparam name="url.ultimo_procesado" default="0">

<cfif isdefined('url.tipoCuenta') >
	<cfset form.tipoCuenta = url.tipoCuenta>
</cfif>

<cfparam name="session.load_rowCount" default="1">

<cffunction name="status" output="no">
	<cfargument name="text"    required="yes">
	<cfargument name="percent" required="no" default="0">
	<cfset session.load_status  = text>
    <cfset session.load_percent = percent>
    <cfif session.load_abort>
    	<cfabort>
    </cfif>
</cffunction>

<cfif url.ultimo_procesado EQ 0>
	<!--- esta iniciando, contar registros --->
	<cfset session.ds_name = "#session.dsn#">	
	<cfset session.tipo = "#Form.TIPO#">
	<cfset session.modulo = "CXP">
    <cfif #form.tipoCuenta# EQ 0>
        <cfset session.modulo = "CXC">
    </cfif>
    <cfset session.load_status = "">
    <cfset session.load_percent = 0>
    <cfset session.load_started = Now()>
    <cfset session._time = StructNew()>
    <cfset session.load_finished = false>
    <cfset session.load_abort   = false>
    <cfset session.load_errores = ArrayNew(1)>
    <cfset session.errores = 0>
    <cfset session.rowindex = 1>
    <cfquery name="rsCountReg" datasource="#session.dsn#">
        <cfif #form.tipoCuenta# EQ 0>
            select count(1) as cantidad
            from Documentos a
            inner join CCTransacciones b
            ON b.Ecodigo   = a.Ecodigo
            AND b.CCTcodigo = a.CCTcodigo
            AND b.CCTestimacion = 1
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and a.Dsaldo <> 0.00	
            and a.Dsaldo = a.Dtotal
        <cfelse>
            select count(1) as cantidad
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
    <cfset session.load_rowCount = rsCountReg.cantidad>
</cfif>

<cfquery name="rsQuery" datasource= "#session.ds_name#">
    <cfif #form.tipoCuenta# EQ 0>
        select top 1
        a.CCTcodigo,a.Ddocumento,b.CCTCodigoRef,a.DdocumentoId as ultimo_procesado
        from Documentos a
        inner join CCTransacciones b
        ON b.Ecodigo   = a.Ecodigo
        AND b.CCTcodigo = a.CCTcodigo
        AND b.CCTestimacion = 1
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and a.Dsaldo <> 0.00	
        and a.Dsaldo = a.Dtotal
        and a.DdocumentoId > <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ultimo_procesado#">
        order by a.DdocumentoId
    <cfelse>
        select top 1
        a.CPTcodigo,a.IDdocumento,a.Ddocumento, a.IDdocumento as ultimo_procesado
        from EDocumentosCP a
        inner join CPTransacciones b
        ON b.Ecodigo   = a.Ecodigo
        AND b.CPTcodigo = a.CPTcodigo
        AND b.CPTestimacion = 1
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and a.EDsaldo <> 0.00				
        and a.EDsaldo = a.Dtotal
        and a.IDdocumento > <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ultimo_procesado#">
        order by a.IDdocumento
    </cfif>
</cfquery>

<cfset Registros = rsQuery.recordCount>

<cfif #Registros# gt 0 >
	<cfset #session.rowindex# += 1>
	<cfset ultimoRegistroProcesado = rsQuery.ultimo_procesado>
	<cfscript>
	Status( "Reversando documento #session.rowindex-1# de #session.load_rowCount#", (#session.rowindex#-1)*100 / #session.load_rowCount#);
	</cfscript>
	<cftry>
		<cfif #form.tipoCuenta# EQ 0>
			<cfset CCTcodigo = rsQuery.CCTcodigo>  
			<cfset CCTCodigoRef = rsQuery.CCTCodigoRef>
			<cfset Ddocumento = rsQuery.Ddocumento>
			<cfinvoke 
				component="sif.Componentes.ReversionDocNoFact" 
				method="Reversion" 
					Modulo="#session.modulo#"
					debug="false"
					ReversarTotal="#session.tipo#"
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
					Modulo="#session.modulo#"
					debug="false"
					ReversarTotal="#session.tipo#"
					CPTcodigo="#CPTcodigo#"
					IDdocumento="#IDdocumento#"
			/>
		</cfif>
	<cfcatch type="any">
		<cfset session.errores += 1 >
		<cfset cfmsg = cfcatch.Message>
        <cfset session.load_errores[#session.errores#] = 'Error de base datos tratando de procesar El documento contable [#rsQuery.Ddocumento#]'&"#cfmsg#">
	</cfcatch>
	</cftry>
	<cfoutput>
        <script type="text/javascript">
            document.location.href="AplicRevMasivo-sql.cfm?show_process=1&ultimo_procesado=#ultimoRegistroProcesado#&tipoCuenta=#form.tipoCuenta#";
        </script>	
    </cfoutput>
<cfelse>
	<!--- mensaje de ya termine --->
	<script type="text/javascript">
		alert("Proceso Terminado");
	</script>
	<cfif #form.tipoCuenta# EQ 0>
		<cflock  type="EXCLUSIVE" timeout="10"><cfset application.myappvarCC="0"></cflock>
	<cfelse>
		<cflock  type="EXCLUSIVE" timeout="10"><cfset application.myappvarCP="0"></cflock>
	</cfif>
	<cfset msg="Documentos reversados exitosamente">
    <cfset por= 100.00>
	<cfif #session.errores# GT 0>
		<cfset msg="No se reversaron todos los documentos">
        <cfset por= (#session.rowindex#-1)*100/#session.load_rowCount#>
	</cfif>
	<cfset session.load_finished = true>
	<cfset status(msg, por)>
</cfif>
</body>
</html>

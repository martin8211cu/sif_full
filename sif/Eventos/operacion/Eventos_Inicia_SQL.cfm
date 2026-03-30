<cftransaction action="begin">
<cftry>
	<!---Array de Eventos Generados --->
    <cfset ArrayResultado = arraynew(1)>
    <cfset ContadorArray = 0>
    
    <cfif isdefined("form.CCH")>
		<!--- Busca CCH abiertas --->
        <cfquery datasource="#session.dsn#" name="rsEvento">
        select cc.CCHcodigo 
        from CCHica cc
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and CCHestado = 'ACTIVA'
        and not exists 
            (select 1 from EventosControl ec
                where ec.Ecodigo = cc.Ecodigo
                and ec.Oorigen = 'CCH'
                and ec.Transaccion = 'APERTURA'
                and ec.Complemento = cc.CCHcodigo)
        </cfquery>
      
        
        <cfloop query="rsEvento">
            <cfset ContadorArray = ContadorArray + 1>
            <!--- Genera el evento para la Caja Chica --->
            <cfinvoke component="sif.Componentes.CG_ControlEvento" 
                method="CG_GeneraEvento" 
                Origen="CCH"
                Transaccion="APERTURA"
                Complemento="#rsEvento.CCHcodigo#"
                Documento="APERTURA-#rsEvento.CCHcodigo#"
                Conexion="#session.dsn#"
                Ecodigo="#session.Ecodigo#"
                returnvariable="arNumeroEvento"
            /> 
            <cfif arNumeroEvento[3] EQ "">
                <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
            </cfif>
            <cfset ArrayResultado[ContadorArray][1] = 'CCH'>
            <cfset ArrayResultado[ContadorArray][2] = rsEvento.CCHcodigo>
            <cfset ArrayResultado[ContadorArray][3] = arNumeroEvento[3]>
        </cfloop>
    </cfif>
    <cfif isdefined("form.CXC")>
    	<!--- Busca CxC con Saldo --->
        <cfquery datasource="#session.dsn#" name="rsEvento">
            select cc.Ddocumento, cc.CCTcodigo, cc.SNcodigo
            from Documentos cc
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and Dsaldo > 0
            and not exists 
                (select 1 from EventosControl ec
                    where ec.Ecodigo = cc.Ecodigo
                    and ec.Oorigen = 'CCFC'
                    and ec.Transaccion = cc.CCTcodigo
                    and ec.SNcodigo = cc.SNcodigo)
        </cfquery>
      
        
        <cfloop query="rsEvento">
            <cfset ContadorArray = ContadorArray + 1>
            <!--- Genera el evento para la Caja Chica --->
            <cfinvoke component="sif.Componentes.CG_ControlEvento" 
                method="CG_GeneraEvento" 
                Origen="CCFC"
                Transaccion="#rsEvento.CCTcodigo#"
                Documento="#rsEvento.Ddocumento#"
                SocioCodigo="#rsEvento.SNcodigo#"
                Conexion="#session.dsn#"
                Ecodigo="#session.Ecodigo#"
                returnvariable="arNumeroEvento"
            /> 
            <cfif arNumeroEvento[3] EQ "">
                <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
            </cfif>
            <cfset ArrayResultado[ContadorArray][1] = 'CCFC'>
            <cfset ArrayResultado[ContadorArray][2] = rsEvento.Ddocumento>
            <cfset ArrayResultado[ContadorArray][3] = arNumeroEvento[3]>
        </cfloop>
    </cfif>
    <cfif isdefined("form.CXP")>
    	<!--- Busca CxP con Saldo --->
        <cfquery datasource="#session.dsn#" name="rsEvento">
            select cp.Ddocumento, cp.CPTcodigo, cp.SNcodigo
            from EDocumentosCP cp
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and EDsaldo > 0
            and not exists 
                (select 1 from EventosControl ec
                    where ec.Ecodigo = cp.Ecodigo
                    and ec.Oorigen = 'CPFC'
                    and ec.Transaccion = cp.CPTcodigo
                    and ec.SNcodigo = cp.SNcodigo)
        </cfquery>
      
        
        <cfloop query="rsEvento">
            <cfset ContadorArray = ContadorArray + 1>
            <!--- Genera el evento para la Caja Chica --->
            <cfinvoke component="sif.Componentes.CG_ControlEvento" 
                method="CG_GeneraEvento" 
                Origen="CPFC"
                Transaccion="#rsEvento.CPTcodigo#"
                Documento="#rsEvento.Ddocumento#"
                SocioCodigo="#rsEvento.SNcodigo#"
                Conexion="#session.dsn#"
                Ecodigo="#session.Ecodigo#"
                returnvariable="arNumeroEvento"
            /> 
            <cfif arNumeroEvento[3] EQ "">
                <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
            </cfif>
            <cfset ArrayResultado[ContadorArray][1] = 'CPFC'>
            <cfset ArrayResultado[ContadorArray][2] = rsEvento.Ddocumento>
            <cfset ArrayResultado[ContadorArray][3] = arNumeroEvento[3]>
        </cfloop>
    </cfif>
    
    <cftransaction action="commit" />
    <cfcatch>
        <cfthrow message="ERROR ROLLBACK A TODAS LAS OPERACIONES: #cfcatch.Message#, #cfcatch.Detail#, #cfcatch.sql#, #cfcatch.where#">
        <cftransaction action="rollback" />
    </cfcatch>
</cftry>
</cftransaction>
<cfoutput>

<cfset FileName = "ProcesoInicialCEV.xls">
<!--- Pinta los botones de regresar, impresion y exportar a excel. --->
<cf_htmlreportsheaders
    title="Proceso Inicial Control Eventos" 
    filename="#FileName#" 
    ira="Eventos_Inicia_form.cfm">
    
<form name="form1" action="Eventos_Inicia_SQL.cfm" method="post">
	<h1 align="center"> Procesos Iniciales para el Control de Eventos </h1>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> <td >&nbsp;  </td> </tr>
        <tr>
            <td align="left">
                <strong> Tipo de Evento </strong>
            </td>
            <td align="right">
                <strong> Caja Chica o Documento </strong>
            </td>
            <td align="right">
                <strong> Evento </strong>
            </td>
        </tr>
        <cfloop from="1" to="#arraylen(ArrayResultado)#" step="1" index="i">
            <tr>
                <td align="left">
                    #ArrayResultado[i][1]#
                </td>
                <td align="right">
                    #ArrayResultado[i][2]#
                </td>
                <td align="right">
                    #ArrayResultado[i][3]#
                </td>
            </tr>
        </cfloop>
		<tr> <td>&nbsp;  </td> </tr>
	</table>
</form>
</cfoutput>

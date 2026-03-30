<cfif (isdefined("form.chk"))><!--- Viene de la lista --->
	<cfset datos = ListToArray(Form.chk,",")>
    <cfset limite = ArrayLen(datos)>
	 <cfset varError = false>	
	<cfloop from="1" to="#limite#" index="idx">
    <cftry>
		<cfset Rdatos = ListToArray(datos[idx],"|")>
        <!---Extrae Maximo ID--->
        <cfset varIDmax = ExtraeMaximo("IE40","ID")>
        
        <cfquery name="rsEDocumentos" datasource="sifinterfaces">
            select Empresa, Modulo, NumeroSocio, max(FechaTransaccion) as FechaTransaccion, Transaccion, Documento, 
            max(CodigoMoneda) as CodigoMoneda, max(TipoCambio) as TipoCambio, max(MontoTotal) as MontoTotal,
            max(Banco) as Banco, max(CuentaBanco) as CuentaBanco, max(ConceptoTesoreria) as ConceptoTesoreria
            from Interfaz40 
            where Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rdatos[1]#">
            and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#Rdatos[2]#">
            and NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[3]#">
            and Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#Rdatos[4]#">
            and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[5]#">
            and Procesado = 'N'
            group by Empresa, Modulo, NumeroSocio, Transaccion, Documento
        </cfquery>
        
         <cfquery name="rsDDocumentos" datasource="sifinterfaces">
            select NumeroSocioDoc, TransaccionDestino, DocumentoDestino, MontoDocumento 
            from Interfaz40 
            where Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rdatos[1]#">
            and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#Rdatos[2]#">
            and NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[3]#">
            and Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#Rdatos[4]#">
            and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[5]#">
            and Procesado = 'N'
        </cfquery>
        
        <!---Usuario--->
        <cfset This.Usucodigo = 5> 
                        
        <!---Obtener el codigo de la empresa--->
        <cfquery name="rsEcodigo" datasource="sifinterfaces">
            select Ecodigo, CodICTS, EcodigoSDCSoin
            from int_ICTS_SOIN 
            where CodICTS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.Empresa#"> 
        </cfquery>
        
        <cfif rsEcodigo.recordcount EQ 0>
            <cfthrow message="No existe código en SIF para la empresa #rsEDocumentos.EcodigoSDC#">
        </cfif>			
        
        <cfset varCEcodigo = getCEcodigo(rsEcodigo.Ecodigo)>
        <cftransaction action="begin">
        <cftry>			
            <cfif isdefined("rsEDocumentos") and rsEDocumentos.recordcount GT 0>
                <!--- Inserta Encabezado --->
                <cfquery datasource="sifinterfaces">
                   insert into IE40 (ID, EcodigoSDC, Modulo, FechaTransaccion, NumeroSocio, Transaccion, Documento, 
						MontoTotal, TipoCambio, CodigoMoneda, Banco, CuentaBanco, ConceptoTesoreria, Estatus, BMUsucodigo)
					values
                    (<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEcodigo.EcodigoSDCSoin#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.Modulo#">,
                     <cfqueryparam cfsqltype="cf_sql_date" value="#rsEDocumentos.FechaTransaccion#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.NumeroSocio#">, 
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.Transaccion#">, 
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.Documento#">,
                     <cfqueryparam cfsqltype="cf_sql_float" value="#rsEDocumentos.MontoTotal#">,
                     <cfqueryparam cfsqltype="cf_sql_float" value="#rsEDocumentos.TipoCambio#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.CodigoMoneda#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.Banco#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.CuentaBanco#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEDocumentos.ConceptoTesoreria#">,
                     1,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
                </cfquery>
                <!---Inserta Detalles--->
                <cfif isdefined("rsDDocumentos") and rsDDocumentos.recordcount GT 0>
                <cfset varIDLinea = 1>
                <cfloop query="rsDDocumentos">
                	<cfquery datasource="sifinterfaces">
                    	insert into ID40 (ID, IDLinea, NumeroSocioDoc, TransaccionDestino, DocumentoDestino, MontoDocumento)
                        values(<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDLinea#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDDocumentos.NumeroSocioDoc#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDDocumentos.TransaccionDestino#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDDocumentos.DocumentoDestino#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#rsDDocumentos.MontoDocumento#">)
                    </cfquery>
                    <cfset varIDLinea = varIDLinea + 1>
                </cfloop>
                </cfif>
                <!---Dispara la Interfaz--->
                <cfquery datasource="sifinterfaces">
                    insert into InterfazColaProcesos
                        (CEcodigo,
                         NumeroInterfaz, 
                         IdProceso, 
                         SecReproceso,
                         EcodigoSDC, 
                         OrigenInterfaz, 
                         TipoProcesamiento, 
                         StatusProceso,
                         FechaInclusion, 
                         UsucodigoInclusion, 
                         Cancelar)
                         values(
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCEcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_integer" value="40">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDmax#">,
                         0,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEcodigo.EcodigoSDCSoin#">,
                         'E',
                         'A',
                         1,
                         <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        0)
                    </cfquery>					
            </cfif>	
            <cfquery datasource="sifinterfaces">
                update Interfaz40 
                	set Procesado = 'S' 
                where Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rdatos[1]#">
                    and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#Rdatos[2]#">
                    and NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[3]#">
                    and Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#Rdatos[4]#">
                    and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[5]#">
                    and Procesado = 'N'
            </cfquery>																							
        <cftransaction action="commit" />
        <cfcatch type="any">
            <cftransaction action="rollback" />
            <cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
			<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            <cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
        </cfcatch>
        </cftry>
        </cftransaction>
    <cfcatch>
    	<cfquery datasource="sifinterfaces">
            update Interfaz40 
                set Error = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.Message# #cfcatch.Detail#">
            where Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rdatos[1]#">
                and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#Rdatos[2]#">
                and NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[3]#">
                and Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#Rdatos[4]#">
                and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[5]#">
                and Procesado = 'N'
        </cfquery>
        <cfset varError = true>			
    </cfcatch>
    </cftry>
    </cfloop>
</cfif>

<cfif not varError>
	<cflocation url="/cfmx/interfacesTBS/Interfaz40PMI-Param.cfm">
<cfelse>
	<form name="form1" action="Interfaz40PMI-Param.cfm" method="post">
    	<center>
        	<table border="1" align="center">
            	<tr>
                	<td width="100%" align="center">
                    	<strong> SE PRESENTARON ERRORES AL APLICAR REGISTROS</strong>
                    </td>
                </tr>
                <tr>
                	<td width="100%" align="center">
                		<strong> Vuelva a ejecutar la el proceso con los mismos filtros para verificar los detalles de los errores </strong>
                    </td>
                <tr>
                <tr>
                	<td width="100%" align="center">
                    	<input type="submit" name="btnRegresa" value="Regresar" />
                    </td>
                </tr>
            </table>
        </center>
    </form>
</cfif>

<cffunction name = 'ExtraeMaximo' returntype="numeric"> 
    <cfargument name='Tabla' type='string'	required='true' hint="Tabla">
    <cfargument name='CampoID' type='string'	required='true' hint="Proceso">
    
    <cfquery name="rsMaximo_Tabla" datasource="sifinterfaces">
        select coalesce (max(#Arguments.CampoID#), 0) + 1 as Maximo from #Arguments.Tabla#
    </cfquery>
    
    <cfif rsMaximo_Tabla.Maximo NEQ "">
        <cfset Max_Tabla = rsMaximo_Tabla.Maximo>
    <cfelse>
        <cfset Max_Tabla = 0>
    </cfif>
    
    <cfquery name="rsMaximo_IdProceso" datasource="sifinterfaces">
        select 1
        from IdProceso 
    </cfquery>
    
    <cfif rsMaximo_IdProceso.recordcount LTE 0>
        <cfquery datasource="sifinterfaces">
            insert IdProceso(Consecutivo,BMUsucodigo) values(0,1)
        </cfquery>
    </cfif>
    
    <cfquery name="rsMaximo_IdProceso" datasource="sifinterfaces">
        select isnull(max(Consecutivo),0) + 1 as Maximo
        from IdProceso 
    </cfquery>
    
    <cfset Max_Cons = rsMaximo_IdProceso.Maximo>
    
    <cfif  Max_Cons LT Max_Tabla>
        <cfset retvalue = rsMaximo_Tabla>
    <cfelse>
        <cfset retvalue = rsMaximo_IdProceso>
    </cfif>
    <cfquery datasource="sifinterfaces">
        update IdProceso
        set Consecutivo = #retvalue.Maximo#
    </cfquery>
    <cfreturn retvalue.Maximo>
</cffunction>

<!--- FUNCION GETCECODIGO --->
<cffunction name="getCEcodigo" returntype="string" output="no">
	<cfargument name='Ecodigo' type='numeric' required='true' hint="Ecodigo">

	<cfquery name="rsCEcodigo" datasource="#session.dsn#">
        select CEcodigo 
        from Empresa e
            inner join Empresas s
            on  e.Ereferencia = s.Ecodigo and s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
    </cfquery>
    <cfreturn rsCEcodigo.CEcodigo>
</cffunction>

             
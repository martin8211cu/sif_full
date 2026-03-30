<!---
	Importador de TAGS para QPass
    
    Campos del Archivo:
    
    QPTNumParte				20
    QPTFechaProduccion		8
    QPTNumSerie				20
    QPTPAN					20
    QPTNumLote				20
    QPTNumPall				20
    
    La fecha se lee en formato YYMMDD y se pasa a fecha en cada registro
    
--->
<cfsetting requesttimeout="3600">
<cfflush interval="16">
<cfset session.Importador.SubTipo = "1">
<cfquery datasource="#session.dsn#">
	delete #table_name#
    where QPTNumParte like 'Article_Number%'
</cfquery>

<cfquery name="rsOficinaUsuario" datasource="#session.dsn#">
	select min(Ocodigo) as Oficina
    from QPassUsuarioOficina
    where Ecodigo = #session.Ecodigo#
      and Usucodigo = #Session.Usucodigo#
</cfquery>

<cfif rsOficinaUsuario.recordcount GT 0 and len(trim(rsOficinaUsuario.Oficina)) GT 0>
	<cfset LvarUsuarioOficina = rsOficinaUsuario.Oficina>
<cfelse>
	<cfset LvarUsuarioOficina = -1>
</cfif>

<!--- Verificar si existen errores de Datos --->
<cfquery name="rsErroresDatos" datasource="#session.dsn#">
	select
	    QPTFechaProduccion,
	    QPTPAN,
	    QPTNumSerie,
        case 
        	when 
        		   (select count(1) 
                    from QPassTag t 
                    where t.QPTPAN = #table_name#.QPTPAN ) > 0 
                or (select count(1) 
                	from QPassTag t 
                    where t.QPTNumSerie = #table_name#.QPTNumSerie ) > 0
        	then 'TAG ya existe' 
            else 'n/a' 
        end as Error1,
        case 
        	when 
        		   datalength(rtrim(QPTFechaProduccion)) <> 6
		       or (substring(QPTFechaProduccion, 3, 2) < '01' or substring(QPTFechaProduccion, 3, 2) > '12')
		       or (substring(QPTFechaProduccion, 5, 2) < '01' or substring(QPTFechaProduccion, 5, 2) > '31')
        	then 'Fecha de Produccion Incorrecta' 
            else 'n/a' 
        end as Error2,
        case 
        	when 
            	#LvarUsuarioOficina# = -1 
            then 'No se ha definido la Sucursal o Bodega para el Usuario'
            else 'n/a'
        end as Error3
    from #table_name#
    where (select count(1) 
    	   from QPassTag t 
           where t.QPTPAN = #table_name#.QPTPAN  
           and t.Ecodigo = #session.Ecodigo#) > 0
       or (select count(1) 
       	   from QPassTag t 
           where t.QPTNumSerie = #table_name#.QPTNumSerie 
           and t.Ecodigo = #session.Ecodigo#) > 0
       or  datalength(rtrim(QPTFechaProduccion)) <> 6
       or (substring(QPTFechaProduccion, 3, 2) < '01' or substring(QPTFechaProduccion, 3, 2) > '12')
       or (substring(QPTFechaProduccion, 5, 2) < '01' or substring(QPTFechaProduccion, 5, 2) > '31')
       or #LvarUsuarioOficina# = -1
</cfquery>

<cfquery name="Err" dbtype="query">
    select 
        QPTPAN,
        QPTNumSerie,
        QPTFechaProduccion,
        Error1,
        Error2
    from rsErroresDatos
</cfquery>


<!--- Obtener los valores default de QPassEstado --->
<cfquery name="rsEstados" datasource="#session.dsn#">
	select min(QPidEstado) as QPidEstado
    from QPassEstado
    where Ecodigo = #session.Ecodigo#
      and QEPvalorDefault = 1 
</cfquery>

<cfif rsEstados.recordcount EQ 0 or len(trim(rsEstados.QPidEstado)) eq 0>
	<!--- Insertar el valor default de QPassEstado para poder continuar --->
	<cfquery datasource="#session.dsn#">
    	insert into QPassEstado (QPEdescripcion, QPEdisponibleVenta, QEPvalorDefault, Ecodigo) values('**DEFECTO**', 1, 1, #session.Ecodigo#)
    </cfquery>
    <cfquery name="rsEstados" datasource="#session.dsn#">
        select min(QPidEstado) as QPidEstado
        from QPassEstado
	    where Ecodigo = #session.Ecodigo#
      	and QEPvalorDefault = 1 
    </cfquery>
</cfif>

<cfset LvarQPidEstado = rsEstados.QPidEstado>


<!--- Procesar los registros a importar en las tablas del sistema --->
<cfquery name="rsRegistros" datasource="#session.dsn#">
	select 
    	QPTNumParte,
	    QPTFechaProduccion,
	    QPTNumSerie,
	    QPTPAN,
	    QPTNumLote,
	    QPTNumPall
    from #table_name#
</cfquery>

<cfset LvarCantErrLuhn = 0>
<cfloop query="rsRegistros">
	<cfset session.Importador.Avance = rsRegistros.currentRow/rsRegistros.recordCount>
	<cfif (rsRegistros.currentRow mod 30 EQ 0)>
		 <!--- veamos si hay que cancelar el proceso --->
		<cfflush>
	</cfif>

	<cfinvoke component="sif.QPass.Componentes.QPVerificaLuhn" method="ValidaDigitoLuhn" returnvariable="LvarStatusLuhn">
	    <cfinvokeargument name="NoTarjeta" value="#rsRegistros.QPTPAN#">
    </cfinvoke>

	<cfif LvarStatusLuhn LT 100>
		<cfset temp = QueryAddRow(Err)>
		<cfset LvarCantErrLuhn = LvarCantErrLuhn + 1>
		<cfset Temp = QuerySetCell(Err, "QPTPAN", rsRegistros.QPTPAN)>
		<cfset Temp = QuerySetCell(Err, "QPTNumSerie", rsRegistros.QPTNumSerie)>
		<cfset Temp = QuerySetCell(Err, "QPTFechaProduccion", rsRegistros.QPTFechaProduccion)>
		<cfset Temp = QuerySetCell(Err, "Error1", "Digito verificador Incorrecto")>
		<cfset Temp = QuerySetCell(Err, "Error2", "Error: #LvarStatusLuhn#")>
        <cfif LvarStatusLuhn GTE 0>
			<cfset Temp = QuerySetCell(Err, "Error2", "Digito verificador Esperado: #LvarStatusLuhn#")>
        </cfif>
    </cfif>
</cfloop> 

<cfif Err.recordcount GT 0>
    <cfreturn false>
</cfif>

<cftransaction>
	<!--- Insertar los Lotes de Tags que no existan para luego poder usarlos en el proceso de insercion de registros --->
    <cfquery datasource="#session.dsn#">
        insert into QPassLote 
            (Ecodigo, QPLcodigo, QPLdescripcion, QPLfechaProduccion, QPLfechaFinVigencia, BMfecha, BMUsucodigo)
        select distinct 
            #session.Ecodigo#, t.QPTNumLote, t.QPTNumLote, '20' + t.QPTFechaProduccion, #createdate(6100,1,1)#, #now()#, #session.Usucodigo#
        from #table_name# t
        where not exists(
            select 1
            from QPassLote l
            where l.QPLcodigo = t.QPTNumLote
        )
    </cfquery>

	<cfset session.Importador.SubTipo = "2">

    <cfquery datasource="#session.dsn#">
        insert into QPassTag (
                Ecodigo,
                QPTNumParte, 
                QPTFechaProduccion, 
                QPTNumSerie, 
                QPTPAN, 
                QPTNumLote, 
                QPTNumPall, 
                QPTEstadoActivacion, 
                BMFecha,
                BMusucodigo,
                QPidLote, 
                QPidEstado,
                Ocodigo)
        select 
                #session.Ecodigo#,
                t.QPTNumParte, 
                '20'+t.QPTFechaProduccion, 
                t.QPTNumSerie, 
                t.QPTPAN, 
                t.QPTNumLote, 
                t.QPTNumPall, 
                1,
                #now()#,
                #session.Usucodigo#,
                l.QPidLote,
                #LvarQPidEstado#,
                #LvarUsuarioOficina#
        from #table_name# t
            inner join QPassLote l
            on l.QPLcodigo = t.QPTNumLote
    </cfquery>
    
    <cfquery datasource="#session.dsn#">
        insert into QPassTagMov (
                QPTidTag, QPTMovtipoMov, QPTNumParte, 
                QPTFechaProduccion, QPTNumSerie, QPTPAN, QPTNumLote, 
                QPTNumPall, QPTEstadoActivacion, 
                Ecodigo, Ocodigo, OcodigoDest, QPidLote, QPidEstado, BMFecha, BMusucodigo)
        select
                t.QPTidTag, 1, t.QPTNumParte, 
                t.QPTFechaProduccion, t.QPTNumSerie, t.QPTPAN, t.QPTNumLote, 
                t.QPTNumPall, t.QPTEstadoActivacion, 
                t.Ecodigo, t.Ocodigo, t.Ocodigo, t.QPidLote, t.QPidEstado, #now()#, #session.Usucodigo#
        from #table_name# a
            inner join QPassTag t
            on t.Ecodigo = #session.Ecodigo#
            and t.QPTPAN = a.QPTPAN
            and t.QPTNumSerie = a.QPTNumSerie
  </cfquery>
</cftransaction>
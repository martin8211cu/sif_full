<!---*********************************
	Módulo   : Control de Reponsables
	Nombre   : Reporte de Documentos Inconsistentes
	Descripción : Muestra una consulta de todos los vales inconsistentes para un centro de custodia.
	***********************************
	Hecho por: Steve Vado Rodríguez
	Creado    : 20/04/2006
	***********************************
	Modificado por: Dorian Abarca Gómez
	Modificado: 18 Julio 2006
	Moficaciones:
	1. Se modifica para que se imprima y baje a excel con el cf_htmlreportsheaders.
	2. Se verifica uso de jdbcquery.
	3. Se verifica uso de cf_templateheader y cf_templatefooter.
	4. Se verifica uso de cf_web_portlet_start y cf_web_portlet_end.
	5. Se agrega cfsetting y cfflush.
	6. Se envían estilos al head por medio del cfhtmlhead.
	7. Se mantienen filtros de la consulta.
	***************************** --->
<cfsetting showdebugoutput="no" requesttimeout="36000">
<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	title="Documentos Inconsistentes" 
	filename="DocumentosInconsistentes#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" 
	ira="DocumentosInconsistentes.cfm">

<cfset fnGeneraQuery()>

<!--- Estilos --->
<cfhtmlhead text="
	<style>
		h1.corte {
			PAGE-BREAK-AFTER: always;}
		.titulo_empresa {
			font-size:16px;
			font-weight:bold;
			text-align:center;}
		.titulo_reporte {
			font-size:12px;
			font-weight:bold;
			text-align:center;}
		.titulo_filtro {
			font-size:10px;
			font-weight:bold;
			text-align:center;}
		.titulo_columna {
			font-size:10px;
			font-weight:bold;
			background-color:##CCCCCC;
			text-align:left;}
		.agrupamiento {
			font-size:12px;
			font-weight:bold;
			background-color:##CCCCCC;
			text-align:left;}
		.titulo_columnar {
			font-size:10px;
			font-weight:bold;
			background-color:##CCCCCC;
			text-align:right;}
		.detalle {
			font-size:10px;
			text-align:left;}
		.detaller {
			font-size:10px;
			text-align:right;}
		.mensaje {
			font-size:10px;
			text-align:center;}
		.paginacion {
			font-size:10px;
			text-align:center;}
	</style>"
>
<cfflush interval="26">

<!--- Variables --->
<cfset MaxLineasReporte = 60>
<cfset nLnEncabezado = 8>		 <!--- Total de líneas del encabezado --->
<cfset nCols = 4>				 <!--- Total de columnas del encabezado --->

<cfinclude template="RetUsuario.cfm">
<!--- Llena el Encabezado --->
<cfsavecontent variable="Encabezado">
	<cfoutput>
		<tr><td colspan="#nCols#" class="titulo_empresa"></td></tr>
		<tr><td colspan="#nCols#" class="titulo_empresa">#trim(rsEmpresa.Edescripcion)#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_reporte">Documentos Inconsistentes</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Centro de Custodia: #trim(rsCustodia.CRCCdescripcion)#</td></tr>
		<tr><td colspan="#nCols#" class="paginacion">#trim(LSDateFormat(Now(),'dd/mm/yyyy'))# #trim(LSTimeFormat(Now(),'HH:mm:ss'))#</td></tr>	
		<tr><td colspan="#nCols#" class="paginacion">Cantidad de Vales con Error: #rsReporteCount.recordcountdb#</td></tr>
		<!--- 		<tr><td>&nbsp;</td></tr> --->
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
		<tr>
			<td width="10%" class="titulo_columna">Placa</td>
			<td width="24%" class="titulo_columna">Empleado</td>
			<td width="6%" class="titulo_columna">CF</td>
			<td class="titulo_columna">Error</td>
		</tr>
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
	</cfoutput>
</cfsavecontent>

<cfquery name="rsReporte" datasource="#session.DSN#">
    #preservesinglequotes(myquery)#
</cfquery>

<cfif isdefined("form.Exportar")>
    <cf_exportQueryToFile query="#rsReporte#" separador="#chr(9)#" filename="DocumentosInconsistentes#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" jdbc="false">
    <cfabort>
</cfif>
<!--- Encabezado --->
<!--- Pinta el Reporte --->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<cfoutput>#Encabezado#</cfoutput>

		<!--- Detalle --->
		<cfset contador = nLnEncabezado>
		<cfset vCRTDid = "">
		<cfloop query="rsReporte">
			<cfoutput>
			<cfset tiene = false>	
			<cfif contador gte MaxLineasReporte>
				<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
				#Encabezado#
				<cfset contador = nLnEncabezado>
			</cfif>
			
			<cfif trim(CRTDid) neq trim(vCRTDid)>
				<cfset vCRTDid = #trim(CRTDid)#>
				<cfset contador = contador + 2>
				<tr><td colspan="#nCols#" class="agrupamiento">Tipo de Documento:&nbsp;#trim(tipoDocumento)#</td></tr>
			</cfif>
	
			<tr>				
				<td class="detalle" valign="top">&nbsp;&nbsp;#trim(Aplaca)#</td>
				<td class="detalle" valign="top">#trim(DEidentificacion)# - #trim(nombre)#</td>
				<td class="detalle" valign="top">#trim(CFcodigo)#</td>
				<td class="detalle" valign="top">
				<cfif Error1 eq 0>
                    <cfif tiene eq true><br></cfif>1:#trim(form.Error1)#
                    <cfset tiene = true>
                    <cfset contador = contador + 1>
                </cfif>
				<cfif Error2 eq 0>
                    <cfif tiene eq true><br></cfif>2:#trim(form.Error2)#
                    <cfset tiene = true>
                    <cfset contador = contador + 1>
                </cfif>
				<cfif Error3 gt 0>
                    <cfif tiene eq true><br></cfif>3:#trim(form.Error3)#
                    <cfset tiene = true>
                    <cfset contador = contador + 1>
                </cfif>
				<cfif Error4 gt 0>
                    <cfif tiene eq true><br></cfif>#trim(form.Error4)#
                    <cfset tiene = true>
                    <cfset contador = contador + 1>
                </cfif>
                
					<cfif #len(trim(Error5))# gt 0>
						<cfif tiene eq true><br></cfif>#trim(form.Error5)#
						<cfset tiene = true>
						<cfset contador = contador + 1>
					</cfif>
					<cfif #len(trim(Error6))# gt 0>
						<cfif tiene eq true><br></cfif>#trim(form.Error6)#
						<cfset tiene = true>
						<cfset contador = contador + 1>
					</cfif>
					<cfif #len(trim(Error7))# gt 0>
						<cfif tiene eq true><br></cfif>#trim(form.Error7)#
						<cfset tiene = true>
						<cfset contador = contador + 1>
					</cfif>
					<cfif #len(trim(Error8))# gt 0>
						<cfif tiene eq true><br></cfif>#trim(form.Error8)#
						<cfset tiene = true>
						<cfset contador = contador + 1>
					</cfif>
					<cfif #len(trim(Error9))# gt 0>
						<cfif tiene eq true><br></cfif>#trim(form.Error9)#
						<cfset tiene = true>
						<cfset contador = contador + 1>
					</cfif>
					<cfif #len(trim(Error10))# gt 0>
						<cfif tiene eq true><br></cfif>#trim(form.Error10)#
						<cfset tiene = true>
						<cfset contador = contador + 1>
					</cfif>															
				</td>
			</tr>
            </cfoutput>
            <cfflush>
		</cfloop>
</table>
<cfoutput>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
	<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
	<tr><td colspan="#nCols#" class="paginacion"> - Fin del Reporte - </td></tr>
</table>
</cfoutput>
</body>
</html>

<cffunction name="fnGeneraQuery" access="private" output="no" hint="Genera los queries">
	<!--- Empieza a pintar el reporte en el usuario cada 512 bytes los bytes que toma en cuenta son de aquí en adelante omitiendo lo que hay antes, y la informació de los headers de la cantidad de bytes --->
    <cf_dbfunction name="now" returnvariable="hoy">
    <!--- Consultas --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion
        from Empresas
        where Ecodigo =   #Session.Ecodigo# 
    </cfquery>
    <cfquery name="rsCustodia" datasource="#session.DSN#">
        select CRCCdescripcion
        from CRCentroCustodia
        where Ecodigo =  #Session.Ecodigo# 
          and CRCCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">
    </cfquery>
    
    <!--- Obtiene el año y el mes de Auxiliares --->
    <cfquery name="myResult" datasource="#session.dsn#">
        select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as value
        from Parametros
        where Ecodigo = #session.ecodigo#
            and Pcodigo = 50
    </cfquery>
    <cfset CurrentPeriodoAux = myResult.value>
    <cfquery name="myResult" datasource="#session.dsn#">
        select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as value
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
            and Pcodigo = 60
    </cfquery>
    <cfset CurrentMesAux = myResult.value>
    
    <!--- Validación de la cantidad de líneas para desplegar el reporte --->
    <CFSET MAXROWSALLOWED = 70000>
    
    <cfquery name="rsReporteCount" datasource="#session.DSN#" >
        select count(1) as recordcountdb
        from AFResponsables a 
        where a.CRCCid  = #form.CRCCid#
          and a.AFRfini <= #hoy#
          and a.AFRffin >= #hoy#
          and #hoy# between a.AFRfini and a.AFRffin
          and (
                <!--- error 1:  No Existe el Centro de Custodia --->
                (
                        select count(1) 
                        from CRCCCFuncionales c 
                                        where a.CRCCid = c.CRCCid 
                                          and a.CFid = c.CFid
                ) = 0
                or 
                <!--- error 2: El empleado del vale no esta vigente --->
                (
                        select count(1) 
                        from EmpleadoCFuncional b 
                        where a.Ecodigo = b.Ecodigo 
                          and a.DEid = b.DEid 
                          and a.CFid = b.CFid 
                          and #hoy# between b.ECFdesde and b.ECFhasta
                ) = 0
                or 
                (
                    <!--- error 3: El centro de custodia asignado tiene control de Categoria / Clase y la categoría / clase no está en los asignados a este centro de custodia --->	
                    (
                        select count(1)
                        from CRAClasificacion ccc1
                        where ccc1.CRCCid = a.CRCCid
                    ) > 0
                    and
                    (
                        select count(1)
                        from Activos act
                            inner join CRAClasificacion cc2
                            on  cc2.Ecodigo  = act.Ecodigo
                            and cc2.ACid     = act.ACid
                            and cc2.ACcodigo = act.ACcodigo
                        where act.Aid = a.Aid
                          and cc2.CRCCid   =  a.CRCCid
                     ) = 0   
                )				
                or
                (
                    <!--- error 4: La Categoría / Clase está restringida a Centros de Custodia específicos y el centro de custodia asignado al vale es diferente a alguno de estos. --->	
                    (
                        select count(1)
                        from Activos act
                            inner join CRAClasificacion cc2
                            on  cc2.Ecodigo  = act.Ecodigo
                            and cc2.ACid     = act.ACid
                            and cc2.ACcodigo = act.ACcodigo
                        where act.Aid = a.Aid
                    ) > 0
                    and
                    (
                        select count(1)
                        from Activos act
                            inner join CRAClasificacion cc2
                            on  cc2.Ecodigo  = act.Ecodigo
                            and cc2.ACid     = act.ACid
                            and cc2.ACcodigo = act.ACcodigo
                        where act.Aid = a.Aid
                        and cc2.CRCCid   = a.CRCCid
                     ) = 0   
                )					
                or
                    <!--- Error 5.  El empleado no está vigente en el sistema --->
                    (	
                        select count(1) 
                        from EmpleadoCFuncional b 
                        where a.DEid = b.DEid 
                          and #hoy# between b.ECFdesde and b.ECFhasta
                    ) = 0
                or
                    <!--- Error 6:  Centro Funcional del Vale es diferente al Centro Funcional de la tabla de Saldos Vigente --->
                    (
                        select count(1) 
                        from AFSaldos sal 
                        where sal.Aid			= a.Aid 
                          and sal.AFSperiodo	= #CurrentPeriodoAux# 
                          and sal.AFSmes		= #CurrentMesAux#
                          and sal.Ecodigo		= a.Ecodigo
                          and sal.CFid			= a.CFid 
                    ) = 0
                or
                    <!--- Error 7: No existe el Centro de Custodia --->
                    (
                        select count(1)
                        from CRCentroCustodia b 
                        where b.CRCCid = a.CRCCid
                    ) = 0
                or
                    <!--- error 8:  No existe el centro funcional --->
                    (
                        select count(1) 
                        from CFuncional b 
                        where b.CFid = a.CFid
                    ) = 0
                or
                    <!--- error 9:  No Existe el Activo --->
                    (
                        select count(1) 
                        from Activos act 
                        where act.Aid = a.Aid
                    ) = 0
                or
                    <!--- Error 10:  No existe el Empleado --->
                    (
                        select count(1) 
                        from DatosEmpleado emp 
                        where emp.DEid = a.DEid
                    ) = 0
                )
    </cfquery>
    
    <cfif rsReporteCount.recordcountdb gt MAXROWSALLOWED>
        <cf_errorCode	code = "50123"
        				msg  = "El reporte no puede ser procesado. Con los filtros definidos se obtienen @errorDat_1@ registros, mas de los @errorDat_2@ soportados. Proceso Cancelado!"
        				errorDat_1="#rsReporteCount.recordcountdb#"
        				errorDat_2="#MAXROWSALLOWED#"
        >
    </cfif>

    <cf_dbfunction name="concat" args="d.DEapellido1 ,' ', d.DEapellido2,' ', d.DEnombre"  returnvariable="Nombre" >
    <!--- Reporte --->
    <cfsavecontent variable="myquery">
        <cfoutput>
        <!--- error 9:  No Existe el Activo --->
        select
            a.AFRid,
            a.CRTDid,
            ' ' as Aplaca,
            ((select min(d.DEidentificacion) from DatosEmpleado d where d.DEid = a.DEid)) as DEidentificacion,
            ((select min(#Nombre#) from DatosEmpleado d where d.DEid = a.DEid)) as nombre,
            ((select min(cf.CFcodigo) from CFuncional cf where cf.CFid = a.CFid))as CFcodigo,
            ((select min(rtrim(f.CRTDdescripcion)) from CRTipoDocumento f where f.CRTDid = a.CRTDid)) as tipoDocumento,
            1 as Error1,
            1  as Error2,
            0  as Error3,
            0  as Error4,
            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">  as Error5,
            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">  as Error6,
            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">  as Error7,
            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">  as Error8,
            1 as Error9,
            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">  as Error10
        from AFResponsables a  
        where a.CRCCid  = #form.CRCCid#
          and #hoy# between a.AFRfini and a.AFRffin
          and (
            select count(1) 
            from Activos act 
            where act.Aid = a.Aid
            ) = 0
            
        union
    
        select 
            a.AFRid,
            a.CRTDid,
            a1.Aplaca as Aplaca,
            ((select min(d.DEidentificacion) from DatosEmpleado d where d.DEid = a.DEid)) as DEidentificacion,
            ((select min(#Nombre#) from DatosEmpleado d where d.DEid = a.DEid)) as nombre,
            ((select min(cf.CFcodigo) from CFuncional cf where cf.CFid = a.CFid))as CFcodigo,
            ((select min(rtrim(f.CRTDdescripcion)) from CRTipoDocumento f where f.CRTDid = a.CRTDid)) as tipoDocumento,
             <!--- error 1:  No Existe el Centro de Custodia --->
            ( 
               select count(1) 
               from CRCCCFuncionales c 
               where c.CRCCid  = a.CRCCid
                 and c.CFid    = a.CFid
            ) as Error1, 
            <!--- error 2: El empleado del vale no esta vigente --->
            (
                select count(1) 
                from EmpleadoCFuncional b 
                where a.Ecodigo = b.Ecodigo 
                  and a.DEid = b.DEid 
                  and a.CFid = b.CFid 
                  and #hoy# between b.ECFdesde and b.ECFhasta
            ) as Error2, 
			<!--- error 3: El centro de custodia asignado tiene control de Categoria / Clase y la categoria / clase no esta¡ en los asignados a este centro de custodia --->
	        (
                select count(1)
                from CRAClasificacion cccl
                where cccl.CRCCid   = a.CRCCid
                  and (
                      select count(1)
                      from CRAClasificacion cc2
                           inner join Activos act
                              on cc2.Ecodigo  = act.Ecodigo
                             and cc2.ACid     = act.ACid
                             and cc2.ACcodigo = act.ACcodigo
                      where act.Aid = a.Aid
                        and cc2.CRCCid = cccl.CRCCid
                      ) = 0
            ) as Error3, 
			<!--- error 4: La Categoria / Clase esta restringida a Centros de Custodia especificos y el centro de custodia asignado al vale es diferente a alguno de estos. --->
			(
                select count(1)
                from Activos act
                        inner join CRAClasificacion cccl
                             on cccl.Ecodigo  = act.Ecodigo
                            and cccl.ACid     = act.ACid
                            and cccl.ACcodigo = act.ACcodigo
                where (
                    select count(1)
                    from Activos act
                        inner join CRAClasificacion cccl
                             on cccl.Ecodigo  = act.Ecodigo
                            and cccl.ACid     = act.ACid
                            and cccl.ACcodigo = act.ACcodigo
                          where cccl.CRCCid   = a.CRCCid
                    ) = 0
            ) as Error4, 
                    <!--- Error 5.  El empleado no estÃ¡ vigente en el sistema --->
                (select 1 from dual where not exists (	
                                select 1 
                                from EmpleadoCFuncional b 
                                where a.DEid = b.DEid 
                                  and a.Ecodigo = b.Ecodigo 
                                  and #hoy# between b.ECFdesde and b.ECFhasta
                                )) as Error5, 
                    <!--- Error 6:  Centro Funcional del Vale es diferente al Centro Funcional de la tabla de Saldos Vigente --->
                (select 1 from dual where not exists (
                            select 1 
                            from AFSaldos sal 
                            where a.Aid = sal.Aid 
                              and sal.AFSperiodo = #CurrentPeriodoAux# 
                              and sal.AFSmes = #CurrentMesAux#
                              and sal.Ecodigo = a.Ecodigo
                              and a.CFid = sal.CFid 
                        )) as Error6, 
                    <!--- Error 7: No existe el Centro de Custodia --->
                (select 1 from dual where not exists(
                            select 1
                            from CRCentroCustodia b 
                            where b.CRCCid = a.CRCCid
                        )) as Error7, 
                    <!--- error 8:  No existe el centro funcional --->
                (select 1 from dual where not exists(
                            select 1 from CFuncional b where b.CFid = a.CFid
                        )) as Error8, 
                <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> as Error9,
                    <!--- Error 10:  No existe el Empleado --->
                (select 1 from dual where not exists(
                            select 1 from DatosEmpleado emp where emp.DEid = a.DEid
                        )) as Error10
        from AFResponsables a 
            inner join Activos a1
                on a1.Aid = a.Aid
        where a.CRCCid  = #form.CRCCid#
          and a.AFRfini <= #hoy#
          and a.AFRffin >= #hoy#
          and #hoy# between a.AFRfini and a.AFRffin
          and (
                <!--- error 1:  No Existe el Centro de Custodia --->
                (
                        select count(1) 
                        from CRCCCFuncionales c 
                                        where a.CRCCid = c.CRCCid 
                                          and a.CFid = c.CFid
                ) = 0
                or 
                <!--- error 2: El empleado del vale no esta vigente --->
                (
                        select count(1) 
                        from EmpleadoCFuncional b 
                        where a.Ecodigo = b.Ecodigo 
                          and a.DEid = b.DEid 
                          and a.CFid = b.CFid 
                          and #hoy# between b.ECFdesde and b.ECFhasta
                ) = 0
                or 
                (
                    <!--- error 3: El centro de custodia asignado tiene control de Categoria / Clase y la categoría / clase no está en los asignados a este centro de custodia --->	
                    (
                        select count(1)
                        from CRAClasificacion ccc1
                        where ccc1.CRCCid = a.CRCCid
                    ) > 0
                    and
                    (
                        select count(1)
                        from Activos act
                            inner join CRAClasificacion cc2
                            on  cc2.Ecodigo  = act.Ecodigo
                            and cc2.ACid     = act.ACid
                            and cc2.ACcodigo = act.ACcodigo
                        where act.Aid = a.Aid
                          and cc2.CRCCid   =  a.CRCCid
                     ) = 0   
                )				
                or
                (
                    <!--- error 4: La Categoría / Clase está restringida a Centros de Custodia específicos y el centro de custodia asignado al vale es diferente a alguno de estos. --->	
                    (
                        select count(1)
                        from Activos act
                            inner join CRAClasificacion cc2
                            on  cc2.Ecodigo  = act.Ecodigo
                            and cc2.ACid     = act.ACid
                            and cc2.ACcodigo = act.ACcodigo
                        where act.Aid = a.Aid
                    ) > 0
                    and
                    (
                        select count(1)
                        from Activos act
                            inner join CRAClasificacion cc2
                            on  cc2.Ecodigo  = act.Ecodigo
                            and cc2.ACid     = act.ACid
                            and cc2.ACcodigo = act.ACcodigo
                        where act.Aid = a.Aid
                        and cc2.CRCCid   = a.CRCCid
                     ) = 0   
                )					
                or
                    <!--- Error 5.  El empleado no está vigente en el sistema --->
                    (	
                        select count(1) 
                        from EmpleadoCFuncional b 
                        where a.DEid = b.DEid 
                          and #hoy# between b.ECFdesde and b.ECFhasta
                    ) = 0
                or
                    <!--- Error 6:  Centro Funcional del Vale es diferente al Centro Funcional de la tabla de Saldos Vigente --->
                    (
                        select count(1) 
                        from AFSaldos sal 
                        where sal.Aid			= a.Aid 
                          and sal.AFSperiodo	= #CurrentPeriodoAux# 
                          and sal.AFSmes		= #CurrentMesAux#
                          and sal.Ecodigo		= a.Ecodigo
                          and sal.CFid			= a.CFid 
                    ) = 0
                or
                    <!--- Error 7: No existe el Centro de Custodia --->
                    (
                        select count(1)
                        from CRCentroCustodia b 
                        where b.CRCCid = a.CRCCid
                    ) = 0
                or
                    <!--- error 8:  No existe el centro funcional --->
                    (
                        select count(1) 
                        from CFuncional b 
                        where b.CFid = a.CFid
                    ) = 0
                or
                    <!--- Error 10:  No existe el Empleado --->
                    (
                        select count(1) 
                        from DatosEmpleado emp 
                        where emp.DEid = a.DEid
                    ) = 0
                )
        order by 2, 3
        </cfoutput>
    </cfsavecontent>

</cffunction>



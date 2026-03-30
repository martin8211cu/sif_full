<cf_dbtemp name="TempTrasAct_v1" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" 	mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 			mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(255)" 	mandatory="no">
</cf_dbtemp>

<!---
		Activos Origen 
			1.	valida Centro Funcional
			2.	valida Usuario
			3.  valida el permiso para consultar ( 1 o 0)
			4.  valida el permiso para traslados ( 1 o 0)
			5.  valida el permiso para reservas ( 1 o 0)
			6.  valida el permiso para formulacion ( 1 o 0)
			7.  valida el permiso para aprovaciones ( 1 o 0)
			8.  valida que el centro funcional padre exista
			9.  valida que no se encuentren rgistros repetidos en el archivo de importacion
			10.  valida que no se repitan los perisos, es decir, verifica si ya existen en la tabla
			11.  valida que no que el padre del centro funcional sea realmente el padre
			
----->

<!---Validacion 1.--->
    <cfquery datasource="#session.dsn#" name="rsCFuncional">
    insert into #ERRORES_TEMP# (Mensaje, DatoIncorrecto, ErrorNum)
	select '1. Centro Funcional No Existente o No es Valido' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.CFcodigo"> as DatoIncorrecto,
	1 as ErrorNum
  	from #table_name# a
		where not exists
		(
		select 1 
			from  CFuncional b
			 where  b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 and b.CFcodigo=a.CFcodigo
		)
</cfquery>
    
<!---Validacion 2.--->
	<cfquery name="rsUsulogin" datasource="#Session.DSN#">            
    insert into #ERRORES_TEMP# (Mensaje, DatoIncorrecto, ErrorNum)
	select '2. Usuario No Existente o No es Valido' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Usulogin"> as DatoIncorrecto,
	2 as ErrorNum
  	from #table_name# a
		where not exists
		(
		select 1 
			from  Usuario b
			 where b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			 and  b.Usulogin= a.Usulogin
		)
	</cfquery>
<!---Validacion 3.--->
    <cfquery datasource="#session.dsn#" name="rsCPSUconsultar">
        select CPSUconsultar
        from #table_name#
        where CPSUconsultar<>1 and CPSUconsultar<>0
    </cfquery>
    <cfif rsCPSUconsultar.recordcount gt 0  >
    <cfloop query="rsCPSUconsultar">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '3. El valor CPSUconsultar no esta definido correctamente debe de ser 1 o 0.', 3,'#rsCPSUconsultar.CPSUconsultar#'
        </cfquery>
    </cfloop>
    </cfif>

<!---Validacion 4.--->
    <cfquery datasource="#session.dsn#" name="rsCPSUtraslados">
        select CPSUtraslados
        from #table_name#
        where CPSUtraslados<>1 and CPSUtraslados<>0
    </cfquery>
    <cfif rsCPSUtraslados.recordcount gt 0  >
    <cfloop query="rsCPSUtraslados">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '4. El valor CPSUtraslados no esta definido correctamente debe de ser 1 o 0.', 4,'#rsCPSUtraslados.CPSUtraslados#'
        </cfquery>
    </cfloop>
    </cfif>
    
<!---Validacion 5.--->
 <cfquery datasource="#session.dsn#" name="rsCPSUreservas">
        select CPSUreservas
        from #table_name#
        where CPSUreservas<>1 and CPSUreservas<>0
    </cfquery>
    <cfif rsCPSUreservas.recordcount gt 0  >
    <cfloop query="rsCPSUreservas">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '5. El valor CPSUreservas no esta definido correctamente debe de ser 1 o 0.', 5,'#rsCPSUreservas.CPSUreservas#'
        </cfquery>
    </cfloop>
    </cfif>
 
<!---Validacion 6.--->  
 <cfquery datasource="#session.dsn#" name="rsCPSUformulacion">
        select CPSUformulacion
        from #table_name#
        where CPSUformulacion<>1 and CPSUformulacion<>0
    </cfquery>
    <cfif rsCPSUformulacion.recordcount gt 0  >
    <cfloop query="rsCPSUformulacion">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '6. El valor CPSUformulacion no esta definido correctamente debe de ser 1 o 0.', 6,'#rsCPSUformulacion.CPSUformulacion#'
        </cfquery>
    </cfloop>
    </cfif>

<!---Validacion 7.--->
   
 <cfquery datasource="#session.dsn#" name="rsCPSUaprobacion">
        select CPSUaprobacion
        from #table_name#
        where CPSUaprobacion<>1 and CPSUaprobacion<>0
    </cfquery>
    <cfif rsCPSUaprobacion.recordcount gt 0  >
    <cfloop query="rsCPSUaprobacion">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '7. El valor CPSUaprobacion no esta definido correctamente debe de ser 1 o 0.', 7,'#rsCPSUaprobacion.CPSUaprobacion#'
        </cfquery>
    </cfloop>
    </cfif>
<!---Validacion 8.--->
    <cfquery datasource="#session.dsn#" name="rsCFuncional">
    insert into #ERRORES_TEMP# (Mensaje, DatoIncorrecto, ErrorNum)
	select '8. Centro Funcional Padre No Existente o No es Valido' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.CFcodigoPadre"> as DatoIncorrecto,
	8 as ErrorNum
  	from #table_name# a
		where not exists
		(
		select 1 
			from  CFuncional b
			 where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 and b.CFcodigo = a.CFcodigoPadre or  a.CFcodigoPadre is null
		)
	</cfquery>
    
    
<!---Validacion#1 errores tabla temporal--->
<cfquery name="err" datasource="#session.dsn#">
select *
from #ERRORES_TEMP#

</cfquery>
<!--- Si hay errores los devuelve, si no realiza el proceso de importación --->
<cfif (err.recordcount) EQ 0>
    
	<!--- crear tabla temporal para verificar la integridad de datos y almacenarlos temporalmente antes de insertar --->
    <cf_dbtemp name="listaDatos" datasource="#session.DSN#" returnvariable="listaDatos">
        <cf_dbtempcol name="Usulogin"   type="varchar(100)" mandatory="no">
        <cf_dbtempcol name="CFcodigo"   type="char(10)" mandatory="no">
        <cf_dbtempcol name="CFid"   type="numeric" mandatory="no">
        <cf_dbtempcol name="CFidpadre"   type="numeric" mandatory="no">
        <cf_dbtempcol name="Usucodigo"   type="numeric" mandatory="no">
        <cf_dbtempcol name="CPSUidOrigen"   type="numeric" mandatory="no">
        <cf_dbtempcol name="CPSUid"   type="numeric" mandatory="no">
        <cf_dbtempcol name="CFpath"   type="varchar(100)" mandatory="no">
        <cf_dbtempcol name="CFpathpadre"   type="varchar(100)" mandatory="no">
    </cf_dbtemp>
    
    <!--- Se agregan el usuario y cf en la tabla temporal--->
	<cfquery datasource="#session.dsn#">	
       	INSERT INTO #listaDatos#
        (Usulogin,CFcodigo)
        select Usulogin,CFcodigo from #table_name#
	</cfquery>
    
    <!--- optener el id de los CF y la ruta--->
    <cfquery datasource="#session.dsn#">	
        update #listaDatos#
        	SET CFid = a.CFid, CFpath=a.CFpath
        from 
        	CFuncional a, 
        	#listaDatos# inner join #table_name# on #listaDatos#.Usulogin= #table_name#.Usulogin 
        	and #listaDatos#.CFcodigo= #table_name#.CFcodigo
        where 
        	a.CFcodigo = #table_name#.CFcodigo 
        	and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            
        </cfquery>
        
		<!--- optener el id de los CF Padres--->
        <cfquery datasource="#session.dsn#">	
            update #listaDatos#
                SET CFidpadre = a.CFid ,CFpathpadre=a.CFpath
            from 
                CFuncional a, 
                #listaDatos# inner join #table_name# on #listaDatos#.Usulogin= #table_name#.Usulogin 
                and #listaDatos#.CFcodigo= #table_name#.CFcodigo
            where 
                a.CFcodigo = #table_name#.CFcodigoPadre 
                and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        
        <!--- obtener los id de los usuarios --->
        <cfquery datasource="#session.dsn#">	
            UPDATE #listaDatos#
            SET Usucodigo = a.Usucodigo
            from Usuario a
            where a.Usulogin = #listaDatos#.Usulogin
        </cfquery>
        
        <!--- validar que no hay permisos o registros repetidos--->      
        <cfquery datasource="#session.dsn#">	
        insert into #ERRORES_TEMP# (Mensaje, DatoIncorrecto, ErrorNum)
            SELECT 
            '9. Hay registros repetidos en el archivo de importacion' ,'Centro Funcional:'+CFcodigo+'   Usuario:'+Usulogin, 9
             FROM #listaDatos#  
            GROUP BY CFcodigo,Usulogin
            HAVING count(*) > 1
		</cfquery>
         <cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, DatoIncorrecto, ErrorNum)
            select  '10. Los permisos para el centro funcional ya estan asignados' ,'Centro Funcional:'+a.CFcodigo+'   Usuario:'+a.Usulogin, 10
            from #listaDatos# a, CPSeguridadUsuario cfsu
            where 
            a.CFid=cfsu.CFid and
            a.Usucodigo=cfsu.Usucodigo
		</cfquery>
         
		 <!--- validar que el hijo sea realmente un hijo del cebtro funcional---> 
        <cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
             select '11.  El Centro Funcional no corresponde con el Centro Funcional Padre ', 11,'Centro Funcional:'+a.CFcodigo+'   Padre:'+a.CFcodigoPadre
                from  #listaDatos# b inner join #table_name# a on b.Usulogin= a.Usulogin 
                and b.CFcodigo= a.CFcodigo
                 where b.CFid=b.CFid
                 and b.Usucodigo = b.Usucodigo and
                 b.CFpathpadre is not null and b.CFpathpadre<>''
                 and b.CFpath not like b.CFpathpadre+'%'
           
        </cfquery>
        
		<!---Validacion#2 errores tabla temporal--->
        <cfquery name="err" datasource="#session.dsn#">
        select *
        from #ERRORES_TEMP#
        
        </cfquery>
        <!--- Si hay errores los devuelve, si no realiza el proceso de importación --->
        <cfif (err.recordcount) EQ 0>
        
        
        <!---iniciar la insercion masiva de datos --->        
        <cfquery datasource="#session.dsn#">	
        BEGIN TRANSACTION 
            
            	---insertar padres
            	insert into CPSeguridadUsuario(Ecodigo,CFid,Usucodigo,CPSUconsultar,CPSUtraslados,CPSUreservas,CPSUformulacion,CPSUaprobacion,BMUsucodigo)
                select 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> as Ecodigo,
                #listaDatos#.CFid,
                #listaDatos#.Usucodigo,
                #table_name#.CPSUconsultar,
                #table_name#.CPSUtraslados,
                #table_name#.CPSUreservas,
                #table_name#.CPSUformulacion,
                #table_name#.CPSUaprobacion,
                #listaDatos#.Usucodigo
                from #listaDatos# inner join #table_name# on #listaDatos#.Usulogin= #table_name#.Usulogin 
                and #listaDatos#.CFcodigo= #table_name#.CFcodigo
                where #table_name#.CFcodigoPadre  is null or #table_name#.CFcodigoPadre  = ''
                
                ---actualizar los ids de la tabla
                UPDATE #listaDatos#
                SET CPSUid = a.CPSUid
                from CPSeguridadUsuario a
                where a.Usucodigo = #listaDatos#.Usucodigo
                and a.CFid = #listaDatos#.CFid
                
                ---actualizar los ids de los padres
                UPDATE #listaDatos#
                SET CPSUidOrigen = a.CPSUid
                from CPSeguridadUsuario a
                where a.Usucodigo = #listaDatos#.Usucodigo
                and a.CFid = #listaDatos#.CFidpadre
                
                ---insertar hijos
            	insert into CPSeguridadUsuario(Ecodigo ,CFid,Usucodigo ,CPSUconsultar ,CPSUtraslados ,CPSUreservas ,CPSUformulacion ,CPSUaprobacion ,BMUsucodigo ,CPSUidOrigen)
                select 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> as Ecodigo,
                #listaDatos#.CFid,
                #listaDatos#.Usucodigo,
                #table_name#.CPSUconsultar,
                #table_name#.CPSUtraslados,
                #table_name#.CPSUreservas,
                #table_name#.CPSUformulacion,
                #table_name#.CPSUaprobacion,
                #listaDatos#.Usucodigo,
                #listaDatos#.CPSUidOrigen
                from #listaDatos# inner join #table_name# on #listaDatos#.Usulogin= #table_name#.Usulogin 
                and #listaDatos#.CFcodigo= #table_name#.CFcodigo
                where #table_name#.CFcodigoPadre  is not null or #table_name#.CFcodigoPadre  <> ''
                
                
            IF @@ERROR != 0
                BEGIN
                    ROLLBACK TRANSACTION 
                    RETURN
                END
            ELSE  
                BEGIN
                    COMMIT TRANSACTION
                    RETURN
                END
               
           
		</cfquery>
        
        </cfif>
    	
<!--- fin if re registros ---> 
</cfif>

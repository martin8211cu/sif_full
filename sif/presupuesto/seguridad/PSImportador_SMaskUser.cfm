<cf_dbtemp name="TempTrasAct_v1" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" 	mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 			mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(255)" 	mandatory="no">
</cf_dbtemp>

<!---
		Activos Origen 
			1.	valida Usuario
			2.	Valida descripcion de la mascara
			3.	Valida valor de la mascara
			4.  valida el permiso para consultar ( 1 o 0)
			5.  valida el permiso para traslados ( 1 o 0)
			6.  valida el permiso para reservas ( 1 o 0)
			7.  valida el permiso para formulacion ( 1 o 0)
			
----->

<!---Validacion 1.--->
	<cfquery name="rsUsulogin" datasource="#Session.DSN#">            
    insert into #ERRORES_TEMP# (Mensaje, DatoIncorrecto, ErrorNum)
	select '1. Usuario No Existente o No es Valido' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Usulogin"> as DatoIncorrecto,
	1 as ErrorNum
  	from #table_name# a
		where not exists
		(
		select 1 
			from  Usuario b
			 where b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			 and  b.Usulogin= a.Usulogin
		)
	</cfquery>
<!--- ***************************************************************************************************************** --->
	<!---Validacion 2.--->
    <cfquery datasource="#session.dsn#" name="rsCPSMdescripcion">
        select CPSMdescripcion
        from #table_name#
        where CPSMdescripcion is null or CPSMdescripcion='' or CPSMdescripcion=NULL
    </cfquery>
    <cfif rsCPSMdescripcion.recordcount gt 0  >
    <cfloop query="rsCPSMdescripcion">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '2. El valor CPSMdescripcion no esta definido correctamente debe de ser diferente a nulo.', 2,'#rsCPSMdescripcion.CPSMdescripcion#'
        </cfquery>
    </cfloop>
    </cfif>
<!--- ***************************************************************************************************************** --->
	<!---Validacion 3.--->
    <cfquery datasource="#session.dsn#" >
        insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		select '3. El valor CPSMascaraP no esta definido correctamente debe de ser diferente a nulo.', 3, CPSMascaraP
        from #table_name#
        where CPSMascaraP is null or CPSMascaraP='' or CPSMascaraP=NULL
    </cfquery>
	
	<!--- verificar que la mascara tenga el signo % --->
	<cfquery datasource="#session.dsn#" name="rsCPSMascaraP">
		SELECT * FROM #table_name#
	</cfquery>
    <cfif rsCPSMascaraP.recordcount gt 0  >
    <cfloop query="rsCPSMascaraP">
		
    	<cfset tmpvar=rsCPSMascaraP.CPSMascaraP>
		<!--- agregar el & de la mascara --->
		<cfif isdefined("tmpvar") and right(tmpvar,1) NEQ "%">
			<cfset tmpvar = tmpvar & "%">
			<cfquery datasource="#session.dsn#" >
				UPDATE #table_name# SET CPSMascaraP='#tmpvar#'
				WHERE 
					Usulogin='#rsCPSMascaraP.Usulogin#'
					AND CPSMdescripcion='#rsCPSMascaraP.CPSMdescripcion#'
					AND CPSMconsultar=#rsCPSMascaraP.CPSMconsultar#
					AND CPSMtraslados=#rsCPSMascaraP.CPSMtraslados#
					AND CPSMreservas=#rsCPSMascaraP.CPSMreservas#
					AND CPSMformulacion=#rsCPSMascaraP.CPSMformulacion#
					
			</cfquery>
		</cfif>
		
    </cfloop>
    </cfif>
<!--- ***************************************************************************************************************** --->
<!---Validacion 4.--->
    <cfquery datasource="#session.dsn#" name="rsCPSMconsultar">
        select CPSMconsultar
        from #table_name#
        where CPSMconsultar<>1 and CPSMconsultar<>0
    </cfquery>
    <cfif rsCPSMconsultar.recordcount gt 0  >
    <cfloop query="rsCPSMconsultar">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '4. El valor CPSMconsultar no esta definido correctamente debe de ser 1 o 0.', 4,'#rsCPSMconsultar.CPSMconsultar#'
        </cfquery>
    </cfloop>
    </cfif>
	
<!--- ***************************************************************************************************************** --->
<!---Validacion 5.--->
    <cfquery datasource="#session.dsn#" name="rsCPSMtraslados">
        select CPSMtraslados
        from #table_name#
        where CPSMtraslados<>1 and CPSMtraslados<>0
    </cfquery>
    <cfif rsCPSMtraslados.recordcount gt 0  >
    <cfloop query="rsCPSMtraslados">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '5. El valor CPSMtraslados no esta definido correctamente debe de ser 1 o 0.', 5,'#rsCPSMtraslados.CPSMtraslados#'
        </cfquery>
    </cfloop>
    </cfif>
<!--- ***************************************************************************************************************** --->
<!---Validacion 6.--->
 <cfquery datasource="#session.dsn#" name="rsCPSMreservas">
        select CPSMreservas
        from #table_name#
        where CPSMreservas<>1 and CPSMreservas<>0
    </cfquery>
    <cfif rsCPSMreservas.recordcount gt 0  >
    <cfloop query="rsCPSMreservas">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '6. El valor CPSMreservas no esta definido correctamente debe de ser 1 o 0.', 6,'#rsCPSMreservas.CPSMreservas#'
        </cfquery>
    </cfloop>
    </cfif>
<!--- ***************************************************************************************************************** --->
<!---Validacion 7.--->  
 <cfquery datasource="#session.dsn#" name="rsCPSMformulacion">
        select CPSMformulacion
        from #table_name#
        where CPSMformulacion<>1 and CPSMformulacion<>0
    </cfquery>
    <cfif rsCPSMformulacion.recordcount gt 0  >
    <cfloop query="rsCPSMformulacion">
    	<cfquery datasource="#session.dsn#">
            insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
            select '7. El valor CPSMformulacion no esta definido correctamente debe de ser 1 o 0.', 7,'#rsCPSMformulacion.CPSMformulacion#'
        </cfquery>
    </cfloop>
    </cfif>
<!--- ***************************************************************************************************************** --->

<!---Validacion#1 errores tabla temporal--->
<cfquery name="err" datasource="#session.dsn#">
select *
from #ERRORES_TEMP#

</cfquery>
<!--- Si hay errores los devuelve, si no realiza el proceso de importación --->
<cfif (err.recordcount) EQ 0>

    <cfquery datasource="#session.dsn#">
        BEGIN TRANSACTION 
            
			insert into CPSeguridadMascarasCtasP 
			(Ecodigo, Usucodigo, CPSMdescripcion,CPSMascaraP, CPSMconsultar, CPSMtraslados, CPSMreservas, CPSMformulacion, BMUsucodigo)
			SELECT 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> as Ecodigo,
			u.Usucodigo as Usucodigo,
			t.CPSMdescripcion,
			t.CPSMascaraP,
			t.CPSMconsultar,
			t.CPSMtraslados,
			t.CPSMreservas,
			CPSMformulacion,
			#session.usucodigo# 		
			FROM
			#table_name# t inner join Usuario u on u.Usulogin=t.Usulogin
			WHERE u.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			
            IF @@ERROR != 0
                BEGIN
                    ROLLBACK TRANSACTION 
					
					Insert INTO #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
					VALUES('No se pudieron insertar los datos',8,'Commit transaction')
					
                    RETURN
                END
            ELSE  
                BEGIN
                    COMMIT TRANSACTION
                    RETURN
                END
               
           
		</cfquery>
	
</cfif>

<cf_dbtemp name="Errores" returnvariable="TableErr" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	 <cf_dbtempcol name="Valor"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">


<!--- Valida que no vengan relaciones Usuario / Oficina Repetidos --->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
	  select 'Usuario/Oficina repetido en el archivo', Login #_cat# ' ' #_cat# Codigo
      from #table_name#
      group by Login, Codigo
      having count(1) >1
</cfquery>

<!--- Valida que no exista el usuario a importar --->
<cfquery datasource="#session.dsn#">
	 insert into #TableErr#(Error)
	  select 'El Usuario no existe en el sistema' from dual
	  where ( select count(1)
				from #table_name# tem
				  inner join Usuario u
					on u.Usulogin = tem.Login
			  where u.CEcodigo = #session.CEcodigo# 
			 ) = 0
</cfquery>		

<!--- Valida que no exista la oficina a importar --->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error)
	  select 'La oficina no existe en el sistema' as Error from dual
	 where ( select count(1)
     		from #table_name# tem
			  inner join Oficinas o
                on o.Oficodigo = tem.Codigo
                and o.Ecodigo = #session.Ecodigo#
     		 ) = 0
</cfquery>

<cfquery name="Errores" datasource="#session.dsn#">
	select count(1) as cantidad 
	  from #TableErr#
</cfquery>

<cfif Errores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.dsn#">
		select Error, Valor
		  from #TableErr#
	</cfquery>	
<cfelse>

	<cfquery name="rsTemporal" datasource="#session.DSN#">
    	select Codigo, Login from #table_name#
    </cfquery>

	<cftransaction>
        <cfloop query="rsTemporal">
            <cfquery name="rsOcodigo" datasource="#session.DSN#">
                select Ocodigo
                from Oficinas
                where Oficodigo = '#rsTemporal.Codigo#'
                  and Ecodigo = #session.Ecodigo#
            </cfquery>

            <cfset LvarOcodigo = rsOcodigo.Ocodigo>
            <cfquery name="rsUsucodigo" datasource="#session.DSN#">
                select Usucodigo
                from Usuario
                where Usulogin = '#rsTemporal.Login#'
                  and CEcodigo = #session.CEcodigo#
            </cfquery>
            <cfset LvarUsucodigo = rsUsucodigo.Usucodigo>
            
            <cfquery datasource="#session.DSN#">
                insert into QPassUsuarioOficina (
                    Ecodigo,
                    Ocodigo,
                    Usucodigo
                    )
                    values(
                        #session.Ecodigo#,
                        #LvarOcodigo#,
                        #LvarUsucodigo#
                    )
            </cfquery>
        </cfloop>
	</cftransaction>	
</cfif>
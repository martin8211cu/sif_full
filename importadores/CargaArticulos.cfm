<cfscript>
	bcheck0 = false; // Chequeo de Existencia de Pago
	bcheck1 = false; // Chequeo de Transaccion de Pago
	bcheck2 = false; // Chequeo de Oficinas
	bcheck3 = false; // Chequeo de Monedas
	bcheck4 = false; // Chequeo de Socios de Negocios
	bcheck5 = false; // Chequeo de Documento a Pagar
	bcheck6 = false; // Chequeo de Monto de Pago
	bcheck7 = false; // Chequeo de Retenciones
	bcheck8 = false; // Chequeo de Saldo de Documentos
	bcheck9 = false; // Chequeo de Documentos en no mas de un pago
	bcheck10 = false; // Chequeo de Integridad de Encabezados
	bcheck11 = false; // Chequeo de Cuenta Bancaria 
</cfscript>

<!---NUEVO IMPORTADOR CARGA ARTICULOS Y RELACION EXISTENCIAS ALMACEN
Realizado por Alejandro Bolaños Gómez APPHOSTING 27-10-08 --->

<!---Se realiza lo siguiente: Se verifican los encabezadoz y se realizan las validaciones necesarias --->

<!--- Verifica que la Unidad Exista --->
<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0
	from #table_name# a
	where not exists (select 1 
			       		from Unidades
				        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    	                and Ucodigo = a.Unidad)
</cfquery>
<cfset bcheck0 = rsCheck0.check0 LT 1>

<!---Verifica que la Clasificacion exista  --->
<cfif bcheck0>
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists
	    (
			select 1 
        	from Clasificaciones
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    	    and Ccodigoclas = a.Clasificacion
	      ) 
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
</cfif>

<!--- Verifica que Almacen Exista--->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2
		from #table_name# a
		where not exists
	    (
			select 1 
        	from Almacen
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    	    and Almcodigo = a.Almacen
	      ) 
	</cfquery>
    <cfset bcheck2 = rsCheck2.check2 LT 1>
</cfif>

<!--- Verifica que el Impuesto Exista --->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists
        (
			select 1
			from Impuestos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and Icodigo = a.Impuesto
		)
        and a.Impuesto is not null
	</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>

<!--- Verifica que La cuenta de Inventario Exista --->
<cfif bcheck3>
	<cfquery name="rsCheck4" datasource="#Session.DSN#">
		select count(1) as check4
		from #table_name# a
		where not exists
        (
			select 1
			from IAContables ci
			inner join CContables cc on ci.IACinventario = cc.Ccuenta
            where ci.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
          <!---  and IACcodigogrupo = a.CInventario--->
		    and cc.Cformato =  ltrim(rtrim(a.CInventario))
		)
	</cfquery>
	<cfset bcheck4 = rsCheck4.check4 LT 1>
</cfif>

<!---Verifica Integridad de los datos--->
<cfif bcheck4>
	<cfquery name="rsCheck5" datasource="#Session.DSN#">
		select count(1) as check5
		from #table_name# a
		where exists
        (
			select 1
			from #table_name# b
            where a.Articulo = b.Articulo
            and (a.AltCodigo != b.AltCodigo
				OR a.Unidad != b.Unidad
				OR a.Clasificacion != b.Clasificacion
				OR a.Descripcion != b.Descripcion
				OR a.CBarras != b.CBarras
				OR a.Impuesto != b.Impuesto
				OR a.TipoCosteo != b.TipoCosteo
				OR a.Cert != b.Cert)
		)
	</cfquery>
	<cfset bcheck5 = rsCheck5.check5 LT 1>
</cfif>

<!---Verifica que Solo se asigne una Cuenta de Invantario por articulo-almacen--->
<cfif bcheck5>
	<cfquery name="rsCheck6" datasource="#Session.DSN#">
		select count(1) as check6
		from #table_name# a
		where exists
        (
			select 1
			from #table_name# b
            where a.Articulo = b.Articulo
            and a.Almacen = b.Almacen
            and a.CInventario != b.CInventario
		)
	</cfquery>
	<cfset bcheck6 = rsCheck6.check6 LT 1>
</cfif>

<cfif bcheck6>
    <cfquery name="rsArticulos" datasource="#session.DSN#">
    	 select distinct Articulo, AltCodigo, Unidad, Clasificacion, 
         	Descripcion, CBarras, Impuesto, TipoCosteo, Cert
         from #table_name#
    </cfquery>
	
    <cfif rsArticulos.recordcount GT 0>
    <cfloop query="rsArticulos">
		<!--- Si el Articulo no Existe lo crea --->
	    <cfquery name="rsVerificaA" datasource="#session.DSN#">
    		select 1 
        	from Articulos
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and Acodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Articulo#">
    	</cfquery>

        <cfif rsVerificaA.recordcount EQ 0>
        	<!--- Obtiene el codigo de la Clasificacion --->
	        <cfquery name="rsCcodigo" datasource="#session.DSN#">
				select Ccodigo
        	    from Clasificaciones 
            	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	            and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Clasificacion#">
    	    </cfquery>
            <cfset varCcodigo = rsCcodigo.Ccodigo>
			<!--- Inserta Articulo --->
	        <cfquery datasource="#session.DSN#">
    		insert Articulos (Ecodigo, Acodigo, Acodalterno, Ucodigo,
					Ccodigo, Adescripcion, Afecha, Acodbarras, Icodigo, 
					Atipocosteo, Areqcert, BMUsucodigo)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
            		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Articulo#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.AltCodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Unidad#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#varCcodigo#">, 
         			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Descripcion#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.CBarras#">, 
                     null,
                    <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Impuesto#">, --->
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsArticulos.TipoCosteo#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsArticulos.Cert#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
    		</cfquery>
        </cfif>
    </cfloop>
    </cfif>
	
    <!--- Crea las Existencias para el articulo --->
    <cfquery name="rsArticulos" datasource="#session.DSN#">
    	 select distinct Articulo, Almacen
         from #table_name#
    </cfquery>
	
    <cfif rsArticulos.recordcount GT 0>
    <cfloop query="rsArticulos">
		<!--- Si la Relacion Articulo Almacen no Existe la Crea --->
	    <cfquery name="rsVerificaA" datasource="#session.DSN#">
    		select 1 
        	from Existencias e
            	inner join Articulos a on e.Ecodigo = a.Ecodigo and e.Aid = a.Aid
                inner join Almacen b on e.Ecodigo = b.Ecodigo and e.Alm_Aid = b.Aid
	        where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and a.Acodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Articulo#">
            and b.Almcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Almacen#">
    	</cfquery>
  		
        <cfif rsVerificaA.recordcount EQ 0>
        	<!--- Busca los ID de articulo y de Almacen --->
            <cfquery name="rsAid" datasource="#session.DSN#">
            	select Aid 
                from Articulos 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and Acodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Articulo#">
            </cfquery>
            <cfset varAid = rsAid.Aid>
            
             <cfquery name="rsAid" datasource="#session.DSN#">
            	select Aid 
                from Almacen
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and Almcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Almacen#">
            </cfquery>
            <cfset varAlm_Aid = rsAid.Aid>
            
            <!--- Obtiene los datos para instertar --->
            <cfquery name="rsAlmacen" datasource="#session.DSN#">
		    	select min(CInventario) as CInventario,min(Estante) as Estante, min(Casilla) as Casilla, 
                	min(EMinima) as EMinima, min(EMaxima) as EMaxima
        		from #table_name#
                where Articulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Articulo#">
                and Almacen  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsArticulos.Almacen#">
		    </cfquery>
            <cfquery name="rsIACcodigo" datasource="#session.DSN#">
            	select IACcodigo
                from IAContables ci
				inner join CContables cc on ci.IACinventario = cc.Ccuenta
                where ci.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and cc.Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAlmacen.CInventario#">
            </cfquery>
            <cfset varIACcodigo = rsIACcodigo.IACcodigo>
            
            <!--- Inserta Relacion Existencias --->
            <cfquery datasource="#session.DSN#">
    			insert Existencias (Aid, Alm_Aid, Ecodigo, IACcodigo, Eexistencia,
					Ecostou, Epreciocompra, Ecostototal, Esalidas, 
	                Eestante, Ecasilla, Eexistmin, Eexistmax, BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#varAid#">, 
        	            <cfqueryparam cfsqltype="cf_sql_integer" value="#varAlm_Aid#">,
            	        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
                	    <cfqueryparam cfsqltype="cf_sql_integer" value="#varIACcodigo#">,
                    	0, 
	         			0,
    	                0, 
        	            0, 
            	        0, 
                	    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAlmacen.Estante#">,
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAlmacen.Casilla#">,
	                    <cfqueryparam cfsqltype="cf_sql_float" value="#rsAlmacen.EMinima#">,
    	                <cfqueryparam cfsqltype="cf_sql_float" value="#rsAlmacen.EMaxima#">,
        	            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
    		</cfquery>
        </cfif>
    </cfloop>
    </cfif>

<cfelse>
	<!--- Fallo Check0 --->
	<cfif not bcheck0>
    	<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Unidad no existe: ' as MSG, a.Unidad 
            from #table_name# a
			where not exists (select 1 
				       		from Unidades
					        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    		                and Ucodigo = a.Unidad) 
        </cfquery>

    <!--- Fallo Check1 --->      
	<cfelseif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Clasificación no existe: ' as MSG, a.Clasificacion
			from #table_name# a
			where not exists
		    (
			select 1 
	       	from Clasificaciones
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    	    and Ccodigoclas = a.Clasificacion
		    ) 
		</cfquery>
	
	<!--- Fallo Check2 --->
    <cfelseif not bcheck2>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Almacen no existe: ' as MSG, a.Almacen
			from #table_name# a
			where not exists
            (
            select 1 
        	from Almacen
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    	    and Almcodigo = a.Clasificacion
            )
		</cfquery>
    
	<!--- Fallo Check3 --->    
	<cfelseif not bcheck3>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Impuesto no existe: ' as MSG, a.Impuesto
			from #table_name# a
			where not exists
            (
			select 1
			from Impuestos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and Icodigo = a.Impuesto
			)
		</cfquery>

    <!--- Fallo Check4 --->
    <cfelseif not bcheck4>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Cuenta de Inventario no existe: ' as MSG, a.CInventario
			from #table_name# a
			where not exists
            (
			select 1
			from IAContables
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and IACcodigogrupo = a.CInventario
			)
		</cfquery>    
     
    <!--- Fallo Check5 --->
    <cfelseif not bcheck5>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Error en la integridad de los datos, verifique lineas del articulo: ' as MSG, a.Articulo
			from #table_name# a
			where exists
    	    (
				select 1
				from #table_name# b
	            where a.Articulo = b.Articulo
    	        and (a.AltCodigo != b.AltCodigo
					OR a.Unidad != b.Unidad
					OR a.Clasificacion != b.Clasificacion
					OR a.Descripcion != b.Descripcion
					OR a.CBarras != b.CBarras
					OR a.Impuesto != b.Impuesto
					OR a.TipoCosteo != b.TipoCosteo
					OR a.Cert != b.Cert)
			)
		</cfquery>    
        
	<!--- Fallo Check6 --->
	<cfelse>
		<cfif not bcheck6>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'Solo se puede asignar una Cuneta de inventario al Articulo por Almacen: ' as MSG, a.Articulo, a.Almacen
				from #table_name# a
				where exists
		       	 (
					select 1
					from #table_name# b
        		    where a.Articulo = b.Articulo
		            and a.Almacen = b.Almacen
        		    and a.CInventario != b.CInventario
				 )
			</cfquery>
		</cfif>	
	</cfif>
</cfif>

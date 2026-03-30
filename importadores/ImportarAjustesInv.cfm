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

<!---NUEVO IMPORTADOR AJUSTES DE INVENTARIO
Realizado por Alejandro Bolaños Gómez APPHOSTING 30-05-08 --->

<!---Se realiza lo siguiente: Se verifican los encabezadoz y se realizan las validaciones necesarias --->

<!--- Verifica si el Ajuste ya existe en sistema --->
<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0
	from #table_name# a
	where exists (select 1 
			       	from EAjustes
			        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                    and EAdocumento = a.AJDocumento)
</cfquery>
<cfset bcheck0 = rsCheck0.check0 LT 1>

<!---Verifica que el Almacen exista  --->
<cfif bcheck0>
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists
	    (
			select 1 
        	from Almacen
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    	    and Almcodigo = a.AJAlmacen
	      ) 
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
</cfif>
<!--- Verifica que no haya cantidades ni costos menores a 0--->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2 
        from #table_name# a
        where AJCantidad < 0
        or AJCosto < 0
	</cfquery>
    <cfset bcheck2 = rsCheck2.check2 LT 1>
</cfif>

<!--- Verifica que el Producto exista --->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists
        (
			select 1
			from Articulos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and Acodigo = a.AJProducto
		)
	</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>

<!--- Verifica que el Producto - Almacen esten relacionados --->
<cfif bcheck3>
	<cfquery name="rsCheck4" datasource="#Session.DSN#">
		select count(1) as check4
		from #table_name# a
		where not exists
        (
			select 1
			from Existencias e 
            	inner join Articulos p
                on e.Ecodigo = p.Ecodigo
                and e.Aid = p.Aid
                inner join Almacen m
                on e.Ecodigo = m.Ecodigo
                and e.Alm_Aid = m.Aid
            where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and p.Acodigo = a.AJProducto
            and m.Almcodigo = a.AJAlmacen
		)
	</cfquery>
	<cfset bcheck4 = rsCheck4.check4 LT 1>
</cfif>

<!---Verifica que el documento a Pagar exista y sea de tipo Credito--->
<cfif bcheck4>

    <!--- Se insertan Documentos en Ajuste Inventario --->
    <cfquery datasource="#session.DSN#">
    	insert EAjustes (Ecodigo,Aid,EAdescripcion,EAfecha,EAdocumento,EAusuario)
        select distinct <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
        a.Aid, t.AJDescripcion, t.AJFecha, t.AJDocumento,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
        from #table_name# t, Almacen a
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        and t.AJAlmacen = a.Almcodigo
    </cfquery>

	<!--- Se toman los encabezados para loop --->
	<cfquery name="rsAjuste" datasource="#session.DSN#">
		select distinct AJDocumento
        from #table_name#
	</cfquery>
    <cfif rsAjuste.recordcount GT 0>
    <cfloop query="rsAjuste">
    	<!---Calcula el ID Pago--->
        <cfquery name="rsID" datasource="#session.DSN#">
        	select EAid
            from EAjustes
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and EAdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAjuste.AJDocumento#">
        </cfquery>
        <cfif rsID.recordcount EQ 1>
        	<cfset varID = rsID.EAid>
        </cfif>
        <cfif isdefined("varID")>
        	<cfquery datasource="#session.DSN#">
	        	<!--- Se Insertan registros en DAjustes --->
				insert DAjustes (EAid,Aid,DAcantidad,DAcosto,DAtipo)
        		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#varID#">,
					a.Aid, isnull(t.AJCantidad,0), isnull(t.AJCosto,0),
                    case when t.AJTipo = 'E' then 0 else 1 end
	        	from #table_name# t , Articulos a
	    	    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
    	    	and t.AJProducto = a.Acodigo
    		    and t.AJDocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAjuste.AJDocumento#">
			</cfquery>
        </cfif>
    </cfloop>
	</cfif>
<cfelse>
	<!--- Fallo Check0 --->
	<cfif not bcheck0>
    	<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El Documento de Ajuste ya existe en el Sistema SIF: ' as MSG, a.AJDocumento as Documento, 
            from #table_name# a
			where exists (select 1 
					       	from EAjustes
					        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                		    and EAdocumento = a.AJDocumento) 
        </cfquery>

    <!--- Fallo Check1 --->      
	<cfelseif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Almacen no existe en Sistema SIF: ' as MSG, a.AJAlmacen as Almacen
			from #table_name# a
			where not exists
		    (
				select 1 
        		from Almacen
		        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    		    and Almcodigo = a.AJAlmacen
		    ) 
		</cfquery>
	
	<!--- Fallo Check2 --->
    <cfelseif not bcheck2>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'No puede Haber Cantidades ni Costos Menores a 0: ' as MSG, a.AJDocumento as Documento, a.AJCantidad as Cantidad, a.AJCosto as Costo
			from #table_name# a
			where AJCantidad < 0
	        or AJCosto < 0
			)
		</cfquery>
    
	<!--- Fallo Check3 --->    
	<cfelseif not bcheck3>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Producto No Existe: ' as MSG, a.AJProducto as Producto
			from #table_name# a
			where not exists(
				select 1
				from Articulos
    	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        	    and Acodigo = a.AJProducto
			)
		</cfquery>
	<!--- Fallo Check4 --->
	<cfelse>
		<cfif not bcheck4>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'Producto no Relacionado con el Almacen: ' as MSG, a.AJProducto as Producto, a.AJAlmacen as Almacen
				from #table_name# a
				where not exists
       			 (
						select 1
						from Existencias e 
    			        	inner join Articulos p
			                on e.Ecodigo = p.Ecodigo
            			    and e.Aid = p.Aid
			                inner join Almacen m
			                on e.Ecodigo = m.Ecodigo
            			    and e.Alm_Aid = m.Aid
			            where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            			and p.Acodigo = a.AJProducto
			            and m.Almcodigo = a.AJAlmacen
				)
			</cfquery>
		</cfif>	
	</cfif>
</cfif>

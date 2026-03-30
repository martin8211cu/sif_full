<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery name="rsImportador" datasource="#session.dsn#">
	select * from #table_name#
</cfquery>


<!--- Validar que no existan datos duplicados --->
<cfquery name="rs" datasource="#session.dsn#">
	select count(1) as total
	from #table_name#
	group by Acodigo, Almcodigo
	having count(1) > 1
</cfquery>
<cfif rs.total gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo del articulo aparece repetido para el mismo almacen!')
		</cfquery>
</cfif>	

<cfloop query="rsImportador">
	<!--- Validar si ya existen Codigo Articulo-Almancen registrado en el sistema --->
	<cfquery name="rs" datasource="#session.dsn#">
	 select count(1) as total 
		   from #table_name# a, Articulos b, Almacen c, Existencias d
		   where a.Acodigo = b.Acodigo
			  and b.Ecodigo = #session.Ecodigo#
			  and a.Almcodigo = c.Almcodigo
			  and c.Ecodigo = #session.Ecodigo#
			  and b.Aid = d.Aid
			  and c.Aid = d.Alm_Aid
			  and d.Ecodigo = #session.Ecodigo# 
			  and a.Acodigo='#Acodigo#'
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Existencia de Codigo Articulo-Almacen ya se encuentra registrado en el sistema(#Acodigo#-#Almcodigo#)!')
			</cfquery>
	</cfif>	
		
	<!--- Verificar que exista el codigo del articulo --->
	<cfquery name="rs" datasource="#session.dsn#">
	select count(1) as total  
		from #table_name# a 
		where  a.Acodigo='#Acodigo#'
		and  not exists ( select Acodigo 
						   from Articulos b
						   where  a.Acodigo = b.Acodigo
						   and b.Ecodigo = #session.Ecodigo#)
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Articulo no se encuentra registrado en el sistema(#Acodigo#)!')
			</cfquery>
	</cfif>
		
	<!--- Verificar que exista el Almacen --->
	<cfquery name="rs" datasource="#session.dsn#">
	select count(1) as total
	 from #table_name# a
	 where  a.Acodigo='#Acodigo#'
		and  not exists ( select 1 
				   from Almacen c
				   where  a.Almcodigo = c.Almcodigo
				   and a.Acodigo='#Acodigo#'
				   and c.Ecodigo = #session.Ecodigo#)
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Almacen no se encuentra registrado en el sistema(#Almcodigo#)!')
			</cfquery>
	</cfif>
	  
	<!--- Verificar que existe el grupo --->
	<cfquery name="rs" datasource="#session.dsn#">
	select count(1) as total
	 from #table_name# a
	 where  IACcodigogrupo is not null
	 and a.Acodigo='#Acodigo#'
		and  not exists ( select 1 
				   from  IAContables b
				   where  a.IACcodigogrupo = b.IACcodigogrupo
				   and a.Acodigo='#Acodigo#'
				   and b.Ecodigo = #session.Ecodigo#)
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Grupo no se encuentra registrado en el sistema(#IACcodigogrupo#)!')
			</cfquery>
	</cfif>
</cfloop>	
	<cfquery name="rsErr" datasource="#session.dsn#">
		select count(1) as cantidad from #errores# 
	</cfquery>


<!--- Inserciones --->
<cfif rsErr.cantidad eq 0>
	<cfquery name="rsIn" datasource="#session.dsn#">
          insert into Existencias
		  (Aid, Alm_Aid, Ecodigo, IACcodigo, Eexistencia, Eexistmin, Eexistmax, 
		  Ecostou, Epreciocompra, Ecostototal, Esalidas,BMUsucodigo)
           select  b.Aid, c.Aid, #session.Ecodigo#, d.IACcodigo, Eexistencia, Eexistmin, Eexistmax, Ecostou, 
		   Epreciocompra,Ecostototal,Esalidas,#session.Usucodigo#
                from #table_name# a, Articulos b, Almacen c, IAContables d
                where a.Acodigo = b.Acodigo
                   and a.Almcodigo = c.Almcodigo
                   and a.IACcodigogrupo *= d.IACcodigogrupo
                   and b.Ecodigo = #session.Ecodigo#
                   and c.Ecodigo = #session.Ecodigo#
                   and d.Ecodigo = #session.Ecodigo#
	</cfquery>
<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
		</cfquery>
		<cfreturn>		
</cfif>
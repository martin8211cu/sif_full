<!--- IMPORTANTE --->
<!--- i. Toma la direccion que se genero para la cuenta empresarial (cuenta-empresarial.cfm) --->
<!--- ii. La referencia no se calcula, se toma fijo 28 (empresa modelo en data) --->
<!--- iii. se usa la moneda generada para la cuenta (cuenta-empresarial.cfm) --->
	<cfquery name="empresa" datasource="asp">
		insert INTO  Empresa (CEcodigo, id_direccion, Cid, Mcodigo, Enombre, Etelefono1, Etelefono2, Efax, Ereferencia, Eidentificacion, BMfecha, BMUsucodigo, Elogo)
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta.identity#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.identity#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#cache.Cid#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#moneda.Mcodigo#">,
				 'DATA',
				 '204-7151',
				 null,
				 '204-7155',
				 28,
				 null,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				null )
			   
		<cf_dbidentity1 datasource="asp">
	</cfquery>
	<cf_dbidentity2 datasource="asp" name="empresa">
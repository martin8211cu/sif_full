<cfset sql = Replace(form.EIsqlexp,'"',"'","all")>
<cfquery name="rsExportar" datasource="#session.DSN#" maxrows="1">
	#PreserveSingleQuotes(sql)#
</cfquery>

<!--- borra los parametros existentes --->
<cfquery name="delete_parametros" datasource="sifcontrol">
	delete from DImportador
	where EIid = <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">
	  and DInumero > 0
</cfquery>

<!--- calcula el numero  --->
<cfset numero = 1 >

<cfset metadata = rsExportar.getMetadata() >

<cfset tipo = "varchar" >
<!--- Tipos de Datos --->
<cfset ListInt     = "tinyint,smallint,int,integer,bit" >
<cfset ListNumeric = "numeric" >			
<cfset ListFloat   = "float" >
<cfset ListMoney   = "smallmoney,money" >
<cfset ListDate    = "smalldatetime,datetime" >
<cfset ListVarchar = "char,varchar,nchar,nvarchar" >

<cfloop from="1" to="#rsExportar.getMetaData().getColumnCount()#" index="c">
	<cfoutput>
			<cfif ListFindNoCase(ListInt,rsExportar.getMetaData().getColumnName(javacast("int", c)),',') neq 0 >
				<cfset tipo = 'int'>
			<cfelseif ListFindNoCase(ListNumeric,rsExportar.getMetaData().getColumnName(javacast("int", c)),',') neq 0 >
				<cfset tipo = 'numeric' >
			<cfelseif ListFindNoCase(ListFloat,rsExportar.getMetaData().getColumnName(javacast("int", c)),',') neq 0 >
				<cfset tipo = 'float' >
			<cfelseif ListFindNoCase(ListMoney,rsExportar.getMetaData().getColumnName(javacast("int", c)),',') neq 0 >
				<cfset tipo = 'money' >
			<cfelseif ListFindNoCase(ListDate,rsExportar.getMetaData().getColumnName(javacast("int", c)),',') neq 0 >
				<cfset tipo = 'datetime' >
			<cfelseif ListFindNoCase(ListVarchar,rsExportar.getMetaData().getColumnName(javacast("int", c)),',') neq 0 >
				<cfset tipo = 'varchar' >
			</cfif>

		<!--- insercion de los parametros --->
		<cfquery name="insert_detalle" datasource="sifcontrol">
			insert into DImportador ( EIid, DInumero, DInombre, DIdescripcion, DItipo, DIlongitud )
			values ( <cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">, 
					 <cfqueryparam value="#numero#" cfsqltype="cf_sql_integer">, 
					 <cfqueryparam value="#rsExportar.getMetaData().getColumnName(javacast('int', c))#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#rsExportar.getMetaData().getColumnName(javacast('int', c))#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#tipo#" cfsqltype="cf_sql_char">, 
					 <cfqueryparam value="0" cfsqltype="cf_sql_integer"> 
				   )
		</cfquery>
		
		<cfset numero = numero + 1>
	</cfoutput>
</cfloop>

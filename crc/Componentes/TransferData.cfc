<cfcomponent output="false">

	<cffunction name="Exportar" access="public" returntype="string">
		<cfargument name="tableName" 		required="yes" 				type="string">
		<cfargument name="keyColumnName" 	required="yes" 				type="string">
		<cfargument name="export" 					 					type="query">
		<cfargument name="Ecodigo" 			default="#session.ecodigo#" type="numeric">
		<cfargument name="DSN" 				default="#session.dsn#"		type="string">
		
		<cfif !isDefined('arguments.export')>
			<cfquery name="q_export" datasource="#arguments.DSN#">
				select * from #arguments.tableName# where ecodigo = #arguments.Ecodigo#
			</cfquery>
		<cfelse>
			<cfset q_export = arguments.export>
		</cfif>
			
		<cfset data = StructNew()>
		<cfset data["tableName"] = "#arguments.tableName#">
		<cfset data["keyColumnName"] = "#arguments.keyColumnName#">
		<cfset data["rows"] = []>
		<cfset data["tableInfo"] = []>
		<!--- <cf_dump var="#getMetaData(q_export)#"> --->
		<cfloop query="q_export">
			<cfset temp = StructNew()>
			<cfset tmp = StructNew()>
			<cfloop array='#getMetaData(q_export)#' item="i">
				<cfset temp["#i.name#"] = q_export["#i.name#"]>
				<cfset tmp["#i.name#"] = "#i.typename#">
			</cfloop>
			<cfset ArrayAppend(data["rows"],temp)>
			<cfset ArrayAppend(data["tableInfo"],tmp)>
		</cfloop>
		
		<script language="JavaScript">
			var theJSON = <cfoutput>#SerializeJSON(data)#</cfoutput>;
			theJSON['rows'] = theJSON['rows'][0];
			theJSON['tableInfo'] = theJSON['tableInfo'][0];
			theJSON['columns'] = Object.keys(theJSON.rows);
			download("export_"+theJSON['tableName']+".txt", JSON.stringify(theJSON));
			
			function download(filename, text) {
				text = text.replace(/á/g, 'a');
				text = text.replace(/é/g, 'e');
				text = text.replace(/í/g, 'i');
				text = text.replace(/ó/g, 'o');
				text = text.replace(/ú/g, 'u');
				text = text.replace(/Á/g, 'A');
				text = text.replace(/É/g, 'E');
				text = text.replace(/Í/g, 'I');
				text = text.replace(/Ó/g, 'O');
				text = text.replace(/Ú/g, 'U');
				var element = document.createElement('a');
				element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
				element.setAttribute('download', filename);
				element.style.display = 'none';
				document.body.appendChild(element);
				element.click();
				document.body.removeChild(element);
			}
		</script>
			
	</cffunction>	
	
	<cffunction name="Importar" access="public" returntype="numeric">
		<cfargument name="json"		 		required="yes" 			type="struct">
		<cfargument name="method" 			required="yes" 			type="string">
		<cfscript>
			if( compareTableInfo(arguments.json.tableInfo,arguments.json.tableName) == 1){
				switch(arguments.method){
					case 'update':
						UpdateRowCatalogo(arguments.json);
					break;
					case 'add':
						InsertRowCatalogo(arguments.json);
					break;
					case 'full':
						UpdateRowCatalogo(arguments.json);
						InsertRowCatalogo(arguments.json);
					break;
					case 'replace':
						DeleteRowCatalogo(arguments.json);
					break;	
				}
			}
		</cfscript>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="DeleteRowCatalogo" access="public" returntype="string">
		<cfargument name="json"	required="yes" 		type="struct">
		
		<cftransaction>
			<cfquery name="q_delete" datasource="#session.DSN#">
				delete from #arguments.json.tableName#;
			</cfquery>
			<cftry>
				<cfinvoke component="TransferData" method="InsertRowCatalogo" json="#arguments.json#">
			<cfcatch>
				<cftransaction action = "rollback"/>
				<cfthrow message="#cfcatch.message#">
			</cfcatch>
			</cftry>
		</cftransaction>
		
	</cffunction>
	
	<cffunction name="InsertRowCatalogo" access="public" returntype="string" returnformat="plain">
		<cfargument name="json"		 		required="yes" 			type="struct">
		<cfset blockStatements = "">
		<cfloop index="j" from="1" to="#ArrayLen(arguments.json.rows[arguments.json.columns[1]])#">	
			<cfset var1 = arguments.json.tableName>
			<cfset var2 = arguments.json.keyColumnName>
			<cfset var3 = arguments.json.rows[arguments.json.keyColumnName][j]>
			<cfset var4 = arguments.json.tableInfo[arguments.json.keyColumnName]>
			<cfif validateRow(var1,var2,var3,var4) eq 0>
				<cfscript>
					statement = "insert into " & arguments.json.tableName &" ("&ArrayToList(arguments.json.columns)&") values (";
					for (i=1;i LTE ArrayLen(arguments.json.columns);i=i+1) {
						value = transformValue(arguments.json.rows[arguments.json.columns[i]][j],arguments.json.tableInfo[arguments.json.columns[i]]);
						if(Find('identity',arguments.json.tableInfo[arguments.json.columns[i]],0)){
							statement = Replace(statement, ","&arguments.json.columns[i], "" , "all");
						}else{
							if(CompareNoCase(arguments.json.columns[i], 'ecodigo')  == 0){ 
								value = session.ecodigo;
							}
							statement = statement & value & ",";
						}
					}
					statement = statement & ");";
					statement = Replace(statement, ",);", ");" , "all");
					blockStatements = blockStatements & statement;
				</cfscript>
			</cfif>
		</cfloop>
		<cfif blockStatements neq "">
			<cftry>
				<cfquery name="q_query" datasource="#session.DSN#">
					#preserveSingleQuotes(blockStatements)#
				</cfquery>
			<cfcatch>
				<cfthrow   message = "Falla al ejecutar el query: [#cfcatch.message#]" >
			</cfcatch>
			</cftry>
		</cfif>
	</cffunction>
		
	<cffunction name="UpdateRowCatalogo" access="public" returntype="string">
		<cfargument name="json"		 		required="yes" 			type="struct">
		<cfset blockStatements = "">
		<cfloop index="j" from="1" to="#ArrayLen(arguments.json.rows[arguments.json.columns[1]])#">	
			<cfset var1 = arguments.json.tableName>
			<cfset var2 = arguments.json.keyColumnName>
			<cfset var3 = arguments.json.rows[arguments.json.keyColumnName][j]>
			<cfset var4 = arguments.json.tableInfo[arguments.json.keyColumnName]>
			<cfif validateRow(var1,var2,var3,var4) eq 1>
				<cfscript>
					statement = "update " & arguments.json.tableName &" set ";
					for (i=1;i LTE ArrayLen(arguments.json.columns);i=i+1) {
						value = transformValue(arguments.json.rows[arguments.json.columns[i]][j],arguments.json.tableInfo[arguments.json.columns[i]]);
						
						if(Find('identity',arguments.json.tableInfo[arguments.json.columns[i]],0)){
						}else{
							if(CompareNoCase(arguments.json.columns[i], 'ecodigo')  == 0){ 
								value = session.ecodigo;
							}
							statement = statement & arguments.json.columns[i] &" = "& value & ", ";
						}
					}
					value = transformValue(arguments.json.rows[arguments.json.keyColumnName][j],arguments.json.tableInfo[arguments.json.keyColumnName]);
					statement = statement & "where " & arguments.json.keyColumnName & " = " & value;
					statement = Replace(statement, ", where", " where" , "all");
					blockStatements = blockStatements & statement;
				</cfscript>
			</cfif>
		</cfloop>
		<cfif blockStatements neq "">
			<cftry>
				<cfquery name="q_query" datasource="#session.DSN#">
					#preserveSingleQuotes(blockStatements)#
				</cfquery>
			<cfcatch>
				<cfthrow  message = "Falla al ejecutar el query: [#cfcatch.message#]" >
			</cfcatch>
			</cftry>
		</cfif>
	</cffunction>

	<cffunction  name="ReplaceCharacters" returntype="string">
		<cfargument name="queryString"		required="yes" 		type="string">
		<cfset qString = arguments.queryString>
		<cfset qString = Replace(qString,'á','a','ALL')>
		<cfset qString = Replace(qString,'é','e','ALL')>
		<cfset qString = Replace(qString,'í','i','ALL')>
		<cfset qString = Replace(qString,'ó','o','ALL')>
		<cfset qString = Replace(qString,'ú','u','ALL')>
		<cfset qString = Replace(qString,'ä','a','ALL')>
		<cfset qString = Replace(qString,'ë','e','ALL')>
		<cfset qString = Replace(qString,'ï','i','ALL')>
		<cfset qString = Replace(qString,'ö','o','ALL')>
		<cfset qString = Replace(qString,'ü','u','ALL')>
		<cfset qString = Replace(qString,'Á','A','ALL')>
		<cfset qString = Replace(qString,'É','E','ALL')>
		<cfset qString = Replace(qString,'Í','I','ALL')>
		<cfset qString = Replace(qString,'Ó','O','ALL')>
		<cfset qString = Replace(qString,'Ú','U','ALL')>
		<cfset qString = Replace(qString,'Ä','A','ALL')>
		<cfset qString = Replace(qString,'Ë','E','ALL')>
		<cfset qString = Replace(qString,'Ï','I','ALL')>
		<cfset qString = Replace(qString,'Ö','O','ALL')>
		<cfset qString = Replace(qString,'Ü','U','ALL')>
		<cfreturn qString>
	</cffunction>
	
	<cffunction name="transformValue" access="public" returntype="string">
		<cfargument name="value"		required="yes" 		type="string">
		<cfargument name="sql_type"		required="yes" 		type="string">
		<cfscript>
			if(value == ""){ 
				value = 'null'; 
			}
			if(value != 'null'){
				switch(sql_type){
					case "varchar": value = "'" & Replace(value,"'","''",'all') & "'"; break;
					case "char": value = "'" & value & "'"; break;
					case "datetime": value = "'" & value & "'"; break;
					case "numeric": value = value; break;
					default : value = value; break;
				}
			}
		</cfscript>
		<cfreturn value>
	</cffunction>
	
	<cffunction name="validateRow" access="public" returntype="numeric">
		<cfargument name="tableName"		required="yes" 		type="string">
		<cfargument name="keyColumnName"	required="yes" 		type="string">
		<cfargument name="columnVal"		required="yes" 		type="string">
		<cfargument name="datatype"			required="yes" 		type="string">

		<cfquery name="q_unique" datasource="#session.DSN#">
			select id from #arguments.tableName# where #arguments.keyColumnName# = #transformValue(arguments.columnVal,arguments.datatype)#
		</cfquery>
		
		<cfreturn q_unique.recordcount>
	</cffunction>
	
	<cffunction name="compareTableInfo" access="public" returntype="numeric">
		<cfargument name="originInfo"		required="yes" 		type="struct">
		<cfargument name="tableName"		required="yes" 		type="string">
		<cftry>
			<cfquery name="q_table" datasource="#session.DSN#">
				select top 1 * from #arguments.tableName#;
			</cfquery>
		<cfcatch>
			<cfif cfcatch.Type eq 'Database'>
				<cfif cfcatch.ErrorCode eq '42S02'>
					<cfthrow   message = "La tabla de destino no existe. No se puede cargar el archivo." >
				</cfif>
			</cfif>
		</cfcatch>
		</cftry>
		<cfset destinyInfo = StructNew()>
		<cfloop array='#getMetaData(q_table)#' item="i">
			<cfset destinyInfo["#i.name#"] = "#i.typename#">
		</cfloop>
		
		<cfif StructCount(arguments.originInfo) eq StructCount(destinyInfo)>
			<cfset colCount = StructCount(destinyInfo)>
			<cfloop collection = #destinyInfo# item = "i">
				<cfif isdefined('arguments.originInfo.#i#')>
					<cfif arguments.originInfo[i] eq destinyInfo[i]>
						<cfset colCount = colCount - 1>
					</cfif>
				</cfif>
			</cfloop>
			<cfif colCount eq 0>
				<!---<cfdump var="#arguments.originInfo#">
				<cfdump var="#destinyInfo#" abort> --->
				<cfreturn 1>
			</cfif>
		</cfif>
		<cfthrow   message="La tabla de Origen y Destino no poseen los mismos campos. No se puede importar el archivo" >
		<cfreturn 0>
	</cffunction>
	
</cfcomponent>
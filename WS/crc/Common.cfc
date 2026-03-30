<cfcomponent displayname="Catalogos" rest="true" restPath="/commons" >

    <cfset dsn     = "minisif">
	<cfset ecodigo = 2>
	
	<cffunction name="getTiendasExternas"
                access="remote"
                httpmethod="GET"
                restpath="/tiendas_externas"
                returntype="any"
                produces="application/json">
                    
        <cfset crcCommons = createObject("component","crc.Componentes.common.CRCCommons")> 
		<cfset result = crcCommons.getTiendasExternas(dsn,ecodigo)>
		<cfreturn result>
    </cffunction>

	<cffunction name="QueryToArray" access="public" returntype="array" output="false"
    hint="This turns a query into an array of structures.">

    <!--- Define arguments. --->
    <cfargument name="Data" type="query" required="yes" />

    <cfscript>
        // Define the local scope.
        var LOCAL = StructNew();
        // Get the column names as an array.
        LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );
        // Create an array that will hold the query equivalent.
        LOCAL.QueryArray = ArrayNew( 1 );
        // Loop over the query.
        for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
            // Create a row structure.
            LOCAL.Row = StructNew();
            // Loop over the columns in this row.
            for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
                // Get a reference to the query column.
                LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
                // Store the query cell value into the struct by key.
                LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
            }
            // Add the structure to the query array.
            ArrayAppend( LOCAL.QueryArray, LOCAL.Row );
        }
        // Return the array equivalent.
        return( LOCAL.QueryArray );
    </cfscript>
</cffunction>

</cfcomponent>
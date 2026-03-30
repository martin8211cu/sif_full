<cfcomponent output="true">
    <cfset listNumber = "CF_SQL_BIGIN,CF_SQL_BIT,CF_SQL_DECIMAL,CF_SQL_DOUBLE,CF_SQL_FLOAT,CF_SQL_IDSTAMP,CF_SQL_INTEGER," &
                        "CF_SQL_MONEY,CF_SQL_MONEY4,CF_SQL_NUMERIC,CF_SQL_REAL,CF_SQL_SMALLINT,CF_SQL_TINYINT">
    <cfset listString = "CF_SQL_CHAR, CF_SQL_LONGNVARCHAR,CF_SQL_LONGVARCHAR,CF_SQL_NCHAR,CF_SQL_NVARCHAR,CF_SQL_VARCHAR">
    <cfset listDateTime = "CF_SQL_DATE,CF_SQL_TIME,CF_SQL_TIMESTAMP">
    <cfset listOthers = "CF_SQL_BLOB,CF_SQL_CLOB,CF_SQL_REFCURSOR,CF_SQL_SQLXML">
    
    <cffunction name="CFDIToStruct" access="public" returntype="struct" output="true"
            hint="Parse raw XML response body into ColdFusion structs and arrays and return it.">
        <cfargument name="xmlNode" type="string" required="true" />
        <cfargument name="str" type="struct" required="true" />
       
        <!---Setup local variables for recurse: --->
        <cfset var i = 0 />
        <cfset var axml = arguments.xmlNode />
        <cfset var astr = arguments.str />
        <cfset var n = "" />
        <cfset var tmpContainer = "" />
        <cfset myxmldoc = XmlParse(this.cleanText(arguments.xmlNode)) >
        <cfset axml = xmlSearch(myXMLDoc,"//*[local-name()='Comprobante' and namespace-uri()='http://www.sat.gob.mx/cfd/3']") />
        <cfset axml = axml[1] />
        
        <cfset _name = replace(axml.XmlName, axml.XmlNsPrefix&":", "") />

        <cfif IsStruct(aXml.XmlAttributes) AND StructCount(aXml.XmlAttributes)>
            <cfset at_list = StructKeyList(aXml.XmlAttributes)>
            <cfloop from="1" to="#listLen(at_list)#" index="atr">
                <cfif ListgetAt(at_list,atr) CONTAINS "xmlns:">
                    <!--- remove any namespace attributes--->
                    <cfset Structdelete(axml.XmlAttributes, listgetAt(at_list,atr))>
                </cfif>
            </cfloop>
            <!--- if there are any atributes left, append them to the response--->
            <cfif StructCount(axml.XmlAttributes) GT 0>
                <cfset astr[_name]['Atributos'] = axml.XmlAttributes />
            </cfif>
        </cfif>

        <cfif arrayLen(axml.XmlChildren) gt 0>
            <!--- For each children of context node: --->
            <cfloop from="1" to="#arrayLen(axml.XmlChildren)#" index="i">
                <cfset _node = structNew()>
                <!--- Read XML node name without namespace: --->
                <cfset n = replace(axml.XmlChildren[i].XmlName, axml.XmlChildren[i].XmlNsPrefix&":", "") />
                <!--- If key with that name exists within output struct ... --->
                <cfif IsStruct(aXml.XmlChildren[i].XmlAttributes) AND StructCount(aXml.XmlChildren[i].XmlAttributes)>
                    <cfset at_list = StructKeyList(aXml.XmlChildren[i].XmlAttributes)>
                    <cfloop from="1" to="#listLen(at_list)#" index="atr">
                        <cfif ListgetAt(at_list,atr) CONTAINS "xmlns:">
                            <!--- remove any namespace attributes--->
                            <cfset Structdelete(axml.XmlChildren[i].XmlAttributes, listgetAt(at_list,atr))>
                        </cfif>
                    </cfloop>
                    <!--- if there are any atributes left, append them to the response--->
                    <cfif StructCount(axml.XmlChildren[i].XmlAttributes) GT 0>
                        <cfset _node['Atributos'] = axml.XmlChildren[i].XmlAttributes />
                        
                        <cfif n eq "Impuestos">
                            <cfset impT = axml.XmlChildren[i]>
                            <cfloop from="1" to="#arrayLen(impT.XmlChildren)#" index="j">
                                <cfset aImp = arrayNew(1)>
                                <cfset _nodeI = structNew()>
                                <!--- Read XML node name without namespace: --->
                                <cfset impn = replace(impT.XmlChildren[j].XmlName, impT.XmlChildren[j].XmlNsPrefix&":", "") />
                                
                                <cfset impuestos = impT.XmlChildren[j]>
                                <cfloop from="1" to="#arrayLen(impuestos.XmlChildren)#" index="k">
                                    <cfset tipoI = StructNew()>
                                    <!--- Read XML node name without namespace: --->
                                    <cfset tn = replace(impuestos.XmlChildren[k].XmlName, impuestos.XmlChildren[k].XmlNsPrefix&":", "") />
                                    <cfset  impTipo = impuestos.XmlChildren[k]>

                                    <cfif IsStruct(impTipo.XmlAttributes) AND StructCount(impTipo.XmlAttributes)>
                                        <cfset impna = replace(impTipo.XmlName, impTipo.XmlNsPrefix&":", "") />
                                        <cfset at_list = StructKeyList(impTipo.XmlAttributes)>
                                        <cfloop from="1" to="#listLen(at_list)#" index="atr">
                                            <cfif ListgetAt(at_list,atr) CONTAINS "xmlns:">
                                                <!--- remove any namespace attributes--->
                                                <cfset Structdelete(impTipo.XmlAttributes, listgetAt(at_list,atr))>
                                            </cfif>
                                        </cfloop>
                                        <!--- if there are any atributes left, append them to the response--->
                                        <cfif StructCount(impTipo.XmlAttributes) GT 0>
                                            <cfset tipoI['Atributos'] = impTipo.XmlAttributes />
                                            
                                        </cfif>
                                    </cfif>
                                    <cfset arrayAppend(aImp, tipoI)>
                                </cfloop>
                                <cfset _node[impn] = aImp>
                            </cfloop>
                        </cfif>
                    </cfif>
                    <cfset astr[_name][n] = _node>
                </cfif>


            </cfloop>
        </cfif>

        <cfset oxml = xmlSearch(myXMLDoc,"//*[local-name()='TimbreFiscalDigital' and namespace-uri()='http://www.sat.gob.mx/TimbreFiscalDigital']") />
        <cfset oxml = oxml[1]>
        <cfif IsStruct(oxml.XmlAttributes) AND StructCount(oxml.XmlAttributes)>
            <cfset _node = structNew()>
            <cfset n = replace(oxml.XmlName, oxml.XmlNsPrefix&":", "") />
            <cfset at_list = StructKeyList(oxml.XmlAttributes)>
            <cfloop from="1" to="#listLen(at_list)#" index="atr">
                <cfif ListgetAt(at_list,atr) CONTAINS "xmlns:">
                    <!--- remove any namespace attributes--->
                    <cfset Structdelete(oxml.XmlAttributes, listgetAt(at_list,atr))>
                </cfif>
            </cfloop>
            <!--- if there are any atributes left, append them to the response--->
            <cfif StructCount(oxml.XmlAttributes) GT 0>
                <cfset _node['Atributos'] = oxml.XmlAttributes />
                <cfset astr[n] = _node>
            </cfif>
        </cfif>

        <cfset cxml = xmlSearch(myXMLDoc,"//*[local-name()='Concepto' and namespace-uri()='http://www.sat.gob.mx/cfd/3']") />
        <cfset arrConcepto = ArrayNew(1)>
        <cfloop from="1" to="#arrayLen(cxml)#" index="i">
            <cfset _cxml = cxml[i]>
            <cfset _concepto = StructNew()>
            <cfset _n = replace(_cxml.XmlName, _cxml.XmlNsPrefix&":", "") />
            <cfif IsStruct(_cXml.XmlAttributes) AND StructCount(_cXml.XmlAttributes)>
                <cfset at_list = StructKeyList(_cXml.XmlAttributes)>
                <cfloop from="1" to="#listLen(at_list)#" index="atr">
                    <cfif ListgetAt(at_list,atr) CONTAINS "xmlns:">
                        <!--- remove any namespace attributes--->
                        <cfset Structdelete(_cxml.XmlAttributes, listgetAt(at_list,atr))>
                    </cfif>
                </cfloop>
                <!--- if there are any atributes left, append them to the response--->
                <cfif StructCount(_cxml.XmlAttributes) GT 0>
                    <cfset _concepto[_n]['Atributos'] = _cxml.XmlAttributes />
                </cfif>
                
                <cfif arrayLen(_cxml.XmlChildren) gt 0>
                    <!--- For each children of context node: --->
                    <cfloop from="1" to="#arrayLen(_cxml.XmlChildren)#" index="j">
                        <cfset _node = structNew()>
                        <!--- Read XML node name without namespace: --->
                        <cfset n = replace(_cxml.XmlChildren[j].XmlName, _cxml.XmlChildren[j].XmlNsPrefix&":", "") />
                        <cfset _concepto[_n][n] = _node>
                        <cfset impuestos = _cxml.XmlChildren[j]>

                        <cfloop from="1" to="#arrayLen(impuestos.XmlChildren)#" index="k">
                            <cfset tipoI = ArrayNew(1)>
                            <!--- Read XML node name without namespace: --->
                            <cfset tn = replace(impuestos.XmlChildren[k].XmlName, impuestos.XmlChildren[k].XmlNsPrefix&":", "") />
                            
                            <cfset  impTipo = impuestos.XmlChildren[k]>
                            
                            <cfloop from="1" to="#arrayLen(impTipo.XmlChildren)#" index="l">
                                <cfset impuesto = structNew()>
                                <!--- Read XML node name without namespace: --->
                                <cfset in = replace(impTipo.XmlChildren[l].XmlName, impTipo.XmlChildren[l].XmlNsPrefix&":", "") />    
                                <cfif StructCount(impTipo.XmlChildren[l].XmlAttributes) GT 0>
                                    <cfset arrayAppend(tipoI, impTipo.XmlChildren[l].XmlAttributes)>
                                </cfif>
                            </cfloop>
                            <cfset _concepto[_n][n][tn] = tipoI>
                        </cfloop>
                    </cfloop>
                </cfif>
                <cfset arrayAppend(arrConcepto, _concepto)>
            </cfif>
        </cfloop>
        <cfset astr[_name]['Conceptos'] = arrConcepto>
        <cfreturn astr />
    </cffunction>
    
    
    <cffunction  name="TableToStruct" output="false">
        <cfargument name="table" type="string" required="true" />
        <cfargument name="includeDefinition" type="boolean" required="false" default="false" />
        <cfargument name="dsn" type="string" required="false"  default="ldcom"/>
        <cfargument name="sgbd" type="string" required="false" default="MSSQL" />

        <cfset db = createObject("component","home.Componentes.datamgr.DataMgr").init(arguments.dsn,arguments.sgbd)>
        <cfset _table = db.getDBTableStruct("Factura_Fiscal_Encabezado")>

        <cfset str = structNew()>
        <cfset _default = "">

        <cfloop array="#_table#" item="field">
            <cfif not field["Increment"]>
                <cfif listContains(listNumber,field["CF_DataType"])>
                    <cfset _default = 0>                
                <cfelseif listContains(listString,field["CF_DataType"])>
                    <cfset _default = "">                
                <cfelseif listContains(listDateTime,field["CF_DataType"])>
                    <cfset _default = DateFormat(now(),"yyyy-mm-dd hh:mm:ss")>
                </cfif>
                <cfset str[field["ColumnName"]] = _default>
            </cfif>
        </cfloop>

        <cfif arguments.includeDefinition>
            <cfset str["_definition"] = _table>
        </cfif>

        <cfreturn str>
    </cffunction>

    <cffunction name="cleanText" output="false" returnType="string">
        <cfargument name="str" default="">
        <cfargument name="spacer" default="-">

        <cfset var ret = arguments.str>
        <!--- <cfset ret = replace(arguments.str,"'", "", "all")> --->
        <!--- <cfset ret = replace(arguments.str,"/", "", "all")>
        <cfset ret = trim(ReReplaceNoCase(ret, "<[^>]*>", "", "ALL"))> --->
        <cfset ret = ReplaceList(ret, "À,Á,Â,Ã,Ä,Å,Æ,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,Ø,Ù,Ú,Û,Ü,Ý,à,á,â,ã,ä,å,æ,è,é,ê,ë,ì,í,î,ï,Ñ,ñ,ò,ó,ô,õ,ö,ø,ù,ú,û,ü,ý,&nbsp;,&amp;", "A,A,A,A,A,A,AE,E,E,E,E,I,I,I,I,D,N,O,O,O,O,O,0,U,U,U,U,Y,a,a,a,a,a,a,ae,e,e,e,e,i,i,i,i,N,n,o,o,o,o,o,0,u,u,u,u,y, , ")>
        <!--- <cfset ret = trim(rereplace(ret, "[[:punct:]]"," ","all"))> --->
        <!--- <cfset ret = rereplace(ret, "[[:space:]]+","!","all")> --->
        <!--- <cfset ret = ReReplace(ret, "[^a-zA-Z0-9!]", " ", "ALL")> --->
        <!--- <cfset ret = trim(rereplace(ret, "!+", arguments.Spacer, "all"))> --->
        <cfreturn ret>
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
<cfsilent>
<cfparam name="form.table" default="">
<cfparam name="form.sColumns" default="">
<cfparam name="form.editButtonText" default="">
<cfparam name="form.editButtonTarget" default="">
<cfparam name="form.sSearch" default="">
<cfparam name="variables.fieldlist" default="">


<cfsetting showDebugOutput=false>
<cfsetting enablecfoutputonly="true">
<cfprocessingdirective suppresswhitespace="true">

<!--- Variables que vienen desde la tabla --->
<cfset variables.fieldlist=form.sColumns>
<cfset variables.count=0>
<cfset filtro = form['search[value]']>
<cfset query = form.Query>
<cfset columnas = form.Columnas>

<cfif isDefined('form.columnasAFiltrar')>
    <cfset columnasAFiltrarArray = listToArray("#form.columnasAFiltrar#", "," )>
<cfelse>
    <cfset columnasAFiltrarArray = ArrayNew(0)>
</cfif>

<cfif isDefined('form.tipoColumnasAFiltrar')>
    <cfset tipoColumnasAFiltrarArray = listToArray("#form.tipoColumnasAFiltrar#", "," )>
<cfelse>
    <cfset tipoColumnasAFiltrarArray = ArrayNew(0)>
</cfif>

<cfset columnasArray = listToArray("#columnas#", "," )>


<cfquery name ="rsDatosConsulta" datasource="#session.dsn#">
    #PreserveSingleQuotes(query)#
</cfquery>


<cfsavecontent variable="filtroConlis">
    <cfoutput >(1=1)</cfoutput>
      <cfif ArrayLen(ColumnasAFiltrarArray) GT 0>
        <cfoutput> and ( </cfoutput>
        <cfloop from="1" to="#ArrayLen(ColumnasAFiltrarArray)#" index="indiceFiltroConlis" >
          <cfoutput>  UPPER(#ColumnasAFiltrarArray[indiceFiltroConlis]#) Like </cfoutput>  
              <cf_jdbcquery_param cfsqltype='cf_sql_#tipoColumnasAFiltrarArray[indiceFiltroConlis]#' value='%#UCASE(filtro)#%'>
           <cfoutput> or </cfoutput>
         
        </cfloop>
        <cfoutput> (1=2)) </cfoutput>
        
      </cfif>
</cfsavecontent>



<cfquery dbtype="query" name="rsDatosConsulta">
    select * from rsDatosConsulta where #preserveSingleQuotes(filtroConlis)#

</cfquery>

<cfset totalRegistros = rsDatosConsulta.recordcount>

<!--- Crear respuesta JSON --->
<cfsavecontent variable="variables.sOutput"><cfoutput>{
    
    "start": #form.start#,
    "start": #form.start#,
    "iTotalRecords": #totalRegistros#,
    "iTotalDisplayRecords": #rsDatosConsulta.recordcount#,
    "data" : [
        <cfloop query="rsDatosConsulta" startrow="#form.start+1#" endrow="#form.start+form.length#">
             <cfset variables.count=variables.count+1>
        { 
            <cfloop from="1" to="#ArrayLen(columnasArray)#" index="i">
                "#trim(columnasArray[i])#" : "#Evaluate("rsDatosConsulta.#trim(columnasArray[i])#")#"<cfif i NEQ ArrayLen(columnasArray)>, </cfif>
                
            </cfloop>
        }   

        <cfif rsDatosConsulta.recordcount LT form.start+form.length>
            <cfif variables.count is not rsDatosConsulta.recordcount-form.start>,</cfif>
        <cfelse>
            <cfif variables.count LT form.length>,</cfif>
        </cfif>
        </cfloop>

    ]
    

}</cfoutput></cfsavecontent>

</cfprocessingdirective>
</cfsilent>
<cfoutput>#variables.sOutput#</cfoutput>
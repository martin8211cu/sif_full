<cfif ThisTag.ExecutionMode is 'start'>
    <cfparam name="Attributes.width"  		    default=""><!---Ancho del lightBox, esta dada en porcentaje, maximo valor 100--->
    <cfparam name="Attributes.height" 		    default=""><!---Alto del lightBox, esta dada en porcentaje, maximo valor 100--->
    <cfparam name="Attributes.index"          default="">
    <cfparam name="Attributes.name"           default="inputTagsDefault">
    <cfparam name="Attributes.query"          default="#queryNew('id')#">
    <cfparam name="Attributes.queryID"        default="id">
    <cfparam name="Attributes.queryText"      default="text">
    <cfparam name="Attributes.queryDefault"   default="#queryNew('id')#">
    <cfparam name="Attributes.importLibs" 	  default="true" />
    <cfparam name="Attributes.cfinputOn"      default="false" />
    <cfparam name="Attributes.cfinputRequired"     default="false" />
</cfif>

<cfif ThisTag.ExecutionMode is 'end'>
	<cfset ThisTag.Contenido        = ThisTag.GeneratedContent/>
    <cfset ThisTag.GeneratedContent = "" />
    <cfif Attributes.importLibs>
      <cf_importLibs/>    
    </cfif>
    <cfoutput>
    <script type="text/javascript" src="/cfmx/jquery/librerias/jquery.tokeninput.js"></script>

    <link rel="stylesheet" href="/cfmx/jquery/estilos/token-input.css" type="text/css" />

    <cfif attributes.cfinputOn>
      <cfinput type="text" id="#Attributes.name#" name="#Attributes.name#" required="#attributes.cfinputRequired#">
    <cfelse>
      <input type="text" id="#Attributes.name#" name="#Attributes.name#">  
    </cfif>
    
 
    <script type="text/javascript">
        $(document).ready(function() {
            $("###Attributes.name#").tokenInput(

            <cfif attributes.query.recordcount>
              [
                <cfloop query="attributes.query">
                  {id: '#evaluate("attributes.query."&Attributes.queryID)#', name: "#evaluate('attributes.query.'&Attributes.queryText)#"}
                  <cfif currentrow neq recordcount>
                    ,
                  </cfif>
                </cfloop>
              ] 
            </cfif>
            ,{
           
              prePopulate:[ 
              <cfif attributes.queryDefault.recordcount>
                <cfloop query="attributes.queryDefault">
                  {id: '#evaluate("attributes.queryDefault."&Attributes.queryID)#', name: "#evaluate('attributes.queryDefault.'&Attributes.queryText)#"}<cfif currentrow neq recordcount>,</cfif>
                </cfloop>
              </cfif>  
              ] 
            ,hintText: "Digite la opción a buscar"
            ,noResultsText: "No existen registros que mostrar"
            ,searchingText: "Buscando..."
            ,preventDuplicates: true
          }
          );
        });
    </script>
    </cfoutput>
</cfif>
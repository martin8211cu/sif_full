<cfif ThisTag.ExecutionMode is 'start'>
    <cfparam name="Attributes.width"  		  default=""><!---Ancho del lightBox, esta dada en porcentaje, maximo valor 100--->
    <cfparam name="Attributes.height" 		  default=""><!---Alto del lightBox, esta dada en porcentaje, maximo valor 100--->
    <cfparam name="Attributes.url"       	  default=""> 
	<cfparam name="Attributes.title"       	  default=""> 
    <cfparam name="Attributes.Params"         default="">  
	<cfparam name="Attributes.Botones"    	  default="">  
    <cfparam name="Attributes.Funciones"      default="PopUpCerrar">
    <cfparam name="Attributes.index"          default="">
    <cfparam name="Attributes.ShowButtons" 	  default="" /> <!--- Si el valor es false, no se agregan los botones, en cualquier otro caso si se agregan --->
    <cfparam name="Attributes.BlockModal" 	  default="" />
    <cfparam name="Attributes.importLibs" 	  default="true" />
	<cfparam name="Attributes.delimiters" 	  default="," />
</cfif>

<cfif ThisTag.ExecutionMode is 'end'>
	<cfset ThisTag.Contenido        = ThisTag.GeneratedContent/>
    <cfset ThisTag.GeneratedContent = "" />
    
    <cfset Paramstemp = Attributes.Params>
    <cfset Params     = StructNew()>
    <cfif Attributes.importLibs>
      <cf_importLibs/>    
    </cfif>
    <cfloop list="#Paramstemp#" delimiters="#Attributes.delimiters#" index="Variable">
    	<cfif ListLen(Variable) EQ 1>
        	<cfset StructInsert(Params, ListGetAT(Variable,1,'='), '')>
        <cfelse>
    		<cfset StructInsert(Params, ListGetAT(Variable,1,'='), ListGetAT(Variable,2,'='))>
        </cfif>
    </cfloop>
    <cfset Attributes.Params = Params>
    <cfif not len(trim(attributes.Botones)) and not len(trim(attributes.ShowButtons))>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cerrar" xmlFile="/rh/generales.xml" default="Cerrar" returnvariable="LvarCerrar">
        <cfset attributes.Botones = LvarCerrar>
    </cfif>

<!-- Modal -->
  <div class="modal fade" id="myModal<cfoutput>#Attributes.index#</cfoutput>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" <cfif len(trim(attributes.BlockModal))>data-backdrop="static" data-keyboard="false"</cfif>>
    <div class="modal-dialog" style='
    <cfif isdefined("attributes.height") and len(trim(attributes.height))> <cfoutput> height:#Attributes.height#%; </cfoutput> </cfif>
     <cfif isdefined("attributes.width") and len(trim(attributes.width))> <cfoutput> width:#Attributes.width#%;</cfoutput> </cfif>'>
      <div class="modal-content">
          <!----- head---->
          <div class="modal-header">
            <cfif not len(trim(attributes.BlockModal))><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button></cfif>
            <h4 class="modal-title" id="myModalLabel"><cfoutput>#Attributes.title#</cfoutput></h4>
          </div>
        <!---- body----->
          <div class="modal-body" id="contenidoConfirm<cfoutput>#Attributes.index#</cfoutput>">
          <cfif LEN(TRIM(Attributes.url))>
            <cfinclude template="#Attributes.url#">
            <cfelse>
              <cfoutput>#ThisTag.Contenido#</cfoutput>
            </cfif>
          </div>
          <!----- FOOTER--->
              <div class="modal-footer">
                <cfif Attributes.ShowButtons NEQ 'false'>
                  <cfloop list="#Attributes.Botones#" index="ItemBoton">
                    <cfif ItemBoton EQ 'Cerrar' or ( listlen(Attributes.Botones) eq listFind(Attributes.Botones, ItemBoton))>
                      <button type="button" class="btn btn-default" data-dismiss="modal" onclick="<cfoutput>if(typeof fn#ItemBoton# == 'function') fn#ItemBoton#();</cfoutput>"/>
                    <cfelse>
                      <cfset pos = listFind(Attributes.Botones, ItemBoton)>
                      <cfset LvarFuncion = listGetAt(Attributes.Funciones, pos)>
                      <button type="button" class="btn btn-primary" onclick="<cfoutput><cfif LEN(TRIM(LvarFuncion))>if(typeof #LvarFuncion# == 'function') #LvarFuncion#();<cfelse>if(typeof fn#ItemBoton# == 'function') fn#ItemBoton#();</cfif></cfoutput>"/>
                    </cfif>
                    <cfoutput>#ItemBoton#</cfoutput>
                    </button>
                  </cfloop>
                </cfif>
              </div>
          <!---- fin footer--->    
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->

	
	<script language="javascript" type="text/javascript">
        function PopUpAbrir<cfoutput>#Attributes.index#</cfoutput>(){
         $('#myModal<cfoutput>#Attributes.index#</cfoutput>').modal('show'); 
        }
        function PopUpCerrar<cfoutput>#Attributes.index#</cfoutput>(){
          $('#myModal<cfoutput>#Attributes.index#</cfoutput>').modal('hide');
        }
		 function PopUpAbrir<cfoutput>#Attributes.index#</cfoutput>(url){
		 	$("#contenidoConfirm<cfoutput>#Attributes.index#</cfoutput>" ).load( url);
         	$('#myModal<cfoutput>#Attributes.index#</cfoutput>').modal('show'); 
        }
		
	</script>
</cfif>
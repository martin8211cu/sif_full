<cfset t= createObject("component", "sif.Componentes.Translate")>
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/rh/generales.xml')/>
<cfset LB_MensajeParaUsuario = t.Translate('LB_MensajeParaUsuario','Mensaje para Usuario','/rh/generales.xml')/>

<cfparam name="Attributes.tipo"	 type="string"    	  default="info"> 
<cfparam name="Attributes.titulo"	 type="string"    default="#LB_MensajeParaUsuario#">
<cfparam name="Attributes.mensaje"	 type="string"    default="Mensaje por defecto">
<cf_templateheader title="#LB_MensajeParaUsuario#">
	<cf_web_portlet_start >
	    <div class="container">

	     	<div class="centered">
	     		<div class="col-lg-2"></div>
	     		<div class="col-lg-8 bs-docs-section">
		 				<div class="well">
		  
							<!--- titulo----->
		                    <div class="form-group">
		                      <div class="col-lg-12" style="background-color:03366">
		                        <h3  style="color: fff;">
			                       	<i class='fa fa-info-circle fa-lg' style></i>
			                       	<cfoutput>#Attributes.titulo#</cfoutput></font>
		                         </h3>
		                      </div>
		                    </div> 


							<!--- Mensaje----->
		                    <div class="form-group">
		                      <div class="col-lg-12">
		                        	<cfoutput>#Attributes.mensaje#</cfoutput>
		                      </div>
		                    </div> 


		                    <!---- botones----->
		                    <div class="form-group">
			                    <div class="col-lg-12 text-center">
			                    		<cfif isdefined("Regresar") and len(trim(Regresar))>
											<input type="button" name="Button" class="btnAnterior" value="<cfoutput>#LB_Regresar#</cfoutput>" onClick="javascript:location.href='<cfoutput>#Regresar#</cfoutput>'">
										<cfelseif isdefined('url.Regresar') and Len(Trim(Url.Regresar))>
											<input type="button" name="Button" class="btnAnterior" value="<cfoutput>#LB_Regresar#</cfoutput>" onClick="javascript:location.href='<cfoutput>#Url.Regresar#</cfoutput>'">
										<cfelse>
											<input type="button" name="Button" class="btnAnterior" value="<cfoutput>#LB_Regresar#</cfoutput>" onClick="javascript:history.back()">
										</cfif>
	                   	 	</div> 
                    	</div>
                 </div>  
                 <div class="col-lg-2"></div>

		 	</div>
		</div><!--- fin container--->			
	<cf_web_portlet_end>
<cf_templatefooter>
 
<cfabort>
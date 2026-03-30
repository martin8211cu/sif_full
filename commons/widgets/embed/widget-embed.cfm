
<cfset REQUEST.WIDCODIGO  = "embed"/>
<cfparam name="Attributes.codewidget" default="embed" > 
<cfparam name="Attributes.showTitulo" default=0 type="boolean">
<cfparam name="Attributes.titulo" default="Código Embebido"> 
<cfparam name="Attributes.size" default="M"> 

<!--- leer configuracion --->
<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfset lvarEmbed=objParam.ObtenerValor("#request.WidCodigo#","001")>


	<style>
		.row-centered {
		    text-align:center;
		}
		.col-centered {
		    display:inline-block;
		    float:none;
		    text-align:left;
		    margin-right:-4px;
		}
	</style>

	<cfoutput>
		<div class="container">	
			<div class="row row-centered">
				<cfif Attributes.showTitulo and Attributes.titulo NEQ "">
					<dtitle>
						#Attributes.titulo#
					</dtitle>		
					<hr>
				</cfif> 
				  	<div class=" col-centered">				
						<cfif lvarEmbed NEQ "">
							<cfsavecontent variable="embedVar"><cfoutput>#lvarEmbed#</cfoutput></cfsavecontent>
							<cfoutput>
								#embedVar#
							</cfoutput>
						<cfelse>
							No se pudo obetener codigo externo.
						</cfif>
					</div>
			</div>
		</div>
	</cfoutput>





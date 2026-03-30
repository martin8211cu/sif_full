
	<cfif ThisTag.ExecutionMode is 'start'>
	<cfparam name="Attributes.codewidget" > <!--- identificador del widget --->
		<cfparam name="Attributes.showTitulo"  		default="True"	type="boolean">
	    <cfparam name="Attributes.titulo"  		    default="">
    <cfparam name="Attributes.size"          	default="M"> <!--- L <large>,M <Medium>,S <Small> --->
	</cfif>


	<cfif ThisTag.ExecutionMode is 'end'>
		<cfoutput>
		<div class="col col-12">
			<div id="popup#Attributes.codewidget#" class="dash-unit
					<cfif Attributes.size EQ 'M' or Attributes.size EQ 'S'> half-unit </cfif>
					<cfif Attributes.size EQ 'S'> small-unit </cfif> " >
					<cfif Attributes.showTitulo and Attributes.titulo NEQ "">
						<dtitle>
							#Attributes.titulo#
						</dtitle>
						<hr>
					</cfif>

			  	<div class="cont">
					  		<cftry>
								<cfinclude template="../../commons/widgets/#Attributes.codewidget#/widget.cfm">
							<cfcatch type="any">
								<cf_infobox color="red" icon="exclamation" value="Error" content="#Attributes.codewidget#"/>
							</cfcatch>
							</cftry>


				</div>
			</div>
					</div>


		<script language="javascript1.2" type="text/javascript">

			function max#Attributes.codewidget#()
			{

				$("##popup#Attributes.codewidget#1").dialog({
			        width: 820,
			        modal:true,
			        title:"Widgets",
			        resizable: "false"
				});

			}

		</script>

	</cfoutput>
	</cfif>

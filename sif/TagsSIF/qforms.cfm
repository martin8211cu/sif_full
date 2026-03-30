<cfparam name="Attributes.form" type="string" default="form1">
<cfparam name="Attributes.objForm" type="string" default="objForm">
<cfparam name="Attributes.onSubmit" type="string" default="">
<cfparam name="Attributes.onValidate" type="string" default="">
<cfparam name="ThisTag.requiredfields" default="#ArrayNew(1)#">

<cfif ThisTag.ExecutionMode is 'start'>
	<cfif not isdefined("Request.qformsInitialized")>
		<cfset Request.qformsInitialized = true>
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>

		<script language="JavaScript" type="text/javascript">
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			qFormAPI.include("*");
			qFormAPI.errorColor = "#FFFFCC";
			function habilitarValidacion(){ }
			function deshabilitarValidacion(){ }
			function appendToValidacion(functionName, appendText)
			{
				var LvarNewText = eval(functionName).toString();
				LvarNewText = LvarNewText.substring(LvarNewText.indexOf("{")+1,LvarNewText.lastIndexOf("}")-1) + "\n" + appendText;
				eval(functionName + " = new Function (LvarNewText);");
			}
		</script>
		<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
	</cfif>
	
	<cfif not isdefined("Request.qformsDeclared#Attributes.objForm#")>
		<cfset Request["qformsDeclared#Attributes.objForm#"] = true>
		<cfoutput>
		<script language="JavaScript" type="text/javascript">
			#Attributes.objForm# = new qForm("#Attributes.form#");
		<cfif len(trim(Attributes.onSubmit)) gt 0>
			#Attributes.objForm#.onSubmit = #Attributes.onSubmit#;
		</cfif>
		<cfif len(trim(Attributes.onValidate)) gt 0>
			#Attributes.objForm#.onValidate = #Attributes.onValidate#;
		</cfif>
		</script>
		</cfoutput>
	</cfif>
</cfif>

<cfif ThisTag.ExecutionMode is 'end' and ArrayLen(ThisTag.requiredfields) GT 0>
		<script language="JavaScript" type="text/javascript">
			//Campos Requeridos del Form
			<cfloop index="i" from="1" to="#ArrayLen(ThisTag.requiredfields)#">
				<cfoutput>#Attributes.objForm#.#ThisTag.requiredfields[i].name#.description="#ThisTag.requiredfields[i].description#"</cfoutput>;
				<cfoutput>if (!#Attributes.objForm#.#ThisTag.requiredfields[i].name#.obj.alt || #Attributes.objForm#.#ThisTag.requiredfields[i].name#.obj.alt == "")#Attributes.objForm#.#ThisTag.requiredfields[i].name#.obj.alt="#ThisTag.requiredfields[i].description#"</cfoutput>;
				<cfif len(trim(ThisTag.requiredfields[i].validate))>
					<cfoutput>
					<cfif not isdefined("Request.QformsValidations.#ThisTag.requiredfields[i].validate#")>
						<cfset Evaluate("Request.QformsValidations.#ThisTag.requiredfields[i].validate#=1")>
						_addValidator("is#ThisTag.requiredfields[i].validate#", #ThisTag.requiredfields[i].validate#);
					</cfif>
					#Attributes.objForm#.#ThisTag.requiredfields[i].name#.validate#ThisTag.requiredfields[i].validate#();
					</cfoutput>
				</cfif>
			</cfloop>
			function habilitarValidacion_<cfoutput>#Attributes.form#</cfoutput>(){
				<cfloop index="i" from="1" to="#ArrayLen(ThisTag.requiredfields)#">
					<cfoutput>#Attributes.objForm#.#ThisTag.requiredfields[i].name#.required=true</cfoutput>;
					<cfif len(trim(ThisTag.requiredfields[i].validate))>
						<cfif ThisTag.requiredfields[i].validateonblur>
							<cfoutput>#Attributes.objForm#.#ThisTag.requiredfields[i].name#.validate=true</cfoutput>;
						</cfif>
					</cfif>
				</cfloop>
			}
			<cfoutput>
			function deshabilitarValidacion_#Attributes.form#(){
				<cfloop index="i" from="1" to="#ArrayLen(ThisTag.requiredfields)#">
					#Attributes.objForm#.#ThisTag.requiredfields[i].name#.required=false;
				</cfloop>
				#Attributes.objForm#._allowSubmitOnError =true;
				#Attributes.objForm#._skipValidation=true;
			}
			habilitarValidacion_#Attributes.form#();
			appendToValidacion ("habilitarValidacion",		"habilitarValidacion_#Attributes.form#();");
			appendToValidacion ("deshabilitarValidacion",	"deshabilitarValidacion_#Attributes.form#();");
			</cfoutput>
		</script>
</cfif>
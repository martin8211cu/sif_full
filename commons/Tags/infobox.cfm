<cfif ThisTag.ExecutionMode is 'start'>
    <cfparam name="Attributes.color"  		    default="green"> <!--- color del tema [purple,pink,blue,green,brown,wood,light-brown,orange,grey,black,dark] --->
    <cfparam name="Attributes.icon"          	default="">
    <cfparam name="Attributes.value"           	default="">
    <cfparam name="Attributes.content"          default="">
    <cfparam name="Attributes.stat"        		default="">
    <cfparam name="Attributes.stat_style"      	default="success">
	<cfparam name="Attributes.multiValue"          default="false">
	<cfparam name="Attributes.value2"           	default="">
    <cfparam name="Attributes.stat2"        		default="">
    <cfparam name="Attributes.stat_style2"      	default="success">
</cfif>

<cfif ThisTag.ExecutionMode is 'end'>
	<cfoutput>
		<div class="infobox infobox-#Attributes.color#">
			<cfif Attributes.icon NEQ "">

				<div class="infobox-icon">
					<i class="ace-icon fa fa-#Attributes.icon#"></i>
				</div>
			</cfif>

			<div class="infobox-data">
				<span class="infobox-data-number">#Attributes.value#</span>
				<!--- <span class="infobox-data-number">#Attributes.value#</span> --->
				<div class="infobox-content">#Attributes.content#</div>
			</div>

			<cfif Attributes.stat NEQ "">
				<div class="stat stat-#Attributes.stat_style#">#Attributes.stat#</div>
				<!--- <div class="stat stat-#Attributes.stat_style#" style="top:33px">#Attributes.stat#</div> --->
			</cfif>
		</div>
	</cfoutput>
</cfif>
<cfparam name="Attributes.width" 	 default="500" 	 type="numeric">
<cfparam name="Attributes.height" 	 default="500" 	 type="numeric">
<cfparam name="Attributes.speed" 	 default="170" 	 type="numeric">
<cfparam name="Attributes.draggable" default="false" type="boolean">
<cfparam name="Attributes.URL" 		 default="" 	 type="string">
<cfparam name="Attributes.Text"      default="" 	 type="string">

<link rel="stylesheet" type="text/css" href="/cfmx/jquery/jquery-windows/css/wowwindow.css">
<cfif NOT isdefined('request.jquery15')>
	<script type="text/javascript" src="/cfmx/jquery/jquery-grid/js/jquery-1.5.js"></script>
	<cfset request.jquery15 = true>
</cfif>
<cfif NOT isdefined('request.JwindowTabIndex')>
	<cfset request.JwindowTabIndex = 1>
<cfelse>
	<cfset request.JwindowTabIndex = request.JwindowTabIndex + 1>
</cfif>
<script type="text/javascript" src="/cfmx/jquery/jquery-windows/js/jquery.wowwindow.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $('.popups<cfoutput>#request.JwindowTabIndex#</cfoutput> a').wowwindow({
            draggable: <cfoutput>#Attributes.draggable#</cfoutput>,
            speed:     <cfoutput>#Attributes.speed#</cfoutput>,
			width:     <cfoutput>#Attributes.width#</cfoutput>,
			height:    <cfoutput>#Attributes.height#</cfoutput>
        });
 	});
	function JwindowCerrar(){jQuery(document.body).overlayPlayground('close');void(0);}
</script>
<div class="popups<cfoutput>#request.JwindowTabIndex#</cfoutput>">
    	<a href="<cfoutput>#Attributes.URL#</cfoutput>">
        	<cfoutput>#Attributes.Text#</cfoutput>
        </a>	
</div>
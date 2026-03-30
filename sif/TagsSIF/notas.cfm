<cfparam name="attributes.titulo"			type="string"  default="Notas">
<cfparam name="attributes.msg"				type="string"  default="">
<cfparam name="attributes.pageIndex"		type="integer" default="1">
<cfparam name="attributes.link"				type="string"  default="Notas">
<cfparam name="attributes.irA"				type="string"  default="##">
<cfparam name="attributes.position"			type="string"  default="right">
<cfparam name="attributes.fnbeforeHide"		type="string"  default="">
<cfparam name="attributes.fnbeforeShow"		type="string"  default="">

<a
    id="tt_<cfoutput>#attributes.pageIndex#</cfoutput>"
    href="<cfoutput>#attributes.irA#</cfoutput>"
	rel="popover" 
    data-container="body" 
    data-toggle="popover" 
    data-placement="<cfif attributes.position EQ 'right'>right<cfelse>left</cfif>" 
    data-content='<cfoutput><b><div id="tt_titulo<cfoutput>#attributes.pageIndex#</cfoutput>">#attributes.titulo#</cfoutput></div></b><br><cfoutput><div id="tt_content<cfoutput>#attributes.pageIndex#</cfoutput>">#attributes.msg#</cfoutput></div>'><cfoutput>#attributes.link#</cfoutput>
</a>

<cfif not isdefined('request.bootstrap')>
	<cfsavecontent variable="LvarBootstrap"><script src="/cfmx/jquery/librerias/bootstrap.min.js"></script><link href="/cfmx/sif/css/popover.css" rel="stylesheet" type="text/css" /></cfsavecontent>
	<cfhtmlhead text="#LvarBootstrap#">
	<cfset request.bootstrap = true>
</cfif>
 
 <script>
		$( document ).ready(function() {
		 	$('#tt_<cfoutput>#attributes.pageIndex#</cfoutput>').popover(
				{ 
				html:true,
				trigger: "hover",
				content:function(){ return $($(this).data('contentwrapper')).html(); } }
				).mouseover(function (e) {
					$('[rel=popover]').not('#' + $(this).attr('id')).popover('hide');
					var $popover = $(this);
					$popover.popover('show');
					<cfif isdefined("attributes.fnbeforeShow") and len(trim(attributes.fnbeforeShow))>
						<cfoutput>#attributes.fnbeforeShow#</cfoutput>
					</cfif>
			
				}).mouseout(function (e) {
					$('[rel=popover]').not('#' + $(this).attr('id')).popover('hide');
					<cfif isdefined("attributes.fnbeforeHide") and len(trim(attributes.fnbeforeHide))>
						<cfoutput>#attributes.fnbeforeHide#</cfoutput>
					</cfif>
				});;
				
		}); /// fin de function de carga al final
		

		function fnMostrarToolTip_<cfoutput>#attributes.pageIndex#</cfoutput>(){
			$("#tt_<cfoutput>#attributes.pageIndex#</cfoutput>").popover('show');
		}
		
		function fnCerrarToolTip_<cfoutput>#attributes.pageIndex#</cfoutput>(){
			$("#tt_<cfoutput>#attributes.pageIndex#</cfoutput>").popover('hide');
		}
		<!-----
		function fnSetTituloToolTip_<cfoutput>#attributes.pageIndex#</cfoutput>(titulo){
			$('#tt_titulo<cfoutput>#attributes.pageIndex#</cfoutput>').html(titulo);
		}
		function fnSetMsgToolTip_<cfoutput>#attributes.pageIndex#</cfoutput>(contenido){
			$('#tt_content<cfoutput>#attributes.pageIndex#</cfoutput>').html(contenido);
		}
		----->
		
	</script>

<cfset pm_marginx = 2>
<cfset pm_marginy = 12>
<cfset pm_mincolwidth = 100>

<cffunction name="pm_portlet">
	<cfparam name="portlet_num" default="0">
	<cfset portlet_num=portlet_num+1>
	<cfoutput>
		<div id="pm_name#portlet_num#" style="position:relative;width:200px">
		 <cf_web_portlet titulo="Titulo #portlet_num#" skin="portlet">
			<div id="pm_contents#portlet_num#">Content #portlet_num# comes here </div>
		 </cf_web_portlet>
		 </div>
	</cfoutput>
</cffunction>

<cffunction name="pm_separator">
	<cfoutput>
	 <div id="separator" style="position:relative;width:1px;background-color:orange">
	 <img src="/cfmx/home/menu/portlets/pzn/transparentpixel.gif" width="1" height="1" alt=""></div>
	</cfoutput>
</cffunction>

<cffunction name="pm_trace">
	<cfoutput>		   
	<form name="formtrace" method="post" action="">
       <select name="select1" size="10" id="select1"><option></option>
       </select>
     </form>
	</cfoutput>
</cffunction>

<cffunction name="pm_include_javascript">
<cfoutput>
<script type="text/javascript" src="portlet_move.js"></script>
<script type="text/javascript">
<!--
SET_DHTML(CURSOR_MOVE,
	<cfloop from="1" to="#portlet_num#" index="i">
	"pm_name#i#"+TRANSPARENT,"pm_contents#i#"+NO_DRAG,
	</cfloop>
	<cfloop from="1" to="#extra_num#" index="i">
	"pm_extra#i#"+NO_DRAG,
	</cfloop>
	"separator");
	
pm_portlet_array = new Array(
	<cfloop from="1" to="#portlet_num#" index="i">
	{name:"pm_name#i#",col:#Int((i+1)/2)#,row:#1+((i+1) MOD 2)#,extra:false},
	</cfloop>
	
	<cfloop from="1" to="#extra_num#" index="i">
	{name:"extra#i#",col:#i#,row:3,extra:true}<cfif i neq extra_num>,</cfif>
	</cfloop>);

pm_reposition_portlets();
//-->
</script>
</cfoutput>
</cffunction>

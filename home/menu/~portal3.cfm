<cf_template>
<cf_templatearea name="title">Inicio</cf_templatearea>
<cf_templatearea name="body">

	<cfinclude template="portal_control.cfm">


	<script type="text/javascript" src="/cfmx/home/menu/portlets/pzn/wz_dragdrop.js"></script>
	<script type="text/javascript" src="/cfmx/home/menu/portlets/pzn/portlet_move.js"></script>
	<cfinclude template="portlets/pzn/pm_functions.cfm">
	
	<!--- OOPS ! --->
	<cfparam name="id_pagina" default="4">
	<cfinclude template="portlets/pzn/init-portlet-preferencias.cfm">

	<cfquery datasource="asp" name="portlets">
		select pp.id_pagina, pp.id_portlet, p.nombre_portlet, pp.columna, pp.fila, p.url_portlet, p.w_portlet
		from SPortletPreferencias pp
			join SPortlet p
				on pp.id_portlet = p.id_portlet
		where pp.id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_pagina#">
		  and pp.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		order by pp.columna, pp.fila
	</cfquery>
	<cfset column_count = 3>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
		<cfloop from="1" to="#column_count#" index="index_columna">
			<td valign="top" align="left">
				<cfoutput query="portlets">
					<cfif index_columna is portlets.columna>
					
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#portlets.id_portlet#"
						Default="#portlets.nombre_portlet#"
						VSgrupo="121"
						Idioma="#Session.Idioma#"
						returnvariable="translated_value" />
						<div id="pm_name#portlets.id_portlet#" style="margin:0 6px 12px 6px;text-align:left;<cfif Len(portlets.w_portlet)>width:#portlets.w_portlet#px;</cfif>" align="left">
						<cf_web_portlet pzn="yes" titulo="#translated_value#" skin="portlet" 
								name="#portlets.id_portlet#" 
								width="#portlets.w_portlet#"
								id_pagina="#portlets.id_pagina#" 
								id_portlet="#portlets.id_portlet#">
							<div id="pm_contents#portlets.id_portlet#" style="background-color:white;">
							<cftry><!---
							contents--->
							<cfinclude template="#portlets.url_portlet#">
							<cfcatch type="any">Error en portlet: #cfcatch.Message# #cfcatch.Detail#</cfcatch>
							</cftry>
							</div>
						</cf_web_portlet>
						</div>
					</cfif>
				</cfoutput>
				<cfset pm_extra()>
			</td>
		</cfloop>
		</tr>
	</table>

	<cfset pm_separator()>
<!---	 <hr>
	<cfset pm_trace()> --->

 <div id="pm_handle" style="position:relative;width:200px;height:30px;background-color:orange;border:1px solid black;">
	 <cf_web_portlet titulo="Mover">
	 <img src="/cfmx/sif/Basura/danim/dnd/transparentpixel.gif" width="1" height="1" alt="">
	 </cf_web_portlet>
 </div>

<script type="text/javascript">
<!--
function moverlo(s_source,s_target){<!---
	s_source : nombre del div que se va a mover
	s_target : nombre del div antes del cual se va insertar
	--->
	var s_source = "pm_name500000000000005";
	var s_target = "pm_name7";
	
	var n_source = document.all?document.all[s_source]:document.getElementById(s_source);
	var n_target = document.getElementById?document.getElementById(s_target):document.all[s_target];
	
	n_source.parentNode.removeChild(n_source);
	n_target.parentNode.insertBefore(n_source, n_target);
}
function patras(){
	var s_source = "pm_name500000000000005";
	var s_target = "pm_name500000000000004";
	
	var n_source = document.getElementById?document.getElementById(s_source):document.all[s_source];
	var n_target = document.getElementById?document.getElementById(s_target):document.all[s_target];
	n_source.parentNode.removeChild(n_source);
	n_target.parentNode.insertBefore(n_source, n_target);
}

var pm_marginx     = <cfoutput>#pm_marginx#</cfoutput>;
var pm_marginy     = <cfoutput>#pm_marginy#</cfoutput>;
var pm_leftmargin  = <cfoutput>#pm_leftmargin#</cfoutput>;
var pm_mincolwidth = <cfoutput>#pm_mincolwidth#</cfoutput>;
var pm_idpagina    = <cfoutput>"#id_pagina#"</cfoutput>;
////mientras corrijo los problemas con el menu
SET_DHTML(CURSOR_MOVE,
	<cfoutput query="portlets">
	"pm_name#portlets.id_portlet#"+NO_DRAG,"pm_contents#portlets.id_portlet#"+NO_DRAG,
	</cfoutput>
	<cfloop from="1" to="#column_count#" index="index_columna"><cfoutput>
		"pm_extra#index_columna#"+NO_DRAG,
	</cfoutput></cfloop>
	"separator", "pm_handle"+TRANSPARENT,"mueveme_a_mi"+NO_DRAG);
	
dd.elements.pm_handle.hide();
//
pm_portlet_array = new Array(
	<cfoutput query="portlets">
		{name:"pm_name#portlets.id_portlet#",col:#portlets.columna#,row:#portlets.fila#,extra:false},
	</cfoutput>
	<cfloop from="1" to="#column_count#" index="index_columna">
	<cfoutput>
		<cfquery dbtype="query" name="maxrow">
			select max(fila) as maxrow
			from portlets
			where columna=#index_columna#
		</cfquery>
		{name:"pm_extra#index_columna#",col:#index_columna#,row:<cfif Len(maxrow.maxrow)>#maxrow.maxrow+1#<cfelse>1</cfif>,extra:true}<cfif index_columna neq column_count>,</cfif>
	</cfoutput>
	</cfloop>
	);
//-->
</script>

<iframe width="1" height="1" marginheight="0" marginwidth="0" style="display:none" src="about:blank" name="pm_iframe" id="pm_iframe"></iframe>
</cf_templatearea>
</cf_template>
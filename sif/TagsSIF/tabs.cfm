<cfif ThisTag.ExecutionMode is 'start'>
	<cfparam name="ThisTag.tabs" default="#ArrayNew(1)#">
	<cfparam name="Attributes.width" default="650">
	<cfparam name="Attributes.mode" type="string" default="javascript">
	<cfparam name="Attributes.flush" type="boolean" default="true">
	<cfif not ListContains('javascript,url,iframe', Attributes.mode)>
	  <!---
			ni url ni iframe estan implementados,
			la idea de url es hacer que mande los parametros por url y 
				cargue solo un tab a la vez.
			la idea del iframe es tener un iframe donde se cargue
				un solo tab a la vez.
		--->
	  <cf_errorCode	code = "50707" msg = "cf_tabs: mode debe ser 'javascript', 'url', o 'frames'">
	</cfif>
</cfif>
<cfif ThisTag.ExecutionMode is 'end'>
	<cfparam name="request.cf_tab_number" type="numeric" default="0">
	<cfset request.cf_tab_number = request.cf_tab_number + 1>
	<cfif request.cf_tab_number EQ 1>
		<cfset mysuffix = ''>
	<cfelse>
		<cfset mysuffix = request.cf_tab_number>
	</cfif>
	<cfparam name="Attributes.onclick" default="tab_set_current#mysuffix#">
	<cfset tab_current = ThisTag.tabs[1].id>
	<cfloop from="1" to="#ArrayLen(ThisTag.tabs)#" index="i">
		<cfif ThisTag.tabs[i].selected>
			<cfset norsel = 'sel'>
			<cfset tab_current = ThisTag.tabs[i].id>
		<cfelse>
			<cfset norsel = 'nor'>
		</cfif>
	</cfloop>
	<cfsavecontent variable="htmlheadtext">
		<cf_importJquery>
		<script type="text/javascript">
			<!--
			<cfoutput>
			var tab_current#mysuffix# = '#JSStringFormat(tab_current)#';
			<cfif request.cf_tab_number EQ 1>
			function tab_set_style(tabname,style_prefix,style_display){
				var elem_l = document.getElementById('tab' + tabname + 'l');
				var elem_m = document.getElementById('tab' + tabname + 'm');
				var elem_r = document.getElementById('tab' + tabname + 'r');
				var elem_c = document.getElementById('tab' + tabname + 'c');
				//elem_l.src='/cfmx/sif/imagenes/tabs/'+style_prefix+'_l.gif';
				elem_l.className='tab_'+style_prefix+'_l';
				elem_m.className='tab_'+style_prefix+'_m';
				elem_r.className='tab_'+style_prefix+'_r';
				//elem_r.src='/cfmx/sif/imagenes/tabs/'+style_prefix+'_r.gif';
				if(style_display =='block'){		
					$(elem_c).fadeToggle(500);
				}
				else{
					elem_c.style.display = style_display;
				}
			}
			</cfif>
			function tab_set_current#mysuffix# (tabname){
				if (tab_current#mysuffix# == tabname) return;
				tab_set_style(tab_current#mysuffix#, 'nor', 'none');
				tab_current#mysuffix# = tabname;
				tab_set_style(tab_current#mysuffix#, 'sel', 'block');
				$(".tab_custom#mysuffix#").removeClass('active');
				$("##tab_custom#mysuffix#"+tabname).addClass( "active" );
			}
			</cfoutput>
			//-->
		</script>
	</cfsavecontent>
	<cfif Attributes.flush>
		<cfhtmlhead text="#htmlheadtext#">
	<cfelse>
		<cfoutput>#htmlheadtext#</cfoutput>
	</cfif>
	<div class="bs-example">
		<ul class="nav nav-tabs">
			<cfloop from="1" to="#ArrayLen(ThisTag.tabs)#" index="i">
				<cfif Len(Trim(ThisTag.tabs[i].text))>
					<cfif ThisTag.tabs[i].id eq tab_current>
						<cfset norsel = 'sel'>
					<cfelse>
						<cfset norsel = 'nor'>
					</cfif>
					<cfoutput>
				 	<li>
					<li class="tab_custom#mysuffix#<cfif norsel eq 'sel'> active</cfif>" id="tab_custom#i#"><a href="javascript:#Attributes.onclick#('#JSStringFormat(ThisTag.tabs[i].id)#')"># ThisTag.tabs[i].text #</a></li>
					<input type="hidden" class="tab_#norsel#_l" id="tab#HTMLEditFormat(ThisTag.tabs[i].id)#l">
					<input type="hidden" class="tab_#norsel#_m" id="tab#HTMLEditFormat(ThisTag.tabs[i].id)#m">
					<input type="hidden" class="tab_#norsel#_r" id="tab#HTMLEditFormat(ThisTag.tabs[i].id)#r">
					<input type="hidden" class="tab_div">
					</li>
					</cfoutput>
				</cfif>
			</cfloop>
		</ul>
		<div class="tab-content">
			<cfloop from="1" to="#ArrayLen(ThisTag.tabs)#" index="i">
				<cfoutput>
				<div id="tab#HTMLEditFormat(ThisTag.tabs[i].id)#c" style="<cfif ThisTag.tabs[i].id neq tab_current>display:none;</cfif>">
				#ThisTag.tabs[i].content#
				</div>
				</cfoutput>
			</cfloop>
		</div>
	</div>
</cfif>
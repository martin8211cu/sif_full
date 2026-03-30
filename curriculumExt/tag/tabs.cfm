<cfsilent>
<cfparam name="ThisTag.tabs" default="#ArrayNew(1)#">
<cfparam name="Attributes.width" default="650">
<cfparam name="Attributes.mode" type="string" default="javascript">
<cfif not ListContains('javascript,url,iframe', Attributes.mode)>
  <!---
		ni url ni iframe estan implementados,
		la idea de url es hacer que mande los parametros por url y 
			cargue solo un tab a la vez.
		la idea del iframe es tener un iframe donde se cargue
			un solo tab a la vez.
	--->
  <cfthrow message="cf_tabs: mode debe ser 'javascript', 'url', o 'frames'">
</cfif>
</cfsilent>
<cfif ThisTag.ExecutionMode is 'end'>
  <cfsilent>
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
		//elem_l.src='/imagenes/tabs/'+style_prefix+'_l.gif';
		elem_l.className='tab_'+style_prefix+'_l';
		elem_m.className='tab_'+style_prefix+'_m';
		elem_r.className='tab_'+style_prefix+'_r';
		//elem_r.src='/imagenes/tabs/'+style_prefix+'_r.gif';
		elem_c.style.display = style_display;
	}
	</cfif>
	function tab_set_current#mysuffix# (tabname){
		if (tab_current#mysuffix# == tabname) return;
		tab_set_style(tab_current#mysuffix#, 'nor', 'none');
		tab_current#mysuffix# = tabname;
		tab_set_style(tab_current#mysuffix#, 'sel', 'block');
	}
	</cfoutput>
	//-->
	</script>
  </cfsavecontent>
  <cfhtmlhead text="#htmlheadtext#">
  </cfsilent>
  <cfoutput>
    <table border="0" cellpadding="0" cellspacing="0" width="#Attributes.width#">
      <tr>
       <!---  <td><img src="/imagenes/tabs/spacer.gif" width="22" height="21" border="0" alt=""/></td> --->
        <td class="tab_div"><img src="/imagenes/tabs/spacer.gif" width="8" height="8" border="0" alt=""/></td>
        <cfloop from="1" to="#ArrayLen(ThisTag.tabs)#" index="i">
          <cfif Len(Trim(ThisTag.tabs[i].text))>
            <cfif ThisTag.tabs[i].id eq tab_current>
              <cfset norsel = 'sel'>
              <cfelse>
              <cfset norsel = 'nor'>
            </cfif>
            <td class="tab_#norsel#_l" id="tab#HTMLEditFormat(ThisTag.tabs[i].id)#l"><img src="/imagenes/tabs/spacer.gif" width="7" height="21" border="0" alt=""/></td>
            <td class="tab_#norsel#_m" id="tab#HTMLEditFormat(ThisTag.tabs[i].id)#m" nowrap="nowrap" onclick="#Attributes.onclick#('#JSStringFormat(ThisTag.tabs[i].id)#')"># ThisTag.tabs[i].text #</td>
            <td class="tab_#norsel#_r" id="tab#HTMLEditFormat(ThisTag.tabs[i].id)#r"><img src="/imagenes/tabs/spacer.gif" width="7" height="21" border="0" alt=""/></td>
            <td class="tab_div"><img src="/imagenes/tabs/spacer.gif" width="1" height="21" border="0" alt=""/></td>
          </cfif>
        </cfloop>
        <td width="100%" class="tab_div"><img src="/imagenes/tabs/spacer.gif" height="21" border="0" alt=""/></td>
      </tr>
    </table>
    <table border="0" cellpadding="0" cellspacing="0"  width="#Attributes.width#">
      <tr>
        <!--- <td width="22"><img src="/imagenes/tabs/spacer.gif" width="22" height="21" border="0" alt=""/></td> --->
        <td width="983" class="tab_contents"><cfloop from="1" to="#ArrayLen(ThisTag.tabs)#" index="i">
            <div id="tab#HTMLEditFormat(ThisTag.tabs[i].id)#c" style="<cfif ThisTag.tabs[i].id neq tab_current>display:none;</cfif>"> #ThisTag.tabs[i].content#</div>
          </cfloop></td>
      </tr>
    </table>
  </cfoutput>
</cfif>

<cffunction  name="fnTabsInclude" output="true">
	<cfargument name="pTabID"   required="true" type="string">
	<cfargument name="pTabs" 	required="true" type="string">
	<cfargument name="pDatos"   required="true" type="string">
	<cfargument name="pNoTabs"  required="false" type="boolean" default="false">
	<cfargument name="pWidth"   required="false" type="string" default="1">
	
	<cfscript>
		LvarLbls = ArrayNew(1);
		LvarPags = ArrayNew(1);
		LvarTits = ArrayNew(1);
		LvarPrms = ArrayNew(2);
		LvarDats = ListToArray (pDatos);
		LvarTabs = ListToArray (pTabs, "|");
		for (i=1; i LTE ArrayLen(LvarTabs); i=i+1)
		{
			LvarTabItem = ListToArray (LvarTabs[i]);
			LvarLbls[i]=LvarTabItem[1];
			LvarPags[i]=LvarTabItem[2];

			if (find("=",LvarTabItem[3]) EQ 0)
			{
				LvarTits[i] = LvarTabItem[3];
				LvarInicio = 4;
			}
			else
			{
				LvarTits[i] = LvarTabItem[1];
				LvarInicio = 3;
			}
			k=1;
			for (j=LvarInicio; j LTE ArrayLen(LvarTabItem); j=j+1)
			{
				LvarPrms[i][k] = LvarTabItem[j];
				k=k+1;
			}
		}
	</cfscript>

	<cfset LvarClass1 = session.preferences.skin & "_tabnorm">
	<cfset LvarClass2 = session.preferences.skin & "_tabsel">

	<cfset LvarClass1 = "tabsnorm">
	<cfset LvarClass2 = "tabssel">
	<cfset LvarClass3 = "tabstitle">

	<cfset LvarForm	  = "form_" & pTabID>

	<cfoutput>
	
	<cfset LvarSessionTabName = "session.TABS." & pTabID> 
	<cfset LvarFormTabName = "form." & pTabID>
	<cfif pNoTabs>
		<cfset LvarTabActual = 1>
		<cfset "#LvarFormTabName#" = 1>
		<cfset "#LvarSessionTabName#" = 1>
	<cfelse>
		<cfif NOT (isdefined(LvarSessionTabName) AND evaluate(LvarSessionTabName) GT 0)>
			<cfset "#LvarSessionTabName#" = 1>
		</cfif>
		<cfparam name="#LvarFormTabName#" default="#evaluate(LvarSessionTabName)#">
		<cfif evaluate(LvarFormTabName) EQ 0>
			<cfset "#LvarFormTabName#" = 1>
		</cfif>
		<cfset LvarTabActual = evaluate(LvarFormTabName)>
		<cfset "#LvarSessionTabName#" = LvarTabActual>
	</cfif>

<table cellpadding="0" cellspacing="0" width="#pWidth#" align="center" valign="top">
	<tr>
		<td>
		<cfif not pNoTabs>
			<script type="text/javascript" language="JavaScript">
			var Gvar#pTabID# = "#LvarTabActual#";
			function fnClick_#pTabID#(e,LprmTabID, LprmAction)
			{
				document.getElementById("#pTabID#_" + Gvar#pTabID#).className = "#LvarClass1#";
				document.getElementById("#pTabID#_" + LprmTabID).className = "#LvarClass2#";
				Gvar#pTabID# = LprmTabID;
				document.#LvarForm#.#pTabID#.value = LprmTabID;
				document.#LvarForm#.action = "";
				document.#LvarForm#.submit();
			}
			</script>
			<cfset fnTabs(pTabID,LvarTabActual,LvarLbls,LvarPags,LvarTits,LvarPrms,LvarDats)>
		</cfif>
			<table cellpadding="10" cellspacing="0" width="100%">
				<tr>
					<td style="border:1px solid ##CCCCCCC">
					<!---
					<cfinclude template="#mid(GetDirectoryFromPath(GetTemplatePath()),len(ExpandPath("/")),100) & LvarPags[LvarTabActual]#">
					--->
					<cfinclude template="#Replace(GetDirectoryFromPath(CGI.SCRIPT_NAME),'/cfmx','') & LvarPags[LvarTabActual]#">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
	</cfoutput>
</cffunction>

<cffunction  name="fnTabsIframe" output="true">
	<cfargument name="pIframeID"  required="true">
	<cfargument name="pEtiquetas" required="true">
	<cfargument name="pPaginas"   required="true">
	<cfargument name="pTitulos"   required="false" default="">
	<cfargument name="pCampos"    required="false" default="">
	<cfargument name="pValores"   required="false" default="">
	<cfargument name="pTabID"     required="false" default="TabID">
	
	<cfset LvarClass1 = session.preferences.skin & "_tabnorm">
	<cfset LvarClass2 = session.preferences.skin & "_tabsel">
	<cfset LvarLbls   = ListToArray (pEtiquetas)>
	<cfset LvarPags   = ListToArray (pPaginas)>
	<cfif pTitulos EQ "">
	  <cfset LvarTits = LvarLbls>
	<cfelse>
	  <cfset LvarTits   = ListToArray (pTitulos)>
	</cfif>
	<cfset LvarCmps   = ListToArray (pCampos)>
	<cfif pValores EQ "">
		<cfset LvarVals[1]= "">
	<cfelse>
		<cfset LvarVals   = ListToArray (pValores)>
	</cfif>

	<cfoutput>
	<script type="text/javascript" language="JavaScript">
	var Gvar#pTabID# = "1";
	function fnClick_#pTabID#(e,LprmTabID, LprmIframeLoc)
	{
		var LvarParams = document.getElementById("hdn_#pTabID#").value;
		if (LvarParams == "")
		  open('about:blank', "#pIframeID#");
		else
		{
			var LprmIframeTit = document.getElementById("#pTabID#_" + LprmTabID).title;
			document.getElementById("#pTabID#_" + Gvar#pTabID#).className = "#LvarClass1#";
			document.getElementById("#pTabID#_" + LprmTabID).className = "#LvarClass2#";
			//alert('document.getElementById("#pIframeID#").location = ' + '"' + LprmIframeLoc + '&" + document.getElementById("hdn_#pTabID#").value');
			var LvarTDtitle = document.getElementById("#pIframeID#_titulo");
			if (LvarTDtitle)
			{
				var LvarTexto = document.createTextNode(LprmIframeTit);
				if (LvarTDtitle.hasChildNodes())
					LvarTDtitle.replaceChild(LvarTexto,LvarTDtitle.firstChild);
				else
					LvarTDtitle.appendChild(LvarTexto);
			}
			Gvar#pTabID# = LprmTabID;
			if (LprmIframeLoc.indexOf("?")>=0)
			  open(LprmIframeLoc + "&" + document.getElementById("hdn_#pTabID#").value, "#pIframeID#");
			else
			  open(LprmIframeLoc + "?" + document.getElementById("hdn_#pTabID#").value, "#pIframeID#");
				//document.getElementById("#pIframeID#").location = LprmIframeLoc + "&" + document.getElementById("hdn_#pTabID#").value;

			var LvarElem = (e.target) ? e.target : e.srcElement;
			if ((window.top.document.body.scrollTop < 100) && (LvarElem.style.cursor == 'hand') )
				window.top.scroll(0, e.screenY);
		}
	}
	</script>
	<cfset fnTabs(LvarLbls,LvarPags,LvarLbls,LvarCmps,LvarVals,pTabID)>
	</cfoutput>
</cffunction>
	
<cffunction  name="fnTabs" output="true">
	<cfargument name="pTabID"     required="true">
	<cfargument name="pTabActual" required="true">
	<cfargument name="LvarLbls"   required="true">
	<cfargument name="LvarPags"   required="true">
	<cfargument name="LvarTits"   required="true">
	<cfargument name="LvarPrms"   required="true">
	<cfargument name="LvarDats"   required="true">

	<cfset LvarClass1 = session.preferences.skin & "_tabnorm">
	<cfset LvarClass2 = session.preferences.skin & "_tabsel">

	<cfset LvarClass1 = "tabsnorm">
	<cfset LvarClass2 = "tabssel">
	<cfset LvarClass3 = "tabstitle">

	<cfoutput>
	<form name="form_#pTabID#" action="" method="post" style="margin:0px;padding:0px;">
	<input type="hidden" name="#pTabID#" id="#pTabID#" value="#pTabActual#">
	<cfloop index="cont" from="1" to="#ArrayLen(LvarDats)#">
		<cfset LvarPto = find("=",LvarDats[cont])>
		<cfif LvarPto GT 0>
		  <cfset LvarDato = mid(LvarDats[cont],1,LvarPto-1)>
		  <cfset LvarValor = trim(mid(LvarDats[cont],LvarPto+1,1000))>
		<cfelse>
		  <cfset LvarDato = LvarDats[cont]>
		  <cfset LvarValor = "">
		</cfif>
		<input type="hidden" name="#LvarDato#" value="#LvarValor#">
		<cfset LvarFormTabName = "form." & LvarDato>
		<cfset "#LvarFormTabName#" = LvarValor>
	</cfloop>
	<cfloop index="cont" from="1" to="#ArrayLen(LvarPrms[pTabActual])#">
		<cfset LvarPto = find("=",LvarPrms[pTabActual][cont])>
		<cfif LvarPto GT 0>
		  <cfset LvarDato = mid(LvarPrms[pTabActual][cont],1,LvarPto-1)>
		  <cfset LvarValor = trim(mid(LvarPrms[pTabActual][cont],LvarPto+1,1000))>
		<cfelse>
		  <cfset LvarDato = LvarPrms[pTabActual][cont]>
		  <cfset LvarValor = "">
		</cfif>
		<input type="hidden" name="#LvarDato#" value="#LvarValor#">
		<cfset LvarFormTabName = "form." & LvarDato>
		<cfset "#LvarFormTabName#" = LvarValor>
	</cfloop>
	</form>
	
	<table width="100%" cellpadding="1" cellspacing="0">
	  <tr>
		<cfloop index="cont" from="1" to="#ArrayLen(LvarLbls)#">
		<td width="5%" class="<cfif cont EQ pTabActual>#LvarClass2#<cfelse>#LvarClass1#</cfif>" id="#pTabID#_#cont#"
			onClick="fnClick_#pTabID#(event,'#cont#', '#LvarPags[cont]#');"
			onMouseOver="style.cursor='hand';" 
			onMouseOut="style.cursor='default';"
			title="#LvarTits[cont]#"
			
			nowrap>
		  #LvarLbls[cont]#
		</td>
		</cfloop>
		<td>
		  <input type="hidden" name="hdn_#pTabID#" id="hdn_#pTabID#">&nbsp;
		</td>
	  </tr>
	  <tr class="#LvarClass3#">
		  <td colspan="#cont#" style="font-size:14px; font-weight:bold;border-left:solid 1px;">
		    #LvarTits[pTabActual]#
		  </td>
	  </tr>
	</table>
	</cfoutput>
</cffunction>

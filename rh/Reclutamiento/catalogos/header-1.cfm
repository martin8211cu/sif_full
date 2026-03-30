<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//-->
</script>
		
<cfinclude template="tabsName.cfm">

<cfif isdefined("Url.RHOid") and not isdefined("Form.RHOid")>
	<cfset Form.RHOid = Url.RHOid>
</cfif>
<cfif isdefined("Url.RHConcurso") and not isdefined("Form.RHCconcurso")>
	<cfset Form.RHCconcurso = Url.RHCconcurso>
</cfif>

<cfif isdefined("Url.RegCon") and not isdefined("Form.RegCon")>
	<cfset Form.RegCon = Url.RegCon>
</cfif>


<form name="formHeader" method="post" action="">
	<input name="vRHOid" id="vRHOid" value="<cfif isdefined('form.RHOid')><cfoutput>#form.RHOid#</cfoutput></cfif>" type="hidden">
</form>
	
<table border="0" cellspacing="0" cellpadding="5" width="100%">
	<tr>
	  <cfloop index="i" from="1" to="#ArrayLen(tabNames)#">
		<cfoutput>
		  <cfif tabAccess[i]>
		  <td class="<cfif tabChoice eq i>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<cfif tabLinks[i] neq "">
					<a href="javascript: validaRHOid(#i#,'#tabLinks[i]#');" 
					onMouseOver="javascript: window.status='#tabStatusText[i]#'; return true;" 
					onMouseOut="javascript: window.status=''; return true;" tabindex="-1">						
				</cfif>
				
				#tabNames[i]#
				
				<cfif tabLinks[i] neq "">
					</a>
				</cfif>
		  </td>
		  </cfif>
		</cfoutput>
	  </cfloop>
	  <td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
	</tr>
</table>


<script language="JavaScript" type="text/javascript">
	function validaRHOid(k,liga){
		var empl = document.formHeader.vRHOid.value;
	
		if(k==1){
			if(empl != ''){
				location.href=liga + "&RHOid=" + empl;		
			}else{
				location.href=liga;
			}
		}else{
			if(empl != ''){
				location.href=liga + "&RHOid=" + empl;
			}else{
				alert('Debe seleccionar a un oferente para acceder esta opción.');
			}
		}
	}
</script>
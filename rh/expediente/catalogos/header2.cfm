<cfinclude template="tabNamesCata.cfm">

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<form name="formHeader" method="post" action="">
	<input name="vDEid" id="vDEid" value="<cfif isdefined('form.DEid')><cfoutput>#form.DEid#</cfoutput></cfif>" type="hidden">
</form>
	
<table border="0" cellspacing="0" cellpadding="5" width="100%">
	<tr>
	  <cfloop index="i" from="1" to="#ArrayLen(tabNames)#">
		<cfoutput>
		  <cfif tabAccess[i]>
		  <td class="<cfif tabChoice eq i>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<cfif tabLinks[i] neq "">
					<a href="javascript: validaDEid(#i#,'#tabLinks[i]#');" onMouseOver="javascript: window.status='#tabStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1">						
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
	function validaDEid(k,liga){
		var empl = document.formHeader.vDEid.value;
	
		if(k==1){
			if(empl != ''){
				location.href=liga + "&DEid=" + empl;		
			}else{
				location.href=liga;
			}
		}else{
			if(empl != ''){
				location.href=liga + "&DEid=" + empl;
			}else{
				alert('Error, primeramente debe seleccionar a un empleado para acceder esta opción');
			}
		}
	}
</script>
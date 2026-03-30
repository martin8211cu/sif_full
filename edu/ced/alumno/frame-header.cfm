<cfinclude template="tabNames.cfm">

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfparam name="Form.o" default="#Url.o#">
</cfif>

<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
</cfif>

<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfset Form.persona = Url.persona>
</cfif>
<form name="formHeader" method="post" action="">
	<input name="vpersona" id="vpersona" value="<cfif isdefined('form.persona')><cfoutput>#form.persona#</cfoutput></cfif>" type="hidden">
</form>
	
<!--- <table border="0" cellspacing="0" cellpadding="5" width="100%">
	<tr>
	  <cfloop index="i" from="1" to="#ArrayLen(tabNames)#">
		<cfoutput>
		  <td class="<cfif tabChoice eq i>tabSelected<cfelse>tabNormal</cfif>" nowrap>
			<cfif tabLinks[i] neq "">
			  <a href="#tabLinks[i]#" onMouseOver="javascript: window.status='#tabStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"> 
			 	<a href="javascript: validapersona(#i#,'#tabLinks[i]#');" onMouseOver="javascript: window.status='#tabStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1">	
			</cfif>
		  #tabNames[i]#
		  <cfif tabLinks[i] neq ""></a></cfif>
		  </td>
		</cfoutput>
	  </cfloop>
	  <td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
	</tr>
</table> --->
<script language="JavaScript" type="text/javascript">
	function validapersona(k,liga){
		
		var empl = document.regAlum.persona.value;
		//alert(liga + "&persona=" + empl);
		//alert(k);alert(liga);alert(empl);
		
		if(k==1){
			if(empl != ''){
				location.href=liga + "&persona=" + empl;		
			}else{
				location.href=liga;
			}
		}else{
			//alert(empl);
			if(empl != ''){
				location.href=liga + "&persona=" + empl;
			}else{
				alert('Error, primeramente debe seleccionar a un alumno para accesar esta opción');
			}
		}
	}
</script> 
<cfinclude template="tabNamesCata.cfm">

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>
<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
</cfif>
<cfif isdefined("Url.Usucodigo") and not isdefined("Form.Usucodigo")>
	<cfset Form.Usucodigo = Url.Usucodigo>
</cfif>
<cfif isdefined("Url.Ulocalizacion") and not isdefined("Form.Ulocalizacion")>
	<cfset Form.Ulocalizacion = Url.Ulocalizacion>
</cfif>
<cfif isdefined("Url.modo") and not isdefined("Form.modo")>
	<cfset Form.modo = Url.modo>
</cfif>

<form name="formHeader" method="post" action="">
	<cfoutput>
		<input name="vUsucodigo" id="vUsucodigo" value="<cfif isdefined('form.Usucodigo')>#form.Usucodigo#</cfif>" type="hidden">
		<input name="vUlocalizacion" id="vUlocalizacion" value="<cfif isdefined('form.Ulocalizacion')>#form.Ulocalizacion#</cfif>" type="hidden">		
	</cfoutput>
</form>
	
<table border="0" cellspacing="0" cellpadding="5" width="100%">
	<tr>
	  <cfloop index="i" from="1" to="#ArrayLen(tabNames)#">
		<cfoutput>
		  <td class="<cfif tabChoice eq i>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<cfif tabLinks[i] neq "">
					<a href="javascript: validaDEid(#i#,'#tabLinks[i]#');" onMouseOver="javascript: window.status='#tabStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1">						
				</cfif>
				
				#tabNames[i]#
				
				<cfif tabLinks[i] neq "">
					</a>
				</cfif>
		  </td>
		</cfoutput>
	  </cfloop>
	  <td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
	</tr>
</table>


<script language="JavaScript" type="text/javascript">
	function validaDEid(k,liga){
		var varUsuc 	= document.formHeader.vUsucodigo.value;
		var varUlocal	= document.formHeader.vUlocalizacion.value;

		if(k==1){
			if(varUsuc != '' && varUlocal != ''){
				location.href=liga + "&Usucodigo=" + varUsuc + "&Ulocalizacion=" + varUlocal;		
			}else{
				location.href=liga;
			}
		}else{
			if(varUsuc != '' && varUlocal != ''){
				location.href=liga + "&Usucodigo=" + varUsuc + "&Ulocalizacion=" + varUlocal;		
			}else{
				alert('Error, primeramente debe seleccionar a un usuario para accesar esta opción');
			}
		}
	}
</script>
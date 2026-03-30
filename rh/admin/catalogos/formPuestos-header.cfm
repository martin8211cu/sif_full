<cfinclude template="formPuestos-tabnames.cfm">

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>

<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
</cfif>

<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
	<cfset Form.RHPcodigo = Url.RHPcodigo>
</cfif>

<form name="formHeader" method="post" action="">
	<input name="vDEid" id="vDEid" value="<cfif isdefined('form.RHPcodigo')><cfoutput>#form.RHPcodigo#</cfoutput></cfif>" type="hidden">
</form>
	

<!---<table border="0" cellspacing="0" cellpadding="5" width="100%">
	<tr>
	  <cfloop index="i" from="1" to="#ArrayLen(tabNames)#">
		<cfoutput>
		  <td valign="top" class="<cfif tabChoice eq i>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
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
</table>--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion"
	Default="Debe seleccionar un puesto para acceder a esta opción"
	returnvariable="MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion"/>

<script language="JavaScript" type="text/javascript">
	function validaDEid(k,liga){
		var empl = document.formHeader.vDEid.value;
	
		if(k==1){
			if(empl != ''){
				location.href=liga + "&RHPcodigo=" + empl;		
			}else{
				location.href=liga;
			}
		}else{
			if(empl != ''){
				location.href=liga + "&RHPcodigo=" + empl;
			}else{
				alert('<cfoutput>#MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion#</cfoutput>');
			}
		}
	}
</script>
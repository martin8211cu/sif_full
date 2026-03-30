<cfif isdefined('form.ckPM') or isdefined('form.ckA') or isdefined('form.ckP') or isdefined('form.ckD') or isdefined('form.ckAD')>
  <table width="100%" border="0" cellspacing="4" cellpadding="4">
    <tr> 
      <td colspan="3" >&nbsp;</td>
    </tr>  
    <tr> 
      <td width="29%">&nbsp;</td>
      <td width="32%">&nbsp;</td>
      <td width="39%">&nbsp;</td>
    </tr>
    <tr> 
      <td <cfif isdefined('form.ckPM')>class="subrayado"</cfif>>&nbsp;</td>
      <td <cfif isdefined('form.ckP')>class="subrayado"</cfif>>&nbsp;</td>
      <td <cfif isdefined('form.ckAD') and isdefined('form.ckAdic1')>class="subrayado"</cfif>>&nbsp;</td>
    </tr>
    <tr> 
      <td align="center"><cfif isdefined('form.ckPM')>Padre / Madre<cfelse>&nbsp;</cfif></td>
      <td align="center"><cfif isdefined('form.ckP')>Profesor<cfelse>&nbsp;</cfif></td>
      <td align="center">
	  	<cfif isdefined('form.ckAD') and isdefined('form.ckAdic1')>
			<cfoutput>#form.nomAdicio1#</cfoutput>	
		<cfelse>
			&nbsp;
		</cfif>
	  </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td <cfif isdefined('form.ckA')>class="subrayado"</cfif>>&nbsp;</td>
      <td <cfif isdefined('form.ckD')>class="subrayado"</cfif>>&nbsp;</td>
      <td <cfif isdefined('form.ckAD') and isdefined('form.ckAdic2')>class="subrayado"</cfif>>&nbsp;</td>
    </tr>
    <tr> 
      <td align="center"><cfif isdefined('form.ckA')>Alumno<cfelse>&nbsp;</cfif></td>
      <td align="center"><cfif isdefined('form.ckD')>Director<cfelse>&nbsp;</cfif></td>
      <td align="center"><cfif isdefined('form.ckAD') and isdefined('form.ckAdic2')><cfoutput>#form.nomAdicio2#</cfoutput><cfelse>&nbsp;</cfif></td>
    </tr>
  </table>
</cfif>
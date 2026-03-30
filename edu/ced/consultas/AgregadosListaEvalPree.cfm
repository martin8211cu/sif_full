<cfif isdefined('form.ckEsc')>
  <table width="100%" border="0" cellspacing="1" cellpadding="1">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>  
    <tr> 
      <td colspan="2" class="areaFiltro" align="center"><strong>ESCALA DE VALORACI&Oacute;N</strong></td>
    </tr>
    <tr> 
      <td align="center"  class="subrayado">N / A</td>
      <td class="subrayado">No Aplica</td>
    </tr>
	<cfif isdefined('rsEscValoracion')>
		<cfoutput>
			<cfloop query="rsEscValoracion">
				<tr> 
				  <td align="center" class="subrayado">#rsEscValoracion.EVvalor#</td>
				  <td class="subrayado">#rsEscValoracion.EVdescripcion#</td>
				</tr>
			</cfloop>	
		</cfoutput>
	</cfif>
  </table>
</cfif>
<cfif isdefined('form.ckObs')>
  <!--- Espacio para Comentarios u Orservaciones --->
  <table width="100%" border="0" cellspacing="1" cellpadding="1">
    <tr> 
      <td width="6%">&nbsp;</td>
      <td width="94%">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" class="areaFiltro" align="center"><strong>COMENTARIOS / 
        OBSERVACIONES</strong></td>
    </tr>
    <tr> 
      <td width="6%">&nbsp;</td>
      <td width="94%">&nbsp;</td>
    </tr>
    <cfloop query="rsPeriodos">
      <tr> 
        <td colspan="2" class="encabReporte"><cfoutput>#rsPeriodos.PEdescripcion#</cfoutput></td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td class="subrayado">&nbsp;</td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td class="subrayado">&nbsp;</td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td class="subrayado">&nbsp;</td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td class="subrayado">&nbsp;</td>
      </tr>	  	  
      <tr> 
        <td>&nbsp;</td>
        <td class="subrayado">&nbsp;</td>
      </tr>	  
      <tr> 
        <td>&nbsp;</td>
        <td class="subrayado">&nbsp;</td>
      </tr>	  
    </cfloop>
  </table>
</cfif>
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
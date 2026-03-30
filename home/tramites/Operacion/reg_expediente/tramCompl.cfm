 
 
<cfquery name="rsTramites" datasource="#session.tramites.dsn#">
 select fecha_inicio, nombre_tramite, it.id_tramite, it.id_instancia, it.id_persona
 from TPInstanciaTramite it 
 left outer join TPTramite t
   on it.id_tramite = t.id_tramite
 where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_persona#">
   and completo = 1
</cfquery>
 
<table width="530" align="center"  style=" border:1px solid #595959 ">

 <tr>
  <td>
   <table width="515" align="center" cellpadding="0" cellspacing="0" border="0">
  
    <cfif rsTramites.recordcount gt 0>
    <tr bgcolor="#DADAB6">
     <td width="60" height="15"><strong>TRAMITE</strong></td>
     <td align="center" width="100" height="15" nowrap><strong>INICIO</strong></td>
     </tr>	
    <cfoutput query="rsTramites">
     <tr> 
      <td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="left">#rsTramites.nombre_tramite#</div></td>
      <td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="center">#LSDateFormat(rsTramites.fecha_inicio,'dd/mm/yyyy')#</div></td>
      </tr>
    </cfoutput>
    <cfelse> 
     <tr> 
      <td align="center" colspan="2" bgcolor="" class="bajada" height="15" id=color7>&nbsp;</td>
     </tr>
     <tr> 
      <td align="center" colspan="2" bgcolor="" class="bajada" height="15" id=color7><div align="center">No hay trámites completados en este expediente.</div></td>
     </tr>
     <tr> 
      <td align="center" colspan="2" bgcolor="" class="bajada" height="15" id=color7>&nbsp;</td>
     </tr>	 
    </cfif>
   </table> 
  </td>
 </tr>
</table>
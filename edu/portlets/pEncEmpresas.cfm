  <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
		select CEnombre from CentroEducativo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	</cfquery>
  <form name="pEmpresas2" method="post" style="margin: 0">
   <cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
      <tr class="area"> 
        <td width="30%" style="font-size: 7pt;">Servicios Digitales al Ciudadano<br>
          www.migestion.net </td>
        <td width="40%" align="center"><cf_LoadImage tabla="CentroEducativo a,  sdc..EmpresaID b, sdc..Empresa c " columnas="logo as contenido, #Session.Edu.CEcodigo# as codigo" condicion="a.CEcodigo = #Session.Edu.CEcodigo# and b.sistema = 'edu' and a.CEcodigo = b.consecutivo and b.Ecodigo = c.Ecodigo" imgname="Logo" height="60"></td>
        <td width="30%" style="font-size: 7pt; text-align: right"> #Request.Translate('RptProgTit08','','/edu/Utiles/Reportes.xml','#Session.Idioma#')#: 
          <cfif isdefined("form.FechaRep") and len(trim(form.FechaRep)) neq 0>
            <cfif Session.Idioma EQ "EN">
              #LSdateFormat(form.FechaRep,'MM/dd/YYYY')# 
              <cfelse>
              #LSdateFormat(form.FechaRep,'dd/MM/YYYY')# 
            </cfif>
            <cfelse>
            <cfif Session.Idioma EQ "EN">
              #LSdateFormat(Now(),'MM/dd/YYYY')# 
              <cfelse>
              #LSdateFormat(Now(),'dd/MM/YYYY')# 
            </cfif>
          </cfif> </td>
      </tr>
      <tr class="tituloAlterno"> 
        <td colspan="3" align="center" class="tituloAlterno"> <strong> 
          <cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
            	#form.TituloRep# 
            <cfelse>
				#tituloDefault#
            <!--- #Request.Translate('RptProgTit02','','/edu/Utiles/Reportes.xml','#Session.Idioma#')#  --->
          </cfif>
          </strong> </td>
      </tr>
      <tr class="tituloAlterno"> 
        <td colspan="3" align="center" class="tituloAlterno"> <strong>#rsCentroEducativo.CEnombre#</strong>
          <hr> </td>
      </tr>
    </table>
</cfoutput>

</form>

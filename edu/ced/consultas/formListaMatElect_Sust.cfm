	<cfif isdefined("Url.FNcodigo") and not isdefined("Form.FNcodigo")>
		<cfparam name="Form.FNcodigo" default="#Url.FNcodigo#">
	</cfif> 
	<cfif isdefined("Url.FGcodigo") and not isdefined("Form.FGcodigo")>
		<cfparam name="Form.FGcodigo" default="#Url.FGcodigo#">
	</cfif> 
	<cfif isdefined("Url.FGRcodigo") and not isdefined("Form.FGRcodigo")>
		<cfparam name="Form.FGRcodigo" default="#Url.FGRcodigo#">
	</cfif> 		

	<!--- Consultas --->		 
		<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_ELECT_SUST" returncode="yes">
			<cfprocresult name="rsElectSust">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@CCentro" value="#Session.Edu.CEcodigo#">
			<cfif isdefined('form.FNcodigo') and form.FNcodigo NEQ '-1'>
				<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@nivel" value="#Form.FNcodigo#">
			</cfif>
			<cfif isdefined('form.FGcodigo') and form.FGcodigo NEQ '-1'>
				<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@grado" value="#Form.FGcodigo#">			
			</cfif>
			<cfif isdefined('form.FGRcodigo') and form.FGRcodigo NEQ '-1'>
				<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@grupo" value="#Form.FGRcodigo#">			
			</cfif>
		</cfstoredproc>
				 
		<cfquery name="rsElect" dbtype="query">
			Select distinct codElect,MnombreEle
			from rsElectSust
			order by MnombreEle
		</cfquery>	
		
		 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>			

<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr class="area"> 
    <td>Servicios Digitales al Ciudadano</td>
    <td width="20%">&nbsp;</td>
    <td width="19%">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
  </tr>
  <tr class="area"> 
    <td>www.migestion.net</td>
    <td>&nbsp;</td>
    <td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
  </tr>
  <tr> 
    <td colspan="3" class="tituloAlterno" align="center">LISTADO DE MATERIAS ELECTIVAS 
      CON SUSTITUTIVAS</td>
  </tr>
  <tr> 
    <td colspan="3" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <cfif rsElect.recordCount GT 0>
    <cfloop query="rsElect" >
      <cfoutput> 
        <cfset codElectiva = "#rsElect.codElect#">
        <tr class="subTitulo"> 
          <td height="20" colspan="3" valign="top" class="encabReporte">#rsElect.MnombreEle#</td>
        </tr>
        <cfquery name="rsMatSust" dbtype="query">
        Select codElect,Cnombre,NombreProf,HDia,Hentrada,Hsalida,Bloque,Aula
		from rsElectSust 
		where rsElectSust.codElect=#codElectiva# 
        order by Cnombre 
        </cfquery>
        <cfif rsMatSust.recordCount GT 0>
          <tr> 
            <td colspan="3"> 
              <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td width="3%"  class="subTitulo">&nbsp;</td>
                  <td width="27%" class="subTitulo">Sustitutiva</td>
                  <td width="22%" class="subTitulo">Profesor</td>
                  <td width="48%" class="subTitulo">Horario</td>
                </tr>
                <cfloop query="rsMatSust" >
                  <cfoutput> 
                    <tr <cfif #rsMatSust.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #rsMatSust.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
                      <td>&nbsp;</td>
                      <td>#rsMatSust.Cnombre#</td>
                      <td>#rsMatSust.NombreProf#</td>
                      <td> <strong>#rsMatSust.HDia#:</strong> #rsMatSust.Hentrada#-#rsMatSust.Hsalida# <strong>~</strong> #rsMatSust.Bloque# <strong>Aula:</strong> #rsMatSust.Aula# </td>
                    </tr>
                  </cfoutput> 
                </cfloop>
              </table></td>
          </tr>
        </cfif>
      </cfoutput> 
    </cfloop>
  </cfif>
  <tr> 
    <td colspan="3" align="center">------------------ Fin del Reporte ------------------</td>
  </tr>  
</table>

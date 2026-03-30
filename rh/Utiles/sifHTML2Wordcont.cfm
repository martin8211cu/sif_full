<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script> 
  
	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"></td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">
			<cfparam name="session.modulo" default="">
			<cfquery name="rsModulo" datasource="#Session.DSN#">
				select Mdescripcion from Modulos where Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Modulo#">
			</cfquery>
			<cfoutput>#rsModulo.Mdescripcion#</cfoutput>
			<cftry>
			<cfheader name="Content-Disposition" value="attachment; filename=#rsModulo.Mdescripcion#_#Dateformat(Now(),'YYYYMMDD')#.xls">
			<cfcatch></cfcatch>
			</cftry>
			</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
		  <cftry>
		  	<cfinclude template="/sif/#Session.Modulo#/jsMenu#Session.Modulo#.cfm">
		  <cfcatch></cfcatch>
		  </cftry>
            </td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cfif isdefined("url.Titulo")>
			<cfset titulo="#url.Titulo#">
		</cfif>		
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#titulo#">
	 
		  <cftry>
		  <cfinclude template="/sif/Portlets/pNavegacion#Session.Modulo#.cfm">
  		  <cfcatch></cfcatch>
		  </cftry>

			<cfif isdefined("url.Archivo") and len(trim(url.archivo)) gt 0>
				<cfif Findnocase('#Session.Usucodigo#_#Session.Ulocalizacion#',url.Archivo) GT 0> 
					<cftry>
						<cfcontent type="application/msexcel" file = "#GetTempDirectory()##url.Archivo#.xls" deletefile = "no" >
					<cfcatch>
					<br>
						<blockquote>
						  <h4><font color="#993333">Advertencia:</font> <br><br>
						  &nbsp;&nbsp;El documento solicitado no existe o usted no tiene acceso. Proceso Cancelado!.
						  </h4>
					  </blockquote>
						<div align="center"><br>
						    <input type="button" name="Regresar" value="Regresar" onClick="javascript:history.back();"><br>
					      </div>
						  <br>
					</cfcatch>
					</cftry>
				<cfelse>
				<br>
					<blockquote>
					  <h4><font color="#993333">Advertencia:</font><br><br>
					  &nbsp;&nbsp;El documento solicitado no existe o usted no tiene acceso. Proceso Cancelado!.
					  </h4>
				  </blockquote>
					<div align="center"><br>
					    <input type="button" name="Regresar" value="Regresar" onClick="javascript:history.back();">
				      </div>
					  <br>
				</cfif>
			</cfif>   
            	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MenuPrin"
	Default="Menú Principal"
	returnvariable="MenuPrin"/>	

	  <cf_web_portlet_start titulo="#MenuPrin#" >
	  <cfquery name="RHConf" datasource="#Session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Pcodigo = 7
	  </cfquery>

  	  <cfinclude template="/rh/portlets/pNavegacion.cfm">
      <table width="70%" border="0" align="center" cellpadding="1" cellspacing="2">
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="right"></div></td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="10"><strong><font size="3"><img src="/cfmx/rh/imagenes/SeleccioneOpcion.gif" editor="Webstyle3" moduleid="default (project)\SeleccioneOpcion.xws" border="0"></font></strong></td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="right"></div></td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="4"><font size="2"><img src="/cfmx/rh/imagenes/Operacion.gif" editor="Webstyle3" moduleid="default (project)\Operacion.xws" border="0"></font></td>
          <td>&nbsp;</td>
          <td colspan="4"><font size="2"><!---<img src="/cfmx/rh/imagenes/Consultas.gif" editor="Webstyle3" moduleid="default (project)\Consultas.xws" border="0">---></font></td>
          <td>&nbsp;</td>
        </tr>
		<!--- Si el sistema usa RH estas opciones no se muestran --->
		<cfif RHConf.recordCount GT 0 and RHConf.Pvalor NEQ 1 and RHConf.Pvalor NEQ 2>
        <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="CargaNomina"
		Default="Cargade Archivo de N&oacute;mina"
		returnvariable="CargaNomina"/>	
		
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
          <td nowrap><font size="2"><a href="#"> <cfoutput>#CargaNomina#</cfoutput> </a></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td align="right" valign="middle">&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap><font size="2"><a href="#"> </a></font></td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
          <td nowrap><font size="2"><a href="/cfmx/rh/pago/operacion/listaRNomina.cfm"> 
            <cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="RegistroNomina"
			Default="Registro de N&oacute;mina"
			returnvariable="RegistroNomina"/>	
			
			<cfoutput>#RegistroNomina#</cfoutput> </a></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
        </tr>
		</cfif>
        <tr> 
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
          <td nowrap><font size="2"><a href="/cfmx/rh/pago/operacion/listaVNomina.cfm"> 
        
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="VerificacionNomina"
			Default="Verificaci&oacute;n de N&oacute;mina"
			returnvariable="VerificacionNomina"/>    
			
			
			<cfoutput>#VerificacionNomina#</cfoutput> </a></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
		<cfif (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_con_Banco_Virtual) or (Session.RHParams.RHPARAM7 EQ Session.RHParams.sin_RH_con_Banco_Virtual)>
			<tr> 
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
			  <td nowrap><font size="2"><a href="/cfmx/rh/pago/operacion/listaANomina.cfm"> 
				<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="AutorizacionNomina"
			Default="Autorizaci&oacute;n de N&oacute;mina"
			returnvariable="AutorizacionNomina"/>   
				
				
				<cfoutput>#AutorizacionNomina#</cfoutput> </a></font></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			
			<tr> 
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
			  <td nowrap><font size="2"><a href="/cfmx/rh/pago/operacion/listaXNomina.cfm"> 
				<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="ErroresNomina"
			Default="Errores en Pago de N&oacute;mina"
			returnvariable="ErroresNomina"/>	
				
				
				<cfoutput>#ErroresNomina#</cfoutput> </a></font></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			
		<cfelse>
			<tr> 
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
			  <td nowrap><font size="2"><a href="/cfmx/rh/pago/operacion/listaPNomina.cfm"> 
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="PagoNomina"
				Default="Registro de Pago dede N&oacute;mina"
				returnvariable="PagoNomina"/>
				
				
				<cfoutput>#PagoNomina#</cfoutput> </a></font></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			<cfquery name="rsBancosFormato" datasource="#session.DSN#">
				select Bid, RHEdescripcion
				from RHExportaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfoutput query="rsBancosFormato">
			<tr> 
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
			  <td nowrap><font size="2"><a href="/cfmx/rh/pago/catalogos/Exportacion.cfm?Bid=#Bid#"> 
				#RHEdescripcion# </a></font></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			</cfoutput>
			<tr> 
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
			  <cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="ExportacionCheques"
				Default="Exportaci&oacute;n de Cheques"
				returnvariable="ExportacionCheques"/>
			  
			  <td nowrap><font size="2"><a href="/cfmx/rh/pago/catalogos/Exportacion.cfm"><cfoutput>#ExportacionCheques#</cfoutput></a></font></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
		</cfif>
        <tr>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle">&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle">&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 

          <td colspan="4"><img src="/cfmx/rh/imagenes/Catalogos.gif" editor="Webstyle3" moduleid="default (project)\Catalogos.xws" border="0"></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td>&nbsp;</td>
        </tr>
		<!--- Si el sistema usa RH estas opciones no se muestran --->
		<cfif RHConf.recordCount GT 0 and RHConf.Pvalor NEQ 1 and RHConf.Pvalor NEQ 2>
        <tr> 
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
          
		  <cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="TipoNomina"
				Default="Tipos de N&oacute;mina"
				returnvariable="TipoNomina"/>
		  <td nowrap><font size="2"><a href="/cfmx/rh/admin/catalogos/TiposNomina.cfm"><cfoutput>#TipoNomina#</cfoutput></a></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle"> <div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
          <cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="Puestos"
				Default="Puestos"
				returnvariable="Puestos"/>
		  
		  <td nowrap><font size="2"><a href="/cfmx/rh/admin/catalogos/Puestos.cfm"><cfoutput>#Puestos#</cfoutput></a></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td>&nbsp;</td>
        </tr>
		</cfif>
        <tr> 
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle"><div align="center"><font size="2"><img src="/cfmx/rh/imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></font></div></td>
           <cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="FExportacion"
				Default="Formatos de Exportaci&oacute;n"
				returnvariable="FExportacion"/>
		  
		  <td nowrap><font size="2"><a href="catalogos/FExportacion.cfm"><cfoutput>#FExportacion#</cfoutput></a></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle">&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle">&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle">&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle">&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td nowrap>&nbsp;</td>
          <td align="right" valign="middle">&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap><font size="2">&nbsp;</font></td>
          <td>&nbsp;</td>
        </tr>
      </table>
	  <cf_web_portlet_end>
 
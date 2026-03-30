<cfset debugStartTime = getTickCount()>
<cfset factory = CreateObject('java', 'coldfusion.server.ServiceFactory')>
<cfset cfdebugger = factory.getDebuggingService()>

<cfinvoke component="home.Componentes.Politicas"
	method="trae_parametro_global" parametro="debug.expira"
	returnvariable="debug_expira"/>
<cfif Not IsDate(debug_expira)>
	<cfset debug_expira = ''>
	<cfset plazo_expira = 0>
<cfelse>
	<cfset plazo_expira = DateDiff('h', Now(), debug_expira)+1>
	<cfif plazo_expira LT 0>
		<cfset plazo_expira = 0>
	</cfif>
</cfif>

<cfoutput>
	  <form id="form1" name="form1" method="post" action="apply.cfm">
	  <input type="hidden" name="tab" value="# HTMLEditFormat( url.tab )#" />
	    <table width="600" border="0" cellspacing="0" cellpadding="2">
          
          <tr>
            <td width="4">&nbsp;</td>
            <td width="338">&nbsp;</td>
            <td width="228">&nbsp;</td>
            <td width="14">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>Debug habilitado en el administrador de coldfusion </td>
            <td>#cfdebugger.settings.enabled#</td>
            <td>&nbsp;</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
            <td><cfif Len(debug_expira) And debug_expira GT Now()>
				La depuración estará activa hasta
				<cfelse>
				El plazo de depuración ya expiró
				</cfif></td>
            <td><cfif Len(debug_expira) And debug_expira GT Now()>
				#TimeFormat(debug_expira)# #DateFormat(debug_expira)#</cfif></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>debug_template</td>
            <td>#cfdebugger.settings.debug_template#</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>template_mode</td>
            <td>#cfdebugger.settings.template_mode#</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>Activar depuración por </td>
            <td><input type="text" name="activa_horas" value="#plazo_expira#" size="2" maxlength="2">
            horas</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;(recuerde seleccionarlo en el administrador de coldfusion) </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td><input type="submit" name="btnActivar" class="btnGuardar" value="Activar">
			<input type="submit" name="btnInactivar" class="btnEliminar" value="Inactivar">			</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
  </form>
</cfoutput>

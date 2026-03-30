<!--- Tag de Cuentas --->
<cfparam name="url.CFformato" default="">
<cfparam name="url.ConLis" default="">
<cfparam name="url.Ecodigo" default="">
<cfparam name="url.Fecha" default="">

<cfif trim(url.CFformato) EQ "">
	<script language="javascript" type="text/javascript">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoIndicadoNingunaCuenta"
		Default="No ha indicado ninguna cuenta"
		returnvariable="MSG_NoIndicadoNingunaCuenta"/>
		
		alert ("<cfoutput>#MSG_NoIndicadoNingunaCuenta#</cfoutput>");
	</script>
	<cfabort>
</cfif>

<cfset LvarCmayor = mid(url.CFformato,1,4)>
<cfset LvarCFdetalle = mid(url.CFformato,6,100)>
<cfset Ecodigo = url.Ecodigo>

<cfinvoke 
 component="sif.Componentes.PC_GeneraCuentaFinanciera"
 method="fnGeneraCuentaFinanciera"
 returnvariable="Lvar_MsgError">
	<cfinvokeargument name="Lprm_Cmayor"		value="#LvarCmayor#"/>
	<cfinvokeargument name="Lprm_Cdetalle"		value="#LvarCFdetalle#"/>
	<cfinvokeargument name="Lprm_Ecodigo"		value="#Ecodigo#"/>
	<cfinvokeargument name="Lprm_Ocodigo"		value="#url.Ocodigo#"/>
	<cfinvokeargument name="Lprm_Verificar_CFid"	value="#url.CFid#"/>
	<cfinvokeargument name="Lprm_SoloVerificar"	value="true"/>
	<cfif url.Fecha NEQ "">
		<cfinvokeargument name="Lprm_Fecha"		value="#LSParseDateTime(Url.fecha)#"/>
	</cfif>
	<cfif url.ConLis EQ "N">
		<cfinvokeargument name="Lprm_NoVerificarPres"	value="true"/>
	</cfif>
</cfinvoke>

<cfif isdefined('Lvar_MsgError') AND (Lvar_MsgError NEQ "" AND Lvar_MsgError NEQ "OLD" AND Lvar_MsgError NEQ "NEW")>
	<script language="JavaScript1.2" type="text/javascript">
		<cfoutput>
		alert("#fnJSStringFormat("ERROR:\n\n" & Lvar_MsgError)#");
		</cfoutput>
	</script>
<cfelseif isdefined('Lvar_MsgError') AND (Lvar_MsgError EQ "NEW" OR Lvar_MsgError EQ "OLD")>
	<script language="JavaScript1.2" type="text/javascript">
		<cfoutput>
		<cfif url.ConLis EQ "N">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_VerificacionOK"
			Default="Verificación OK"
			returnvariable="MSG_VerificacionOK"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_LaCuenta"
			Default="La cuenta "
			returnvariable="MSG_LaCuenta"/>		
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EstaBienFormadaYPuedeSerCreadaSinproblemas"
			Default="esta bien formada y puede ser creada sin problemas\n\n(excepto que requiera Cuenta de Presupuesto y no exista"
			returnvariable="MSG_EstaBienFormadaYPuedeSerCreadaSinproblemas"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSecumplenReglasOHayaValoresNoPertenecientesAUnaOficinaEnParticular"
			Default="o no se cumplan reglas\n o haya valores no pertenecientes a una oficina en particular"
			returnvariable="MSG_NoSecumplenReglasOHayaValoresNoPertenecientesAUnaOficinaEnParticular"/>				
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_YaExiste"
			Default="ya existe"
			returnvariable="MSG_YaExiste"/>		
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_PeroNoSeValidaronReglasNiValoresPertenecientesAUnaOficinaEnParticular"
			Default="(pero no se validaron reglas\n ni valores pertenecientes a una oficina en particular)"
			returnvariable="MSG_PeroNoSeValidaronReglasNiValoresPertenecientesAUnaOficinaEnParticular"/>					
		
			<cfoutput>
			<cfif Lvar_MsgError EQ "NEW">
				<cfif url.Ocodigo EQ "-1">
					alert("#fnJSStringFormat("#MSG_VerificacionOK#:\n\n#MSG_LaCuenta# #url.CFformato# #MSG_EstaBienFormadaYPuedeSerCreadaSinproblemas#,\n #MSG_NoSecumplenReglasOHayaValoresNoPertenecientesAUnaOficinaEnParticular#)")#");

				<cfelse>
					alert("#fnJSStringFormat("#MSG_VerificacionOK#:\n\n#MSG_LaCuenta# #url.CFformato# #MSG_EstaBienFormadaYPuedeSerCreadaSinproblemas#)")#");
				</cfif>
			<cfelse>
				<cfif url.Ocodigo EQ "-1">
					alert("#fnJSStringFormat("#MSG_VerificacionOK#:\n\n#MSG_LaCuenta# #url.CFformato# #MSG_YaExiste#\n\n#MSG_PeroNoSeValidaronReglasNiValoresPertenecientesAUnaOficinaEnParticular#")#");
				<cfelse>
					alert("#fnJSStringFormat("#MSG_VerificacionOK#:\n\n#MSG_LaCuenta# #url.CFformato# #MSG_YaExiste#")#");
				</cfif>
			</cfif>
			</cfoutput>
		<cfelse>
			if (window.parent.sbSeleccionarOK) 
			{
				window.parent.sbSeleccionarOK();
			}
		</cfif>
		</cfoutput>
	</script>
</cfif>
<cffunction name="fnJSStringFormat" output="false" returntype="string" access="private">
	<cfargument name="hilera" type="string" required="yes">
	
	<cfinvoke 
		 component="sif.Componentes.PC_GeneraCuentaFinanciera"
		 method="fnJSStringFormat"
		 returnvariable="LvarHilera"

		 hilera="#Arguments.hilera#" 
	 />
	<cfreturn LvarHilera>
</cffunction>

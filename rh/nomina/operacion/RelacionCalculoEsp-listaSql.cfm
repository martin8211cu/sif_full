<cfif isDefined("Form.btnNuevo")>
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	<cfset Action = "RelacionCalculoEsp.cfm">
<cfelse>
	<cfset Action = "ResultadoCalculoEsp-lista.cfm">
</cfif>
<cfif isDefined("Form.chk") and isDefined("Form.btnEliminar")>
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	<cfset Action = "RelacionCalculoEsp-lista.cfm">
	<cftry>
		<cfset vchk = ListToArray(Form.chk)>
		<cfloop from="1" index="i" to="#ArrayLen(vchk)#">            
			<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="BajaRCalculoNomina">
                <cfinvokeargument name="RCNid" 				value="#vchk[i]#">
                <cfinvokeargument name="TransacionActiva" 	value="false">
            </cfinvoke>    
		</cfloop>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<form action="#Action#" method="post" name="sql">
	<cfif not isDefined("Form.btnNuevo")>
    	<input name="RCNid" 	type="hidden" value="#Form.RCNid#">
		<input name="Tcodigo" 	type="hidden" value="#Form.Tcodigo#">
	</cfif>
</form>
</cfoutput>

<HTML>
	<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</HTML>
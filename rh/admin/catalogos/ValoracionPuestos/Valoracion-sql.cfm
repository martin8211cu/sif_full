<cfif isdefined('form.altaE')>
	<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnAltaE" returnvariable="RHEVFid">
        <cfinvokeargument name="RHEVFcodigo" 		value="#trim(form.RHEVFcodigo)#">
        <cfinvokeargument name="RHEVFdescripcion" 	value="#form.RHEVFdescripcion#">
        <cfinvokeargument name="RHEVFfecha" 		value="#lsdateformat(form.RHEVFfecha)#">
    </cfinvoke>
<cfelseif isdefined('form.cambioE')>
	<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnCambioE" returnvariable="RHEVFid">
    	<cfinvokeargument name="RHEVFid" 			value="#form.RHEVFid#">
        <cfinvokeargument name="RHEVFcodigo" 		value="#trim(form.RHEVFcodigo)#">
        <cfinvokeargument name="RHEVFdescripcion" 	value="#form.RHEVFdescripcion#">
        <cfinvokeargument name="RHEVFfecha" 		value="#lsdateformat(form.RHEVFfecha)#">
    </cfinvoke>
<cfelseif isdefined('form.bajaE')>
	<cftransaction>
    	<cfquery name="rsBajaD" datasource="#session.dsn#">
			select RHDVFid from RHDValoracionFactores where RHEVFid = #form.RHEVFid#
		</cfquery>
        <cfloop query="rsBajaD">
            <cfinvoke component="rh.Componentes.RH_Valoracion" method="fnBajaS">
                <cfinvokeargument name="RHDVFid" 			value="#rsBajaD.RHDVFid#">
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_Valoracion" method="fnBajaD">
                <cfinvokeargument name="RHDVFid" 			value="#rsBajaD.RHDVFid#">
            </cfinvoke>
        </cfloop>
        <cfinvoke component="rh.Componentes.RH_Valoracion" method="fnBajaE">
            <cfinvokeargument name="RHEVFid" 			value="#form.RHEVFid#">
        </cfinvoke>
    </cftransaction>
<cfelseif isdefined('form.altaD')>
	<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnAltaD" returnvariable="RHDVFid">
    	<cfinvokeargument name="RHEVFid" 			value="#form.RHEVFid#">
        <cfinvokeargument name="RHPcodigo" 			value="#form.RHPcodigo#">
        <cfinvokeargument name="RHDVFdesripcion" 	value="#form.RHDVFdesripcion#">
    </cfinvoke>
<cfelseif isdefined('form.cambioD')>
	<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnCambioD" returnvariable="RHDVFid">
    	<cfinvokeargument name="RHEVFid" 			value="#form.RHEVFid#">
    	<cfinvokeargument name="RHDVFid" 			value="#form.RHDVFid#">
        <cfinvokeargument name="RHPcodigo" 			value="#form.RHPcodigo#">
        <cfinvokeargument name="RHDVFdesripcion" 	value="#form.RHDVFdesripcion#">
    </cfinvoke>
<cfelseif isdefined('form.bajaD')>
	<cftransaction>
        <cfinvoke component="rh.Componentes.RH_Valoracion" method="fnBajaS">
            <cfinvokeargument name="RHDVFid" 			value="#form.RHDVFid#">
        </cfinvoke>
        <cfinvoke component="rh.Componentes.RH_Valoracion" method="fnBajaD">
            <cfinvokeargument name="RHDVFid" 			value="#form.RHDVFid#">
        </cfinvoke>
    </cftransaction>
<cfelseif isdefined('form.GuardarS')>
	<cftransaction>
        <cfloop list="#form.RHSVFid#" index="i">
        	<cfset RHSVFid = ListGetAt(i, 2, '|')>
            <cfset codigo = ListGetAt(i, 1, '|')>
            <cfset RHSVFgradoPropuesta = evaluate("RHSVFgradoPropuesta_" & ListGetAt(codigo, 1, '&') & "_" & ListGetAt(codigo, 2, '&'))>
            <cfset RHSVFpuntosPropuesta = evaluate("RHSVFpuntosPropuesta_" & ListGetAt(codigo, 1, '&') & "_" & ListGetAt(codigo, 2, '&'))>
            <cfinvoke component="rh.Componentes.RH_Valoracion" method="fnCambioS">
                <cfinvokeargument name="RHSVFid" 				value="#RHSVFid#">
                <cfinvokeargument name="RHSVFgradoPropuesta" 	value="#RHSVFgradoPropuesta#">
                <cfinvokeargument name="RHSVFpuntosPropuesta" 	value="#RHSVFpuntosPropuesta#">
            </cfinvoke>
        </cfloop>
    </cftransaction>
</cfif>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
	<cfoutput>
	<form name="form1" action="Valoracion.cfm" method="post">
    	<cfif isdefined('RHEVFid') and not isdefined('form.nuevoE') and not isdefined('form.bajaE')>
        	<input type="hidden" name="RHEVFid" value="#RHEVFid#"/>
        </cfif>
        <cfif isdefined('form.nuevoE')>
        	<input type="hidden" name="btnNuevo" value="btnNuevo"/>
        </cfif>
        <cfif isdefined('RHDVFid') and not isdefined('form.nuevoD') and not isdefined('form.bajaD')>
        	<input type="hidden" name="RHDVFid" value="#RHDVFid#"/>
        </cfif>
    </form>
    </cfoutput>
	<script language="javascript1.2" type="text/javascript">
    	document.form1.submit();
    </script>
</body>

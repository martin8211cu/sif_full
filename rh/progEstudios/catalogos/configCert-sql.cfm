<cfif isdefined('form.AltaEC')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaEConfig" returnvariable="RHECCBid">
        <cfinvokeargument name="RHTBid" 			value="#form.RHTBid#">
    </cfinvoke>
<cfelseif isdefined('form.BajaEC')>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaEConfig">
        <cfinvokeargument name="RHECCBid" 			value="#form.RHECCBid#">
    </cfinvoke>
    
<cfelseif isdefined('form.AltaDC')>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaDConfig">
        <cfinvokeargument name="RHECCBid" 				value="#form.RHECCBid#">
        <cfinvokeargument name="RHTBDFid" 				value="#form.RHTBDFid#">
        <cfinvokeargument name="RHDCCBcodigo" 			value="#trim(form.RHDCCBcodigo)#">
    </cfinvoke>
<cfelseif isdefined('form.CambioDC')>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioDConfig">
        <cfinvokeargument name="RHECCBid" 				value="#form.RHECCBid#">
        <cfinvokeargument name="RHTBDFid" 				value="#form.RHTBDFid#">
        <cfinvokeargument name="RHDCCBcodigo" 			value="#trim(form.RHDCCBcodigo)#">
    </cfinvoke>
<cfelseif isdefined('form.BajaDC')>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaDConfig">
        <cfinvokeargument name="RHECCBid" 				value="#form.RHECCBid#">
        <cfinvokeargument name="RHTBDFid" 				value="#form.RHTBDFid#">
    </cfinvoke>
</cfif>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
	<cfoutput>
	<form name="form1" action="configCert.cfm" method="post">
    	<cfif isdefined('RHECCBid') and not isdefined('form.NuevoEC') and not isdefined('form.BajaEC')>
        	<input type="hidden" name="RHECCBid" value="#RHECCBid#"/>
        </cfif>
    </form>
    </cfoutput>
	<script language="javascript1.2" type="text/javascript">
    	document.form1.submit();
    </script>
</body>
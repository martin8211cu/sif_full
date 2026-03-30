<cfif isdefined('form.Alta')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaFiadores" returnvariable="RHFid">
        <cfinvokeargument name="RHFcedula" 			value="#trim(form.RHFcedula)#">
        <cfinvokeargument name="RHFnombre" 			value="#form.RHFnombre#">
		<cfinvokeargument name="RHFapellido1" 		value="#form.RHFapellido1#">
        <cfinvokeargument name="RHFapellido2" 		value="#form.RHFapellido2#">
        <cfinvokeargument name="RHFestadoCivil" 	value="#form.RHFestadoCivil#">
        <cfinvokeargument name="RHFprovincia" 		value="#form.RHFprovincia#">
        <cfinvokeargument name="RHFcanton" 			value="#form.RHFcanton#">
        <cfinvokeargument name="RHFempresaLabora" 	value="#form.RHFempresaLabora#">
    </cfinvoke>
<cfelseif isdefined('form.Cambio')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioFiadores" returnvariable="RHFid">
   		<cfinvokeargument name="RHFid" 			value="#form.RHFid#">
        <cfinvokeargument name="RHFcedula" 			value="#trim(form.RHFcedula)#">
        <cfinvokeargument name="RHFnombre" 			value="#form.RHFnombre#">
		<cfinvokeargument name="RHFapellido1" 		value="#form.RHFapellido1#">
        <cfinvokeargument name="RHFapellido2" 		value="#form.RHFapellido2#">
        <cfinvokeargument name="RHFestadoCivil" 	value="#form.RHFestadoCivil#">
        <cfinvokeargument name="RHFprovincia" 		value="#form.RHFprovincia#">
        <cfinvokeargument name="RHFcanton" 			value="#form.RHFcanton#">
        <cfinvokeargument name="RHFempresaLabora" 	value="#form.RHFempresaLabora#">
    </cfinvoke>
<cfelseif isdefined('form.Baja')>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaFiadores">
        <cfinvokeargument name="RHFid" 			value="#form.RHFid#">
    </cfinvoke>
</cfif>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
	<cfoutput>
	<form name="form1" action="fiadores.cfm" method="post">
    	<cfif isdefined('RHFid') and not isdefined('form.Nuevo') and not isdefined('form.Baja')>
        	<input type="hidden" name="RHFid" value="#RHFid#"/>
        </cfif>
    </form>
    </cfoutput>
	<script language="javascript1.2" type="text/javascript">
    	document.form1.submit();
    </script>
</body>
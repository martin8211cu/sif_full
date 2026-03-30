<cfif isdefined('URL.RFCCURP') and URL.RFCCURP>
		<cfset Errores="">
	<cfif NOT ISDEFINED('URL.Fecha') OR (ISDEFINED('URL.Fecha') AND (NOT LEN(TRIM(URL.Fecha)) OR NOT ISDATE(URL.Fecha)))>
		<cfset Errores = Errores & '\n-La fecha de Nacimiento es Requerido'>
    </cfif>
    <cfif NOT ISDEFINED('URL.sexo') OR (ISDEFINED('URL.sexo') AND (NOT LEN(TRIM(URL.sexo)) OR NOT listfind('M,F',URL.sexo)))>
    	<cfset Errores = Errores & '\n-El sexo es requerido'>
    <cfelse>
    	<cfif URL.sexo EQ 'M'><cfset URL.sexo = 'H'><cfelse><cfset URL.sexo = 'M'></cfif>
    </cfif>
    <cfif NOT ISDEFINED('URL.nombre') OR (ISDEFINED('URL.nombre') AND (NOT LEN(TRIM(URL.nombre))))>
    	<cfset Errores = Errores & '\n-El nombre es Requerido'>
    </cfif>
     <cfif NOT ISDEFINED('URL.paterno') OR (ISDEFINED('URL.paterno') AND (NOT LEN(TRIM(URL.paterno))))>
    	<cfset Errores = Errores & '\n-El primer apellido es Requerido'>
    </cfif>
     <cfif NOT ISDEFINED('URL.materno') OR (ISDEFINED('URL.materno') AND (NOT LEN(TRIM(URL.materno))))>
    	<cfset Errores = Errores & '\n-El segundo apellido es Requerido'>
    </cfif>
     <cfif NOT ISDEFINED('URL.NivelCurp') OR (ISDEFINED('URL.NivelCurp') AND (LEN(TRIM(URL.NivelCurp)) LT 2) OR TRIM(URL.NivelCurp) EQ 'N/A')>
    	<cfset Errores = Errores & '\n-El Nivel CURP de la Dirección de nacimiento no esta Configurada'>
    </cfif>
     
    <cfif LEN(TRIM(Errores))>
    	<script type="text/javascript" language="javascript">
			alert('No se puedo calcular el RFC y EL CURP:<cfoutput>#Errores#</cfoutput>');
		</script>
     <cfelse>
     	<cfparam name="Request.CURPRFC" default="false">
		<cfif Request.CURPRFC EQ false>
            <cfset Request.RFC = true>
            <script language="JavaScript" src="../../js/calculo_RFC_CURP.js"></script>
        </cfif>
		<script language="javascript" type="text/javascript">
			STRUCT = fnCalculaCURP(<cfoutput>'#UCASE(URL.nombre)#', '#UCASE(URL.paterno)#', '#UCASE(URL.materno)#', '#UCASE(URL.fecha)#', '#UCASE(URL.sexo)#', '#UCASE(Left(TRIM(URL.NivelCurp),2))#'</cfoutput>);
			window.parent.document.getElementById('RFC').value=STRUCT[7];
			window.parent.document.getElementById('CURP').value =STRUCT[15];
		</script>
    </cfif>
<cfelse>
	<cfif isdefined('URL.fechaNac') and isdefined('URL.fechaHoy') and LEN(URL.fechaNac) and LEN(URL.fechaHoy) and IsDate(URL.fechaNac) and IsDate(URL.fechaHoy)>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="años" Default="años" returnvariable="LvarAños"/>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="año"  Default="año"  returnvariable="LvarAño"/>
        <cfset LvarCantAños = datediff('yyyy',lsparsedatetime(URL.fechaNac),lsparsedatetime(URL.fechaHoy))>
        <cfif LvarCantAños EQ 1>
            <cfset LvarLabelAños = LvarAño>
        <cfelse>
            <cfset LvarLabelAños = LvarAños>
        </cfif>
        <script type="text/javascript" language="javascript">
            window.parent.document.getElementById('anos').innerHTML = "<cfoutput>#LvarCantAños#&nbsp;#LvarLabelAños#</cfoutput>";
        </script>
    </cfif>
</cfif>
<cfset action = "becas.cfm">
<cfif isdefined('form.AltaEB')>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaEBE" returnvariable="RHEBEid">
        <cfinvokeargument name="RHTBid" 		value="#form.RHTBid#">
        <cfinvokeargument name="DEid" 			value="#form.DEid#">
        <cfinvokeargument name="RHEBEfecha" 	value="#form.RHEBEfecha#">
        <cfinvokeargument name="RHEBEestado" 	value="10">
    </cfinvoke>
<cfelseif isdefined('form.EliminarEB')>
	<cftransaction>
    	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaDBE">
        <cfinvokeargument name="RHEBEid" 			value="#form.RHEBEid#">
   		</cfinvoke>
        <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaEBE">
            <cfinvokeargument name="RHEBEid" 			value="#form.RHEBEid#">
        </cfinvoke>
    </cftransaction>
<cfelseif isdefined('form.AplicarEB')>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioEstadoEBE">
   		<cfinvokeargument name="RHEBEid" 			value="#form.RHEBEid#">
        <cfinvokeargument name="RHEBEestado" 		value="15">
    </cfinvoke>
<cfelseif isdefined('form.Guardar')>
	
    	<cfquery datasource="#session.dsn#">
            delete from  RHDBecasEmpleado
            where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEBEid#">
            and RHDBEversion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDBEversion#">
        </cfquery>
		<cfif isdefined("form.NombreConceptos")>
            <cfloop index="i" list="#form.NombreConceptos#" delimiters=",">
               <cfset lvarCodigo = Trim(i)>
               <cfset lvarMultiple = Evaluate("form.RHECBesMultiple_"& lvarCodigo) EQ 1>
               <cfset lvarActivo = false>
               <cfif not lvarMultiple>
                    <cfset lvarRHDCBtipo = Evaluate("form.RHDCBtipo_" & lvarCodigo & "_" & Evaluate(lvarCodigo))>
                    <cfset lvarConcepto = Evaluate("form." & lvarCodigo)>
                    <cfset lvarCodigo = Evaluate("form.Valor_" & lvarCodigo & "_" & Evaluate(lvarCodigo))>
                    <cfset lvarActivo = true>
               <cfelse>
                    <cfset lvarRHDCBtipo = Evaluate("form.RHDCBtipo_" & lvarCodigo)>
                    <cfset lvarConcepto = Evaluate("form.RHDCBid_" & lvarCodigo)>
                    <cfif isdefined('form.#lvarCodigo#')>
                        <cfset lvarActivo = true>
                    </cfif>
               </cfif>
               <cfset lvarValor = "null">
               <cfif lvarActivo and lvarRHDCBtipo neq 0>
                    <cfset lvarValor = Evaluate("form.RHDCBtipoValor_" & lvarCodigo)>
                </cfif>
                <cfif lvarRHDCBtipo eq 2>
                    <cfset lvarMoneda = Evaluate("form.Mcodigo" & lvarCodigo)>
                    <cfif len(trim(lvarMoneda)) eq 0>
                    	<cfset lvarMoneda = "null">
                    </cfif>
                    <cfset lvarValor = Replace(lvarValor,',','','ALL') & "|" & lvarMoneda>
                </cfif>
                <cfif lvarActivo>
                    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaDBE" returnvariable="RHDBEid">
                        <cfinvokeargument name="RHEBEid" 		value="#form.RHEBEid#">
                        <cfinvokeargument name="RHDCBid" 		value="#lvarConcepto#">
                        <cfinvokeargument name="RHDBEvalor" 	value="#lvarValor#">
                        <cfinvokeargument name="RHDBEversion" 	value="#form.RHDBEversion#">
                    </cfinvoke>
                </cfif>
            </cfloop>
        </cfif>
		<cfif isdefined("form.NombreDetalles")>
            <cfloop index="i" list="#form.NombreDetalles#" delimiters=",">
                <cfset lvarCodigo = Trim(i)>
                <cfset lvarDetalle = Evaluate(lvarCodigo)>
                <cfset lvarCapturaA = Evaluate("form.RHTBDFcapturaA_" & lvarDetalle)>
                <cfset lvarCapturaB = Evaluate("form.RHTBDFcapturaB_" & lvarDetalle)>
                <cfset lvarRHDCBid = "">
                <cfset lvarValor = "">
                <cfif lvarCapturaA eq 5>
                    <cfset lvarRHDCBid = Evaluate("form.RHDCBtipoValor_" & lvarCodigo)>
                <cfelseif lvarCapturaB eq 5>
                    <cfset lvarRHDCBid = Evaluate("form.RHDCBtipoValor_B_" & lvarCodigo)>
                </cfif>
                
                <cfif len(trim(lvarCapturaA)) gt 0 and lvarCapturaA neq 0 and lvarCapturaA neq 5>
                    <cfset lvarValor = Evaluate("form.RHDCBtipoValor_" & lvarCodigo)>
                    <cfif len(trim(lvarValor)) eq 0>
                    	<cfset lvarValor = "null">
                    </cfif>
                    <cfif lvarCapturaA eq 2>
                        <cfset lvarMoneda = Evaluate("form.Mcodigo" & lvarCodigo)>
                        <cfif len(trim(lvarMoneda)) eq 0>
                    		<cfset lvarMoneda = "null">
                    	</cfif>
                        <cfset lvarValor = Replace(lvarValor,',','','ALL') & "|" & lvarMoneda>
                    </cfif>
                </cfif>
                <cfif len(trim(lvarCapturaB)) gt 0 and lvarCapturaB neq 0 and lvarCapturaB neq 5>
                	<cfif len(trim(lvarValor)) gt 0>
                    	<cfset lvarValor = lvarValor & "##">
                    </cfif>
                    <cfset lvarValorTemp = Evaluate("form.RHDCBtipoValor_B_" & lvarCodigo)>
                    <cfif len(trim(lvarValorTemp)) eq 0>
                    	 <cfset lvarValorTemp = "null">
                    </cfif>
                    <cfset lvarValor = lvarValor & lvarValorTemp>
                    <cfif lvarCapturaB eq 2>
                        <cfset lvarMoneda = Evaluate("form.McodigoB_" & lvarCodigo)>
                        <cfif len(trim(lvarMoneda)) eq 0>
                    		<cfset lvarMoneda = "null">
                    	</cfif>
                        <cfset lvarValor = Replace(lvarValor,',','','ALL') & "|" & lvarMoneda>
                    </cfif>
               </cfif>
               <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaDBE">
                    <cfinvokeargument name="RHEBEid" 		value="#form.RHEBEid#">
                    <cfinvokeargument name="RHTBDFid" 		value="#lvarDetalle#">
                    <cfinvokeargument name="RHDBEvalor" 	value="#lvarValor#">
                    <cfinvokeargument name="RHDBEversion" 	value="#form.RHDBEversion#">
                    <cfif len(trim(lvarRHDCBid))>
                         <cfinvokeargument name="RHDCBid" 	value="#lvarRHDCBid#">
                    </cfif>
               </cfinvoke>
            </cfloop>
        </cfif>
	<cfelseif isdefined('form.AprobarCom')>
	<cftransaction>
        <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioEstadoEBE">
            <cfinvokeargument name="RHEBEid" 					value="#form.RHEBEid#">
            <cfinvokeargument name="RHEBEestado" 				value="70">
            <cfinvokeargument name="RHEBEsesionCom" 			value="#form.RHEBEsesionCom#">
            <cfinvokeargument name="RHEBEarticuloCom" 			value="#form.RHEBEarticuloCom#">
            <cfinvokeargument name="RHEBEfechaCom" 				value="#LSDateFormat(form.RHEBEfechaCom)#">
            <cfinvokeargument name="RHEBEusuarioACom"  			value="#session.Usucodigo#">
            <cfinvokeargument name="RHEBEacuerdo"  				value="#form.RHEBEacuerdo#">
        </cfinvoke>
    <cfloop list="#form.DEids#" index="LvarDEid">
    	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaFBecas">
            <cfinvokeargument name="RHEBEid" 					value="#form.RHEBEid#">
            <cfinvokeargument name="DEid" 					value="#LvarDEid#">
        </cfinvoke>
    </cfloop>
     <cfloop list="#form.RHFids#" index="LvarRHFid">
    	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaFBecas">
            <cfinvokeargument name="RHEBEid" 					value="#form.RHEBEid#">
            <cfinvokeargument name="RHFid" 					value="#LvarRHFid#">
        </cfinvoke>
    </cfloop>
    </cftransaction>
<cfelseif isdefined('form.accion') and form.accion eq 'RechazarCom'>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioEstadoEBE">
        <cfinvokeargument name="RHEBEid" 					value="#form.RHEBEid#">
        <cfinvokeargument name="RHEBEestado" 				value="60">
        <cfinvokeargument name="RHEBEjustificacionCom" 		value="#form.RHEBEjustificacionCom#">
        <cfinvokeargument name="RHEBEusuarioRCom"  			value="#session.Usucodigo#">
    </cfinvoke>
    <cfset RechazarCom = "RechazarCom">
<cfelseif isdefined('form.Subir')>
	<cfquery name="rsdataObj" datasource="#session.DSN#">
        select ltrim(rtrim(RHEBEarchivo)) as RHEBEarchivo, ltrim(rtrim(RHEBErutaPlan)) as RHEBErutaPlan
        from RHEBecasEmpleado
        where  RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEBEid#">  
    </cfquery>
	<cftry>
		<cfset error = false >
        <cfset rootdir = ExpandPath('') >
        <cfset ruta = "#rootdir#/rh/progEstudios/archivos">
        <cfset ruta = replace(ruta,'\','/', 'ALL')>
        <cfset filename = replace(form.RHEBErutaPlan, '\', '/', 'all') >
        <cfset temp_arreglo = listtoarray(filename, '/') >
        <cfset filename = trim(temp_arreglo[arraylen(temp_arreglo)]) >
        <cfset nombre_arreglo = listtoarray(filename, '.') >

        <cfif not directoryexists(ruta)>
            <cfset error = true >
        </cfif>
        <cfif not error >
            <cffile action="upload" destination="#ruta#" nameConflict="overwrite" fileField="form.RHEBErutaPlan">
            <cfset Actual  = cffile.serverDirectory & '\' & cffile.serverFile>
            <cfset list1 = " ,á,é,í,ó,ú,Á,É,Í,Ó,Ú,Ñ,ñ">
            <cfset list2 = "_,a,e,i,o,u,a,e,i,o,u,n,n">
            <cfset nombreArchivo = ReplaceList(cffile.serverFile,list1,list2)>	
            <cfset Nuevo   = cffile.serverDirectory & '\' & form.RHEBEid & '_' & nombreArchivo>
            <cffile action="rename" source="#Actual#" destination="#Nuevo#" attributes="normal"> 
        </cfif>
        <cfcatch type="any">
            <cfset error = true >
            <cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail#">
        </cfcatch>	
    </cftry>
    <cfif not error>
    	<cfif len(trim(rsdataObj.RHEBErutaPlan)) gt 0 and len(trim(rsdataObj.RHEBEarchivo))>
			<cfset full_path_name = rsdataObj.RHEBErutaPlan & '\' & rsdataObj.RHEBEarchivo>
            <cffile action = "delete"	file = "#full_path_name#">
        </cfif>
        <cfquery datasource="#Session.DSN#">
            update RHEBecasEmpleado set 
                RHEBErutaPlan = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#cffile.serverDirectory#">,
                RHEBEarchivo = '#form.RHEBEid#_#nombreArchivo#'
            where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEBEid#">
        </cfquery>
    </cfif>
<cfelseif isdefined('form.AprobarVic')>
	<cftransaction>
        <cfloop list="#form.chk#" index="LvarRHEBEid">
            <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioEstadoEBE">
                <cfinvokeargument name="RHEBEid" 					value="#LvarRHEBEid#">
                <cfinvokeargument name="RHEBEestado" 				value="50">
                <cfinvokeargument name="RHEBEusuarioAVic"  			value="#session.Usucodigo#">
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCrearCopiaEBE">
                <cfinvokeargument name="RHEBEid" 					value="#LvarRHEBEid#">
            </cfinvoke>
        </cfloop>
    </cftransaction>
    <cfset action = "RegBecasVic.cfm">
<cfelseif  isdefined('form.botonSel') and form.botonSel eq 'RechazarVic'>
	<cftransaction>
        <cfloop list="#form.chk#" index="LvarRHEBEid">
            <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioEstadoEBE">
                <cfinvokeargument name="RHEBEid" 					value="#LvarRHEBEid#">
                <cfinvokeargument name="RHEBEestado" 				value="40">
                <cfinvokeargument name="RHEBEjustificacionVic" 		value="#form.RHEBEjustificacionVic#">
                <cfinvokeargument name="RHEBEusuarioRVic"  			value="#session.Usucodigo#">
            </cfinvoke>
        </cfloop>
    </cftransaction>
    <cfset RechazarVic = "RechazarVic">
    <cfset action = "RegBecasVic.cfm">
</cfif>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
	<cfoutput>
	<form name="form1" action="#action#" method="post">
    	<cfif isdefined('RHEBEid') and not isdefined('form.EliminarEB') and not isdefined('form.AplicarEB') and not isdefined('AprobarCom') and not isdefined('RechazarCom') and not isdefined('AprobarVic') and not isdefined('RechazarVic')>
        	<input type="hidden" name="RHEBEid" value="#RHEBEid#"/>
        </cfif>
    </form>
    </cfoutput>
	<script language="javascript1.2" type="text/javascript">
		<cfif isdefined('AprobarCom')>
			window.opener.document.location = "becas.cfm";
			window.close();
		<cfelse>
    		document.form1.submit();
		</cfif>
    </script>
</body>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined('form.AltaB')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaBeca" returnvariable="RHTBid">
        <cfinvokeargument name="RHTBcodigo" 			value="#trim(form.RHTBcodigo)#">
        <cfinvokeargument name="RHTBdescripcion" 		value="#form.RHTBdescripcion#">
        <cfif isdefined('form.RHTBesCorporativo')>
        	<cfinvokeargument name="RHTBesCorporativo" 	value="1">
        <cfelse>
        	<cfinvokeargument name="RHTBesCorporativo" 	value="0">
        </cfif>
    </cfinvoke>
<cfelseif isdefined('form.CambioB')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioBeca" returnvariable="RHTBid">
        <cfinvokeargument name="RHTBid" 				value="#form.RHTBid#">
        <cfinvokeargument name="RHTBcodigo" 			value="#trim(form.RHTBcodigo)#">
        <cfinvokeargument name="RHTBdescripcion" 		value="#form.RHTBdescripcion#">
        <cfif isdefined('form.RHTBesCorporativo')>
        	<cfinvokeargument name="RHTBesCorporativo" 	value="1">
        <cfelse>
        	<cfinvokeargument name="RHTBesCorporativo" 	value="0">
        </cfif>
    </cfinvoke>
<cfelseif isdefined('form.BajaB')>
	<!---	select DEnombre#LvarCNCT# ' '#LvarCNCT# DEapellido1 #LvarCNCT# ' '#LvarCNCT# DEapellido2 as nombre 
	from RHEBecasEmpleado b
			inner join DatosEmpleado d
			on d.DEid=b.DEid
			where RHTBid=#form.RHTBid#--->
			
		<cfquery name="val" datasource="#session.dsn#">	
			select 'Fecha: ' #LvarCNCT#<cf_dbfunction name="date_format" args="RHEBEfechaJef,dd-mm-yyyy">#LvarCNCT#'/'#LvarCNCT#' '#LvarCNCT# 'Becado: ' #LvarCNCT#e.DEnombre#LvarCNCT#' ' #LvarCNCT#e.DEapellido1#LvarCNCT#' '
			#LvarCNCT#e.DEapellido2 #LvarCNCT# '/' #LvarCNCT# ' '#LvarCNCT#
			'Fiador: '#LvarCNCT#' '#LvarCNCT#d.DEnombre#LvarCNCT#' '#LvarCNCT#d.DEapellido1#LvarCNCT#' '#LvarCNCT# d.DEapellido2 as fiador
				from  RHEBecasEmpleado b
					left outer join RHFiadoresBecasEmpleado fb
						inner join DatosEmpleado d
						on d.DEid=fb.DEid
					on fb.RHEBEid = b.RHEBEid
				inner join DatosEmpleado e
				on e.DEid=b.DEid	
			where  RHTBid=#form.RHTBid#
		</cfquery>
 		<cfset Lvar=Valuelist(val.fiador,',')>
		
 		<cfif val.recordcount EQ 0>
			<cftransaction>
				<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBC">
					<cfinvokeargument name="RHTBid" 			value="#form.RHTBid#">
				</cfinvoke>
				<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBDF">
					<cfinvokeargument name="RHTBid" 			value="#form.RHTBid#">
					<cfinvokeargument name="TransaccionActiva" 	value="true">
				</cfinvoke>
				<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBEF">
					<cfinvokeargument name="RHTBid" 			value="#form.RHTBid#">
				</cfinvoke>
				<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBeca">
					<cfinvokeargument name="RHTBid" 			value="#form.RHTBid#">
				</cfinvoke>
			</cftransaction>
		<cfelse>
			<cfthrow message="No se puede eliminar el registro porque tiene Colaboradores asociados (#Lvar#)">
		</cfif>

<cfelseif isdefined('form.AltaBC')>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaBC">
        <cfinvokeargument name="RHTBid" 				value="#form.RHTBid#">
        <cfinvokeargument name="RHECBid" 				value="#form.RHECBid#">
    </cfinvoke>
<cfelseif isdefined('form.BajaBC')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBC">
        <cfinvokeargument name="RHTBid" 				value="#form.RHTBid#">
        <cfinvokeargument name="RHECBid" 				value="#form.RHECBid#">
    </cfinvoke>
<cfelseif isdefined('form.AltaBEF')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaBEF" returnvariable="RHTBEFid">
        <cfinvokeargument name="RHTBid" 				value="#form.RHTBid#">
        <cfinvokeargument name="RHTBEFcodigo" 			value="#trim(form.RHTBEFcodigo)#">
        <cfinvokeargument name="RHTBEFdescripcion" 		value="#form.RHTBEFdescripcion#">
        <cfinvokeargument name="RHTBEFfecha" 			value="#form.RHTBEFfecha#">
    </cfinvoke>
<cfelseif isdefined('form.CambioBEF')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioBEF" returnvariable="RHTBEFid">
    	<cfinvokeargument name="RHTBEFid" 				value="#form.RHTBEFid#">
        <cfinvokeargument name="RHTBid" 				value="#form.RHTBid#">
        <cfinvokeargument name="RHTBEFcodigo" 			value="#trim(form.RHTBEFcodigo)#">
        <cfinvokeargument name="RHTBEFdescripcion" 		value="#form.RHTBEFdescripcion#">
        <cfinvokeargument name="RHTBEFfecha" 			value="#form.RHTBEFfecha#">
    </cfinvoke>
<cfelseif isdefined('form.BajaBEF')>
	<cftransaction>
    	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBDF">
    		<cfinvokeargument name="RHTBEFid" 			value="#form.RHTBEFid#">
			<cfinvokeargument name="TransaccionActiva" 	value="true">
    	</cfinvoke>
        <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBEF">
            <cfinvokeargument name="RHTBEFid" 			value="#form.RHTBEFid#">
        </cfinvoke>
    </cftransaction>
<cfelseif isdefined('form.AltaBDF')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaBDF" returnvariable="RHTBDFid">
        <cfinvokeargument name="RHTBEFid" 				value="#form.RHTBEFid#">
        <cfinvokeargument name="RHTBDForden" 			value="#form.RHTBDForden#">
        <cfinvokeargument name="RHTBDFetiqueta" 		value="#form.RHTBDFetiqueta#">
        <cfinvokeargument name="RHTBDFfuente" 			value="#form.RHTBDFfuente#">
        <cfif isdefined('form.RHTBDFnegrita')>
       	 	<cfinvokeargument name="RHTBDFnegrita" 		value="1">
       	</cfif>
        <cfif isdefined('form.RHTBDFitalica')>
       	 	<cfinvokeargument name="RHTBDFitalica" 		value="1">
       	</cfif>
        <cfif isdefined('form.RHTBDFsubrayado')>
       	 	<cfinvokeargument name="RHTBDFsubrayado" 	value="1">
       	</cfif>
        <cfif ( ListFind('2,3', form.RHTBDFcapturaA) or ListFind('2,3', form.RHTBDFcapturaB) ) and isdefined('form.RHTBDFnegativos')>
       	 	<cfinvokeargument name="RHTBDFnegativos" 	value="1">
       	</cfif>
        <cfinvokeargument name="RHTBDFtamFuente" 		value="#form.RHTBDFtamFuente#">
        <cfinvokeargument name="RHTBDFcolor" 			value="#form.RHTBDFcolor#">
        <cfinvokeargument name="RHTBDFcapturaA" 		value="#form.RHTBDFcapturaA#">
        <cfif isdefined('form.RHTBDFcapturaB') and form.RHTBDFcapturaB gt 0>
       	 	<cfinvokeargument name="RHTBDFcapturaB" 	value="#form.RHTBDFcapturaB#">
       	</cfif>
        <cfif form.RHTBDFcapturaA eq 5 or form.RHTBDFcapturaB eq 5>
       	 	<cfinvokeargument name="RHECBid" 			value="#form.RHECBid#">
       	</cfif>
        <cfif isdefined('form.RHTBDFbeneficio')>
       	 	<cfinvokeargument name="RHTBDFbeneficio" 	value="1">
       	</cfif>
        <cfif len(trim(form.RHTBDFreporte)) gt 0>
       	 	<cfinvokeargument name="RHTBDFreporte" 		value="#form.RHTBDFreporte#">
       	</cfif>
        <cfif isdefined('form.RHTBDFrequerido')>
       	 	<cfinvokeargument name="RHTBDFrequerido" 	value="1">
       	</cfif> 
    </cfinvoke>
<cfelseif isdefined('form.CambioBDF')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioBDF" returnvariable="RHTBDFid">
    	<cfinvokeargument name="RHTBDFid" 				value="#form.RHTBDFid#">
        <cfinvokeargument name="RHTBEFid" 				value="#form.RHTBEFid#">
        <cfinvokeargument name="RHTBDForden" 			value="#form.RHTBDForden#">
        <cfinvokeargument name="RHTBDFetiqueta" 		value="#form.RHTBDFetiqueta#">
        <cfinvokeargument name="RHTBDFfuente" 			value="#form.RHTBDFfuente#">
        <cfif isdefined('form.RHTBDFnegrita')>
       	 	<cfinvokeargument name="RHTBDFnegrita" 		value="1">
       	</cfif>
        <cfif isdefined('form.RHTBDFitalica')>
       	 	<cfinvokeargument name="RHTBDFitalica" 		value="1">
       	</cfif>
        <cfif isdefined('form.RHTBDFsubrayado')>
       	 	<cfinvokeargument name="RHTBDFsubrayado" 	value="1">
       	</cfif>
        <cfif ( ListFind('2,3', form.RHTBDFcapturaA) or ListFind('2,3', form.RHTBDFcapturaB) ) and isdefined('form.RHTBDFnegativos')>
       	 	<cfinvokeargument name="RHTBDFnegativos" 	value="1">
       	</cfif>
        <cfinvokeargument name="RHTBDFtamFuente" 		value="#form.RHTBDFtamFuente#">
        <cfinvokeargument name="RHTBDFcolor" 			value="#form.RHTBDFcolor#">
        <cfinvokeargument name="RHTBDFcapturaA" 		value="#form.RHTBDFcapturaA#">
         <cfif isdefined('form.RHTBDFcapturaB') and form.RHTBDFcapturaB gt 0>
       	 	<cfinvokeargument name="RHTBDFcapturaB" 	value="#form.RHTBDFcapturaB#">
       	</cfif>
        <cfif form.RHTBDFcapturaA eq 5 or form.RHTBDFcapturaB eq 5>
       	 	<cfinvokeargument name="RHECBid" 			value="#form.RHECBid#">
       	</cfif>
        <cfif isdefined('form.RHTBDFbeneficio')>
       	 	<cfinvokeargument name="RHTBDFbeneficio" 	value="1">
       	</cfif>
        <cfif len(trim(form.RHTBDFreporte)) gt 0>
       	 	<cfinvokeargument name="RHTBDFreporte" 		value="#form.RHTBDFreporte#">
       	</cfif>
        <cfif isdefined('form.RHTBDFrequerido')>
       	 	<cfinvokeargument name="RHTBDFrequerido" 	value="1">
       	</cfif>
    </cfinvoke>
<cfelseif isdefined('form.BajaBDF')>
	<cfquery name="valida" datasource="#session.dsn#">
		select 'Fecha: ' #LvarCNCT# <cf_dbfunction name="date_format" args="RHEBEfechaJef,dd-mm-yyyy">#LvarCNCT#'/'#LvarCNCT#' '#LvarCNCT# 'Becado: ' #LvarCNCT#e.DEnombre#LvarCNCT#' ' #LvarCNCT#e.DEapellido1#LvarCNCT#' '
		#LvarCNCT#e.DEapellido2 #LvarCNCT# '/' #LvarCNCT# ' '#LvarCNCT#
		'Fiador: '#LvarCNCT#' '#LvarCNCT#d.DEnombre#LvarCNCT#' '#LvarCNCT#d.DEapellido1#LvarCNCT#' '#LvarCNCT# d.DEapellido2 as fiador
			from RHDBecasEmpleado a
			inner join RHEBecasEmpleado b
				inner join RHFiadoresBecasEmpleado fb
							inner join DatosEmpleado d
						   on d.DEid=fb.DEid
						on fb.RHEBEid = b.RHEBEid
				inner join DatosEmpleado e
				on e.DEid=b.DEid
			on a.RHEBEid=b.RHEBEid
			where  RHTBDFid=#form.RHTBDFid#
			
	</cfquery>
	<cfset LvarDos=ValueList(valida.fiador,',')>
	<cfif valida.recordcount eq 0>
		<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBDF">
			<cfinvokeargument name="RHTBDFid" 				value="#form.RHTBDFid#">
		</cfinvoke>
	<cfelse>
		<cfthrow message="No se puede eliminar el registro porque tiene becados asociados (#LvarDos#)">
	</cfif>
<cfelseif isdefined('form.CambiarGrado')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioBDFGrado">
    	<cfinvokeargument name="RHTBDFid" 				value="#form.RHTBDFid#">
        <cfinvokeargument name="Posicion" 				value="#form.RHTBDForden + form.Posicion#">
    </cfinvoke>
</cfif>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
	<cfoutput>
	<form name="form1" action="becas.cfm" method="post">
    	<cfif isdefined('RHTBid') and not isdefined('form.NuevoB') and not isdefined('form.BajaB')>
        	<input type="hidden" name="RHTBid" value="#RHTBid#"/>
        </cfif>
        <cfif isdefined('form.AltaBC') or isdefined('form.BajaBC')>
        	<input type="hidden" name="ConceptosB" value="ConceptosB"/>
        </cfif>
        <cfif isdefined('form.AltaBEF') or isdefined('form.CambioBEF') or isdefined('form.BajaBEF') or isdefined('form.NuevoBEF') or isdefined('form.AltaBDF') or isdefined('form.CambioBDF') or isdefined('form.BajaBDF') or isdefined('form.NuevoBDF') or isdefined('form.CambiarGrado')>
        	<input type="hidden" name="FormatosB" value="FormatosB"/>
        </cfif>
        <cfif isdefined('RHTBEFid') and not isdefined('form.BajaBEF') and not isdefined('form.NuevoBEF')>
        	<input type="hidden" name="RHTBEFid" value="#RHTBEFid#"/>
        </cfif>
    </form>
    </cfoutput>
	<script language="javascript1.2" type="text/javascript">
    	document.form1.submit();
    </script>
</body>
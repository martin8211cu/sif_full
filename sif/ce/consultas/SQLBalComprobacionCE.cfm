<cfif isdefined('form.btnGenerar')>

	<cfif isdefined('form.periodo') and form.periodo NEQ ''>
    	<cfset Periodo = #form.periodo#>
    </cfif>

    <cfif isdefined('form.mes') and form.mes NEQ ''>
    	<cfset Mes = #form.mes#>
    </cfif>

    <cfif isdefined('form.CAgrupador') and len(form.CAgrupador) GT 0>
    	<cfset idAgrupador = #form.CAgrupador#>
    </cfif>

	<cfif not isdefined('form.hdGEid')>
		<cfset form.hdGEid = -1>
	</cfif>
    <!---<cfif isdefined('form.nivel') and form.nivel NEQ -1>--->
    	<cfset Nivel = #form.nivel#>
    <!---<cfelse>
        <cfset Nivel = #hdNivelDef#>
    </cfif>--->

    <cfif isdefined('chkSaldoCeros')>
    	<cfset SaldoCeros = 'S'>
   	<cfelse>
        <cfset SaldoCeros = 'N'>
   	</cfif>

    <!---SML 16042015. Inicio Obtiene la moneda depende del RadioButton que seleccione en el form--->
    <cfif isdefined('form.rdMoneda') and #form.rdMoneda# EQ -2>
    	<cfset LvarTipoMoneda = 'L'>
    	<cfset LvarMcodigo = #form.hdMonedaLocal#>
        <cfset LvarMoneda = -2>
    <cfelseif isdefined('form.rdMoneda') and #form.rdMoneda# EQ -4>
    	<cfset LvarTipoMoneda = 'I'>
    	<cfset LvarMcodigo = #form.hdMonedaInforme#>
        <cfset LvarMoneda = -4>
    </cfif>
    <!---SML 16042015. Fin Obtiene la moneda depende del RadioButton que seleccione en el form--->

    <cfinvoke method="ConBalCompSAT" component="sif.ce.Componentes.BalComprobacionCE" returnvariable="idBalCompSAT">
    	<cfinvokeargument name="Periodo" 	value="#Periodo#">
        <cfinvokeargument name="Mes" 		value="#Mes#">
        <cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#">
		<cfinvokeargument name="GEid" 		value="#form.hdGEid#">
    </cfinvoke>

    <cfinvoke method="EstBalCompSAT" component="sif.ce.Componentes.BalComprobacionCE" returnvariable="estBalCompSAT">
    	<cfinvokeargument name="Periodo" 	value="#Periodo#">
        <cfinvokeargument name="Mes" 		value="#Mes#">
        <cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#">
		<cfinvokeargument name="GEid" 		value="#form.hdGEid#">
    </cfinvoke>

    <cfif isdefined('estBalCompSAT') and #estBalCompSAT# EQ 0> <!---and len(trim(#insBalCompSAT.identity#)) GT 0--->

    	<cfinvoke method="ConBalCompSAT" component="sif.ce.Componentes.BalComprobacionCE" returnvariable="ValPreBalCompSATP">
    		<cfinvokeargument name="Periodo" 	value="#Periodo#">
        	<cfinvokeargument name="Mes" 		value="#Mes#">
			<cfinvokeargument name="GEid" 		value="#form.hdGEid#">
    	</cfinvoke>

    	<!---Elimina la balanza de comprobacion para que actualice los saldos hasta la fecha actual--->
        <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="EliminarBalCompSAT">
            <cfinvokeargument name="Periodo"   value="#Periodo#">
            <cfinvokeargument name="Mes"   	   value="#Mes#">
            <cfinvokeargument name="Ecodigo"   value="#Session.Ecodigo#">
			<cfinvokeargument name="GEid" 		value="#form.hdGEid#">
        </cfinvoke>

	</cfif>

    <!---Obtiene el id de la balanza de comprobacion que se inserta en la tabla CGRBalanceComprobacion y DCGRBalanceComprobacion--->
	<cftry>
	     <cfinvoke returnvariable="rs_Res" component="sif.Componentes.sp_SIF_CG0004" method="balanceComprob">
	         <cfinvokeargument name="periodo"   value="#Periodo#">
	         <cfinvokeargument name="mes"   	value="#Mes#">
	         <cfinvokeargument name="nivel"  	value="#Nivel#">
				<cfinvokeargument name="Mcodigo"   	value="#LvarMoneda#">
	         <cfinvokeargument name="Ecodigo"   value="#Session.Ecodigo#">
				<cfinvokeargument name="myGEid"   	value="#form.hdGEid#">
	         <cfinvokeargument name="ceros"   	value="#SaldoCeros#">
	         <cfinvokeargument name="Mcodigo"   value="#LvarMoneda#">
	     </cfinvoke>

		<!--- Si es la Balanza en modeda informe del mes 12 REQUERIMIENTO PMI --->
		<cfif isdefined('form.rdMoneda') and #form.rdMoneda# EQ -4>
			<cfinvoke returnvariable="rs_ResL" component="sif.Componentes.sp_SIF_CG0004" method="balanceComprob">
		         <cfinvokeargument name="periodo"   value="#Periodo#">
		         <cfinvokeargument name="mes"   	value="#Mes#">
		         <cfinvokeargument name="nivel"  	value="#Nivel#">
				 <cfinvokeargument name="Mcodigo"   value="-2">
		         <cfinvokeargument name="Ecodigo"   value="#Session.Ecodigo#">
				 <cfinvokeargument name="myGEid"   	value="#form.hdGEid#">
		         <cfinvokeargument name="ceros"   	value="#SaldoCeros#">
		         <cfinvokeargument name="Mcodigo"   value="-2">
		     </cfinvoke>
			<cfquery datasource="#Session.DSN#">
				update bc set CGRBCid = #rs_Res#
				from DCGRBalanceComprobacion bc
				inner join CtasMayor cm
					on cm.Cmayor = bc.mayor
					and cm.Ecodigo = bc.Ecodigo
				where CGRBCid = #rs_ResL#
					and cm.Ctipo = 'O'
			</cfquery>
		</cfif>

	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
     <!---Consulta las tablas donde se genero la balanza de comprobacion del modulo de Contabilidad y se valida con las cuentas de mapeo--->
     <cfinvoke component="sif.ce.Componentes.ValidacionMapeo" method="ValMapeoCtasContables" returnvariable="esValido">
         <cfinvokeargument name="idAgrupador"   value="#idAgrupador#">
         <cfinvokeargument name="Periodo"   	value="#Periodo#">
         <cfinvokeargument name="Mes"           value="#Mes#">
         <cfinvokeargument name="Nivel"         value="#Nivel#">
		<cfinvokeargument name="GEid"   	value="#form.hdGEid#">
     </cfinvoke>

     <cfif isdefined('esValido') and esValido>

         <!---Insertar en las tablas de la balanza de Comprobacion para el SAT--->
         <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="GenerarBalCompSAT" returnvariable="idBalCompSAT">
             <cfinvokeargument name="idBalComp"   value="#rs_Res#">
             <cfinvokeargument name="Periodo"     value="#Periodo#">
             <cfinvokeargument name="Mes"   	  value="#Mes#">
             <cfinvokeargument name="Nivel"       value="#Nivel#">
             <cfinvokeargument name="idAgrupador" value="#idAgrupador#">
             <cfinvokeargument name="Mcodigo"     value="#LvarMcodigo#">
             <cfinvokeargument name="TipoMoneda"  value="#LvarTipoMoneda#">
			 <cfinvokeargument name="idBalCompAnt"  value="#idBalCompSAT#">
			 <cfinvokeargument name="GEid"   		value="#form.hdGEid#">
         </cfinvoke>
         <!---Se realizar el reporte en otra archivo para tener mayor rendimiento--->

         <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="BalCompSAT" returnvariable="rsReporte">
             <cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
             <cfinvokeargument name="Periodo"     value="#Periodo#">
             <cfinvokeargument name="Mes"         value="#Mes#">
         </cfinvoke>

         <cfinclude template="repBalComprobacionCE.cfm">

     <cfelse>
		<cfif form.hdGEid NEQ "-1" and form.hdGEid NEQ "">
			<cflocation url = "/cfmx/sif/ce/GrupoEmpresas/consultas/BalComprobacionCE.cfm?Errores=true" addtoken="no">
     	<cfelse>
     	<cflocation url = "/cfmx/sif/ce/consultas/BalComprobacionCE.cfm?Errores=true" addtoken="no">
		</cfif>
     </cfif>
   <!---  <cfelse>
    	 <!---Se realizar el reporte en otra archivo para tener mayor rendimiento--->
    	<cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="BalCompSAT" returnvariable="rsReporte">
        	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
            <cfinvokeargument name="Periodo"   value="#Periodo#">
            <cfinvokeargument name="Mes"   value="#Mes#">
        </cfinvoke>

        <cfinclude template="repBalComprobacionCE.cfm">
    </cfif> --->

<cfelseif isdefined('form.btnDownload')>

    <cfif isdefined('url.idBalCompSAT') and len(#url.idBalCompSAT#) GT 0>
    	<cfset idBalCompSAT = #url.idBalCompSAT#>
    </cfif>

	<cfif isdefined('form.periodo') and form.periodo NEQ -1>
    	<cfset Periodo = #form.periodo#>
    </cfif>

    <cfif isdefined('form.mes') and form.mes NEQ -1>
    	<cfset Mes = #form.mes#>
    </cfif>

    <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="BalCompSAT" returnvariable="rsReporte">
    	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
        <cfinvokeargument name="Periodo"   	 value="#Periodo#">
        <cfinvokeargument name="Mes"   		 value="#Mes#">
    </cfinvoke>

    <cfinclude template="repBalComprobacionCE.cfm">

<cfelseif isdefined('form.btnPrepXML')>

	<cfif isdefined('form.idBalCompSAT') and len(trim(form.idBalCompSAT)) GT 0>
    	<cfset idBalCompSAT = #form.idBalCompSAT#>
    </cfif>

	<cfquery name="rshayBalanza" datasource="#session.DSN#">
    	SELECT COUNT(1) as cantidad
        FROM CEBalanzaSAT
        WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CEBmes <> (select CEBmes from CEBalanzaSAT where CEBalanzaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalCompSAT#">
			and GEid <> -1)
    </cfquery>

    <cfquery name="rshayBalanzasP" datasource="#session.DSN#">
        SELECT top 1 a.*
        FROM
            (SELECT CEBmes,CEBperiodo
            FROM CEBalanzaSAT
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                AND CEBalanzaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalCompSAT#">
				and GEid = -1
			) as BalanzaActual
            INNER JOIN CEBalanzaSAT a
                ON a.CEBperiodo >= BalanzaActual.CEBperiodo
                   AND a.CEBmes > BalanzaActual.CEBmes
        WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    </cfquery>
    <cfif isdefined('rshayBalanzasP') and rshayBalanzasP.RecordCount EQ 0 and
		  isdefined('rshayBalanza') and rshayBalanza.cantidad GT 1>
        <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="ValPreBalCompSATA" returnvariable="estaPreparadaA">
            <cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
        </cfinvoke>
    </cfif>

    <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="ValPreBalCompSATP" returnvariable="estaPreparadaP">
    	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
    </cfinvoke>

    <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="PrepararBalCompSAT">
    	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
    </cfinvoke>


    <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="BalCompSAT" returnvariable="rsReporte">
    	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
    </cfinvoke>

	<cfinclude template="repBalComprobacionCE.cfm">
<cfelseif isdefined('form.mostrarBal')>

	<cfif isdefined('form.mostrarBal') and len(trim(form.mostrarBal)) GT 0>
    	<cfset idBalCompSAT = #form.mostrarBal#>
    </cfif>

    <!--- <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="ValPreBalCompSATA" returnvariable="estaPreparadaA">
    	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
    </cfinvoke>

    <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="ValPreBalCompSATP" returnvariable="estaPreparadaP">
    	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
    </cfinvoke>

    <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="PrepararBalCompSAT">
    	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
    </cfinvoke> --->


    <cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="BalCompSAT" returnvariable="rsReporte">
    	<cfinvokeargument name="idBalComp"   value="#idBalCompSAT#">
    </cfinvoke>

    <cfinclude template="repBalComprobacionCE.cfm">

<cfelseif isdefined('form.btnRegresar')>
	<cfif isdefined('form.hdGEid') and form.hdGEid NEQ "-1" and form.hdGEid NEQ "">
		<cflocation url = "/cfmx/sif/ce/GrupoEmpresas/consultas/BalComprobacionCE.cfm" addtoken="no">
     	<cfelse>
     		<cflocation url = "/cfmx/sif/ce/consultas/BalComprobacionCE.cfm" addtoken="no">
	</cfif>
</cfif>


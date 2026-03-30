<cfsetting requesttimeout="36000">
<cfif IsDefined("form.btnGenerar") or IsDefined("form.btnGenerarDoc") OR IsDefined("form.btnGenerar_Marcados")>
	<!--- Período de Auxiliares --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo# 
		  and Mcodigo = 'GN'
		  and Pcodigo = 50
	</cfquery>
	<cfset LvarAnoAux = rsSQL.Pvalor>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo# 
		  and Mcodigo = 'GN'
		  and Pcodigo = 60
	</cfquery>
	<cfset LvarMesAux = rsSQL.Pvalor>


	<cfset LobjOC 		= createObject( "component","sif.oc.Componentes.OC_transito")>
	<cfset LobjCxC 		= createObject( "component","sif.Componentes.CC_PosteoDocumentosCxC")>
	<cfset LobjINV 		= createObject( "component","sif.Componentes.IN_PosteoLin")>
	<cfset LobjPRES 	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>

	<cfset IMPUESTOS	= LobjCxC.CreaTablas(session.dsn)>
	<cfset INTARC 		= LobjCONTA.CreaIntarc(session.dsn)>
	<cfset INTPRES 		= LobjPRES.CreaTablaIntPresupuesto(session.dsn)>
	<cfset IDKARDEX 	= LobjINV.CreaIdKardex(session.dsn)>
	<cfset OC_DETALLE 	= LobjOC.OC_CreaTablas(session.dsn)>

	<cfif IsDefined("form.btnGenerar_Marcados")>
		<cfset form.chkArticulos = "1">
		<cfset form.chkOCs_DC = "1">
		<cfset form.chkOCs_DV = "1">
		<cfif not IsDefined("form.chk")>
			<cf_errorCode	code = "50440" msg = "No marco ningun documento">
		</cfif>
		<cfset LvarLstChks = form.chk>
	<cfelseif IsDefined("form.btnGenerarDoc")>
		<cfset form.chkArticulos = "1">
		<cfset form.chkOCs_DC = "1">
		<cfset form.chkOCs_DV = "1">
		<cfset LvarLstChks = form.CCTcodigo & '|' & form.Ddocumento>
	<cfelse>	
		<cfset LvarLstChks = '*'>
	</cfif>

	<cfparam name="form.chkOCs_DC"		default="0">
	<cfparam name="form.chkOCs_DV"		default="0">
	<cfparam name="form.chkVerAsiento"	default="0">
	<cfparam name="form.cboAnoMes"		default="0">

	<cfloop list="#LvarLstChks#" index="LvarChk">
		<cfif LvarChk EQ "*">
			<cfset LvarCCTcodigo	= "">
			<cfset LvarDdocumento	= "">
		<cfelse>
			<cfset LvarCCTcodigo	= listGetAt(LvarChk,1,"|")>
			<cfset LvarDdocumento	= listGetAt(LvarChk,2,"|")>
		</cfif>

		<cfif IsDefined("form.chkArticulos")>
			<cfif form.chkVerAsiento NEQ "1">
				<cfset LobjCxC.CxC_AplicaCostoVenta_Pendientes (session.Ecodigo, LvarAnoAux, LvarMesAux, LvarCCTcodigo, LvarDdocumento, session.dsn)>
			</cfif>
		</cfif>
		<cfif form.chkOCs_DC EQ 1 OR form.chkOCs_DV EQ 1>
			<cfset LobjOC.OC_Aplica_CostoVenta_Pendientes(session.Ecodigo, LvarAnoAux, LvarMesAux, form.chkOCs_DC, form.chkOCs_DV, LvarCCTcodigo, LvarDdocumento, session.dsn, (form.chkVerAsiento EQ "1"), form.cboAnoMes)>
		</cfif>
	</cfloop>
</cfif>
<cflocation url="OCcostoVenta.cfm">



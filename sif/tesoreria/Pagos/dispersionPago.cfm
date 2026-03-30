
<cfinvoke key="LB_Titulo" default="Dispersion de Pagos"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago.xml"/>

<cf_navegacion name="PASO" default="0" navegacion="">
<cf_navegacion name="TESOPid" navegacion="">

<cfif isdefined("Session.Menues")>
	<cfif isdefined("Session.Menues.SPCODIGO") and Session.Menues.SPCODIGO EQ "TOP_001">
		<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	</cfif>
</cfif>

<cfset GvarDetalleGrande = false>

<cfset titulo = '#LB_Titulo#'>

<cf_templateheader title="#titulo#">

<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfif isdefined('form.BTNGENERAR')>
		<cfset OP_IDs = arrayNew(1)>
		<cfset OP_AccountID = "">
		<cfloop list="#form.CHK#" index="OP_itm">
			<cfset ArrayAppend(OP_IDs,listGetAt(OP_itm,1,'|'))>
			<cfset OP_AccountID = listGetAt(OP_itm,2,'|')>
		</cfloop>
		
		<cfquery name="datos_Banco" datasource="#session.DSN#">
			select * from Bancos a inner join CuentasBancos b on a.Bid = b.Bid where b.CBcodigo = '#OP_AccountID#';
		</cfquery>
		<cfset plantilla = datos_Banco.plantillaDispersion>
		<cfif plantilla NEQ "">
			<cfinvoke component="sif.mb.plantillas_dispersion.#plantilla#" method="genDispersion" 
				OP_IDs="#OP_IDs#" 
				BankName="#UCase(replace(plantilla,"_disp","","all"))#"
				BankData="#datos_Banco#"
			>
			</cfinvoke>
		<cfelse>
			<cf_errorCode code = "50740" msg = "<cf_translate key=LB_EmpleadoNoRegistrado>El Banco: (#datos_Banco.Bdescripcion#) No tiene plantilla de dispersion asociada</cf_translate">
		</cfif>
			
	</cfif>
	<cfinclude template="dispersionPagos_form.cfm">
<cf_web_portlet_end>

<cf_templatefooter>

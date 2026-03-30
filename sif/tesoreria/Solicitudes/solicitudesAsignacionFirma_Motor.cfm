<!--- 
	Creado por: Maria de los Angeles Blanco López
		Fecha: 19 Octubre 2011
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos por volumen de Ventas'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<cfset varError = false>

<cfquery name="rsFirmas" datasource="#session.dsn#">
	select TESSPid, DEid_Aprueba, DEid_Autoriza, Usuario, convert(varchar(10), Fecha_Act, 103) as Fecha_Act, 
	UAP.DEnombre +' '+ UAP.DEapellido1 +' '+ UAP.DEapellido2 as NombreAP, UAP.DEid as Id_Aprueba, UAP.DEidentificacion as    Cod_Aprueba, UAU.DEnombre +' '+ UAU.DEapellido1 +' '+UAU.DEapellido2 as NombreAU, UAU.DEid as Id_Autoriza, 	    		    UAU.DEidentificacion as Cod_Autoriza
	from TESsolicitudFirmas	SF
	inner join (select DEid, DEidentificacion, DEapellido1,  DEapellido2, DEnombre
				from DatosEmpleado) as UAP 
	on UAP.DEid = SF.DEid_Aprueba
	inner join (select DEid, DEidentificacion, DEapellido1, DEapellido2, DEnombre 
				from DatosEmpleado) as UAU
	on UAU.DEid = SF.DEid_Autoriza
	where TESSPid = #session.TESSPid#
	and Ecodigo = #session.Ecodigo#
</cfquery>

<cfif rsFirmas.recordcount EQ 0>
	<cfif form.DEid EQ ''>
		<cfthrow message="Debe indicar el usuario que firma la Aprobación">
	</cfif>
	<cfif form.DEidA EQ ''>
		<cfthrow message="Debe indicar el usuario que firma la Autorización">
	</cfif>
</cfif>
	
<cftransaction action="begin">
<cftry>	
	<cfif rsFirmas.recordcount GT 0>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudFirmas
			set 
			<cfif isdefined("form.DEid") and form.DEid NEQ ''>
				DEid_Aprueba =  #form.DEid#,
			</cfif>
			<cfif isdefined("form.DEidA") and form.DEidA NEQ ''>
				DEid_Autoriza = #form.DEidA#,
			</cfif>
			Usuario = '#session.Usuario#',
			Fecha_Act = getdate()
			where TESSPid = #session.TESSPid#
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
		insert into TESsolicitudFirmas
			(TESSPid,
			DEid_Aprueba,
			DEid_Autoriza,
			Ecodigo,
			Usuario,
			Fecha_Act)
		values
			(#session.TESSPid#,
			 #form.DEid#,
			 #form.DEidA#,
			 #session.Ecodigo#,
			 '#session.Usuario#',
			 getdate())			
		</cfquery>
	</cfif>
	<cftransaction action="commit"/>
		<cfcatch>
		<cftransaction action="rollback"/>
   		<cfset varError = true>			
		<cfif isdefined("cfcatch.Message")>
			<cfset Mensaje="#cfcatch.Message#">
       	<cfelse>
 	       <cfset Mensaje="">
        </cfif>
        <cfif isdefined("cfcatch.Detail")>
	       <cfset Detalle="#cfcatch.Detail#">
    	<cfelse>
            <cfset Detalle="">
        </cfif>
        <cfif isdefined("cfcatch.sql")>
           	<cfset SQL="#cfcatch.sql#">
	    <cfelse>
    	    <cfset SQL="">
        </cfif>
        <cfif isdefined("cfcatch.where")>
            <cfset PARAM="#cfcatch.where#">
	    <cfelse>
    	    <cfset PARAM="">
        </cfif>
        <cfif isdefined("cfcatch.StackTrace")>
            <cfset PILA="#cfcatch.StackTrace#">
	    <cfelse>
    	   <cfset PILA="">
        </cfif>
           <cfset MensajeError= #Mensaje# & #Detalle# & #cfcatch.sql#>
		<cfthrow message="#MensajeError#">
		</cfcatch>
	</cftry>
</cftransaction>	
							
<cfif not varError>
	<cflocation url="/cfmx/sif/tesoreria/solicitudes/solicitudesAsignacionFirma_Valores.cfm"> 
<cfelse>
	<form name="form1" action="solicitudesAsignacionFirma_Valores.cfm" method="post">
    	<center>
        	<table border="1" align="center">
            	<tr>
                	<td width="100%" align="center">
                    	<strong> SE PRESENTARON ERRORES AL GUARDAR LAS FIRMAS #MensajeError#</strong>
                    </td>
                </tr>
                <tr>
	               	<td width="100%" align="center">
                    	<input type="submit" name="btnRegresa" value="Regresar" />
                    </td>
                </tr>
            </table>
        </center>
    </form>
</cfif>


<cf_templatefooter>
<cf_navegacion name="fOorigen"		default="" navegacion="" session>
<cf_navegacion name="fCconcepto"	default="" navegacion="" session>
<cf_navegacion name="fCdescripcion"	default="" navegacion="" session>
<cfset filtro = "">
<cfset navegacion = "">					
<cfif isdefined("url.fOorigen") and not isdefined("Form.fOorigen")>
	<cfset form.fOorigen = url.fOorigen>
</cfif>
<cfif isdefined("url.fCconcepto") and not isdefined("Form.fCconcepto")>
	<cfset form.fCconcepto = url.fCconcepto>
</cfif>
<cfif isdefined("url.fCdescripcion") and not isdefined("Form.fCdescripcion")>
	<cfset form.fCdescripcion = url.fCdescripcion>
</cfif>
<cfif isdefined("Form.fOorigen") and len(trim(form.fOorigen))>
	<cfset filtro = filtro & " and upper(Oorigen) like '%"  & trim(Ucase(Form.fOorigen)) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fOorigen=" & Form.fOorigen>
</cfif>
<cfif isdefined("Form.fCconcepto") and len(trim(form.fCconcepto))>
	<cfset filtro = filtro & " and Cconcepto = '"  & trim(Form.fCconcepto) & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCconcepto=" & Form.fCconcepto>
</cfif>
<cfif isdefined("Form.fCdescripcion") and len(trim(form.fCdescripcion))>
	<cfset filtro = filtro & " and upper(Cdescripcion) like '%"  & trim(Ucase(Form.fCdescripcion)) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCdescripcion=" & Form.fCdescripcion>
</cfif>
<cfset img_checked = "<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>">
<cfset img_unchecked = "<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>">

<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as cantidad
	  from Origenes
	 where Oorigen = 'CGCF'
</cfquery>
<cfif rsSQL.cantidad EQ 0>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into Origenes (Oorigen, Odescripcion, Otipo, BMUsucodigo)
		values ('CGCF', 'Cierre Anual Fiscal', 'S', 1)
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from Origenes
		 where Oorigen = 'CGCC'
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into Origenes (Oorigen, Odescripcion, Otipo, BMUsucodigo)
			values ('CGCC', 'Cierre Anual Corporativo', 'S', 1)
		</cfquery>
	</cfif>			
</cfif>			

<cf_templateheader title="Contabilidad General">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Asignaci&oacute;n de Concepto por Auxiliar Contable'>
		 <cfif isdefined("session.modulo") and session.modulo EQ "CG">
			<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</cfif>		
		<table  width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td nowrap colspan="4" valign="top">
					<cfinclude template="ConceptoContable-Filtro.cfm">
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 		value="ConceptoContable"/>
						<cfinvokeargument name="columnas" 	value="Oorigen, Cconcepto, Cdescripcion, 
																case Chknoreglas when 1 then '#img_checked#' else '#img_unchecked#' end as Chknoreglas,
																case Chknovalmayor when 1 then '#img_checked#' else '#img_unchecked#' end as Chknovalmayor,
																case Chknovaloficinas when 1 then '#img_checked#' else '#img_unchecked#' end as Chknovaloficinas"/>
						<cfinvokeargument name="desplegar" 	value="Oorigen, Cconcepto, Cdescripcion, Chknoreglas, Chknovalmayor, Chknovaloficinas"/>
						<cfinvokeargument name="etiquetas" 	value="Origen, Lote, Descripción del Concepto, No validar reglas, No validar cta. mayor, No validar oficina"/>
						<cfinvokeargument name="formatos" 	value="S,S,S,S,S,S"/>
						<cfinvokeargument name="filtro" 	value=" Ecodigo = #Session.Ecodigo# #filtro# order by Oorigen"/>
						<cfinvokeargument name="align" 		value="left, left, left, center, center, center"/>
						<cfinvokeargument name="ajustar" 	value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="keys" 		value="Oorigen"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="irA" 		value="ConceptoContable.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true">
						<cfinvokeargument name="debug" 		 value="N">
					  </cfinvoke>
				</td>
				<td valign="top">
		 				<cfinclude template="formConceptoContable.cfm">
				</td>
			</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
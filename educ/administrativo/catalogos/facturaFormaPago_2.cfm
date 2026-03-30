<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Formas de Pago
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!--- Coloque #N/A# para que desaparezca la zona left: #N/A# = pantalla completa --->
	<!-- InstanceBeginEditable name="left" -->
		<cfinclude template="/home/menu/menu.cfm"> 
	<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
	<cf_templatecss>
	<!-- InstanceBeginEditable name="Encabezado" -->
		Formas de Pago
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfif isdefined("Url.FACcodigo") and not isdefined("form.FACcodigo")>
			<cfset Form.FACcodigo = Url.FACcodigo>
		</cfif>
		<cfif isdefined("Url.codApersona") and not isdefined("form.codApersona")>
			<cfset Form.codApersona = Url.codApersona>
		</cfif>	
		
		<cfset titulo = "Formas de Pago">
		<cfset navBarItems = ArrayNew(1)>
		<cfset navBarLinks = ArrayNew(1)>
		<cfset navBarItems[1] = "Facturas">
		<cfset navBarLinks[1] = "/cfmx/educ/administrativo/catalogos/facturas.cfm?FACcodigo=#form.FACcodigo#&codApersona=#form.codApersona#&modo=CAMIO">
		<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
		
		<cfinclude template="encAlumno.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="47%" valign="top">
				<cfinvoke 
				 component="educ.componentes.pListas"
				 method="pListaEdu"
				 returnvariable="pListaEduRet">
					<cfinvokeargument name="tabla" value="
							FacturaEduFormaPago ffp
							, FacturaEdu fe"/>
					<cfinvokeargument name="columnas" value="
						codApersona=#form.codApersona#
						, ffp.FACcodigo
						, FAPsecuencia
						, case FAPtipo
							when 1 then 'Efectivo'
							when 2 then 'Tarjeta'
							when 3 then 'Cheque'
						end FAPtipo
						, FAPorigen
						, FAPmonto"/>			 
					<cfinvokeargument name="filtro" value=" 
							ffp.FACcodigo=#form.FACcodigo#
							and ffp.Ecodigo=#session.Ecodigo#
							and ffp.FACcodigo=fe.FACcodigo
							and ffp.Ecodigo=fe.Ecodigo
						order by FAPorigen"/>					
					<cfinvokeargument name="desplegar" value="FAPorigen, FAPtipo, FAPmonto"/>
					<cfinvokeargument name="etiquetas" value="Origen, Tipo, Monto"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="align" value="left,left,right"/>
					<cfinvokeargument name="ajustar" value="N,N,N"/>
					<cfinvokeargument name="irA" value="facturaFormaPago.cfm"/>
					<cfinvokeargument name="formName" value="formListaFactFormaPago"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>				
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="keys" value="FACcodigo,FAPsecuencia"/>
				</cfinvoke>		
			</td>
			<td width="1%">&nbsp;</td>
			<td width="52%" valign="top">
				<cfinclude template="facturaFormaPago_form.cfm">
			</td>	
		  </tr>
		</table>		
	
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->
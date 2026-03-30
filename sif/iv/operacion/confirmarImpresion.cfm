<!--- 
	Creado por: Ana Villavicencio
	Fecha: 13 de setiembre del 2005
	Motivo: se creo para mostrar los datos para confirmar la impresion y aplicación de facturas.
--->

<cfset params = ''>
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfset  params = params & "&SNcodigo=#form.SNcodigo#">
</cfif>
<cfif isdefined("form.CCtipo") and len(trim(form.CCtipo))>
	<cfset  params = params & "&CCtipo=#form.CCtipo#">
</cfif>
<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
	<cfset  params = params & "&Mcodigo=#form.Mcodigo#">
</cfif>
<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
	<cfset  params = params & "&Periodo=#form.Periodo#">
</cfif>
<cfif isdefined("form.Mes") and len(trim(form.Mes))>
	<cfset  params = params & "&Mes=#form.Mes#">
</cfif>
<cfif isdefined("idioma") and len(trim(idioma))>
	<cfset  params = params & "&Idioma=#idioma#">
</cfif>
<cfif isdefined("firmaAutorizada") and len(trim(firmaAutorizada))>
	<cfset  params = params & "&firmaAutorizada=#firmaAutorizada#">
</cfif>

<cfset total = 0>
<cfset cantDocs = 0>
<cfset listaDocs = "">
<cfset Doc = "">
<cfloop list="#form.chk#" index="i" delimiters=",">
	<cfset total = total + form['Dtotal_#i#']>
	<cfset cantDocs = cantDocs + 1>
	<cfset Doc = ListAppend(Doc,form['Ddocumento_#i#'],'|')>
	<cfset Doc = ListAppend(Doc,form['CCTcodigo_#i#'],'|')>
	<cfset listaDocs = ListAppend(listaDocs,Doc,',')>
	<cfset Doc = "">
</cfloop>

<cfquery name="rsMoneda" datasource="#session.DSN#">
	select Miso4217 as Moneda
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Mcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
</cfquery>
<cf_templateheader title=" Confirmaci&oacute;n de Impresi&oacute;n de Facturas">
	
<cfoutput><form name="form1" method="post" action="impresionFacturas-sql.cfm">
 <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Impresi&oacute;n de Facturas'>
	 <table width="100%" border="0" cellspacing="0" cellpadding="2">
	 	<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr> 
		  <td class="Titulo" colspan="2" bgcolor="##E4E4E4">Confirmaci&oacute;n</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<table border="0" cellpadding="0" cellspacing="2">
					<tr>
						<td align="right"><strong>Cantidad de Documentos:&nbsp;</strong></td>
						<td>#cantDocs#</td>
					</tr>
					<tr>
						<td align="right"><strong>Tipo de Movimiento de los Documentos:&nbsp;</strong></td>
						<td><cfif isdefined('form.CCtipo') and form.CCtipo EQ 'D'>D&eacute;bito<cfelseif form.CCtipo EQ 'C'>Cr&eacute;dito</cfif></td>
					</tr>
					<tr>
						<td align="right"><strong>Monto Total:&nbsp;</strong></td>
						<td>#LSCurrencyFormat(total,'none')# #rsMoneda.Moneda#</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="2" align="center">
					<tr><td width="439" colspan="4" bgcolor="##E4E4E4" class="subTitulo">Resumen</td></tr>
					<tr bgcolor="##E0E0E0">
						<td>Transacci&oacute;n</td>
						<td>Fecha</td>
						<td>Documento</td>
						<td>Monto</td>
					</tr>
					<cfloop list="#form.chk#" index="i" delimiters=",">
						<tr>
							<td>#form['CCTcodigo_#i#']#</td>
							<td>#LSDateFormat(form['Dfecha_#i#'],'dd/mm/yyyy')#</td>
							<td>#form['Ddocumento_#i#']#</td>
							<td align="right">#LSCurrencyFormat(form['Dtotal_#i#'],'none')#</td>
						</tr>
					</cfloop>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td align="center" colspan="4">
							<input name="Aceptar" type="submit" value="Aceptar" onClick="javascript: if(confirm('Desea aplicar los documentos seleccionados?')){return true}else{return false}">
							<input name="Cancelar" type="button" value="Cancelar" onClick="javascript: location.href='impresionFacturas.cfm?<cfoutput>#params#</cfoutput>';">
							<input name="listaDocs" type="hidden" value="#listaDocs#">
							<input name="fechaFact" type="hidden" value="#form.fechaFact#">
							<input name="firmaAutorizada" type="hidden" value="#form.firmaAutorizada#">
							<input name="idioma" type="hidden" value="#form.idioma#">
							<input name="CCtipo" type="hidden" value="#form.CCtipo#">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	 <cf_web_portlet_end>
</form></cfoutput>
	<cf_templatefooter>

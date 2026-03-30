<cfif isdefined("form.pPPparte") and len(trim(form.pPPparte))>
	<cfset form.PPparte = form.pPPparte >
</cfif>

<cfset modo_parte = 'ALTA'>
<cfif isdefined("form.PPparte") and len(trim(form.PPparte))>
	<cfset modo_parte = 'CAMBIO'>
	<cfquery name="pcpdata" datasource="sifcontrol">
		select PPparte, PCPdescripcion, PCPinstrucciones, PCPmaxpreguntas
		from PortalCuestionarioParte
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPparte = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPparte#">
	</cfquery>
</cfif>

<cfoutput>
<table border="0" cellpadding="0" cellspacing="2" width="100%" align="center" >
	<cfif isdefined("form.pagenum1")>
		<input type="hidden" name="_pagenum1" value="#form.pagenum1#">
	</cfif>

	<tr>
		<td align="right" width="1%" nowrap ><cf_translate key="LB_Parte">Parte</cf_translate>:&nbsp;</td>
		<td>
			<input type="text" name="PPparte" size="7" maxlength="3"  style="text-align:right;" value="<cfif modo_parte neq 'ALTA'>#trim(pcpdata.PPparte)#</cfif>"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
		</td>
	</tr>

	<tr>
		<td align="right" width="1%"><cf_translate XmlFile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate>:&nbsp;</td>
		<td><input type="text" name="PCPdescripcion" size="30" maxlength="30" onFocus="restaurar_color(this); this.select(); " value="<cfif modo_parte neq 'ALTA'>#trim(pcpdata.PCPdescripcion)#</cfif>"></td>
	</tr>


	<tr>
		<td align="right" width="1%" nowrap ><cf_translate key="LB_Preguntas">Preguntas</cf_translate>:&nbsp;</td>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td><input type="text" name="PCPmaxpreguntas" size="7" maxlength="3"  style="text-align:right;" value="<cfif modo_parte neq 'ALTA'>#trim(pcpdata.PCPmaxpreguntas)#</cfif>"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
					<td><cf_translate key="Ayuda_SeRefiereAlNumeroDePreguntasQueDebenSerContestadasPorParte">Se refiere al número de preguntas que deben ser contestadas por parte.</cf_translate></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="2"></td></tr>
	
	
	<tr>
		<td align="right" valign="top" nowrap ><cf_translate key="instrucciones"><cf_translate key="LB_Instrucciones">Instrucciones</cf_translate></cf_translate>:&nbsp;</td>
		<td>
			<!---<textarea name="PPpregunta" onClick="this.select()" cols="60" rows="7" onFocus="restaurar_color(this); this.select();"><cfif modo_parte neq 'ALTA'>#trim(pcpdata.PPpregunta)#</cfif></textarea>--->
			<cfif modo_parte neq 'ALTA'>
				<cf_sifeditorhtml name="PCPinstrucciones" indice="1" value="#trim(pcpdata.PCPinstrucciones)#" height="150">
			<cfelse>
				<cf_sifeditorhtml name="PCPinstrucciones" indice="1" height="150">
			</cfif>
		</td>	
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	
	<tr>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Guardar"
	Default="Guardar"
	returnvariable="BTN_Guardar"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	returnvariable="BTN_Eliminar"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	returnvariable="BTN_Nuevo"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarLaParte"
	Default="Desea eliminar la parte?"
	returnvariable="MSG_DeseaEliminarLaParte"/>	

	
		<td colspan="2" align="center">
			<input type="submit" name="<cfif modo_parte eq 'ALTA'>PCPGuardar<cfelse>PCPModificar</cfif>" value="<cfoutput>#BTN_Guardar#</cfoutput>">
			<cfif modo_parte neq 'ALTA'>
				<input type="submit" name="PCPEliminar" value="<cfoutput>#BTN_Eliminar#</cfoutput>" onClick="javascript:return confirm('<cfoutput>#MSG_DeseaEliminarLaParte#</cfoutput>');">
				<input type="button" name="NuevaParte" value="<cfoutput>#BTN_Nuevo#</cfoutput>" onClick="location.href='cuestionario.cfm?PCid=#form.PCid#';" >
			</cfif>
		</td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
</table>

</cfoutput>
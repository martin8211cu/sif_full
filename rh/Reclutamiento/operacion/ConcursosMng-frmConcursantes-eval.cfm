<cfquery name="rsListaNotaGrabada" datasource="#Session.DSN#">
	select c.RHDAlinea, c.RHDAdescripcion, b.RHEAcodigo, b.RHEAid, b.RHEAdescripcion, d.RHCAONota, d.RHCAOid, a.RHCconcurso 
	from RHAreasEvalConcurso a 

		inner join RHEAreasEvaluacion b 
			on b.RHEAid = a.RHEAid 
			and b.Ecodigo = a.Ecodigo 

		inner join RHDAreasEvaluacion c 
			on c.RHEAid = b.RHEAid 

		left outer join RHCalificaAreaConcursante d 
			on d.RHDAlinea = c.RHDAlinea 
			and d.RHCconcurso = a.RHCconcurso 
			and d.RHCPid=#form.RHCPid#
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
	
	order by b.RHEAcodigo, b.RHEAid
</cfquery>

<!-----and d.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">--->
<cfquery name="rsListaNotaPGrabada" datasource="#session.DSN#">
	select distinct a.RHPcodigopr, b.RHPdescripcionpr, c.RHCPCNota, c.RHCPCid
	from RHPruebasConcurso a
		
		inner join RHPruebas b
			on b.Ecodigo = a.Ecodigo
			and b.RHPcodigopr = a.RHPcodigopr
		 
		left outer join RHCalificaPrueConcursante c
			on c.RHCconcurso = a.RHCconcurso
			and c.Ecodigo = a.Ecodigo
			and c.RHPcodigopr = a.RHPcodigopr
			and c.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">

	where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by a.RHPcodigopr
</cfquery>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="2">&nbsp;</td>
	    <td>&nbsp;</td>
	    <td width="2">&nbsp;</td>
      </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>
			<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td>&nbsp;<strong><cf_translate key="LB_EVALUARCONCURSANTE">EVALUAR CONCURSANTE</cf_translate></strong></td>
					<td align="right" width="25">&nbsp;</td>
				  </tr>
				</table>
			</fieldset>
		</td>
	    <td>&nbsp;</td>
      </tr>
	  <tr>
		<td>&nbsp;</td>
		<td valign="top">
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<table width="99%" border="0" cellspacing="0" cellpadding="2" style="border-bottom: 1px solid ##CCCCCC">
				  <tr style="height: 25;">
					<td class="tituloListas" nowrap>
						<font color="##000099" style="font-size:11px;"><strong>
						#rsConcursante.identificacion#&nbsp;&nbsp;#rsConcursante.nombre#
						</strong></font>
					</td>
					<td class="tituloListas" align="right" nowrap>
						NOTA: <font style="font-size:14px;"><cfif rsConcursante.RHCevaluado EQ 1>#LSNumberFormat(rsConcursante.RHCPpromedio, ',9.00')#<cfelse>N/E</cfif></font>
					</td>
				  </tr>
				</table>
				<form name="form1" method="post" action="ConcursosMng-sql.cfm">
				  <div id="divNuevo" style="overflow:auto; height: #tamVentanaConcursantes-25#; margin:0;" >
					<cfinclude template="ConcursosMng-hiddens.cfm">
					<input type="hidden" name="op" value="3">
					<table width="99%" border="0" cellspacing="0" cellpadding="2">
					
					  <cfif isdefined("rsListaNotaGrabada") and rsListaNotaGrabada.RecordCount GT 0>
						<cfset AreaEncabezado = "">
						<cfloop query="rsListaNotaGrabada">
						  <cfif (currentRow Mod 2) eq 1>
							<cfset color = "Non">
							<cfelse>
							<cfset color = "Par">
						  </cfif>
						  <cfif AreaEncabezado NEQ rsListaNotaGrabada.RHEAdescripcion>
							<cfset AreaEncabezado = rsListaNotaGrabada.RHEAdescripcion>
							<tr class="listaCorte">
							  <td colspan="3" style="padding-left:5px;"><strong>#rsListaNotaGrabada.RHEAdescripcion#</strong></td>
							</tr>
							<tr class="tituloListas">
							  <td align="left" style="padding-right:5px;"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
							  <td align="left" style="padding-right:5px;"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
							  <td align="right" style="padding-right:5px;"><strong><cf_translate key="LB_Nota">Nota</cf_translate></strong></td>
							</tr>
						  </cfif>
						  <tr>
							<td class="lista#color#" style="padding-right:5px;">#rsListaNotaGrabada.RHDAlinea#</td>
							<td class="lista#color#" style="padding-right:5px;">#rsListaNotaGrabada.RHDAdescripcion#</td>
							<td class="lista#color#" align="right" style="padding-right:5px;">
							  <input class="flat" style="text-align:right;" onFocus="this.select();"  name="peso_#rsListaNotaGrabada.RHDAlinea#_#rsListaNotaGrabada.RHEAid#" type="text" size="6"  maxlength="10"
											onChange="javascript: fm(this,2); validaPeso(this);"
											onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};"
											value="<cfif Len(Trim(rsListaNotaGrabada.RHCAONota))>#Trim(LSNumberFormat(rsListaNotaGrabada.RHCAONota,"___.__"))#<cfelse>#Trim(LSNumberFormat(0,"___.__"))#</cfif>" >
							  <input name="RHDAlinea_#rsListaNotaGrabada.RHDAlinea#_#rsListaNotaGrabada.RHEAid#" type="hidden" value="#trim(rsListaNotaGrabada.RHDAlinea)#">
							  <input type="hidden" name="RHCAOid_#trim(rsListaNotaGrabada.RHDAlinea)#_#trim(rsListaNotaGrabada.RHEAid)#" value="#rsListaNotaGrabada.RHCAOid#">
							</td>
						  </tr>
						</cfloop>
					  </cfif>
						<tr class="listaCorte">
						  <td colspan="3" style="padding-left:5px;"><strong><cf_translate key="LB_Pruebas">Pruebas</cf_translate></strong></td>
						</tr>
						<cfif isdefined("rsListaNotaPGrabada") and rsListaNotaPGrabada.RecordCount GT 0>
							<tr class="tituloListas">
							  <td align="left" style="padding-right:5px;"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
							  <td align="left" style="padding-right:5px;"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
							  <td align="right" style="padding-right:5px;"><strong><cf_translate key="LB_Nota">Nota</cf_translate></strong></td>
							</tr>
							<cfloop query="rsListaNotaPGrabada">
								<cfif (currentRow Mod 2) eq 1>
									<cfset color = "Non">
								<cfelse>
									<cfset color = "Par">
								</cfif>
								<!--- ********************************************* --->
								<tr>
									<td class="lista#color#" style="padding-right:5px;">#rsListaNotaPGrabada.RHPcodigopr#</td>
									<td class="lista#color#" style="padding-right:5px;">#rsListaNotaPGrabada.RHPdescripcionpr#</td>
									<td class="lista#color#" align="right" style="padding-right:5px;">
										<input class="flat" style="text-align:right"  onFocus="this.select();" name="pesa_#trim(rsListaNotaPGrabada.RHPcodigopr)#"
										type="text" size="6"  maxlength="10"
										onChange="javascript: fm(this,2); validaPeso(this);"
										onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};"
										value="<cfif Len(Trim(rsListaNotaPGrabada.RHCPCNota))>#rsListaNotaPGrabada.RHCPCNota#<cfelse>#Trim(LSNumberFormat(0,"___.__"))#</cfif>">
										<!--- rsListaNotaPGrabada --->
										<input name="tipocompa_#rsListaNotaPGrabada.RHPcodigopr#" 
												type="hidden" value="#rsListaNotaPGrabada.RHPdescripcionpr#">
										<input name="Idcompa_#trim(rsListaNotaPGrabada.RHPcodigopr)#" 
												type="hidden" value="#rsListaNotaPGrabada.RHPcodigopr#">
										<input name="RHCPCid_#trim(rsListaNotaPGrabada.RHPcodigopr)#" 
												type="hidden" value="<cfif Len(Trim(rsListaNotaPGrabada.RHCPCid))>#rsListaNotaPGrabada.RHCPCid#</cfif>">
									</td>
								</tr>
							</cfloop>
							<tr><td colspan="3">&nbsp;</td></tr>
						<cfelse>
							<tr><td align="center"><strong>--- <cf_translate key="LB_NoHayPruebas">No hay Pruebas.</cf_translate> ---</strong></td></tr>
						</cfif>
					</table>
				  </div>
					<table width="99%" border="0" cellspacing="0" cellpadding="2">
					  <tr style="height: 25;">
						<td align="center" valign="middle" nowrap>
							<input type="submit" name="btnAceptar" value="Aceptar">
							<cfif rsConcursante.DEid gt 0>
								<input type="button" name="Importar" value="Importar" onClick="javascript:NuevaVentana(<cfoutput>#rsConcursante.RHCPid#,#rsConcursante.DEid#,#form.RHCconcurso#</cfoutput>);">
							<cfelseif rsConcursante.RHOid gt 0>
								<input type="button" name="Importar" value="Importar" onClick="javascript:NuevaVentanaOferente(<cfoutput>#rsConcursante.RHCPid#,#rsConcursante.RHOid#,#form.RHCconcurso#</cfoutput>);">
							</cfif>
						</td><!--- <cfdump var="#rsListaNotaGrabada#"> <cfdump var="#rsListaNotaPGrabada#"> --->
					  </tr>
					</table><!--- <cfdump var="#rsConcursante#"> --->
				</form>
			</fieldset>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
      </tr>
	</table>
</cfoutput>
<!--- <cfdump var="#form#">
<cfdump var="#rsConcursante#"> --->

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaNotaDigitadaDebeEstarEntre0Y100."
	Default="La Nota digitada debe estar entre 0 y 100."
	returnvariable="MSG_LaNotaDigitadaDebeEstarEntre0Y100"/>
	
<script language="javascript" type="text/javascript">
	function validaPeso(peso){ 
		var nombre;
		if (peso.name){
		 	p = peso.value;
			nombre = peso.name;
		}
		else 
			p = peso;
		
		p = qf(p);
			
		if (p > 100) {
			alert('<cfoutput>#MSG_LaNotaDigitadaDebeEstarEntre0Y100#</cfoutput>');			
			eval("document.form1."+ nombre + ".value = '0.00'");
			eval("document.form1."+ nombre + ".focus();");
			return false;
		}
	} 


	var popUpWin=0;
	//Levanta la ventana
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama la ventana
	
		
	
		

	<cfif rsConcursante.DEid gt 0>
	function NuevaVentana(RHCPid, DEid, RHCconcurso ) {
	<cfelseif rsConcursante.RHOid gt 0>
	function NuevaVentanaOferente(RHCPid, RHOid, RHCconcurso ) {
	</cfif>
		var params ="";
		
		params = "&form=form"+
		<cfif rsConcursante.DEid gt 0>
			popUpWindow("/cfmx/rh/Reclutamiento/operacion/ImportarNota.cfm?RHCPid="+RHCPid+"&RHCconcurso="+RHCconcurso +"&DEid="+DEid+params,300,120,510,535);
		<cfelseif rsConcursante.RHOid gt 0>
			popUpWindow("/cfmx/rh/Reclutamiento/operacion/ImportarNota.cfm?RHCPid="+RHCPid+"&RHCconcurso="+RHCconcurso +"&RHOid="+RHOid+params,300,120,510,535);
		</cfif>
	}
	function funcRefrescar(){
		location.reload();
	}

</script>
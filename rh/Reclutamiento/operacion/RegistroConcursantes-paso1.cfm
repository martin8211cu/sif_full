<!---*******************************--->
<!---  inicialización de variables  --->
<!---*******************************--->
<cfset modo = 'ALTA'>
<!---*******************************--->
<!---  área de consultas            --->
<!---*******************************--->
<cfquery name="rsConcurso" datasource="#session.DSN#">
	select RHCconcurso,RHCdescripcion,a.RHPcodigo,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,RHPdescpuesto,RHCcantplazas
	from RHConcursos a , RHPuestos b
	where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCCONCURSO#">
	and a.RHPcodigo = b.RHPcodigo and a.Ecodigo = b.Ecodigo
	and a.RHCestado = 50 
	order by RHCconcurso, RHCdescripcion
</cfquery>
<!---*******************************--->
<!--- Información del Concurso      --->
<!---*******************************--->
	<table  width="75%"  align="center"border="0">
		<tr>
			<td width="11%" align="left" >N&ordm;. Concurso:</td>
			<td width="75%"><strong><cfoutput>#rsConcurso.RHCCONCURSO#</cfoutput></strong></td>
		</tr>
		<tr>
			<td align="left">Descripci&oacute;n:</td>
			<td><strong><cfoutput>#rsConcurso.RHCDESCRIPCION#</cfoutput></strong></td>
		</tr>
		<tr>
			<td align="left">Puesto:</td>
			<td><strong><cfoutput>#rsConcurso.RHPcodigoext# #rsConcurso.RHPDESCPUESTO#</cfoutput></strong></td>
		</tr>
		<tr>
			<td align="left"> Plazas:</td>
			<td><strong><cfoutput>#rsConcurso.RHCCANTPLAZAS#</cfoutput></strong></td>
		</tr>
	</table>
<!---*******************************--->
<!--- aréa de pintado               --->
<!---*******************************--->
<form action="<cfoutput>#CurrentPage#</cfoutput>" method="post" name="form1" >
    <input type="hidden" name="paso" value="<cfoutput><cfif isdefined("Gpaso")>#Gpaso#<cfelse>0</cfif></cfoutput>">
	<input type="hidden" name="RHCPid" value="">
	<input name="RHCCONCURSO" type="hidden" 
	value="<cfif isdefined("rsConcurso.RHCCONCURSO")and (rsConcurso.RHCCONCURSO GT 0)><cfoutput>#rsConcurso.RHCCONCURSO#</cfoutput></cfif>">
	<table width="100%" border="0">
		<tr>
			<td width="12%">&nbsp;</td>
			<td width="11%">&nbsp;</td>
			<td width="65%">
				<input name="TipoConcursante" type="radio" value="I" onClick="javascript: Submit();"
					<cfif (isdefined("Form.TipoConcursante") and TipoConcursante EQ 'I') or not isdefined("Form.TipoConcursante")>
						checked 
					<cfelse>
						uncheked
					</cfif>>&nbsp;Interno&nbsp;
				<input name="TipoConcursante" type="radio" value="E" onClick="javascript: Submit();" 
					<cfif isdefined("Form.TipoConcursante") and TipoConcursante EQ 'E'>checked <cfelse> uncheked</cfif>>&nbsp;Externo
			</td>
			<td width="10%">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>Concursante:</td>
		<td nowrap>
		<cfif isdefined("Form.TipoConcursante") and Form.TipoConcursante EQ 'E'>
			<cf_rhoferente size="35">
		<cfelse>
			<cf_rhempleado size="35">
		</cfif>
		</td>
			<td nowrap>
				<input type="submit" name="Alta" value="+" tabindex="0"
				onClick="javascript: this.form.botonSel.value = this.name; if (window.funcAlta) return funcAlta();if (window.habilitarValidacion) habilitarValidacion();if (1==2)alert('No haga nada');" >
			</td>
		</tr>
	</table>
	<!---*******************************--->
	<!--- Información del botones       --->
	<!---*******************************--->
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
				<input type="submit" name="Anterior" 
				value="<< Anterior" 
				onClick="javascript: this.form.botonSel.value = this.name; if (window.funcAnterior) return funcAnterior();" tabindex="0">
				<cfif isdefined("form.TipoConcursante") and Form.TipoConcursante EQ 'E'>
					<input type="reset" name="Nuevo" value="Nuevo"  tabindex="0" 
					onClick="javascript: NuevoOferente(<cfoutput>#form.RHCCONCURSO#</cfoutput>);">		
				</cfif>
				<input type="reset" name="Limpiar" value="Limpiar" 
				onClick="javascript: this.form.botonSel.value = this.name; if (window.funcLimpiar) return funcLimpiar();" tabindex="0">
				<input type="submit" name="Siguiente" value="Siguiente >>" 
				onClick="javascript: this.form.botonSel.value = this.name; if (window.funcSiguiente) return funcSiguiente();" tabindex="0">
			</td>
		</tr>
	</table>
	<!---*******************************--->
	<!--- Lista de Concursante          --->
	<!---*******************************--->
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr><td colspan="2" align="center">&nbsp;</td></tr>
		<td colspan="2"  align="center"   bgcolor="#CCCCCC" valign="top"><strong><cf_translate key="LB_ListaDeConsursantes">Lista de Concursantes</cf_translate></strong></td>
		<tr>
			<td colspan="2">
				<cfquery name="rsLista" datasource="#session.DSN#">							
					select  RHCconcurso, RHCPid,
					case RHCPtipo when 'I' then 'Interno' else 'Externo' end as Tipo_Concursante,
					 '<a href= javascript:Expendiente('''||<cf_dbfunction name="to_char" args="a.DEid">||''')>'||DEidentificacion ||'</a>' as identificacion,
					 '<a href= javascript:Expendiente('''||<cf_dbfunction name="to_char" args="a.DEid">||''')>'||b.DEnombre || ' ' || b.DEapellido1 || ' ' || b.DEapellido2 ||'</a>' as NombreEmp,
					'<img border=''0'' onClick=''eliminar('||<cf_dbfunction name="to_char" args="RHCPid">||');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>' as borrar, RHCPtipo
					from RHConcursantes a , DatosEmpleado b
					where  a.DEid  = b.DEid 
					and  RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCCONCURSO#" >
					
					union
					
					select  RHCconcurso,RHCPid,
					case RHCPtipo when 'I' then 'Interno' else 'Externo' end as Tipo_Concursante,
					 '<a href= javascript:Expendiente('''||<cf_dbfunction name="to_char" args="a.RHOid">||''')>'||RHOidentificacion ||'</a>' as identificacion,
					 '<a href= javascript:Expendiente('''||<cf_dbfunction name="to_char" args="a.RHOid">||''')>'||b.RHOnombre || ' ' || b.RHOapellido1 || ' ' || b.RHOapellido2 ||'</a>' as NombreEmp,
					'<img border=''0'' onClick=''eliminar('||<cf_dbfunction name="to_char" args="RHCPid">||');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>' as borrar, RHCPtipo
					from RHConcursantes a , DatosOferentes b
					where  a.RHOid  = b.RHOid 
					and  RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCCONCURSO#" >
				</cfquery>
				<cfinvoke
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"> 
					<cfinvokeargument name="query" value="#rsLista#"/> 
					<cfinvokeargument name="desplegar" value="identificacion,NombreEmp,Tipo_Concursante,borrar"/> 
					<cfinvokeargument name="etiquetas" value="Identificación,Nombre,Tipo,&nbsp;"/> 
					<cfinvokeargument name="formatos" value="S,S,S,S"/> 
					<cfinvokeargument name="align" value="left,left,left,right"/> 
					<cfinvokeargument name="ajustar" value="N"/> 
					<cfinvokeargument name="checkboxes" value="N"/> 
					<cfinvokeargument name="irA" value="#CurrentPage#"/>
					<cfinvokeargument name="keys" value="RHCPid"/> 
					<cfinvokeargument name="showEmptyListMsg" value="true"/>						
					<cfinvokeargument name="maxrows" value="10"/>
					<cfinvokeargument name="showlink" value="false"/>
				</cfinvoke>
			</td>
		</tr>
	</table>
</form>
<!---*******************************--->
<!--- Lista de script               --->
<!---*******************************--->
<cf_qforms>
<script language="javascript" type="text/javascript">
	function deshabilitar(){
			objForm.DEidentificacion.required = false;
	}
	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description="Concursante";	

	function eliminar(llave){
		if (confirm('¿Desea eliminar el participante?')){
			document.form1.RHCPid.value = llave;
			document.form1.BORRAR.value = 'BORRAR';
			document.form1.submit();
		}else{
			return false;
		}
	}
	function Expendiente(llave){
		var PARAM  = "Expediente_concursante.cfm?DEid="+ llave
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}
	function Submit(){
		document.form1.submit();
	}
	
	function NuevoOferente(valor){
		document.form1.action='/cfmx/rh/Reclutamiento/catalogos/OferenteExterno.cfm?sel=1&modo=ALTA&RegCon=true&RHCconcurso=' + valor;
		document.form1.submit();
	}
</script>

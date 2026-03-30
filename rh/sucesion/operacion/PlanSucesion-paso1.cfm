<!---*******************************--->
<!---  inicialización de variables  --->
<!---*******************************--->
<cfif isdefined("form.TIENE") and len(trim(form.TIENE)) gt 0 >
	<cfif form.TIENE eq "N">
		<cfset  modo = 'ALTA' >
	<cfelse>
		<cfset  modo = 'CAMBIO' >
	</cfif>
<cfelse>	
	<cfset  modo = 'CAMBIO' >
</cfif>
<!---*******************************--->
<!---  área de consultas            --->
<!---*******************************--->
<cfquery name="rsPuesto" datasource="#session.DSN#">
	select  coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext,RHPcodigo , RHPdescpuesto   from RHPuestos  
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>

<cfquery name="rsHabilidades" datasource="#session.DSN#">
	select  RHHcodigo,b.RHHdescripcion as habilidad from RHHabilidadesPuesto  a
	inner join RHHabilidades  b
		on a.RHHid  = b.RHHid	
		 and  a.Ecodigo = b.Ecodigo	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>

<cfif modo neq "ALTA">
	<cfquery name="RSPlanSucesion" datasource="#session.DSN#">
		select RHPcodigo,PSporcreq,ts_rversion 
		from RHPlanSucesion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	</cfquery>
</cfif>

<!---*******************************--->
<!--- Información del Concurso      --->
<!---*******************************--->
	<table  width="75%"  align="center"border="0">
		<tr>
			<td width="20%" align="left" >C&oacute;d. Puesto:</td>
			<td width="80%"><strong><cfoutput>#rsPuesto.RHPcodigoext#</cfoutput></strong>&nbsp;<cfif modo neq "ALTA"><a  href="javascript: informacion('<cfoutput>#trim(rsPuesto.RHPcodigo)#</cfoutput>');" ><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></a></cfif></td>
		</tr>
		<tr>
			<td align="left">Descripci&oacute;n:</td>
			<td><strong><cfoutput>#rsPuesto.RHPdescpuesto#</cfoutput></strong></td>
		</tr>
	</table>
<!---*******************************--->
<!--- aréa de pintado               --->
<!---*******************************--->
<form action="<cfoutput>#CurrentPage#</cfoutput>" method="post" name="form1" >
 	<input type="hidden" name="paso"     	value="<cfoutput>#Gpaso#</cfoutput>">
	<input type="hidden" name="modo"     	value="<cfif isdefined("modo")and (modo GT 0)><cfoutput>#modo#</cfoutput></cfif>">
	<input type="hidden" name="RHPcodigo"  	value="<cfif isdefined("rsPuesto.RHPcodigo")and (rsPuesto.RHPcodigo GT 0)><cfoutput>#rsPuesto.RHPcodigo#</cfoutput></cfif>">
	<cfif modo neq "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#RSPlanSucesion.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
	</cfif>
	<table width="100%" border="0">
		<tr>
			<td width="12%">&nbsp;</td>
			<td width="20%">Porcentaje Requerido</td>
			<td width="57%">
				<input type="text"
				SIZE="6" 
				MAXLENGTH="6"
				name="PSporcreq" 
				id="PSporcreq"
				VALUE="<cfif modo neq "ALTA"><cfoutput>#LSNumberFormat(RSPlanSucesion.PSporcreq,',9')#</cfoutput><cfelse>0.00</cfif>" 
				onBlur="javascript: fm(this,2);"  
				onFocus="javascript:this.value=qf(this); this.select();"
				ONKEYUP="if(snumber(this,event,2)){ if(Key(event)=='13') {}}"
				>&nbsp;%
			</td>
			<td width="11%">&nbsp;</td>
		</tr>
	</table>
<!---*******************************--->
<!--- area del botones              --->
<!---*******************************--->
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
				<input type="submit" name="Anterior" value="<< Anterior" 	onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
				<input type="submit" name="Siguiente" value="Siguiente >>" 	onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0"> 
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
			objForm.PSporcreq.required = false;
	}
	objForm.PSporcreq.required = true;
	objForm.PSporcreq.description="Porcentaje";	
	function Submit(){
		document.form1.submit();
	}
	function informacion(llave){
		var PARAM  = "../consultas/PlanSucesion-ConsultaPlanIMP.cfm?RHPcodigo="+ llave
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}

	
</script>

<cfset modo = 'ALTA'>
<cfif  isdefined("form.DEid") and isdefined("form.Mcodigo")>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA'>
		<cfquery datasource="#session.dsn#" name="data">
			select em.DEid, 
				   em.Mcodigo,
				   em.RHEinicio,
				   em.RHEfinal,
				   em.RHEnota, 
				   {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as DEnombre,
				   m.Msiglas,
				   m.Mnombre,
				   em.ts_rversion
			from RHEmpleadoMateria em
			
			inner join DatosEmpleado de
			on em.Ecodigo=de.Ecodigo
			and em.DEid=de.DEid
			
			inner join RHMateria m
			on em.Mcodigo=m.Mcodigo
			and em.Ecodigo=m.Ecodigo
			
			where em.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and em.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and em.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		</cfquery>
</cfif>

<cfquery name="materia" datasource="#session.DSN#">
	select Mcodigo, Msiglas, Mnombre
	from RHMateria
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Mactivo = 1
</cfquery>

<cfoutput>

<script type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script> 
<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: RHEmpleadoMateria - RHEmpleadoMateria
			
		// Columna: DEid ID de Empleado numeric
		if (formulario.DEid.value == "") {
			error_msg += "\n - El campo Empleado no puede quedar en blanco.";
			error_input = formulario.DEid;
		}
	
		// Columna: Mcodigo Mcodigo numeric
		if (formulario.Mcodigo.value == "") {
			error_msg += "\n - El campo Materia no puede quedar en blanco.";
			error_input = formulario.Mcodigo;
		}
	
		// Columna: RHEinicio Fecha inicio datetime
		if (formulario.RHEinicio.value == "") {
			error_msg += "\n - El campo Fecha inicio no puede quedar en blanco.";
			error_input = formulario.RHEinicio;
		}
					
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Se presentaron los siguientes errores:" + error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->

	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisRHMaterias() {
		var params ="";
		if ( document.form1.DEid.value != '' ){
			params = '?DEid=' + document.form1.DEid.value;
		}
		popUpWindow("/cfmx/rh/capacitaciondes/catalogos/conlisRHMaterias.cfm"+params,250,200,650,400);
	}

</script>


<form action="RHEmpleadoMateria-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td  align="right" valign="middle">Materia:&nbsp;</td>
			<td nowrap >
				<cfif modo neq 'ALTA'>
					#data.Msiglas# - #data.Mnombre#
					<input type="hidden" name="Mcodigo" value="#data.Mcodigo#">
				<cfelse>
					<table width="1%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="1%">
								<input type="hidden" name="Mcodigo" value="" >
							</td>
							<td width="1%">
								<input type="text" name="Mnombre" id="Mnombre" disabled value="" size="50" maxlength="80" tabindex="1">
							</td>
							<TD width="1%"><a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Materias" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisRHMaterias();'></a></TD>
						</tr>
					</table>
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td  align="right" valign="middle">Fecha inicio:&nbsp;</td>
			<td >		
				<cfif modo neq 'ALTA'>
					<cf_sifcalendario form="form1" name="RHEinicio" value="#DateFormat(data.RHEinicio,'dd/mm/yyyy')#">
				<cfelse>
					<cf_sifcalendario form="form1" name="RHEinicio" value="">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td  align="right" valign="middle">Fecha final:&nbsp;</td>
			<td >
				<cfif modo neq 'ALTA'>
					<cf_sifcalendario form="form1" name="RHEfinal" value="#DateFormat(data.RHEfinal,'dd/mm/yyyy')#">
				<cfelse>
					<cf_sifcalendario form="form1" name="RHEfinal" value="">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td  align="right" valign="middle">Nota:&nbsp;</td>
			<td >
				<input type="text" name="RHEnota" size="6" id="RHEnota"  value="<cfif modo NEQ 'ALTA' and len(trim(data.RHEnota))>#LSCurrencyFormat(data.RHEnota, 'none')#<cfelse>0.00</cfif>" tabindex="1" size="7" maxlength="7" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
			</td>
		</tr>
	
		<tr>
			<td colspan="2" class="formButtons">
				<cfif modo neq 'ALTA' >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>

	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	
	<input type="hidden" name="DEid" value="#form.DEid#">
	
</form>

</cfoutput>
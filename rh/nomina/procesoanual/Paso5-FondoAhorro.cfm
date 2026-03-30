<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//función que valida antes de Aplicar
	function funcAplicar() {
		if (confirm('¿Est\u00e1 seguro que desea Aplicar esta Relaci\u00f3n de C\u00e1lculo de N\u00f3mina de FOA?'))
			return true;
		return false;
	}
</script>


<cfif isdefined("Form.RCNid") and len(trim(Form.RCNid)) EQ 0>
	<cfif isdefined("url.RCNid") and len(trim(url.RCNid)) GT 0>
    	<cfset RCNid = trim(url.RCNid)>
    </cfif>
</cfif>

<cfif isdefined('url.RHCFOAid') and len(trim(url.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #url.RHCFOAid#>
<cfelseif isdefined('form.RHCFOAid') and len(trim(form.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #form.RHCFOAid#>
</cfif>


<cfquery name="rsRelacionCalculo" datasource="#Session.DSN#">
	select 	a.RCNid, 
		   	rtrim(a.Tcodigo) as Tcodigo, 
		   	a.RCDescripcion, 
		   	a.RCdesde, 
		  	a.RChasta,
		   (case a.RCestado 
				when 0 then 'Proceso'
				when 1 then 'Cálculo'
				when 2 then 'Terminado'
				when 3 then 'Pagado'
				else ''
		   end) as RCestado,
		   a.Usucodigo, 
		   a.Ulocalizacion, 
		   a.ts_rversion,
		   b.Tdescripcion,
		   b.Mcodigo,
		   c.CPcodigo,
			case when c.CPtipo = 0 then 'Normal'
			when c.CPtipo = 2 then 'Anticipo'
			when c.CPtipo = 3 then 'Retroactivo'
            when c.CPtipo = 4 then 'PTU'
            when c.CPtipo = 5 then 'FOA' end as TipoCalendario,
			c.CPnodeducciones
	from RCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#">
	and a.Ecodigo = b.Ecodigo
	and a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
</cfquery>
    
<form action="Paso5-FondoAhorro-sql.cfm" method="post" name="form5">
	<input type="hidden" name="RCNid" value="<cfoutput>#RCNid#</cfoutput>">
    <input type="hidden" name="RHCFOAid" value="<cfoutput>#RHCFOAid#</cfoutput>">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height="20px">
			<td nowrap class="fileLabel" colspan="2">
				
			</td>
		</tr>
		<tr>
			<td nowrap class="fileLabel" colspan="2" align="center">
				Seleccione la Cuenta Cliente a Debitar para el pago de la N&oacute;mina
			</td>
		</tr>
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<!--- Cuenta Cliente --->
		<tr>
			<td nowrap class="fileLabel" align="right" width="20%">
				Cuenta Cliente:&nbsp;
			</td>
			<td nowrap width="80%">
				<cf_sifCuentaCliente tabindex="1" vMcodigo="#rsRelacionCalculo.Mcodigo#" form="form5">
			</td>
		</tr>
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr>
        <td nowrap align="center" colspan="2">
			<input type="submit" name="butAplicar" id="butAplicar" value="Aplicar" onClick="javascript: return funcAplicar();">
		</td></tr>
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
	</table>
	<!---<input type="hidden" name="RCNid" value="<cfoutput>#Form.RCNid#</cfoutput>">--->
    <input type="hidden" name="tab" value="5">
</form>
<script language="JavaScript" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form5");
	//Funciones adicionales de validación
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
		if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
		this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
		}
	}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	//Validaciones del Encabezado
	objForm.CBcc.required = true;
	objForm.CBcc.description = "Cuenta Cliente";
	objForm.CBcc.validateAlfaNumerico();
	objForm.CBcc.validate = true;
	objForm.CBcc.obj.focus();
</script>
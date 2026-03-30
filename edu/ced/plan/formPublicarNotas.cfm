
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("Form.Periodo") and isdefined("Form.SubPeriodo")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>
<cfif isdefined("Form.btnNuevo") >
	<cfset modo="ALTA">
</cfif>
<cfif isdefined("Url.SPEfechainicio") and not isdefined("form.SPEfechainicio")>
	<cfset form.SPEfechainicio = Url.SPEfechainicio>
</cfif>
<cfif isdefined("Url.SPEfechafin") and not isdefined("form.SPEfechafin")>
	<cfset form.SPEfechafin = Url.SPEfechafin>
</cfif>


<!--- Consultas --->
<cfif modo EQ "ALTA">
	<cfquery datasource="#Session.Edu.DSN#" name="rsPeriodoEscolar">	
			select convert(varchar,b.PEcodigo) as PEcodigo, rtrim(c.Ndescripcion) + ' : ' + rtrim(b.PEdescripcion) as PEdescripcion
			from PeriodoEscolar b, Nivel c 
			where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
			  and b.Ncodigo = c.Ncodigo
	</cfquery>
</cfif>

<cfif modo NEQ "ALTA">
	<!--- 1. Form Encabezado --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsPublicarNotas">
		select convert(varchar,PNcodigo) as PNcodigo, SPEcodigo, PEcodigo ,PNestado, convert(varchar,PNfechaInicio,103) as PNfechaInicio,
		convert(varchar,PNfechaFin,103)  as PNfechaFin
		from PublicacionNotas
		where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Periodo#">
		  and SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SubPeriodo#">
	</cfquery>
</cfif>

<link href="../../css/estilos.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" src="../../js/calendar.js"></script>
	<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function irALista() {
		location.href = "listaPublicarNotas.cfm";
	}
	function cambioMod(obj){
		var fecha1= document.getElementById("fecIni");
		var fecha2= document.getElementById("lbl_fecIni");
		
		var date1= document.getElementById("fecFin");
		var date2= document.getElementById("lbl_fecFin");
				
		if(obj[1].checked){
			objForm.PNfechaInicio.required = true;
			objForm.PNfechaInicio.description = "Fecha inicio";
			objForm.PNfechaFin.required = true;
			objForm.PNfechaFin.description = "Fecha fin";
			fecha1.style.display = "";
			fecha2.style.display = "";
			date1.style.display = "";
			date2.style.display = "";
			//objForm.PNestado.value = '1';
		}else 
		{
			objForm.PNfechaInicio.required = false;
			objForm.PNfechaFin.required = false;
			fecha1.style.display = "none";
			fecha2.style.display = "none";
			date1.style.display = "none";
			date2.style.display = "none";
			//objForm.PNestado.value = '0'
		}
	}
</script>
<form name="form1" method="post" action="SQLPublicarNotas.cfm">
	<cfif modo NEQ "ALTA">
		<input name="SPEcodigo" id="SPEcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#Form.SubPeriodo#</cfoutput></cfif>" type="hidden">
		<input name="PEcodigo" id="PEcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#Form.Periodo#</cfoutput></cfif>" type="hidden">
		<input name="SPEfechainicio" id="SPEfechainicio" value="<cfoutput>#Form.SPEfechainicio#</cfoutput>" type="hidden">
		<input name="SPEfechafin" id="SPEfechafin" value="<cfoutput>#Form.SPEfechafin#</cfoutput>" type="hidden">
	</cfif>
 <cfif isdefined("form.SubPeriodo")>
	  
    <fieldset>
    <legend>Opciones:</legend>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td align="right">&nbsp;</td>
        <td width="18%" align="right">&nbsp;</td>
        <td width="2%" align="right"> <input type="radio" onClick="javascript: cambioMod(document.form1.PNestado)" name="PNestado" value="0"  <cfif isdefined("form.SubPeriodo") and #rsPublicarNotas.RecordCount# NEQ 0 and #rsPublicarNotas.PNestado# EQ 0>checked</cfif>> 
        </td>
        <td width="24%" align="left">Se publicar&aacute;n siempre </td>
        <td width="2%" align="right"> <input type="radio"  onClick="javascript: cambioMod(document.form1.PNestado)" name="PNestado" value="1" <cfif isdefined("form.SubPeriodo") and #rsPublicarNotas.RecordCount# NEQ 0 and #rsPublicarNotas.PNestado# EQ 1>checked</cfif>> 
        </td>
        <td width="41%" nowrap>No se publicar&aacute;n en el siguiente rango de 
          fechas</td>
        <td width="13%">&nbsp;</td>
      </tr>
      <tr> 
        <td align="right">&nbsp;</td>
        <td nowrap>&nbsp;</td>
        <td height="22" align="right" nowrap><div id="lbl_fecIni"></div></td>
        <td align="left" nowrap> <div id="fecIni"> Fecha Inicio: 
            <input name="PNfechaInicio"  tabindex="1" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsPublicarNotas.PNfechaInicio#</cfoutput></cfif>" size="12" maxlength="10" >
            <a href="#"><img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.form1.PNfechaInicio');"></a> 
          </div></td>
        <td align="right" nowrap><div id="lbl_fecFin"> </div></td>
        <td align="left" nowrap><div id="fecFin"> Fecha Fin: 
            <input name="PNfechaFin"  tabindex="1"  onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsPublicarNotas.PNfechaFin#</cfoutput></cfif>" size="12" maxlength="10" >
            <a href="#"><img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.form1.PNfechaFin');"></a></div></td>
        <td>&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="7" align="center"> <input name="Cambio" type="submit" id="Cambio" value="Aceptar Cambios" onClick="javascript: setBtn(this);"></td>
      </tr>
      <tr> 
        <td colspan="7" align="center">&nbsp; </td>
      </tr>
    </table>
    </fieldset>
	</cfif>
  	<cfinvoke 
		 component="edu.Componentes.pListas"
		 method="pListaEdu"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="tabla" value="SubPeriodoEscolar a, PeriodoEscolar b, Nivel c, PeriodoVigente d, PublicacionNotas e"/>
			<cfinvokeargument name="columnas" value="convert(varchar,a.PEcodigo) as Periodo, convert(varchar,a.SPEcodigo) as SubPeriodo, a.SPEorden, 
													substring(a.SPEdescripcion,1,50)  as SPEdescripcion, 
													convert(varchar,a.SPEfechafin,103) as SPEfechafin  ,
													case when PNestado = 0 then ''  else convert(varchar,e.PNfechaFin,103) end as PNfechaFin,
													convert(varchar,a.SPEfechainicio,103)  as SPEfechainicio, 
													case when PNestado = 0 then ''  else convert(varchar,e.PNfechaInicio,103) end as PNfechaInicio,
													case when PNestado = 0 then 'siempre' else 'no publicar' end as publica, 
												    c.Ndescripcion + ' : ' + b.PEdescripcion as PEdescripcion, case when d.PEevaluacion is not null then 'Vigente' else '' end as Vigente"/>
			<cfinvokeargument name="desplegar" value="SPEdescripcion,  SPEfechainicio, SPEfechafin, publica, PNfechaInicio, PNfechaFin "/>
			<cfinvokeargument name="etiquetas" value="Nombre del Curso Lectivo, Inicio de Periodo, Término de Periodo, Publicar Notas, desde, hasta"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value=" c.CEcodigo = #Session.Edu.CEcodigo# and a.PEcodigo = b.PEcodigo and b.Ncodigo = c.Ncodigo 
												and b.Ncodigo = d.Ncodigo and a.PEcodigo = d.PEcodigo and a.SPEcodigo = d.SPEcodigo 
												and a.PEcodigo = e.PEcodigo 
												and a.SPEcodigo = e.SPEcodigo 
												order by c.Norden, b.PEorden, a.SPEorden"/>
			<cfinvokeargument name="align" value="left,left,left,left,left,left"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
			<cfinvokeargument name="irA" value="PublicarNotas.cfm"/>
			<!--- <cfinvokeargument name="cortes" value="PEdescripcion"/> --->
			<cfinvokeargument name="incluyeForm" value="false"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
</form>

<script language="JavaScript" type="text/JavaScript">
	// Se aplica la descripcion del Concepto 
	function __isFueraPeriodo() {
		
		var a = this.obj.form.PNfechaInicio.value.split("/");
		var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
	   	var b = this.obj.form.PNfechaFin.value.split("/");
	   	var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
	   
	   	var c = this.obj.form.SPEfechainicio.value.split("/");
		var SPEini = new Date(parseInt(c[2], 10), parseInt(c[1], 10)-1, parseInt(c[0], 10));
	   	var d = this.obj.form.SPEfechafin.value.split("/");
	   	var SPEfin = new Date(parseInt(d[2], 10), parseInt(d[1], 10)-1, parseInt(d[0], 10));
		var dif_ini = ((ini-SPEini)/86400000.0); // diferencia en días

		var msg = "";	   
	   	if (new Number(ini) > new Number(fin) ) {
			msg = msg + "la fecha inicial es mayor que la fecha final"
		}	

		if (new Number(dif_ini) < 0) {
			if (msg != "")
			{
				msg = msg + ", ";
			}
			msg = msg + "la fecha inicial esta fuera del periodo"
		}
		var dif_fin = ((fin-SPEfin)/86400000.0); // diferencia en días
		if (new Number(dif_fin) > 0) {
			if (msg != "")
			{
				msg = msg + ", ";
			}
			msg = msg + " la fecha final esta fuera del periodo"
		}
		// Valida que el Concepto no tenga dependencias con otros.
	
		if (msg != "")
		{
			this.error = "No puede agregar las fechas porque: " + msg + ".";
			this.obj.form.PNfechaInicio.focus();
		}
	}
	

	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isFueraPeriodo", __isFueraPeriodo);
	objForm = new qForm("form1");
	<cfif modo EQ "CAMBIO">
		cambioMod(document.form1.PNestado);
		objForm.PNfechaInicio.validateFueraPeriodo();
	</cfif>
	
</script>
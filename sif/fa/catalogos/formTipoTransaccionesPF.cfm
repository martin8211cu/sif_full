<cfset modo = 'ALTA' >
<cfif isdefined("form.PFTcodigo") and len(trim(form.PFTcodigo))>
	<cfset modo = 'CAMBIO' >
</cfif>

<!--- Las transacciones Bancarias no se usan para PF
<cfquery name="rsTransaccionesBancarias" datasource="#Session.DSN#">
	select convert(varchar, BTid) as BTid, BTdescripcion
	from BTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and BTid not in (select convert(numeric, Pvalor)
	  				   from Parametros b
					   where b.Ecodigo = #Session.Ecodigo#
					     and b.Pcodigo between 160 and 170)
</cfquery>
ABG --->

<cfif modo NEQ "ALTA"> <!--- COMIENZA MODO CAMBIO ABG --->
	<cfquery name="rsTipoTransacciones" datasource="#Session.DSN#">
		select PFTcodigo, PFTdescripcion, PFTtipo, FMT01COD, ts_rversion, PFTcodigoext,CCTcodigoRef,CCTcodigoCan,CCTcodigoEst,
				PFTcodigoRef, isnull(esContado,0) esContado
        from FAPFTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and PFTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.PFTcodigo#" >
		order by PFTcodigo asc
	</cfquery>
</cfif>

<cfquery name="rsFormatos" datasource="#Session.DSN#">
	select FMT01COD, FMT01DES from FMT001
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    or Ecodigo is null
	order by FMT01COD
</cfquery>

<!--- Consulta de etiquetas para pintar títulos en el reporte --->
<!--- Verificar para que sirve esta parte
<cfquery name="rsEtiquetas" datasource="#session.dsn#">
	select CCTcolrpttranapl, CCTcolrpttranapldesc
	from CCTrpttranapl
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>
--->
<cf_templatecss>
<script language="JavaScript" type="text/javascript">
</script>

<form action="SQLTipoTransaccionesPF.cfm" method="post" name="form1" onSubmit="javascript: document.form1.PFTcodigo.disabled = false; return true;" >
	<cfoutput>
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	</cfoutput>
  <table width="100%" align="center">
    <tr>
      <td width="50%" align="right" valign="middle" nowrap> C&oacute;digo:&nbsp;</td>
      <td>
        <input  name="PFTcodigo" type="text" tabindex="1" <cfif modo neq 'ALTA'>disabled</cfif> value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsTipoTransacciones.PFTcodigo)#</cfoutput></cfif>" size="5" maxlength="2" alt="El campo Código del Tipo de Transacción">
        <div align="right"></div>
      </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap>Descripci&oacute;n:&nbsp;</td>
      <td>
        <input name="PFTdescripcion" type="text" tabindex="2" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsTipoTransacciones.PFTdescripcion)#</cfoutput></cfif>" size="50" maxlength="80"  alt="El campo Descripción del Tipo de Transacción">
      </td>
    </tr>
	<tr>
	  	<td align="right" valign="middle" nowrap>C&oacute;digo Externo:&nbsp;</td>
		<td nowrap>
			<input tabindex="3" name="PFTcodigoext" type="text" size="30"  maxlength="25" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsTipoTransacciones.PFTcodigoext)#</cfoutput></cfif>" >
		</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>Transacci&oacute;n de Contado:&nbsp;</td>
		<td>
			<input type="checkbox" name="esContado" id="esContado" value="esContado" <cfif isdefined("rsTipoTransacciones") and rsTipoTransacciones.esContado neq 0> checked </cfif> >
		</td>
	</tr>
    <tr>
      <td align="right" valign="middle" nowrap>Tipo:&nbsp;</td>
      <td>
        <select name="PFTtipo" onChange="javascript:chngtextREF(this);" tabindex="4" >
          <option value="D" <cfif (isDefined("rsTipoTransacciones.PFTtipo") AND "D" EQ rsTipoTransacciones.PFTtipo)>selected</cfif>>Débito</option>
          <option value="C" <cfif (isDefined("rsTipoTransacciones.PFTtipo") AND "C" EQ rsTipoTransacciones.PFTtipo)>selected</cfif>>Crédito</option>
        </select>
      </td>
    </tr>

    <tr>
      <td nowrap align="right">Formato de Impresi&oacute;n:&nbsp;</td>
      <td nowrap>
	  	<select name="FMT01COD" tabindex="5" >
		<option value="">-- seleccionar formato--</option>
		<cfoutput>
		<cfloop query="rsFormatos">
			<option value="#rsFormatos.FMT01COD#" <cfif modo neq "ALTA" and Trim(rsTipoTransacciones.FMT01COD) eq Trim(rsFormatos.FMT01COD)>selected</cfif> >#rsFormatos.FMT01DES#</option>
		</cfloop>
		</cfoutput>
		</select>
      </td>
    </tr>

	<tr>
		<td align="right">
			Transacci&oacute;n para Aplicaci&oacute;n
		</td>
		<td>
			<cfset ArrayTrREF=ArrayNew(1)>
			<cfif isdefined("rsTipoTransacciones.CCTcodigoRef") and len(trim(rsTipoTransacciones.CCTcodigoRef))>
				<cfquery name="rsTrREF" datasource="#session.dsn#">
				  select CCTcodigo as CCTcodigoRef,CCTdescripcion as CCTdescripcionRef
				  from CCTransacciones
				  where Ecodigo = #Session.Ecodigo#
				  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoTransacciones.CCTcodigoRef#" >
                  and CCTestimacion = 0
				  and CCTtranneteo = 0
				  and CCTpago = 0
				</cfquery>

				<cfset ArrayAppend(ArrayTrREF,rsTrREF.CCTcodigoRef)>
				<cfset ArrayAppend(ArrayTrREF,rsTrREF.CCTdescripcionRef)>
			</cfif>
				<cf_conlis
				Campos="CCTcodigoRef,CCTdescripcionRef"
				Desplegables="S,S"
				Modificables="S,N"
				Size="2,43"
				tabindex="6"
				ValuesArray="#ArrayTrREF#"
				Title="Lista de tipos de transacciones referenciadas"
				Tabla="CCTransacciones "
				Columnas="CCTcodigo as CCTcodigoRef,CCTdescripcion as CCTdescripcionRef"
				Filtro=" Ecodigo = #Session.Ecodigo# and  CCTtipo = $PFTtipo,char$ and CCTestimacion = 0 and CCTtranneteo = 0 and CCTpago = 0"
				Desplegar="CCTcodigoRef,CCTdescripcionRef"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CCTcodigo,CCTdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="CCTcodigoRef,CCTdescripcionRef"
				Asignarformatos="S,S"/>
		</td>
    </tr>

	<tr>
		<td align="right">
			Transacci&oacute;n para Cancelaci&oacute;n
		</td>
		<td>
			<cfset ArrayTrCAN=ArrayNew(1)>
			<cfif isdefined("rsTipoTransacciones.CCTcodigoCan") and len(trim(rsTipoTransacciones.CCTcodigoCan))>
				<cfquery name="rsTrCAN" datasource="#session.dsn#">
				  select CCTcodigo as CCTcodigoCan,CCTdescripcion as CCTdescripcionCan
				  from CCTransacciones
				  where Ecodigo = #Session.Ecodigo#
				  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoTransacciones.CCTcodigoCan#" >
                  and CCTestimacion = 0
			      and CCTtranneteo = 0
  				  and CCTpago = 0
				</cfquery>

				<cfset ArrayAppend(ArrayTrCAN,rsTrCAN.CCTcodigoCan)>
				<cfset ArrayAppend(ArrayTrCAN,rsTrCAN.CCTdescripcionCan)>
			</cfif>
				<cf_conlis
				Campos="CCTcodigoCan,CCTdescripcionCan"
				Desplegables="S,S"
				Modificables="S,N"
				Size="2,43"
				tabindex="7"
				ValuesArray="#ArrayTrCAN#"
				Title="Lista de tipos de transacciones de Cancelación"
				Tabla="CCTransacciones"
				Columnas="CCTcodigo as CCTcodigoCan,CCTdescripcion as CCTdescripcionCan"
				Filtro=" Ecodigo = #Session.Ecodigo# and  CCTtipo != $PFTtipo,char$ and CCTestimacion = 0 and CCTtranneteo = 0 and CCTpago = 0"
				Desplegar="CCTcodigoCan,CCTdescripcionCan"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CCTcodigo,CCTdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="CCTcodigoCan,CCTdescripcionCan"
				Asignarformatos="S,S"/>
		</td>
    </tr>

<tr>
		<td align="right">
			Transacci&oacute;n para Estimaci&oacute;n
		</td>
		<td>
			<cfset ArrayTrEst=ArrayNew(1)>
			<cfif isdefined("rsTipoTransacciones.CCTcodigoEst") and len(trim(rsTipoTransacciones.CCTcodigoEst))>
				<cfquery name="rsTrEst" datasource="#session.dsn#">
				  select CCTcodigo as CCTcodigoEst,CCTdescripcion as CCTdescripcionEst
				  from CCTransacciones
				  where Ecodigo = #Session.Ecodigo#
				  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoTransacciones.CCTcodigoEst#" >
				</cfquery>

				<cfset ArrayAppend(ArrayTrEst,rsTrEst.CCTcodigoEst)>
				<cfset ArrayAppend(ArrayTrEst,rsTrEst.CCTdescripcionEst)>
			</cfif>
				<cf_conlis
				Campos="CCTcodigoEst,CCTdescripcionEst"
				Desplegables="S,S"
				Modificables="S,N"
				Size="2,43"
				tabindex="8"
				ValuesArray="#ArrayTrEst#"
				Title="Lista de tipos de transacciones de Estimación"
				Tabla="CCTransacciones"
				Columnas="CCTcodigo as CCTcodigoEst,CCTdescripcion as CCTdescripcionEst"
				Filtro=" Ecodigo = #Session.Ecodigo# and  CCTtipo = $PFTtipo,char$ and CCTestimacion = 1 and CCTtranneteo = 0 and CCTpago = 0"
				Desplegar="CCTcodigoEst,CCTdescripcionEst"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CCTcodigo,CCTdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="CCTcodigoEst,CCTdescripcionEst"
				Asignarformatos="S,S"/>
		</td>
    </tr>

    <tr id="PFref" <cfif (modo NEQ 'ALTA' AND rsTipoTransacciones.PFTtipo EQ 'C')> style="display:none" </cfif>>
		<td align="right">
			Transacci&oacute;n Pre-Factura referenciada
		</td>
		<td>
			<cfset ArrayPFREF=ArrayNew(1)>
			<cfif isdefined("rsTipoTransacciones.PFTcodigoRef") and len(trim(rsTipoTransacciones.PFTcodigoRef))>
				<cfquery name="rsPFREF" datasource="#session.dsn#">
				  select PFTcodigo as PFTcodigoRef,PFTdescripcion as PFTdescripcionRef
				  from FAPFTransacciones
				  where Ecodigo = #Session.Ecodigo#
				  and PFTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoTransacciones.PFTcodigoRef#" >
				</cfquery>

				<cfset ArrayAppend(ArrayPFREF,rsPFREF.PFTcodigoRef)>
				<cfset ArrayAppend(ArrayPFREF,rsPFREF.PFTdescripcionRef)>
			</cfif>
				<cf_conlis
				Campos="PFTcodigoRef,PFTdescripcionRef"
				Desplegables="S,S"
				Modificables="S,N"
				Size="2,43"
				tabindex="9"
				ValuesArray="#ArrayPFREF#"
				Title="Lista de tipos de transacciones referenciadas"
				Tabla="FAPFTransacciones "
				Columnas="PFTcodigo as PFTcodigoRef,PFTdescripcion as PFTdescripcionRef"
				Filtro=" Ecodigo = #Session.Ecodigo# and  PFTtipo != $PFTtipo,char$ and not exists (select 1 from FAPFTransacciones b where b.Ecodigo = #Session.Ecodigo# and b.PFTcodigoRef = FAPFTransacciones.PFTcodigo)"
				Desplegar="PFTcodigoRef,PFTdescripcionRef"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="PFTcodigo,PFTdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="PFTcodigoRef,PFTdescripcionRef"
				Asignarformatos="S,S"/>
		</td>
    </tr>
 </div>
    <tr>
      <td colspan="2" nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center" nowrap>
		<!--- <cfset tabindex = 2 >
        <cfinclude template="../../portlets/pBotones.cfm"> --->
		<cf_botones modo="#modo#" tabindex="10">
      </td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsTipoTransacciones.ts_rversion#"/>
	</cfinvoke>
</cfif>
  <input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
 </form>

<cf_qforms form="form1" objForm="objForm">
<script language="JavaScript" type="text/javascript">
	function funcBaja()
	{
		if (!confirm('¿Desea Eliminar el Registro?') )
		{ return false;}
		else
		{ deshabilitarValidacion();
		  return true; }
	}

	function deshabilitarValidacion(){
		objForm.PFTcodigo.required = false;
		objForm.PFTdescripcion.required = false;
		objForm.CCTdescripcionRef.required = false;
		objForm.CCTdescripcionCan.required = false;
		objForm.CCTdescripcionEst.required = false;
		}

	function chngtextREF(f) {
		document.form1.CCTcodigoRef.value='';
		document.form1.CCTdescripcionRef.value='';
		document.form1.CCTcodigoCan.value='';
		document.form1.CCTdescripcionCan.value='';
		document.form1.CCTcodigoEst.value='';
		document.form1.CCTdescripcionEst.value='';

		if(f.value=="D"){
			document.getElementById("PFref").style.display = '';
			}
		else
			{
			document.getElementById("PFref").style.display = 'none';
			}
	}

	objForm.PFTcodigo.required = true;
	objForm.PFTcodigo.description = 'Código';

	objForm.PFTdescripcion.required = true;
	objForm.PFTdescripcion.description = 'Descripción';

	objForm.CCTdescripcionRef.required = true;
	objForm.CCTdescripcionRef.description = 'Transacción para Aplicación';

	objForm.CCTdescripcionCan.required = true;
	objForm.CCTdescripcionCan.description = 'Transacción para Cancelación';

	objForm.CCTdescripcionEst.required = true;
	objForm.CCTdescripcionEst.description = 'Transacción para Estimación';

	<cfif modo NEQ 'ALTA'>
		document.form1.PFTdescripcion.focus();
	<cfelse>
		document.form1.PFTcodigo.focus();
	</cfif>
</script>